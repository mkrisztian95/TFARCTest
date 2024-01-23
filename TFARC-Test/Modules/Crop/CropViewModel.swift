import AVFoundationPlus
import CombinePlus
import Depin
import UIKit
import XCoordinator

class CropViewModel {

    // MARK: - Injected properties

    @Injected private var factory: CropViewStateFactory

    private let router: StrongRouter<UserProfileRoute>
    private unowned let view: CropViewProtocol
    private let image: UIImage
    private let source: ImageSource

    // MARK: - Private properties

    private var bag = CancelBag()

    @Published private var userDidCropPhoto = false

    init(
        router: StrongRouter<UserProfileRoute>,
        view: CropViewProtocol,
        image: UIImage,
        source: ImageSource
    ) {
        self.router = router
        self.view = view
        self.image = image
        self.source = source

        bind()
    }

    private func bind() {

        view.viewIsAppearingPublisher
            .map { [unowned self] in
                factory.make(image: image, source: source)
            }
            .sink { [unowned self] in
                view.apply($0)
            }
            .store(in: &bag)

        view.viewDidLoadPublisher
            .sink { [unowned self] in
                bindOnLoad()
            }
            .store(in: &bag)
    }

    private func bindOnLoad() {
        Publishers.Merge(view.backPublisher, view.cancelPublisher)
            .sink { [unowned self] in
                router.trigger(.pop)
            }
            .store(in: &bag)

        view.continueButtonPublisher
            .sink { [unowned self] image in
                router.trigger(.popToEditor(image))
            }
            .store(in: &bag)
    }
}
