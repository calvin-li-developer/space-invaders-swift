//
//  PhysicsCategories.swift
//  lixx4090_a5
//
//  Created by Calvin Li on 2021-03-24.
//

import Foundation

struct PhysicsCategory
{
    static let None         : UInt32 = 0
    static let All          : UInt32 = UInt32.max
    static let Invader      : UInt32 = 0b1       // 1
    static let PlayerBullet : UInt32 = 0b10      // 2
    static let Shelter      : UInt32 = 0b11      // 3
    static let SpaceShip    : UInt32 = 0b100     // 4
    static let InvaderBullet: UInt32 = 0b101     // 5
}
