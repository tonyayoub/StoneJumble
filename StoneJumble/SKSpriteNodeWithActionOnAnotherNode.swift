//
//  SKSpriteNodeWithAction.swift
//  BurgerInvasion
//
//  Created by Tony Ayoub on 6/28/17.
//  Copyright © 2017 amahy. All rights reserved.
//

import SpriteKit

class SKSpriteNodeWithActionOnAnotherNode: SKSpriteNode
{
    var onTouched:(()->Void)?
    var nodeToPerformActionUpon:SKSpriteNode?
    var actionBeforeTouched:SKAction? //actions performed before executing onTouched
    //like moving the box down before hiding glass
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let performAction = onTouched
        {
            self.isUserInteractionEnabled = false //because touching it twice cause an exception
            performAction()
            // the below was causing an exception and is not very good aslan
//            if let act = actionBeforeTouched, let targetNode = nodeToPerformActionUpon
//            {
//                targetNode.run(act, completion: performAction)
//            }
//            else
//            {
//                performAction()
//            }
        }
    }

}
