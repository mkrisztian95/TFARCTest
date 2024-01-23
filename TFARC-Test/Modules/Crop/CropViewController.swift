import AVKit
import CombinePlus
import Lottie
import UIKitPlus

protocol CropViewProtocol: BaseViewController {
    var backPublisher: AnyPublisher<Void, Never> { get }
    var cancelPublisher: AnyPublisher<Void, Never> { get }
    var croppingPublisher: AnyPublisher<Void, Never> { get }
    var continueButtonPublisher: AnyPublisher<UIImage, Never> { get }

    func apply(_ viewState: CropViewController.ViewState)
}

class CropViewController: BaseViewController {

    struct ViewState {
        let image: UIImage
        let cancelButtonTitle: String
        let continueButtonTitle: String
        let hintText: String
        let processingText: String
        let imageContentMode: UIView.ContentMode
    }

    // MARK: - Outlets

    @IBOutlet private var overlay: CameraFrameOverlay!
    @IBOutlet private var continueButton: PrimaryButton!
    @IBOutlet private var hintLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private var hintLabelLeadingConstraint: NSLayoutConstraint!

    @IBOutlet private var backButton: BackButton! {
        didSet {
            backButton.tintColor = .constantWhite
        }
    }

    @IBOutlet private var cancelButton: UIButton! {
        didSet {
            cancelButton.backgroundColor = .alphaConstantWhite20016
            cancelButton.titleLabel?.font = .titleSemiBold
            cancelButton.setTitleColor(.constantWhite, for: .normal)
        }
    }

    @IBOutlet private var hintLabel: UILabel! {
        didSet {
            hintLabel.textColor = .constantWhite
            hintLabel.font = .captionLBold
        }
    }

    @IBOutlet private var snapImageView: UIImageView! {
        didSet {
            snapImageView.clipsToBounds = true
            snapImageView.layer.masksToBounds = true
        }
    }

    // MARK: - Private properties

    private lazy var processingLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.font = .titleSemiBold
        $0.textColor = .constantWhite
    }

    private lazy var processingAnimationView = LottieAnimationView().then { animationView in
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.animation = LottieAnimation.named("processing")
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.loopMode = .loop

        NSLayoutConstraint.activate {
            animationView.widthAnchor.constraint(equalToConstant: 154)
            animationView.heightAnchor.constraint(equalToConstant: 88)
        }
    }

    private lazy var processingStack = UIStackView(arrangedSubviews: [processingAnimationView, processingLabel]).then {
        $0.translatesAutoresizingMaskIntoConstraints = false

        $0.alignment = .center
        $0.distribution = .fill
        $0.axis = .vertical
        $0.spacing = 64.0
    }

    private lazy var loadingContainerView = UIView().then { containerView in
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.alpha = 0
        containerView.isHidden = true
        containerView.backgroundColor = .backgroundPrimary
        view.addSubview(containerView)
        containerView.addSubview(loadingView)

        NSLayoutConstraint.activate {
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            containerView.topAnchor.constraint(equalTo: view.topAnchor)
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

            loadingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
            loadingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
            loadingView.topAnchor.constraint(equalTo: containerView.topAnchor)
            loadingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        }
    }

    private lazy var loadingView = UIView().then { loadingView in
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = .alphaConstantBlack90088
        loadingView.addSubview(processingStack)

        NSLayoutConstraint.activate {
            processingStack.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
            processingStack.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor)
        }
    }

    // MARK: - Public Properties

    var viewModel: CropViewModel!

    // MARK: - Lifecycle

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)

        let initialHeight: CGFloat = 200.0

        let size = CGSize(width: view.frame.width - 2 * 30, height: 200)
        let origin = CGPoint(
            x: 30,
            y: view.center.y - overlay.frame.origin.y - initialHeight / 2
        )
        let rect = CGRect(origin: origin, size: size)

        overlay.croppingEnabled = true
        overlay.set(rect)

        overlay.cropFrameChangePublisher
            .map { [unowned self] in
                CGPoint(
                    x: $0.midX - hintLabel.bounds.width / 2,
                    y: $0.origin.y - 26 + overlay.frame.origin.y
                )
            }
            .sink { [unowned self] in
                hintLabelLeadingConstraint.constant = $0.x
                hintLabelTopConstraint.constant = $0.y
            }
            .store(in: &bag)
    }

    override func startLoading() {
        loadingContainerView.setHidden(false, withDuration: 0.3)
        processingAnimationView.play()
    }

    override func stopLoading() {
        loadingContainerView.setHidden(true, withDuration: 0.3)
        processingAnimationView.stop()
    }
}

// MARK: - CropViewProtocol

extension CropViewController: CropViewProtocol {

    var backPublisher: AnyPublisher<Void, Never> {
        backButton.tapPublisher
    }

    var cancelPublisher: AnyPublisher<Void, Never> {
        cancelButton.tapPublisher
    }

    var croppingPublisher: AnyPublisher<Void, Never> {
        overlay.cropFrameChangePublisher
            .removeDuplicates()
            .void()
            .dropFirst()
            .first()
            .eraseToAnyPublisher()
    }

    var continueButtonPublisher: AnyPublisher<UIImage, Never> {
        continueButton.tapPublisher
            .withLatestFrom(overlay.cropFrameChangePublisher)
            .map { [unowned self] in
                snapImageView.screenshot(maskFrame: overlay.convert($0, to: snapImageView))
            }
            .eraseToAnyPublisher()
    }

    func apply(_ viewState: ViewState) {
        snapImageView.image = viewState.image
        continueButton.setTitle(viewState.continueButtonTitle)
        cancelButton.setTitle(viewState.cancelButtonTitle)
        hintLabel.text = viewState.hintText
        snapImageView.contentMode = viewState.imageContentMode
        processingLabel.text = viewState.processingText
    }
}
