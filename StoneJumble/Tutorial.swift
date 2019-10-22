//
//  Tutorial.swift
//  BurgerInvasion
//
//  Created by Tony Sameh on 2/28/18.
//  Copyright © 2018 amahy. All rights reserved.
//

import SpriteKit

class Tutorial: SKSpriteNode
{
    static var currentTutorial:Tutorial?

    static var pauseShooting = false
    var timeBetweenSteps:Double = 3

    var numberOfObstaclesCollisions = 0
    var numberOfAddonsCollisions = 0
    var tutorialStep = 1
    var stepText1 = SKLabelNode(fontNamed: "ChalkDuster")
    var stepText2 = SKLabelNode(fontNamed: "ChalkDuster")
    var stepTextTarget = SKLabelNode(fontNamed: "ChalkDuster")
    var stepTextTouch = SKLabelNode(fontNamed: "ChalkDuster")
    var stepTextShooter = SKLabelNode(fontNamed: "ChalkDuster")
    let touchSprite = SKSpriteNode(imageNamed: "hand")

    var targetNode:SKSpriteNode?
    var targetNodePosition:CGPoint = CGPoint.zero






    override init(texture: SKTexture?, color: UIColor, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }
    init(color: UIColor, size: CGSize)
    {
        let currentProgress = GameData.shared.maxProgress
        if currentProgress.level == 1 && currentProgress.episode == 1
        {
            ProgressManager.saveLevelAch(episodeID: 1, levelID: 1, value: 3)
            GameData.incrementMaxProgress()
        } //once tutorial opened once, it opens the following level
        super.init(texture: nil, color: UIColor.black, size: size)
        Tutorial.currentTutorial = self
        guard let levelScene = SJLevelScene.currentLevelScene else
        {
            return
        }
        levelScene.container.addChild(self)
        self.alpha = 0.8
        self.anchorPoint = CGPoint.zero
        self.zPosition = 99

        self.addChild(touchSprite)
        touchSprite.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        touchSprite.alpha = 0
        touchSprite.run(SKAction.sequence([
            SKAction.wait(forDuration: 3),
            SKAction.fadeIn(withDuration: 1)
            ]))

        let touchAct = SKAction.repeatForever(SKAction.sequence([
            SKAction.group([
                SKAction.scale(to: 1.2, duration: 1)
               // SKAction.fadeOut(withDuration: 3)
                ]),
            SKAction.scale(to: 1, duration: 1),
         //   SKAction.fadeIn(withDuration: 0.1)
            ]))
        touchSprite.run(touchAct)
        showShooterAndTargets()
        adjustTouchLocation()
        let exitButton = EffectButton(img: "exitTutorial")
        self.addChild(exitButton)
        exitButton.position = CGPoint(x: exitButton.calculateAccumulatedFrame().size.width/2, y: exitButton.calculateAccumulatedFrame().size.height/2)

        func exitTutorial()
        {
            Tutorial.pauseShooting = false
            NPDirector.displayCurrentEpisodeMenu()
        }
        exitButton.onTouched = exitTutorial

        self.addChild(stepText1)
        self.addChild(stepText2)
        self.addChild(stepTextTarget)
        self.addChild(stepTextTouch)
        self.addChild(stepTextShooter)




        let fontSize = levelScene._shooter.size.height * 0.35
        stepText1.fontSize = fontSize
        stepText2.fontSize = fontSize
        stepTextTarget.fontSize = fontSize
        stepTextTouch.fontSize = fontSize
        stepTextShooter.fontSize = fontSize

        createAndAdjustText()



    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }



    func createAndAdjustText()
    {
        guard let levelScene = SJLevelScene.currentLevelScene else
        {
            return
        }

        if tutorialStep >= 11
        {
            createFinalStepText()
        }
        else
        {
            self.createStepText()
        }


        stepText1.position = CGPoint(x: levelScene.frame.midX, y: levelScene.frame.height)
        stepText2.position = stepText1.position

        
        stepTextTarget.position = targetNodePosition
        stepTextTarget.position.x -= stepTextTarget.calculateAccumulatedFrame().width
        stepTextTarget.position.y -= stepTextTarget.fontSize * 0.3
        stepTextTarget.alpha = 0
        stepTextTarget.run(SKAction.sequence([
            SKAction.wait(forDuration: 3),
            SKAction.fadeIn(withDuration: 1)
            ]))

        stepTextShooter.position = levelScene._shooter.position
        stepTextShooter.position.x += stepTextShooter.calculateAccumulatedFrame().width * 0.75
        stepTextShooter.position.y -= stepTextShooter.fontSize * 0.5
        stepTextShooter.alpha = 0
        stepTextShooter.run(SKAction.sequence([
            SKAction.wait(forDuration: 3),
            SKAction.fadeIn(withDuration: 1)
            ]))

        stepTextTouch.position = touchSprite.position
        stepTextTouch.position.x -= stepTextTouch.calculateAccumulatedFrame().width * 0.75
        stepTextTouch.alpha = 0
        stepTextTouch.run(SKAction.sequence([
            SKAction.wait(forDuration: 3),
            SKAction.fadeIn(withDuration: 1)
            ]))
        stepText1.horizontalAlignmentMode = .center
        stepText2.horizontalAlignmentMode = .center
        stepTextTarget.horizontalAlignmentMode = .center

        stepText1.position.y -= stepText2.fontSize * 2
        stepText2.position.y -= stepText2.fontSize * 4
    //    stepTextTarget.position.x -= stepTextTarget.calculateAccumulatedFrame().width

    }

    func createFinalStepText()
    {
        guard let levelScene = SJLevelScene.currentLevelScene else
        {
            return
        }
        var text1A = ""
        var text2A = ""
        var text1B = ""
        var text2B = ""
        let act = SKAction.repeatForever(SKAction.sequence([
            SKAction.scale(to: 1.1, duration: 0.5),
            SKAction.scale(to: 1, duration: 0.2),
            SKAction.wait(forDuration: 0.5)
            ]))
        switch tutorialStep {

        case 11:
            text1A = "Great!"
            text2A = "Cucumber got the Fries"
            text1B = "To finish a level,"
            text2B = "detroy all burgers"
            SJLevelCreator.targetsRange = "0000000011110000"
            createFinalBurger(str: 1)
            createFinalBurger(str: 3)
            createFinalBurger(str: 6)
            createFinalBurger(str: 3)
            createFinalBurger(str: 1)
            levelScene._shooter.run(SKAction.fadeOut(withDuration: 2))

            self.run(SKAction.wait(forDuration: 3), completion: {
                for child in levelScene.container.children
                {
                    if let burger = child as? Burger
                    {
                        burger.run(act)
                    }
                }
            })



        case 12:
            timeBetweenSteps = 0.1
            text1A = ""
            text2A = ""
            text1B = "Number of Moves"
            text2B = "\u{2193}"
            self.run(SKAction.wait(forDuration: 3), completion: {
                for child in levelScene.container.children
                {
                    if let burger = child as? Burger
                    {
                        burger.run(SKAction.fadeOut(withDuration: 0.25))
                    }
                }
            })
            if let hitsSprite = levelScene.container.childNode(withName: "hits")
            {
                hitsSprite.zPosition += 100
                hitsSprite.run(act)
            }

            stepText1.run(SKAction.moveTo(y: stepText1.position.y - self.frame.size.height * 0.75, duration: 1))
            stepText2.run(SKAction.moveTo(y: stepText2.position.y - self.frame.size.height * 0.75, duration: 1))


        case 13:
            Tutorial.pauseShooting = false
            NPDirector.displayCurrentEpisodeMenu()
        default:
            text1B = ""
            text2B = ""
        }
        stepText1.text = text1A
        stepText2.text = text2A
        Tutorial.pauseShooting = true;
        stepText1.run(SKAction.sequence([
            SKAction.wait(forDuration: timeBetweenSteps),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.run {
                self.stepText1.text = text1B

            },
            SKAction.fadeIn(withDuration: 0.5)
            ]))

        stepText2.run(SKAction.sequence([
            SKAction.wait(forDuration: timeBetweenSteps),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.run {
                self.stepText2.text = text2B
            },
            SKAction.fadeIn(withDuration: 0.5)
            ]))

    }

    func createStepText()
    {
        var text1A = ""
        var text2A = ""
        var text1B = ""
        var text2B = ""
        var textTarget = ""
        var textTouch = ""
        var textShooter = ""




        switch tutorialStep {
        case 1:
            text1A = "Welcome to this"
            text2A = "quick Tutorial!"
            text1B = "Touch the screen to move your Plate"
            text2B = "towards enemy Burger and destroy it."
            textTarget = "Burger \u{2192}"
            textShooter = "\u{2190} Your Plate"
            textTouch = "Touch here \u{2192}"

        case 2:
            text1A = "Great! To pass a level, destroy"
            text2A = "all Burgers with minimum moves."
            text1B = "You need more hits"
            text2B = "to destroy this Sandwitch"
            textTarget = ""

        case 3:
            text1A = "Great!"
            text2A = "You finished it with 5 hits"
            text1B = "Try catching this Apple"
            text2B = "to be more powerful!"
            textTarget = ""

        case 4:
            text1A = "Good!"
            text2A = "You got the Apple"
            text1B = "Try hitting this Burger"
            text2B = "Sandwitch with the apple in your plate."
            textTarget = ""

        case 5:
            text1A = "You needed less hits"
            text2A = "because of the Apple"
            text1B = "Soda glasses block your way."
            text2B = "Your enemy Burger is safe!"

        case 6:
            text1A = "You need to destroy some"
            text2A = "Soda glasses"
            text1B = "Fresh Water in your plate allows you"
            text2B = "to break Soda and get the Burger"

        case 7:
            text1A = "Good Job!"
            text2A = "You got the Burger"
            text1B = "Ketchup protects Burger"
            text2B = "and they are Sticky!!"

        case 8:
            text1A = "Ketchup, like Soda,"
            text2A = "is not helpful!"
            text1B = "Fresh Tomatoe"
            text2B = "destroys Ketchup"

        case 9:
            text1A = "Good Job!"
            text2A = "You got the Burger"
            text1B = "Fries protect Burger"
            text2B = "and they duplicate!!"

        case 10:
            text1A = "Fries are not good"
            text2A = "for You"
            text1B = "Put Cucumber in your plate"
            text2B = "and destroy some of them"


        default:
            text1B = ""
            text2B = ""
            textTarget = ""
        }
        stepText1.text = text1A
        stepText2.text = text2A
        Tutorial.pauseShooting = true;
        stepText1.run(SKAction.sequence([
            SKAction.wait(forDuration: timeBetweenSteps),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.run {
                self.stepText1.text = text1B
                Tutorial.pauseShooting = false
            },
            SKAction.fadeIn(withDuration: 0.5)
            ]))

        stepText2.run(SKAction.sequence([
            SKAction.wait(forDuration: timeBetweenSteps),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.run {
                self.stepText2.text = text2B
            },
            SKAction.fadeIn(withDuration: 0.5)
            ]))


        stepTextTarget.text = textTarget
        stepTextTouch.text = textTouch
        stepTextShooter.text = textShooter
    }


    func shooterHitObstacle(obstacle: Obstacle)
    {
        numberOfObstaclesCollisions += 1
        var requiredNumber = 0
        var mayMoveToNextStep = false
        switch tutorialStep {
        case 5: // soda
            requiredNumber = 10
            mayMoveToNextStep = true
        case 7: //ketchup
            requiredNumber = 10
            mayMoveToNextStep = true
        case 9:
            requiredNumber = 10
            mayMoveToNextStep = true
        default:
            break
        }

        if numberOfObstaclesCollisions >= requiredNumber && mayMoveToNextStep
        {
            nextStep()
        }

    }

    func shooterHitAddon(addon: Addon)
    {
        numberOfAddonsCollisions += 1
        var shouldMoveToNextStep = false
        switch tutorialStep {
        case 3: //apple
            shouldMoveToNextStep = true
        default:
            break
        }

        if shouldMoveToNextStep
        {
            nextStep()
        }

    }

    func showOrHideText(hide: Bool)
    {
        stepText1.isHidden = hide
        stepText2.isHidden = hide
        stepTextTarget.isHidden = true // will always hide it once and never show it again
        stepTextTouch.isHidden = true
        stepTextShooter.isHidden = true // will always hide it once and never show it again
        touchSprite.isHidden = true
    }
    func shooterMoving()
    {
        showOrHideText(hide: true)
    }
    func shooterStopped()
    {


        print("shooter stopped...")

        showOrHideText(hide: false)


    }
    func removeAllObstacles()
    {
        guard let scene = SJLevelScene.currentLevelScene else
        {
            return;
        }

        for obst in scene.container.children
        {
            if let obstacle = obst as? Obstacle
            {
                obstacle.explodeWithOwnPicture(emitterFileName: "burger")
                obstacle.removeFromParent()
            }
        }
    }

    func nextStep()
    {
        Tutorial.pauseShooting = true
        guard let scene = SJLevelScene.currentLevelScene else
        {
            return;
        }
        numberOfAddonsCollisions = 0
        numberOfObstaclesCollisions = 0
        scene._shooter.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        scene._shooter.removeAllAddons()
        scene._shooter.run(
            SKAction.sequence([
                SKAction.wait(forDuration: timeBetweenSteps/4),
       //         SKAction.fadeAlpha(to: 0.5, duration: timeBetweenSteps/4),
       //         SKAction.fadeOut(withDuration: timeBetweenSteps/2),
                SKAction.group([
                    SKAction.move(to: scene._shooter.initialPosition, duration: timeBetweenSteps/4)
        //            SKAction.fadeIn(withDuration: timeBetweenSteps/2)
                    ])
                ])
        )
        tutorialStep += 1

        switch tutorialStep
        {
        case 2:
            createBurger(str: 5)
        case 3:
            createAddon(str: "apple")
        case 4:
            createBurger(str: 5)
        case 5:
            createBurger(str: 5)
            createObstacle(str: "soda")
        case 6:
            createAddon(str: "water")
        case 7:
            createBurger(str: 5)
            createObstacle(str: "ketchup")
        case 8:
            createAddon(str: "tomatoe")
        case 9:
            createBurger(str: 4)
            createObstacle(str: "fries")
        case 10:
            createAddon(str: "cucumber")

        default:
           finalizeTutorial()
        }
        createAndAdjustText()
        self.showOrHideText(hide: false)
    }

    var finalSteps = 1;
    func touchReceived()
    {
        print("touch received........")
        if tutorialStep < 11
        {
            return;
        }
        tutorialStep += 1

        createAndAdjustText()
        self.showOrHideText(hide: false)
    }
    func finalizeTutorial()
    {
        guard let levelScene = SJLevelScene.currentLevelScene else
        {
            return
        }

        removeAllObstacles()
        Tutorial.pauseShooting = true


        levelScene._shooter.physicsBody?.isDynamic = false

    }

    func createObstacle(str: String)
    {
        removeAllObstacles()

        guard let levelScene = SJLevelScene.currentLevelScene else
        {
            return
        }


        guard let firstObstacle = Obstacle.make(objectSpec: str) as? Obstacle else
        {
            return
        }
        var numberOfObstacles = Int(levelScene.frame.width / firstObstacle.size.width)
        let spaceBetweenObstacles = (levelScene.frame.width - (CGFloat(numberOfObstacles) * firstObstacle.size.width)) / CGFloat(numberOfObstacles - 1)


        levelScene.run(SKAction.wait(forDuration: timeBetweenSteps), completion: {
            levelScene.container.addChild(firstObstacle)
            firstObstacle.position = ScreenRange.generateRandomLocation(object: firstObstacle)
            firstObstacle.position.x = firstObstacle.size.width/2
            self.targetNode = firstObstacle
            firstObstacle.zPosition = 200
        })

        numberOfObstacles -= 1
        for i in 1...numberOfObstacles
        {

            guard let obstacle = Obstacle.make(objectSpec: str) as? Obstacle else
            {
                break
            }

            levelScene.run(SKAction.wait(forDuration: timeBetweenSteps), completion: {
                levelScene.container.addChild(obstacle)
                obstacle.position = firstObstacle.position
                obstacle.position.x += ((obstacle.size.width + spaceBetweenObstacles) * CGFloat(i))
                self.targetNode = obstacle
                obstacle.zPosition = 200
            })
        }



        levelScene.run(SKAction.wait(forDuration: timeBetweenSteps), completion: {
            self.showShooterAndTargets()
            Tutorial.pauseShooting = false
        })
    }


    func createAddon(str: String)
    {
        guard let levelScene = SJLevelScene.currentLevelScene else
        {
            return
        }
        guard let apple = Addon.make(objectSpec: str) as? Addon else
        {
            return
        }


        levelScene.run(SKAction.wait(forDuration: timeBetweenSteps), completion: {
            levelScene.container.addChild(apple)
            apple.position = ScreenRange.generateRandomLocation(object: apple)
            self.targetNode = apple
            apple.zPosition = 200
            self.destroyGift(addon: apple)
            self.showShooterAndTargets()

            print("will start second step...")
            Tutorial.pauseShooting = false
        })
    }

    func createFinalBurger(str: Int)
    {
        guard let levelScene = SJLevelScene.currentLevelScene else
        {
            return
        }

        guard let newBurger = Burger.make(objectSpec: "\(str)") as? Burger else
        {
            return
        }

        newBurger.updateCollisionMask()


        levelScene.run(SKAction.wait(forDuration: timeBetweenSteps), completion: {
            levelScene.container.addChild(newBurger)
            newBurger.position = ScreenRange.generateRandomLocation(object: newBurger)
            self.showShooterAndTargets()

        })
    }


    func createBurger(str: Int)
    {
        guard let levelScene = SJLevelScene.currentLevelScene else
        {
            return
        }

        guard let newBurger = Burger.make(objectSpec: "\(str)") as? Burger else
        {
            return
        }

        newBurger.updateCollisionMask()


        levelScene.run(SKAction.wait(forDuration: timeBetweenSteps), completion: {
            levelScene.container.addChild(newBurger)
            newBurger.position = ScreenRange.generateRandomLocation(object: newBurger)
            self.targetNode = newBurger
            self.showShooterAndTargets()
            print("will start second step...")
            Tutorial.pauseShooting = false
        })
    }
    func destroyGift(addon: Addon)
    {
        guard let levelScene = SJLevelScene.currentLevelScene else
        {
            return
        }
        let giftAct = SKAction.sequence([
            SKAction.shake(addon.giftMask.position, duration: 0.4),
            SKAction.run {
                addon.giftMask.move(toParent: levelScene.container)
                addon.giftMask.explodeWithOwnPicture(emitterFileName: "burger")
                addon.giftMask.removeFromParent()
                SJDirector.shared.sound.runSoundAction(owner: addon, soundAction: SKAction.playSoundFileNamed("gift", waitForCompletion: false))
            }
            ])

        addon.run(SKAction.sequence([
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
    func hideAllObjects()
    {
        guard let levelScene = SJLevelScene.currentLevelScene else
        {
            return
        }
        levelScene._shooter.zPosition = 100
        for target in levelScene.allTargets()
        {
            target.zPosition = 90
        }
    }
    func adjustTouchLocation()
    {
        guard let levelScene = SJLevelScene.currentLevelScene else
        {
            return
        }

        let touchSpriteX = levelScene._shooter.position.x + (targetNodePosition.x - levelScene._shooter.position.x) / 2
        let touchSpriteY = levelScene._shooter.position.y + (targetNodePosition.y - levelScene._shooter.position.y) / 2
        touchSprite.position = CGPoint(x: touchSpriteX, y: touchSpriteY)
    }
    func showShooterAndTargets()
    {
        guard let levelScene = SJLevelScene.currentLevelScene else
        {
            return
        }
        levelScene._shooter.zPosition = 1000
        for target in levelScene.allTargets()
        {
            target.zPosition += 100
            for part in target._parts
            {
                part.zPosition += 100
            }
            if tutorialStep == 1
            {
                targetNode = target
                targetNodePosition = target.initialPosition //at this moment the burger did not yet move to the screen
            }
        }




    }
    

}
