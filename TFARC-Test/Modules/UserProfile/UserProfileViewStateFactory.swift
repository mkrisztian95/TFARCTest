import CustomizableAvatar
import Depin
import UIKit

class UserProfileViewStateFactory {

    typealias ViewState = UserProfileViewController.ViewState

    @Injected private var i18n: I18n

    func make(
        with savedSource: AvatarSource? = nil
    ) -> ViewState {
        ViewState(
            avatarConfiguration: Avatar.AvatarConfiguration(
                cornerStyle: .circular,
                source: savedSource ?? .image(.placeholder)
            )
        )
    }

    func make(with source: AvatarSource) -> ViewState {
        ViewState(
            avatarConfiguration: Avatar.AvatarConfiguration(
                cornerStyle: .circular,
                source: source
            )
        )
    }
}
