//
//  Fries.swift
//  BurgerInvasion
//
//  Created by Tony Ayoub on 7/2/17.
//  Copyright © 2017 amahy. All rights reserved.
//

import SpriteKit

class Fries: Obstacle
{
    static var oneFriesIsBeingAdded = false
    override func doActionsAfterHit(hitter: SJSpriteNode, hittingPoint: CGPoint)
    {
        if destroyerAttachedToShooter() ||  Fries.oneFriesIsBeingAdded
        {
            return
        }

        
        
        addAnotherFries()

        self.run(SKAction.wait(forDuration: 1), completion: {self.isBeingHit = false})
        SJLevelScene.currentLevelScene?.delayedActions.insertAction(insertedAction: SJDirector.friesEnd, numberOfHitsBeforeRunning: 3)
    }
    override func destroyerList() -> [AddonType]
    {
        return [AddonType.cucumber, AddonType.pea]
    }
    func addAnotherFries()
    {
        guard let container = SJLevelScene.currentLevelScene?.container else
        {
            return
        }
        guard let newFries = Obstacle.make(objectSpec: "fries")  as? Fries else
        {
            return
        }
        SJLevelCreator.obstaclesRange = "1111111111111111" // so that the new fries is placed anyhwere
        var numberOfTrials = 0
        while (true)
        {
            numberOfTrials += 1
            var intersectingPreviousNode = false

            newFries.initialPosition = ScreenRange.generateRandomLocation(object: self)
            let dummyNode = SKSpriteNode(color: UIColor.clear, size: newFries.totalSize)
            dummyNode.position = newFries.initialPosition
            
            container.addChild(dummyNode)
            
            for child in container.children
            {
                if let objectChild = child as? SJSpriteNode
                {
                    if objectChild.intersects(dummyNode)
                    {
                        intersectingPreviousNode = true
                        break
                    }
                }
            }
            
            if !intersectingPreviousNode // we found an empty place
            {
                Fries.oneFriesIsBeingAdded = true
                if let parent = self.parent
                {
                    parent.run(SKAction.wait(forDuration: 3), completion: {Fries.oneFriesIsBeingAdded = false})
                    //so that we make sure the flag is set to false again
                    //previously, newFries (below) was repsonsible for this but when it gets destroyed while still being fadin in
                    // this flag never becomes false again
                }
                newFries.position = newFries.initialPosition
                container.addChild(newFries)
                
                newFries.zPosition = 99
                newFries.alpha = 0
                dummyNode.removeFromParent()
                newFries.run(SKAction.fadeAlpha(to: 1, duration: 3))
                SJDirector.shared.sound.playLevelSound(sound: .friesDouble)
                showEmitter(emitterFile: "fries", position: newFries.position, lifetime: 4)
                return
            }
            else if numberOfTrials > 9 // no place found after 9 trials, don't add this target
            {
                dummyNode.removeFromParent()
                break
            }
            else // no place found but we will search again
            {
                dummyNode.removeFromParent()
            }
        }
    }
}
