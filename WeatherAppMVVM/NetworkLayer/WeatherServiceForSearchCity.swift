import Foundation

final class WeatherServiceForSearchCity {
    
    var city = ""

    func requestForWeatherInCity(_ completion: @escaping ((Result<MainSearchWeatherCity, Error>) -> Void)) {

        guard let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&limit=5&appid=c88dea33fd6e93919619685eb9fdc45c&units=metric".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard error == nil, let data = data else { return }

            do {
                let response = try JSONDecoder().decode(MainSearchWeatherCity.self, from: data)
                completion(.success(response))
                print(data)
            } catch {
                completion(.failure(error))
                print(error)
            }
        }
        .resume()
    }
}
