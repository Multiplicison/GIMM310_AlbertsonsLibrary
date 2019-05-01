
import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    ////////////////////
    //this testOutputLabel is for DEGUB PURPOSES and can be removed when it is no longer needed for the App
    @IBOutlet weak var tapOutputLabel: UILabel!
    ///////////////////
    
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
        
        //*****************4DIRECTION RESOURCE GROUP***************
        case winLab3 = "WinLab3"
        case appleLab3 = "AppleLab3"
        case lobPC3 = "LobPC3"
        case lobDesk3 = "LobDesk3"
        case appleDoor = "LabDoorB"
        //*****************4DIRECTION RESOURCE GROUP***************
    }
    //************************
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        
        //set text output to display nothing for the moment
        tapOutputLabel.text = ""
        
        //enable our lighting
        sceneView.autoenablesDefaultLighting = true
        
        //**********************
        //SET UP REF PATH AND VARS FOR THE 3D OBJECTS
        let boxScene = SCNScene(named: "art.scnassets/MarkerWindows.scn")
        let sphereScene = SCNScene(named: "art.scnassets/MarkerEXIT.scn")
        let capsuleScene = SCNScene(named: "art.scnassets/MarkerLobbyPC.scn")
        let pyramidScene = SCNScene(named: "art.scnassets/MarkerHELP.scn")
        let torusScene = SCNScene(named: "art.scnassets/MarkerMac.scn")
        //assign var "boxNode" to the box.scn and assign it to the root node because there is only one thing in the scene
        boxNode = boxScene?.rootNode
        boxNode!.name = "boxGroup"
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
        
        //switch case setup for possible hit test results and the output for each to the debug log
        //switch hitResult.node {
        switch hitTestResult.name {
        case "WinLabObject":
            tapOutputLabel.text = "this is the Windows Lab"
        case "LobbyExitObject":
            tapOutputLabel.text = "this is the Exit"
        case "LobbyPCObject":
            tapOutputLabel.text = "these are the Lobby PCs"
        case "LobbyDeskObject":
            tapOutputLabel.text = "this is the Front Desk"
        case "MacLabObject":
            tapOutputLabel.text = "this is the Apple Lab"
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
        //if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "LobbyImages", bundle: Bundle.main) {
        
        //*************4DIRECTIONS RESOURSE GROUP*****************
        if let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "4Directions", bundle: Bundle.main) {
            //*************4DIRECTIONS RESOURSE GROUP*****************
            
            
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
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.1)
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
                
            //*************4DIRECTIONS RESOURSE GROUP*****************
            case ImageType.winLab3.rawValue :
                shapeNode = boxNode
            case ImageType.appleLab3.rawValue:
                shapeNode = sphereNode
            case ImageType.lobDesk3.rawValue  :
                shapeNode = pyramidNode
            case ImageType.lobPC3.rawValue :
                shapeNode = capsuleNode
            case ImageType.appleDoor.rawValue :
                shapeNode = torusNode
                //*************4DIRECTIONS RESOURSE GROUP*****************
                
            //add a default and break to cover all other possibilities and get out of the switch statement
            default:
                break
            }
            //************************************
            
            
            //************************************
            //CREATE SPINNING MOVEMENT FOR THE 3D OBJECT (shapeNode)
            //use type "ScneneAction" with no spin on x, 2*pi (360deg) on y, and no spin on z axis, with a duration of 10 seconds
            //let shapeSpin = SCNAction.rotateBy(x: 0, y: 2 * .pi, z: 0, duration: 10)
            //have it repeat the SCNAction(shapeSpin) forever
            //let repeatSpin = SCNAction.repeatForever(shapeSpin)
            //set this action for the shapeNode
            //shapeNode?.runAction(repeatSpin)
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
