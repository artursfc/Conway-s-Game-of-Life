//
//  SilverViewController.swift
//  Conway's-Game-of-Life
//
//  Created by Artur Carneiro on 04/11/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class SilverViewController: UIViewController, SCNSceneRendererDelegate {
    
    var sceneView: SCNView!
    var scene: SCNScene!
    var cameraNode: SCNNode!
    var boxArray: [[SCNNode]] = []
    var playButton: UIButton?
    var timeInterval: TimeInterval = 0
    var timeConstant: TimeInterval  = 0.5
    var floor: Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView = SCNView(frame: self.view.frame)
        setupView()
        setupScene()
        setupCamera()
        setupGrid()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(spawn(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        playButton = UIButton()
        guard let playButton = playButton else { return }
        playButton.backgroundColor = .red
        playButton.addTarget(self, action: #selector(startGameLoop), for: .touchDown)
        self.view.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
        playButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupGrid() {
        for y in 0...16 {
            var line: [SCNNode] = []
            for x in 0...16 {
                let material = SCNMaterial()
                material.diffuse.contents = UIColor.white
                let geometry: SCNGeometry
                geometry = SCNBox(width: 0.8, height: 0.8, length: 0.8, chamferRadius: 0)
                geometry.firstMaterial = material
                let geometryNode = SCNNode(geometry: geometry)
                geometryNode.position.x = Float(x)
                geometryNode.position.y = Float(-y)
                scene.rootNode.addChildNode(geometryNode)
                line.append(geometryNode)
            }
            boxArray.append(line)
        }
    }
    
    @objc func startGameLoop() {
        if sceneView.isPlaying {
            timeInterval = 0
            sceneView.isPlaying = false
        } else {
            sceneView.isPlaying = true
        }
    }
    
    @objc func spawn(_ gestureRecognizer: UIGestureRecognizer) {
        
        
        guard let view = self.view as? SCNView else { return }
        
        let location = gestureRecognizer.location(in: view)
        let hitResults = view.hitTest(location, options: [:])
        
        if hitResults.count > 0 {
            let result = hitResults[0]
            guard let material = result.node.geometry?.firstMaterial else { return }
            material.diffuse.contents = UIColor.red
            for x in 0..<boxArray.count {
                for y in 0..<boxArray[0].count {
                    if boxArray[x][y] == result.node {
                        if GameManager.shared.grid[x][y] {
                            GameManager.shared.grid[x][y] = false
                            var toBeRemoved: [Int] = []
                            for i in 0..<GameManager.shared.survivors.count {
                                if GameManager.shared.survivors[i] == (x,y) {
                                    boxArray[x][y].geometry?.firstMaterial?.diffuse.contents = UIColor.white
                                    toBeRemoved.append(i)
                                }
                            }
                            for j in 0..<toBeRemoved.count {
                                GameManager.shared.survivors.remove(at: j)
                            }
                        } else {
                            GameManager.shared.grid[x][y] = true
                            GameManager.shared.survivors.append((x,y))
                        }
                    }
                }
            }
        }
        
    }
    
    func setupView() {
        self.view = sceneView
        sceneView.backgroundColor = .black
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.delegate = self
        sceneView.isPlaying = false
    }
    
    func setNewGrid(survivors: [(Int,Int)], dead: [(Int,Int)] ) {
        let copy = boxArray
        for i in survivors {
            copy[i.0][i.1].geometry?.firstMaterial?.diffuse.contents = UIColor.red
            copy[i.0][i.1].position.z = floor
        }
        for j in dead {
            copy[j.0][j.1].geometry?.firstMaterial?.diffuse.contents = UIColor.white
        }
        floor += 0.8
    }
    
    func setupScene() {
        scene = SCNScene()
        sceneView.scene = scene
    }
    
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(8, -7, 35)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    func spawnBox() -> SCNNode {
        var geometry: SCNGeometry
        geometry = SCNBox(width: 0.6, height: 0.6, length: 0.6, chamferRadius: 0)
        let geometryNode = SCNNode(geometry: geometry)
        scene.rootNode.addChildNode(geometryNode)
        return geometryNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if timeInterval < 0.01 {
            timeInterval = time
        }
        let deltaTime = time - timeInterval
        if sceneView.isPlaying && deltaTime > timeConstant {
            GameManager.shared.gameLoop()
            setNewGrid(survivors: GameManager.shared.survivors, dead: GameManager.shared.dead)
            GameManager.shared.clearGenerationArray()
            timeInterval = time
        }
    }

}
