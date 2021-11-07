//
//  GameScene.swift
//  lixx4090_a5
//
//  Created by Calvin Li on 2021-03-23.
//

import SpriteKit
import GameplayKit
import AVFoundation

class MenuScene: SKScene {
    
    var playGameButton : SKSpriteNode?
    var instructionButton : SKSpriteNode?
    var playMusicButton : SKSpriteNode?
    var stopMusicButton : SKSpriteNode?
    
    override func didMove(to view: SKView) {
        
        GameConstants.game.reset() //reset game when menu is displayed

        backgroundColor = SKColor.white
        playGameButton = SKSpriteNode(imageNamed: "PlayButton.png")
        playGameButton!.name="playGameButton"
        playGameButton!.position = CGPoint(x:size.width * 0.5 , y:size.height * 0.7);
        self.addChild(playGameButton!)
        
        instructionButton = SKSpriteNode(imageNamed: "InstructionButton.png")
        instructionButton!.name="instructionButton"
        instructionButton!.position = CGPoint(x:size.width * 0.5 , y:size.height * 0.6);
        self.addChild(instructionButton!)
        
        playMusicButton = SKSpriteNode(imageNamed: "PlayMusic.png")
        playMusicButton!.name="playMusicButton"
        playMusicButton!.position = CGPoint(x:size.width * 0.5 , y:size.height * 0.5);
        self.addChild(playMusicButton!)
        
        stopMusicButton = SKSpriteNode(imageNamed: "StopMusic.png")
        stopMusicButton!.name="stopMusicButton"
        stopMusicButton!.position = CGPoint(x:size.width * 0.495 , y:size.height * 0.4);
        self.addChild(stopMusicButton!)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let theNode = self.atPoint(location)
            if theNode.name == instructionButton!.name {
//                print("The \(instructionButton!.name!) is touched ")
                let transition = SKTransition.moveIn(with: SKTransitionDirection.up, duration: 0.5)
                let gameScene = instructionScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            }
            else if theNode.name == playMusicButton!.name
            {
//                print("The \(playMusicButton!.name!) is touched ")
                Music.music.playBackgroundMusic(filename: "spaceinvaders-background.mp3")
            }
            else if theNode.name == stopMusicButton!.name
            {
//                print("The \(stopMusicButton!.name!) is touched ")
                Music.music.stopBackgroundMusic()
            }
            else if theNode.name == playGameButton!.name
            {
//                print("The \(playGameButton!.name!) is touched ")
                let transition = SKTransition.moveIn(with: SKTransitionDirection.up, duration: 0.5)
                let gameScene = GameScene(size: self.size, levelCount: 1)
                self.view?.presentScene(gameScene, transition: transition)
            }
            // println("touch outside")
        }
    } //touchesBegan
    
}
