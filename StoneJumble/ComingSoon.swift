//
//  AhyComingSoon.swift
//  Hasty Rock
//
//  Created by Tony Ayoub on 10/18/15.
//  Copyright (c) 2015 amahy. All rights reserved.
//

import SpriteKit

class ComingSoon: SKScene
{
    
    override func didMove(to view: SKView)
    {
        self.backgroundColor = SKColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        let comingSoon = SKLabelNode(fontNamed: "Georgia-BoldItalic")
        comingSoon.text = "Coming Soon..."
        comingSoon.fontSize = NPDirector.shared.episodeTitleSize
        comingSoon.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        self.addChild(comingSoon)
        
        let leftArrow = SKSpriteNode(imageNamed: "left-arrow")
        leftArrow.position = CGPoint(x: self.frame.minX + leftArrow.size.width/2, y: self.frame.midY)
        leftArrow.name = "left"
        leftArrow.color = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        leftArrow.colorBlendFactor = 0.5
        self.addChild(leftArrow)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let touch = touches.first //touches.first is optional
        {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
        
            if let name = touchedNode.name
            {
                if name == "left"
                {
                    //Display last available episode
                }
            }
        }
    }
}
