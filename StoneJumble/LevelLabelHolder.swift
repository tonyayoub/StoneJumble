//
//  LevelLabelHolder.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 3/22/17.
//  Copyright © 2017 amahy. All rights reserved.
//

import SpriteKit

class LevelLabelHolder: SKNode
{
    var ID: Int = 1
    var parentEpisodeID: Int = 1
    var buttonSprite: EffectButton?
    enum LevelLabelStatus
    {
        case locked
        case current
        case open
    }
    

    convenience init(levelID: Int, episodeID: Int, status: LevelLabelStatus)
    {
        self.init()
        
        var imageName = "levelLocked" // locked

        
        switch status
        {
        case .open:
            let levelAch = String(ProgressManager.getLevelAch(episodeID: episodeID, levelID: levelID))
            imageName = "level\(levelAch)"
        case .current:
            imageName = "levelCurrent"
        default:
            break
        }
        
        
        buttonSprite = EffectButton(img: imageName)
        
        guard let button = buttonSprite else
        {
            return
        }
        self.addChild(button)
        ID = levelID
        parentEpisodeID = episodeID
        
        if status != .locked
        {
            buttonSprite?.onTouched = startLevel
        }
        
        let levelIDLabel = SKLabelNode(fontNamed: MainMenu.fontName)
        
        levelIDLabel.fontSize = button.calculateAccumulatedFrame().size.height / 5
        var alphaFactor:CGFloat = 0.4
        
        if status == .locked
        {
            alphaFactor = 0.1
        }
        else if status == .current
        {
            alphaFactor = 1
            
        }
        
        if status == .open
        {
            levelIDLabel.fontColor = SKColor(red: 1, green: 1, blue: 0.7, alpha: alphaFactor)
            

            levelIDLabel.zPosition = 30
            levelIDLabel.text = "\(levelID)"

            levelIDLabel.position.y = button.position.y - button.calculateAccumulatedFrame().size.height / 2.3
            self.addChild(levelIDLabel)
        }
        else if status == .current
        {
            let arrow = SKSpriteNode(imageNamed: "arrow-up")
            arrow.zPosition = self.zPosition - 1
            arrow.position.y = button.position.y - arrow.size.height/1.5
            self.addChild(arrow)
            let arrowYMovement = arrow.size.height / 8
            arrow.run(SKAction.repeatForever(SKAction.sequence([SKAction.moveBy(x: 0, y: arrowYMovement, duration: 0.5), SKAction.moveBy(x: 0, y: -arrowYMovement, duration: 0.5)])))

            
        }

        if parentEpisodeID == 1 && levelID == 1
        {
            levelIDLabel.text = "Tutorial"
        }
    }
    
    func startLevel()
    {
        NPDirector.startBoardLevel(episodeID: parentEpisodeID, levelID: ID)
        
    }


}
