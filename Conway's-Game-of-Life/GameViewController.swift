//
//  GameViewController.swift
//  Conway's-Game-of-Life
//
//  Created by Artur Carneiro on 31/10/19.
//  Copyright © 2019 Artur Carneiro. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    var sceneView: SCNView!
    var scene: SCNScene!
    var cameraNode: SCNNode!
    var boxArray: [[SCNNode]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        setupCamera()
        for y in 0...16 {
            var line: [SCNNode] = []
            for x in 0...16 {
                let material = SCNMaterial()
                material.diffuse.contents = UIColor.white
                let geometry: SCNGeometry
                geometry = SCNBox(width: 0.8, height: 0.8, length: 0, chamferRadius: 0)
                geometry.firstMaterial = material
                let geometryNode = SCNNode(geometry: geometry)
                geometryNode.position.x = Float(x)
                geometryNode.position.y = Float(-y)
                scene.rootNode.addChildNode(geometryNode)
                line.append(geometryNode)
            }
            boxArray.append(line)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(nextIteration(_:)))
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func nextIteration(_ gestureRecognizer: UIGestureRecognizer) {
        
        
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
                            for i in 0..<GameManager.shared.survivors.count {
                                if GameManager.shared.survivors[i] == (x,y) {
                                    boxArray[x][y].geometry?.firstMaterial?.diffuse.contents = UIColor.white
                                    GameManager.shared.survivors.remove(at: i)
                                }
                            }
                        } else {
                            GameManager.shared.grid[x][y] = true
                            GameManager.shared.survivors.append((x,y))
                        }
                    }
                }
            }
        } else {
            GameManager.shared.gameLoop()
            setNewGrid(survivors: GameManager.shared.survivors, dead: GameManager.shared.dead)
            GameManager.shared.clearGenerationArray()
        }
        
    }
    
    func setupView() {
        sceneView = self.view as! SCNView
        sceneView.backgroundColor = .black
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = false
        sceneView.autoenablesDefaultLighting = true
    }
    
    func setNewGrid(survivors: [(Int,Int)], dead: [(Int,Int)] ) {
        for i in survivors {
            boxArray[i.0][i.1].geometry?.firstMaterial?.diffuse.contents = UIColor.red
        }
        for j in dead {
            boxArray[j.0][j.1].geometry?.firstMaterial?.diffuse.contents = UIColor.white
        }
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

}
