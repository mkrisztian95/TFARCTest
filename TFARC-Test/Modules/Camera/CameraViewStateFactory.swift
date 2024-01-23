import Depin
import UIKit

class CameraViewStateFactory {

    typealias ViewState = CameraViewController.ViewState
    typealias PopUpViewState = PopUpView.ViewState
    typealias PopUpButtonViewState = PopUpView.PopUpButtonViewState

    @Injected private var i18n: I18n

    func make(
        isFlashEnabled: Bool,
        cameraEnabled: Bool
    ) -> ViewState {
        ViewState(
            flashIcon: cameraEnabled ? (isFlashEnabled ? .icFlashOn : .icFlashOff) : nil,
            hintText: i18n.str(.takePhotoOfTheTask)
        )
    }

    func makePopUpViewState(
        with continueAction: @escaping () -> Void,
        and notNowAction: @escaping () -> Void
    ) -> PopUpViewState {
        PopUpViewState(
            title: i18n.str(.allowAccessToCamera),
            subtitle: i18n.str(.toSolveMathProblem)
        ) {
            PopUpButtonViewState(
                title: i18n.str(.continue),
                type: .primary,
                action: continueAction
            )
            PopUpButtonViewState(
                title: i18n.str(.notNow),
                type: .secondary,
                action: notNowAction
            )
        }
    }
}
