enum Environment {
    case testing
    case production

    static var current: Self {
        #if PRODUCTION
            .production
        #else
            .testing
        #endif
    }
}
