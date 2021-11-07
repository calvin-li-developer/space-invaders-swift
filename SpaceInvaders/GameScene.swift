//
//  GameScene.swift
//  lixx4090_a5
//
//  Created by Calvin Li on 2021-03-23.
//

import SpriteKit
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate
{
    //Game Node Objects
    var fireButton : SKSpriteNode?
    var leftButton : SKSpriteNode?
    var rightButton : SKSpriteNode?
    var spaceShip : SKSpriteNode?
    var shelter1 : SKSpriteNode?
    var shelter2 : SKSpriteNode?
    var spaceShipBullet : SKSpriteNode?
    var invaderBullet : SKSpriteNode?
    
    //Game Sounds
    var fireBulletSound: AVAudioPlayer!
    var crushSound: AVAudioPlayer!
    var screamSound: AVAudioPlayer!
    
    var invaderDirection = 1; // 1 - Move Right, 2 - Move Left
    var gameLevel = InvaderSet(rowCount: 1, colCount: 1)
    var levelCount = 1;
    var invaderCount = Int()
    var mostLeftBoundary = CGFloat()
    var mostRightBoundary = CGFloat()
    var invaderShooterArray = Array<Int>()
    var updateFrame = 0.0

    init(size: CGSize, levelCount: Int)
    {
        super.init(size: size)
        
        self.levelCount = levelCount
        gameLevel = GameConstants.GameLevel[levelCount-1]
        invaderCount = GameConstants.GameLevel[levelCount-1].rowCount * GameConstants.GameLevel[levelCount-1].colCount
        
        if self.levelCount == 3
        {
            //ADD 2 SHELTER
            shelter1 = SKSpriteNode(imageNamed: "shelter2.png")
            shelter1!.name="shelter1"
            shelter1!.position = CGPoint(x:self.frame.maxX * 0.25, y: self.frame.maxY * 0.25)
            shelter1!.physicsBody = SKPhysicsBody(circleOfRadius: shelter1!.size.width/2)
            shelter1!.physicsBody?.isDynamic = true
            shelter1!.physicsBody?.categoryBitMask = PhysicsCategory.Shelter
            shelter1!.physicsBody?.contactTestBitMask = PhysicsCategory.PlayerBullet
            shelter1!.physicsBody?.collisionBitMask = PhysicsCategory.None
            shelter1!.physicsBody?.usesPreciseCollisionDetection = true
            self.addChild(shelter1!)

            shelter2 = SKSpriteNode(imageNamed: "shelter2.png")
            shelter2!.name="shelter2"
            shelter2!.position = CGPoint(x:self.frame.maxX * 0.75, y: self.frame.maxY * 0.25)
            shelter2!.physicsBody = SKPhysicsBody(circleOfRadius: shelter2!.size.width/2)
            shelter2!.physicsBody?.isDynamic = true
            shelter2!.physicsBody?.categoryBitMask = PhysicsCategory.Shelter
            shelter2!.physicsBody?.contactTestBitMask = PhysicsCategory.PlayerBullet
            shelter2!.physicsBody?.collisionBitMask = PhysicsCategory.None
            shelter2!.physicsBody?.usesPreciseCollisionDetection = true
            self.addChild(shelter2!)
        }
        for _ in 0..<gameLevel.colCount
        {
            invaderShooterArray.append(gameLevel.rowCount-1)
        }
        
        backgroundColor = SKColor.black
        
        fireButton = SKSpriteNode(imageNamed: "bullet.jpeg")
        fireButton!.name="fireButton"
        fireButton!.position = CGPoint(x:self.frame.maxX * 0.5, y:(fireButton!.size.height * 0.3)/2+10)
        fireButton?.xScale = 0.7
        fireButton?.yScale = 0.3
        self.addChild(fireButton!)
        
        leftButton = SKSpriteNode(imageNamed: "left-arrow.png")
        leftButton!.name="leftButton"
        leftButton!.position = CGPoint(x:(leftButton!.size.width * 0.43)/2, y:(leftButton!.size.height * 0.314)/2+10)
        leftButton?.xScale = 0.43
        leftButton?.yScale = 0.314
        self.addChild(leftButton!)
        
        rightButton = SKSpriteNode(imageNamed: "right-arrow.png")
        rightButton!.name="rightButton"
        rightButton!.position = CGPoint(x:self.frame.maxX - ((rightButton!.size.width * 0.5602)/2), y:(rightButton!.size.height * 0.409)/2+10)
        rightButton?.xScale = 0.5602
        rightButton?.yScale = 0.409
        self.addChild(rightButton!)
        
        spaceShip = SKSpriteNode(imageNamed: "Spaceship.png")
        spaceShip!.name="spaceShip"
        spaceShip!.position = CGPoint(x:self.frame.maxX * 0.5, y:self.frame.maxY * 0.18)
        spaceShip?.xScale = 0.12
        spaceShip?.yScale = 0.12
        
        spaceShip!.physicsBody = SKPhysicsBody(rectangleOf: spaceShip!.size)
        spaceShip!.physicsBody?.isDynamic = true // 2
        spaceShip!.physicsBody?.categoryBitMask = PhysicsCategory.SpaceShip //
        spaceShip!.physicsBody?.contactTestBitMask = PhysicsCategory.Invader // Contact with Invader
        spaceShip!.physicsBody?.collisionBitMask = PhysicsCategory.None // No bouncing on collision
        spaceShip!.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(spaceShip!)
        
        var colDisplayFrame = 1
        var rowDisplayFrame = 0.9
        for row in 0..<gameLevel.rowCount
        {
            for col in 0..<gameLevel.colCount
            {
                gameLevel.invaders[row][col].node.position = CGPoint(x:self.frame.maxX * (0.1 * CGFloat(colDisplayFrame)), y:self.frame.maxY * CGFloat(rowDisplayFrame))
                gameLevel.invaders[row][col].node.physicsBody = SKPhysicsBody(rectangleOf: gameLevel.invaders[row][col].node.size) // define boundary of body
                gameLevel.invaders[row][col].node.physicsBody?.isDynamic = true // 2
                gameLevel.invaders[row][col].node.physicsBody?.categoryBitMask = PhysicsCategory.Invader //
                gameLevel.invaders[row][col].node.physicsBody?.contactTestBitMask = PhysicsCategory.PlayerBullet // Contact with bullet
                gameLevel.invaders[row][col].node.physicsBody?.collisionBitMask = PhysicsCategory.None // No bouncing on collision
                gameLevel.invaders[row][col].node.physicsBody?.usesPreciseCollisionDetection = true
                self.addChild(gameLevel.invaders[row][col].node)
                colDisplayFrame += 1
            }
            colDisplayFrame = 1
            rowDisplayFrame -= 0.05
        }
        
        // set the physical world
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    override func update(_ currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
        invaderShoot()
        moveInvader()
    }
   
    func invaderShoot()
    {
        if updateFrame == 60.0 / GameConstants.InvaderBulletFrequency
        {
            var randomCol = Int()
            
            for col in 0..<gameLevel.colCount
            {
                if invaderShooterArray[col] != -1 // if -1 the whole column is dead no invaders in that column
                {
                    for row in stride(from: gameLevel.rowCount-1, through: 0, by: -1)
                    {
                        let invaderIsAlive = gameLevel.invaders[row][col].node.userData?.object(forKey: GameConstants.aliveKey) as! Bool
                        
                        if invaderIsAlive
                        {
                            invaderShooterArray[col] = row
                            break
                        }
                        else if row == 0
                        {
                            invaderShooterArray[col] = -1
                        }
                    }
                }
            }

            repeat
            {
                randomCol = Int.random(in: 0..<gameLevel.colCount)
            }while invaderShooterArray[randomCol] == -1
            
            
            invaderBullet = SKSpriteNode(imageNamed: "rock.png")
            
            // row = invaderShooterArray[randomCol]
            // col = randomCol
            invaderBullet!.position = gameLevel.invaders[invaderShooterArray[randomCol]][randomCol].node.position
            invaderBullet!.yScale = 0.45
            invaderBullet!.xScale = 0.15
            
            invaderBullet!.physicsBody = SKPhysicsBody(circleOfRadius: invaderBullet!.size.width/2)
            invaderBullet!.physicsBody?.isDynamic = true
            invaderBullet!.physicsBody?.categoryBitMask = PhysicsCategory.InvaderBullet
            invaderBullet!.physicsBody?.contactTestBitMask = PhysicsCategory.SpaceShip | PhysicsCategory.Shelter | PhysicsCategory.PlayerBullet
            invaderBullet!.physicsBody?.collisionBitMask = PhysicsCategory.None
            invaderBullet!.physicsBody?.usesPreciseCollisionDetection = true
            addChild(invaderBullet!)
            
            let actionMove = SKAction.move(to: CGPoint(x: invaderBullet!.position.x, y: 0 - invaderBullet!.size.width/2), duration: GameConstants.InvaderBulletSpeed)
            let actionMoveDone = SKAction.removeFromParent()
            invaderBullet!.run(SKAction.sequence([actionMove, actionMoveDone]), withKey: GameConstants.movingKey)
            updateFrame = 0
        }
        updateFrame += 1
    }
    func moveInvader()
    {
        mostLeftBoundary = gameLevel.invaders[0][updateLeftBound()].node.position.x
        mostRightBoundary = gameLevel.invaders[0][updateRightBound()].node.position.x
        
        let invaderHalfWidth = gameLevel.invaders[0][0].node.size.width / 2
        let invaderYMovement = gameLevel.invaders[0][0].node.size.height * 2
        
        if invaderDirection == 1 //Move Right
        {
            if self.frame.maxX - invaderHalfWidth >= mostRightBoundary
            {
                for row in 0..<gameLevel.rowCount
                {
                    for col in 0..<gameLevel.colCount
                    {
                        let actionMove = SKAction.move(to: CGPoint(x: gameLevel.invaders[row][col].node.position.x + 10, y: gameLevel.invaders[row][col].node.position.y), duration: 0.1 * TimeInterval(GameConstants.InvaderSpeed))
                        gameLevel.invaders[row][col].node.run(SKAction.sequence([actionMove]))
                    }
                }
            }
            else
            {
                if levelCount != 1
                {
                    for row in 0..<gameLevel.rowCount
                    {
                        for col in 0..<gameLevel.colCount
                        {
                            let actionMove = SKAction.move(to: CGPoint(x: gameLevel.invaders[row][col].node.position.x , y: gameLevel.invaders[row][col].node.position.y - invaderYMovement), duration: 0.1 * TimeInterval(GameConstants.InvaderSpeed))
                            gameLevel.invaders[row][col].node.run(SKAction.sequence([actionMove]))
                        }
                    }
                }
                invaderDirection = 2 //Change to Left Movement
            }
        }
        else if invaderDirection == 2 //Move Left
        {
            if mostLeftBoundary >= invaderHalfWidth
            {
                for row in 0..<gameLevel.rowCount
                {
                    for col in 0..<gameLevel.colCount
                    {
                        let actionMove = SKAction.move(to: CGPoint(x: gameLevel.invaders[row][col].node.position.x - 10, y: gameLevel.invaders[row][col].node.position.y), duration: 0.1 * TimeInterval(GameConstants.InvaderSpeed))
                        gameLevel.invaders[row][col].node.run(SKAction.sequence([actionMove]))
                    }
                }
            }
            else
            {
                if levelCount != 1
                {
                    for row in 0..<gameLevel.rowCount
                    {
                        for col in 0..<gameLevel.colCount
                        {
                            let actionMove = SKAction.move(to: CGPoint(x: gameLevel.invaders[row][col].node.position.x , y: gameLevel.invaders[row][col].node.position.y - invaderYMovement), duration: 0.1 * TimeInterval(GameConstants.InvaderSpeed))
                            gameLevel.invaders[row][col].node.run(SKAction.sequence([actionMove]))
                        }
                    }
                }
                invaderDirection = 1 //Change to Right Movement
            }
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let theNode = self.atPoint(location)
            if theNode.name == leftButton!.name {
//                print("The \(leftButton!.name!) is touched ")
                moveLeft()
            }
            else if theNode.name == rightButton!.name {
//                print("The \(rightButton!.name!) is touched ")
                moveRight()
            }
            else if theNode.name == fireButton!.name {
//                print("The \(fireButton!.name!) is touched ")
                spaceShipFireBullet()
            }
            // println("touch outside")
        }
    } //touchesBegan
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            let theNode = self.atPoint(location)
            if theNode.name == spaceShip!.name {
//                print("The \(spaceShip!.name!) is touched ")
                let actionMove = SKAction.move(to: CGPoint(x: location.x, y: location.y), duration: TimeInterval(0))
                spaceShip!.run(SKAction.sequence([actionMove]))
            }
        }
    }
    
    func moveLeft()
    {
        if spaceShip!.position.x >= spaceShip!.size.width/2 + 5
        {
            let actionMove = SKAction.move(to: CGPoint(x: spaceShip!.position.x - 10, y: spaceShip!.position.y), duration: TimeInterval(0))
            spaceShip!.run(SKAction.sequence([actionMove]))
        }
    }
    
    func moveRight()
    {
        if self.frame.maxX - spaceShip!.size.width/2 - 5 >= spaceShip!.position.x
        {
            let actionMove = SKAction.move(to: CGPoint(x: spaceShip!.position.x + 10, y: spaceShip!.position.y), duration: TimeInterval(0))
            spaceShip!.run(SKAction.sequence([actionMove]))
        }
    }
    
    func spaceShipFireBullet()
    {
        let url = Bundle.main.url(forResource: "artillery2.m4a", withExtension: nil)
        
        do {
            try fireBulletSound = AVAudioPlayer(contentsOf: url!)
        } catch {
            print("Could not create audio player")
        }

        fireBulletSound.volume = 0.5
        fireBulletSound.prepareToPlay()
        fireBulletSound.play()
        
        spaceShipBullet = SKSpriteNode(imageNamed: "defenderBullet2.png")
        spaceShipBullet!.yScale = 0.5
        spaceShipBullet!.xScale = 0.5
        if levelCount == 1
        {
            spaceShipBullet = SKSpriteNode(imageNamed: "bullet-small.jpeg")
            spaceShipBullet!.yScale = 0.5
            spaceShipBullet!.xScale = 0.3
        }
        
        spaceShipBullet!.position = spaceShip!.position
        spaceShipBullet!.physicsBody = SKPhysicsBody(circleOfRadius: spaceShipBullet!.size.width/4)
        spaceShipBullet!.physicsBody?.isDynamic = true
        spaceShipBullet!.physicsBody?.categoryBitMask = PhysicsCategory.PlayerBullet
        spaceShipBullet!.physicsBody?.contactTestBitMask = PhysicsCategory.Invader
        spaceShipBullet!.physicsBody?.collisionBitMask = PhysicsCategory.None
        spaceShipBullet!.physicsBody?.usesPreciseCollisionDetection = true
        
        addChild(spaceShipBullet!)
        
        let actionMove = SKAction.move(to: CGPoint(x: spaceShip!.position.x, y: self.frame.maxY + spaceShipBullet!.size.width/2), duration: GameConstants.SpaceShipBulletSpeed)
        let actionMoveDone = SKAction.removeFromParent()
        spaceShipBullet!.run(SKAction.sequence([actionMove, actionMoveDone]),withKey: GameConstants.movingKey)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func projectileDidCollideWithInvader(_ invader:SKSpriteNode, projectile:SKSpriteNode)
    {

        let url = Bundle.main.url(forResource: "crash.mp3", withExtension: nil)
        
        do {
            try crushSound = AVAudioPlayer(contentsOf: url!)
        } catch {
            print("Could not create audio player")
        }

        crushSound.volume = 0.5
        crushSound.prepareToPlay()
        crushSound.play()
        
        invader.userData?.setObject(false, forKey: GameConstants.aliveKey as NSCopying)
        projectile.removeFromParent()
        invader.removeFromParent()
        
        invaderCount -= 1
        if invaderCount == 0
        {
            winScene()
        }
    }
    
    func updateLeftBound() -> Int
    {
        var leftRecordCol = 0
        var leftFound = false
        for col in 0..<gameLevel.colCount
        {
            for row in 0..<gameLevel.rowCount
            {
                let invaderIsAlive = gameLevel.invaders[row][col].node.userData?.object(forKey: GameConstants.aliveKey) as! Bool
                if invaderIsAlive
                {
                    leftRecordCol = col
                    leftFound = true
                    break
                }
            }
            if leftFound
            {
                break
            }
        }
        return leftRecordCol
    }
    
    func updateRightBound() -> Int
    {
        var rightRecordCol = 0
        var rightFound = false
        for col in stride(from: gameLevel.colCount-1, through: 0, by: -1)
        {
            for row in 0..<gameLevel.rowCount
            {
                let invaderIsAlive = gameLevel.invaders[row][col].node.userData?.object(forKey: GameConstants.aliveKey) as! Bool
                if invaderIsAlive
                {
                    rightRecordCol = col
                    rightFound = true
                    break
                }
            }
            if rightFound
            {
                break
            }
        }
        return rightRecordCol
    }

    // we must implement this delegate method
   func didBegin(_ contact: SKPhysicsContact)
   {
        // bodyA and bodyB collide, we have to sort them by their bitmasks
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        // When invader is already killed dont need to calculate anymore
        if firstBody.node == nil || secondBody.node == nil
        {
            return
        }
    
        // Invader hit SpaceShip = Lose Game
        if ((firstBody.categoryBitMask == 1 && PhysicsCategory.Invader != 0) &&
                    (secondBody.categoryBitMask == 4 && PhysicsCategory.SpaceShip != 0))
        {
            loseScene()
        }
        // Invader rock hit SpaceShip = Lose Game
        else if((firstBody.categoryBitMask == 4 && PhysicsCategory.SpaceShip != 0) &&
                    (secondBody.categoryBitMask == 5 && PhysicsCategory.InvaderBullet != 0))
        {
            secondBody.node!.removeFromParent()
            loseScene()
        }
        // Spaceship Bullet hit Invader = Invader dies
        else if ((firstBody.categoryBitMask == 1 && PhysicsCategory.Invader != 0) &&
                (secondBody.categoryBitMask == 2 && PhysicsCategory.PlayerBullet != 0))
        {
            //check if invader is alive
            let invaderIsAlive = firstBody.node!.userData?.object(forKey: GameConstants.aliveKey) as! Bool
            if invaderIsAlive
            {
                projectileDidCollideWithInvader(firstBody.node as! SKSpriteNode, projectile: secondBody.node as! SKSpriteNode)
            }
        }
        else if ((firstBody.categoryBitMask == 2 && PhysicsCategory.PlayerBullet != 0) &&
                    (secondBody.categoryBitMask == 3 && PhysicsCategory.Shelter != 0))
        {
            firstBody.node!.removeFromParent()
        }
        else if((firstBody.categoryBitMask == 3 && PhysicsCategory.Shelter != 0) &&
                    (secondBody.categoryBitMask == 5 && PhysicsCategory.InvaderBullet != 0))
        {
            secondBody.node!.removeFromParent()
        }
        else if((firstBody.categoryBitMask == 2 && PhysicsCategory.PlayerBullet != 0) &&
                    (secondBody.categoryBitMask == 5 && PhysicsCategory.InvaderBullet != 0))
        {
            secondBody.node!.removeFromParent()
            firstBody.node!.removeFromParent()
        }
    } //didBeginContact
    
    func winScene()
    {
        self.levelCount += 1
        run(SKAction.sequence([
            SKAction.run()
            {
                let winScene = WinScene(size: self.size, levelCount: self.levelCount)
                let transition = SKTransition.moveIn(with: SKTransitionDirection.left, duration: 2)
                self.view?.presentScene(winScene, transition: transition) // we killed the invaders, we win!
            }
        ]))
    }
    
    func loseScene()
    {
        let url = Bundle.main.url(forResource: "scream.mp3", withExtension: nil)
        
        do {
            try screamSound = AVAudioPlayer(contentsOf: url!)
        } catch {
            print("Could not create audio player")
        }
        
        screamSound.volume = 0.5
        screamSound.prepareToPlay()
        screamSound.play()
        spaceShip!.texture = SKTexture(imageNamed: "scream.png")
        spaceShip!.xScale = 0.05
        spaceShip!.yScale = 0.1
        run(SKAction.sequence([
            SKAction.wait(forDuration: 1.5),
            SKAction.run() {
                let loseScene = LoseScene(size: self.size)
                let transition = SKTransition.doorway(withDuration: 2.0)
                self.view?.presentScene(loseScene, transition: transition) // You got hit, you lose
            }
        ]))
    }
}
