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

    var numbers: [Int] = []
    for line in entities {
      var firstDigitTest: Int = 0
      if let firstDigit = line.first(where: { $0.isNumber }) {
        firstDigitTest = Int(String(firstDigit))! * 10
      }
      if let lastDigit = line.last(where: { $0.isNumber }) {
        numbers.append(firstDigitTest + Int(String(lastDigit))!)
      }
    }

    return numbers.reduce(0, { $0 + $1 })
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    // Sum the maximum entries in each set of data
    // entities.map { $0.max() ?? 0 }.reduce(0, +)
    print("inside day1 part2")
  }
}
