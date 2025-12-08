import Foundation

struct day08 {
    static func run(context: DayContext) {
        let input: [(Int, Int, Int)] = context.input
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .map {
                let parts = $0.split(separator: ",").map { Int($0)! }
                return (parts[0], parts[1], parts[2])
            }

        context.restartTimer()
    
        // Create a union of all coordinate pairs
        var coordinateSet = Array<((Int, Int, Int), (Int, Int, Int))>()
        for i in 0..<input.count {
            for j in i+1..<input.count {
                let coord1 = input[i]
                let coord2 = input[j]
                coordinateSet.append((coord1, coord2))
            }
        }        

        // Sort pairs by distance
        coordinateSet.sort { (pair1, pair2) -> Bool in
            return distance(pair1.0, pair1.1) < distance(pair2.0, pair2.1)
        }

        if !context.runPartTwo {
            let part1Result = solvePart1(sortedPairs: coordinateSet, coords: input, nToConnect: context.isExample ? 10 : 1000, part2: false)
            print("Total size of the largest 3 circuits: \(part1Result)")
        } else {
            let part2Result = solvePart1(sortedPairs: coordinateSet, coords: input, nToConnect: coordinateSet.count, part2: true)
            print("Part 2: \(part2Result)")
        }
    }

    static private func solvePart1(sortedPairs input: [((Int, Int, Int), (Int, Int, Int))], coords: [(Int, Int, Int)], nToConnect n: Int, part2: Bool) -> Int {
        var circuits: [[(Int, Int, Int)]] = coords.map { [$0] }
        
        for i in 0..<input.count {
            if i >= n { break }

            let pair = input[i]
            let firstCircuit = circuits.firstIndex(where: { $0.contains(where: { $0 == pair.0 }) })
            let secondCircuit = circuits.firstIndex(where: { $0.contains(where: { $0 == pair.1 }) })

            if let f = firstCircuit, let s = secondCircuit {
                if f != s {
                    let mergedCircuit = circuits[f] + circuits[s]
                    circuits[f] = mergedCircuit
                    circuits.remove(at: s)
                }
            }
            else {
                let existingPair = firstCircuit != nil ? pair.0 : pair.1
                let newPair = firstCircuit != nil ? pair.1 : pair.0
                guard let index = circuits.firstIndex(where: { circuit in
                    circuit.contains(where: { $0 == existingPair })
                }) else {
                    print("Could not find existing circuit for pair \(existingPair)")
                    continue
                }

                circuits[index].append(newPair)
            }

            if part2 && circuits.count == 1 {
                return pair.0.0 * pair.1.0
            }
        }

        circuits.sort { $0.count > $1.count }

        var total = 1;
        for i in 0..<min(3, circuits.count) {
            total *= circuits[i].count
        }
        return total
    }

    static private func distance(_ coord1: (Int, Int, Int), _ coord2: (Int, Int, Int)) -> Double {
        let dx = pow(Double(coord1.0 - coord2.0), 2)
        let dy = pow(Double(coord1.1 - coord2.1), 2)
        let dz = pow(Double(coord1.2 - coord2.2), 2)
        return (dx + dy + dz).squareRoot()
    }
}