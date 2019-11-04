//
//  GameManager.swift
//  Conway's-Game-of-Life
//
//  Created by Artur Carneiro on 01/11/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import Foundation


final class GameManager {
    private init() {
    }
    
    static let shared = GameManager()
    
    public var grid: [[Bool]] = Array(repeating: Array(repeating: false, count: 16), count:16)
    public var survivors: [(Int, Int)] = []
    public var dead: [(Int, Int)] = []

    func round(row: Int, column: Int) {
        let amountOfNeighbours: Int = checkNeighbours(row: row, column: column)
        if amountOfNeighbours < 2 {
            dead.append((row,column))
        } else if amountOfNeighbours >= 2 && amountOfNeighbours <= 3 {
            if amountOfNeighbours == 3 {
                survivors.append((row,column))
            }
        } else {
            dead.append((row, column))
        }
    }

    func gameLoop() {
        for i in 0..<grid.count {
            for j in 0..<grid[0].count {
                round(row: i, column: j)
            }
        }
        setNewGrid(survivors: survivors, dead: dead)
    }

    func setNewGrid(survivors: [(Int,Int)], dead: [(Int,Int)] ) {
        for i in survivors {
            grid[i.0][i.1] = true
        }
        for j in dead {
            grid[j.0][j.1] = false
        }
    }

    func clearGenerationArray() {
        survivors.removeAll(keepingCapacity: false)
        dead.removeAll(keepingCapacity: false)
    }

    func checkNeighbours(row: Int, column: Int) -> Int {
        let maxRow = grid.count - 1
        var numberOfNeighbours = 0
        if (maxRow > 0) {
            let maxColumn = grid[0].count - 1
            let x = max(0, row - 1)
            let y = max(0, column - 1)
            
            for x in x...min(row + 1, maxRow) {
                for y in y...min(column + 1, maxColumn) {
                    if (x != row || y != column) {
                        if (grid[x][y] == true) {
                             numberOfNeighbours += 1
                        }
                    }
                }
            }
        }
        return numberOfNeighbours
    }

    func spawnBeing(row: Int, column: Int ) {
        grid[row][column] = true
    }


}

