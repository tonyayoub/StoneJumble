//
//  Obstacle.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 11/8/15.
//  Copyright © 2015 amahy. All rights reserved.
//

import SpriteKit

class Obstacle: SJSpriteNode
{
    
    var obstacleName:String?
    var isBeingHit = false

    
    override init(texture: SKTexture?, color: UIColor, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
        //        self.physicsBody = (SKPhysicsBody(circleOfRadius: self.frame.size.width/2))
    }
    
    override class func make(objectSpec: String) -> SJSpriteNode?
    {
        var res:Obstacle?
        switch objectSpec
        {
        case "fries":
            res = Fries(imageNamed: objectSpec)
        case "ketchup":
            res = Ketchup(imageNamed: objectSpec)
        case "mustard":
            res = Mustard(imageNamed: objectSpec)
            /*
            let magnet = SKFieldNode.radialGravityField()
            magnet.strength = 5
            magnet.falloff = 4
            magnet.categoryBitMask = SJDirector.mustardGravityCategory
            magnet.region = SKRegion(radius: 100)
            res?.addChild(magnet)
             */
        case "soda":
            res = Soda(imageNamed: objectSpec)
        default:
            res = Fries(imageNamed: objectSpec)
        }
  //      let res = Obstacle(imageNamed: objectSpec)
        if let createdObstacle = res
        {
            let pSize = createdObstacle.size
            //pSize.width *= 0.6
            //pSize.height *= 0.8
            createdObstacle.physicsBody = SKPhysicsBody(texture: createdObstacle.texture!, size: pSize)
         //   createdObstacle.physicsBody = SKPhysicsBody(rectangleOf: pSize)
            createdObstacle.physicsBody?.affectedByGravity = false
            createdObstacle.physicsBody?.isDynamic = false
            createdObstacle.physicsBody?.categoryBitMask = SJDirector.obstacleCategory
            createdObstacle.physicsBody?.collisionBitMask =  SJDirector.frameCategory
            
            return createdObstacle
        }
        else
        {
            return nil
        }
    }
    
    func showEmitter(emitterFile: String, position: CGPoint, lifetime: Double)
    {
        if let emitter = SKEmitterNode(fileNamed: emitterFile)
        {
            emitter.position = position
            emitter.name = "sparkEmmitter"
            emitter.zPosition = 199
            
            SJLevelScene.currentLevelScene!.container.addChild(emitter)
            if lifetime != 0 //0 means infinity
            {
                let waitAction = SKAction.wait(forDuration: lifetime)
                let removeAction = SKAction.removeFromParent()
                emitter.run(SKAction.sequence([waitAction, removeAction]))
            }
        }
    }
    override func gotOneHit(hitter: SJSpriteNode, collisionPoint: CGPoint)
    {
        if isBeingHit
        {
            // print("is being hit already")
            return;
        }
        else
        {
            // print("not being hit before")
            isBeingHit = true
        }

        // print("will rung got one hit")

        if destroyerAttachedToShooter()
        {
            explodeWithOwnPicture(emitterFileName: "part-explode")
            SJDirector.shared.sound.playLevelSound(sound: .obstacleExplode)
            removeFromParent()
        }
        else
        {
            let collisionVector = pSub(self.position, p2: collisionPoint)
            let shakeX = abs(Int(collisionVector.dx * 0.3))
            let shakeY = abs(Int(collisionVector.dy * 0.3))
            
            self.doActionsAfterHit(hitter: hitter, hittingPoint: collisionPoint)
            let shakingAction = SKAction.shake(self.position, duration: 0.2, amplitudeX: shakeX, amplitudeY: shakeY)
            self.run(shakingAction, completion: {self.isBeingHit = false})

        }
    }

    func doActionsAfterHit(hitter: SJSpriteNode, hittingPoint: CGPoint)
    {
    }

    func destroyerAttachedToShooter() -> Bool
    {
        guard let currentAddons = SJLevelScene.currentLevelScene?._shooter.addons else
        {
            return false
        }
        for addon in currentAddons
        {
            for destroyerAddonType in destroyerList()
            {
                if addon.addonType == destroyerAddonType
                {
                    return true
                }
            }
        }
        return false
    }

    func destroyerList() -> [AddonType]
    {
        return [AddonType]()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}
