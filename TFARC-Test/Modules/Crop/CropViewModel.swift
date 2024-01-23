import AVFoundationPlus
import CombinePlus
import Depin
import JatAppFoundation
import Networking
import UIKit
import XCoordinator

class CropViewModel {

    // MARK: - Injected properties

    @Injected private var factory: CropViewStateFactory
    @Injected private var analytics: UserAnalytics
    @Injected private var solveRepository: SolveProblemRepository
    @Injected private var reachability: Reachability
    @Injected private var userInfoProvider: UserInfoProvider

    private let router: StrongRouter<CameraRoute>
    private unowned let view: CropViewProtocol
    private let image: UIImage
    private let source: ImageSource

    // MARK: - Private properties

    private var bag = CancelBag()
    private var croppedImageData: Data?
    private var isReachable: Bool {
        reachability.isReachable
    }

    @Published private var userDidCropPhoto = false

    init(
        router: StrongRouter<CameraRoute>,
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

    private func recogniseProblem(with imageData: Data) {
        guard isReachable else {
            view.isLoading = false
            view.displayNoInternetConnection()
            analytics.collect(event: .mathSolvingNoInternetConnectionScreenShown)
            return
        }

        analytics.collect(event: .mathSolvingPhotoTaken(
            photoCropped: userDidCropPhoto,
            source: source
        ))
        view.isLoading = true

        solveRepository.solve(image: imageData)
            .onMain()
            .sink(
                onError: { [weak self] error in
                    guard let self else { return }
                    handleError(error)
                    logResultScreenAppearance(found: false, stepsCount: 0)
                },
                onValue: {  [weak self] solution in
                    guard let self else { return }
                    logResultScreenAppearance(found: true, stepsCount: (solution.steps ?? []).count)
                    router.trigger(.results(solution: solution))
                },
                onAnyCompetition: { [weak self] in
                    guard let self else { return }
                    view.isLoading = false
                    analytics.set(property: .totalMathSolvingRecognitions)
                }

            )
            .store(in: &bag)
    }

    private func bindOnLoad() {
        Publishers.Merge(view.backPublisher, view.cancelPublisher)
            .sink { [unowned self] in
                router.trigger(.pop)
            }
            .store(in: &bag)

        view.croppingPublisher
            .map { true }
            .assign(to: &$userDidCropPhoto)

        view.tryAgainActionPublisher
            .track { [unowned self] in
                analytics.collect(event: .mathSolvingTryAgainClicked)
            }
            .compactMap { [unowned self] in croppedImageData }
            .sink { [unowned self] imageData in
                view.hideNoInternetConnection {
                    self.recogniseProblem(with: imageData)
                }
            }
            .store(in: &bag)

        view.continueButtonPublisher
            .compactMap { $0.jpegData(compressionQuality: 1.0) }
            .sink { [unowned self] imageData in
                croppedImageData = imageData
                recogniseProblem(with: imageData)
            }
            .store(in: &bag)
    }

    private func handleError(_ error: APIError) {
        if case .forbiddenAction = error {
            router.trigger(.paywall)
        } else {
            view.displayPopUp(with: factory.makePopUpViewState(closeAction: returnToCamera))
        }
    }

    private func logResultScreenAppearance(found: Bool, stepsCount: Int) {
        userInfoProvider.resultsScreenWasShownCounter += 1

        analytics.set(property: .firstMathSolvingRecognitionSuccessful(found))
        analytics.collect(event: .mathSolvingResultsShown(
            found: found,
            enterCount: userInfoProvider.resultsScreenWasShownCounter,
            solvingStepsCount: stepsCount
        ))
    }

    private func returnToCamera() {
        view.hidePopUp()
        analytics.collect(event: .mathSolvingRetakePhotoButtonClicked)
        router.trigger(.pop)
    }
}
