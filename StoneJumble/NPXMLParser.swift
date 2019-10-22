//
//  NPXMLParser.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 11/7/15.
//  Copyright © 2015 amahy. All rights reserved.
//

import UIKit

class NPXMLParser: NSObject, XMLParserDelegate
{
    
    
    override init()
    {
        
    }
    func clear() ->Void
    {
        SJDirector.shared.currentLevelModel.targets.removeAll(keepingCapacity: false)
        
    }
    func parseXMLFile(_ pathToFile: String) ->Void
    {
        clear()
        /*NSString* path = [[NSBundle mainBundle] pathForResource:@"test"
        ofType:@"txt"];*/
        let path = Bundle.main.path(forResource: pathToFile, ofType: "xml")
        var success: Bool
        let xmlURL = URL(fileURLWithPath: path!)
        let addressParser = XMLParser(contentsOf: xmlURL)!
        addressParser.delegate = self
        addressParser.shouldResolveExternalEntities = true
        success = addressParser.parse()
        if success
        {
            for _ in SJDirector.shared.currentLevelModel.targets
            {
                
            }
        }
        // SJDirector.shared.levelScene.data = currentLevelModel
        
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {

        if (elementName == "shooter")
        {
            
            SJDirector.shared.currentLevelModel.shooter = SJObjectModel()
            if let parsedID = attributeDict["id"] //we put the type String so that NSString is cased to String to be able to use toInt
            {
                SJDirector.shared.currentLevelModel.shooter.id = Int(parsedID)
                
                let parsedX:NSString? = attributeDict["x"] as NSString? // parsedX cannot be String because floatValue is member of NSString not String
                SJDirector.shared.currentLevelModel.shooter.x = CGFloat(parsedX!.floatValue)
            }
            
        }
        else if(elementName == "targets")
        {
            
            
        }
        else if(elementName == "target")
        {
            let parsedTarget = SJObjectModel()
            if let targetIDString = attributeDict["id"]
            {
                let targetID = Int(targetIDString)
                parsedTarget.id = targetID
                
                SJDirector.shared.currentLevelModel.targets.append(parsedTarget)
            }
            //add target objects one by one to targest array
        }
        
    }
    func parser2(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [AnyHashable: Any])
    {
        //        println("didStartElement")
        if (elementName == "shooter")
        {
            
            SJDirector.shared.currentLevelModel.shooter = SJObjectModel()
            if let parsedID = attributeDict["id"] as? String //we put the type String so that NSString is cased to String to be able to use toInt
            {
                SJDirector.shared.currentLevelModel.shooter.id = Int(parsedID)
                
                let parsedX = attributeDict["x"] as! NSString // parsedX cannot be String because floatValue is member of NSString not String
                SJDirector.shared.currentLevelModel.shooter.x = CGFloat(parsedX.floatValue)
                
                let parsedY = attributeDict["y"] as! NSString
                SJDirector.shared.currentLevelModel.shooter.y = CGFloat(parsedY.floatValue)
            }
            
        }
        else if(elementName == "targets")
        {
            
            
        }
        else if(elementName == "target")
        {
            let parsedTarget = SJObjectModel()
            parsedTarget.id = Int((attributeDict["id"] as? String)!)
            
            SJDirector.shared.currentLevelModel.targets.append(parsedTarget)
            //add target objects one by one to targest array
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        //    println(string)
        return
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        //  println("didEndElement")
    }
    
    
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error)
    {
        print(parseError)
        
    }
    
}
