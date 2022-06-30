//
//  Vector.swift
//  Genius Machine
//


import Foundation
//import KDTree


struct Vector {
    var uuid: String
    var name: String
    var vector: [Double]
    var distance: Double
}

extension Vector {
    init(uuid: String, name: String, vector: [Double]) {
        self.init(uuid: uuid,
                  name: name,
                  vector: vector,
                  distance: 0)
    }
    
    init?(item: [String: Any]) {
        guard
              let uuid = item["uuid"] as? String,
              let name = item["name"] as? String,
              let vector = item["vector"] as? [Double],
              let distance = item["distance"] as? Double
        else {
            print("Error at get vectors")
            return nil
        }
        self.uuid = uuid
        self.name = name
        self.vector = vector
        self.distance = distance
    }
    
    var dict: [String: Any] {
        return [
            "uuid": uuid,
            "name": name,
            "vector": vector,
            "distance": distance
        ]
    }
}
extension Sequence where Iterator.Element: Hashable {
    func uniq() -> [Iterator.Element] {
        var seen = Set<Iterator.Element>()
        return filter { seen.update(with: $0) == nil }
    }
}

extension Vector : Hashable {
    //var hash : [Double] { return self.vector }
}

func == (lhs: Vector, rhs: Vector) -> Bool {
    return lhs.vector == rhs.vector
}

