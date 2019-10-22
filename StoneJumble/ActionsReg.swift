//
//  ActionsReg.swift
//  BurgerInvasion
//
//  Created by Tony Ayoub on 7/2/17.
//  Copyright © 2017 amahy. All rights reserved.
//

import UIKit

class ActionsReg: NSObject
{
    typealias FutureAction = ()->Void
    var futureActions = [Int: [FutureAction]]()
    
    func insertAction(insertedAction: @escaping FutureAction, numberOfHitsBeforeRunning: Int)
    {
        let remainingHits = SJDirector.shared._hitsRemaining
        let hitsNumberToPerformAction = remainingHits - numberOfHitsBeforeRunning
        
        if var existingListForThisHitsNumber = futureActions[hitsNumberToPerformAction]
        {
            existingListForThisHitsNumber.append(insertedAction)
        }
        else
        {
            var newListForThisHitsNumber = [FutureAction]()
            newListForThisHitsNumber.append(insertedAction)
            futureActions[hitsNumberToPerformAction] = newListForThisHitsNumber
        }
    }
    
    func checkActions()
    {
        let remainingHits = SJDirector.shared._hitsRemaining
        if let listForThisHitsNumber = futureActions[remainingHits]
        {
            for act in listForThisHitsNumber
            {
                act()
            }
        }

    }
    
    

}
