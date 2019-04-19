//
//  ViewController.swift
//  Albertsons Library Social Map
//
//  Created by Addison Jones on 4/9/19.
//  Copyright © 2019 Addison Jones. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        let config = ARWorldTrackingConfiguration()
        sceneView.session.run(config)
    }

    override func viewWillDisappear(_ animated: Bool){
        super.viewWillAppear(animated)
        sceneView.session.pause()
    }
}

