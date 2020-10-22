//
//  File.swift
//
//
//  Created by Ezekiel Elin on 10/21/20.
//

import Foundation
import Algorithms

struct Day13: Day {
    struct Pair: Hashable, Equatable {
        let x: Int
        let y: Int
    }

    func run(input: String) {
        let program = input.filter { !$0.isWhitespace }.split(separator: ",").map { str in
            return Int(str)!
        }

        process(program: program, first: true)
        process(program: program, first: false)
    }

    func process(program: [Int], first: Bool) {
        let output = BufferedIO()
        let input = BufferedIO()
        var computer = IntcodeState(memory: program, input: input, output: output)
        if !first {
            computer.memory[0] = 2 // insert coin
        }

        var screen = [Pair: Int]()
        var score = 0

        while !computer.halted {
            computer = IntcodeState.advanceMulti(computer)

            while let x = output.read(), let y = output.read(), let tileID = output.read() {
                if x == -1 && y == 0 {
                    score = tileID
                } else {
                    screen[Pair(x: x, y: y)] = tileID
                }
            }

            let ballX = screen.first { $0.value == 4 }!.key.x
            let paddleX = screen.first { $0.value == 3 }!.key.x

            if ballX > paddleX {
                input.write(1)
            } else if ballX < paddleX {
                input.write(-1)
            } else {
                input.write(0)
            }
        }

        if first {
            print(screen.values.filter { $0 == 2 }.count)
        } else {
            print(score)
        }
    }
}
