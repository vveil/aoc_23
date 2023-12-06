import Algorithms
import Foundation
import RegexBuilder

struct Day06: AdventDay {
  var data: String

  var entities: [String] {
    data.components(separatedBy: "\n")
  }

  func countWinsByChatGPT(time: Int, distance: Int) -> Int {
    let discriminant = Double(time * time - 4 * distance)
    guard discriminant >= 0 else { return 0 }

    let sqrtDiscriminant = sqrt(discriminant)
    let i1 = Double(time) / 2 - sqrtDiscriminant / 2
    let i2 = Double(time) / 2 + sqrtDiscriminant / 2

    let lowerBound = max(0, Int(ceil(i1)))
    let upperBound = min(time, Int(floor(i2)))

    return max(0, (upperBound - lowerBound) + 1)
  }

  func getWinPossibilitiesWithChatGPTsHelp(times: [Int], distances: [Int]) -> [Int] {
    var winPossibilities: [Int] = []
    for (index, time) in times.enumerated() {
      winPossibilities.append(countWinsByChatGPT(time: time, distance: distances[index]))
    }
    return winPossibilities
  }

  func getWinPossibilities(times: [Int], distances: [Int]) -> [Int] {
    var winPossibilities: [Int] = []
    for (index, time) in times.enumerated() {
      let distance = distances[index]

      var wins: Int = 0
      for i in 0..<time {
        let travelDistance = i * (time - i)
        if travelDistance > distance {
          wins += 1
        }
      }
      winPossibilities.append(wins)
    }
    return winPossibilities
  }

  func part1() -> Any {

    let times = entities[0].split(separator: " ")
      .compactMap { Int($0) }
    let distances = entities[1].split(separator: " ").compactMap { Int($0) }

    return getWinPossibilities(times: times, distances: distances).reduce(
      1, { $0 * $1 })
  }

  func part2() -> Any {

    let time = Int(
      entities[0].split(separator: " ")[1...]
        .compactMap { String($0) }
        .joined())!
    let distance = Int(
      entities[1].split(separator: " ")[1...].compactMap { String($0) }
        .joined())!

    return getWinPossibilities(times: [time], distances: [distance]).reduce(
      1, { $0 * $1 })
  }
}
