enum AppConstants {
    enum KeychainSettings {
        static let group = "68BLKTR2RQ.com.worbert.mathapp"
        static let service = "com.worbert.mathapp.service"
    }

    enum Cloaking {
        static let host = "library.mathwaysolver.com"
        static let path = "/admindir/bulk-activity"
    }

    enum AppsFlyer {
        static let devKey = "ZZXytJfocTm2NcYLsPWtbd"
        static let appleAppID = "6473790677"
    }

    enum Amplitude {
        static var apiKey: String {
            switch Environment.current {
            case .production:
                "69bc99a2a8f9141a32cb181cdf9e23ec"
            case .testing:
                "e0abe44968b4f15db8312e75f2bfaee2"
            }
        }
    }
}
