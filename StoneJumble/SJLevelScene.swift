//
//  SJLevelScene.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 11/8/15.
//  Copyright © 2015 amahy. All rights reserved.
//

import SpriteKit

class SJLevelScene: SKScene, XMLParserDelegate, SKPhysicsContactDelegate
{
    
    static var currentLevelScene:SJLevelScene?
    var numberOfContacts = 0
    var addHitsOffered = false
    var _yPositionToPlaceObject:CGFloat = 0
    var _sparkTest:SKEmitterNode?
    var isTutorial = false
    var tutorialScene:Tutorial?
    let particleLayerNode = SKNode()


    
  //  let _bubble = SKSpriteNode(imageNamed: "bubble")
    let bottom = SKSpriteNode(imageNamed: "floor")
    let top = SKSpriteNode(imageNamed: "ceiling")

    var lastSpawnTimeInterval:CFTimeInterval = 0
    var lastUpdateTimeInterval:CFTimeInterval = 0
    var timeToCompareWith:CFTimeInterval = 1 // it is 1 at the beginning then increased, so that after 1 second collect objects, after 3 seconds fire them ..etc
   
    var delayedActions = ActionsReg()
    let noAnimation = true;
    let container = SKNode()
    var originalNumberOfHits:Int
    {
        get
        {
            
            return SJDirector.shared.originalNumberOfHits
        }
        set(newNumberOfHits)
        {
            SJDirector.shared.originalNumberOfHits = newNumberOfHits
        }
    }
    var hitsRemaining:Int
    {
        get
        {
            return SJDirector.shared._hitsRemaining
        }
        set(newNumberOfHits)
        {
            SJDirector.shared._hitsRemaining = newNumberOfHits
            delayedActions.checkActions()
            hitsLeftLabel.text = String(newNumberOfHits)
         //   let hitsSprite = container.childNode(withName: "hits")
         //   hitsSprite?.run(SKAction.sequence([SKAction.scale(to: 1.05, duration: 0.1),SKAction.scale(to: 1.0, duration: 0.1)]))
        }
    }


    
    
    private static var _status = LevelStatus.start
    static var status:LevelStatus
    {
        get
        {
            return _status
        }
        set(newStatus)
        {
            // print("status changed from \(_status) to \(newStatus)")
            _status = newStatus
        }
    }
    
    var _shooter = Shooter(imageNamed: "shooter")

    
    
    var _panRecognizer: UIPanGestureRecognizer?
    var _tapRecognizer: UITapGestureRecognizer?
    var hitsLeftLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
    var goldLabel = SKLabelNode(fontNamed: "MarkerFelt-Thin")

    override init(size: CGSize)
    {
       // _levelString = levelString

        super.init(size: size)
        SJLevelScene.currentLevelScene = self
    }

    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView)
    {
        NPDirector.shared.showBanner()
        createSceneContentsFromLevelData()
        if NPDirector.shared.currentEpisodeID == 1 && NPDirector.shared.currentLevelID == 1
        {
            isTutorial = true
            print("tutorial .............")
            NPDirector.shared.hideBanner()

        }
        
    }

    
    func createSceneContentsFromLevelData()
    {
        addHitsOffered = false
        Fries.oneFriesIsBeingAdded = false
        Chartboost.cacheInterstitial(CBLocationHomeScreen)
        Chartboost.cacheRewardedVideo(CBLocationHomeScreen)
        _tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SJLevelScene.handleTap(_:)))
        _tapRecognizer?.cancelsTouchesInView = false //without this line, when i reload the main menu after finishing the level, touchesEnded are not recognized
        
        view?.addGestureRecognizer(_tapRecognizer!)

        self.addChild(container)
        
        container.addChild(particleLayerNode)
        particleLayerNode.zPosition = 10
        
        
        
        
        //bacground
        //let _bg = SKSpriteNode(color: SKColor.black, size: self.frame.size)
//        let _bg = SKSpriteNode(imageNamed: "won-bg")
        let _bg = SKSpriteNode(imageNamed: "bg")
        _bg.position = CGPoint(x: 0, y: 0)
        _bg.name = "bg"
        _bg.anchorPoint = CGPoint(x: 0, y: 0)
        _bg.zPosition = -100
        container.addChild(_bg)
        
    
        
        //creating border
        
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
 //       self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = SJDirector.frameCategory
        self.physicsBody?.friction = 0.3;
      //  self.physicsBody?.linearDamping = 0.5;
        
        //general physics properties
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -9.8)
        self.physicsWorld.contactDelegate = self


        self.physicsBody?.categoryBitMask = SJDirector.frameCategory

        createLevelCharacters()

    }
       
    func createLevelCharacters()
    {
        //bottom
      //  let bottomY = (Constants.Dimensions.NotUsedHeightPercentage)*self.frame.height - bottom.frame.height/2
        //bottom.anchorPoint = CGPoint(x: 0.5, y: 0)
        bottom.position = CGPoint(x: self.size.width/2, y: bottom.size.height/2)
        let bottomSize = bottom.frame.size
  //      bottomSize.height *= 0.9
        bottom.physicsBody = SKPhysicsBody(rectangleOf: bottomSize)
        
        bottom.physicsBody?.categoryBitMask = SJDirector.bottomCategory
        
        bottom.physicsBody?.isDynamic = false
        bottom.zPosition = 1
        bottom.physicsBody?.affectedByGravity = false
        bottom.name = "bottom"
        container.addChild(bottom)

        //top

        top.position = CGPoint(x: self.size.width/2, y: size.height - top.size.height/2)
        let topsize = top.frame.size
        //      bottomSize.height *= 0.9
        top.physicsBody = SKPhysicsBody(rectangleOf: topsize)

        top.physicsBody?.categoryBitMask = SJDirector.bottomCategory

        top.physicsBody?.isDynamic = false
        top.zPosition = 1
        top.physicsBody?.affectedByGravity = false
        top.name = "top"
        container.addChild(top)


        

        
        let shooterX = self.frame.midX
        var shooterY = bottom.size.height/2 + _shooter.size.height/2
        shooterY *= 1.9
        _shooter.initialPosition = CGPoint(x: shooterX, y: shooterY);
        _shooter.zPosition = 10
        _shooter.position = _shooter.initialPosition
        let dummyNode = SKSpriteNode(color: UIColor.clear, size: CGSize(width: _shooter.size.width*1.5, height: _shooter.size.height*1.5))
        dummyNode.position = _shooter.initialPosition
        dummyNode.name = "dummy"
        container.addChild(dummyNode)
        _shooter.isHidden = true
        container.addChild(_shooter)

   
        
        createBottomArea()

        hitsRemaining = SJDirector.shared._hitsRemaining
        SJDirector.shared.originalNumberOfHits = hitsRemaining


        Boxes.showStartMessage(episdoeID: NPDirector.shared.currentEpisodeID, levelID: NPDirector.shared.currentLevelID, parentScene: self)
    }
    func createBottomArea()
    {
        //hits label
        let hitsSprite = SKSpriteNode(imageNamed: "hitsLabel")
        hitsSprite.zPosition = 9
        hitsSprite.position = CGPoint(x: container.calculateAccumulatedFrame().midX, y: hitsSprite.size.height * 0.5)
        hitsSprite.name = "hits"
        container.addChild(hitsSprite)
   //     hitsLeftLabel.horizontalAlignmentMode = .center
   //     hitsLeftLabel.verticalAlignmentMode = .center
        hitsLeftLabel.fontSize = NPDirector.shared.hitsLabelSize
        hitsLeftLabel.zPosition = 5
//        hitsLeftLabel.fontColor = SKColor(red: 0.4, green: 0.8, blue: 1, alpha: 1)
        hitsLeftLabel.fontColor = SKColor(red: 0.25, green: 0.125, blue: 0.05 , alpha: 1)
      //  hitsLeftLabel.fontColor = SKColor.blue

   //     hitsLeftLabel.fontColor = SKColor.darkGray
        hitsLeftLabel.horizontalAlignmentMode = .center
        hitsLeftLabel.verticalAlignmentMode = .center
  //      hitsLeftLabel.position.x -= hitsSprite.size.width * 0.05
  //      hitsLeftLabel.position.y += hitsSprite.size.height * 0.05


        hitsSprite.addChild(hitsLeftLabel)
        
 
      
        


        
        
        //gold


         
         
        let gold = EffectButton(img: "addGold")
         
        gold.zPosition = 9
        gold.position = hitsSprite.position
        //gold.position.x += (hitsSprite.calculateAccumulatedFrame().width/2) + (gold.calculateAccumulatedFrame().width/2)
        gold.position.x = self.frame.width - (gold.calculateAccumulatedFrame().width/2)
        goldLabel.position.y -= gold.calculateAccumulatedFrame().height * 0.08

     //   gold.position.y += gold.calculateAccumulatedFrame().height * 0.08
        container.addChild(gold)
         
        goldLabel.text = "\(SJDirector.shared.goldCredit)"
        goldLabel.zPosition = 10

        goldLabel.fontColor = SKColor(red: 80/255, green: 49/255, blue: 10/255, alpha: 1)
//      goldLabel.fontColor = SKColor.black
        goldLabel.fontSize = gold.calculateAccumulatedFrame().height * 0.15
        goldLabel.verticalAlignmentMode = .center
        
        gold.addChild(goldLabel)

        func showAddGold()
        {

            if(!Chartboost.hasRewardedVideo(CBLocationHomeScreen))
            {
                Chartboost.cacheRewardedVideo(CBLocationHomeScreen)
                let notAvailableLabel = SKSpriteNode(imageNamed: "noGold")
                notAvailableLabel.zPosition = 99
                gold.addChild(notAvailableLabel)
                notAvailableLabel.run(SKAction.wait(forDuration: 0.5), completion: {notAvailableLabel.removeFromParent()})
                return;
            }
            if SJLevelScene.status == .playing && hitsRemaining > 0
            {
                SJDirector.shared.sound.runSoundAction(owner: self, soundAction: SKAction.playSoundFileNamed("addGold", waitForCompletion: false))

                NPDirector.shared.gamePaused = true
                Boxes.showAddGoldConfirmation(ownerFrame: self.frame, parentSKNode: self.container)
            }
        }
        gold.onTouched = showAddGold


        //booster
        func showAddonShopping()
        {
            if SJLevelScene.status == .playing && hitsRemaining > 0
            {
                SJDirector.shared.sound.runSoundAction(owner: self, soundAction: SKAction.playSoundFileNamed("addAddon", waitForCompletion: false))
                NPDirector.shared.gamePaused = true
                Boxes.showAddonShopping(ownerFrame: self.frame, parentSKNode: self.container)
            }
        }
        let booster = EffectButton(img: "booster")

        booster.onTouched = showAddonShopping
        booster.zPosition = 9
        booster.position = hitsSprite.position
        booster.position.x += (hitsSprite.size.width)/2 + (booster.calculateAccumulatedFrame().size.width/2)
        booster.position.y = gold.position.y
        booster.name = "booster"
        container.addChild(booster)
//      let goldLabelSprite = SKSpriteNode(imageNamed: "creditLabel")
//        goldLabelSprite.zPosition = 10
//        gold.addChild(goldLabelSprite)
//        goldLabelSprite.position.y += (gold.calculateAccumulatedFrame().height/2 - goldLabelSprite.size.height/2)

 
        
        
        //home button (testing)
        let pauseIcon = EffectButton(img: "pause")
        //      homeIcon.position = CGPoint(x: self.frame.midX, y: homeIcon.calculateAccumulatedFrame().height * 0.8)
        
        func exitConfirmation()
        {
            if SJLevelScene.status != .playing
            {
                return
            }
            if hitsRemaining > 0 // if hits remaining == 0, another dialog will appear soon 
            {
                NPDirector.shared.gamePaused = true
                Boxes.showExitConfirmation(ownerFrame: self.frame, parentSKNode: self.container)
            }
            else
            {
                hitsSprite.run(SKAction.sequence([
                    SKAction.scale(to: 1.2, duration: 0.05),
                    SKAction.scale(to: 1, duration: 0.05)
                    ]))
            }
            
        }
        //        homeIcon.onTouched = NPDirector.displayMainMenu
        pauseIcon.onTouched = exitConfirmation
        pauseIcon.position = CGPoint(x: pauseIcon.calculateAccumulatedFrame().width * 0.5, y: hitsSprite.position.y)
        container.addChild(pauseIcon)

        let musicIcon = EffectButton(img: "music", switchImg: "mute")
        musicIcon.onTouched = NPDirector.changeMusicEnabled
        musicIcon.position = pauseIcon.position
        musicIcon.position.x += musicIcon.calculateAccumulatedFrame().width
        container.addChild(musicIcon)
        musicIcon.childNode(withName: "switch")?.isHidden = NPDirector.shared.musicEnabled



        let soundIcon = EffectButton(img: "sound", switchImg: "mute")
        soundIcon.onTouched = NPDirector.changeSoundEnabled
        soundIcon.position = musicIcon.position
        soundIcon.position.x += soundIcon.calculateAccumulatedFrame().width
        container.addChild(soundIcon)
        soundIcon.childNode(withName: "switch")?.isHidden = NPDirector.shared.soundEnabled

        var indicatorImageName = "hand"
        if SJDirector.shared.isTimeLevel
        {

            if NPDirector.shared.soundEnabled
            {
                playTickSound()
            }
            indicatorImageName = "clock"
            let indicator = SKSpriteNode(imageNamed: indicatorImageName)
            indicator.position = hitsSprite.position
            indicator.position.x -= hitsSprite.size.width/2
            //indicator.position.y -= hitsSprite.size.height/2
            // indicator.setScale(0.5)
            indicator.zPosition = 9
            indicator.name = "indicator"
          //  indicator.setScale(0.7)
         //   container.addChild(indicator)

        }




    }
    func playTickSound()
    {
        let tickSoundAction = SKAction.repeatForever(SKAction.playSoundFileNamed("tick", waitForCompletion: true))
        self.run(tickSoundAction, withKey: "tick")
    }
  
    func getMinY() -> CGFloat
    {
        return bottom.size.height
    }
    func anyObjectMoving() ->Bool
    {
 
        var res = false;
        for node in self.children
        {
            if let rsNode = node as? SJSpriteNode
            {
                if (rsNode.isMoving)
                {
                    res = true;
                    break;
                }
            }
            else
            {
                //("node is not HRSpriteNode")
            }
            
        }
        res = false
        return res
    }
    

    func shoot(destination: CGPoint)
    {
        if (NPDirector.shared.gamePaused) || (SJLevelScene.status != .playing)
        {
            return
        }
        if self.bottom.contains(destination)
        {
            /*
             adding a strength count to every single burger

             */
            return
        }
        if _shooter.contains(destination)
        {
            if(isTutorial)
            {
                if let tutorial = tutorialScene
                {
                    tutorial.shooterStopped()
                }
            }
            return
        }

        if(SJLevelScene.status == .gameEnded)
        {
            //levelEndDialogue?.handleTouch(skTouchLocation)
            return;
        }
        //test restart
        //        NPDirector.startLevel(SJLevelCreator.createLevelData(NPDirector.shared.currentEpisodeID, levelID: NPDirector.shared.currentLevelID))
        //        return;
        switch SJLevelScene.status
        {

        case .checkingTargetsPlaced:
            return
            //            _status = .ShowingTargets
            //            showBurgersAndObstacles()
        //            moveObjectsToInitialPositions()
        case .playing:
            if hitsRemaining < 1
            {
                return
            }
            
            SJDirector.shared.sound.playLevelSound(sound: .tapShooter)

            //   NSLog("viewTouchLocation: (%f, %f)", viewTouchLocation.x, viewTouchLocation.y)
            //    NSLog("skTouchLocation: (%f, %f)", skTouchLocation.x, skTouchLocation.y)
            //    NSLog("shooter: (%f, %f)", _shooter.position.x, _shooter.position.y)

            let vDisplacement = pSub(destination, p2: _shooter.position)

            _shooter.shoot(vDisplacement)
            if(SJDirector.shared.isTimeLevel)
            {
                // print("timer level")
            }
            else
            {
                if !isTutorial
                {
                    hitsRemaining -= 1
                }

            }

            //        NSLog("skTouchLocation", skTouchLocation.x, skTouchLocation.y)

        default:
            return;
        }

    }
    func clearRay()
    {
        container.enumerateChildNodes(withName: "dot")
        { node, _ in
            node.removeFromParent()
        }
    }
    func drawRay(touchPoint: CGPoint)
    {
        if NPDirector.shared.gamePaused
        {
            return
        }
        
        if let shooterBody = _shooter.physicsBody
        {
            shooterBody.velocity = CGVector(dx: 0, dy: 0)
        }
        else
        {
            return
        }

        clearRay()
        var loc = _shooter.position
        let horDiff = touchPoint.x - loc.x
        let verDiff = touchPoint.y - loc.y
        let numberOfDots = distanceBetweenTwoPoints(touchPoint, p2: _shooter.position) / (_shooter.size.width * 0.8)
        let numberOfCarrot = _shooter.containsAddonOfType(checkedType: .carrot)
        for i in 1...Int(numberOfDots + 1)
        {
            let dot = SKSpriteNode(imageNamed: "dot")
            dot.name = "dot"
            loc.x += horDiff/CGFloat(numberOfDots)
            loc.y += verDiff/CGFloat(numberOfDots)
            dot.position = loc
            dot.zPosition = 99
            self.container.addChild(dot)


            let scale = 1.0 - CGFloat(i)/numberOfDots
            dot.setScale(scale)
            dot.alpha = scale

            if numberOfCarrot > 0
            {
                let speedLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
                speedLabel.position.y -= (dot.size.height * scale)
                speedLabel.text = "x\(numberOfCarrot * 2)"
                dot.addChild(speedLabel)
            }
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch = touches.first
        {
            let viewTouchLocation = touch.location(in: self.view)
            let skTouchLocation = self.convertPoint(fromView: viewTouchLocation)
            if bottom.contains(skTouchLocation)
            {
                clearRay()
            }
            else
            {
                drawRay(touchPoint: skTouchLocation)
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {

        clearRay()
        if isTutorial && Tutorial.pauseShooting
        {
            tutorialScene?.touchReceived()
            return
        }
        if let touch = touches.first
        {
            let viewTouchLocation = touch.location(in: self.view)
            let skTouchLocation = self.convertPoint(fromView: viewTouchLocation)
            shoot(destination: skTouchLocation)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {

        if isTutorial && Tutorial.pauseShooting
        {
            return
        }
        if let touch = touches.first
        {
            let viewTouchLocation = touch.location(in: self.view)
            let skTouchLocation = self.convertPoint(fromView: viewTouchLocation)
            if !bottom.contains(skTouchLocation)
            {
                drawRay(touchPoint: skTouchLocation)
            }

        }
    }
    @IBAction func handleTap(_ recognizer: UITapGestureRecognizer)
    {

//        let viewTouchLocation = recognizer.location(in: self.view)
//        let skTouchLocation = self.convertPoint(fromView: viewTouchLocation)
//        shoot(destination: skTouchLocation)
    }
    
    func testEffects()
    {
        //the method below returns a shapeNode
//        var circle = self.generateImage()
        let effect : SKEffectNode = SKEffectNode()
        let filter : CIFilter = CIFilter(name:"CIGaussianBlur")!
        filter.setValue(10, forKey: "inputRadius")
        
        effect.filter = filter
        effect.position = _shooter.position
        _shooter.move(toParent: effect)
        
        container.addChild(effect)
    }

    var collisionAnimationShowing = false
   
    func didBegin(_ contact: SKPhysicsContact)
    {

        var firstBody:SKPhysicsBody
        var secondBody:SKPhysicsBody

        if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
        {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else
        {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }



        if !collisionAnimationShowing
        {
            collisionAnimationShowing = true
            NPDirector.showEmitter("collision", position: contact.contactPoint, parentNode: container, lifetime: 3)
            self.run(SKAction.wait(forDuration: 0.5), completion: {self.collisionAnimationShowing = false})
        }
        numberOfContacts += 1
        if numberOfContacts > 1
        {
            // print("more than one contact")
        }
        if contact.contactPoint.x < 0 || contact.contactPoint.y < 0
        {
           // print("Contact Point: \(contact.contactPoint)")
         //   return
        }

        var shooterHitting = true
        if((firstBody.categoryBitMask == SJDirector.burgerPartCategory)
            && (secondBody.categoryBitMask == SJDirector.bottomCategory))
        {

            shooterHitting = false
            if let burgerPart = firstBody.node as? BurgerPart
            {
                burgerPart.touchBottom(touchPosition: contact.contactPoint)
                animatePartFallingOnFloor()
            }

        }


        if SJLevelScene.status != LevelStatus.playing && SJLevelScene.status != .checkingLoss //while checking loss you may explode
        {
            // print("not playing, not checking loss")
            return;
        }
        
        
        /* let shake = SKAction.shake(_shooter.position, duration: 0.3)
        _shooter.runAction(shake)
        return*/
        
        //        let shake = SKAction.shake(_bg.position, duration: 0.3)
        //   shakeScene()
        
        

        
        //this to ensure that the body with a smaller category value is firstBody

        // we have 3 possible collisions, shooter hitting frame, burger part hitting bottom, shooter (or spawned shooter hitting a burger, obstacle or addon


        //burger part falling down

        if shooterHitting //shooter hitting something and in this case first body must be shooter
        {
            if SJLevelScene.status == .gameEnded // we did not put this at the beginning to allow parts hitting the floor to expode even if the (out of hits) dialogue is appearing
            {
                // print("collision after end")
                return
            }
            if let shooterOrSpawnedShooter = firstBody.node as? Shooter
            {
                //shooter hitting frame
                if(firstBody.categoryBitMask == SJDirector.shooterCategory  //this check is not important, we are shure it is a shooter
                    &&
                    (
                        secondBody.categoryBitMask == SJDirector.frameCategory || secondBody.categoryBitMask == SJDirector.bottomCategory
                    )
                    )
                {
                    SJDirector.shared.sound.playLevelSound(sound: .reflection)
                }
                else //shooter hitting burger, obstacle or addon
                {
                    if(secondBody.categoryBitMask & SJDirector.burgerCategory != 0) //second body is burger. burger cannot be first body because first body must be shooter because its category is smaller in value
                    {

                        if let hitTarget = secondBody.node as? Burger
                        {

                            SJDirector.shared.sound.playLevelSound(sound: .targetHit)
                            hitTarget.gotOneHit(hitter: shooterOrSpawnedShooter, collisionPoint: contact.contactPoint)
                        //    checkForWin()

                        }
                    }
                    else if(secondBody.categoryBitMask & SJDirector.obstacleCategory != 0)
                    {
                        if let hitObstacle = secondBody.node as? Obstacle
                        {
                            if isTutorial
                            {
                                if let tutorial = tutorialScene
                                {
                                    tutorial.shooterHitObstacle(obstacle: hitObstacle)
                                }
                            }
                            hitObstacle.gotOneHit(hitter: shooterOrSpawnedShooter, collisionPoint: contact.contactPoint)

                        }

                    }
                    else if(secondBody.categoryBitMask & SJDirector.addOnCategory != 0)
                    {
                        if let hitAddon = secondBody.node as? Addon
                        {
                            if isTutorial
                            {
                                if let tutorial = tutorialScene
                                {
                                    tutorial.shooterHitAddon(addon: hitAddon)
                                }
                            }

                            hitAddon.gotOneHit(hitter: shooterOrSpawnedShooter, collisionPoint: contact.contactPoint)
                        }

                    }
                }
            }
        }

        numberOfContacts -= 1

    }
    

//    - (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {
//    
//    self.lastSpawnTimeInterval += timeSinceLast;
//    if (self.lastSpawnTimeInterval > 1) {
//    self.lastSpawnTimeInterval = 0;
//    [self addMonster];
//    }
//    }
//    
//    

    func destroyOneBurger(destroyed:Burger)
    {
        SJDirector.shared.sound.playLevelSound(sound: .targetExplodes)
        destroyed.removeWithAnimation()
        self.container.run(SKAction.shake(self.container.position, duration: 0.25, amplitudeX: 4, amplitudeY: 4))
        checkForWin()
    }

    func animatePartFallingOnFloor()
    {
        SJDirector.shared.sound.playLevelSound(sound: .partTouchesFloor)
        var vibrationDistance = bottom.size.height*0.01
        var startintDuration = 0.05
        var actionsSequence = [SKAction]()
        for _ in 1...10
        {
            actionsSequence.append(SKAction.moveBy(x: 0, y: -vibrationDistance, duration:startintDuration))
            actionsSequence.append(SKAction.moveBy(x: 0, y: vibrationDistance, duration: startintDuration))
            startintDuration *= 0.8
            vibrationDistance *= 0.8
        }
        
        bottom.run(SKAction.sequence(actionsSequence))
    }
    
    func placeObjects()
    {
        var putAddonLeft = true
        ScreenRange.initializeIndex()

        //so that we guarantee targets
        for target in SJLevelCreator._targets
        {
            target.generateInitialPosition()
        }

        ScreenRange.initializeIndex()

        for obstacle in SJLevelCreator._obstacles
        {

            obstacle.generateInitialPosition()
            obstacle.position = obstacle.initialPosition
        }

        ScreenRange.initializeIndex()
        for addon in SJLevelCreator._addons
        {

            addon.generateInitialPosition()
            addon.position = addon.initialPosition
            if(putAddonLeft)
            {
                addon.position.x = -addon.size.width
            }
            else
            {
                addon.position.x = self.frame.maxX + addon.size.width
            }
            putAddonLeft = !putAddonLeft
        }



        

        _shooter.physicsBody?.isDynamic = false //should be called elsewhere
        var timeInc = 0.1
        for target in SJLevelCreator._targets
        {
            target.position.x = target.initialPosition.x
            target.position.y = self.frame.height + target.size.height;
            let time = distanceBetweenTwoPoints(target.position, p2: target.initialPosition) / self.frame.size.height
            let act = SKAction.sequence([
                SKAction.wait(forDuration: timeInc),
                SKAction.move(to: target.initialPosition, duration: TimeInterval(time))
                ])
            timeInc += 0.025
            target.run(act, completion: {
                target._status = TargetStatus.readyToFire
            })




            self.run(SKAction.repeatForever(SKAction.sequence([
                SKAction.wait(forDuration: 5),
                SKAction.run {
                    target.shakeThenSmoke()
                }
                ])))
        }

        timeInc += 0.25

        for obstacle in SJLevelCreator._obstacles
        {
            obstacle.position.x = obstacle.initialPosition.x
            obstacle.position.y = self.frame.height + obstacle.size.height;
            let time = distanceBetweenTwoPoints(obstacle.position, p2: obstacle.initialPosition) / self.frame.size.height
            let act = SKAction.sequence([
                SKAction.wait(forDuration: timeInc),
                SKAction.move(to: obstacle.initialPosition, duration: TimeInterval(time))
                ])
            obstacle.run(act)
        }
        



        
        container.enumerateChildNodes(withName: "dummy")
        { node, _ in
                node.removeFromParent()
        }

        if isTutorial
        {
            tutorialScene = Tutorial(color: UIColor.black, size: self.frame.size)

        }

        

    }


    func moveObstaclesAndAddonsToTheirPositions()
    {

        var waitingTimeBeforeLevelStart = 0.2

        NPDirector.shared.gamePaused = true

        if SJLevelCreator._addons.count > 0
        {
            waitingTimeBeforeLevelStart += 1.25
        }

        //time = 0.5 if there are obstacles
        for addon in SJLevelCreator._addons
        {


            var xDeviation = addon.size.width/5
            if(addon.initialPosition.x < addon.position.x)
            {
                xDeviation *= -1
            }
            var intermediatePosition = addon.initialPosition
            intermediatePosition.x += xDeviation
            let giftAct = SKAction.sequence([
                SKAction.shake(addon.giftMask.position, duration: 0.4),
                SKAction.run {
                    addon.giftMask.move(toParent: self.container)
                    addon.giftMask.explodeWithOwnPicture(emitterFileName: "burger")
                    addon.giftMask.removeFromParent()
                    SJDirector.shared.sound.runSoundAction(owner: addon, soundAction: SKAction.playSoundFileNamed("gift", waitForCompletion: false))
                }
                ])

            addon.run(SKAction.sequence([
                SKAction.move(to: intermediatePosition, duration: 0.4),
                SKAction.move(to: addon.initialPosition, duration: 0.1),
                SKAction.run {
                    addon.createPhysicsBody()
                },
                SKAction.wait(forDuration: 0.2),
                SKAction.run {
                    addon.giftMask.run(giftAct)
                },
                SKAction.scale(to: 1.1, duration: 0.1),
                SKAction.scale(to: 1, duration: 0.05)
                ]))
        }






//        var timeBeforeAddingOneAddon:Double = 0
//        for addon in SJLevelCreator._addons
//        {
//            addon.run(SKAction.sequence([
//                SKAction.wait(forDuration: timeBeforeAddingOneAddon),
//                SKAction.move(to: addon.initialPosition, duration: 0.5),
//                SKAction.run {
//                    addon.createPhysicsBody() // if we create physics body earlier, it may hit the shooter in its way to its position
//                }
//                ]))
//            timeBeforeAddingOneAddon += 0.1
//        }
//
//        let timeBeforeStarting:Double = 0.3 + timeBeforeAddingOneAddon

        self.run(SKAction.wait(forDuration: waitingTimeBeforeLevelStart), completion: {
            NPDirector.shared.gamePaused = false
            SJLevelScene.status = LevelStatus.playing

        })
    }
    func allTargets() -> [Burger]
    {
        var res = [Burger]()
        for node in container.children
        {
            if let target = node as? Burger
            {
                res.append(target)
            }
        }
        return res
    }
    func stopAllTargetsIfAnyOfThemIsVerySlow2()
    {
        var shouldStopAllTargets = false
        for tar in allTargets()
        {
            if(tar._status == TargetStatus.firing && vectorNorm(tar.physicsBody!.velocity) < 5.0)
            {
                
                shouldStopAllTargets = true
                break
            }
        }
        if shouldStopAllTargets
        {
            
            self.run(SKAction.run({
                for tar in self.allTargets()
                {
                    tar.physicsBody?.isDynamic = false
                    tar.run(SKAction.sequence([
                        SKAction.scale(to: 1.1, duration: 0.2),
                        SKAction.scale(to: 1, duration: 0.1)
                        ]))
                }
            
            }))
            
            SJLevelScene.status = LevelStatus.playing //finished creating the scene
            _shooter.physicsBody?.isDynamic = true
        }
    }
    func updateWithTimeSinceLastUpdate(_ timeSinceLast: CFTimeInterval)
    {
      //  // print("time since last: ", timeSinceLast)

        self.lastSpawnTimeInterval += timeSinceLast
        if (self.lastSpawnTimeInterval > timeToCompareWith)
        {
            self.lastSpawnTimeInterval = 0;
            
            //time based levels
            if(SJDirector.shared.isTimeLevel)
            {
                if(!NPDirector.shared.gamePaused && SJLevelScene.status == LevelStatus.playing)
                {
                    if hitsRemaining >= 1
                    {
                        self.hitsRemaining -= 1
                        self.container.childNode(withName: "indicator")?.run(SKAction.sequence([SKAction.scale(by: 1.125, duration: 0.1), SKAction.scale(by: 0.8, duration: 0.1)]))
                      
                    }
                }
            }

        //    animateObjectsAtTheBeginning()
            timeToCompareWith = 1
        }
        
//        if (self.lastSpawnTimeInterval > 3)
//        {
//            self.lastSpawnTimeInterval = 0;
//            ("some time passed......................")
//        }
    }
    
    func inGameMessage2(_ text:String)
    {
        //1
        let label: SKLabelNode = SKLabelNode(
        fontNamed: "AvenirNext-Regular")
        label.text = text
        label.fontSize = 128.0
        label.color = SKColor.white
        //2
        label.position = CGPoint(x: frame.size.width/2,
        y: frame.size.height/2)


        //3
        container.addChild(label)
        //4
        run(SKAction.sequence([
        SKAction.wait(forDuration: 3),
        SKAction.removeFromParent()
        ]))
    }
    func checkForWin()
    {
        if SJLevelScene.status == .gameEnded
        {
            return
        }

        var remainintTargets = [Burger]()
        self.container.enumerateChildNodes(withName: "target-*")
            { node, _ in
                if let target = node as? Burger
                {
                    if self.intersects(target) && !target.isBeingDestroyed //TODO: self.frame.intersects
                    {
                        remainintTargets.append(target)
                    }
                }
        }
        
        
        if remainintTargets.count == 0
        {
            SJDirector.shared.sound.runSoundAction(owner: self, soundAction: SKAction.playSoundFileNamed("win", waitForCompletion: false))
            if isTutorial
            {
                if let tutorial = tutorialScene
                {
                    tutorial.nextStep()
                }
                return;
            }
            SJLevelScene.status = .gameEnded
            self.run(SKAction.wait(forDuration: 0.5), completion: {self.doActionAfterWinningLevel()})
            
        }
    }
    
  
    

    
    func doActionAfterWinningLevel()
    {
        self.container.removeAllChildren()

        GameData.incrementMaxProgress() //writing to Progress file
//        scene.isUserInteractionEnabled = false
//        scene.scaleMode = .aspectFill
//        self.view?.presentScene(scene)
        Boxes.showLevelWon(ownerFrame: self.frame, parentSKNode: self.container)
        

    }
    func showLevelLost()
    {
    //    let dialogueNode = NPDirector.create3OptionsDialogue(ownerFrame: self.frame, parentSKNode: self.container, message: "You are out of hits!", firstImageName: "repeat", secondImageName: "menu", thirdImageName: "add", firstAction: repeatLevel, secondAction: NPDirector.displayMainMenu, thirdAction: NPDirector.displayMainMenu)
      //  levelEndDialogue = LevelEnd(message: LevelEnd.MessageType.lose)
      //  levelEndDialogue!.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        //    container.addChild(levelEndDialogue!)
    }
    func checkForLoss()
    {
        
        var remainintTargets = [Burger]()
        container.enumerateChildNodes(withName: "target-*")
        { node, _ in
            if let target = node as? Burger
            {
                if self.intersects(target) && !(target.isBeingHit || target.hitsBuffer > 0)
                {
                    remainintTargets.append(target)
                }
            }
        }
        
        
        if remainintTargets.count > 0
        {
            
            if(!addHitsOffered && originalNumberOfHits > 5) // if original number <=5 no ad is offered
            {
                if(NPDirector.shared.showAds && Chartboost.hasRewardedVideo(CBLocationHomeScreen))
                {
                    // print("pausing game to show ad")
                    NPDirector.shared.gamePaused = true
                    Boxes.showAddHits(ownerFrame: self.frame, parentSKNode: container)
                    addHitsOffered = true
                }
                else
                {
                    if !Chartboost.hasRewardedVideo(CBLocationHomeScreen) // if that is the reason for not showing ads
                    {
                        Chartboost.cacheRewardedVideo(CBLocationHomeScreen)
                    }
                    SJLevelScene.status = .gameEnded
                    Boxes.showlevelLost(ownerFrame: self.frame, parentSKNode: container)
                     SJDirector.shared.sound.runSoundAction(owner: self, soundAction: SKAction.playSoundFileNamed("lost", waitForCompletion: false))
                }
                
            }
            else
            {
                SJLevelScene.status = .gameEnded
                Boxes.showlevelLost(ownerFrame: self.frame, parentSKNode: container)
            }
        }
        else
        {
            SJLevelScene.status = .playing 

        }

    }
    func setNewLevelStatusIfAllTargetsAreOfStatus(_ desiredTargetStatus:TargetStatus, newLevelStatus:LevelStatus) -> Bool
    {
        var res = true
        for tar in allTargets()
        {
            if tar._status != desiredTargetStatus
            {
                res = false
                break
            }
        }
        if res
        {
            SJLevelScene.status = newLevelStatus
        }
        
        return res
    }
    var lastprintedStauts:LevelStatus?
    override func update(_ currentTime: TimeInterval)
    {
        if(SJLevelScene.status != lastprintedStauts)
        {
            // print(SJLevelScene.status)
            lastprintedStauts = SJLevelScene.status
        }
        
       // _bubble.zRotation += 0.1
        
        // Handle time delta.
        // If we drop below 60fps, we still want everything to move the same distance.
        //tony: currentTime is an absolute number since system restart
        //at the very first call, the result of the subtraction is very big
        var timeSinceLast = currentTime - self.lastUpdateTimeInterval;
        self.lastUpdateTimeInterval = currentTime;
        if (timeSinceLast > 1) // more than a second since last update, tony: is only called at the beginning of the scene when the last call did not happen aslan
        {

            timeSinceLast = 1.0 / 60.0;
            self.lastUpdateTimeInterval = currentTime;
        }
        // we call updateWithTimeSinceLastUpdate every fixed intervals and and let it add the fixed intervals and call when it wants
        self.updateWithTimeSinceLastUpdate(timeSinceLast)
        
        switch SJLevelScene.status
        {
            // this switch statement is used to do the following:
            // to know that all the targets are collected, so that we put the scene status into firing. Why do i need that? so that i start checking targets speeds
        
        case .readyToPlaceObjects:
            SJLevelScene.status = .checkingTargetsPlaced
            placeObjects()
            
        case .checkingTargetsPlaced:
            let allTargetsAreReadyToFire = setNewLevelStatusIfAllTargetsAreOfStatus(TargetStatus.readyToFire, newLevelStatus: LevelStatus.animatingTargets)
            if(allTargetsAreReadyToFire)
            {
                for tar in allTargets()
                {
                    tar._status = .firing
                    tar.run(SKAction.sequence([
                        SKAction.scale(to: 1.2, duration: 0.2),
                        SKAction.scale(to: 1, duration: 0.1)
                        ]), completion: {tar._status = .ready})
                    
                }
            }
          
            
        case .animatingTargets:
            let allTargetsAreInitialPositions = setNewLevelStatusIfAllTargetsAreOfStatus(.ready, newLevelStatus: .puttingObstacles)
            if allTargetsAreInitialPositions
            {
                self._shooter.isHidden = false
                self._shooter.run(SKAction.sequence([
                    SKAction.scale(to: 0.1, duration: 0),
                    SKAction.scale(to: 1.1, duration: 0.2),
                    SKAction.scale(to: 1, duration: 0.1),
                    ]), completion: {self._shooter.createPhysicsBody()
                        self.moveObstaclesAndAddonsToTheirPositions()
                })


            }
         break
        case .playing:
            if isTutorial
            {
                if let tutorial = tutorialScene
                {
                    let shooterVelocity = vectorNorm(_shooter.physicsBody!.velocity)
                    if shooterVelocity > 10
                    {
                        tutorial.shooterMoving()
                    }
                    else if(shooterVelocity < 10 && shooterVelocity > 0) //so that it only fires when it moved then stops
                    {
                        tutorial.shooterStopped()
                        _shooter.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
                    }
                }
            }
            self.container.enumerateChildNodes(withName: "spawn") { node, _ in
                if(vectorNorm(node.physicsBody!.velocity) < 40)
                {
                    node.run(SKAction.fadeOut(withDuration: 0.2), completion:
                        {
                            node.removeFromParent()
                            self._shooter.numberOfSpawns -= 1

                    })
                }
            }
            if hitsRemaining == 0
            {
                // so that we give a chance to the spawned shooters to hit burgers, otherwise a "no hits" dialog may appear (because parent shooter is not moving) while children shooters are still moving around
                let countOfSpawns = self.container["spawn"].count
                if countOfSpawns > 0 && (!SJDirector.shared.isTimeLevel) //because in time level we will not wait for spawns
                {
                    // print(countOfSpawns)
                    return
                }

                if(vectorNorm(_shooter.physicsBody!.velocity) < 10)
                {
                    if _shooter.numberOfSpawns > 0
                    {
                        return
                    }
                    SJLevelScene.status = .checkingLoss
                    //_shooter._isMoving = false
                    _shooter.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
                    checkForLoss()
                }
            }
        case .gameEnded:
            self.removeAction(forKey: "tick")
        default:
            break
        }



    }
    
    //(red: Int16, green: Int16, blue: Int16, stone: Int16, wood: Int16, metal: Int16, bigger: Int16, smaller: Int16, stronger: Int16,
    
}




