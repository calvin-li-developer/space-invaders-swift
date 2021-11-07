//
//  InvaderSet.swift
//  lixx4090_a5
//
//  Created by Calvin Li on 2021-03-25.
//

import Foundation
import SpriteKit

class InvaderSet
{
    var invaders = [[Invader]]()
    var rowCount = Int()
    var colCount = Int()
    
    init(rowCount: Int, colCount: Int) {
        self.rowCount = rowCount
        self.colCount = colCount
        generateInvader()
    }
    
    func generateInvader()
    {
        for row in 0..<self.rowCount
        {
            self.invaders.append([])
            for col in 0..<self.colCount
            {
                let r = row
                let c = col
                //Setup InvaderNode
                let invaderNode = SKSpriteNode(imageNamed: "space-invader-small.png")
                invaderNode.name="invader" + String(row) + String(col)
                invaderNode.userData = NSMutableDictionary()
                invaderNode.userData?.setObject(r, forKey: GameConstants.rowKey as NSCopying) // row of the invader
                invaderNode.userData?.setObject(c, forKey: GameConstants.colKey as NSCopying) // column of the invader
                invaderNode.userData?.setObject(true, forKey: GameConstants.aliveKey as NSCopying)
                //Setup Invader Class
                let invader = Invader(node: invaderNode, row: row, col: col)
                self.invaders[r].append(invader)
            }
        }
    }
}
