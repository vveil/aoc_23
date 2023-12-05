import Algorithms
import Foundation
import RegexBuilder

struct Day05: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
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

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {

    let testString = """
      seeds: 79 14 55 13

      seed-to-soil map:
      50 98 2
      52 50 48

      soil-to-fertilizer map:
      0 15 37
      37 52 2
      39 0 15

      fertilizer-to-water map:
      49 53 8
      0 11 42
      42 0 7
      57 7 4

      water-to-light map:
      88 18 7
      18 25 70

      light-to-temperature map:
      45 77 23
      81 45 19
      68 64 13

      temperature-to-humidity map:
      0 69 1
      1 0 69

      humidity-to-location map:
      60 56 37
      56 93 4
      """
    let test = testString.components(separatedBy: "\n\n")

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

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {

    return []
  }
}
