//
//  Target.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 11/8/15.
//  Copyright © 2015 amahy. All rights reserved.
//

import SpriteKit

class Target2: SJSpriteNode
{

    let parts:[Int:(imgName:String, order:Int, position:Double)] = [
        1: ("burger", 1, 0.8),
        2: ("bottom", 0, 0.8),
        3: ("top", 99, 0.8)
    ]
    var weight = 0;
    var fullTexture:SKTexture?
    var oneShotTexture: SKTexture?
    var twoShotTexture: SKTexture?
    var threeShotTexture: SKTexture?
    var numberOfHits = 0
    private var _strength:Int = 0
    var _sparkEmitter:SKEmitterNode?
    var type:TargetType = TargetType.Red
    var colorName:String?
    var _label = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
    var _status = TargetStatus.Initial
    var _childrenNodes = [Int: SKSpriteNode]()
    var _holder = SKSpriteNode()
    /*    override init()
    {
    super.init()
    }*/
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize)
    {
        print(parts.count)
        print(parts[2])
        print(parts[1]!.position)
        super.init(texture: texture, color: color, size: size)
        _label.text = String(self._strength)
        _label.fontSize = 15
        _label.position = CGPointMake(self.position.x, self.position.y - size.height/10)
        _label.zPosition = 10
        _label.hidden = true
        self.addChild(_label)
        //self.halfTexture = SKTexture(imageNamed: "Target2-piece")
        // self.fullTexture = SKTexture(imageNamed: "target-full")
        //        self.texture = SKTexture(imageNamed: "Shooter")
        self.setupPhysics()
        
    }




    override class func make(objectName: String, objectSpec: Int) -> SJSpriteNode?
    {
        
        
        var res:Target2!
        
        res = Target2()

        
        //        res = Target(imageNamed: targetName)
        res.colorName = objectName
        res.strength = objectSpec
        res.name = "target-\(objectName)"
        let burger = SKSpriteNode(imageNamed: "burger")
        res.addChild(burger)
        res.size = burger.size
        

        
        return res
    }
    
    class func make3(objectName: String, objectSpec: Int) -> SJSpriteNode?
    {
        
        
        var res:Target2!

        res = Target2(imageNamed: "burger")
     

        //        res = Target(imageNamed: targetName)
        res.colorName = objectName
        res.strength = objectSpec
        res.name = "target-\(objectName)"
        
        
        res.makeChildrenB()
        
        return res
    }
    
    class func make2(objectName: String, objectSpec: Int) -> SJSpriteNode?
    {
        
        var res:Target2!
        res = Target2(texture: SJSpriteNode.generateTexture(objectName))
        //        res = Target(imageNamed: targetName)
        res.colorName = objectName
        res.strength = objectSpec
        res.name = "target-\(objectName)"


        res.makeChildrenD()
        
        return res
    }
    var strength:Int
    {
        get
        {
            return _strength
        }
        set(newStrength)
        {
            _strength = newStrength
            _label.text = String(newStrength)
            
        }
    }
    
    func setupPhysics()
    {
        //        NSLog("*****: (%f, %f)", self.frame.size.width, self.frame.size.height)
        self.physicsBody = (SKPhysicsBody(circleOfRadius: self.frame.size.width/2))

        let xP = self.frame.width/2
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0) //start from here
        CGPathAddLineToPoint(path, nil, xP, 0)
        CGPathAddLineToPoint(path, nil, xP, 10)
        CGPathAddLineToPoint(path, nil, -1 * xP, 10)
        CGPathAddLineToPoint(path, nil, -1 * xP, 0)
        CGPathAddLineToPoint(path, nil, 0, 0)
     //   self.physicsBody = SKPhysicsBody(polygonFromPath: path)
        
        //     self.physicsBody = SKPhysicsBody(rectangleOfSize: self.frame.size)
        //    self.physicsBody?.mass = 99999
        if let ph = self.physicsBody
        {

            ph.dynamic = false
            ph.allowsRotation = true
            ph.friction = 0.0
            ph.linearDamping = 0.2
        }
    }
  

    func fireRandomly()
    {
        self._status = .Firing
        self.physicsBody?.dynamic = true
        let xImpulse = CGFloat(arc4random_uniform(300)) - 150
        let yImpulse = -CGFloat(arc4random_uniform(50))
        self.physicsBody?.applyImpulse(CGVectorMake(xImpulse, yImpulse))
        self.runAction(SKAction.sequence([
            SKAction.waitForDuration(1),
            SKAction.runBlock({
                self.physicsBody?.dynamic = false
            }),
            SKAction.scaleTo(1.1, duration: 0.2),
        //    SKAction.runBlock({self._label.hidden = false}),
            SKAction.scaleTo(1, duration: 0.1),
            SKAction.runBlock({self._status = .Ready})
            ]))
  //      self._label.hidden = false
    }
    
    func makeChildrenB()
    {
        if _strength <= 1
        {
            return;
        }
  
        let bottom = SKSpriteNode(imageNamed: "bottom")
        bottom.position = CGPointMake(self.position.x, self.position.y - (self.size.height/2 + bottom.size.height/2))
        self.addChild(bottom)

        return;
        let burger = SKSpriteNode(imageNamed: "burger")
        burger.position = CGPointMake(self.position.x, self.position.y + burger.size.height/2)
        burger.zPosition = self.zPosition + 1
        self.addChild(burger)
        
        let top = SKSpriteNode(imageNamed: "top")
        top.position = CGPointMake(burger.position.x, burger.position.y + top.size.height/2)
        top.zPosition = self.zPosition + 2
        self.addChild(top)
        
    }
    
    func makeChildrenD()
    {
        if _strength <= 1
        {
            return;
        }
        let refScale:CGFloat = 1.0
        self.setScale(refScale)
        
        
        //        for i in _strength.stride(through: 2, by: -1) //through includes 25
        for i in 1..._strength-1
        {
          //  let child = SKSpriteNode(texture: SJSpriteNode.generateTexture(self.colorName! + "-1"))
            
            let child = SKSpriteNode(imageNamed: "donutA-" + String(i))
            child.position = self.position
            child.zPosition = self.zPosition + CGFloat(i)
            _childrenNodes.updateValue(child, forKey: i)
            self.addChild(child)
        }
        
        
    }
    func makeChildren()
    {
        if _strength <= 1
        {
            return;
        }
        let refScale:CGFloat = 0.6
        self.setScale(refScale)

        
//        for i in _strength.stride(through: 2, by: -1) //through includes 25
        for i in 1..._strength-1
        {
            let child = SKSpriteNode(texture: SJSpriteNode.generateTexture(self.colorName!))

            let childScale = Double(refScale) * (pow(1.2, Double(i)))
    
            child.setScale(CGFloat(childScale))
            child.name = "child"
            child.position = self.position
            child.zPosition = self.zPosition + CGFloat(i)
            _childrenNodes.updateValue(child, forKey: i)
            self.addChild(child)
        }
        
        
    }
    
    func updateChildren()
    {
        numberOfHits += 1
        let deletedChild = _childrenNodes[numberOfHits]
        deletedChild?.runAction(SKAction.sequence([
            SKAction.moveToY(-200, duration: 2),
            SKAction.removeFromParent()
            ]))
//        _childrenNodes.removeValueForKey(_strength-1)?.removeFromParent()
        _strength -= 1
    }
    override func gotOneHit(pointOfContact:CGPoint)
    {
        SoundPlayer.playSound(Sounds.TargetHit)
        

        updateChildren()

        _label.text = String(_strength)

        let collapseAction = SKAction.scaleTo(0.8, duration: 0.05)
        let expandAction = SKAction.scaleTo(1, duration: 0.1)
        self.runAction(SKAction.sequence([collapseAction, expandAction]))
   
        
        let _sparkEmitter = SKEmitterNode(fileNamed: "Spark")
        
        if let emitter = _sparkEmitter
        {
            emitter.position = self.position
            emitter.name = "sparkEmmitter"
            emitter.zPosition = 3
          //  emitter.targetNode = self
        //    emitter.particleTexture = SKTexture(imageNamed: self.colorName! + "-part")
            emitter.particleTexture = self.texture
            emitter.particleScale = 0.2
            
            guard let parentScene = self.parent as? SJLevelScene else
            {
                return;
            }
            emitter.xAcceleration = parentScene._shooter.physicsBody!.velocity.dx * -1
            emitter.yAcceleration = parentScene._shooter.physicsBody!.velocity.dy * -1
            parentScene.addChild(emitter)
            let waitAction = SKAction.waitForDuration(3)
            let removeAction = SKAction.removeFromParent()
            emitter.runAction(SKAction.sequence([waitAction, removeAction]))
        }
        
        if(_strength < 1)
        {
            _label.removeFromParent()
            self.removeFromParent()
        }
        
    }
    func gotOneHit2(pointOfContact:CGPoint)
    {
        SoundPlayer.playSound(Sounds.TargetHit)
        

        numberOfHits += 1
        _strength -= 1
        

        if(_strength > 0)
        {
            let textureName = colorName! + "-" + String(numberOfHits)
            let textureAction = SKAction.setTexture(SKTexture(imageNamed: textureName))
            self.size = SKTexture(imageNamed: textureName).size()
            let seq = SKAction.sequence([textureAction])
            self.runAction(seq)
            self.setupPhysics()
            
        }
        else
        {
            _label.removeFromParent()
            self.removeFromParent()
        }
        
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
}
