//
//  LevelEnd.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 2/16/16.
//  Copyright © 2016 amahy. All rights reserved.
//

import SpriteKit


class LevelEnd: SKSpriteNode
{
    enum MessageType
    {
        case win
        case lose
        case pause
    }


    func handleTouch(_ location: CGPoint)
    {
        if let restartButton = self.childNode(withName: "restart"),
            let menuButton = self.childNode(withName: "menu"),
            let proceedButton = self.childNode(withName: "proceed")
        {
            let convertedPoint = self.convert(location, from: self.parent!)

            if restartButton.contains(convertedPoint)
            {
                NPDirector.startBoardLevel(episodeID: NPDirector.shared.currentEpisodeID, levelID: NPDirector.shared.currentLevelID)// same level again
            }
            else if menuButton.contains(convertedPoint)
            {
                //NPDirector.createEpisodeScene(NPDirector.shared.currentEpisodeID, bgImageName: "bg-menu", direction: SKTransitionDirection.left)
                
                
                
                   NPDirector.displayMainMenu()
                

            }
            else if proceedButton.contains(convertedPoint)
            {
                NPDirector.displayMainMenu()//1 for now
            }
        }
    }
    convenience init(message: MessageType)
    {
        self.init(color: SKColor.red, size: CGSize(width: 400, height: 200))

        let label = SKLabelNode(fontNamed: "Arial")
        label.fontSize = 30
        switch message
        {
        case .lose:
            label.text = "You are out of hits"
        case .win:
            label.text = "You won"
        default:
            label.text = "Are you sure you want to exit?"
            
        }
        label.position = self.position
        label.run(SKAction.moveTo(y: 20, duration: 0))
        self.addChild(label)
        
        let restartButton = SKSpriteNode(color: SKColor.green, size: CGSize(width: 40,height: 40))
        restartButton.name = "restart"
        restartButton.position.x -= 100
        restartButton.position.y -= 20
        self.addChild(restartButton)
        
        let menuButton = SKSpriteNode(color: SKColor.blue, size: CGSize(width: 40,height: 40))
        menuButton.name = "menu"
//        menuButton.position.x -= 100
        menuButton.position.y -= 20
        self.addChild(menuButton)
        
        let proceedButton = SKSpriteNode(color: SKColor.yellow, size: CGSize(width: 40,height: 40))
        proceedButton.name = "proceed"
        proceedButton.position.x += 100
        proceedButton.position.y -= 20
        self.addChild(proceedButton)
        
        self.zPosition = 100
    }
    
    
 
 
    override init(texture: SKTexture?, color: UIColor, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
        isUserInteractionEnabled = true
        
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }


}
