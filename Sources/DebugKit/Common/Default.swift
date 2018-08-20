protocol Default {
    static var defaultValue: Self { get }
}

extension Bool: Default {
    static var defaultValue: Bool { return false }
}

extension Int: Default {
    static var defaultValue: Int { return 0 }
}

extension Float: Default {
    static var defaultValue: Float { return 0.0 }
}

extension Double: Default {
    static var defaultValue: Double { return 0.0 }
}

extension Character: Default {
    static var defaultValue: Character { return "\0" }
}

extension String: Default {
    static var defaultValue: String { return "" }
}

extension Array: Default {
    static var defaultValue: Array { return [] }
}

extension Dictionary: Default {
    static var defaultValue: Dictionary { return [:] }
}

extension Set: Default {
    static var defaultValue: Set { return [] }
}
