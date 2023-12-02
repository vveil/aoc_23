import Algorithms
import RegexBuilder

struct Day02: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.components(separatedBy: "\n")
  }

  struct CubeCollection {
    var redCubes: Int = 12
    var blueCubes: Int = 14
    var greenCubes: Int = 13
  }

  func findCubeAmountByColor(reveals: [String]) -> [[String: Int]] {
    let amountRef = Reference(Int.self)
    let numberSearch = Regex {
      TryCapture(as: amountRef) {
        OneOrMore(.digit)
      } transform: { match in
        Int(match)
      }
    }

    var cubesAmountByColor: [[String: Int]] = []

    for reveal in reveals {
      var cubesShown: [String: Int] = ["red": 0, "blue": 0, "green": 0]
      let cubesShownString = reveal.components(separatedBy: ", ")
      for cubes in cubesShownString {
        if let amount = cubes.firstMatch(of: numberSearch) {
          if cubes.contains("red") {
            cubesShown["red"]! += amount[amountRef]
          }
          if cubes.contains("blue") {
            cubesShown["blue"]! += amount[amountRef]
          }
          if cubes.contains("green") {
            cubesShown["green"]! += amount[amountRef]
          }
        }
      }
      cubesAmountByColor.append(cubesShown)
    }

    return cubesAmountByColor
  }

  let gameSearch = #/Game (\d+): (.*)/#

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    // Calculate the sum of the first set of input data
    print("inside day2 part1")
    var validGames: [Int] = []

    var isGameValid: Bool = true
    for line in entities {
      isGameValid = true
      if let gameString = try? gameSearch.wholeMatch(in: line) {
        let reveals: [String] = gameString.2.components(separatedBy: "; ")

        let cubesAmountByColor = findCubeAmountByColor(reveals: reveals)
        for cubesAmount in cubesAmountByColor {
          if cubesAmount["red"]! > CubeCollection().redCubes
            || cubesAmount["blue"]! > CubeCollection().blueCubes
            || cubesAmount["green"]! > CubeCollection().greenCubes
          {
            isGameValid = false
          }
        }

        if isGameValid {
          validGames.append(Int(gameString.1)!)
        }
      }
    }

    print("validGames: \(validGames)")
    return validGames.reduce(0, { $0 + $1 })
  }

  func transformToArrayByColor(cubeAmountByColor: [[String: Int]], color: String) -> [Int] {
    var result: [Int] = []
    for cubeAmount in cubeAmountByColor {
      result.append(cubeAmount[color]!)
    }
    return result
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {
    var result: [Int] = []

    for line in entities {

      if let gameString = try? gameSearch.wholeMatch(in: line) {
        let reveals: [String] = gameString.2.components(separatedBy: "; ")

        let cubesAmountByColor = findCubeAmountByColor(reveals: reveals)
        let redCubes = transformToArrayByColor(cubeAmountByColor: cubesAmountByColor, color: "red")
        let blueCubes = transformToArrayByColor(
          cubeAmountByColor: cubesAmountByColor, color: "blue")
        let greenCubes = transformToArrayByColor(
          cubeAmountByColor: cubesAmountByColor, color: "green")

        result.append(redCubes.max()! * blueCubes.max()! * greenCubes.max()!)
      }

    }

    return result.reduce(0, { $0 + $1 })
  }
}
