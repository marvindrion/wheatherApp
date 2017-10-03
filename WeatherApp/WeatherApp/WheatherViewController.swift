//
//  ViewController.swift
//  WeatherApp
//
//  Created by Marvin DRION on 28/09/2017.
//  Copyright © 2017 Marvin DRION. All rights reserved.
//

import UIKit
import WeatherAPI

class WeatherViewController: UIViewController {

    //Outlets
    @IBOutlet var weatherTableView: UITableView!
    
    //Class var
    var weatherInfos : [WeatherInfos] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        weatherTableView.register(UINib(nibName: String(describing: WeatherCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: WeatherCell.self))
        self.title = "Météo"
        self.navigationItem.title = "Météo"
        
        self.weatherTableView.dataSource = self
        self.weatherTableView.delegate = self
        
        getWeather()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getWeather() {
        WeatherAPI.getWeather(id: "2643743", appid: "f541e1c34cc580e7d0c28678466bdd5a") { (wr: WeatherResponse?, error: Error?) in
            if let err = error {
                print("getWeather ERROR : ",err)
            }
            else{
                print("getWEATHER SUCCESS")
                for fullWeather in (wr?.list)! {
                    let infos = WeatherInfos()
                    for weather in fullWeather.weather! {
                        print("weather description : ",weather.description)
                        if let icon = weather.icon {
                            infos.iconString = icon
                        }
                        if let desc = weather.description {
                            infos.weatherDescription = desc
                        }
                    }
                    
                    self.weatherInfos.append(infos)
                }
            }
            self.weatherTableView.reloadData()
        }
    }


}



extension WeatherViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let infos = weatherInfos[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCell  else {
            fatalError("The dequeued cell is not an instance of WeatherCell.")
        }
        
        if let image = UIImage(named: "Sunny") {
            cell.weatherIcon.image = image
        }
        
        
        cell.dateLabel.text = "MARDI TEST fevréier"
        cell.temperatureLabel.text = infos.weatherDescription
        return cell
   }
}

extension WeatherViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SELECTED ROW")
    }
}

