//
//  TextureManager.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 1/2/17.
//  Copyright © 2017 amahy. All rights reserved.
//
// singleton     //from: https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/AdoptingCocoaDesignPatterns.html#//apple_ref/doc/uid/TP40014216-CH7-ID6

import SpriteKit

class TextureManager: NSObject
{
    
    static let sharedManager:TextureManager =
    {
        let instance = TextureManager()
        let images = ["burger", "lettuce", "burger2", "top", "bottom"]
        
        for imageName in images
        {
            instance.addTexture(withName: imageName, texture: SKTexture(imageNamed: imageName))
            //not actuall needed because any new image is added if called as per getTexture()
            
        }
        return instance
    }()

    
    
    class var shared: TextureManager
    {
        return sharedManager
    }
    
    private var textures = [String:SKTexture]()
    
    func getTexture(withName name:String)->SKTexture
    {
        if let result = textures[name]
        {
            return result
        }
        else
        {
            addTexture(withName: name, texture: SKTexture(imageNamed: name))
            return textures[name]!
        }
        
    }
    
    func addTexture(withName name:String, texture :SKTexture)
    {
        if textures[name] == nil
        {
            textures[name] = texture
        }
    }
    
    func addTextures(texturesDictionary:[String:SKTexture])
    {
        for (name, texture) in texturesDictionary
        {
            addTexture(withName: name, texture: texture)
        }
    }
    
    func removeTexture(withName name:String)->Bool
    {
        if textures[name] != nil
        {
            textures[name] = nil
            return true
        }
        return false
    }

}
