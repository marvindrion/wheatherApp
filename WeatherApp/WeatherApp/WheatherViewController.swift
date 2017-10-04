//
//  ViewController.swift
//  WeatherApp
//
//  Created by Marvin DRION on 28/09/2017.
//  Copyright © 2017 Marvin DRION. All rights reserved.
//

import UIKit
import WeatherAPI
import SDWebImage


class WeatherViewController: UIViewController {

    //Outlets
    @IBOutlet var weatherTableView: UITableView!
    
    //Class var
    var weatherInfos : [WeatherInfos] = []
    var currentDay = ""
    var currentColor = UIColor(hexString: "D8D8D8")
    var userLang = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let deviceLanguage = NSLocale.preferredLanguages[0].components(separatedBy: "-").first {
            userLang = deviceLanguage
        }
        else{
            userLang = "fr"
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        weatherTableView.register(UINib(nibName: String(describing: WeatherCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: WeatherCell.self))
        if userLang == "fr" {
            self.navigationItem.title = "Météo"
        }
        else{
            self.navigationItem.title = "Weather"
        }
        
        //Tableview delegates
        self.weatherTableView.dataSource = self
        self.weatherTableView.delegate = self
        
        //PullToRefresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getWeather), for: .valueChanged)
        
        self.weatherTableView.refreshControl = refreshControl

        
        getWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func getWeather() {
        WeatherAPI.getWeather(id: "2643743", units: PropertiesManager.sharedInstance.getTemperatureUnit()!, lang: userLang, appid: PropertiesManager.sharedInstance.getApiKey()!) { (wr: WeatherResponse?, error: Error?) in
            if let err = error {
                print("getWeather ERROR : ",err)
            }
            else{
                print("getWEATHER SUCCESS")
                for fullWeather in (wr?.list)! {
                    let infos = WeatherInfos()
                    
                    if let temperature = fullWeather.main?.temp {
                        infos.temperature = String(describing: Int(temperature)) + " °"
                    }
                    
                    if let dateString = fullWeather.dtTxt {
                        
                        let df = DateFormatter()
                        df.dateFormat = "YYYY-MM-d HH:m:s"
                        let date = df.date(from: dateString)
                        let sf = DateFormatter()
                        sf.dateFormat = "cccc d LLLL H"
                        let newDate = sf.string(from: date!)
                        infos.date = newDate + "h"
                    }
                    
                    for weather in fullWeather.weather! {
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
            self.weatherTableView.refreshControl?.endRefreshing()
        }
    }


}



extension WeatherViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let infos = weatherInfos[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WeatherCell.self), for: indexPath) as? WeatherCell  else {
            fatalError("The dequeued cell is not an instance of WeatherCell.")
        }
        
        //Set cell infos
        cell.dateLabel.text = infos.date.capitalizingFirstLetter()
        cell.descWeatherLabel.text = infos.weatherDescription.capitalizingFirstLetter()
        cell.temperatureLabel.text = infos.temperature
        
        //Set cell icon
        let iconUrl = "https://openweathermap.org/img/w/" + infos.iconString + ".png"
        cell.weatherIcon.sd_setImage(with: URL(string: iconUrl), placeholderImage: UIImage(named: "IconNotFound"))
        
        //Cell background management
        let day = cell.dateLabel.text?.components(separatedBy: " ").first!
        if day != currentDay {
            if currentColor == UIColor(hexString: "E6E6E6") {
                currentColor = UIColor(hexString: "D8D8D8")
            }
            else{
                currentColor = UIColor(hexString: "E6E6E6")
            }
            currentDay = day!
        }
        cell.backgroundColor = currentColor
        
        return cell
   }
}

extension WeatherViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("SELECTED ROW")
    }
}

