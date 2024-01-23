import DebugPanel
import Depin
import JatAppFoundation
import UIKit
import XCoordinator

class LifecycleHandler: UIApplicationLifeCycleDelegate {

    @Injected private var reachability: Reachability
    @Injected private var crashlytics: CrashlyticsAnalyticClientProtocol

    private var window: UIWindow?
    private var splashWindow: UIWindow?

    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        let window = AppWindow()

        self.window = window
        do {
            try reachability.startNotifier()
        } catch { }

        return true
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        _ = crashlytics.application?(application, didFinishLaunchingWithOptions: launchOptions)

        start()

        return true
    }
}

private extension LifecycleHandler {

    func start() {
        let splashVC = UIStoryboard(name: "LaunchScreen", bundle: .main).instantiateInitialViewController()
        splashWindow = UIWindow(frame: UIScreen.main.bounds)
        splashWindow?.rootViewController = splashVC
        splashWindow?.windowLevel = .statusBar + 1
        splashWindow?.makeKeyAndVisible()

        window.map { AppCoordinator().strongRouter.setRoot(for: $0) }

        UIView.animate(withDuration: 0.3) {
            self.splashWindow?.alpha = 0
        } completion: { _ in
            self.splashWindow = nil
        }
    }
}