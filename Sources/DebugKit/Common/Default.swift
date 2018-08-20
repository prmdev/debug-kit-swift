public protocol Default {
    static var defaultValue: Self { get }
}

extension Bool: Default {
    public static var defaultValue: Bool { return false }
}

extension Int: Default {
    public static var defaultValue: Int { return 0 }
}

extension Float: Default {
    public static var defaultValue: Float { return 0.0 }
}

extension Double: Default {
    public static var defaultValue: Double { return 0.0 }
}

extension Character: Default {
    public static var defaultValue: Character { return "\0" }
}

extension String: Default {
    public static var defaultValue: String { return "" }
}

extension Array: Default {
    public static var defaultValue: Array { return [] }
}

extension Dictionary: Default {
    public static var defaultValue: Dictionary { return [:] }
}

extension Set: Default {
    public static var defaultValue: Set { return [] }
}
