//
//  Burger.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 4/2/16.
//  Copyright © 2016 amahy. All rights reserved.
//

import SpriteKit


class Burger: SJSpriteNode, Hittable, ParentActioner
{
    
    //ParentActioner
    var childrenActioners: [ChildActioner] = [ChildActioner]()
    var runAfterAllChildrenFinish: (() -> Void)?
    var toBeDestroyed = false
    var hittingWithMoreThanOneHit = false
    var numberOfFallingParts = 0
    var vDisp:CGFloat = 0.88
    var isBeingMustarded = false
    var hitsBuffer = 0
    var wasApplyingBufferedHits = false
    var strengthLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
    var strength:Int
    {
        get
        {
            return _strength
        }
        set(newStrength)
        {
            _strength = newStrength
            var newStrengthText = String(newStrength)
            if newStrength <= 1
            {
                newStrengthText = ""
            }

            let shakeAction = SKAction.shake(strengthLabel.position, duration: 0.3, amplitudeX: Int(strengthLabel.fontSize * 0.5), amplitudeY: Int(strengthLabel.fontSize * 0.5))
            strengthLabel.run(shakeAction, completion: {
                self.strengthLabel.text = newStrengthText
            })
        }
    }
    func onAllChildrenFinish()
    {
       
    }
    internal var reaction: ReactionProfile
        {
            get
            {
                return SJDirector.shared.reactions.burgerReaction
            }
    }
    var _parts = [BurgerPart]()
    
    var isBeingDestroyed = false
    fileprivate var calculatedTotalSize:CGSize?
    
    override var totalSize: CGSize
        {
        get
        {
            if let res = calculatedTotalSize
            {
                return res
            }
            else
            {
                return self.size
            }
        }
    }
    var physicalCenter:CGPoint?
    var isBeingHit = false
    var weight = 0;
    private var _strength:Int = 0
    var _sparkEmitter:SKEmitterNode?
    
    var _status = TargetStatus.initial
    var _childrenNodes = [Int: SKSpriteNode]()
    var _holder = SKSpriteNode()
    /*    override init()
    {
    super.init()
    }*/
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize)
    {
        
        super.init(texture: texture, color: color, size: size)
        self.zPosition = 5
        
    }
    override class func make(objectSpec: String) -> SJSpriteNode
    {
        
        
        let res = Burger(imageNamed: "burger") //calls init
        
        
        res.strength = Int(objectSpec)!


        

        
        //vDisp for bottom parts represents the percentage that will be hidden from me
        //from top parts represents the percentage that will be hidden from the part below me
        //this has changed and vDisp always represents the part that will be hidden from me

        //top parts, from burger up: cheese, secondBurger, pickles, salami, eggs, topBread

        let cheesePart = BurgerPart(str: 4,
                                    imgNm: "cheese",
                                    drawOrd: 1,
                                    vDisp: 0.8)



        let tomatoePart = BurgerPart(str: 6,
                                     imgNm: "tomatoePart",
                                     drawOrd: 2,
                                     vDisp: 0.85)

        let whiteCheesePart = BurgerPart(str: 7,
                                   imgNm: "whiteCheese",
                                   drawOrd: 3,
                                   vDisp: 0.8)


        let picklesPart = BurgerPart(str: 8,
                                 imgNm: "pickles",
                                 drawOrd: 4,
                                 vDisp: 0.8)



        let salamiPart = BurgerPart(str: 9,
                                 imgNm: "salami",
                                 drawOrd: 5,
                                 vDisp: 0.75)

//        let eggsPart = BurgerPart(str: 11,
//                                 imgNm: "eggs",
//                                 drawOrd: 5,
//                                 vDisp: 0.8)


        //top bread always have strength = 3
        let topPart = BurgerPart(str: 3,
                                 imgNm: "top",
                                 drawOrd: 6,
                                 vDisp: 0.8)
        
        
        //bottom parts, from burger down: tomatoe, lettuce, onion, mushroom, pepper, bottomBread

        let lettucePart = BurgerPart(str: 5,
                                     imgNm: "lettuce",
                                     drawOrd: -1,
                                     vDisp: 0.85)



//        let mushroomPart = BurgerPart(str: 10,
//                                      imgNm: "mushroom",
//                                      drawOrd: -3,
//                                      vDisp: 0.7)



        //bottom bread always have strength = 2
        let bottomPart = BurgerPart(str: 2,
                                    imgNm: "bottom",
                                    drawOrd: -4,
                                    vDisp: 0.82)


        
        let addedParts = [ tomatoePart, lettucePart, whiteCheesePart, bottomPart, cheesePart, picklesPart, salamiPart, topPart]

        for part in addedParts
        {
            part.parentBurger = res
            if part.strength <= res.strength
            {
              //  res.parts.append(part)
                
                res.addChild(part)
                
                //part.parentActioner = res
                //res.childrenActioners.append(part)
            }
            
        }
        res.name = "target-burger"


        res.adjustPartsPositionsAndPhysics(true)
        res.strengthLabel.zPosition = 99
        res.strengthLabel.fontSize = res.size.height * 0.3
        res.strengthLabel.fontColor = UIColor.init(red: 1, green: 1, blue: 0.5, alpha: 0.9)
        //res.strengthLabel.alpha = 0.5

        //res.position = CGPoint.zero

        return res
    }


    func runSmokeSound()
    {
        SJDirector.shared.sound.runSoundAction(owner: self, soundAction: SKAction.playSoundFileNamed("sizzle", waitForCompletion: false))
    }
    func shakeThenSmoke()
    {
        if NPDirector.shared.gamePaused
        {
            return
        }
        let randomNumber = arc4random_uniform(100)
        let randomWaitTime = Double(randomNumber)/Double(100)
        self.run(
            SKAction.sequence([
                SKAction.wait(forDuration: randomWaitTime),
                SKAction.scale(to: 1.1, duration: 0.1),
                SKAction.scale(to: 1.05, duration: 0.05),
                SKAction.scale(to: 1.1, duration: 0.05),
                SKAction.run {
                   // self.runSmokeSound()
                    self.smoke()
                },
                SKAction.scale(to: 1.05, duration: 0.05),
                SKAction.scale(to: 1.1, duration: 0.05),
                SKAction.scale(to: 1, duration: 0.1)
                ]))
    }
    func smoke()
    {
        if let emitter = SKEmitterNode(fileNamed: "burgerSmoke")
        {
         //   emitter.position = self.position
            emitter.name = "sparkEmmitter"
            emitter.zPosition = 599
            emitter.targetNode = self
            emitter.particlePositionRange.dx = self.size.width
            self.addChild(emitter)

            let waitAction = SKAction.wait(forDuration: 3)
            let removeAction = SKAction.removeFromParent()
            emitter.run(SKAction.sequence([waitAction, removeAction]))

        }
    }

    func getBurgerParts() -> [BurgerPart]
    {
        var res = [BurgerPart]()
        for child in self.children
        {
            
            guard let partSprite = child as? BurgerPart else
            {
                continue //not expected to happen because all children are SKSpriteNode
            }
            res.append(partSprite)
        }
        return res
    }
    func calculateAndSaveSize()
    {
        var lowestPoint:CGFloat = -self.size.height/2
        var highestPoint:CGFloat = self.size.height/2
        var biggestWidth: CGFloat = self.size.width
        for partSprite in getBurgerParts()
        {
            
           
            if partSprite.isBeingRemoved
            {
                continue //exclude the part that is currently being removed
            }
            if (partSprite.position.y - partSprite.size.height/2) < lowestPoint
            {
                lowestPoint = partSprite.position.y - partSprite.size.height/2
            }
            
            if (partSprite.position.y + partSprite.size.height/2) > highestPoint
            {
                highestPoint = partSprite.position.y + partSprite.size.height/2
            }
            if (partSprite.size.width) < biggestWidth
            {
                biggestWidth = partSprite.size.width
            }
        }
        self.physicalCenter = CGPoint(x: 0, y: (highestPoint + lowestPoint)/2)
        self.calculatedTotalSize = CGSize(width: biggestWidth, height: highestPoint - lowestPoint)
        
    }
    
    
    

    
    func setupPhysicsAndGetReadyForHitting()
    {
        
        self.calculateAndSaveSize()
        self.physicsBody = SKPhysicsBody(rectangleOf: self.totalSize, center: physicalCenter!)
        if let ph = self.physicsBody
        {
            ph.isDynamic = true
            ph.allowsRotation = false

            ph.affectedByGravity = false
            ph.restitution = 1.0

        }
        self.physicsBody?.categoryBitMask = SJDirector.burgerCategory
        self.physicsBody?.collisionBitMask = SJDirector.frameCategory | SJDirector.bottomCategory
        self.physicsBody?.fieldBitMask = SJDirector.zeroCategory
        self.isBeingHit = false

        // why can't i decrement hitsBuffer inside applyBufferedHits?
        // if i did so, the hitsBuffer will be set to zero before the buffered hit is applied
        // so i have to do the following
        // there is a buffered hits
        // if wasApplying will be false
        // if hitsBuffer will be true and applyBuffered will be called
        // then we will reach here again, if was applying will be true
        // and if hitsBuffer will be false
        if wasApplyingBufferedHits
        {
            hitsBuffer -= 1
            if hitsBuffer < 0
            {
                hitsBuffer = 0
            }
            wasApplyingBufferedHits = false
        }
        if hitsBuffer > 0
        {
            guard let shooter = SJLevelScene.currentLevelScene?._shooter else
            {
                return
            }

            applyBufferedHits(shooter: shooter, hittingPoint: self.position)
        }
    }
    
    override func updateCollisionMask()
    {
        self.physicsBody?.collisionBitMask = SJDirector.frameCategory | SJDirector.bottomCategory | SJDirector.burgerCategory | SJDirector.obstacleCategory
    }
    
    func fireRandomly()
    {
        self._status = .firing
        self.physicsBody?.isDynamic = true
        let xImpulse = CGFloat(arc4random_uniform(100)) - 50
        let yImpulse = -CGFloat(arc4random_uniform(100))
        self.physicsBody?.applyImpulse(CGVector(dx: xImpulse, dy: yImpulse))
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: 1),
            SKAction.run({
                self.physicsBody?.isDynamic = false
            }),
            SKAction.scale(to: 1.1, duration: 0.2),
            //    SKAction.runBlock({self._label.hidden = false}),
            SKAction.scale(to: 1, duration: 0.1),
            SKAction.run({
                self._status = .ready;
            })
            ]))
        //      self._label.hidden = false
    }
    
    
    //this function is only to animate moving parts to their positions after hitting one part. 
    //correct positions are calculated using calculateAndStore..
    func movePartsToCalculatedPositions(_ newLevel: Bool)
    {
        
        var partsThatWillBeAnimated = [BurgerPart]()
        for burgerPart in getBurgerParts()
        {
            if newLevel
            {
                burgerPart.position = burgerPart.wantedPosition
            }
            else
            {
                if !burgerPart.isBeingRemoved // or we can remove it from BurgerParts
                {
                    burgerPart.wantedAction = burgerPart.getJumpingAction()
                    partsThatWillBeAnimated.append(burgerPart)
                }
            }
            
        }

        // all this is to prevent negative coordinates but (resulting in explosions in the lowest left point of the screen). Here we make sure all parts finishes animation before setting self.isBeingHit = false allowing a new hit
        if newLevel
        {
            setupPhysicsAndGetReadyForHitting()
        }
        else
        {
            runActionOnCollection(actioners: partsThatWillBeAnimated, afterTheyFinish: {self.setupPhysicsAndGetReadyForHitting()})
        }
    }
    

    func adjustPartsPositionsAndPhysics(_ newLevel: Bool)
    {
        
        calculateAndStorePartsWantedPosition()
        movePartsToCalculatedPositions(newLevel) //animation, but setupPhysicsShouldWait
    }
    
    func calculateAndStorePartsWantedPosition()
    {
        if strength <= 1
        {
            return;
        }
        var partsAbove = [BurgerPart]()
        var partsBelow = [BurgerPart]()
        
        for burgerPart in getBurgerParts()
        {
            if self.strength < burgerPart.strength //this part is already shot away
            {
                continue
            }
            
            
            if burgerPart.drawingOrder > 0
            {
                partsAbove.append(burgerPart)
            }
            else if burgerPart.drawingOrder < 0
            {
                partsBelow.append(burgerPart)
            }
          //  self.addChild(burgerPart)
        }
        
        partsAbove.sort(by: {(p1: BurgerPart, p2: BurgerPart) -> Bool in
            return p1.drawingOrder < p2.drawingOrder // in the parts above we sort from the burger upwards
        })
        
        partsBelow.sort(by: {(p1: BurgerPart, p2: BurgerPart) -> Bool in
            return p1.drawingOrder > p2.drawingOrder // in the parts below we sort from the burger downwards
        })
        
        var lastDrawnPart:SKSpriteNode = self
        var lastDrawnY:CGFloat = 0
        
        for part in partsAbove
        {
            
            let x:CGFloat = 0
            var yDiff:CGFloat = 0
            
            if(lastDrawnPart == self) // putting the first part above burger
            {
                part.zPosition = 1
                yDiff = self.size.height * self.vDisp
                
            }
            else
            {
                part.zPosition = lastDrawnPart.zPosition + 1
                var usedVDisp = part.vDisplacement
                if let lastDrawnBurgerPart = lastDrawnPart as? BurgerPart
                {
                    usedVDisp = lastDrawnBurgerPart.vDisplacement
                }
                yDiff = part.size.height * usedVDisp
            }
            let y = lastDrawnY + lastDrawnPart.size.height/2 + part.size.height/2 - yDiff
            part.wantedPosition = CGPoint(x: x, y: y)
            lastDrawnPart = part
            lastDrawnY = part.wantedPosition.y
            
        }
        
        lastDrawnPart = self
        lastDrawnY = 0
        
        for part in partsBelow
        {
            
            
            let x:CGFloat = 0
            let yDiff = part.size.height * part.vDisplacement //calculating the hidden part relative to the part newly put because i'm sorting from burger downwards. Remember: the hidden part always depends on the below part, and here the below part is the part currently being drawn
            //if yDiff = 0, there will be no overlap
            let y = (lastDrawnY - lastDrawnPart.size.height/2 - part.size.height/2) + yDiff


            part.wantedPosition = CGPoint(x: x, y: y)
            if(lastDrawnPart == self) // putting the first part below burger
            {
                part.zPosition = -1
            }
            else
            {
                part.zPosition = lastDrawnPart.zPosition - 1
                
            }
            
            lastDrawnPart = part
            lastDrawnY = part.wantedPosition.y
        }
    }
    




    func animateHittingOnePart(removedPart:BurgerPart)
    {
        //let removedChildPositionInView:CGPoint = self.position
     
        //Tony: the removed part should start animation immediately, and not wait to the moving apart, so that when removing the last bread in the bottom, it is removed immediately not wait for nothing
     //   movePartApart(true)
        removedPart.destroy()
    }
    
   
    

    
    override func gotOneHit(hitter: SJSpriteNode, collisionPoint: CGPoint)
    {
       
     //   animateBeingHit(numberOfHits: hits)
        var appliedHits = 1
        if let shooter = SJLevelScene.currentLevelScene?._shooter
        {
            shooter.calculateAppliedHits(pointOfContact: collisionPoint)
            appliedHits = shooter.appliedHits
        }

        if isBeingMustarded
        {
//            self.run(SKAction.wait(forDuration: 3), completion: {
//                self.isBeingMustarded = false
//            }) //should never be called
            return;
        }
        if strength < 1 // the burger is being destroyed now but still parts are falling
        {
            parentSceneRemoveMe() // if they are still falling and get another hit, remove it ba2a
            return;
        }
        var neededHits = appliedHits
        if appliedHits >= self.strength
        {
            neededHits = strength
        }

        numberOfFallingParts = 0
        if neededHits > 1
        {
            hittingWithMoreThanOneHit = true
        }
        else
        {
            hittingWithMoreThanOneHit = false
        }

        if(isBeingHit) //animation is still running when another hit arrived
        {
            hitsBuffer += 1
            return
        }
        else
        {
            isBeingHit = true
        }

        
        var totalTime:Double = 0
        for _ in 1...neededHits
        {

            self.run(SKAction.sequence([
                SKAction.wait(forDuration: totalTime),
                SKAction.run({self.hitOnePart()})
                ]))
            totalTime += 0.1
        }
        
        self.run(SKAction.sequence([
            SKAction.wait(forDuration: totalTime),
            SKAction.run({self.adjustPartsPositionsAndPhysics(false)})
            ]))
        
        
        //TODO: after understanding dispatch queues, the Burger will handle adjusting the remaining parts positions and will be called here, so i get full control over it.. Also calling isBeingHit = false should be here, after felling all parts.

    }

    func applyBufferedHits(shooter: Shooter, hittingPoint: CGPoint)
    {
        if hitsBuffer > 0
        {
            wasApplyingBufferedHits = true
            self.gotOneHit(hitter: shooter, collisionPoint: hittingPoint)

        }
    }
    
    func hitOnePart()
    {
        
        //actual hitting
        
        //      SoundPlayer.playSound(Sounds.TargetHit)
        
        if strength > 1 // only a part or more will be removed
        {
            numberOfFallingParts += 1
            if let removedChild = self.childNode(withName: String(strength)) as? BurgerPart
            {
                removedChild.isBeingRemoved = true
                removedChild.zRotation = 0 // to reset any previous animation

                animateHittingOnePart(removedPart: removedChild)
            }
        }
        strength = strength - 1
        if(strength < 1)
        {
            if hittingWithMoreThanOneHit // there are some parts to be explde first
            {
                toBeDestroyed = true // just mark it for destroying.. and the falling parts will call the function when they reach the ground
            }
            else
            {
                
                parentSceneRemoveMe()
            }
        }
    }
    
    func destroyIfNoFallingPartsStillExist()
    {
        if toBeDestroyed
        {
            if numberOfFallingParts == 0
            {
                parentSceneRemoveMe()
            }
        }
        
    }

    func parentSceneRemoveMe() // so that parent scene check for win after doing that
    {
        if let parentScene = SJLevelScene.currentLevelScene
        {
            parentScene.destroyOneBurger(destroyed: self)
        }
    }
    func removeWithAnimation()
    {

        self.explodeWithOwnPicture(emitterFileName: "burger")
        self.removeFromParent()
        isBeingDestroyed = true
        isBeingHit = true

    }
    func destroy()
    {
        
        
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
}

