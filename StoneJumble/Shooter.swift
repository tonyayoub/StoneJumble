//
//  Shooter.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 11/8/15.
//  Copyright © 2015 amahy. All rights reserved.
//

import SpriteKit


class Shooter: SJSpriteNode
{
    let _power:CGFloat = 4
    var addons = [Addon]()
    var appliedHits = 1
    var numberOfSpawns = 0

    func calculateAppliedHits(pointOfContact: CGPoint)
    {
        let numberOfAvocado = containsAddonOfType(checkedType: .avocado)
        let numberOfApple = containsAddonOfType(checkedType: .apple)
        if numberOfAvocado == 0 && numberOfApple == 0
        {
            appliedHits = 1 //applied hits is used in target class, so we change it here
        }
        else
        {
            if numberOfAvocado > 0
            {
                appliedHits = 99
            }
            else
            {
                if numberOfApple == 0
                {
                    appliedHits = 1
                }
                else
                {
                    appliedHits = numberOfApple * 2
                }


            }
        }
        if appliedHits > 1
        {

            let hitsLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
            hitsLabel.text = "x\(appliedHits)"
            if appliedHits >= 99 //avocado
            {
                hitsLabel.text = "x10"
            }
            self.parent?.addChild(hitsLabel)
            hitsLabel.zPosition = 9999
            hitsLabel.alpha = 0.9
            hitsLabel.position = pointOfContact
            hitsLabel.run(SKAction.sequence([
                SKAction.wait(forDuration: 0.2),
                SKAction.group([
                    SKAction.scale(to: 0.1, duration: 1),
                    SKAction.fadeOut(withDuration: 1)]),
                SKAction.removeFromParent()
                ]))
        }
    }

    func makeShooterCollideWithShooter()
    {
        self.physicsBody?.collisionBitMask |=  SJDirector.shooterCategory
    }
    override func createPhysicsBody()
    {
        self.physicsBody = SKPhysicsBody(circleOfRadius: 0.95 * self.frame.size.width/2)

        if let shooterPhysics = self.physicsBody
        {
            shooterPhysics.mass = 2
            shooterPhysics.restitution = 1.0
       //     shooterPhysics.usesPreciseCollisionDetection = true
            shooterPhysics.isDynamic = true
            shooterPhysics.friction = 0.0;
            shooterPhysics.affectedByGravity = false
            shooterPhysics.categoryBitMask = SJDirector.shooterCategory;
            shooterPhysics.collisionBitMask = SJDirector.burgerCategory | SJDirector.frameCategory | SJDirector.bottomCategory | SJDirector.edgeCategory | SJDirector.obstacleCategory | SJDirector.addOnCategory //| SJDirector.shooterCategory
            shooterPhysics.isDynamic = true
            shooterPhysics.contactTestBitMask = SJDirector.burgerCategory | SJDirector.burgerPartCategory | SJDirector.obstacleCategory | SJDirector.frameCategory | SJDirector.bottomCategory | SJDirector.edgeCategory | SJDirector.addOnCategory
        }



        //    self.shader = SKShader(fileNamed: "test")
    }


    func shoot(_ v: CGVector)
    {

        var numberOfBanana = containsAddonOfType(checkedType: .banana)
        var numberOfCarrot = containsAddonOfType(checkedType: .carrot)



        if numberOfCarrot > 0
        {
            if numberOfCarrot > 5
            {
                numberOfCarrot = 5
            }

        }
        var damping = 0.7 - (0.1 * CGFloat(numberOfCarrot)) //0.4 for 1 carrot, 0.3 for 2 ..etc
        if damping <= 0
        {
            damping = 0.1
        }
        self.physicsBody?.linearDamping = damping
     //   self.physicsBody?.mass = 2
      //  self.physicsBody?.linearDamping = 0.0
        // print("============================density: \(String(describing: self.physicsBody?.density))")
        // print("============================mass: \(String(describing: self.physicsBody?.mass))")
        // print("============================area: \(String(describing: (SJLevelScene.currentLevelScene?.frame.width)! * (SJLevelScene.currentLevelScene?.frame.height)!))")



        //4 without carrot
        //4 * 3 with 1 carrot
        //4 * 5 with 2 carrots
        //4 * 7 ...






        if numberOfBanana > 0
        {
            self.physicsBody?.isDynamic = false
            // print(vectorNorm(v))
            if numberOfBanana > 5
            {
                numberOfBanana = 5
            }
            var alpha:CGFloat = 0.2 //angle
            let usedVector = v
            if v.dy < 0
            {
                alpha *= -1
            }

            func spawnChildren(waitingTime: Double)
            {
                let shootingVector = getShootingVector(touchingVector: v)

//                for i in 0...2
//                {
//                    self.run(SKAction.wait(forDuration: Double(i) * 0.2), completion: {
//                        self.spawnChild(waitingTime: waitingTime, vector: shootingVector, power: self._power)
//                    })
//                }
                self.spawnChild(waitingTime: waitingTime, vector: rotateVector(vector: shootingVector, angle: alpha), power: _power)
                self.spawnChild(waitingTime: waitingTime, vector: rotateVector(vector: shootingVector, angle: 0), power: _power)
                self.spawnChild(waitingTime: waitingTime, vector: rotateVector(vector: shootingVector, angle: -alpha), power: _power)
            }

            for i in 1...numberOfBanana
            {
                spawnChildren(waitingTime: Double(i-1) * 0.3)
            }

        }
        else
        {
            self.physicsBody?.isDynamic = true
            self.physicsBody?.applyImpulse(getShootingVector(touchingVector: v))
        }
        consumeAddons()
        removeExpiredAddons()

        arrangeAddons()
  //      self.run(SKAction.wait(forDuration: 1), completion: {self.physicsBody?.fieldBitMask = SJDirector.mustardGravityCategory})
        
    }

    func getShootingVector(touchingVector: CGVector) -> CGVector
    {
        var speedFactor:CGFloat = 1000 //not used actually
        var carrotFactor:CGFloat = 4
        if let frameHeight = SJLevelScene.currentLevelScene?.frame.size.height, let frameWidth = SJLevelScene.currentLevelScene?.frame.size.width
        {
            // iPhone aspect 9:16 and iPad 3:4
            // small Aspect in both is smaller than 1
            // but in iPhone much smaller (~0.5 vs. ~ 0.7)
            // so when power in iPhone is bigger multiply with aspect in both
            // so that power in iPhone is multiplied by 0.5 while in iPad by 0.75
            // what if it became much smaller?
            // multiply with square root of aspect (~0.7 vs ~0.8)
            // no.. now as if i didn't multiply with anything
            // // 0.5 vs 0.7 is too much and 0.7 vs 0.8 is too little
            // multiply withy aspect to the power of 1.5 (0.66 vs 0.8)
            // and so on

            //aspect in iPhone = 0.5
            // aspect in iPad = 0.75
            //


            let smallAspect:Float = Float(frameWidth) / Float(frameHeight) // small in
            let rootFactor = 1
            //the bigger this number, the lower the degradation of iPhone speed
            // 1: we are degrading the speed of iPhone by a very big factor
            //2: we are degrading with a small factor
            //3: we are almost not degrading

            // rootFactor : iPhoneFactor : iPadFactor
            // 1          :     0.5625   : 0.75
            // 1.5        :     0.6814   : 0.8255
            // 2          :     0.75     : 0.866

            let iPhoneVsiPadFactor:Float = powf(smallAspect, Float(1/rootFactor)) // < 1
        //    iPhoneVsiPadFactor = iPhoneVsiPadFactor * iPhoneVsiPadFactor
        //    iPhoneVsiPadFactor *= 1.25 //0.395 iPhone, 0.703 iPad

         //   iPhoneVsiPadFactor = sqrt(smallAspect)

            speedFactor = sqrt(pow(frameHeight,2) + pow(frameWidth,2)) //proprotinaol to the hypotenues
            //speedFactor = ((frameHeight * frameWidth) / 400)
            speedFactor *= CGFloat(iPhoneVsiPadFactor)
            speedFactor *= 0.8 //to reduce power
            carrotFactor *= CGFloat(iPhoneVsiPadFactor)

            // H * W / 400 : proprotinal to area but it was difficult in iphone more than ipad probably due to small area of iphone
            // * H/W : multiplying with aspect ratio which is 1.7 in iphone and 1.3 in ipad

            // print("speedFactor: \(speedFactor)")

        }
        // print("speedFactor: \(speedFactor)")
        let unitShootingVector = unitVector(touchingVector)
        carrotFactor = 1
        let usedPower = _power * CGFloat(1 + carrotFactor * CGFloat(containsAddonOfType(checkedType: .carrot)))

        let shootingVector = multiplyVector(unitShootingVector, value: (speedFactor * usedPower))
        // print("final power: \(speedFactor * usedPower)")
        //            let powerLabel = SKLabelNode(fontNamed: "Arial")
        //            powerLabel.text = "\(speedFactor * usedPower)"
        //            self.parent!.addChild(powerLabel)
        //            powerLabel.position = self.position
        //            powerLabel.zPosition = 100
        //            powerLabel.run(SKAction.wait(forDuration: 3), completion: {powerLabel.removeFromParent()})
        return shootingVector
    }

    func spawnChild(waitingTime: Double, vector: CGVector, power: CGFloat)
    {
        let childShooter = self.copy() as! Shooter
        childShooter.physicsBody?.isDynamic = true
        self.parent?.addChild(childShooter)
        self.numberOfSpawns += 1
        childShooter.position = self.position
        childShooter.alpha = 0.8
        childShooter.setScale(0.8)
        if let ph = self.physicsBody
        {
            childShooter.physicsBody?.allowsRotation = false
            childShooter.physicsBody?.mass = ph.mass
            childShooter.physicsBody?.linearDamping = 0.2
            childShooter.physicsBody?.restitution = 0.8
        }

      //  childShooter.physicsBody?.linearDamping = 0.7
   //     childShooter.physicsBody?.restitution = 0.8

        childShooter.run(SKAction.wait(forDuration: waitingTime), completion: {
            childShooter.physicsBody?.applyImpulse(vector)
            childShooter.run(SKAction.wait(forDuration: 0.1), completion: {
                childShooter.makeShooterCollideWithShooter()
            })
            childShooter.name = "spawn" //if we put this name earlier, it will be removed in the scene update method by considering it not moving
            SJDirector.shared.sound.runSoundAction(owner: self, soundAction: SKAction.playSoundFileNamed("spawn", waitForCompletion: false))


        })

        childShooter.zPosition = self.zPosition - 1
    }
    
//    override init(texture: SKTexture?, color: UIColor, size: CGSize)
//    {
//        
//        super.init(texture: texture, color: color, size: size)
//    }


    /*
     attachedAddon.physicsBody = nil
     attachedAddon.setScale(0.8)
     attachedAddon.zPosition = 99
     attachedAddon.move(toParent: self)
     */
    func arrangeAddons()
    {
        let sortedAddons = addons.sorted(by: {(a1: Addon, a2: Addon) -> Bool in return a1.lifeTime > a2.lifeTime})

        var zPos:CGFloat = 99

        


        for addon in sortedAddons
        {
            

            let shrinkedScale = CGFloat(addon.initialScale * powf(0.8, Float(5 - addon.lifeTime)))
            addon.setScale(shrinkedScale)
            addon.zPosition = zPos
            zPos += 1
        }
    }

    func printAddons()
    {
        let sortedAddonsOnly = addons.sorted(by: {(a1: Addon, a2: Addon) -> Bool in return a1.lifeTime > a2.lifeTime})

        for sor in sortedAddonsOnly
        {
            print("\(sor.addonType): expiry: \(sor.lifeTime)")
        }
    }

    func removeAllAddons()
    {
        for addon in self.addons
        {
            addon.removeFromParent()
        }
        self.addons = [Addon]()

    }
    func removeExpiredAddons()
    {
        var newAddons = [Addon]()
        for (_, addon) in addons.enumerated()
        {
            if addon.lifeTime > 0
            {
                newAddons.append(addon)
            }
            else
            {
                // print("addon with lifetime \(addon.lifeTime) is removed")
            }
            self.addons = newAddons
        }
            return;

//                let action = SKAction.group([SKAction.fadeOut(withDuration: 2)

    }

    func consumeAddons()
    {
        if let scene = SJLevelScene.currentLevelScene
        {
            if scene.isTutorial
            {
                return
            }
        }
        var numberOfEmissions = 3
        for (index, _) in addons.enumerated()
        {
            let addon = addons[index]
            //not to emit too much
            if numberOfEmissions > 0
            {
                addon.emit()
                numberOfEmissions -= 1
            }

            addon.lifeTime -= 1
            // print("lifetime: \(addon.lifeTime)")
            if addon.lifeTime <= 1
            {
                addon.isHidden = true
            }
        }
    }


    func attachPurchasedAddon(type: AddonType)
    {
        let attachedAddon = Addon(imageNamed: type.rawValue)
        attachedAddon.addonType = type
        attachedAddon.imageName = type.rawValue
        let resSoundFile: String = type.rawValue + ".wav"
        attachedAddon.soundAction = SKAction.playSoundFileNamed(resSoundFile, waitForCompletion: true)

        self.addons.append(attachedAddon)
        attachedAddon.playSound()
        attachedAddon.physicsBody = nil

        attachedAddon.move(toParent: self)
        attachedAddon.position = CGPoint.zero
        attachedAddon.zPosition = self.zPosition + 1
        attachedAddon.calculateInitialScale()
        arrangeAddons()
    }


    func attachAddon(attachedAddon: Addon)
    {
        self.addons.append(attachedAddon)
        attachedAddon.playSound()
        attachedAddon.physicsBody = nil

        attachedAddon.move(toParent: self)
        attachedAddon.run(SKAction.sequence([
            SKAction.move(to: CGPoint.zero, duration: 0.075)
            ]))//because sometimes this line does not execute so may be due to the move took more time




        attachedAddon.zPosition = self.zPosition + 1

        arrangeAddons()
    }

    func containsAddonOfType(checkedType: AddonType) ->Int
    {
        var res = 0
        for addon in addons
        {
            if addon.addonType == checkedType && addon.lifeTime > 0
            {
                res += 1
            }
        }

        if res > 5
        {
            res = 5 // to prevent extremely fast shooter
        }
        return res
    }
//    required init?(coder aDecoder: NSCoder)
//    {
//        super.init(coder: aDecoder)
//    }
}
