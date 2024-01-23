import AVFoundationPlus
import CombinePlus
import Depin
import UIKit
import XCoordinator

class CameraViewModel {

    // MARK: - Injected properties

    private unowned let view: CameraViewProtocol
    private let router: StrongRouter<UserProfileRoute>

    @Injected private var cameraService: CameraSessionService
    @Injected private var factory: CameraViewStateFactory

    // MARK: - Private Properties

    private var bag = CancelBag()
    private var isFlashEnabled = false

    init(
        router: StrongRouter<UserProfileRoute>,
        view: CameraViewProtocol
    ) {
        self.router = router
        self.view = view

        cameraService.isPhotoOutputAvailable = true
        cameraService.setupSession()
        bind()
    }
}

// MARK: - Private Methods

private extension CameraViewModel {

    func bind() {
        view.viewWillAppearPublisher
            .sink { [unowned self] in
                view.setup(with: cameraService.session)
            }
            .store(in: &bag)

        view.viewDidLoadPublisher
            .sink { [unowned self] in
                viewDidLoad()
            }
            .store(in: &bag)

        view.viewDidAppearPublisher
            .sink { [unowned self] in
                viewDidAppear()
            }
            .store(in: &bag)
    }

    func bindCameraSessionPublishers() {
        cameraService.sessionSetupResultPublisher
            .map { $0 == .success }
            .onMain()
            .compactMap { [weak self] cameraEnabled in
                guard let self else { return nil }
                return factory.make(
                    isFlashEnabled: cameraService.flashMode == .on,
                    cameraEnabled: cameraEnabled
                )
            }
            .sink { [weak self] in
                self?.view.apply($0)
            }
            .store(in: &bag)
    }

    func bindViewPublishers() {
        view.flashTapPublisher
            .combineLatest(cameraService.sessionSetupResultPublisher.map { $0 == .success })
            .perform { [unowned self] _ in
                isFlashEnabled.toggle()
                cameraService.flashMode = isFlashEnabled ? .on : .off
            }
            .map { [unowned self] _, cameraEnabled in
                factory.make(
                    isFlashEnabled: cameraService.flashMode == .on,
                    cameraEnabled: cameraEnabled
                )
            }
            .sink { [unowned self] in
                view.apply($0)
            }
            .store(in: &bag)

        view.snapTapPublisher
            .combineLatest(cameraService.sessionSetupResultPublisher.map { $0 == .success }) { $1 }
            .filter { !$0 }
            .void()
            .sink { [unowned self] in
                view.displayPopUp(with: factory.makePopUpViewState(
                    with: openSettings,
                    and: hidePopUp
                ))
            }
            .store(in: &bag)

        let snapPublisher = view.snapTapPublisher
            .combineLatest(cameraService.sessionSetupResultPublisher.map { $0 == .success }) { $1 }
            .filter { $0 }
            .flatMap { [unowned self] _ in
                cameraService
                    .captureImage()
                    .ignoreFailure()
                    .eraseToAnyPublisher()
            }
            .map { (result: $0, source: ImageSource.camera) }

        let libraryTapPublisher = view.libraryTapPublisher
            .map { [unowned self] in
                view as UIViewController
            }
            .flatMap { [unowned self] in
                cameraService
                    .selectImageFromLibrary(from: $0)
                    .ignoreFailure()
                    .eraseToAnyPublisher()
            }
            .map { (result: $0, source: ImageSource.gallery) }

        snapPublisher
            .merge(with: libraryTapPublisher)
            .onMain()
            .sink { [unowned self] image, source in
                router.trigger(.crop(image: image, source: source))
            }
            .store(in: &bag)

        view.backTapPublisher
            .sink { [unowned self] in
                router.trigger(.pop)
            }
            .store(in: &bag)
    }

    func viewDidLoad() {
        bindViewPublishers()
        bindCameraSessionPublishers()
    }

    func viewDidAppear() {
        cameraService
            .sessionSetupResultPublisher
            .filter { [unowned self] in
                $0 == .notAuthorized && !cameraService.accessRequested
            }
            .onMain()
            .sink { [unowned self] _ in
                view.displayPopUp(with: factory.makePopUpViewState(
                    with: openSettings,
                    and: hidePopUp
                ))
                cameraService.accessRequested = true
            }
            .store(in: &bag)
    }

    func openSettings() {
        guard
            let url = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(url)
        else { return }

        UIApplication.shared.open(url)
    }

    func hidePopUp() {
        view.hidePopUp()
    }
}
