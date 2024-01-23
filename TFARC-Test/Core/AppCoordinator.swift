import Depin
import UIKit
import XCoordinator

enum AppRoute: Route {

    enum PaywallRoute {
        case afterOnboarding
        case onLaunch
    }

    case splash
    case onboarding
    case paywall(PaywallRoute)
    case camera
}

class AppCoordinator: NavigationCoordinator<AppRoute> {

    init() {
        super.init(
            rootViewController: UINavigationController(),
            initialRoute: .splash
        )
    }

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {

        case .splash:
            let viewController = moduleBuilder.build(.splash(router: strongRouter))
            return .set([viewController])

        case .onboarding:
            let viewController = moduleBuilder.build(.onboarding(router: strongRouter))
            return .set([viewController], animation: .fade)

        case .paywall(let route):
            return .none(PaywallCoordinator(
                rootViewController: rootViewController,
                placement: paywallPlacement(for: route)
            ))

        case .camera:
            return .none(CameraCoordinator(rootViewController: rootViewController, afterSplash: true))
        }
    }

    private func paywallPlacement(for route: RouteType.PaywallRoute) -> Analytics.Paywall.Placement {
        switch route {
        case .afterOnboarding:
                .intro
        case .onLaunch:
                .appStart
        }
    }
}
