import Depin
import UIKit
import XCoordinator

class ModuleBuilder {

    // MARK: - Injected properties

    enum Module {
        case initial(
            router: StrongRouter<UserProfileRoute>
        )

        case crop(
            image: UIImage,
            source: ImageSource,
            router: StrongRouter<UserProfileRoute>
        )

        case camera(
            router: StrongRouter<UserProfileRoute>
        )
    }

    func build(_ module: Module) -> UIViewController {
        switch module {
        case let .initial(router):
            let view = UserProfileViewController()
            let viewModel = UserProfileViewModel(
                router: router,
                view: view
            )

            view.viewModel = viewModel
            return view

        case let .camera(router):
            let viewController = CameraViewController()
            let viewModel = CameraViewModel(
                router: router,
                view: viewController
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
