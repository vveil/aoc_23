import Algorithms
import Foundation
import RegexBuilder

struct Day04: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.components(separatedBy: "\n")
  }

  func getWins(line: String) -> [String] {
    let tmp = line.components(separatedBy: "|")
    let winningNumbers = tmp[0].components(separatedBy: ":")[1].components(separatedBy: " ")
      .filter { !$0.isEmpty }
    let givenNumbers = tmp[1].components(separatedBy: " ").filter { !$0.isEmpty }

    return givenNumbers.filter { winningNumbers.contains($0) }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {

    var result: Int = 0

    for line in entities {
      let wins = getWins(line: line)

      result += Int(pow(Double(2), Double(wins.count - 1)))
    }

    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var cards: [Int: Int] = [:]
    for (index, line) in entities.enumerated() {
      cards[index, default: 0] += 1
      let wins = getWins(line: line)
      if wins.isEmpty {
        continue
      }
      let range = 1...wins.count
      for i in range {
        cards[index + i, default: 0] += cards[index]!
      }
    }

    var result: Int = 0
    for (_, value) in cards {
      result += value
    }

    return result
  }
}
