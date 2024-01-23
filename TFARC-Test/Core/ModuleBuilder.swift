import AVFoundationPlus
import Depin
import SwiftUI
import UIKit
import XCoordinator

class ModuleBuilder {

    // MARK: - Injected properties

    @Injected private var paywallModuleBuilder: PaywallModuleBuilder

    enum Module {

        case splash(
            router: StrongRouter<AppRoute>
        )

        case onboarding(
            router: StrongRouter<AppRoute>
        )

        case paywall(
            type: PaywallType,
            router: StrongRouter<PaywallRoute>,
            placement: Analytics.Paywall.Placement
        )

        case legal(
            router: StrongRouter<LegalRoute>,
            type: LegalViewModel.LegalType
        )

        case camera(
            router: StrongRouter<CameraRoute>
        )

        case settings(
            router: StrongRouter<SettingsRoute>
        )

        case results(
            router: StrongRouter<CameraRoute>,
            solution: Solution
        )

        case tips(
            router: StrongRouter<CameraRoute>,
            referrer: Analytics.Tips.Referrer
        )

        case crop(
            image: UIImage,
            source: ImageSource,
            router: StrongRouter<CameraRoute>
        )

    }

    func build(_ module: Module) -> UIViewController {
        switch module {

        case let .splash(router):
            let viewController = SplashViewController()
            let viewModel = SplashViewModel(
                router: router,
                view: viewController
            )
            viewController.viewModel = viewModel
            return viewController

        case let .onboarding(router):
            let viewController = OnboardingViewController()
            let viewModel = OnboardingViewModel(
                router: router,
                view: viewController
            )
            viewController.viewModel = viewModel
            return viewController

        case let .paywall(type, router, placement):
            return paywallModuleBuilder.build(
                for: type,
                with: router,
                placement: placement
            )

        case let .legal(router, type):
            let viewController = LegalViewController()
            let viewModel = LegalViewModel(
                router: router,
                view: viewController,
                type: type
            )
            viewController.viewModel = viewModel
            return viewController

        case let .camera(router):
            let viewController = CameraViewController()
            let viewModel = CameraViewModel(
                router: router,
                view: viewController
            )
            viewController.viewModel = viewModel
            return viewController

        case let .settings(router):
            let viewModel = SettingsViewModel(router: router)
            let viewController = SettingsViewController(
                rootView: SettingsView(viewModel: viewModel)
            )
            viewModel.view = viewController
            viewController.viewModel = viewModel
            return viewController

        case let .results(router, solution):
            let viewController = ResultsViewController()
            let viewModel = ResultsViewModel(
                router: router,
                view: viewController,
                solution: solution
            )
            viewController.viewModel = viewModel
            return viewController

        case let .tips(router, referrer):
            let viewController = TipsViewController()
            let viewModel = TipsViewModel(
                router: router,
                view: viewController,
                referrer: referrer
            )
            viewController.viewModel = viewModel
            return viewController

        case let .crop(image, source, router):
            let viewController = CropViewController()
            let viewModel = CropViewModel(
                router: router,
                view: viewController,
                image: image,
                source: source
            )
            viewController.viewModel = viewModel
            return viewController

        }
    }
}
