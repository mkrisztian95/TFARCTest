import UIKit

class ApplicationLifeCycleCompositor {
    private let delegates: [UIApplicationLifeCycleDelegate]

    init(delegates: [UIApplicationLifeCycleDelegate]) {
        self.delegates = delegates
    }
}

extension ApplicationLifeCycleCompositor: UIApplicationLifeCycleDelegate {
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        delegates.map { $0.application(application, willFinishLaunchingWithOptions: launchOptions) }.allSatisfy { $0 }
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        delegates.map { $0.application(application, didFinishLaunchingWithOptions: launchOptions) }.allSatisfy { $0 }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        delegates.forEach { $0.applicationDidBecomeActive(application) }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        delegates.forEach { $0.applicationWillResignActive(application) }
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        delegates.forEach { $0.applicationDidReceiveMemoryWarning(application) }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        delegates.forEach { $0.applicationWillTerminate(application) }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        delegates.forEach { $0.applicationDidEnterBackground(application) }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        delegates.forEach { $0.applicationWillEnterForeground(application) }
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        delegates.map { $0.application(app, open: url, options: options) }.allSatisfy { $0 }
    }

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        delegates.map { $0.application(
            application,
            continue: userActivity,
            restorationHandler: restorationHandler
        ) }
        .allSatisfy { $0 }
    }

    func application(
        _ application: UIApplication,
        open url: URL,
        sourceApplication: String?,
        annotation: Any
    ) -> Bool {
        delegates.map { $0.application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation
        ) }
        .allSatisfy { $0 }
    }
}
