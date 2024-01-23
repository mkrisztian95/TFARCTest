import CustomizableAvatar
import Depin
import UIKit

class UserProfileViewStateFactory {

    typealias ViewState = UserProfileViewController.ViewState

    @Injected private var i18n: I18n

    private var toolbarDesignSystem: CustomizableAvatar.DesignSystem = .init(
        backgroundColor: .clear,
        textViewColor: .black900,
        optionTitleColor: .black700,
        buttonTitleColor: .constantWhite,
        buttonColor: .primary500,
        textViewFont: .bodyBold,
        optionTItleFont: .bodyRegular,
        buttonFont: .titleSemiBold
    )

    func make(
        with savedSource: AvatarSource? = nil,
        and configurations: [AvatarSource]
    ) -> ViewState {
        ViewState(
            avatarConfiguration: Avatar.AvatarConfiguration(
                cornerStyle: .circular,
                source: savedSource ?? .image(.placeholder)
            ),
            toolbarDesignSystem: toolbarDesignSystem,
            configurations: configurations.map {
                Avatar.AvatarConfiguration(
                    cornerStyle: .circular,
                    source: $0
                )
            }
        )
    }

    func make(
        with source: AvatarSource,
        and configurations: [AvatarSource]
    ) -> ViewState {
        ViewState(
            avatarConfiguration: Avatar.AvatarConfiguration(
                cornerStyle: .circular,
                source: source
            ),
            toolbarDesignSystem: toolbarDesignSystem,
            configurations: configurations.map {
                Avatar.AvatarConfiguration(
                    cornerStyle: .circular,
                    source: $0
                )
            }
        )
    }
}
