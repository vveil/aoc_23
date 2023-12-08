import Algorithms
import Foundation
import RegexBuilder

struct Day08: AdventDay {
  var data: String

  var entities: [String] {
    data.components(separatedBy: "\n\n")
  }

  let testData = """
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    """.components(separatedBy: "\n\n")

  let testData2 = """
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
    """.components(separatedBy: "\n\n")

  func convertInputToTuples(input: [String]) -> [String: [String]] {
    let regex = Regex {
      Capture(OneOrMore(.word))
      One(.whitespace)
      One(.any)
      One(.whitespace)
      One(.any)
      Capture(OneOrMore(.word))
      One(.any)
      One(.whitespace)
      Capture(OneOrMore(.word))
      OneOrMore(.any)
    }
    var converted: [String: [String]] = [:]
    input.forEach { line in
      let matches = line.matches(of: regex)

      if let firstMatch = matches.first {
        let current = firstMatch.1
        let left = firstMatch.2
        let right = firstMatch.3

        converted[String(current)] = [String(left), String(right)]
      }
    }
    return converted
  }

  func getInstructions(input: String) -> [Int] {
    return input.map({ char -> Int in
      switch char {
      case "L":
        return 0
      case "R":
        return 1
      default:
        return 0
      }
    }
    )
  }

  func part1() -> Any {

    let instructions = getInstructions(input: entities[0])
    let way = convertInputToTuples(input: entities[1].components(separatedBy: "\n"))

    var turns = 0
    var instructionsIndex = 0
    var current = "AAA"
    while current != "ZZZ" {
      if instructionsIndex == instructions.count {
        instructionsIndex = 0
      }
      let instruction = instructions[instructionsIndex]
      current = way[current]![instruction]
      turns += 1
      instructionsIndex += 1
    }

    return turns
  }

  func part2() -> Any {

    let instructions = getInstructions(input: entities[0])
    let way = convertInputToTuples(input: entities[1].components(separatedBy: "\n"))

    var currentPos: [String] = way.keys.filter({ $0.last == "A" })
    var turns = 0

    var instructionsIndex = 0

    print(
      currentPos.allSatisfy({ pos in
        pos.hasSuffix("A")
      }))

    while !currentPos.allSatisfy({ pos in
      pos.last == "Z"
    }) {
      if instructionsIndex == instructions.count {
        instructionsIndex = 0
      }
      currentPos = currentPos.map({ pos in
        turns += 1
        return way[pos]![instructions[instructionsIndex]]
      })
      instructionsIndex += 1
    }

    return turns
  }
}
