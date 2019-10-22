//
//  EffectButton.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 3/11/17.
//  Copyright © 2017 amahy. All rights reserved.
//

import SpriteKit

class EffectButton: SKNode
{
    static let labelName = "labelName"
    static let clickSoundAction = SKAction.playSoundFileNamed("click", waitForCompletion: false)
    var onTouched:(() -> Void)?
    var pressedSprite: SKSpriteNode?
    var fg: SKSpriteNode?
    var isUsingSeparateImageForPressingEffect = false //will expand and fade the original sprite
    var isBeingPressed = false


    var switchImgAppearing:Bool
    {
        get
        {
            if let switchImage = self.childNode(withName: "switch")
            {
                return !switchImage.isHidden
            }
            else
            {
                return false
            }

        }
        set(newIsImgAppearing)
        {
            self.childNode(withName: "switch")?.isHidden = !newIsImgAppearing
        }
    }


    override init()
    {
        super.init()
    }
    

    

    convenience init(img: String, pressedImg: String = "", text: String = "", fontSizeFactor: Int = 6, switchImg: String = "")
    {
        self.init()
        self.isUserInteractionEnabled = true
        let transparency:CGFloat = 1.0
        fg = SKSpriteNode(imageNamed: img)
        fg?.alpha = transparency
        if let fgSprite = fg
        {
            fgSprite.zPosition = 3
            fgSprite.name = "fg"
            self.addChild(fgSprite)
            
            if !pressedImg.isEmpty
            {
                isUsingSeparateImageForPressingEffect = true
                pressedSprite = SKSpriteNode(imageNamed: pressedImg)
                self.addChild(pressedSprite!)
                pressedSprite?.zPosition = 9
                pressedSprite?.alpha = 0
            }

            if !switchImg.isEmpty
            {
                let switchSprite = SKSpriteNode(imageNamed: switchImg)
                switchSprite.name = "switch"
                switchSprite.zPosition = 9
                self.addChild(switchSprite)
                switchSprite.isHidden = true

            }
            if !text.isEmpty
            {
                let buttonLabel = SKLabelNode(fontNamed: MainMenu.fontName)
                buttonLabel.fontSize = fgSprite.size.width / CGFloat(fontSizeFactor)
                buttonLabel.text = "\(text)"
                buttonLabel.fontColor = SKColor.init(red: 0.4, green: 0.2, blue: 0, alpha: 1)
                
                buttonLabel.zPosition = 33
                buttonLabel.position.y -= (buttonLabel.fontSize / 3)
                buttonLabel.name = EffectButton.labelName
                self.addChild(buttonLabel)
            }
        }
    }
    
    func doEffect()
    {
        if isBeingPressed
        {
            return
        }

        let duration = 0.1
        guard let fgSprite = fg else
        {
            return
        }
        if isUsingSeparateImageForPressingEffect
        {
            if let pressed = pressedSprite
            {

                fgSprite.run(SKAction.fadeOut(withDuration: duration))
                pressed.run(SKAction.fadeIn(withDuration: duration))
            }
        }
        else
        {
            fgSprite.alpha = 0.85
            fgSprite.setScale(1.075)
        }
        isBeingPressed = true


        
    }
    
    func undoEffect()
    {
        if !isBeingPressed
        {
            return
        }

        let duration = 0.01

        guard let fgSprite = fg else
        {
            return
        }
        if isUsingSeparateImageForPressingEffect
        {
            if let pressed = pressedSprite
            {

                fgSprite.run(SKAction.fadeIn(withDuration: duration))
                pressed.run(SKAction.fadeOut(withDuration: duration))
            }
        }
        else
        {
            fgSprite.alpha = 1
            fgSprite.setScale(1)

        }
        isBeingPressed = false

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        super.touchesBegan(touches, with: event)
        
//        pressedEffect.isHidden = false
        if self.onTouched == nil //if there is no callback, don't make an effect
        {
            return
        }
        else
        {
            SJDirector.shared.sound.runSoundAction(owner: self, soundAction: SKAction.playSoundFileNamed("click", waitForCompletion: false))
            doEffect()
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {


        
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
        undoEffect()
        super.touchesEnded(touches, with: event)
        if self.onTouched == nil //if there is no callback, don't make an effect
        {
            return
        }

        

      
        if let touch = touches.first, let parentNode = self.parent, let callBack = onTouched
        {
            if self.contains(touch.location(in: parentNode))
            {
                callBack()
                switchImgAppearing = !switchImgAppearing
            }
        }
        
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
