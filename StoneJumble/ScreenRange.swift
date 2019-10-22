//
//  ScreenRange.swift
//  BurgerInvasion
//
//  Created by Tony Sameh on 2/4/18.
//  Copyright © 2018 amahy. All rights reserved.
//

import SpriteKit

class ScreenRange: NSObject
{
    //4 x 4 matrix starting from bottom left
    //each character represents 25% x 25% of the screen
    // 16 ones means any place in screen
    // "0000111100000000" means the second row from below ..etc


    
    static var areaIndex = Int(arc4random_uniform(15))
    static func initializeIndex()
    {
        areaIndex = Int(arc4random_uniform(15))
        // print(".................................. \(areaIndex)")
    }
    static func generateRandomLocation(object: SJSpriteNode) -> CGPoint
    {
        var posRangeString = SJLevelCreator.targetsRange //assuming it is a target
        if object is Obstacle
        {
            posRangeString = SJLevelCreator.obstaclesRange
        }
        else if object is Addon
        {
            posRangeString = SJLevelCreator.addonsRange
        }
        if posRangeString.isEmpty
        {
            posRangeString = "1111111111111111"
        }

        var chars = Array(posRangeString)

        while(true)
        {
            let currentChar = chars[areaIndex]

            if currentChar == "0"
            {
                areaIndex += 1
                if areaIndex > 15
                {
                    areaIndex = 0
                }
                continue
            }
            else
            {

                break
            }
        }

        //after exiting this loop, the currentAreaIndex will point to the index of the square that we will generate a random location inside

        guard let parentScene = SJLevelScene.currentLevelScene else
        {
            return CGPoint.zero
        }
        var minX:CGFloat = 0
        var maxX:CGFloat = parentScene.frame.width
        var minY:CGFloat = 0
        if let bottomNode = parentScene.container.childNode(withName: "bottom") as? SKSpriteNode
        {
            minY = bottomNode.position.y + bottomNode.size.height
        }

        var maxY = parentScene.frame.height - 50

        let usedHeight = maxY - minY
        let usedWidth = maxX - minX


        let i = areaIndex

        if 0...3 ~= i
        {
            maxY -= (CGFloat(0.75) * usedHeight)
        }
        else if 4...7 ~= i
        {
            minY += (CGFloat(0.25) * usedHeight)
            maxY -= (CGFloat(0.5) * usedHeight)
        }
        else if 8...11 ~= i
        {
            minY += (CGFloat(0.5) * usedHeight)
            maxY -= (CGFloat(0.25) * usedHeight)
        }
        else if 12...15 ~= i
        {
            minY += (CGFloat(0.75) * usedHeight)
        }



        if i%4 == 0 //first column
        {
            maxX -= (CGFloat(0.75) * usedWidth)
        }
        else if i%4 == 1
        {
            minX += (CGFloat(0.25) * usedWidth)
            maxX -= (CGFloat(0.5) * usedWidth)
        }
        else if i%4 == 2
        {
            minX += (CGFloat(0.5) * usedWidth)
            maxX -= (CGFloat(0.25) * usedWidth)
        }
        else if i%4 == 3
        {
            minX += (CGFloat(0.75) * usedWidth)
        }



        let minX4ThisTarget = minX + object.totalSize.width / 2
        let maxX4ThisTarget = maxX - object.totalSize.width / 2
        let minY4ThisTarget = minY + object.totalSize.height / 2
        let maxY4ThisTarget = maxY - object.totalSize.height / 2
        let randomX = CGFloat(arc4random_uniform(UInt32(maxX4ThisTarget - minX4ThisTarget))) + minX4ThisTarget
        let randomY = CGFloat(arc4random_uniform(UInt32(maxY4ThisTarget - minY4ThisTarget))) + minY4ThisTarget
        areaIndex += 1
        if areaIndex > 15
        {
           areaIndex = 0
        }
        return CGPoint(x: randomX, y: randomY)
    }
}
