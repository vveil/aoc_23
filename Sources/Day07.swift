import Algorithms
import Foundation
import RegexBuilder

struct Day07: AdventDay {
  var data: String

  var entities: [String] {
    data.components(separatedBy: "\n")
  }

  let testData = """
    32T3K 765
    T55J5 684
    QQQJA 483
    KK677 28
    KTJJT 220
    """.components(separatedBy: "\n")

  func getBaseHandValue(hand: String, isPart2: Bool = false) -> Int {
    var charCounts = hand.reduce(into: [Character: Int]()) { counts, char in
      counts[char, default: 0] += 1
    }

    var counts = Set(charCounts.values)
    if isPart2 {
      let jokerCount = charCounts["J", default: 0]
      charCounts.removeValue(forKey: "J")
      counts = Set(charCounts.values)

      if jokerCount > 0 {
        if charCounts.filter({ $0.value == 2 }).count == 2 {
          counts = [3, 2]
        } else if jokerCount == 5 {
          counts = [5]
        } else if let highestValue = counts.max() {
          counts.remove(highestValue)
          counts.insert(highestValue + jokerCount)
        }
      }
    }

    if counts.contains(5) {
      return 7
    } else if counts.contains(4) {
      return 6
    } else if counts.contains(3) && counts.contains(2) {
      return 5
    } else if counts.contains(3) {
      return 4
    } else if charCounts.filter({ $0.value == 2 }).count == 2 {
      return 3
    } else if counts.contains(2) {
      return 2
    } else {
      return 1
    }
  }

  func compareCards(hand1: String, hand2: String, cards: [String: Int]) -> Bool {
    for (card1, card2) in zip(hand1, hand2) {
      if let value1 = cards[String(card1)], let value2 = cards[String(card2)] {
        if value1 != value2 {
          return value1 < value2
        }
      }
    }
    return false
  }

  struct HandInfo {
    var hand: String
    var bid: Int
  }

  func part1() -> Any {

    let cards: [String: Int] = [
      "A": 14,
      "K": 13,
      "Q": 12,
      "J": 11,
      "T": 10,
      "9": 9,
      "8": 8,
      "7": 7,
      "6": 6,
      "5": 5,
      "4": 4,
      "3": 3,
      "2": 2,
    ]

    let hands = entities.map({ $0.components(separatedBy: " ") })

    var baseValueHands: [Int: [HandInfo]] = [:]
    for hand in hands {
      let value = getBaseHandValue(hand: hand[0])
      baseValueHands[value, default: []].append(
        HandInfo(hand: hand[0], bid: Int(hand[1])!))
    }
    var allBidsSorted: [Int] = []
    for index in baseValueHands.keys.sorted() {
      let sorted = baseValueHands[index]!.sorted(by: {
        compareCards(hand1: $0.hand, hand2: $1.hand, cards: cards)
      })
      for info in sorted {
        allBidsSorted.append(info.bid)
      }
    }

    return allBidsSorted.enumerated().map({ index, bid in
      return (index + 1) * bid
    }).reduce(0, { $0 + $1 })
  }

  func part2() -> Any {

    let cards: [String: Int] = [
      "A": 14,
      "K": 13,
      "Q": 12,
      "T": 10,
      "9": 9,
      "8": 8,
      "7": 7,
      "6": 6,
      "5": 5,
      "4": 4,
      "3": 3,
      "2": 2,
      "J": -1,
    ]

    let hands = entities.map({ $0.components(separatedBy: " ") })

    var baseValueHands: [Int: [HandInfo]] = [:]
    for hand in hands {
      let value = getBaseHandValue(hand: hand[0], isPart2: true)
      baseValueHands[value, default: []].append(
        HandInfo(hand: hand[0], bid: Int(hand[1])!))
    }
    var allBidsSorted: [Int] = []
    for index in baseValueHands.keys.sorted() {
      let sorted = baseValueHands[index]!.sorted(by: {
        compareCards(hand1: $0.hand, hand2: $1.hand, cards: cards)
      })
      for info in sorted {
        allBidsSorted.append(info.bid)
      }
    }

    return allBidsSorted.enumerated().map({ index, bid in
      return (index + 1) * bid
    }).reduce(0, { $0 + $1 })
  }
}
