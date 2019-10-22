//
//  BurgerPart.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 5/9/16.
//  Copyright © 2016 amahy. All rights reserved.
//

import SpriteKit

class BurgerPart: SJSpriteNode, ChildActioner
{
    //ChildActioner
    internal var parentActioner: ParentActioner?
    var wantedAction: SKAction?
    var actionFinished: Bool = false
    
    
    var wantedPosition:CGPoint!
    
    var parentBurger:Burger?
    var exploded = false
    var isBeingRemoved = false
    var strength:Int = 1
    var imageTexture:SKTexture!
    var drawingOrder:Int = 0
    var vDisplacement:CGFloat = 1.0
    //this value affects the position of the part that is placed above this part.
    //from 0 to 1. 0 means the part put above this part will not hide any part of this part image. If 0.5, then it will hide half of it ..etc. This is used for example as follows: for a burger part, it will be like 0.2 because I only want to hide 20% of the burger part with the top bread part, but for cheese, it will be 50%
    var calculatedPosition = CGPoint(x: 0, y: 0)
    init (str: Int, imgNm: String, drawOrd: Int, vDisp: CGFloat)
    {
     //   imageTexture = SKTexture(imageNamed: imgNm)

     //   super.init(texture: imageTexture, color: SKColor.white, size: imageTexture!.size())

        let loadedTexture = TextureManager.shared.getTexture(withName: imgNm)
  
        super.init(texture: loadedTexture, color: SKColor.white, size: loadedTexture.size())
        strength = str
        self.name = String(str)
        

        drawingOrder = drawOrd
        vDisplacement = vDisp
        


    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    override func createPhysicsBody()
    {
        
        physicsBody = SKPhysicsBody(rectangleOf: self.size)
        physicsBody?.categoryBitMask = SJDirector.burgerPartCategory
        physicsBody?.collisionBitMask = SJDirector.bottomCategory
        physicsBody?.contactTestBitMask = SJDirector.bottomCategory
        physicsBody?.affectedByGravity = true
        physicsBody?.fieldBitMask = SJDirector.zeroCategory
      //  physicsBody?.allowsRotation = true
    }

    func destroy()
    {

        self.zPosition = 9990


     //   self.run(SKAction.wait(forDuration: 0.01), completion: {self.animateFalling()})
       self.animateFalling() //done in another function in case we need to wait before calling like in the commented line of code
        return;
        
    }
    

    func animateFalling()
    {
        let timeSlot = 0.08
        let numberOfBlinks = 2
        let totalTime = 2 * timeSlot * Double(numberOfBlinks)
        let blinkingOnceAction = SKAction.sequence([
            SKAction.scale(to: 1.2, duration: timeSlot),
            SKAction.scale(to: 1, duration: timeSlot)
            ])
        let blinkingAction = SKAction.repeat(blinkingOnceAction, count: numberOfBlinks)
        move(toParent: (self.parent?.parent!)!)
        self.run(SKAction.sequence([
            //SKAction.wait(forDuration: 0.3),
            SKAction.scale(to: 1.25, duration: 0.15),
            SKAction.scale(to: 1, duration: 0.15),
            SKAction.group([
                SKAction.wait(forDuration: totalTime),
                blinkingAction
                ]),
            SKAction.scaleY(to: 1.5, duration: 0.1),
            SKAction.run(self.createPhysicsBody)
            ]))
    }
    func touchBottom(touchPosition: CGPoint)
    {
        parentBurger?.numberOfFallingParts -= 1
        parentBurger?.destroyIfNoFallingPartsStillExist()
        if(!exploded) //to avoid double explosion when the part fell on the bottom and touch it twice (due to reflex)
        {
            explodeWithOwnPicture(emitterFileName: "part-explode")
         //   self.parentBurger!.adjustPartsPositionsAndPhysics(false)
            exploded = true
            self.removeFromParent()
        }
    }


    func getJumpingAction() -> SKAction
    {
        
        let rotTime = 0.08
        let jumpDisp = (self.size.height / 16) * CGFloat(self.drawingOrder)
        let angleStep:CGFloat = 0.5
        let rot1 = SKAction.rotate(toAngle: angleStep, duration: rotTime)
        let rot2 = SKAction.rotate(toAngle: -0.8 * angleStep, duration: rotTime)
        let rot3 = SKAction.rotate(toAngle: 0.6 * angleStep, duration: rotTime)
        let rot4 = SKAction.rotate(toAngle: -0.4 * angleStep, duration: rotTime)
        let rot5 = SKAction.rotate(toAngle: 0.2 * angleStep, duration: rotTime)
        let rot6 = SKAction.rotate(toAngle: 0.0, duration: rotTime)
        let _ = SKAction.sequence([rot1, rot2, rot3, rot4, rot5, rot6])
        let jump1 = SKAction.moveBy(x: 0, y: jumpDisp, duration: rotTime * 3)
        let jump2 = SKAction.move(to: self.wantedPosition, duration: rotTime * 3)
        let jumping = SKAction.sequence([jump1, jump2])
        
        //let oldAction = SKAction.group([rotating, jumping])
        //let newAction = SKAction.group([SKAction.shake(self.position, duration: 0.5),                                           SKAction.move(to: self.wantedPosition, duration: 0.5)])
        return jumping
        
        //return jumping
    }

}
