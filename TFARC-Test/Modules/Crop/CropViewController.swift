import AVKit
import CombinePlus
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
    }
}
