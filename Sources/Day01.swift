import Algorithms

struct Day01: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.components(separatedBy: "\n")
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    // Calculate the sum of the first set of input data
    print("inside day1 part1")

    // var numbers: [Int] = []
    // for line in entities {
    //   var firstDigitTest: Int = 0
    //   if let firstDigit = line.first(where: { $0.isNumber }) {
    //     firstDigitTest = Int(String(firstDigit))! * 10
    //   }
    //   if let lastDigit = line.last(where: { $0.isNumber }) {
    //     numbers.append(firstDigitTest + Int(String(lastDigit))!)
    //   }
    // }

    // return numbers.reduce(0, { $0 + $1 })
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    let digits: [Int: String] = [
      1: "one",
      2: "two",
      3: "three",
      4: "four",
      5: "five",
      6: "six",
      7: "seven",
      8: "eight",
      9: "nine",
    ]

    var numbers: [Int] = []

    let test: [String] = [
      ""
      // "bbzhsmnmtf8kftwosevenxfkssgrcjthree",
    ]

    print(entities.count)
    for line in entities {
      // find first digit (int or string)
      var firstDigit: Int = 0
      var lowestBound: String.Index = line.endIndex
      for (key, value) in digits {
        if let keyRange = line.range(of: String(key)) {
          if keyRange.lowerBound < lowestBound {
            lowestBound = keyRange.lowerBound
            firstDigit = key * 10
          }

        }
        if let valueRange = line.range(of: value) {
          if valueRange.lowerBound < lowestBound {
            lowestBound = valueRange.lowerBound
            firstDigit = key * 10
          }
        }
      }

      // find last digit (int or string)
      var lastDigit: Int = 0
      var uppestBound: String.Index = line.startIndex
      for (key, value) in digits {
        if let keyRange = line.range(of: String(key)) {
          if keyRange.upperBound > uppestBound {
            uppestBound = keyRange.upperBound
            lastDigit = key
          }

        }
        if let valueRange = line.range(of: value) {
          if valueRange.upperBound > uppestBound {
            uppestBound = valueRange.upperBound
            lastDigit = key
          }
        }
      }

      numbers.append(firstDigit + lastDigit)
    }

    return numbers.reduce(0, { $0 + $1 })
  }
}
