import AVFoundationPlus
import CombinePlus
import UIKitPlus

protocol CameraViewProtocol: BaseViewController {
    var flashTapPublisher: AnyPublisher<Void, Never> { get }
    var libraryTapPublisher: AnyPublisher<Void, Never> { get }
    var snapTapPublisher: AnyPublisher<Void, Never> { get }
    var tipsTapPublisher: AnyPublisher<Void, Never> { get }
    var settingsTapPublisher: AnyPublisher<Void, Never> { get }

    func apply(_ viewState: CameraViewController.ViewState)
    func setup(with session: AVCaptureSession)
}

class CameraViewController: BaseViewController {

    struct ViewState {
        let flashIcon: UIImage?
        let hintText: String
    }

    // MARK: - IBOutlets

    @IBOutlet private var cameraOverlay: CameraFrameOverlay!
    @IBOutlet private var previewView: PreviewView!
    @IBOutlet private var snapButton: SnapButton!
    @IBOutlet private var tipsButton: UIButton!
    @IBOutlet private var settingsButton: UIButton!
    @IBOutlet private var libraryButton: UIButton!
    @IBOutlet private var flashButton: UIButton!
    @IBOutlet private var cameraActionsContainerView: UIView!

    @IBOutlet private var hintLabel: UILabel! {
        didSet {
            hintLabel.font = .captionLBold
            hintLabel.textColor = .constantWhite
        }
    }

    var viewModel: CameraViewModel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        let height = view.frame.height -
        cameraOverlay.frame.origin.y -
        view.safeAreaInsets.bottom -
        cameraActionsContainerView.frame.height

        cameraOverlay.set(CGRect(
            x: 16,
            y: 0,
            width: view.frame.width - 16 * 2,
            height: height
        ))
    }
}

extension CameraViewController: CameraViewProtocol {

    var flashTapPublisher: AnyPublisher<Void, Never> {
        flashButton.tapPublisher
    }

    var libraryTapPublisher: AnyPublisher<Void, Never> {
        libraryButton.tapPublisher
    }

    var snapTapPublisher: AnyPublisher<Void, Never> {
        snapButton.tapPublisher
    }

    var tipsTapPublisher: AnyPublisher<Void, Never> {
        tipsButton.tapPublisher
    }

    var settingsTapPublisher: AnyPublisher<Void, Never> {
        settingsButton.tapPublisher
    }

    func apply(_ viewState: ViewState) {
        hintLabel.text = viewState.hintText

        if let flashIcon = viewState.flashIcon {
            flashButton.setImage(flashIcon)
            flashButton.isHidden = false
        } else {
            flashButton.isHidden = true
        }
    }

    func setup(with session: AVCaptureSession) {
        previewView.session = session
    }
}
