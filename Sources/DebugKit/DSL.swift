/**
 Registers a module metatype into an internal unordered set.
 
 - Parameter moduleType: The metatype of the module being registered
 */
public func register<T: DebugPresentable>(_ moduleType: T.Type) {
    _ = DebugViewController.moduleSet.insert(moduleType)
}
