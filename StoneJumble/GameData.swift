//
//  GameData.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 1/28/17.
//  Copyright © 2017 amahy. All rights reserved.
//

import Foundation
class GameData
{
    //keys names:
    static let progressFileName = "Progress"
    static let maxEpisodeKey = "maxEpisode"
    static let maxLevelKey = "maxLevel"
    static let numberOfLevelsPerEpisode:Int = 9
    static let numberOfEpisodes:Int = 11
    
    static let shared: GameData =
        {
            let instance = GameData()
            GameData.preparePlistForUse("Progress")
          //  GameData.testWriteProgress()
          //  instance.loadCurrentProgress()
            
            return instance
        }()
    
    
    //TODO: do we need maxProgress variable or better read/write to Plist directly?
    
    var maxProgress:(episode: Int, level: Int) {
        get {
            if let maxEpisode = PlistManager.sharedInstance.getValueForKey(key: GameData.maxEpisodeKey) as! Int?, let maxLevel = PlistManager.sharedInstance.getValueForKey(key: GameData.maxLevelKey) as! Int? {
                return (episode: maxEpisode, level: maxLevel)
            }
            else {
                return (episode: 1, level: 1)
            }
        }
        set {
            PlistManager.sharedInstance.saveIntValue(value: newValue.episode, forKey: GameData.maxEpisodeKey)
            PlistManager.sharedInstance.saveIntValue(value: newValue.level, forKey: GameData.maxLevelKey)
        }
    }
    
    class func calculateNextProgress(episode: Int, level: Int) -> (newEpisode: Int, newLevel: Int)
    {
        var newEpisode = episode
        var newLevel = level
        
        if level < numberOfLevelsPerEpisode
        {
            newLevel += 1
        }
        else // new episode
        {
            newLevel = 1
            newEpisode += 1
        }
        
        return (newEpisode, newLevel)
        
    }
    class func incrementMaxProgress()
    {
        let currentlyPlayedLevel = NPDirector.shared.currentLevelID
        let currentlyPlayedEpisode = NPDirector.shared.currentEpisodeID
        
        let currentProgress = shared.maxProgress
        var currentMaxAllowedLevel = currentProgress.level
        var currentMaxAllowedEpisode = currentProgress.episode
        
        if !(currentlyPlayedLevel == currentMaxAllowedLevel &&
            currentlyPlayedEpisode == currentMaxAllowedEpisode)
        {
            //he is playing an old level
            return;
        }
        if currentMaxAllowedLevel < numberOfLevelsPerEpisode
        {
            currentMaxAllowedLevel += 1
        }
        else // new episode
        {
            currentMaxAllowedLevel = 1
            currentMaxAllowedEpisode += 1
        }
        
        shared.maxProgress = (episode: currentMaxAllowedEpisode, level: currentMaxAllowedLevel)

    }

    
    
    class func saveLevelProgress(episode: Int, level: Int, progress: Int)
    {
        let actualEpisode = episode - 1
        let actualLevel = level - 1
        var newEpisodesArray = [[Int]]()
        if let x = PlistManager.sharedInstance.getValueForKey(key: "episodes")
        {
            newEpisodesArray = x as! [[Int]]
            
            
            if let x1 = x.object(forKey: actualEpisode) as? [Int]
            {
                
                let _ = x1[actualLevel]
                // print(x11)
                
            }
            newEpisodesArray[0][0] = 3

        }
        if let plist = Plist(name: "Progress")
        {
            
            let dict = plist.getMutablePlistFile()!
            
            if let dictValue = dict["episodes"]
            {
                
                if type(of: newEpisodesArray) != type(of: dictValue)
                {
                    // print("[PlistManager] WARNING: You are saving a \(type(of: newEpisodesArray)) typed value into a \(type(of: dictValue)) typed value. Best practice is to save Int values to Int fields, String values to String fields etc. (For example: '_NSContiguousString' to '__NSCFString' is ok too; they are both String types) If you believe that this mismatch in the types of the values is ok and will not break your code than disregard this message.")
                }
                
                dict["episodes"] = newEpisodesArray
                
            }
            
            do {
                try plist.addValuesToPlistFile(dictionary: dict)
            } catch {
                // print(error)
            }
            // print("[PlistManager] An Action has been performed. You can check if it went ok by taking a look at the current content of the plist file: ")
            // print("[PlistManager] \(String(describing: plist.getValuesInPlistFile()))")
        } else {
            // print("[PlistManager] Unable to get Plist")
        }

  
    }
    
    class func resetProgress()
    {
        //Display confirmation
        let pathInBundle = GameData.getPlistFilePathInBundleDirectory(fileName: GameData.progressFileName)
        let pathInDocuments = GameData.getPlistFilePathInDocumentDirectory(fileName: GameData.progressFileName)
        do
        {
            try FileManager.default.removeItem(atPath: pathInDocuments)

        }
        catch
        {
            // print("Error occurred while deleting file from documents \(error)")
        }
        do
        {
            try FileManager.default.copyItem(atPath: pathInBundle!, toPath: pathInDocuments)
        }
        catch
        {
            // print("Error occurred while copying file to document \(error)")
        }
        NPDirector.shared.currentEpisodeID = 1
       // GameData.preparePlistForUse("Progress")
        
        
    }
    
    
    class func loadCurrentProgress()
    {
        let bundleConfig = NSDictionary(contentsOfFile:
            Bundle.main.path(forResource: GameData.progressFileName, ofType: "plist")!)!
        
        
        if let maxEpisode = bundleConfig[GameData.maxEpisodeKey] as? Int
        {
            print("max episode loaded from bundle: \(maxEpisode)")
        }
        
        if let maxLevel = bundleConfig[GameData.maxLevelKey] as? Int
        {
            print("max level loaded from bundle: \(maxLevel)")
        }
        
        let docConfig = NSDictionary(contentsOfFile:GameData.getPlistFilePathInDocumentDirectory(fileName: GameData.progressFileName))!
        
        
        if let maxDocEpisode = docConfig[GameData.maxEpisodeKey] as? Int
        {
            print("max episode loaded from doc: \(maxDocEpisode)")
        }
        
        if let maxDocLevel = bundleConfig[GameData.maxLevelKey] as? Int
        {
            print("max level loaded from doc: \(maxDocLevel)")
        }
    }
  /*  class func testWriteProgress()
    {
        GameData.preparePlistForUse("Progress")
        let path = getPlistFilePathInDocumentDirectory(fileName: GameData.progressFileName)
        let config = NSMutableDictionary(contentsOfFile:path)!
        _ = config[GameData.maxEpisodeKey] as! Int
        config.setValue(13, forKey: GameData.maxEpisodeKey)
        
        let config11 = NSMutableDictionary(contentsOfFile:path)!
        _ = config11[GameData.maxEpisodeKey] as! Int
        
        config.write(toFile: path, atomically: true)
        let config2 = NSMutableDictionary(contentsOfFile:path)!
        _ = config2[GameData.maxEpisodeKey] as! Int
        
    }*/
    

    
    class func getPlistFilePathInDocumentDirectory(fileName: String) -> String
    {
        // 1
        let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        // 2
        return rootPath + "/\(fileName).plist"
    }
    
    class func getPlistFilePathInBundleDirectory(fileName: String) -> String?
    {
        return Bundle.main.path(forResource: "\(fileName)", ofType: "plist") as String?
    }
    
    class func preparePlistForUse(_ plistName: String)
    {
        
        
        // 1
        let rootPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, .userDomainMask, true)[0]
        // 2
        let plistPathInDocument = rootPath + "/\(plistName).plist"
        if !FileManager.default.fileExists(atPath: plistPathInDocument)
        {
            //if file does not exist in the user document dir (opening the game for the first time), copy it from the bundle
            
            let plistPathInBundle = Bundle.main.path(forResource: "\(plistName)", ofType: "plist") as String?
            // 3
            do
            {
                try FileManager.default.copyItem(atPath: plistPathInBundle!, toPath: plistPathInDocument)
            }
            catch
            {
                // print("Error occurred while copying file to document \(error)")
            }
        }
        else
        {
            // print("progress file exists in document directory")
        }
    }
}
