import UIKit

protocol UIApplicationLifeCycleDelegate: AnyObject {
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool

    func applicationDidBecomeActive(_ application: UIApplication)

    func applicationWillResignActive(_ application: UIApplication)

    func applicationDidReceiveMemoryWarning(_ application: UIApplication)

    func applicationWillTerminate(_ application: UIApplication)

    func applicationDidEnterBackground(_ application: UIApplication)

    func applicationWillEnterForeground(_ application: UIApplication)

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any]
    ) -> Bool

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool

    func application(
        _ application: UIApplication,
        open url: URL,
        sourceApplication: String?,
        annotation: Any
    ) -> Bool
}

extension UIApplicationLifeCycleDelegate {
    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        false
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        false
    }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        false
    }

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        false
    }

    func application(
        _ application: UIApplication,
        open url: URL,
        sourceApplication: String?,
        annotation: Any
    ) -> Bool {
        false
    }
}
