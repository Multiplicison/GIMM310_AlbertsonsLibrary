
import UIKit
import SceneKit
import ARKit

class AuthController: UIViewController {

    private var locationManager = LocationManager()
    private var isLocationTrackingActive = false
    //private var atLib = Bool?
    @IBOutlet weak var startButton: UIButton!
    
   // var helloWorldTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(AuthController.showButt), userInfo: nil, repeats: true)
    
  
    
    
   // var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        locationManager.initialize()
       // locationManager.delegate = self
        toggleLocationTracking()
        
        print(locationManager.atLibrary)
        
 while (locationManager.atLibrary == false)
 {
    if ( locationManager.atLibrary == true)
    {
        
        startButton.isHidden = false
    
        }
        
        
    }
    
   
    
   func update(_ currentTime: TimeInterval) {
      
    
    print("working")
    
            
        }
        
        
    }
    
    @IBAction func showButton(_ sender: Any) {
        
        
    }
    
    //**************************
    //FUNCTION TO HANDLE TAP GESTURES
    
    

@IBAction func toggleLocationTracking() {
    isLocationTrackingActive = !isLocationTrackingActive
    
    if isLocationTrackingActive {
        //self.toggleLocationTrackingButton.setImage(#imageLiteral(resourceName: "arKit-fence-on"), for: .normal)
        
        //let atLib = locationManager.atLibrary
        let libLocation = Constants.LibraryLocation
        let libCoordinates = libLocation.location
        print("")
        print("=========================================================================================================")
        print("WARNING: ensure that the Albertsons Library is at a location near you,")
     
        print("The current location is: \(libLocation.name) (\(libLocation.location.latitude), \(libLocation.location.longitude))")
        print("=========================================================================================================")
        
        do {
            try locationManager.startMonitoring(location: libCoordinates, radius: Constants.geofencingRadius, identifier: Constants.libIdentifier)
        } catch (let error as LocationManager.GeofencingError) {
            print("An error occurred while monitoring a region: \(error)")
        } catch (let error) {
            print("Tracking location error: \(error.localizedDescription)")
        }
    } else {
        //self.toggleLocationTrackingButton.setImage(#imageLiteral(resourceName: "arKit-fence-off"), for: .normal)
        locationManager.stopMonitoringRegions()
        //locationManager.stopMonitoring(beacons: Constants.razeadBeacons)
        //beaconStatusImage.isHidden = true
       // beaconStatusLabel.isHidden = true
       // stopAutoscanTimer()
    }
}
}
