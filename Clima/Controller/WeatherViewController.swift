import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    var weatherManager=WeatherManager()
    let locationManager=CLLocationManager()
    let location:[CLLocation] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
       
        
    
        searchTextField.delegate = self
        weatherManager.delegate = self
        
    }
  
}


//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text==""{
            textField.placeholder="Right Something!"
            return false
        }
        else{
            return true
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city=searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        else{
            print("Error")
        }
        textField.text=""
    }
}


//MARK: - WeatherManagerDelegate
extension WeatherViewController:WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManagaer:WeatherManager, weather: WeatherModel) {
        
        DispatchQueue.main.async {
            self.conditionImageView.image=UIImage(systemName: weather.coditionName)
            
            self.temperatureLabel.text=String(weather.conditionTemp)
            
            self.cityLabel.text=weather.name
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
    
}


//MARK: - CLLocationManagerDelegate
extension WeatherViewController:CLLocationManagerDelegate{
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let safeLocation = locations.last{
            weatherManager.fetchWeather(longitude: safeLocation.coordinate.longitude, latitude: safeLocation.coordinate.latitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error")
    }

}
