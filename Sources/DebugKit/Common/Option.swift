struct UnwrapError: Swift.Error {
    let message: String
}

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

    func expect(_ message: String) throws -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            throw UnwrapError(message: message)
        }
    }

    func unwrap() throws -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            throw UnwrapError(message: "called `Optional#unwrap()` on a `.none` value")
        }
    }

    func unwrapOr(_ other: Wrapped) -> Wrapped {
        guard case let .some(value) = self else {
            return other
        }
        return value
    }

    func unwrapOrElse(operation: () throws -> Wrapped) rethrows -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            return try operation()
        }
    }

    func mapOr<U>(default: U, _ transform: (Wrapped) throws -> U) rethrows -> U {
        switch self {
        case .some(let value):
            return try transform(value)
        case .none:
            return `default`
        }
    }

    func mapOrElse<U>(default: () throws -> U, _ transform: (Wrapped) throws -> U) rethrows -> U {
        switch self {
        case .some(let value):
            return try transform(value)
        case .none:
            return try `default`()
        }
    }

    func and<U>(_ opt: U?) -> U? {
        switch self {
        case .some:
            return opt
        case .none:
            return .none
        }
    }

    func andThen<U>(operation: (Wrapped) throws -> U?) rethrows -> U? {
        return try flatMap(operation)
    }

    func filter(_ predicate: (Wrapped) throws -> Bool) rethrows -> Wrapped? {
        guard case let .some(value) = self,
            try predicate(value) else {
            return .none
        }
        return .some(value)
    }

    func or(_ opt: Wrapped?) -> Wrapped? {
        switch self {
        case .some:
            return self
        case .none:
            return opt
        }
    }

    func orElse(_ operation: () throws -> Wrapped?) rethrows -> Wrapped? {
        switch self {
        case .some:
            return self
        case .none:
            return try operation()
        }
    }
}

extension Optional: Default {
    static var defaultValue: Optional { return .none }
}

extension Optional where Wrapped: Default {
    static var defaultValue: Wrapped? { return Wrapped.defaultValue }

    func unwrapOrDefault() -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            return Wrapped.defaultValue
        }
    }
}
