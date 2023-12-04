import Algorithms
import RegexBuilder

struct Day03: AdventDay {
  // Save your data in a corresponding text file in the `Data` directory.
  var data: String

  // Splits input data into its component parts and convert from string.
  var entities: [String] {
    data.components(separatedBy: "\n")
  }

  struct Number {
    var number: Int
    var lowerIndex: Int
    var upperIndex: Int
    var isPartNumber: Bool = false
  }

  struct Symbol {
    var xIndex: Int
    var adjacentNumbers: [Int] = []
  }

  func getRelevantIndices(symbolIndex: Int) -> [Int] {
    var relevantIndices: [Int] = []
    if symbolIndex > 0 {
      relevantIndices.append(symbolIndex - 1)
    }
    relevantIndices.append(symbolIndex)
    if symbolIndex < entities[0].count - 1 {
      relevantIndices.append(symbolIndex + 1)
    }
    return relevantIndices
  }

  func getNumbersAdjecentToSymbol(numberDictPar: [Int: [Number]], symbolDict: [Int: [Int]]) -> [Int]
  {
    var partNumbers: [Int] = []
    var numberDict = numberDictPar

    for (lineIndex, columnIndices) in symbolDict {
      for columnIndex in columnIndices {
        if lineIndex > 0 {
          for (numberIndex, number) in numberDict[lineIndex - 1]!.enumerated() {
            let numberIndices = number.lowerIndex...number.upperIndex
            let relevantIndices = getRelevantIndices(symbolIndex: columnIndex)
            if relevantIndices.contains(where: { numberIndices.contains($0) }) {
              numberDict[lineIndex - 1]![numberIndex].isPartNumber = true
            }
          }
        }
        for (numberIndex, number) in numberDict[lineIndex]!.enumerated() {
          let numberIndices = number.lowerIndex...number.upperIndex
          var relevantIndices = [columnIndex - 1]
          if columnIndex < entities[0].count - 1 {
            relevantIndices.append(columnIndex + 1)
          }
          if relevantIndices.contains(where: { numberIndices.contains($0) }) {
            numberDict[lineIndex]![numberIndex].isPartNumber = true
          }
        }
        if lineIndex < numberDictPar.count - 1 {
          for (numberIndex, number) in numberDict[lineIndex + 1]!.enumerated() {
            let numberIndices = number.lowerIndex...number.upperIndex
            let relevantIndices = getRelevantIndices(symbolIndex: columnIndex)
            if relevantIndices.contains(where: { numberIndices.contains($0) }) {
              numberDict[lineIndex + 1]![numberIndex].isPartNumber = true
            }
          }
        }
      }
    }

    for (_, numbers) in numberDict {
      for number in numbers {
        if number.isPartNumber {
          partNumbers.append(number.number)
        }
      }
    }

    return partNumbers
  }

  func getNumbersAdjecentToSymbolForPart2(
    numberDictPar: [Int: [Number]], symbolDict: [Int: [Symbol]]
  )
    -> [Int]
  {
    var partNumbers: [Int] = []
    let numberDict = numberDictPar
    var symbolDictMut = symbolDict

    for (lineIndex, symbols) in symbolDict {
      for (symbolIndex, symbol) in symbols.enumerated() {
        if lineIndex > 0 {
          for (_, number) in numberDict[lineIndex - 1]!.enumerated() {
            let numberIndices = number.lowerIndex...number.upperIndex
            let relevantIndices = getRelevantIndices(symbolIndex: symbol.xIndex)
            if relevantIndices.contains(where: { numberIndices.contains($0) }) {
              symbolDictMut[lineIndex]![symbolIndex].adjacentNumbers.append(number.number)
            }
          }
        }
        for (_, number) in numberDict[lineIndex]!.enumerated() {
          let numberIndices = number.lowerIndex...number.upperIndex
          var relevantIndices = [symbol.xIndex - 1]
          if symbol.xIndex < entities[0].count - 1 {
            relevantIndices.append(symbol.xIndex + 1)
          }
          if relevantIndices.contains(where: { numberIndices.contains($0) }) {
            symbolDictMut[lineIndex]![symbolIndex].adjacentNumbers.append(number.number)
          }
        }
        if lineIndex < numberDictPar.count - 1 {
          for (_, number) in numberDict[lineIndex + 1]!.enumerated() {
            let numberIndices = number.lowerIndex...number.upperIndex
            let relevantIndices = getRelevantIndices(symbolIndex: symbol.xIndex)
            if relevantIndices.contains(where: { numberIndices.contains($0) }) {
              symbolDictMut[lineIndex]![symbolIndex].adjacentNumbers.append(number.number)
            }
          }
        }
      }
    }

    for (_, symbols) in symbolDictMut {
      for symbol in symbols {
        print(symbol.adjacentNumbers)
        if symbol.adjacentNumbers.count == 2 {
          partNumbers.append(symbol.adjacentNumbers.reduce(1, { $0 * $1 }))
        }
      }
    }

    return partNumbers
  }

  let numberRegex = Regex {
    Capture {
      OneOrMore(.digit)
    }
  }

  // Replace this with your solution for the first part of the day's challenge.
  func part1() -> Any {
    // Calculate the sum of the first set of input data
    print("inside day3 part1")

    let charRegex = #/[^.^0-9]/#

    var symbolDict: [Int: [Int]] = [:]
    var numberDict: [Int: [Number]] = [:]
    for (index, line) in entities.enumerated() {
      symbolDict[index] = []
      numberDict[index] = []

      let charMatches = line.matches(of: charRegex)
      for match in charMatches {
        let symbolIndex = line.distance(from: line.startIndex, to: match.range.lowerBound)

        symbolDict[index]!.append(symbolIndex)
      }

      let numberMatches = line.matches(of: numberRegex)
      for match in numberMatches {
        let numberLowerIndex = line.distance(from: line.startIndex, to: match.range.lowerBound)
        let numberUpperIndex = line.distance(from: line.startIndex, to: match.range.upperBound)

        numberDict[index]!.append(
          Number(
            number: Int(match.1)!, lowerIndex: Int(numberLowerIndex),
            upperIndex: Int(numberUpperIndex) - 1))
      }
    }

    let partNumbers = getNumbersAdjecentToSymbol(numberDictPar: numberDict, symbolDict: symbolDict)

    return partNumbers.reduce(0, { $0 + $1 })
  }

  // Replace this with your solution for the second part of the day's challenge.
  func part2() -> Any {

    var symbolDict: [Int: [Symbol]] = [:]
    var numberDict: [Int: [Number]] = [:]
    for (index, line) in entities.enumerated() {
      symbolDict[index] = []
      numberDict[index] = []
      for (charIndex, char) in line.enumerated() {
        if char == "*" {
          symbolDict[index]!.append(Symbol(xIndex: charIndex))
        }
      }
      let numberMatches = line.matches(of: numberRegex)
      for match in numberMatches {
        let numberLowerIndex = line.distance(from: line.startIndex, to: match.range.lowerBound)
        let numberUpperIndex = line.distance(from: line.startIndex, to: match.range.upperBound)

        numberDict[index]!.append(
          Number(
            number: Int(match.1)!, lowerIndex: Int(numberLowerIndex),
            upperIndex: Int(numberUpperIndex) - 1))
      }
    }

    let partNumbers = getNumbersAdjecentToSymbolForPart2(
      numberDictPar: numberDict, symbolDict: symbolDict)

    return partNumbers.reduce(0, { $0 + $1 })
  }
}
