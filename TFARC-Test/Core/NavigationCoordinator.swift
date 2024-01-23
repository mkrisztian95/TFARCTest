import Depin
import os
import XCoordinator

class NavigationCoordinator<RouteType: Route>: XCoordinator.NavigationCoordinator<RouteType> {

    @Injected var moduleBuilder: ModuleBuilder

    deinit {
        Logger.uiKit.log("DEINIT \(String(describing: self))")
    }
}
