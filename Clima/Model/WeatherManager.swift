import UIKit
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error:Error)
}


struct WeatherManager{
    let weatherURL="https://api.openweathermap.org/data/2.5/weather?appid=34a16f94d70788f19a31005be21e0987&units=metric"
    
    var delegate:WeatherManagerDelegate?
    
    func fetchWeather(cityName:String){
        performRequest(with: "\(weatherURL)&q=\(cityName)")
    }
    func fetchWeather(longitude:CLLocationDegrees,latitude:CLLocationDegrees){
        performRequest(with: "\(weatherURL)&lat=\(latitude)&lon=\(longitude)")
    }
    
    func performRequest(with urlString:String){
        //1. Create URL
        if let url = URL(string: urlString){
            
            //2. Create URL session
            let urlSession = URLSession(configuration: .default)
            
            //3. Give a certian task
            let task = urlSession.dataTask(with: url){ (data,response,error) in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData=data{
                    if let weather = self.parseJSON(safeData){
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
       
    }
    
    func parseJSON(_ weatherData:Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id          = decodedData.weather[0].id
            let name        = decodedData.name
            let temp        = decodedData.main.temp
            
            let weatherModel = WeatherModel(name: name, temp: temp, id: id)
            return weatherModel
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}


