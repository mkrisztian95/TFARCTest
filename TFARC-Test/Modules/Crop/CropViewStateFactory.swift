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
            imageContentMode: imageContentMode
        )
    }
}
