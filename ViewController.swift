
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
        case appleLab = "appleLabDoorMarker2"
        case winLab = "winLapMarker"
        case exitLab = "exitMarker1"
        case exitLab2 = "extMarker"
        case lobDesk = "lobDeskMarker1"
    }
    //************************
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        
        //enable our lighting
        sceneView.autoenablesDefaultLighting = true
        
        //**********************
        //set up reference paths for our 3D obejects
        let boxScene = SCNScene(named: "art.scnassets/Box.scn")
        let sphereScene = SCNScene(named: "art.scnassets/Sphere.scn")
        let capsuleScene = SCNScene(named: "art.scnassets/Capsule.scn")
        let pyramidScene = SCNScene(named: "art.scnassets/Pyramid.scn")
        let torusScene = SCNScene(named: "art.scnassets/Torus.scn")
        //assign var "boxNode" to the box.scn and assign it to the root node because there is only one thing in the scene
        boxNode = boxScene?.rootNode
        sphereNode = sphereScene?.rootNode
        capsuleNode = capsuleScene?.rootNode
        pyramidNode = pyramidScene?.rootNode
        torusNode = torusScene?.rootNode
        //**********************
    }
    
    
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
            plane.firstMaterial?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
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
            case ImageType.appleLab.rawValue :
                //set our temporary wrapped shapNode equal to the boxNode
                shapeNode = boxNode
            case ImageType.exitLab.rawValue :
                shapeNode = sphereNode
            case ImageType.lobDesk.rawValue :
                shapeNode = torusNode
            case ImageType.winLab.rawValue :
                shapeNode = capsuleNode
            case ImageType.exitLab2.rawValue :
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