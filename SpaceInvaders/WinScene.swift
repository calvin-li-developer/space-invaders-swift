//
//  WinScene.swift
//  lixx4090_a5
//
//  Created by Calvin Li on 2021-03-24.
//

import Foundation
import SpriteKit

class WinScene: SKScene
{
    init(size: CGSize, levelCount: Int) {
        super.init(size: size)
        backgroundColor = SKColor.white
        
        
        let label = SKLabelNode(fontNamed: "Courier")
        label.fontColor = SKColor.black
        label.fontSize = 24
        label.text = "You Win!!"
        label.position =  CGPoint(x:self.frame.maxX * 0.5, y:self.frame.maxY * 0.55);
        self.addChild(label)
        
        // 4
        if levelCount <= GameConstants.GameLevel.count
        {
            let label2 = SKLabelNode(fontNamed: "Courier")
            label2.fontColor = SKColor.black
            label2.fontSize = 22
            label2.text = "Go to \(levelCount) Round"
            label2.position =  CGPoint(x:self.frame.maxX * 0.5, y:self.frame.maxY * 0.5);
            self.addChild(label2)
            
            run(SKAction.sequence([
                SKAction.wait(forDuration: 2.5),
                SKAction.run() {
                // 5
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let scene = GameScene(size: size,levelCount: levelCount)
                self.view?.presentScene(scene, transition:reveal)
              }
            ]))
        }
        else
        {
            let label2 = SKLabelNode(fontNamed: "Courier")
            label2.fontColor = SKColor.black
            label2.fontSize = 22
            label2.text = "Go Back to Menu..."
            label2.position =  CGPoint(x:self.frame.maxX * 0.5, y:self.frame.maxY * 0.5);
            self.addChild(label2)
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
        
    } //init
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
