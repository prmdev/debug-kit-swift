extension Optional {
    var isSome: Bool {
        switch self {
        case .some:
            return true
        case .none:
            return false
        }
    }

    var isNone: Bool {
        return !isSome
    }
}
