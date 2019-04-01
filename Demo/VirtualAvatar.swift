//
//  JulienAvatar.swift
//  Animoji-01
//  https://stackoverflow.com/questions/52004941/arkit-animation-scnnode
//  Created by Vikesh JOYPAUL on 08/02/2019.
//  Copyright © 2019 Vikesh JOYPAUL. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class VirtualAvatar: GenericARObject<Avatar> {
    
    private lazy var puppetNode = contentNode?.childNode(withName: "puppet", recursively: true)
    private var cameraNode:SCNNode?
    private var nodesLists:[SCNNode:String]!
    private var blendshapeKey: String = "eyeBlinkLeftMesh"
    private var orthographic: String = "OrthograhicCamera"
    private var defaultCamera: String = "defaultCamera"
    
    override init(geometry: ARSCNFaceGeometry, item:Avatar, view: ARSCNView) {
        super.init(geometry: geometry, item: item, view: view)
        contentNode = loadedContentForAsset(named: "Sammy", type: "scn")
        contentNode?.scale = SCNVector3(0.09, 0.09, 0.09)
       
        // camera is set to userOrthographic
        cameraNode = contentNode?.childNode(withName: orthographic, recursively: true)
        view.pointOfView = cameraNode
        
        guard let children = puppetNode?.childNodes else { return }
        nodesLists = [:]
        children.forEach { (node) in
            guard let name = getMorphNameslists(node).first?.name,
                let range = name.range(of: blendshapeKey) else { return }
            let geoName = name[..<range.lowerBound]
            nodesLists[node] = String(geoName)
           if(node.name == "\(item.name.uppercased())_HEAD") { node.geometry?.subdivisionLevel = 10 }
        }
        
        //set morphs to normal
        nodesLists.forEach { (key: SCNNode, value: String) in
            unifiesNormals(key)
        }

        self.allowRendering = true
    }
    
    override func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else { return nil }
        return contentNode
    }
    
    override func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        super.renderer(renderer, didUpdate: node, for: anchor)
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
       
        let blendShapes = faceAnchor.blendShapes
        guard let rendering = allowRendering else { return }
        if(rendering) {
            
           
            puppetNode?.rotation = node.presentation.rotation
            
            
            let _ = blendShapes.reduce("", {
                result, input in
                guard let shape = BlendShapesMap(rawValue: input.key.rawValue), let list = nodesLists else { return "" }
                list.forEach({ (node: SCNNode, value: String) in
                    /// tongue is availble as from
                    let target = "\(value)\(shape.description)"
                    let range =  minMax(input.value.floatValue) //CGFloat((input.value.floatValue * 1000).rounded() / 1000)
                    guard let morph = node.morpher else { return }
                    //range = (range.unsafelyUnwrapped * 100).rounded() / 100
                    if node.name == "tongue"  {
                        guard #available(iOS 12.0, *) else { return }
                        morph.setWeight(range,forTargetNamed: target)
                    } else {
                        morph.setWeight(range,forTargetNamed: target)
                    }
                })
                return result
            })
            
            if(!faceAnchor.isTracked && rendering){
                node.isHidden = false
                //guard let list = nodesLists else { return  }
                //resetMorphs(list)
            }
        }
    }
    
    func minMax(_ newValue: Float, minimum: Float = 0.0, maximum: Float = 1.0) -> CGFloat {
        let _2dp = ((newValue * 1000).rounded(.toNearestOrAwayFromZero) / 1000)
        return CGFloat(min(maximum, max(minimum, _2dp)))
    }
    
    
    /// unifies all morphers
    func unifiesNormals(_ node: SCNNode){
        let morpher = SCNMorpher()
        let morphs = getMorphNameslists(node)
        morpher.targets = morphs
        morpher.unifiesNormals = true
        node.morpher = morpher
    }
    
    func resetMorphs(_ list: [SCNNode: String]){
        list.forEach { (node, value) in
            let nodelist = getMorphNameslists(node)
            for (_, geometry) in nodelist.enumerated() {
                guard let target = geometry.name else { return }
                if(node.name == "tongue") {
                    guard #available(iOS 12.0, *) else { return }
                    node.morpher?.setWeight(0.0, forTargetNamed: target)
                } else {
                    node.morpher?.setWeight(0.0, forTargetNamed: target)
                }
            }
        }
    }
    
    func getMorphNameslists(_ node: SCNNode)-> [SCNGeometry] {
        return  node.morpher.flatMap({ return $0.targets }) ?? []
    }
    
    deinit {
        puppetNode = nil
        contentNode = nil
        allowRendering = false
        nodesLists = [:]
    }
    
}


