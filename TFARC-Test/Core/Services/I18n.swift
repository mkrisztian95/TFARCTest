import FoundationPlus

class I18n {

    enum StringKey {

        // MARK: - Onboarding

        case `continue`
        case notNow
        case onboardingTitle(Int)

        // MARK: - Paywall

        case ok
        case success
        case enjoyPremium
        case yourOrderIsProcessing
        case toBecomePremium
        case failedToRestore
        case restored
        case weSuccessfullyRestored
        case subscriptionExpired
        case weRestoredButSubscriptionExpired
        case termsOfUse
        case privacyPolicy
        case restore
        case solveProblemsGetExplanations
        case solveProblems
        case getExplanations
        case aiTextRecognition
        case allMathLevelsSupported
        case remindBeforeFreeTrialEnds
        case getAllFeaturesForFree
        case unlockAllFeatures
        case tryForFree
        case noPaymentNow
        case bestValue
        case priceAnnualPayment(String)
        case durationDayFreeTrial(Int)
        case thenPriceSlashWeek(String)
        case priceSlashWeek(String)
        case popular

        // MARK: - Camera

        case takePhotoOfTheTask
        case tips
        case tipsListItem(index: Int)
        case tipsListItemDescription(index: Int)
        case getIt
        case startScanning
        case allowAccessToCamera
        case toSolveMathProblem
        case cancel
        case cropThePhoto

        // MARK: - Settings

        case settings
        case becomePremiumMember
        case getStepByStepSolution
        case restorePurchase
        case privacyAndSecurity
        case versionNumber(String)

        // MARK: - Processing

        case sitTightMagicInProgress
        case weCouldntRecogniseThisProblem
        case makeSureAboutHighQualityPhoto
        case retakePhoto

        // MARK: - No Internet Connection

        case noInternetConnection
        case checkYourConnection
        case tryAgain

        // MARK: - Results

        case calculations
        case results
        case problem
        case solution
        case solvingSteps
        case stepNumber(Int)
        case solveAnotherTask
    }

    // swiftlint:disable cyclomatic_complexity
    func str(_ key: StringKey) -> String {
        switch key {
        case .continue:
            "continue".localized()
        case let .onboardingTitle(index):
            "onboarding_title_\(index)".localized()
        case .ok:
            "ok".localized()
        case .success:
            "success".localized()
        case .enjoyPremium:
            "enjoy_premium".localized()
        case .yourOrderIsProcessing:
            "your_order_is_processing".localized()
        case .toBecomePremium:
            "to_become_premium".localized()
        case .failedToRestore:
            "failed_to_restore".localized()
        case .restored:
            "restored".localized()
        case .weSuccessfullyRestored:
            "we_successfully_restored".localized()
        case .subscriptionExpired:
            "subscription_expired".localized()
        case .weRestoredButSubscriptionExpired:
            "we_restored_but_subscription_expired".localized()
        case .termsOfUse:
            "terms_of_use".localized()
        case .privacyPolicy:
            "privacy_policy".localized()
        case .restore:
            "restore".localized()
        case .solveProblemsGetExplanations:
            "solve_problems_get_explanations".localized()
        case .solveProblems:
            "solve_problems".localized()
        case .getExplanations:
            "get_explanations".localized()
        case .aiTextRecognition:
            "ai_text_recognition".localized()
        case .allMathLevelsSupported:
            "all_math_levels_supported".localized()
        case .remindBeforeFreeTrialEnds:
            "remind_before_free_trial_ends".localized()
        case .getAllFeaturesForFree:
            "get_all_features_for_free".localized()
        case .unlockAllFeatures:
            "unlock_all_features".localized()
        case .tryForFree:
            "try_for_free".localized()
        case .noPaymentNow:
            "no_payment_now".localized()
        case .bestValue:
            "best_value".localized()
        case .priceAnnualPayment(let price):
            "price_annual_payment".localized(arguments: price)
        case .durationDayFreeTrial(let duration):
            "duration_day_free_trial".localized(arguments: duration)
        case .thenPriceSlashWeek(let price):
            "then_price_slash_week".localized(arguments: price)
        case .priceSlashWeek(let price):
            "price_slash_week".localized(arguments: price)
        case .popular:
            "popular".localized()
        case .takePhotoOfTheTask:
            "take_photo_of_the_task".localized()
        case .notNow:
            "not_now".localized()
        case .allowAccessToCamera:
            "allow_access_to_camera".localized()
        case .toSolveMathProblem:
            "to_solve_math_problem".localized()
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
        case .settings:
            "settings".localized()
        case .becomePremiumMember:
            "become_premium_member".localized()
        case .getStepByStepSolution:
            "get_step_by_step_solution".localized()
        case .restorePurchase:
            "restore_purchase".localized()
        case .privacyAndSecurity:
            "privacy_and_security".localized()
        case let .versionNumber(version):
            "version_number".localized(arguments: version)
        case .cancel:
            "cancel".localized()
        case .sitTightMagicInProgress:
            "sit_tight_magic_in_progress".localized()
        case .weCouldntRecogniseThisProblem:
            "we_couldnt_recognise_this_problem".localized()
        case .makeSureAboutHighQualityPhoto:
            "make_sure_about_high_quality_photo".localized()
        case .retakePhoto:
            "retake_photo".localized()
        case .noInternetConnection:
            "no_internet_connection".localized()
        case .checkYourConnection:
            "check_your_connection".localized()
        case .tryAgain:
            "try_again".localized()
        case .calculations:
            "calculations".localized()
        case .results:
            "results".localized()
        case .problem:
            "problem".localized()
        case .solution:
            "solution".localized()
        case .solvingSteps:
            "solving_steps".localized()
        case .stepNumber(let number):
            "steps_no".localized(arguments: number)
        case .solveAnotherTask:
            "solve_another_task".localized()
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
