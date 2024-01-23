import AVFoundationPlus
import Depin

class AppAssembly: Assembly {

    func assemble(container: Swinject.Container) {

        container.register(ModuleBuilder.self) {
            ModuleBuilder()
        }

        container.register(UserProfileViewStateFactory.self) {
            UserProfileViewStateFactory()
        }

        container.register(LifecycleHandler.self) {
            LifecycleHandler()
        }

        container.register(CameraViewStateFactory.self) {
            CameraViewStateFactory()
        }

        container.register(I18n.self) {
            I18n()
        }

        container.register(CropViewStateFactory.self) {
            CropViewStateFactory()
        }

        container.registerSynchronized(ApplicationLifeCycleCompositor.self) { r in
            ApplicationLifeCycleCompositor(delegates: [
                r ~> LifecycleHandler.self
            ])
        }
        .inObjectScope(.container)

        container.register(CameraSessionService.self) {
            CameraSessionService(with: nil)
        }

    }
}
