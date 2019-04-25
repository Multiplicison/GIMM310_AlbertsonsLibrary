
import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    //***********************
    //vars to hold our 3D shapes (made as optional(thus the "?") because it's not always going to be detected)
    var sphereNode: SCNNode?
    var boxNode: SCNNode?
    var capsuleNode: SCNNode?
    var pyramidNode: SCNNode?
    var torusNode: SCNNode?
    //**************************
    
    
    //************************
    //enumerator to be used for switch statements down in func viewWillDisappear()
    enum ImageType : String {
        case appleLab1 = "appleLabDoorMarker2"
        case winLab1 = "winLapMarker"
        case winLab2 = "bigDaddyMarker"
        case winLab3 = "marioMarker"
        case winLab4 = "winLabWallFullMarker"
        case exitLab1 = "exitMarker1"
        case exitLab2 = "extMarker"
        case lobDesk1 = "lobDeskMarker1"
        case lobDesk2 = "lobDeskCornerMarker"
        case lobDesk3 = "libDeskPcMarker"
        case lobDesk4 = "deskPanelLGMarker"
        case lobDesk5 = "deskPanelSmMarker"
        case lobDesk6 = "bsuFlagMarker"
        case lobDesk7 = "skateRackMarker"
        case lobPC1 = "pcScreenMarker"
        case lobPC2 = "pcMarker1"
        case lobPC3 = "pcMarker2"
        case lobPC4 = "pcMarker3"
    }
    //************************
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        
        //enable our lighting
        sceneView.autoenablesDefaultLighting = true
        
        //**********************
        //SET UP REF PATH AND VARS FOR THE 3D OBJECTS
        let boxScene = SCNScene(named: "art.scnassets/Box.scn")
        let sphereScene = SCNScene(named: "art.scnassets/Sphere.scn")
        let capsuleScene = SCNScene(named: "art.scnassets/Capsule.scn")
        let pyramidScene = SCNScene(named: "art.scnassets/Pyramid.scn")
        let torusScene = SCNScene(named: "art.scnassets/Torus.scn")
        //assign var "boxNode" to the box.scn and assign it to the root node because there is only one thing in the scene
        boxNode = boxScene?.rootNode
        boxNode!.name = "box"
        sphereNode = sphereScene?.rootNode
        sphereNode!.name = "sphere"
        capsuleNode = capsuleScene?.rootNode
        capsuleNode!.name = "capsule"
        pyramidNode = pyramidScene?.rootNode
        pyramidNode!.name = "pyramid"
        torusNode = torusScene?.rootNode
        torusNode!.name = "torus"
        //**********************
        
        
        //**********************
        //ADD TAP GESTURE TO SCENE
        //the target of this tap will be "self" (this class)
        //passing info about the "sender:" (where we are taping down at) and handleTap function set up below with objective-C (@objc) tag
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        //select number of taps needed to trigger
        tapGestureRecognizer.numberOfTapsRequired = 1
        //add the gesture recognizer to the scene view
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        //**********************
    }
    
    
    //**************************
    //FUNCTION TO HANDLE TAP GESTURES
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        //get a CGpoint variable for our touch on the screen (x and y location)
        let touchLocation = sender.location(in: sceneView)
        
        //hitTestResult is an array of possible hits
        // option [:] means we are getting a hit test for everything (no options means all options selected)
        guard let hitTestResult = sceneView.hitTest(touchLocation, options: [:] ).first?.node else { return }
        
        //if the thing that we hit happens to be the boxNode
        if hitTestResult.name == "torus" {
            //print the message in the debug log
            print("this is the apple lab")
        }
        
        //switch case setup for possible hit test results and the output for each to the debug log
        //switch hitResult.node {
        switch hitTestResult.name {
        case "box":
            print("this is the apple lab")
        case "sphere":
            print("this is the exit")
        case "capsule":
            print("this is the windows lab")
        case "pyramid":
            print("this is the exit again")
        case "torus":
            print("this is the lobby desk")
        default:
            break
        }
    }
    //***************************
 
    //tell ARkit what images to look for
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        
        //for object detection and tracking
        //let configuration = ARWorldTrackingConfiguration()
        
        //*******************************
        //LET ARKIT KNOW YOU ARE LOOKING FOR OBJECTS
        //configuration.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "", bundle: Bundle.main)!
        //*******************************
        
        
        //for image detection and tracking
        let configuration = ARImageTrackingConfiguration()
        
        //*******************************
        //LET ARKIT KNOW WHAT TO LOOK FOR
        if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "LobbyImages", bundle: Bundle.main) {
            //if we can see images in this group set the images to track to "trackingImages"
            configuration.trackingImages = trackingImages
            //set the number of images we want to track at the same time
            configuration.maximumNumberOfTrackedImages = 5
        //******************************
        }
        
        //start the session
        sceneView.session.run(configuration)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause the view's session
        sceneView.session.pause()
    }

    
    // MARK: - ARSCNViewDelegate
    
    //give the use some indication that ARkit has detected an image
    //using the AR Scene Kit delegate "nodeFor"....
    //this method is called when the ARkit detects and adds an anchor and  returns an SCNNode
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        //check for type of anchor is returned (make sure its an ARImage anchor)
        if let imageAnchor = anchor as? ARImageAnchor {
            //create a var named "size" that will hold the images physical size information it gets from the ARImageAnchor associated with the image
            let size = imageAnchor.referenceImage.physicalSize
            
            //************************************
            //OVERLAY PLANE ON IMAGE
            //initialize a SCNPlane with a width and a height from "size"
            let plane = SCNPlane(width: size.width, height: size.height)
            //give the plane a material from a UIcolor with alpha for transparency (0.5 = half transparent)
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.2)
            //give the plane some corner radiuses (in milimeters)
            plane.cornerRadius = 0.005
            //create a node to attach the geometry from the "plane" var
            let planeNode = SCNNode(geometry: plane)
            //need to rotate the plane on the x axis so its laying down on the image correctly
            //pi is a half circle for devide by 2 to get 90deg (add neg sign to get -90deg)
            planeNode.eulerAngles.x = -.pi/2
            //add the planeNode to the "node" var that will be returned when this function is called
            node.addChildNode(planeNode)
            //************************************
            
            
            //************************************
            //ASSIGN THE 3D OBJECT NODE TO THE ANCHOR
            //figure out which image you are looking at (imageAnchor has a ref to the image name)
            var shapeNode: SCNNode?
            //if the rawValue of the enumerator (set up top by vars) equals the imageAnchor...
            switch imageAnchor.referenceImage.name {
            case ImageType.appleLab1.rawValue :
                //set our temporary wrapped shapNode equal to the boxNode
                shapeNode = boxNode
            case ImageType.exitLab1.rawValue, ImageType.exitLab2.rawValue :
                shapeNode = sphereNode
            case ImageType.lobDesk1.rawValue, ImageType.lobDesk2.rawValue, ImageType.lobDesk3.rawValue, ImageType.lobDesk4.rawValue, ImageType.lobDesk5.rawValue, ImageType.lobDesk6.rawValue, ImageType.lobDesk7.rawValue :
                shapeNode = torusNode
            case ImageType.winLab1.rawValue, ImageType.winLab2.rawValue, ImageType.winLab3.rawValue, ImageType.winLab4.rawValue :
                shapeNode = capsuleNode
            case ImageType.lobPC1.rawValue, ImageType.lobPC2.rawValue, ImageType.lobPC3.rawValue, ImageType.lobPC4.rawValue :
                shapeNode = pyramidNode
                //add a default and break to cover all other possibilities and get out of the switch statement
            default:
                break
            }
            //************************************
            
            
            //************************************
            //CREATE SPINNING MOVEMENT FOR THE 3D OBJECT (shapeNode)
            //use type "ScneneAction" with no spin on x, 2*pi (360deg) on y, and no spin on z axis, with a duration of 10 seconds
            let shapeSpin = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 10)
            //have it repeat the SCNAction(shapeSpin) forever
            let repeatSpin = SCNAction.repeatForever(shapeSpin)
            //set this action for the shapeNode
            shapeNode?.runAction(repeatSpin)
            //************************************
            
            
            //************************************
            //UNWRAP SHAPENODE AND GIVE IT TO NODE TO BE RETURNED
            //unwrap the ShapeNode and assign it to the var "shape"
            //if we are unsuccesful at getting a shape node then just return nil (we have to return something and "nil" will work)
            guard let shape = shapeNode else {return nil}
            //then add the unwrapped version of the shapNode ("shape") as a child of the imageNode to be returned to the function caller
            node.addChildNode(shape)
            //************************************
        }
        
        return node
    }
}
