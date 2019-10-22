//
//  ObjectsReactions.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 12/28/16.
//  Copyright © 2016 amahy. All rights reserved.
//

import UIKit

struct ObjectsReactions
{

    //here i'm saying that the current (or initial or default) reaction of burgers are to explode
    var burgerReaction: ReactionProfile = ExplodeReactionProfile()
    var obstacleReaction: ReactionProfile = NoMoveReactionProfile()
    var addonReaction: ReactionProfile = AttachReactionProfile()

}
