import CombinePlus
import CustomizableAvatar
import UIKitPlus

protocol UserProfileViewProtocol: BaseViewProtocol {

    var sourceConfigPublisher: AnyPublisher<AvatarSource, Never> { get }
    var cameraTappedPublisher: AnyPublisher<Void, Never> { get }
    var saveTappedPublisher: AnyPublisher<AvatarSource, Never> { get }

    func apply(_ viewState: UserProfileViewController.ViewState)
}

class UserProfileViewController: BaseViewController {

    enum ViewID: ViewIdentifiable {
        case view
    }

    // MARK: - ViewState

    struct ViewState {
        let avatarConfiguration: Avatar.AvatarConfiguration
    }

    // MARK: - Private properties

    var sourceConfigSubject: PassthroughSubject<AvatarSource, Never> = .init()
    var saveConfigSubject: PassthroughSubject<AvatarSource, Never> = .init()
    var cameraTappedSubject: PassthroughSubject<Void, Never> = .init()

    private lazy var avatarView: Avatar = {
        let avatarView = Avatar(frame: .zero)
        view.addSubview(avatarView)
        avatarView.preparedForAutoLayout()

        NSLayoutConstraint.activate {
            avatarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
            avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor, multiplier: 1.0)
            avatarView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0)
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
        }

        return avatarView
    }()

    private lazy var toolbar: ConstructorToolbar = {
        let toolbar = ConstructorToolbar()
        toolbar.delegate = self
        toolbar.preparedForAutoLayout()
        toolbar.backgroundColor = .clear
        return toolbar
    }()

    // MARK: - Public properties

    var viewModel: UserProfileViewModel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        view.viewID = ViewID.view
    }

    @IBAction private func didTapEditButton(_ sender: Any) {
        displayPopUp(with: toolbar, and: "Customise your logo")
    }
}

// MARK: - InitialViewProtocol

extension UserProfileViewController: UserProfileViewProtocol {
    var saveTappedPublisher: AnyPublisher<CustomizableAvatar.AvatarSource, Never> {
        saveConfigSubject.eraseToAnyPublisher()
    }
    
    var cameraTappedPublisher: AnyPublisher<Void, Never> {
        cameraTappedSubject.eraseToAnyPublisher()
    }

    var sourceConfigPublisher: AnyPublisher<CustomizableAvatar.AvatarSource, Never> {
        sourceConfigSubject.eraseToAnyPublisher()
    }

    func apply(_ viewState: ViewState) {
        avatarView.apply(viewState.avatarConfiguration)
    }

}

extension UserProfileViewController: ConstructorToolbarProtocol {
    func didTapSave(_ source: CustomizableAvatar.AvatarSource) {
        saveConfigSubject.send(source)
    }
    
    func didTapCameraButton() {
        cameraTappedSubject.send(())
    }

    func didChangeSource(_ source: CustomizableAvatar.AvatarSource) {
        sourceConfigSubject.send(source)
    }
}
