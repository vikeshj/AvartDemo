

//
//  GenricARObject.swift
//  SFR-Shell
//  eye movement - https://stackoverflow.com/a/51072693
//  Camera fov https://photo.stackexchange.com/questions/76321/is-there-a-difference-between-taking-a-far-shot-on-a-50mm-lens-and-a-close-shot/76335#76335
//  Created by Vikesh JOYPAUL on 20/02/2019.
//  Copyright © 2019 Vikesh JOYPAUL. All rights reserved.
//

import UIKit
import ARKit

class GenericARObject <U:Any>: NSObject, VirtualContentController {
    
    var sceneView: ARSCNView?
    var allowRendering: Bool?
    var contentNode: SCNNode?
    
    var item: U!
    var isNodeMoving: Bool!
    var view: ARSCNView!
    
    
    init(geometry: ARSCNFaceGeometry, item:U, view:ARSCNView) {
        super.init()
        self.item = item
        contentNode?.geometry = geometry
        isNodeMoving = true
        self.view = view
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        return contentNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let content = contentNode else { return }
        
        if(!faceAnchor.isTracked && !isNodeMoving){
            node.isHidden = false
            isNodeMoving = true
            let position = SCNAction.move(to: SCNVector3(0, 0, 0), duration: 0.35)
            let rotation = SCNAction.rotateTo(x:0, y: 0, z: 0, duration: 0.35, usesShortestUnitArc: true)
            let group = SCNAction.group([position,rotation])
            content.runAction(group, completionHandler: {
                self.isNodeMoving = false
            })
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
    }
    
    func fadeOut() {
        let fadeIn = SCNAction.fadeOut(duration: 0.25)
        self.contentNode?.runAction(fadeIn)
    }
    
    func calculateAngleInRadians(from: SCNVector3, to: SCNVector3) -> Float {
        let x = from.x - to.x
        let z = from.z - to.z
        return atan2(z, x)
    }
    
    deinit {
        isNodeMoving = nil
        allowRendering = false
        item = nil
        contentNode = nil
    }
}

