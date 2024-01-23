import CombinePlus
import CustomizableAvatar
import Depin
import UIKit
import XCoordinator

class UserProfileViewModel {

    // MARK: - Injected properties

    @Injected private var factory: UserProfileViewStateFactory

    private unowned let view: UserProfileViewProtocol
    private let router: StrongRouter<UserProfileRoute>

    private var bag = CancelBag()

    init(
        router: StrongRouter<UserProfileRoute>,
        view: UserProfileViewProtocol
    ) {
        self.router = router
        self.view = view

        bind()
    }

    deinit {
        print(" ☠️☠️☠️ DEINIT: \(String(describing: self))")
    }

    func set(image: UIImage) {
        let source = AvatarSource.image(image)
        UserDefaults.standard.saveNewSource(source)
        UserDefaults.standard.currentSource = source
        view.hidePopUp()
        view.apply(factory.make(with: source, and: UserDefaults.standard.previousAvatarSources))
    }
}

private extension UserProfileViewModel {
    func bind() {
        view.sourceConfigPublisher
            .compactMap { [weak self] in
                self?.factory.make(
                    with: $0,
                    and: UserDefaults.standard.previousAvatarSources
                )
            }
            .sink { [weak self] in
                self?.view.apply($0)
            }
            .store(in: &bag)

        view.viewDidLoadPublisher
            .compactMap { [weak self] in
                self?.factory.make(
                    with: UserDefaults.standard.currentSource,
                    and: UserDefaults.standard.previousAvatarSources
                )
            }
            .sink { [weak self] in
                self?.bindOnLoad()
                self?.view.apply($0)
            }
            .store(in: &bag)
    }

    func bindOnLoad() {
        view.cameraTappedPublisher
            .onMain()
            .sink { [unowned self] in
                router.trigger(.camera)
            }
            .store(in: &bag)

        view.saveTappedPublisher
            .perform { [unowned self] in
                UserDefaults.standard.saveNewSource($0)
                UserDefaults.standard.currentSource = $0
                view.hidePopUp()
            }
            .map { [unowned self] in
                factory.make(
                    with: $0,
                    and: UserDefaults.standard.previousAvatarSources
                )
            }
            .sink { [unowned self] in
                view.apply($0)
            }
            .store(in: &bag)

        view.previousAvatarSourcePublisher
            .perform {
                UserDefaults.standard.currentSource = $0
            }
            .compactMap { [weak self] in
                self?.factory.make(
                    with: $0,
                    and: UserDefaults.standard.previousAvatarSources
                )
            }
            .sink { [weak self] in
                self?.view.apply($0)
            }
            .store(in: &bag)
    }
}
