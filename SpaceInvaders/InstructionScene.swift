//
//  InstructionScene.swift
//  lixx4090_a5
//
//  Created by Calvin Li on 2021-03-23.
//

import SpriteKit

class instructionScene: SKScene
{
    var backButton : SKSpriteNode?
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor.white
        
        let label = SKLabelNode(fontNamed: "Courier")
        label.fontColor = SKColor.black
        label.fontSize = 22
        label.text = "Shoot at the invaders!!"
        label.position =  CGPoint(x:self.frame.maxX * 0.5, y:self.frame.maxY * 0.55);
        self.addChild(label)
        
        let label2 = SKLabelNode(fontNamed: "Courier")
        label2.fontColor = SKColor.black
        label2.fontSize = 20
        label2.text = "Don't let the rock hit you!"
        label2.position =  CGPoint(x:self.frame.maxX * 0.5, y:self.frame.maxY * 0.5);
        self.addChild(label2)
        
        backButton = SKSpriteNode(imageNamed: "goBack.png")
        backButton!.name="backButton"
        backButton!.position = CGPoint(x:self.frame.maxX * 0.5, y:self.frame.maxY * 0.45);
        backButton?.xScale = 0.6
        backButton?.yScale = 0.6
        self.addChild(backButton!)
    } //init
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let theNode = self.atPoint(location)
            if theNode.name == backButton!.name {
//                print("The \(backButton!.name!) is touched ")
                let transition = SKTransition.moveIn(with: SKTransitionDirection.up, duration: 0.5)
                let gameScene = MenuScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            }
            // println("touch outside")
        }
    } //touchesBegan
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
