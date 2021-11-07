//
//  Constants.swift
//  lixx4090_a5
//
//  Created by Calvin Li on 2021-03-24.
//

import Foundation

struct GameConstants {
    static let game = GameConstants()
    static let InvaderSpeed : Double = 1.0 //lower is faster
    static let SpaceShipBulletSpeed : Double = 2.0
    static let InvaderBulletSpeed : Double = 4.0
    static let InvaderBulletFrequency = 1.0
    static let colKey = "colKey"
    static let rowKey = "rowKey"
    static let aliveKey = "alive"
    static let movingKey = "moving"
    static var GameLevel = [InvaderSet]()
    
    func reset() {
        GameConstants.GameLevel = [
            InvaderSet(rowCount: 1, colCount: 1), // Level 1
            InvaderSet(rowCount: 1, colCount: 4), // Level 2
            InvaderSet(rowCount: 4, colCount: 7)  // Level 3
        ]
    }
    
    
        
}
