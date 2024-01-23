import AVFoundationPlus
import Depin
import UIKit

class CropViewStateFactory {

    typealias ViewState = CropViewController.ViewState
    typealias PopUpViewState = PopUpView.ViewState
    typealias PopUpButtonViewState = PopUpView.PopUpButtonViewState

    @Injected private var i18n: I18n

    func make(image: UIImage, source: ImageSource) -> ViewState {
        let imageContentMode = switch source {
        case .camera:
            UIView.ContentMode .scaleAspectFill
        case .gallery:
            UIView.ContentMode.scaleAspectFit
        }

        return ViewState(
            image: image,
            cancelButtonTitle: i18n.str(.cancel),
            continueButtonTitle: i18n.str(.continue),
            hintText: i18n.str(.cropThePhoto),
            processingText: i18n.str(.sitTightMagicInProgress),
            imageContentMode: imageContentMode
        )
    }

    func makePopUpViewState(closeAction retakeAction: @escaping () -> Void) -> PopUpViewState {
        PopUpViewState(
            title: i18n.str(.weCouldntRecogniseThisProblem),
            subtitle: i18n.str(.makeSureAboutHighQualityPhoto),
            icon: .icError,
            showCloseButton: true
        ) {
            PopUpButtonViewState(
                title: i18n.str(.retakePhoto),
                type: .primary,
                action: retakeAction
            )
        }
    }
}
