//
//  SJEnums.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 11/8/15.
//  Copyright © 2015 amahy. All rights reserved.
//

import Foundation




enum TargetStatus
{
    case initial // Inside the bubble
    case movingToInitialPosition2 //
    case readyToFire
    case firing // firing
    case ready // ready to be hit
}
enum LevelStatus
{
    case start
    case showingAdAtStart
    case showingAdAtRepeat
    case showingStartMessage
    case readyToPlaceObjects
    case checkingTargetsPlaced
    case animatingTargets //firing
    case puttingObstacles
    case puttingAddons
    case playing // ready for user interaction
    case checkingLoss
    case gameEnded
  //  case shooting // shooter is moving
}


