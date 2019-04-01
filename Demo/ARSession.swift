//
//  ARSession.swift
//  SFR-Shell
//
//  Created by Vikesh JOYPAUL on 08/02/2019.
//  Copyright © 2019 Vikesh JOYPAUL. All rights reserved.
//

import SceneKit
import ARKit

extension ARSession {
    func run() {
        let configuration = ARFaceTrackingConfiguration()
        configuration.worldAlignment = .gravity
        configuration.providesAudioData = true
        configuration.isLightEstimationEnabled = true
        run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func runWithNoOptions(){
        let configuration = ARFaceTrackingConfiguration()
        configuration.worldAlignment = .gravity
        configuration.providesAudioData = true
        configuration.isLightEstimationEnabled = true
        run(configuration, options: [])
    }
}
