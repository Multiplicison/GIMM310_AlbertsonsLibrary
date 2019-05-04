
import UIKit
import SceneKit
import ARKit

class AuthController: UIViewController {

    private var locationManager = LocationManager()
    private var isLocationTrackingActive = false
    //private var atLib = Bool?
    @IBOutlet weak var startButton: UIButton!
    
  //timer to check if user is in range of library
     var timer = Timer()
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
 //starts location services
        locationManager.initialize()
        toggleLocationTracking()
        
      
        

        //hides start button by default until user is in range of library
        startButton.isHidden = false
       locationManager.atLibrary = false
    
   //starts timer
     scheduledTimerWithTimeInterval()
    
   
        
        
    }
    
    func scheduledTimerWithTimeInterval(){
 
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: Selector(("inRange")), userInfo: nil, repeats: true)
    }
    
    
    @objc func inRange(){
        
        
     
        if (locationManager.atLibrary == true)
        
        {
            
            startButton.isHidden = false
            
            
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
