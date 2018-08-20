public enum Error: Swift.Error {
    case registrationFailed
}

/// Throws a `DebugKit.Error` if registration of the type fails
public func register<T: DebugModule>(_ moduleType: T.Type) throws {
    let (success, _) = DebugViewController.moduleSet.insert(moduleType)
    guard success else {
        throw DebugKit.Error.registrationFailed
    }
}
