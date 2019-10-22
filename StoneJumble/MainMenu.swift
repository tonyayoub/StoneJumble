//
//  MainMenu.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 11/4/15.
//  Copyright © 2015 amahy. All rights reserved.
//


import SpriteKit
import CloudKit


class MainMenu: SKScene
{
    
    var selectedNode: SKNode?
    
    static let menuHolderName = "menuHolder"
    static let leftArrowName = "leftArrow"
    static let rightArrowName = "rightArrow"
    static let episodeTitleAndLevels = "currentEpisodeTitleAndLevels"
    static let episodeArrows = "episodeArrows"
    static let fontName = "ChalkboardSE-Bold"
    static var menuStatus:DisplayedMenuStatus = .StartingMenu
    
    //static let fontName = "Chalkduster"
    
    
    var titleAndArrowsY:CGFloat = 0
    var bg = SKSpriteNode(color: SKColor.black, size: CGSize(width: 768, height: 1024))
    
    enum DisplayedMenuStatus
    {
        case StartingMenu
        case EpisodeMenu
        case HelpMenu
        case SettingsMenu
    }
    override func didMove(to view: SKView)
    {
        NPDirector.shared.hideBanner()
        createSceneContents();
    }
    
    func createSceneContents()
    {

       // let bg = SKSpriteNode(imageNamed: "sky-bg")
        bg.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bg.name = "bg"
        
        bg.zPosition = -100
        self.addChild(bg)
        
   //     createEmitters()
        createMainMenuLables()
        
        self.view?.isMultipleTouchEnabled = false
    }
    
    func test11()
    {
        // print("pushing down")
    }
    func createMainMenuLables()
    {
        MainMenu.menuStatus = .StartingMenu
        bg.texture = SKTexture(imageNamed: "firstBG")

        bg.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        let mainMenuHolder = deleteOldMenuHolderAndCreateANewOne()

        let deviation = self.frame.width/100
        
        let actMiddle =
           SKAction.sequence([SKAction.wait(forDuration: 5),
                              SKAction.repeatForever(SKAction.sequence([SKAction.rotate(byAngle: -0.1, duration: 2), SKAction.rotate(byAngle: 0.1, duration: 2)]))
            ])

        


        let playButton = EffectButton(img: "play")
        mainMenuHolder.addChild(playButton)
        playButton.position = CGPoint(x: self.frame.midX, y: playButton.calculateAccumulatedFrame().height * 0.8)
        playButton.zPosition = 9
        playButton.onTouched = playCallBack
        
        
        
        
        
        
        var startingPoint = CGPoint(x: self.frame.midX, y: self.frame.midY)
        startingPoint.y -= self.frame.height * 0.05
        
        let middle = SKSpriteNode(imageNamed: "tomato1")
        mainMenuHolder.addChild(middle)
        middle.zPosition = 9
        middle.zRotation = 0.05
        middle.position = startingPoint
        
        middle.run(actMiddle)
        
        let upper = SKSpriteNode(imageNamed: "pea1")
        mainMenuHolder.addChild(upper)
        upper.zPosition = 9
        upper.position = startingPoint
        upper.position.y += (middle.size.height/2 + upper.size.height/2)

        //upper.run(actTop)
        upper.run(SKAction.sequence([
            SKAction.wait(forDuration: 2),
            SKAction.repeatForever(SKAction.sequence([
                SKAction.shake(upper.position, duration: 0.5, amplitudeX: Int(deviation), amplitudeY: 0),
                SKAction.wait(forDuration: 4)
                ]))
            ]))

        
        
        let right = SKSpriteNode(imageNamed: "lemon1")
        mainMenuHolder.addChild(right)
        right.zPosition = 9
        right.position = startingPoint
        right.position.x +=  (right.size.width/2 + middle.size.width/2)
        

       
        
        
        
        let left = SKSpriteNode(imageNamed: "btengan1")
        mainMenuHolder.addChild(left)
        left.zPosition = 9
        left.position = startingPoint
        left.position.x -= (left.size.width/2 + middle.size.width/2)
        right.run(createSideAct(deviation: deviation, point: right.position))
        left.run(createSideAct(deviation: deviation, point: left.position))

        let lower = SKSpriteNode(imageNamed: "kronb1")
        mainMenuHolder.addChild(lower)
        lower.zPosition = 9
        lower.position = startingPoint
        lower.position.y -= (lower.size.height/2 + middle.size.height/2)



        lower.run(SKAction.sequence([
            SKAction.wait(forDuration: 1.5),
            SKAction.repeatForever(SKAction.sequence([
                SKAction.shake(lower.position, duration: 0.5, amplitudeX: 0, amplitudeY: Int(deviation)),
                SKAction.wait(forDuration: 4)
                ]))
            ]))

        let enemy = SKSpriteNode(imageNamed: "enemy")
        mainMenuHolder.addChild(enemy)
        enemy.zPosition = 99
        enemy.position = startingPoint
        enemy.position.y = self.frame.size.height - enemy.size.height/2
        if enemy.size.width > self.frame.size.width
        {
            enemy.size.width = self.frame.size.width * 0.95
        }

        let floor = SKSpriteNode(imageNamed: "firstFloor")
        mainMenuHolder.addChild(floor)
        floor.zPosition = 7
        floor.position = playButton.position
        floor.position.y = floor.size.height/2


    }

    func createSideAct(deviation: CGFloat, point: CGPoint) -> SKAction
    {
        // upper position = deviation * 12
        var shakingPoint = point
        shakingPoint.y = point.y + deviation * 12
        let sidesAct = SKAction.repeatForever(
            SKAction.sequence([
                SKAction.wait(forDuration: 3),
                SKAction.repeat(SKAction.sequence([
                    SKAction.moveBy(x: 0, y: deviation*5, duration: 1),
                    SKAction.moveBy(x: 0, y: -deviation, duration: 0.1),
                    SKAction.wait(forDuration: 0.5)
                    ]), count: 3),
                SKAction.wait(forDuration: 0.5),
                SKAction.shake(shakingPoint, duration: 1),
                SKAction.wait(forDuration: 0.2),
                SKAction.moveBy(x: 0, y: -deviation*16, duration: 1),
                SKAction.moveBy(x: 0, y: deviation*4, duration: 0.1),
                SKAction.wait(forDuration: 2)
                ])
        )
        return sidesAct
    }
    func createHelpScene()
    {
        let menuHolder = deleteOldMenuHolderAndCreateANewOne()
        let helpLabel = SKSpriteNode(imageNamed: "helpBox")
        helpLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        menuHolder.addChild(helpLabel)
        MainMenu.menuStatus = .HelpMenu
    }


    
    
    func testCloud()
    {
        // print("fetching cloud prgress...")
        /*
        let container = CKContainer.default()
        let publicDB = container.publicCloudDatabase
        let goldPredicate = NSPredicate(format: "Key == %@", "Gold")
        let query = CKQuery(recordType: "Progress", predicate: goldPredicate)
      

        
        publicDB.perform(query, inZoneWith: nil) { [unowned self] results, error in
            if let error = error {
                // print(error)
                return
            }
            
            // print(results!.count)
            // print(results!.count)
            if let record = results?[0]
            {
                // print(record.object(forKey: "Value")! )
            }
        }
        */
        //test write
        
        
    }
    func playCallBack()
    {
        
        
        self.childNode(withName: MainMenu.menuHolderName)?.removeFromParent()
        createEpisodeMenu()
        //displayEpisode(episodeID: GameData.shared.maxProgress.episode, firstEpisodeToBeDisplayed: true)
    }
    

    //direction = 1 for next and -1 for previous
    func displayComingEpisode(direction: Int)
    {
        
        let newEpisodeID = NPDirector.shared.currentEpisodeID + direction
        
        guard let menuHolder = self.childNode(withName: MainMenu.menuHolderName) else
        {
            return
        }
        menuHolder.childNode(withName: HolderNode.movingOutName)?.removeFromParent() //previously moving holder
        
        if let childHolder = menuHolder.childNode(withName: MainMenu.episodeTitleAndLevels) as? HolderNode
        {
            childHolder.fadeOutWithDirection(direction: CGFloat(-1 * direction))
        }
        
        displayEpisodeTitleAndLevels(episodeID: newEpisodeID, direction: CGFloat(direction))
        enableAndDisableArrows(episodeID: newEpisodeID)
    }
    
    //those two functions because the call back of the arrow buttons must not have any parameters
    func displayNextEpisode()
    {
        displayComingEpisode(direction: 1)
    }
    
    func displayPreviousEpisode()
    {
        displayComingEpisode(direction: -1)
    }
    

    
    func createEpisodeMenu()
    {
        MainMenu.menuStatus = .EpisodeMenu
        let menuHolder = deleteOldMenuHolderAndCreateANewOne()

        
        //x: middle, y: middle then shift up
        
        //scene holder: holding both arrows and Episode title and levels
        
 
        
        
        let leftArrowIcon = EffectButton(img: "leftArrow")
        self.titleAndArrowsY = self.frame.height - leftArrowIcon.calculateAccumulatedFrame().height
        let titleAndArrowsPosition = CGPoint(x: self.frame.midX, y: self.titleAndArrowsY)
        
        leftArrowIcon.position = CGPoint(x: leftArrowIcon.calculateAccumulatedFrame().width, y: titleAndArrowsPosition.y)
        leftArrowIcon.onTouched = displayPreviousEpisode
        leftArrowIcon.name = MainMenu.leftArrowName
        menuHolder.addChild(leftArrowIcon) //we add arrows to menuHolder because they will not move

        let rightArrowIcon = EffectButton(img: "rightArrow")
        rightArrowIcon.position = CGPoint(x: self.frame.size.width - rightArrowIcon.calculateAccumulatedFrame().width, y: titleAndArrowsPosition.y)
        rightArrowIcon.onTouched = displayNextEpisode
        rightArrowIcon.name = MainMenu.rightArrowName
        menuHolder.addChild(rightArrowIcon)
        
        enableAndDisableArrows(episodeID: NPDirector.shared.currentEpisodeID)


        let helpIcon = EffectButton(img: "helpWooden")
        helpIcon.position = CGPoint(x: helpIcon.calculateAccumulatedFrame().width, y: helpIcon.calculateAccumulatedFrame().height)
        helpIcon.onTouched = createHelpScene
        menuHolder.addChild(helpIcon)


        let homeIcon = EffectButton(img: "menuWooden")
        homeIcon.position = CGPoint(x: self.frame.midX, y: homeIcon.calculateAccumulatedFrame().height)
        homeIcon.onTouched = createMainMenuLables
        menuHolder.addChild(homeIcon)
        


        let settingsIcon = EffectButton(img: "settingsWooden")
        settingsIcon.position = CGPoint(x: self.frame.width - settingsIcon.calculateAccumulatedFrame().width, y: settingsIcon.calculateAccumulatedFrame().height)
        settingsIcon.onTouched = displayOptions
        menuHolder.addChild(settingsIcon)
        
        
    
        
        
        displayEpisodeTitleAndLevels(episodeID: NPDirector.shared.currentEpisodeID, direction: 0)

    }
    func enableAndDisableArrows(episodeID: Int)
    {
        let isFirstEpisode = episodeID == 1
        let isLastEpisode = episodeID == GameData.numberOfEpisodes
        
        self.childNode(withName: MainMenu.menuHolderName)?.childNode(withName: MainMenu.leftArrowName)?.isHidden = isFirstEpisode
        self.childNode(withName: MainMenu.menuHolderName)?.childNode(withName: MainMenu.rightArrowName)?.isHidden = isLastEpisode
    
    }
    var cheatCounter = 0;
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        switch MainMenu.menuStatus
        {
        case .StartingMenu:
            playCallBack()
        case .HelpMenu:
            NPDirector.displayCurrentEpisodeMenu()
        case .SettingsMenu:
            NPDirector.displayCurrentEpisodeMenu()
        case .EpisodeMenu:
            cheatCounter += 1
            if cheatCounter >= 20
            {
                cheatCounter = 0
                print("open all levels for for \(NPDirector.shared.currentEpisodeID)");
                cheat()
            }

        }
    }

    func cheat()
    {
        let maxProgress = GameData.shared.maxProgress
        let maxAchievedEpisode = maxProgress.episode
        let maxAchievedLevel = maxProgress.level
        let currentEpisode = NPDirector.shared.currentEpisodeID

        if currentEpisode == maxAchievedEpisode && maxAchievedLevel < 9
        {
            for i in (maxAchievedLevel)...9
            {
                print("\(i)")
                ProgressManager.saveLevelAch(episodeID: currentEpisode, levelID: i, value: 3)
                
                GameData.shared.maxProgress = (episode: currentEpisode, level: i)
            }
        }



    }
    func displayEpisodeTitleAndLevels(episodeID: Int, direction: CGFloat)
    {
        
        bg.texture =  SKTexture(imageNamed: "bg")
        
        NPDirector.shared.currentEpisodeID = episodeID
        let menuHolder = self.childNode(withName: MainMenu.menuHolderName)
            //episode title and levels
        let episodeHolder = HolderNode()
        episodeHolder.name = MainMenu.episodeTitleAndLevels
        episodeHolder.alpha = 0
        menuHolder?.addChild(episodeHolder)
        
   //     episodeHolder.position.x += self.frame.size.width/24 * direction
   //     episodeHolder.run(SKAction.moveTo(x: 0, duration: 0.4))
        episodeHolder.run(SKAction.fadeIn(withDuration: 0.5))
        
        //episode title
        let menuTitle = EffectButton(img: "episodeTitle", text: "Menu \(episodeID)", fontSizeFactor: 5)
        
        
       
        menuTitle.position = CGPoint(x: self.frame.midX, y: titleAndArrowsY)
        episodeHolder.addChild(menuTitle)

        


        
       /*
        let level1 = LevelLabelHolder(labelID: 1, episodeID: 1, status: .locked)
        // print(level1.calculateAccumulatedFrame().width)
        level1.position = CGPoint(x: self.frame.midX - level1.calculateAccumulatedFrame().width/2, y: self.frame.midY + self.frame.height * 0.15)
        episodeHolder.addChild(level1)
        // print(level1.calculateAccumulatedFrame().width)
        level1.buttonSprite?.onTouched = createMainMenuLables 
         */
        
        let maxProgress = GameData.shared.maxProgress
        let maxAchievedEpisode = maxProgress.episode
        let maxAchievedLevel = maxProgress.level
        
        
        let refY = titleAndArrowsY * 0.90
        
        let dummyLevelLabel = LevelLabelHolder(levelID: 1, episodeID: 1, status: .open)
        let leftX = dummyLevelLabel.calculateAccumulatedFrame().width * 0.6
        let midX = self.frame.midX
        let rightX = self.frame.width - dummyLevelLabel.calculateAccumulatedFrame().width * 0.6
        let stepY = self.frame.size.height / 13

        
        for levelID in 1...GameData.numberOfLevelsPerEpisode
        {
            

            var levelStatus: LevelLabelHolder.LevelLabelStatus
            if episodeID > maxAchievedEpisode
            {
                levelStatus = .locked
            }
            else if episodeID < maxAchievedEpisode
            {
                levelStatus = .open
            }
            else // equal (we are in the partial finished episode
            {
                if levelID <= maxAchievedLevel
                {
                    levelStatus = .open
                    
                    if levelID == maxAchievedLevel
                    {
                        levelStatus = .current
                    }
                }
                else
                {
                    levelStatus = .locked
                }
            }
            
            let levelLabel = LevelLabelHolder(levelID: levelID, episodeID: episodeID, status: levelStatus)
            
            /*
            refY - stepY
            refY - stepY
            refY - stepY
            
            refY - 2StepY
            refY - 2StepY
            refY - 2StepY
            
            refY - 3StepY
            refY - 3StepY
            refY - 3StepY
            */
            var subtractedIndex = 0
            if (levelID%3 == 1) //1, 4, 7
            {
                levelLabel.position = CGPoint(x: leftX , y: (refY - CGFloat(levelID - subtractedIndex) * stepY))
            }
            else if (levelID%3 == 2) //2, 5, 8
            {
                subtractedIndex = 1
                levelLabel.position = CGPoint(x: midX , y: (refY - CGFloat(levelID - subtractedIndex) * stepY))
            }
            else // 3, 6, 0
            {
                subtractedIndex = 2
                levelLabel.position = CGPoint(x: rightX , y: (refY - CGFloat(levelID - subtractedIndex) * stepY))

            }
            

            episodeHolder.addChild(levelLabel)
            
            
        }
    }


    func displayOptions()
    {
    
        
        let mainMenuHolder = deleteOldMenuHolderAndCreateANewOne()
        

        let musicButton = EffectButton(img: "musicWooden", switchImg: "mute")
        mainMenuHolder.addChild(musicButton)
        musicButton.position = CGPoint(x: self.frame.midX - (self.frame.width / 6), y: self.frame.midY + (self.frame.height / 6))
        musicButton.onTouched = NPDirector.changeMusicEnabled
        musicButton.switchImgAppearing = !NPDirector.shared.musicEnabled

        let soundButton = EffectButton(img: "soundWooden", switchImg: "mute")
        mainMenuHolder.addChild(soundButton)
        soundButton.position = CGPoint(x: self.frame.midX + (self.frame.width / 6), y: self.frame.midY + (self.frame.height / 6))
        soundButton.onTouched = NPDirector.changeSoundEnabled
        soundButton.switchImgAppearing = !NPDirector.shared.soundEnabled


        let resetButton = EffectButton(img: "resetWooden")
        mainMenuHolder.addChild(resetButton)
        resetButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY - (self.frame.height / 6))
        resetButton.onTouched = displayResetConfirmation
        
        let homeIcon = EffectButton(img: "leftArrow")
        homeIcon.position = CGPoint(x: self.frame.midX, y: homeIcon.calculateAccumulatedFrame().height * 0.8)
        homeIcon.onTouched = NPDirector.displayCurrentEpisodeMenu
        mainMenuHolder.addChild(homeIcon)

        MainMenu.menuStatus = .SettingsMenu

    }
    
    func deleteOldMenuHolderAndCreateANewOne() -> SKNode
    {
        if let x = self.childNode(withName: MainMenu.menuHolderName)
        {
            x.removeFromParent()
        }
        
        let mainMenuHolder = SKNode()
        mainMenuHolder.name = MainMenu.menuHolderName
        mainMenuHolder.alpha = 0
        self.addChild(mainMenuHolder)
        mainMenuHolder.run(SKAction.fadeIn(withDuration: 0.5))
        return mainMenuHolder
    }
    
    func shopping()
    {
        ProgressManager.test()
    }
    func resetGame()
    {
        GameData.resetProgress()
        Boxes.removeGlass()
        createMainMenuLables()
    }
    
    func displayResetConfirmation()
    {
//        NPDirector.createDialogue(owner: self, message: "Reset game data?", okAction: resetGame, noAction: removeGlass)
        if let menuHolder = self.childNode(withName: MainMenu.menuHolderName)
        {
            Boxes.showResetConfirmation(ownerFrame: self.frame, parentSKNode: menuHolder)

//            NPDirector.createDialogue(ownerFrame: self.frame, parentSKNode: menuHolder, message: "Reset game data?", okAction: resetGame, noAction: Boxes.removeGlass)
        }

    }

    

    

  
}


