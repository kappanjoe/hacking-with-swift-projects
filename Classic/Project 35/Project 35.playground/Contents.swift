import UIKit

// Basic RNG (insecure)

let int1 = Int.random(in: 0...10)
let int2 = Int.random(in: 0..<10)
let double1 = Double.random(in: 1000...10000)
let float1 = Float.random(in: -100...100)
let bool1 = Bool.random()

// Classic RNG

print(arc4random())
print(arc4random() % 6) // Introduces modulo bias
print(arc4random_uniform(6)) // Generates within a range between 0 and _
print(arc4random())

import GameplayKit

// Random Source -> an unfiltered stream of random numbers

print(GKRandomSource.sharedRandom().nextInt()) // Between -2,147,483,648 and 2,147,483,647; not guaranteed random
print(GKRandomSource.sharedRandom().nextInt(upperBound: 6)) // Same as arc4random()
// Other methods: .nextBool(), .nextUniform()

// Other sources:
// GKLinearCongruentialRandomSource - High performance, Low randomness
// GKMersenneTwisterRandomSource - Low performance, High randomness
// GKARC4RandomSource - "Goldilocks" random source

let arc4 = GKARC4RandomSource()
arc4.nextInt(upperBound: 20)
arc4.dropValues(1024) // Recommended to drop at least 769 first values to ensure true randomness

let mersenne = GKMersenneTwisterRandomSource()
mersenne.nextInt(upperBound: 20)

// Dice are included

let d6 = GKRandomDistribution.d6()
d6.nextInt()

let d20 = GKRandomDistribution.d20()
d20.nextInt()

// 11,539-sided die
let wild = GKRandomDistribution(lowestValue: 1, highestValue: 11539) // Inclusive of min/max
wild.nextInt()

// This will crash:
// let distribution = GKRandomDistribution(lowestValue: 10, highestValue: 20)
// print(distribution.nextInt(upperBound: 9))

// Specify random source
let rand = GKMersenneTwisterRandomSource()
let distribution = GKRandomDistribution(randomSource: rand, lowestValue: 10, highestValue: 20)
print(distribution.nextInt())


// Weighted distributions

let shuffled = GKShuffledDistribution.d6() // Every number will appear an equal number of times
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())
print(shuffled.nextInt())

let gaussian = GKGaussianDistribution.d20() // Biased toward the mean average of the range
print(gaussian.nextInt())
print(gaussian.nextInt())
print(gaussian.nextInt())
print(gaussian.nextInt())
print(gaussian.nextInt())
print(gaussian.nextInt())

// Shuffling Arrays

// Fisher-Yates algorithm (as implemented by Nate Cook) - shuffles in place
extension Array {
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            swapAt(i, j)
        }
    }
}

let lotteryBalls = [Int](1...49)
let shuffledBalls = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lotteryBalls)
print(shuffledBalls[0])
print(shuffledBalls[1])
print(shuffledBalls[2])
print(shuffledBalls[3])
print(shuffledBalls[4])
print(shuffledBalls[5])

// To fix the lottery... (using a seed value)

let fixedLotteryBalls = [Int](1...49)
let fixedShuffledBalls = GKMersenneTwisterRandomSource(seed: 1001).arrayByShufflingObjects(in: fixedLotteryBalls)
print(fixedShuffledBalls[0])
print(fixedShuffledBalls[1])
print(fixedShuffledBalls[2])
print(fixedShuffledBalls[3])
print(fixedShuffledBalls[4])
print(fixedShuffledBalls[5])
