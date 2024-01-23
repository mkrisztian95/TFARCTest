import Bean
import Depin
import JatAppFoundation
import UIKitPlus

class AppAssembly: Assembly {

    func assemble(container: Swinject.Container) {

        container.register(ModuleBuilder.self) {
            ModuleBuilder()
        }

        container.register(KeychainManager.self) {
            KeychainManager(settings: .with { settings in
                settings.accessGroup = AppConstants.KeychainSettings.group
                settings.service = AppConstants.KeychainSettings.service
                settings.synchronizable = true
                settings.accessibility = .always(thisDeviceOnly: false)
            })
        }
        .inObjectScope(.container)

        container.register(DeviceDataProvider.self) {
            DeviceDataProvider()
        }
        .inObjectScope(.container)

        container.register(Reachability.self) {
            // swiftlint:disable:next force_try
            try! Reachability()
        }
        .inObjectScope(.container)

        container.register(LifecycleHandler.self) {
            LifecycleHandler()
        }
        .inObjectScope(.container)

        container.registerSynchronized(ATTRequester.self) { r in
            ATTRequester(tracker: r.autoResolve())
        }

        container.register(StartupService.self) {
            StartupService()
        }

        container.register(I18n.self) {
            I18n()
        }

        container.register(Bean.self) {
            Configuration.setup {
                $0.configurationRequest = .init(
                    host: AppConstants.Cloaking.host,
                    path: AppConstants.Cloaking.path
                )
            }
        }

        container.register(CloakingService.self) {
            CloakingService()
        }
        .inObjectScope(.container)

        container.register(AnalyticsDaemon.self) {
            AnalyticsDaemon()
        }

        container.register(AnalyticsDataService.self) {
            AnalyticsDataService()
        }

        container.register(AnalyticsRepository.self) {
            AnalyticsRepository()
        }

        container.register(AnalyticsStorage.self) {
            AnalyticsStorage()
        }

        container.register(UserInfoProvider.self) {
            UserInfoProvider()
        }

        container.register(UserInfoDaemon.self) {
            UserInfoDaemon()
        }

        container.register(PushNotificationPermissionHandler.self) {
            PushNotificationPermissionHandler()
        }

        container.register(ApplicationLifecycleService.self) {
            ApplicationLifecycleService()
        }

        container.register(DeviceCheckerService.self) {
            DeviceCheckerService()
        }
        .inObjectScope(.container)
    }
}
