import CombinePlus
import Depin
import Midas

class StartupService {

    @Injected private var purchaseService: SubscriptionPurchasable
    @Injected private var cloakingService: CloakingService
    @Injected private var subslabNetworkService: SubslabNetworkService
    @Injected private var mathNetworkService: MathNetworkService
    @Injected private var analyticsDaemon: AnalyticsDaemon
    @Injected private var userInfoDaemon: UserInfoDaemon
    @Injected private var deviceCheckerService: DeviceCheckerService

    func start() -> AnyPublisher<Void, Never> {
        Publishers.Zip3(
            fetchAppData(),
            fetchCloakings(),
            sendData()
        )
        .void()
        .eraseToAnyPublisher()
    }

    private func fetchAppData() -> AnyPublisher<Void, Never> {
        Publishers.Zip3(
            fetchPurchases(),
            fetchUserInfo(),
            fetchDeviceInfo()
        )
        .void()
        .eraseToAnyPublisher()
    }

    private func fetchPurchases() -> AnyPublisher<Void, Never> {
        purchaseService.combine.fetchProducts()
            .void()
            .replaceError(with: ())
            .eraseToAnyPublisher()
    }

    private func fetchUserInfo() -> AnyPublisher<Void, Never> {
        userInfoDaemon.start()
    }

    private func fetchDeviceInfo() -> AnyPublisher<Void, Never> {
        deviceCheckerService.refresh()
    }

    private func fetchCloakings() -> AnyPublisher<Void, Never> {
        cloakingService.fetch()
            .replaceCompletion(with: ())
            .eraseToAnyPublisher()
    }

    private func sendData() -> AnyPublisher<Void, Never> {
        Publishers.Zip(
            sendAnalyticsConfig(),
            sendDeviceData()
        )
        .void()
        .eraseToAnyPublisher()
    }

    private func sendAnalyticsConfig() -> AnyPublisher<Void, Never> {
        analyticsDaemon.start()
            .eraseToAnyPublisher()
    }

    private func sendDeviceData() -> AnyPublisher<Void, Never> {
        mathNetworkService.device()
            .void()
            .replaceError(with: ())
            .eraseToAnyPublisher()
    }
}
