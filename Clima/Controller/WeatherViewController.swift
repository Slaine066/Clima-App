import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    // Outlets
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    // Actions
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }

    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self // Set the locationManager delegate before requesting the permission and the location.
        
        // Request Permission for location (show user a popup)
        locationManager.requestWhenInUseAuthorization() // This is not enough to work with location: you also need to add a Key on the Info.plist file
                                                        // (Privacy - Location When In Use Usage Description)
        locationManager.requestLocation() // This method returns immediately. Calling it causes the location manager to obtain a location fix (which may take several seconds)
                                          // and call the delegate’s locationManager(_:didUpdateLocations:) method with the result.
        
        // Notify the ViewController everytime there is a change into the UITextField.
        searchTextField.delegate = self
        
        weatherManager.delegate = self
    }
}


//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    //
    // TextFieldDelegate Protocol Methods
    //
    
    // Actions
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    
    
    // Called when the Return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    // This method is called when the TextField is asked to end editing (resign the first responder status).
    // Mostly used to make some control or validations on the TextField value before calling the "textViewDidEndEditing".
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    // This method is called after the TextField ended editing (resigned the first responder status).
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(city)
        }
        
        // Empty the text field
        searchTextField.text = ""
    }
}


//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    
    //
    // WeatherManagerDelegate Protocol Methods
    //
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel) { // The first parameter is not necessary but I added following the Swift
                                                                                       // naming convention (see how textFieldDelegate methods are written.
        DispatchQueue.main.async { // We use the DispatchQueue because the information we are trying to put into our UI is from a Networking CompletionHandler,
                                   // that means that the operation could take few seconds depending on the user network.
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(_ weatherManager: WeatherManager, _ error: Error) {
        print(error)
    }
}


//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    //
    // CLLocationManagerDelegate Protocol Methods
    //
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            weatherManager.fetchWeather(lat, long)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
