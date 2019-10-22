//
//  Math.swift
//  StoneJumble
//
//  Created by Tony Ayoub on 12/15/14.
//  Copyright (c) 2014 amahy. All rights reserved.
//

import CoreGraphics

func stepForward(_ input: Int, output: CGPoint)-> Int
{
    return input + 1
}

func pSub(_ p1: CGPoint, p2: CGPoint) ->CGVector
{
    return CGVector(dx: p1.x - p2.x, dy: p1.y - p2.y)
}

func vectorNorm(_ v: CGVector) -> CGFloat
{
    
    return sqrt(pow(v.dx, 2) + pow(v.dy, 2))
}

func unitVector(_ v: CGVector) -> CGVector
{
    let norm = vectorNorm(v)
    return CGVector(dx: (v.dx)/norm, dy: (v.dy)/norm)
}

func multiplyVector(_ vector: CGVector, value: CGFloat) -> CGVector
{
    return CGVector(dx: vector.dx * value, dy: vector.dy * value)
}

func rotateVector(vector: CGVector, angle: CGFloat) -> CGVector
{
    let xCosAlpha = vector.dx * cos(angle)
    let ySinAlpha = vector.dy * sin(angle)
    let xSinAlpha = vector.dx * sin(angle)
    let yCosAlpha = vector.dy * cos(angle)

    return CGVector(dx: xCosAlpha - ySinAlpha, dy: xSinAlpha + yCosAlpha)
}



func distanceBetweenTwoPoints(_ p1: CGPoint, p2: CGPoint) -> CGFloat
{
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
}
/*static inline CGVector pSub(const CGPoint p1, const CGPoint p2)
{
    return CGVectorMake(p1.x - p2.x, p1.y - p2.y);
}*/
