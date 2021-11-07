//
//  LoseScene.swift
//  lixx4090_a5
//
//  Created by Calvin Li on 2021-03-25.
//

import Foundation
import SpriteKit

class LoseScene: SKScene
{
    override init(size: CGSize)
    {
        super.init(size: size)
        backgroundColor = SKColor.white
        
        let label = SKLabelNode(fontNamed: "Courier")
        label.fontColor = SKColor.black
        label.fontSize = 24
        label.text = "You Lose!!"
        label.position =  CGPoint(x:self.frame.maxX * 0.5, y:self.frame.maxY * 0.5);
        self.addChild(label)
        
        run(SKAction.sequence([
            SKAction.wait(forDuration: 2.5),
            SKAction.run() {
            // 5
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            let scene = MenuScene(size: size)
            self.view?.presentScene(scene, transition:reveal)
          }
        ]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
