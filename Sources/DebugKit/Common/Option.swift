public struct UnwrapError: Swift.Error {
    let message: String
}

public extension Optional {
    public var isSome: Bool {
        switch self {
        case .some(_):
            return true
        case .none:
            return false
        }
    }
    
    public var isNone: Bool {
        return !isSome
    }
    
    public func expect(_ message: String) throws -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            throw UnwrapError(message: message)
        }
    }
    
    public func unwrap() throws -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            throw UnwrapError(message: "called `Optional#unwrap()` on a `.none` value")
        }
    }
    
    public func unwrapOr(_ other: Wrapped) -> Wrapped {
        guard case let .some(value) = self else {
            return other
        }
        return value
    }
    
    public func unwrapOrElse(op: () throws -> Wrapped) rethrows -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            return try op()
        }
    }
    
    public func mapOr<U>(default: U, _ transform: (Wrapped) throws -> U) rethrows -> U {
        switch self {
        case .some(let value):
            return try transform(value)
        case .none:
            return `default`
        }
    }
    
    public func mapOrElse<U>(default: () throws -> U, _ transform: (Wrapped) throws -> U) rethrows -> U {
        switch self {
        case .some(let value):
            return try transform(value)
        case .none:
            return try `default`()
        }
    }
    
    public func and<U>(_ opt: U?) -> U? {
        switch self {
        case .some(_):
            return opt
        case .none:
            return .none
        }
    }
    
    public func andThen<U>(op: (Wrapped) throws -> U?) rethrows -> U? {
        return try flatMap(op)
    }
    
    public func filter(_ predicate: (Wrapped) throws -> Bool) rethrows -> Wrapped? {
        guard case let .some(value) = self,
            try predicate(value) else {
            return .none
        }
        return .some(value)
    }
    
    public func or(_ opt: Wrapped?) -> Wrapped? {
        switch self {
        case .some(_):
            return self
        case .none:
            return opt
        }
    }
    
    public func orElse(_ op: () throws -> Wrapped?) rethrows -> Wrapped? {
        switch self {
        case .some(_):
            return self
        case .none:
            return try op()
        }
    }
}

extension Optional: Default {
    public static var defaultValue: Optional { return .none }
}

public extension Optional where Wrapped: Default {
    public static var defaultValue: Wrapped? { return Wrapped.defaultValue }
    
    public func unwrapOrDefault() -> Wrapped {
        switch self {
        case .some(let value):
            return value
        case .none:
            return Wrapped.defaultValue
        }
    }
}

