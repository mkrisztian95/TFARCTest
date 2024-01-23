import FoundationPlus

class I18n {

    enum StringKey {

        // MARK: - Onboarding

        case `continue`
        case notNow

        // MARK: - Camera

        case takePhoto
        case tips
        case tipsListItem(index: Int)
        case tipsListItemDescription(index: Int)
        case getIt
        case startScanning
        case allowAccessToCamera
        case toSettings
        case cancel
        case cropThePhoto
        case customizeYourLogo
    }

    // swiftlint:disable cyclomatic_complexity
    func str(_ key: StringKey) -> String {
        switch key {
        case .continue:
            "continue".localized()
        case .takePhoto:
            "take_photo".localized()
        case .notNow:
            "not_now".localized()
        case .allowAccessToCamera:
            "allow_access_to_camera".localized()
        case .toSettings:
            "to_settings".localized()
        case .cropThePhoto:
            "crop_the_photo".localized()
        case .tips:
            "tips".localized()
        case let .tipsListItem(index):
            "tips_list_item_\(index)".localized()
        case let .tipsListItemDescription(index):
            "tips_list_item_description_\(index)".localized()
        case .getIt:
            "get_it".localized()
        case .startScanning:
            "start_scanning".localized()
        case .cancel:
            "cancel".localized()
        case .customizeYourLogo:
            "customize_your_logo".localized()
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
