//
//  Boxes.swift
//  BurgerInvasion
//
//  Created by Tony Ayoub on 5/15/17.
//  Copyright © 2017 amahy. All rights reserved.
//

import SpriteKit

class Boxes: NSObject
{
    
    
    static let boxesFontName = "GillSans-Bold"
    static var currentGlass:SKSpriteNode?
    static func createFallingBoxAction() -> SKAction
    {
        let res = SKAction.sequence([
            SKAction.moveTo(y: 0, duration: 0.3),
            SKAction.moveTo(y: NPDirector.shared.viewSize.height*0.02, duration: 0.05),
            SKAction.moveTo(y: 0, duration: 0.1)
            ])
        return res
    }
    static func createRisingBoxAction() -> SKAction
    {
        let res = SKAction.sequence([
            SKAction.moveTo(y: -NPDirector.shared.viewSize.height*0.02, duration: 0.05),
            SKAction.moveTo(y: NPDirector.shared.viewSize.height, duration: 0.3)
            ])
        return res
    }
    

    static func createGlassAndShadow(parent: SKNode)->SKSpriteNodeWithTouch
    {
        NPDirector.shared.gamePaused = true
        let glassNode = SKSpriteNodeWithTouch(color: SKColor.clear, size: parent.frame.size)
        //glassNode.alpha = 0.
        glassNode.isUserInteractionEnabled = true
        currentGlass = glassNode
        
        glassNode.position = CGPoint(x: parent.frame.midX, y: parent.frame.midY)
        
        glassNode.zPosition = 999
        
        parent.addChild(glassNode)
        
        let shadowNode = SKSpriteNode(color: SKColor.blue, size: glassNode.size)
        shadowNode.alpha = 0.1
        shadowNode.zPosition = 3
        shadowNode.name = "shadow"
        glassNode.addChild(shadowNode)
        return glassNode
    }
    
    static func removeGlass()
    {
       // NPDirector.shared.gamePaused = false
        if let glass = currentGlass
        {
            glass.run(SKAction.fadeOut(withDuration: 0.2), completion: {glass.removeFromParent()})
        }
    }
    static func getSpritesArrayFromStartImagesNames(parentNode: SKSpriteNode)
    {
        let imagesString = SJLevelCreator.images.components(separatedBy: ",")

        var i = 0

        let lowerY:CGFloat = -parentNode.size.height * 0.075
        let middleY = lowerY + parentNode.size.height * 0.175
        let topY = lowerY + parentNode.size.height * 0.35

        var maxSpriteWidth:CGFloat = 0
        for imageName in imagesString
        {
            if imageName == "empty"
            {
                continue
            }
            let sprite =  SKSpriteNode(imageNamed: imageName)
            if sprite.size.width > maxSpriteWidth
            {
                maxSpriteWidth = sprite.size.width
            }
        }
        for imageName in imagesString
        {
            i += 1
            if imageName == "empty"
            {
                continue
            }
            let sprite =  SKSpriteNode(imageNamed: imageName)
            parentNode.addChild(sprite)
            sprite.position.y = lowerY
            sprite.zPosition = 99
            sprite.name = "startImage"
            // print("\(i): \(imageName)")


            switch i
            {
                //lower row
            case 1:
                sprite.position.x -= maxSpriteWidth * 2
            case 3:
                sprite.position.x += maxSpriteWidth * 2

                //middle row
            case 4:
                sprite.position.x -= maxSpriteWidth * 2
                sprite.position.y = middleY

            case 5:
                sprite.position.y = middleY
                sprite.run(SKAction.repeatForever(SKAction.sequence([
                    SKAction.wait(forDuration: 0.15), //the time before all sprites appear
                    SKAction.scale(to: 1.1, duration: 0.5),
                    SKAction.scale(to: 1.0, duration: 0.5)
                    ])))
            case 6:
                sprite.position.x += maxSpriteWidth * 2
                sprite.position.y = middleY

                //top row
            case 7:
                sprite.position.x -= maxSpriteWidth * 2
                sprite.position.y = topY
            case 8:
                sprite.position.y = topY
            case 9:
                sprite.position.x += maxSpriteWidth * 2
                sprite.position.y = topY
            default:
                break
            }



//            sprite.setScale(0.2)
//            sprite.run(SKAction.sequence([
//                SKAction.scale(to: 1.2, duration: 0.1),
//                SKAction.scale(to: 1, duration: 0.05),
//                SKAction.wait(forDuration: 4),
//                SKAction.fadeOut(withDuration: 0.5)
//                ]))
        }

    }
    static func showStartMessage(episdoeID: Int, levelID: Int, parentScene: SKNode)
    {
        
        let glassNode = createGlassAndShadow(parent: parentScene)
        
        let box = SKSpriteNode(imageNamed: "message")
        box.zPosition = 4


        glassNode.addChild(box)

        
        //
        func close()
        {
            box.run(createRisingBoxAction(), completion: {
                removeGlass();
             //   NPDirector.shared.gamePaused = false;
                SJLevelScene.status = LevelStatus.readyToPlaceObjects

            })
        

        }
        
        func start()
        {
            removeGlass();
            SJDirector.shared.sound.playLevelSound(sound: .levelStart)
            SJLevelScene.status = LevelStatus.readyToPlaceObjects
        }
        
       
        glassNode.onTouched = start

        
        
        
        box.position.y = parentScene.frame.height/2 + box.size.height

        let parts = SJLevelCreator.levelMessage.components(separatedBy: ";")
        let part1 = parts[0]

        let messageLabel1 = SKLabelNode(fontNamed: MainMenu.fontName)
        messageLabel1.text = part1
        messageLabel1.fontSize = box.size.height * 0.045
        messageLabel1.fontColor = SKColor(red: 0.4, green: 0.2, blue: 0, alpha: 1)
        messageLabel1.zPosition = 4
        messageLabel1.verticalAlignmentMode = .center
        messageLabel1.horizontalAlignmentMode = .center

        box.addChild(messageLabel1)
        messageLabel1.position.y -= box.size.height*0.275

        if parts.count > 1
        {


            let part2 = parts[1]
            if !part2.isEmpty
            {
                let messageLabel2 = SKLabelNode(fontNamed: MainMenu.fontName)
                messageLabel2.text = part2
                messageLabel2.fontSize = messageLabel1.fontSize
                messageLabel2.fontColor = SKColor(red: 0.4, green: 0.2, blue: 0, alpha: 1)
                messageLabel2.zPosition = 4
                messageLabel2.verticalAlignmentMode = .center
                messageLabel2.horizontalAlignmentMode = .center
                messageLabel2.position.y -= box.size.height*0.375


                box.addChild(messageLabel2)
            }
        }



        



        
        //level title
        let levelID = NPDirector.shared.currentLevelID
        let episodeID = NPDirector.shared.currentEpisodeID
        
        let levelTitleSprite = SKSpriteNode(imageNamed: "woodenLevelTitle")
    //    levelTitleSprite.position = CGPoint(x: box.frame.midX, y: box.frame.maxY)
        levelTitleSprite.position.y += (box.size.height/2 - levelTitleSprite.size.height/3)
        levelTitleSprite.zPosition = 5
        box.addChild(levelTitleSprite)
        
        let levelTitleLabel = SKLabelNode(fontNamed: boxesFontName)
        levelTitleLabel.text = "Level \(episodeID)-\(levelID)"
        levelTitleLabel.fontSize = levelTitleSprite.size.height * 0.35
        levelTitleLabel.verticalAlignmentMode = .center
        levelTitleLabel.zPosition = 6
        levelTitleSprite.addChild(levelTitleLabel)
        
        
        
        let messageY:CGFloat = 0
        getSpritesArrayFromStartImagesNames(parentNode: box)

        let action = SKAction.sequence([
            SKAction.moveTo(y: messageY, duration: 0.3),
            SKAction.moveTo(y: messageY + NPDirector.shared.viewSize.height*0.02, duration: 0.05),
            SKAction.moveTo(y: messageY, duration: 0.1),
            SKAction.wait(forDuration: 5),
            SKAction.run {
                glassNode.isUserInteractionEnabled = false
            },
            SKAction.moveTo(y: messageY + NPDirector.shared.viewSize.height*0.02, duration: 0.05),
            SKAction.moveTo(y: -(NPDirector.shared.viewSize.height/2 + box.size.height/2), duration: 0.3),
            SKAction.run(start)
            ])
        
        
        box.run(action)
        return
        //if we are adding credit
    }

    static func addFixedObjectsToLevelLost(winBox: SKSpriteNode, glass: SKSpriteNode)
    {
        
        
        
        let exitButton = PushButton(fixedImageName: "fixed", normalImageName: "normal", pressedImageName: "pressed", symbolImageName: "exit-symbol", onPushed: NPDirector.displayCurrentEpisodeMenu)
        exitButton.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.minY + exitButton.size.height/2)
        exitButton.position.x += winBox.size.width / 5

        exitButton.zPosition = 5
        exitButton.isUserInteractionEnabled = true
        winBox.addChild(exitButton)
        
        
        let repeatButton = PushButton(fixedImageName: "fixed", normalImageName: "normal", pressedImageName: "pressed", symbolImageName: "repeat-symbol", onPushed: repeatLevel)
        repeatButton.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.minY + repeatButton.size.height/2)
        repeatButton.position.x -= winBox.size.width / 5
        repeatButton.zPosition = 5
        repeatButton.isUserInteractionEnabled = true
        winBox.addChild(repeatButton)
        
        
        
        
    }
    static func showlevelLost(ownerFrame: CGRect, parentSKNode: SKNode)
    {
        
        
        let glassNode = SKSpriteNode(color: SKColor.clear, size: ownerFrame.size)
        
        
        glassNode.position = CGPoint(x: ownerFrame.midX, y: ownerFrame.midY)
        //        owner.childNode(withName: MainMenu.menuHolderName)?.addChild(glassNode)
        glassNode.zPosition = 999
        glassNode.name = "glass"
        parentSKNode.addChild(glassNode)
        
        let shadowNode = SKSpriteNode(color: SKColor.blue, size: glassNode.size)
        shadowNode.alpha = 0.3
        shadowNode.zPosition = 3
        glassNode.addChild(shadowNode)

        var boxSpriteName = "lost-box"
        if(SJDirector.shared.isTimeLevel)
        {
            boxSpriteName = "lost-box-time"
        }
        
        let box = SKSpriteNode(imageNamed: boxSpriteName)
        box.zPosition = 4
        glassNode.addChild(box)
        addFixedObjectsToLevelLost(winBox: box, glass: glassNode)
        box.position.y = ownerFrame.height/2 + box.size.height/2
        box.run(createFallingBoxAction())
        
        return
        //if we are adding credit
        
    }
    static func addFixedObjectsToWinBox(winBox: SKSpriteNode)
    {
        let levelID = NPDirector.shared.currentLevelID
        let episodeID = NPDirector.shared.currentEpisodeID
        
        
        let levelTitleSprite = SKSpriteNode(imageNamed: "level-title")
        levelTitleSprite.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.midY)
        levelTitleSprite.position.y += winBox.size.height / 3.5
        levelTitleSprite.zPosition = 5
        winBox.addChild(levelTitleSprite)
        
        let levelTitleLabel = SKLabelNode(fontNamed: boxesFontName)
        levelTitleLabel.text = "Level \(episodeID)-\(levelID)"
        levelTitleLabel.fontSize = levelTitleSprite.size.height * 0.35
        levelTitleLabel.verticalAlignmentMode = .center
        levelTitleLabel.zPosition = 6
        levelTitleSprite.addChild(levelTitleLabel)
        
        
        let exitButton = PushButton(fixedImageName: "fixed", normalImageName: "normal", pressedImageName: "pressed", symbolImageName: "exit-symbol", onPushed: NPDirector.displayCurrentEpisodeMenu)
        exitButton.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.minY + exitButton.size.height/2)
        winBox.addChild(exitButton)
        exitButton.zPosition = 77
        exitButton.isUserInteractionEnabled = true

        
        let repeatButton = PushButton(fixedImageName: "fixed", normalImageName: "normal", pressedImageName: "pressed", symbolImageName: "repeat-symbol", onPushed: repeatLevel)
        repeatButton.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.minY + repeatButton.size.height/2)
        repeatButton.position.x -= winBox.size.width / 4
        winBox.addChild(repeatButton)
        repeatButton.zPosition = 77
        repeatButton.isUserInteractionEnabled = true

        let nextButton = PushButton(fixedImageName: "fixed", normalImageName: "normal", pressedImageName: "pressed", symbolImageName: "next-symbol", onPushed: nextLevel)
        nextButton.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.minY + repeatButton.size.height/2)
        nextButton.position.x += winBox.size.width / 4
        winBox.addChild(nextButton)
        nextButton.zPosition = 77
        nextButton.isUserInteractionEnabled = true

        if episodeID == GameData.numberOfEpisodes && levelID == 9
        {
            nextButton.callBack = NPDirector.displayCurrentEpisodeMenu
        }

    }
    static func showLevelWon(ownerFrame: CGRect, parentSKNode: SKNode)
    {
 //       Chartboost.cacheInterstitial(CBLocationLevelComplete)
        if(Chartboost.hasInterstitial(CBLocationLevelComplete))
        {
            // print("ad cached successfully...")
        }
        else
        {
            Chartboost.cacheInterstitial(CBLocationLevelComplete)

        }
        let levelID = NPDirector.shared.currentLevelID
        let episodeID = NPDirector.shared.currentEpisodeID
        
        //this to handle the situation when the last winning shoot is tapped, then a pause, or add gold button is pressed, which will result in the winning box to appear simultaneously with the pause or add gold box.
        removeGlass()
        
        
        let glassNode = SKSpriteNodeWithTouch(imageNamed: "bg")
        glassNode.isUserInteractionEnabled = true
        glassNode.onTouched = nextLevel
        glassNode.name = "wonGlass"
        currentGlass = glassNode
        //glassNode.anchorPoint = CGPoint(x: 0, y: 0)
        glassNode.position = CGPoint(x: ownerFrame.midX, y: ownerFrame.midY)
        //        owner.childNode(withName: MainMenu.menuHolderName)?.addChild(glassNode)
        glassNode.zPosition = 88
        
        parentSKNode.addChild(glassNode)
        
        
        let box = SKSpriteNode(imageNamed: "won-box")
        box.zPosition = 99
        glassNode.addChild(box)
        
        
        
        
        
        addFixedObjectsToWinBox(winBox: box)
        let oldNumberOfStars = ProgressManager.getLevelAch(episodeID: episodeID, levelID: levelID)
        
        let winPercentage  = Double(SJDirector.shared._hitsRemaining) / Double(SJDirector.shared.originalNumberOfHits)
        
        var numberOfStars = 1
        if winPercentage >= 0.1
        {
            numberOfStars = 2
        }
        if winPercentage >= 0.2
        {
            numberOfStars = 3
        }


        if SJDirector.shared.originalNumberOfHits <= 3
        {
            numberOfStars = 3 // if <= 3 any win is 3 stars
        }
        else if SJDirector.shared.originalNumberOfHits <= 6
        {
            if numberOfStars < 2
            {
                numberOfStars = 2
            }
        }
        let oldCredit = ProgressManager.getCredit()
        let newCredit = oldCredit + (numberOfStars - oldNumberOfStars) * ((episodeID) * GameData.numberOfLevelsPerEpisode + levelID + 1) //1,2,3 for episode 1; 11,12,12 for episode 2 ...etc

        
        if numberOfStars > oldNumberOfStars
        {
            ProgressManager.saveLevelAch(episodeID: NPDirector.shared.currentEpisodeID, levelID: NPDirector.shared.currentLevelID, value: numberOfStars)
            ProgressManager.saveCredit(value: newCredit)
        }
        
        
        let scoreSprite = SKSpriteNode(imageNamed: "score-label")
        scoreSprite.zPosition = 5
        scoreSprite.position.y -= (scoreSprite.size.height * 2)
      //  scoreSprite.position.x += scoreSprite.size.width * 0.1
        box.addChild(scoreSprite)
        
        let scoreLabel = SKLabelNode(fontNamed: boxesFontName)
        scoreLabel.text = "\(oldCredit)"
        scoreLabel.fontSize = scoreSprite.size.height * 0.5
        scoreLabel.verticalAlignmentMode = .center
        scoreLabel.zPosition = 6
        scoreSprite.addChild(scoreLabel)
        
        let starsBand = SKSpriteNode(imageNamed: "band-\(oldNumberOfStars)")
        starsBand.zPosition = 5
        box.addChild(starsBand)
        starsBand.position.y -= starsBand.size.height * 0.05
        
        box.position.y = ownerFrame.height/2 + box.size.height/2
        box.run(createFallingBoxAction())
        if numberOfStars <= oldNumberOfStars // no more gold for this level
        {
            return
            
        }
        else // we are adding credit here
        {
            
            var waitingTimeBeforeGoldAction: Double = 0
            
            for i in (oldNumberOfStars+1)...numberOfStars
            {
                let star = SKSpriteNode(imageNamed: "star-\(i)")
                
                var emitterLocation = CGPoint.zero
                var starLocation = CGPoint.zero
                starLocation.y += star.size.height/3
                if i == 1
                {
                    emitterLocation.x -= starsBand.size.width / 3 //move left
                    starLocation.x = emitterLocation.x
                    
                    starLocation.y -= star.size.height/4
                    
                }
                else if i == 2 //middle star
                {
                    emitterLocation.y += starsBand.size.height / 8
                    
                }
                else if i == 3
                {
                    emitterLocation.x += starsBand.size.width / 3 //move right
                    starLocation.x = emitterLocation.x
                    
                    starLocation.y -= star.size.height/4
                }
                box.addChild(star)
                star.position = CGPoint(x: starLocation.x, y: glassNode.frame.size.height/2 + star.size.height)
                
                star.zPosition = 9
                let texture = SKTexture(imageNamed: "band-\(i)")
                
                let starFallingTime: Double = 0.25
                let scaleAnimationTime: Double = 0.2
                let waitingTime = 0.4 + (starFallingTime + scaleAnimationTime) * (Double(i)-1)
                
                
                
                star.run(SKAction.sequence([
                    SKAction.wait(forDuration: waitingTime),
                    SKAction.moveTo(y: starLocation.y, duration: starFallingTime),
                    SKAction.run({
                        NPDirector.showEmitter("coins", position: emitterLocation, parentNode: starsBand, lifetime: 0)
                    }),
                    SKAction.removeFromParent()
                    ]), completion: {
                        starsBand.run(SKAction.sequence([
                            SKAction.setTexture(texture),
                            SKAction.scale(by: 1.1, duration: scaleAnimationTime/2),
                            SKAction.scale(to: 1, duration: scaleAnimationTime/2)
                            ]))
                        
                })
                
                waitingTimeBeforeGoldAction = waitingTime + starFallingTime + scaleAnimationTime //after exiting this loop, this variable will hold the  time consumed in the last star animiation. This will be the waiting time before gold animation
                
            } //for loop: stars 1, 2 and 3
            
            
            let diffCredit = newCredit - oldCredit
            if diffCredit <= 0
            {
                return
            }
            var creditStep = 5
            var numberOfSteps = diffCredit / creditStep
            if numberOfSteps > 20
            {
                numberOfSteps = 20
            }
            else if numberOfSteps < diffCredit
            {
                numberOfSteps = diffCredit
                creditStep = 1
            }
            
            
            var currentAppearingCredit = oldCredit
            scoreLabel.text = "\(currentAppearingCredit)"
            
            for i in 1...numberOfSteps
            {
                let creditLabelAction = SKAction.sequence([
                    SKAction.wait(forDuration: 0.04 * Double(i)),
                    SKAction.run({
                        scoreLabel.text = "\(currentAppearingCredit)"
                        currentAppearingCredit = currentAppearingCredit + creditStep
                        if currentAppearingCredit > newCredit
                        {
                            currentAppearingCredit = 0
                        }
                        if i == numberOfSteps //last iteration
                        {
                            scoreLabel.text = "\(newCredit)"
                        }
                        if Int(i) % 5 == 0 //every 3 steps
                        {
                            NPDirector.showEmitter("coin_emitter", position: CGPoint.zero, parentNode: scoreSprite, lifetime: 0)

                        }
                    })
                    ])
                
                
                scoreLabel.run(SKAction.sequence([SKAction.wait(forDuration: waitingTimeBeforeGoldAction), creditLabelAction]))
                
                
            }
            
            
            
        } //if we are adding credit
        
        
        

    }

    static func addFixedObjectsToAddonShoppingBox(winBox: SKSpriteNode, glass: SKSpriteNode)
    {
        let goldCredit = SJDirector.shared.goldCredit
        


        let youHaveSprite = SKSpriteNode(imageNamed: "youHave")
        youHaveSprite.position = CGPoint(x: winBox.frame.midX,
                                            y: winBox.frame.midY)
        youHaveSprite.position.y += winBox.size.height / 4
        youHaveSprite.zPosition = 10
        winBox.addChild(youHaveSprite)

        let youHaveLabel = SKLabelNode(fontNamed: boxesFontName)
        youHaveLabel.text = "You have: \(goldCredit)"
        youHaveLabel.fontSize = youHaveSprite.size.height * 0.3
        youHaveLabel.verticalAlignmentMode = .center
        youHaveLabel.zPosition = 10
        youHaveSprite.addChild(youHaveLabel)

        
        var addonID = 1
        var currentPrice = 200
        var currentAddonType = AddonType.carrot
        let addonShoppingHolder = SKSpriteNode(imageNamed: "carrot-shopping")
        addonShoppingHolder.zPosition = 5
        winBox.addChild(addonShoppingHolder)
        func displayCurrentAddon()
        {
            if let displayedAddon = Addon.Shopping[addonID]
            {
                let img = "\(displayedAddon.type.rawValue)-shopping"
                currentPrice = displayedAddon.price
                currentAddonType = displayedAddon.type
                addonShoppingHolder.run(SKAction.setTexture(SKTexture(imageNamed: img)))
            }

        }
        displayCurrentAddon()


        func displayNextAddon()
        {
            if addonID == 9
            {
                addonID = 1
            }
            else
            {
                addonID += 1
            }
            displayCurrentAddon()

        }

        func displayPreviousAddon()
        {
            if addonID == 1
            {
                addonID = 9
            }
            else
            {
                addonID -= 1
            }
            displayCurrentAddon()
        }
        //testItemSprite.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.midY)


        

        func getAddon()
        {
            let currentCredit = SJDirector.shared.goldCredit
            if currentCredit < currentPrice
            {
                youHaveSprite.run(SKAction.sequence([
                    SKAction.scale(to: 1.2, duration: 0.1),
                    SKAction.scale(to: 1, duration: 0.2)
                    ]))
             //   SJDirector.shared.goldCredit += 9999
            }
            else
            {
                SJLevelScene.currentLevelScene?._shooter.attachPurchasedAddon(type: currentAddonType)
                winBox.run(createRisingBoxAction(), completion: {glass.removeFromParent();NPDirector.shared.gamePaused = false})
                SJDirector.shared.goldCredit -= currentPrice
            }
        }
        func resumeGame()
        {
            winBox.run(createRisingBoxAction(), completion: {glass.removeFromParent();NPDirector.shared.gamePaused = false})
        }

        let okButton = PushButton(fixedImageName: "fixed", normalImageName: "normal", pressedImageName: "pressed", symbolImageName: "ok-symbol", onPushed: getAddon)
        okButton.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.minY + okButton.size.height/3.5)
     //   okButton.position.x -= winBox.size.width / 4.5
        okButton.zPosition = 7
        okButton.isUserInteractionEnabled = true
        winBox.addChild(okButton)

        let nextButton = PushButton(fixedImageName: "fixed",
                                    normalImageName: "normal",
                                    pressedImageName: "pressed",
                                    symbolImageName: "next-addon-symbol",
                                    onPushed: displayNextAddon)
        nextButton.position = okButton.position
        nextButton.position.x += nextButton.size.width

        winBox.addChild(nextButton)
        nextButton.zPosition = 7

        let previousButton = PushButton(fixedImageName: "fixed",
                                    normalImageName: "normal",
                                    pressedImageName: "pressed",
                                    symbolImageName: "previous-addon-symbol",
                                    onPushed: displayPreviousAddon)
        previousButton.position = okButton.position
        previousButton.position.x -= nextButton.size.width

        winBox.addChild(previousButton)
        previousButton.zPosition = 7
        

        let x = EffectButton(img: "close-window")
        x.onTouched = resumeGame
        x.zPosition = 5
        winBox.addChild(x)
        x.position.y += winBox.size.height/2.6
        x.position.x += winBox.size.width/2.6
    //    winBox.addChild(resumeButton)


    }
    static func showAddonShopping(ownerFrame: CGRect, parentSKNode: SKNode)
    {

        NPDirector.shared.gamePaused = true

        let glassNode = SKSpriteNode(color: SKColor.clear, size: ownerFrame.size)

        glassNode.position = CGPoint(x: ownerFrame.midX, y: ownerFrame.midY)
        //        owner.childNode(withName: MainMenu.menuHolderName)?.addChild(glassNode)
        glassNode.zPosition = 999
        glassNode.name = "glass"
        parentSKNode.addChild(glassNode)

        let shadowNode = SKSpriteNode(color: SKColor.blue, size: glassNode.size)
        shadowNode.alpha = 0.3
        shadowNode.zPosition = 3
        glassNode.addChild(shadowNode)


        let box = SKSpriteNode(imageNamed: "addon-shopping")
        box.zPosition = 4
        glassNode.addChild(box)

        addFixedObjectsToAddonShoppingBox(winBox: box, glass: glassNode)

        box.position.y = ownerFrame.height/2 + box.size.height/2
        box.run(createFallingBoxAction())
    }

    static func addFixedObjectsToAddHitsBox(winBox: SKSpriteNode, glass: SKSpriteNode)
    {
        let levelID = NPDirector.shared.currentLevelID
        let episodeID = NPDirector.shared.currentEpisodeID
        
        
        let levelTitleSprite = SKSpriteNode(imageNamed: "level-title")
        levelTitleSprite.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.midY)
        levelTitleSprite.position.y += winBox.size.height / 3.25
        levelTitleSprite.zPosition = 5
        winBox.addChild(levelTitleSprite)
        
        let levelTitleLabel = SKLabelNode(fontNamed: boxesFontName)
        levelTitleLabel.text = "Level \(episodeID)-\(levelID)"
        levelTitleLabel.fontSize = levelTitleSprite.size.height * 0.35
        levelTitleLabel.verticalAlignmentMode = .center
        levelTitleLabel.zPosition = 6
        levelTitleSprite.addChild(levelTitleLabel)
        
        
        let exitButton = PushButton(fixedImageName: "fixed", normalImageName: "normal", pressedImageName: "pressed", symbolImageName: "exit-symbol", onPushed: NPDirector.displayCurrentEpisodeMenu)
        exitButton.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.minY + exitButton.size.height/2)
        
        exitButton.zPosition = 5
        exitButton.isUserInteractionEnabled = true
        winBox.addChild(exitButton)
        
        
        let repeatButton = PushButton(fixedImageName: "fixed", normalImageName: "normal", pressedImageName: "pressed", symbolImageName: "repeat-symbol", onPushed: repeatLevel)
        repeatButton.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.minY + repeatButton.size.height/2)
        repeatButton.position.x -= winBox.size.width / 3
        repeatButton.zPosition = 5
        repeatButton.isUserInteractionEnabled = true
        winBox.addChild(repeatButton)
        
        func addHits()
        {
            winBox.run(createRisingBoxAction(), completion: {
                glass.removeFromParent();
                SJDirector.shared.stopBGMusic()
                Chartboost.showRewardedVideo(CBLocationHomeScreen)
                if(SJDirector.shared.isTimeLevel)
                {
                    var addedTime = 10
                    if SJDirector.shared.originalNumberOfHits <= 10
                    {
                        addedTime = 5
                    }
                    SJLevelScene.currentLevelScene?.hitsRemaining = addedTime
                }
                else
                {
                    var addedHits = 3
                    if SJDirector.shared.originalNumberOfHits <= 6
                    {
                        addedHits = 1
                    }
                    else if SJDirector.shared.originalNumberOfHits <= 10
                    {
                        addedHits = 2
                    }
                    SJLevelScene.currentLevelScene?.hitsRemaining = addedHits
                }
                SJLevelScene.status = .playing //because it is previously .checkingForLoss
            })
            
        }
        let okButton = PushButton(fixedImageName: "fixed", normalImageName: "normal", pressedImageName: "pressed", symbolImageName: "ok-symbol", onPushed: addHits)
        okButton.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.minY + repeatButton.size.height/2)
        okButton.position.x += winBox.size.width / 3
        okButton.zPosition = 5
        okButton.isUserInteractionEnabled = true
        winBox.addChild(okButton)
        
        
        
    }
    static func showAddHits(ownerFrame: CGRect, parentSKNode: SKNode)
    {
        
        NPDirector.shared.gamePaused = true

        let glassNode = SKSpriteNode(color: SKColor.clear, size: ownerFrame.size)
        
        
        glassNode.position = CGPoint(x: ownerFrame.midX, y: ownerFrame.midY)
        //        owner.childNode(withName: MainMenu.menuHolderName)?.addChild(glassNode)
        glassNode.zPosition = 999
        glassNode.name = "glass"
        parentSKNode.addChild(glassNode)
        
        let shadowNode = SKSpriteNode(color: SKColor.blue, size: glassNode.size)
        shadowNode.alpha = 0.3
        shadowNode.zPosition = 3
        glassNode.addChild(shadowNode)
        
        
        let box = SKSpriteNode(imageNamed: "addHits")
        box.zPosition = 4
        glassNode.addChild(box)
        addFixedObjectsToAddHitsBox(winBox: box, glass: glassNode)
        box.position.y = ownerFrame.height/2 + box.size.height/2
        box.run(createFallingBoxAction())
        
        return
        //if we are adding credit
        
    }
    
    static func addFixedObjectsToAddGoldConfirmation(winBox: SKSpriteNode, glass: SKSpriteNode)
    {
        let levelID = NPDirector.shared.currentLevelID
        let episodeID = NPDirector.shared.currentEpisodeID
        
        
        let levelTitleSprite = SKSpriteNode(imageNamed: "level-title")
        levelTitleSprite.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.midY)
        levelTitleSprite.position.y += winBox.size.height / 3.25
        levelTitleSprite.zPosition = 5
        winBox.addChild(levelTitleSprite)
        
        let levelTitleLabel = SKLabelNode(fontNamed: boxesFontName)
        levelTitleLabel.text = "Level \(episodeID)-\(levelID)"
        levelTitleLabel.fontSize = levelTitleSprite.size.height * 0.35
        levelTitleLabel.verticalAlignmentMode = .center
        levelTitleLabel.zPosition = 6
        levelTitleSprite.addChild(levelTitleLabel)
        
        
        func addGold()
        {
            winBox.run(createRisingBoxAction(), completion: {
                glass.removeFromParent();
                NPDirector.shared.gamePaused = false;
               // Chartboost.showRewardedVideo(CBLocationHomeScreen)
               Boxes.addGoldFree()
            })
            
        }
        let okButton = PushButton(fixedImageName: "fixed", normalImageName: "normal", pressedImageName: "pressed", symbolImageName: "ok-symbol", onPushed: addGold)
        okButton.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.minY + okButton.size.height/2)
        okButton.position.x -= winBox.size.width / 4
        okButton.zPosition = 5
        okButton.isUserInteractionEnabled = true
        winBox.addChild(okButton)
        
        
        func resumeGame()
        {
            winBox.run(createRisingBoxAction(), completion: {glass.removeFromParent();NPDirector.shared.gamePaused = false})
        }
        let resumeButton = PushButton(fixedImageName: "fixed", normalImageName: "normal", pressedImageName: "pressed", symbolImageName: "resume-symbol", onPushed: resumeGame)
        resumeButton.position = CGPoint(x: winBox.frame.midX, y: okButton.position.y)
        resumeButton.position.x += winBox.size.width / 4
        resumeButton.zPosition = 5
        resumeButton.isUserInteractionEnabled = true
        winBox.addChild(resumeButton)
    }


    static func showAddGoldConfirmation(ownerFrame: CGRect, parentSKNode: SKNode)
    {
        let glassNode = SKSpriteNode(color: SKColor.clear, size: ownerFrame.size)
        glassNode.position = CGPoint(x: ownerFrame.midX, y: ownerFrame.midY)
        //        owner.childNode(withName: MainMenu.menuHolderName)?.addChild(glassNode)
        glassNode.zPosition = 999
        glassNode.name = "glass"
        parentSKNode.addChild(glassNode)
        
        let shadowNode = SKSpriteNode(color: SKColor.blue, size: glassNode.size)
        shadowNode.alpha = 0.3
        shadowNode.zPosition = 3
        glassNode.addChild(shadowNode)
        
        
        let box = SKSpriteNode(imageNamed: "addGoldAd")
        box.zPosition = 4
        glassNode.addChild(box)
        addFixedObjectsToAddGoldConfirmation(winBox: box, glass: glassNode)
        box.position.y = ownerFrame.height/2 + box.size.height/2
        box.run(createFallingBoxAction())
        
        return
        //if we are adding credit
        
    }
    
    static func addFixedObjectsToConfirmationBox(winBox: SKSpriteNode, glass: SKSpriteNode)
    {
        let levelID = NPDirector.shared.currentLevelID
        let episodeID = NPDirector.shared.currentEpisodeID
        
        
        let levelTitleSprite = SKSpriteNode(imageNamed: "level-title")
        levelTitleSprite.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.midY)
        levelTitleSprite.position.y += winBox.size.height / 3.25
        levelTitleSprite.zPosition = 5
        winBox.addChild(levelTitleSprite)
        
        let levelTitleLabel = SKLabelNode(fontNamed: boxesFontName)
        levelTitleLabel.text = "Level \(episodeID)-\(levelID)"
        levelTitleLabel.fontSize = levelTitleSprite.size.height * 0.35
        levelTitleLabel.verticalAlignmentMode = .center
        levelTitleLabel.zPosition = 6
        levelTitleSprite.addChild(levelTitleLabel)
        
        
        let exitButton = PushButton(fixedImageName: "fixed", normalImageName: "normal", pressedImageName: "pressed", symbolImageName: "exit-symbol", onPushed: NPDirector.displayCurrentEpisodeMenu)
        exitButton.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.minY + exitButton.size.height/2)
        
        exitButton.zPosition = 5
        exitButton.isUserInteractionEnabled = true
        winBox.addChild(exitButton)
        
        
        let repeatButton = PushButton(fixedImageName: "fixed", normalImageName: "normal", pressedImageName: "pressed", symbolImageName: "repeat-symbol", onPushed: repeatLevel)
        repeatButton.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.minY + repeatButton.size.height/2)
        repeatButton.position.x -= winBox.size.width / 3
        repeatButton.zPosition = 5
        repeatButton.isUserInteractionEnabled = true
        winBox.addChild(repeatButton)
        
        func resumeGame()
        {
            winBox.run(createRisingBoxAction(), completion: {glass.removeFromParent();NPDirector.shared.gamePaused = false})
  
        }
        let resumeButton = PushButton(fixedImageName: "fixed", normalImageName: "normal", pressedImageName: "pressed", symbolImageName: "resume-symbol", onPushed: resumeGame)
        resumeButton.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.minY + repeatButton.size.height/2)
        resumeButton.position.x += winBox.size.width / 3
        resumeButton.zPosition = 5
        resumeButton.isUserInteractionEnabled = true
        winBox.addChild(resumeButton)

        
        
    }
    static func showExitConfirmation(ownerFrame: CGRect, parentSKNode: SKNode)
    {
        let glassNode = SKSpriteNode(color: SKColor.clear, size: ownerFrame.size)
        
        
        glassNode.position = CGPoint(x: ownerFrame.midX, y: ownerFrame.midY)
        //        owner.childNode(withName: MainMenu.menuHolderName)?.addChild(glassNode)
        glassNode.zPosition = 999
        glassNode.name = "glass"
        parentSKNode.addChild(glassNode)
        
        let shadowNode = SKSpriteNode(color: SKColor.blue, size: glassNode.size)
        shadowNode.alpha = 0.3
        shadowNode.zPosition = 3
        glassNode.addChild(shadowNode)
        
        
        let box = SKSpriteNode(imageNamed: "confirmation")
        box.zPosition = 4
        glassNode.addChild(box)
        addFixedObjectsToConfirmationBox(winBox: box, glass: glassNode)
        box.position.y = ownerFrame.height/2 + box.size.height/2
        box.run(createFallingBoxAction())
        
        return
        //if we are adding credit

    }
    

    static func addFixedObjectsToResetConfirmationBox(winBox: SKSpriteNode, glass: SKSpriteNode)
    {

        func resetGameData()
        {
            winBox.run(createRisingBoxAction(), completion: {glass.removeFromParent();GameData.resetProgress();NPDirector.displayCurrentEpisodeMenu()})

        }

        let okButton = PushButton(fixedImageName: "fixed", normalImageName: "normal", pressedImageName: "pressed", symbolImageName: "ok-symbol", onPushed: resetGameData)

        okButton.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.minY + okButton.size.height/2)
        okButton.position.x -= winBox.size.width / 3

        okButton.zPosition = 5
        okButton.isUserInteractionEnabled = true
        winBox.addChild(okButton)


        func resumeGame()
        {
            winBox.run(createRisingBoxAction(), completion: {glass.removeFromParent()})

        }
        let resumeButton = PushButton(fixedImageName: "fixed", normalImageName: "normal", pressedImageName: "pressed", symbolImageName: "resume-symbol", onPushed: resumeGame)
        resumeButton.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.minY + resumeButton.size.height/2)
        resumeButton.position.x += winBox.size.width / 3
        resumeButton.zPosition = 5
        resumeButton.isUserInteractionEnabled = true
        winBox.addChild(resumeButton)



    }
    static func showResetConfirmation(ownerFrame: CGRect, parentSKNode: SKNode)
    {
        let glassNode = SKSpriteNode(color: SKColor.clear, size: ownerFrame.size)


        glassNode.position = CGPoint(x: ownerFrame.midX, y: ownerFrame.midY)
        //        owner.childNode(withName: MainMenu.menuHolderName)?.addChild(glassNode)
        glassNode.zPosition = 999
        glassNode.name = "glass"
        parentSKNode.addChild(glassNode)

        let shadowNode = SKSpriteNode(color: SKColor.blue, size: glassNode.size)
        shadowNode.alpha = 0.3
        shadowNode.zPosition = 3
        glassNode.addChild(shadowNode)


        let box = SKSpriteNode(imageNamed: "resetConfirmation")
        box.zPosition = 4
        glassNode.addChild(box)
        addFixedObjectsToResetConfirmationBox(winBox: box, glass: glassNode)
        box.position.y = ownerFrame.height/2 + box.size.height/2
        box.run(createFallingBoxAction())

        return
        //if we are adding credit

    }


    static func addFixedObjectsToGoldBox(winBox: SKSpriteNode, glass: SKSpriteNode)
    {
        let levelID = NPDirector.shared.currentLevelID
        let episodeID = NPDirector.shared.currentEpisodeID
        
        
       
        

        func resumeGame()
        {
            winBox.run(createRisingBoxAction(), completion: {glass.removeFromParent();NPDirector.shared.gamePaused = false})
        }
        let resumeButton = PushButton(fixedImageName: "fixed", normalImageName: "normal", pressedImageName: "pressed", symbolImageName: "resume-symbol", onPushed: resumeGame)
        resumeButton.position = CGPoint(x: winBox.frame.midX, y: winBox.frame.minY + resumeButton.size.height/2.5)
    //    resumeButton.position.x += winBox.size.width / 3
        resumeButton.zPosition = 5
        resumeButton.isUserInteractionEnabled = true
        winBox.addChild(resumeButton)
        
        
        
    }
    
    //adds box with realy money in addition to watching ads
    static func showAddGoldBox()
    {
        guard let parentSKNode = SJLevelScene.currentLevelScene else
        {
            return
        }
        let ownerFrame = parentSKNode.frame
        
        let glassNode = SKSpriteNode(color: SKColor.clear, size: ownerFrame.size)
        
        
        glassNode.position = CGPoint(x: ownerFrame.midX, y: ownerFrame.midY)
        //        owner.childNode(withName: MainMenu.menuHolderName)?.addChild(glassNode)
        glassNode.zPosition = 999
        glassNode.name = "glass"
        parentSKNode.addChild(glassNode)
        
        let shadowNode = SKSpriteNode(color: SKColor.black, size: glassNode.size)
        shadowNode.alpha = 0.4
        shadowNode.zPosition = 3
        glassNode.addChild(shadowNode)
        
        
        let box = SKSpriteNode(imageNamed: "goldBox")
        box.zPosition = 10
        //add gold buttons
        let currentGold = ProgressManager.getCredit()
        
        let currentGoldSprite = SKSpriteNode(imageNamed: "currentGold")
        currentGoldSprite.position = CGPoint(x: box.frame.midX, y: box.frame.midY)
        currentGoldSprite.position.y += box.size.height / 3.75
        currentGoldSprite.zPosition = box.zPosition + 1
        box.addChild(currentGoldSprite)
        
        let currentGoldLabel = SKLabelNode(fontNamed: boxesFontName)
        currentGoldLabel.text = "You have: \(currentGold)"
        currentGoldLabel.fontSize = currentGoldSprite.size.height * 0.35
        currentGoldLabel.verticalAlignmentMode = .bottom
        currentGoldLabel.zPosition = 6
        currentGoldSprite.addChild(currentGoldLabel)
        let vDiff = currentGoldSprite.calculateAccumulatedFrame().height
        
        
        let goldFree = EffectButton(img: "addGoldFree")
        goldFree.position = currentGoldSprite.position
        goldFree.zPosition = currentGoldSprite.zPosition
        goldFree.position.y -= vDiff
        box.addChild(goldFree)
        goldFree.onTouched = addGoldFree
        
        
        let gold1 = EffectButton(img: "addGold1")
        gold1.position = goldFree.position
        gold1.zPosition = goldFree.zPosition
        gold1.position.y -= vDiff
        box.addChild(gold1)
        gold1.onTouched = addGold1
        
        let gold2 = EffectButton(img: "addGold2")
        gold2.position = gold1.position
        gold2.zPosition = gold1.zPosition
        gold2.position.y -= vDiff
        box.addChild(gold2)
        gold2.onTouched = addGold2
        
        let gold3 = EffectButton(img: "addGold3")
        gold3.position = gold2.position
        gold3.zPosition = gold2.zPosition
        gold3.position.y -= vDiff
        box.addChild(gold3)
        gold3.onTouched = addGold3
        
        let gold5 = EffectButton(img: "addGold5")
        gold5.position = gold3.position
        gold5.zPosition = gold3.zPosition
        gold5.position.y -= vDiff
        box.addChild(gold5)
        gold5.onTouched = addGold5
        
        
        addFixedObjectsToGoldBox(winBox: box, glass: glassNode)
        box.position.y = ownerFrame.height/2 + box.size.height/2
        glassNode.addChild(box)
        

 
        
        
        
        let action = createFallingBoxAction()
        box.run(action)
        
        
        
        return
        //if we are adding credit
    }
    
    static func nextLevel()
    {
        removeGlass()
        NPDirector.showAdBeforeLevelStart()
        //NPDirector.proceed()
    }
    static func repeatLevel()
    {
        removeGlass()
        NPDirector.showAdBeforeLevelRepeat()
    }

    // all this function calling because we have to do the following:
    // 1. onTouched: has to be a function without parameters
    // 2. We need to update the gold control on the level scene and we want it to be called once
    static func addGoldWithPrice(price: Int)
    {
        switch price
        {
        case 0:
            ProgressManager.addCredit(addedValue: 200)
        case 1:
            ProgressManager.addCredit(addedValue: 1000)
        case 2:
            ProgressManager.addCredit(addedValue: 3000)
        case 3:
            ProgressManager.addCredit(addedValue: 5000)
        case 5:
            ProgressManager.addCredit(addedValue: 10000)
        default:
            break
        }
        SJLevelScene.currentLevelScene?.goldLabel.text = "\(ProgressManager.getCredit())"
        
    }
    static func addGoldFree()
    {
        SJDirector.shared.stopBGMusic()
        Chartboost.showRewardedVideo(CBLocationHomeScreen)
        NPDirector.shared.hasGoldToAdd = true
        Chartboost.cacheRewardedVideo(CBLocationHomeScreen)
    }
    
    static func addGold1()
    {
        addGoldWithPrice(price: 1)
    }
    static func addGold2()
    {
        addGoldWithPrice(price: 2)
    }
    static func addGold3()
    {
        addGoldWithPrice(price: 3)
    }
    static func addGold5()
    {
        addGoldWithPrice(price: 5)
    }
}
