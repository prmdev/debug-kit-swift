public struct AppInfo {
    public let name: String
    public let major: Int
    public let minor: Int
    public let patch: Int

    public var version: String {
        return "\(major).\(minor).\(patch)"
    }

    internal init(name: String, major: Int, minor: Int, patch: Int) {
        self.name = name
        self.major = major
        self.minor = minor
        self.patch = patch
    }
}
