//
//  Invader.swift
//  lixx4090_a5
//
//  Created by Calvin Li on 2021-03-23.
//

import SpriteKit
import Foundation

struct Invader
{
    var node = SKSpriteNode()
    var col = Int()
    var row = Int()
    var isAlive = Bool()
    
    init(node: SKSpriteNode, row: Int, col:Int)
    {
        self.node = node
        self.row = row
        self.col = col
    }
}
