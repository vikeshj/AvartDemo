//
//  ViewController.swift
//  Demo
//
//  Created by Vikesh JOYPAUL on 01/04/2019.
//  Copyright © 2019 Vikesh JOYPAUL. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    // MARK: - Components
    weak var sceneView: ARSCNView! = {
        let s = ARSCNView()
        s.contentMode =  UIView.ContentMode.scaleAspectFit
        s.backgroundColor = .white
        s.automaticallyUpdatesLighting = false
        s.autoenablesDefaultLighting = true
        s.showsStatistics = true
        s.antialiasingMode = .multisampling4X
        s.contentMode = UIView.ContentMode.scaleAspectFit
        s.translatesAutoresizingMaskIntoConstraints = false
        s.rendersContinuously = true
        return s
    }()
    
    var recorder:RecordAR?
    
    var session: ARSession { return sceneView.session }
    
    var button:UIButton! = {
       let b = UIButton(frame: .zero)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "record"), for: .normal)
      return b
    }()
    
    var avatar: VirtualAvatar?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(sceneView)
        sceneView.scene.background.contents = UIColor.green
        
        NSLayoutConstraint.activate([
            sceneView.widthAnchor.constraint(equalTo: view.widthAnchor),
            sceneView.heightAnchor.constraint(equalTo: view.heightAnchor)
            ])
       
        sceneView.delegate = self
        session.delegate = self
        
        
        recorder = RecordAR(ARSceneKit: sceneView)
        recorder?.delegate = self
        recorder?.renderAR = self
        recorder?.enableAudio = true
        recorder?.fps = ARVideoFrameRate.fps60
        recorder?.videoOrientation = .alwaysPortrait
        recorder?.onlyRenderWhileRecording = false
        recorder?.enableAdjustEnvironmentLighting = true
        recorder?.contentMode = .aspectFill
        recorder?.deleteCacheWhenExported = true
        recorder?.inputViewOrientations = [.portrait]
       
        
        
         guard let device = MTLCreateSystemDefaultDevice(),
            let faceGeometry =  ARSCNFaceGeometry(device: device, fillMesh: false) else { return  }
        avatar = VirtualAvatar(geometry: faceGeometry, item: data()[0], view: sceneView)
       
        
        view.addSubview(button)
        button.addTarget(self, action: #selector(startRecording), for: .touchUpInside)
        
        
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 120),
            button.heightAnchor.constraint(equalToConstant: 120),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60)
            ])
        
    }
    
    @objc func startRecording(){
        guard let recorder = recorder else { return}
        let status = recorder.status
        if status == .readyToRecord {
            recorder.record()
            print("recording")
        } else if status == .recording {
            recorder.stopAndExport({ (url, status, bool) in
                print(url)
            })
            print("stop")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        session.run()
        recorder?.prepare(session.configuration)
    }
    

}

extension ViewController: ARSCNViewDelegate, ARSessionDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor, let avatar = avatar else { return }
        if(node.childNodes.isEmpty) {
            guard let contentNode = avatar.renderer(renderer, nodeFor: faceAnchor) else { return }
            node.addChildNode(contentNode)
           
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let avatar = avatar else { return }
        avatar.renderer(renderer, didUpdate: node, for: anchor)
    }
    
}

extension ViewController:RenderARDelegate, RecordARDelegate {
    
    func frame(didRender buffer: CVPixelBuffer, with time: CMTime, using rawBuffer: CVPixelBuffer) {
        
    }
    
    func recorder(didEndRecording path: URL, with noError: Bool) {
        if(noError){
            
        }
        
    }
    
    func recorder(didFailRecording error: Error?, and status: String) {
        
    }
    
    func recorder(willEnterBackground status: RecordARStatus) {
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        print("sessionWasInterrupted")
    }
    
    
    func sessionInterruptionEnded(_ session: ARSession) {
         print("sessionInterruptionEnded")
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
         print("\(error.localizedDescription)")
    }
}

