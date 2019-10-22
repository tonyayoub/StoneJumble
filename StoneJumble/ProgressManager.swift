//
//  ProgressManager.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 4/10/17.
//  Copyright © 2017 amahy. All rights reserved.
//

import Foundation



class ProgressManager
{
    static let progressFileName = "Progress"


    
    //returns the ach. of levels in the episode in a string "1_2_3_1_2...etc"
    // the key of episode 1 is ach_1
    // episode 2: ach_2 ...etc
    class func getEpisodeAch(episodeID: Int) -> String?
    {
        if let episodeString = PlistManager.sharedInstance.getValueForKey(key: "ach_\(episodeID)") as? String
        {
            return episodeString
        }
        else
        {
            return nil
        }
    }
    
    // takes the episode String as an input, so that we don't have to read from file for every level (while populating the menu)
    // levelID is 1, 2, 3.... not 0, 1, 2
    class func getLevelAchFromEpisodeAchString(levelID: Int, episodeAchString: String) -> Int
    {
        let levelsAchStrings = episodeAchString.components(separatedBy: "_")
        if let levelAch = Int(levelsAchStrings[levelID - 1])
        {
            return levelAch
        }
        else
        {
            return 0
        }
    }
    
    class func updateLevelAch(episodeID: Int, levelID: Int, newAch: Int)
    {
        
    }
    //takes episode ID and returns episode achievement key (e.g. ach_1)
    class func getEpisodeAchKey(episodeID: Int) -> String
    {
        return "ach_\(episodeID)"
    }

    class func test()
    {
        // print("testing progress manager")
     //   let x = getLevelAch(episodeID: 2, levelID: 3)
        
        saveLevelAch(episodeID: 5, levelID: 1, value: 1)
        
    //    let x1 = getLevelAch(episodeID: 5, levelID: 1)
        
    }
    
    class func getEpisodeAch(episodeID: Int) -> [Int]?
    {
        let episodes = PlistManager.sharedInstance.getValueForKey(key: "episodes") as! [NSArray]
        if episodeID > episodes.count
        {
            // print("You are reading episode \(episodeID) while there are only \(episodes.count) episodes in progress file")
            return nil
        }
        let levelsInEpisode = episodes[episodeID - 1]
        
        return levelsInEpisode as? [Int]
        
    }
    class func getLevelAch(episodeID: Int, levelID: Int) -> Int
    {
        let episodes = PlistManager.sharedInstance.getValueForKey(key: "episodes") as! [NSArray]
        if episodeID > episodes.count // should never happen
        {
            // print("You are reading episode \(episodeID) while there are only \(episodes.count) episodes in progress file")
            return 0
        }
        let levelsInEpisode = episodes[episodeID - 1]
        
        if levelID > levelsInEpisode.count // should never happen
        {
            // print("You are reading level \(levelID) while there are only \(levelsInEpisode.count) levels in episode \(episodeID)")
            return 0
        }
        
        if let levelAch = levelsInEpisode[levelID - 1] as? Int
        {
            return levelAch
        }
        else
        {
            return 0 //level not played before
        }
   
    }
    class func addCredit(addedValue: Int)
    {
        let currentCredit = getCredit()
        saveCredit(value: currentCredit + addedValue)
        
    }
    class func saveCredit(value: Int)
    {
        PlistManager.sharedInstance.saveIntValue(value: value, forKey: "credit")
    }
    
    class func getCredit() -> Int
    {
        if let gold = PlistManager.sharedInstance.getValueForKey(key: "credit") as? Int
        {
            return gold
        }
        else
        {
            return 1
        }
    }
    
    class func saveLevelAch(episodeID: Int, levelID: Int, value:Int)
    {
        if let plist = Plist(name: "Progress")
        {
            
            let dict = plist.getMutablePlistFile()!
            guard var episodes = dict["episodes"] as? [NSMutableArray] else
            {
                // print ("cannot find episodes in progress file")
                return
            }
            
            //array or arrays as specified in the .plist file
            
            
            
            if episodeID > episodes.count
            {
                //episodeID should be =  episodes.count
      //          // print("You are saving episode \(episodeID) while there are only \(episodes.count) episodes in progress file. A new value will be added")
                let newEpisode = NSMutableArray()
                newEpisode[levelID - 1] = value //levelID should be 1 so that this is always the first item of the array
                episodes.append(newEpisode)
                dict["episodes"] = episodes
            }
            else //episode ID exists
            {
               let levelsInEpisode = episodes[episodeID - 1] as NSMutableArray
                
                if levelID > levelsInEpisode.count
                {
        //            // print("You are saving level \(levelID) while there are only \(levelsInEpisode.count) levels in episode \(episodeID). A new level will be added")
                    
                }
                levelsInEpisode[levelID - 1] = value
                
            }
         
            do
            {
                try plist.addValuesToPlistFile(dictionary: dict)
            }
            catch
            {
                // print(error)
            }
        }
        else
        {
            // print("[PlistManager] Unable to get Plist")
        }
    }
    
    

}
