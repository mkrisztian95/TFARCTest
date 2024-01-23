import Depin
import UIKit
import XCoordinator

enum UserProfileRoute: Route {
    case userProfile
    case camera
    case crop(image: UIImage, source: ImageSource)
    case dismiss
    case pop
    case popToEditor(UIImage)
}

class UserProfileCoordinator: NavigationCoordinator<UserProfileRoute> {

    init(
        rootViewController: UINavigationController
    ) {
        super.init(
            rootViewController: rootViewController,
            initialRoute: nil
        )
        trigger(.userProfile)
    }

    override func prepareTransition(for route: UserProfileRoute) -> NavigationTransition {
        switch route {
        case .userProfile:
            return .set([moduleBuilder.build(.initial(router: strongRouter))])

        case let .crop(image, source):
            let viewController = moduleBuilder.build(.crop(
                image: image,
                source: source,
                router: strongRouter
            ))
            return .push(viewController)

        case .camera:
            let viewController = moduleBuilder.build(.camera(router: strongRouter))
            return .push(viewController)

        case .dismiss:
            return .dismiss()

        case .pop:
            return .pop()

        case .popToEditor(let image):
            if let view = rootViewController.viewControllers.first(where: {
                $0.isKind(of: UserProfileViewController.self)
            }) as? UserProfileViewController {
                view.viewModel.set(image: image)
                return .pop(to: view)
            } else {
                return .popToRoot()
            }
        }
    }
}
