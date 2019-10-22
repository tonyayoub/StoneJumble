//
//  SJSpriteNode.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 11/7/15.
//  Copyright © 2015 amahy. All rights reserved.
//

import SpriteKit

class SJSpriteNode: SKSpriteNode
{

    
    var totalSize: CGSize
    {
        get
        {
            return self.size
        }
    }
    
    fileprivate var _isMoving:Bool = false
    var initialPosition = CGPoint.zero

    var movingVector: CGVector = CGVector(dx: 0, dy: 0)

    func createPhysicsBody()
    {
        
    }
    
    func generateInitialPosition()
    {
        guard let container = SJLevelScene.currentLevelScene?.container else
        {
            return
        }
        var numberOfTrials = 0
        //TODO: check if it is faster enumerate here and add all nodes to a set, then iterate it inside the while loop
        while (true)
        {
            numberOfTrials += 1
            var intersectingPreviousNode = false
            self.initialPosition = ScreenRange.generateRandomLocation(object: self)
            let dummyNode = SKSpriteNode(color: UIColor.clear, size: self.totalSize)
            dummyNode.position = self.initialPosition
            dummyNode.name = "dummyTemp"
            container.addChild(dummyNode)
            container.enumerateChildNodes(withName: "dummy") { node, _ in
                if node.intersects(dummyNode)
                {
                    intersectingPreviousNode = true
                    
                }
            }
            if !intersectingPreviousNode // we found an empty place. dummy node will be left
            {
                dummyNode.name = "dummy"
                if self.parent == nil
                {
                    container.addChild(self)

                }
                else
                {
                    dummyNode.removeFromParent()
                    // print("trying to add a node twice. this is an erro")
                }
                break
            }
            else if numberOfTrials > 20 // no place found after 9 trials, don't add this target
            {
                dummyNode.removeFromParent()
                break
            }
            else // no place found but we will search again
            {
                dummyNode.removeFromParent()
            }
        }
    }
    
    class func make(objectSpec: String) -> SJSpriteNode?
    {
        return nil
        
    }
    
    func updateCollisionMask()
    {}
    
    class func generateTexture(_ objectName: String) -> SKTexture?
    {
        // 1
        struct SharedTexture
        {
            static var texture = SKTexture()
            static var onceToken: Int = 0
            static var objectsDictionary = [String: SKTexture]()
        }
        
    //    _ = SJSpriteNode.__once
        
        return SharedTexture.objectsDictionary[objectName]
    }
    var isMoving:Bool
        {
        get
        {
            if let physicalBody = self.physicsBody
            {
                
                if (abs(physicalBody.velocity.dx) < 10.0
                    && abs(physicalBody.velocity.dy) < 10.0)
                {
                    return  false;
                }
                else
                {
                    return true;
                }
            }
            else
            {
                return false;
            }
            
        }
    }
    func expandThenCollapse(_ time:TimeInterval)
    {
        run(SKAction.sequence([
            SKAction.scale(to: 1.5, duration: time),
            SKAction.scale(to: 1.0, duration: time)
            ]))
    }
    
    func gotOneHit(hitter: SJSpriteNode, collisionPoint: CGPoint)
    {
        
    }

    func explodeWithOwnPicture(emitterFileName: String)
    {
        if let emitter = SKEmitterNode(fileNamed: emitterFileName)
        {
            emitter.position = self.position // check
            emitter.zPosition = 121
            emitter.particleTexture = self.texture
            if let particleLayer = SJLevelScene.currentLevelScene?.particleLayerNode
            {
                particleLayer.addChild(emitter)
            }
            else
            {
                return
            }

            if emitter.position.x < 0 || emitter.position.y < 0
            {
                //something is negative
            }

            let fadeAction = SKAction.fadeOut(withDuration: 0.5)
            let removeAction = SKAction.removeFromParent()
            let fadeThenRemoveAction = SKAction.sequence([fadeAction, removeAction])
            emitter.run(fadeThenRemoveAction)

        }
    }
    // I have to override all "init" designated (the following two) functions to inherit "convenience functions" like:
    // init(texture: SKTexture!, color: UIColor!, size: CGSize)
    //try commenting one of the following two init functions
    //you will get an error in     var _shooter = Shooter(imageNamed: "Shooter")
    // because Shooter now, since its parent (this class) did not override designated initialziers, did not inherit the convenience initializer (the one with texture)
    
    /*    override init()
    {
    super.init()
    }*/
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

}
