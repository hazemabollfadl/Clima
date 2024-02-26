import Foundation

struct WeatherModel{
    let name:String
    let temp:Double
    let id:Int
    
    var conditionTemp:Double{
        return round(temp*10)/10
    }
    
    var coditionName:String{
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "snowflake"
        case 701...781:
            return "cloud.fog"
        case 801...804:
            return "cloud"
        case 800:
            return "sun.max"
        default:
            return "sun.max.trianglebadge.exclamationmark"
        }
    }
}
