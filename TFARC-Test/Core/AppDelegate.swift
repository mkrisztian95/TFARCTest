import Depin
import UIKit
import XCoordinator

class AppDelegate: UIResponder, UIApplicationDelegate {

    @Injected private var lifeCycleCompositor: ApplicationLifeCycleCompositor

    // MARK: - Life cycle

    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        lifeCycleCompositor.application(
            application,
            willFinishLaunchingWithOptions: launchOptions
        )
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        lifeCycleCompositor.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
}
