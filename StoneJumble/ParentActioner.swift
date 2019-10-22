//
//  ParentActioner.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 1/9/17.
//  Copyright © 2017 amahy. All rights reserved.
//

import SpriteKit

protocol ParentActioner: class
{
    var runAfterAllChildrenFinish:(()->Void)? {get set}
    var childrenActioners:[ChildActioner] {get set}
    func onAllChildrenFinish()
}

extension ParentActioner
{
    func runActionOnCollection(actioners:[ChildActioner], afterTheyFinish: @escaping () -> Void)
    {
        childrenActioners.removeAll()
        self.runAfterAllChildrenFinish = afterTheyFinish

        
        if actioners.isEmpty
        {
            if let finishingFunction = self.runAfterAllChildrenFinish
            {
             //   // print("no childrent to run, parent will run")

                finishingFunction()
            }
        }
        self.childrenActioners = actioners

        for c in childrenActioners
        {
            c.parentActioner = self
            c.actionFinished = false
            c.performWantedAction()
        }
        

    }
    
    func callAfterEachChildFinish(finishingChild:ChildActioner)
    {
        // // print("in parent node after one child finished action")
        
        finishingChild.actionFinished = true
        for c in childrenActioners
        {
            
          //  // print(part.drawingOrder)
          //  // print(part.isBeingRemoved)
            if !c.actionFinished // at least one child is still remaining
            {
              //  // print("at least one child did not finish, will return")

                return
            }
        }
        
        //if we reach here, all children finished
        if let finishingFunction = self.runAfterAllChildrenFinish
        {
           // // print("all children finished, parent will run")

            finishingFunction()
        }
    }
    
    

}
