import Foundation

struct MetatypeSet {
    private var items: MetatypeItemMap
}

extension MetatypeSet: SetAlgebra {
    typealias Element = Any.Type
    typealias MetatypeItemMap = Dictionary<ObjectIdentifier, Element>
    
    init() {
        items = [:]
    }
    
    init<S>(_ sequence: S) where S: Sequence, Element == S.Element {
        items = Dictionary(sequence.map({ (ObjectIdentifier($0), $0) })) { $1 }
    }
    
    func contains(_ member: Element) -> Bool {
        let id = ObjectIdentifier(member)
        return items[id].isSome
    }
    
    func union(_ other: MetatypeSet) -> MetatypeSet {
        var new = self
        new.formUnion(other)
        return new
    }
    
    func intersection(_ other: MetatypeSet) -> MetatypeSet {
        var new = self
        new.formIntersection(other)
        return new
    }
    
    func symmetricDifference(_ other: MetatypeSet) -> MetatypeSet {
        var new = self
        new.formSymmetricDifference(other)
        return new
    }
    
    mutating func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
        let id = ObjectIdentifier(newMember)
        if let oldValue = items[id] {
            return (false, oldValue)
        } else {
            items[id] = newMember
            return (true, newMember)
        }
    }
    
    mutating func update(with newMember: Element) -> Element? {
        let id = ObjectIdentifier(newMember)
        let oldValue = items[id]
        items[id] = newMember
        return oldValue
    }
    
    mutating func remove(_ member: Element) -> Element? {
        return items.removeValue(forKey: ObjectIdentifier(member))
    }
    
    mutating func formUnion(_ other: MetatypeSet) {
        items.merge(other.items) { $1 }
    }
    
    mutating func formIntersection(_ other: MetatypeSet) {
        items = items.filter { other.items[$0.key].isSome }
    }
    
    mutating func formSymmetricDifference(_ other: MetatypeSet) {
        for (otherKey, otherValue) in other.items {
            if items[otherKey].isSome {
                _ = remove(otherValue)
            } else {
                _ = insert(otherValue)
            }
        }
    }
    
    static func ==(lhs: MetatypeSet, rhs: MetatypeSet) -> Bool {
        return Set(lhs.items.keys) == Set(rhs.items.keys)
    }
}

extension MetatypeSet: CustomStringConvertible {
    var description: String {
        return String(describing: Array(self.items.values))
    }
}

extension MetatypeSet: Sequence {
    typealias Iterator = MetatypeItemMap.Values.Iterator
    
    func makeIterator() -> MetatypeSet.Iterator {
        return items.values.makeIterator()
    }
}
