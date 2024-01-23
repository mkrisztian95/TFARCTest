import UIKitPlus

@resultBuilder
enum PopUpButtonBuilder {

    typealias ViewState = PopUpView.PopUpButtonViewState

    static func buildPartialBlock(first: ViewState) -> [ViewState] {
        [first]
    }

    static func buildPartialBlock(first: [ViewState]) -> [ViewState] {
        first
    }

    static func buildPartialBlock(accumulated: [ViewState], next: ViewState) -> [ViewState] {
        accumulated + [next]
    }

    static func buildPartialBlock(accumulated: [ViewState], next: [ViewState]) -> [ViewState] {
        accumulated + next
    }

    static func buildBlock(_ components: ViewState...) -> [ViewState] {
        components
    }

    static func buildArray(_ components: [[ViewState]]) -> [ViewState] {
        Array(components.joined())
    }
}
