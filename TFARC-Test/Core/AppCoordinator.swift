import Depin
import UIKit
import XCoordinator

enum AppRoute: Route {

    case initial
}

class AppCoordinator: NavigationCoordinator<AppRoute> {

    init() {
        super.init(
            rootViewController: UINavigationController(),
            initialRoute: .initial
        )
    }

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {

        case .initial:
            return .none(UserProfileCoordinator(rootViewController: rootViewController))
        }
    }
}

extension XCoordinator.Transition {

    static func presentOnRoot(
        _ presentable: Presentable,
        modalPresentationStyle: UIModalPresentationStyle? = nil,
        modalTransitionStyle: UIModalTransitionStyle? = nil,
        animation: Animation? = nil
    ) -> Self {
        if let modalPresentationStyle {
            presentable.viewController?.modalPresentationStyle = modalPresentationStyle
        }
        if let modalTransitionStyle {
            presentable.viewController?.modalTransitionStyle = modalTransitionStyle
        }
        return .presentOnRoot(presentable, animation: animation)
    }

    static func present(
        _ presentable: Presentable,
        modalPresentationStyle: UIModalPresentationStyle? = nil,
        modalTransitionStyle: UIModalTransitionStyle? = nil,
        animation: Animation? = nil
    ) -> Self {
        if let modalPresentationStyle {
            presentable.viewController?.modalPresentationStyle = modalPresentationStyle
        }
        if let modalTransitionStyle {
            presentable.viewController?.modalTransitionStyle = modalTransitionStyle
        }
        return .present(presentable, animation: animation)
    }

    static func none(_ presentable: Presentable) -> Transition {
        .none()
    }
}
