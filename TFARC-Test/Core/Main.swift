import Depin
import UIKit

@main
enum Main {

    @Space(\.dependenciesAssembler)
    private static var assembler: Assembler

    static func main() {

        assembler.apply(assemblies: [
            AppAssembly()
        ])

        UIApplicationMain(
            CommandLine.argc,
            CommandLine.unsafeArgv,
            nil,
            NSStringFromClass(AppDelegate.self)
        )
    }
}
