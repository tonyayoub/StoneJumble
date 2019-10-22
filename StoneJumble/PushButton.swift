//
//  PushButton.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 5/3/17.
//  Copyright © 2017 amahy. All rights reserved.
//

import SpriteKit

class PushButton: SKSpriteNode
{
    var callBack:(() -> Void)?
    var unPressedSprite: SKSpriteNode
    var pressedSprite: SKSpriteNode
    var symbol: SKSpriteNode
    var nameForTestingReasons: String = "nil"
    
    init(fixedImageName: String, normalImageName: String, pressedImageName: String, symbolImageName: String, onPushed: @escaping (() -> Void))
    {
        let fixedTexture = SKTexture(imageNamed: fixedImageName)
        unPressedSprite = SKSpriteNode(imageNamed: normalImageName)
        pressedSprite = SKSpriteNode(imageNamed: pressedImageName)
        symbol = SKSpriteNode(imageNamed: symbolImageName)

        super.init(texture: fixedTexture, color: SKColor.clear, size: fixedTexture.size())
        //cannot call super.init(imageNamed: fixedImageName) because this is a convenience initializer of SKSpriteNode and my initializer is a designated initializer for PushButton, so it can only call designated initilizers of super class
        self.isUserInteractionEnabled = true
        unPressedSprite.zPosition = 1
        self.addChild(unPressedSprite)
        
        pressedSprite.zPosition = 2
        pressedSprite.isHidden = true
        self.addChild(pressedSprite)
        
        
        symbol.zPosition = 3
        self.addChild(symbol)
        
        callBack = onPushed
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func doEffect()
    {
        unPressedSprite.isHidden = true
        pressedSprite.isHidden = false
        symbol.setScale(1.05)
        symbol.alpha = 0.9
        
    }
    
    func undoEffect()
    {
        unPressedSprite.isHidden = false
        pressedSprite.isHidden = true
        symbol.setScale(1.0)
        symbol.alpha = 1.0
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if self.callBack == nil //if there is no callback, don't make an effect
        {
            return
        }
        else
        {
            
            doEffect()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if self.callBack == nil //if there is no callback, don't make an effect
        {
            return
        }
        
        
        guard let touchLoc = touches.first?.location(in: self.parent!) else
        {
            return
        }
        if self.contains(touchLoc)
        {
            doEffect()
        }
        else
        {
            undoEffect()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesEnded(touches, with: event)
        if self.callBack == nil //if there is no callback, don't make an effect
        {
            return
        }
        undoEffect()
 
        if let touch = touches.first, let parentNode = self.parent, let callBack = callBack
        {
            if self.contains(touch.location(in: parentNode))
            {
                SJDirector.shared.sound.runSoundAction(owner: self, soundAction: SKAction.playSoundFileNamed("click", waitForCompletion: false))
                callBack()
            }
        }
        
    }
}
