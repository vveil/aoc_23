import Algorithms
import Foundation
import RegexBuilder

struct Day09: AdventDay {
  var data: String

  var entities: [String] {
    data.components(separatedBy: "\n")
  }

  let testData = """
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """.components(separatedBy: "\n")

  // let testData2 = """
  //   LR

  //   11A = (11B, XXX)
  //   11B = (XXX, 11Z)
  //   11Z = (11B, XXX)
  //   22A = (22B, XXX)
  //   22B = (22C, 22C)
  //   22C = (22Z, 22Z)
  //   22Z = (22B, 22B)
  //   XXX = (XXX, XXX)
  //   """.components(separatedBy: "\n\n")

  func getAllDiffs(_ numbersParam: [Int]) -> [Int: [Int]] {
    var numbers = numbersParam
    var diffs: [Int: [Int]] = [0: numbers]
    var diffCounter: Int = 0
    repeat {
      diffCounter += 1
      for (index, number) in numbers.enumerated() {
        if index < numbers.count - 1 {
          diffs[diffCounter, default: []].append(numbers[index + 1] - number)
        }
      }
      numbers = diffs[diffCounter]!
    } while !diffs[diffCounter]!.allSatisfy({ $0 == 0 })
    return diffs
  }

  func getNextHistoryNumber(_ diffsParam: [Int: [Int]]) -> Int {
    var diffs = diffsParam
    var currentDiff: Int = 0
    for key in diffs.keys.sorted().reversed() {
      if key == 0 {
        return diffs[key]!.last! + currentDiff
      }
      diffs[key]!.append(diffs[key]!.last! + currentDiff)
      currentDiff = diffs[key]!.last!
    }
    return 0
  }

  func part1() -> Any {

    var result: Int = 0

    for line in entities {
      let numbers = line.components(separatedBy: " ").compactMap { Int($0) }
      let diffs = getAllDiffs(numbers)
      result += getNextHistoryNumber(diffs)
    }

    return result
  }

  func part2() -> Any {

    var result: Int = 0
    for line in entities {
      let numbers = line.components(separatedBy: " ").compactMap { Int($0) }
      let numbersReversed = Array(numbers.reversed())
      let diffs = getAllDiffs(numbersReversed)
      result += getNextHistoryNumber(diffs)
    }

    return result
  }
}
