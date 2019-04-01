//
//  BlenshapesMap.swift
//  SFR-Shell
//
//  Created by Vikesh JOYPAUL on 07/03/2019.
//  Copyright © 2019 Vikesh JOYPAUL. All rights reserved.
//

import ARKit

enum BlendShapesMap:String, CustomStringConvertible, CaseIterable  {
    
    case eyeBlink_L,
        mouthDimple_L,
        mouthPress_R,
        jawLeft,
        mouthShrugLower,
        mouthFrown_R,
        mouthShrugUpper,
        eyeLookUp_L,
        mouthSmile_R,
        mouthPress_L,
        eyeSquint_L,
        browDown_R,
        mouthUpperUp_L,
        mouthDimple_R,
        mouthRight,
        browOuterUp_L,
        browOuterUp_R,
        mouthFunnel,
        eyeLookOut_R,
        mouthSmile_L,
        browInnerUp,
        eyeWide_L,
        mouthRollLower,
        eyeLookOut_L,
        cheekSquint_R,
        mouthClose,
        eyeBlink_R,
        jawRight,
        mouthPucker,
        jawOpen,
        mouthStretch_L,
        eyeLookDown_R,
        mouthRollUpper,
        mouthLeft,
        eyeLookUp_R,
        mouthUpperUp_R,
        mouthLowerDown_R,
        eyeWide_R,
        cheekSquint_L,
        eyeLookDown_L,
        noseSneer_L,
        tongueOut,
        cheekPuff,
        browDown_L,
        eyeLookIn_R,
        mouthStretch_R,
        mouthLowerDown_L,
        eyeLookIn_L,
        eyeSquint_R,
        noseSneer_R,
        mouthFrown_L,
        jawForward
    
    
    //return raw value
    public var description: String {
        let blend = map(self.rawValue)
        return blend
    }
    
    private func map(_ value: String)->String {
        if(value.contains(find: "_L")){ return value.replace(target: "_L", words: "LeftMesh") }
        if(value.contains(find: "_R")){ return value.replace(target: "_R", words: "RightMesh") }
        return "\(value)Mesh"
    }
    
}
