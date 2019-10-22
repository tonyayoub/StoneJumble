//
//  Addon.swift
//  BurgerInvasion
//
//  Created by Tony Sameh on 8/3/17.
//  Copyright © 2017 amahy. All rights reserved.
//

import SpriteKit

enum AddonType: String
{
    case carrot // faster
    case tomatoe // destroys ketchuhup
    case water //destroys soda
    case apple //double hit
    case cucumber // destroys fries
    case lemon // destroys mustard
    case banana //smoother
    case avocado // destroys whole burger whaterver the strength
    case pea // destroys all obstacles
}

class Addon: SJSpriteNode
{
    static let Shopping: [Int: (type: AddonType, price: Int)] =
        [
            1: (type: .carrot, price: 200),
            2: (type: .tomatoe, price: 250),
            3: (type: .water, price: 250),
            4: (type: .apple, price: 300),
            5: (type: .banana, price: 500),
            6: (type: .cucumber, price: 500),
            7: (type: .lemon, price: 600),
            8: (type: .avocado, price: 800),
            9: (type: .pea, price: 1000),
        ]
    var giftMask:SJSpriteNode = SJSpriteNode(imageNamed: "gift")
    var addonType:AddonType = .carrot
    var imageName:String = ""
    var soundAction: SKAction?
    private var _lifeTime = 4
    var lifeTime: Int
    {
        get
        {
            return _lifeTime
        }
        set(newValue)
        {
            _lifeTime = newValue
            if _lifeTime <= 0
            {
                self.run(SKAction.fadeOut(withDuration: 2), completion: {self.removeFromParent()})
            }
        }
    }
    var initialScale:Float = 1
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
 
    override class func make(objectSpec: String) -> SJSpriteNode?
    {
        let res = Addon(imageNamed: objectSpec)
        res.imageName = objectSpec
        let resSoundFile: String = objectSpec + ".wav"
        res.soundAction = SKAction.playSoundFileNamed(resSoundFile, waitForCompletion: true)
        if let createdAddonType = AddonType(rawValue: objectSpec)
        {
            res.addonType = createdAddonType
        }
        else
        {
            res.addonType = .carrot
        }

      //  res.createPhysicsBody()

        res.calculateInitialScale()
        res.addChild(res.giftMask)
        res.giftMask.zPosition = 101
        return res
      
    }
    override func createPhysicsBody() {
        var pSize = self.size
        pSize.width *= 0.95
        pSize.height *= 0.95
        //   res.physicsBody = SKPhysicsBody(circleOfRadius: pSize.width/2)
        self.physicsBody = SKPhysicsBody(rectangleOf: pSize)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = SJDirector.addOnCategory

    }

    func playSound()
    {
        if let hitSound = self.soundAction
        {
            SJDirector.shared.sound.runSoundAction(owner: self, soundAction: hitSound)
        }
    }
    func calculateInitialScale()
    {
        var heightPercentage:Float = 1
        var widthPercentage:Float = 1
        if let shooterSize = SJLevelScene.currentLevelScene?._shooter.size
        {
            if self.size.height > shooterSize.height
            {
                heightPercentage = Float(shooterSize.height / self.size.height)
            }

            if self.size.width > shooterSize.width
            {
                widthPercentage = Float(shooterSize.width / self.size.width)
            }
            self.initialScale = (heightPercentage < widthPercentage) ? heightPercentage : widthPercentage
            self.initialScale *= 0.9
        }
    }
    override func gotOneHit(hitter: SJSpriteNode, collisionPoint: CGPoint)
    {
        SJLevelScene.currentLevelScene?._shooter.attachAddon(attachedAddon: self)
        
    }

    
    func emit()
    {
        if lifeTime < 2
        {
            return;
        }
        if let emitter = SKEmitterNode(fileNamed: "addon")
        {
            emitter.position = self.position // check
            emitter.zPosition = 121
            emitter.particleTexture = self.texture
            SJLevelScene.currentLevelScene?._shooter.addChild(emitter)


            let fadeAction = SKAction.fadeOut(withDuration: 0.5)
            let removeAction = SKAction.removeFromParent()
            let fadeThenRemoveAction = SKAction.sequence([fadeAction, removeAction])
            emitter.run(fadeThenRemoveAction)

        }
    }

}
