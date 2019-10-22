//
//  ChildActioner.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 1/9/17.
//  Copyright © 2017 amahy. All rights reserved.
//

import SpriteKit

protocol ChildActioner: class
{
    var parentActioner:ParentActioner? {get set}
    var wantedAction: SKAction? {get set}
    var actionFinished:Bool {get set}
}

extension ChildActioner
{
    
    func performWantedAction()
    {
        //// print("performing action on one child node")
        if let selfSKNode = self as? SKNode, let action = self.wantedAction
        {
            
            selfSKNode.run(action, completion: {self.completeAction()})
        }
        
    }
    
    func completeAction()
    {
       // // print("one child finished action")
        self.actionFinished = true
        if let parentActionerNode = parentActioner
        {
            parentActionerNode.callAfterEachChildFinish(finishingChild: self)
        }
    }
}
