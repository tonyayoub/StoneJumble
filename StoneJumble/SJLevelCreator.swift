//
//  SJLevelCreator.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 11/7/15.
//  Copyright © 2015 amahy. All rights reserved.
//

import UIKit

class SJLevelCreator: NSObject
{
   
    let colorNames2 = ["burger"] //just in case we have anything other than burger
    let obstacleNames = ["spoon", "fork", "knife"]
    static var _targets = [Burger]()
    static var _obstacles = [Obstacle]()
    static var _addons = [Addon]()
    static let fixedLevelMessage = "Burgers are invading our space. Get them down"
    static var levelMessage:String = fixedLevelMessage
    static var images = "empty,empty,empty,empty,empty,empty,empty,empty,empty"
    static var targetsRange = "1111111111111111"
    static var obstaclesRange = "1111111111111111"
    static var addonsRange = "1111111111111111"
    
    class func createObjects() -> Bool
    {
        _targets = [Burger]()
        _obstacles = [Obstacle]()
        _addons = [Addon]()
        do
        {
            try parseLevelData()
            return true;
        }
        catch _
        {
            //NPDirector.terminateMessage()
            return false;
        }
    }
    
    enum ParsingError: Error
    {
        case levelDataFormatError
    }

    class func parseLevelData() throws
    {
        
        let episodeID = NPDirector.shared.currentEpisodeID - 1
        let levelID = NPDirector.shared.currentLevelID - 1
        
        
        let config = NSDictionary(contentsOfFile:Bundle.main.path(forResource: "Levels", ofType: "plist")!)!
        
        
        guard let episodes = config["episodes"] as? [NSDictionary]
        else
        {
            throw ParsingError.levelDataFormatError
        }
        if episodeID >= episodes.count
        {
            throw ParsingError.levelDataFormatError
        }
        let currentEpisodeData = episodes[episodeID]
        
        guard let levels = currentEpisodeData["levels"] as? [NSDictionary] else
        {
            throw ParsingError.levelDataFormatError
        }
        if levels.count <= levelID
        {
            throw ParsingError.levelDataFormatError
        }
        let currentLevelData = levels[levelID]
        
        SJDirector.shared._hitsRemaining = currentLevelData["hits"] as! Int
        
        //level start message
        if let parsedLevelMessage = currentLevelData["message"] as? String
        {
            levelMessage = parsedLevelMessage
        }
        else
        {
            levelMessage = fixedLevelMessage
        }

        //level start images
        if let parsedStartImages = currentLevelData["images"] as? String
        {
            images = parsedStartImages
        }
        else
        {
            images = "empty"
        }


        
        //targets and obstacles ranges
        if let parsedTargetsRange = currentLevelData["targetsRange"] as? String
        {
            targetsRange = parsedTargetsRange
        }
        else
        {
            targetsRange = "1111111111111111"
        }
        
        if let parsedObstaclesRange = currentLevelData["obstaclesRange"] as? String
        {
            obstaclesRange = parsedObstaclesRange
        }
        else
        {
            obstaclesRange = "1111111111111111"
        }
        
        if let parsedAddonsRange = currentLevelData["addonsRange"] as? String
        {
            addonsRange = parsedAddonsRange
        }
        else
        {
            addonsRange = "1111111111111111"
        }

        if let parsedTime = currentLevelData["time"] as? Bool
        {
            SJDirector.shared.isTimeLevel = parsedTime
        }

        if let targetsString = currentLevelData["targets"] as? String
        {
            createObjects("targets", parsedValues: targetsString)

        }
        
        if let obstaclesString = currentLevelData["obstacles"] as? String
        {
            createObjects("obstacles", parsedValues: obstaclesString)
        }
        
        if let addonsString = currentLevelData["addons"] as? String
        {
            createObjects("addons", parsedValues: addonsString)
        }
  //`      let addonsString = currentLevelData["addons"] as! String
        
      //  createObjects("addons", parsedValues: addonsString)
    }
    
    class func createObjects(_ type: String, parsedValues: String)
    {

        if parsedValues.isEmpty
        {
            return
        }
        let objectsSubStrings = parsedValues.components(separatedBy: ",") // [targets: 1:1,2:5,3:10] ... [obstacles: fries:3,soda:5]
        for oneObjectString in objectsSubStrings
        {
            let oneObjectSubStrings = oneObjectString.components(separatedBy: ":")
            if oneObjectSubStrings.count < 2
            {
                continue
            }
            let oneObjectParsedType:String? = oneObjectSubStrings[0] //strength in the case of burger and type in the case of obstacle
            let oneObjectParsedCount:Int? = Int(oneObjectSubStrings[1])
            
            
            if let oneObjectType = oneObjectParsedType, let oneObjectCount = oneObjectParsedCount
            {
                if oneObjectCount < 1
                {
                    break;
                }
                for _ in 1...oneObjectCount
                {
                    if type == "targets"
                    {
                        if let createdObject = Burger.make(objectSpec: oneObjectType) as? Burger
                        {
                            _targets.append(createdObject)
                            
                        }
                    }
                    else if type == "obstacles"
                    {
                        if let createdObject = Obstacle.make(objectSpec: oneObjectType) as? Obstacle
                        {
                            _obstacles.append(createdObject)
                            
                        }
                    }
                    else if type == "addons"
                    {
                        if let createdAddon = Addon.make(objectSpec: oneObjectType) as? Addon
                        {
                            _addons.append(createdAddon)
                        }
                    }
                    
                }
            }
        }
    }
   
    
   

}
