import Algorithms
import Foundation
import RegexBuilder

struct Day05: AdventDay {
  var data: String

  var entities: [String] {
    data.components(separatedBy: "\n\n")
  }

  struct ConvertInfo {
    let startValue: Int
    let rangeLength: Int
    let resultStartValue: Int
  }

  func convert(toConvert: Int, convertInfos: [ConvertInfo]) -> Int {
    var result = toConvert
    for convertInfo in convertInfos {
      if result >= convertInfo.startValue
        && result <= convertInfo.startValue + convertInfo.rangeLength
      {
        result = convertInfo.resultStartValue + result - convertInfo.startValue
        break
      }
    }
    return result
  }

  func getMinLocation(convertInfos: [Int: [ConvertInfo]], seeds: [Int]) -> Int {
    var valuesToConvert: [Int] = []
    for index in convertInfos.keys.sorted() {
      if valuesToConvert.isEmpty {
        valuesToConvert = seeds
      }
      var convertedValues: [Int] = []
      for value in valuesToConvert {
        let converted = convert(toConvert: value, convertInfos: convertInfos[index]!)
        convertedValues.append(converted)
      }
      valuesToConvert = convertedValues
    }
    return valuesToConvert.min()!
  }

  func part1() -> Any {

    var maps = entities

    let seeds = maps.removeFirst().components(separatedBy: " ").dropFirst().compactMap { Int($0) }

    var convertInfos: [Int: [ConvertInfo]] = [:]

    for (index, map) in maps.enumerated() {
      let numberLines = map.components(separatedBy: "\n").dropFirst()
      convertInfos[index, default: []] = numberLines.map { line in
        let numbers = line.components(separatedBy: " ").compactMap { Int($0) }
        return ConvertInfo(
          startValue: numbers[1], rangeLength: numbers[2], resultStartValue: numbers[0])
      }
    }

    return getMinLocation(convertInfos: convertInfos, seeds: seeds)
  }

  func part2() -> Any {

    var maps = entities

    let seedNumbers = maps.removeFirst().components(separatedBy: " ").dropFirst().compactMap {
      Int($0)
    }

    // Pair each element with the next one
    var pairs = [(Int, Int)]()
    for i in stride(from: 0, to: seedNumbers.count, by: 2) {
      if i + 1 < seedNumbers.count {
        pairs.append((seedNumbers[i], seedNumbers[i + 1]))
      }
    }

    var seeds: [Int] = []
    for pair in pairs {
      for i in 0...pair.1 {
        seeds.append(pair.0 + i)
      }
    }

    var convertInfos: [Int: [ConvertInfo]] = [:]

    for (index, map) in maps.enumerated() {
      let numberLines = map.components(separatedBy: "\n").dropFirst()
      convertInfos[index, default: []] = numberLines.map { line in
        let numbers = line.components(separatedBy: " ").compactMap { Int($0) }
        return ConvertInfo(
          startValue: numbers[1], rangeLength: numbers[2], resultStartValue: numbers[0])
      }
    }

    return getMinLocation(convertInfos: convertInfos, seeds: seeds)
  }
}
