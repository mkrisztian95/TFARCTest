import CombinePlus
import CustomizableAvatar
import UIKit

protocol UserProfileViewProtocol: BaseViewProtocol {

    var sourceConfigPublisher: AnyPublisher<AvatarSource, Never> { get }
    var cameraTappedPublisher: AnyPublisher<Void, Never> { get }
    var saveTappedPublisher: AnyPublisher<AvatarSource, Never> { get }
    var previousAvatarSourcePublisher: AnyPublisher<AvatarSource, Never> { get }

    func apply(_ viewState: UserProfileViewController.ViewState)
}

class UserProfileViewController: BaseViewController {

    let cellIdentifier = "CustomCell"

    // MARK: - ViewState

    struct ViewState {
        let avatarConfiguration: Avatar.AvatarConfiguration
        let toolbarDesignSystem: CustomizableAvatar.DesignSystem
        let configurations: [Avatar.AvatarConfiguration]
    }

    // MARK: - Private properties

    @IBOutlet private var configureButton: UIButton! {
        didSet {
            configureButton.tintColor = .black900
        }
    }

    // MARK: - Private properties

    var sourceConfigSubject: PassthroughSubject<AvatarSource, Never> = .init()
    var saveConfigSubject: PassthroughSubject<AvatarSource, Never> = .init()
    var previousAvatarSourceSubject: PassthroughSubject<AvatarSource, Never> = .init()
    var cameraTappedSubject: PassthroughSubject<Void, Never> = .init()

    var configurations: [Avatar.AvatarConfiguration] = [] {
        didSet {
            collectionView.isHidden = configurations.isEmpty
            collectionView.reloadData()
        }
    }

    private lazy var avatarView: Avatar = {
        let avatarView = Avatar(frame: .zero)
        view.addSubview(avatarView)
        avatarView.preparedForAutoLayout()

        NSLayoutConstraint.activate {
            avatarView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.3)
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

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        // Initialize the UICollectionView
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.backgroundColor = UIColor.white
        collectionView.backgroundColor = .clear
        collectionView.preparedForAutoLayout()
        view.addSubview(collectionView)
        collectionView.isHidden = true

        NSLayoutConstraint.activate {
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            collectionView.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 32.0)
        }

        return collectionView
    }()

    // MARK: - Public properties

    var viewModel: UserProfileViewModel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        collectionView.register(
            AvatarConfigurationCell.self,
            forCellWithReuseIdentifier: AvatarConfigurationCell.reuseIdentifier
        )
    }

    @IBAction private func didTapEditButton(_ sender: Any) {
        displayPopUp(with: toolbar, and: i18n.str(.customizeYourLogo))
    }
}

// MARK: - InitialViewProtocol

extension UserProfileViewController: UserProfileViewProtocol {
    var previousAvatarSourcePublisher: AnyPublisher<CustomizableAvatar.AvatarSource, Never> {
        previousAvatarSourceSubject.eraseToAnyPublisher()
    }

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
        view.backgroundColor = .backgroundAccent
        avatarView.apply(viewState.avatarConfiguration)
        toolbar.apply(viewState.toolbarDesignSystem)
        configurations = viewState.configurations
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

extension UserProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        configurations.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AvatarConfigurationCell.reuseIdentifier,
            for: indexPath
        ) as? AvatarConfigurationCell else {
            return .init()
        }

        cell.apply(configurations[indexPath.row])

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        previousAvatarSourceSubject.send(configurations[indexPath.row].source)
    }
}

extension UserProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width / 3 - 48 / 3
        return CGSize(width: width, height: width)
    }
}
