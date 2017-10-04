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
    @IBOutlet var selectedCityButton: UIButton!

    //Class var
    var weatherInfos: [WeatherInfos] = []
    var currentDay = ""
    var currentColor = UIColor(hexString: "D8D8D8")
    var userLang = ""
    var collectionPopIn: CollectionPopIn!
    var citiesArray: [City] = []
    var selectedCityId = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        //Load cities data
        loadCities()

        //Language Management
        if let deviceLanguage = NSLocale.preferredLanguages[0].components(separatedBy: "-").first {
            userLang = deviceLanguage
        } else {
            userLang = "fr"
        }

        weatherTableView.register(UINib(nibName: String(describing: WeatherCell.self), bundle: Bundle.main), forCellReuseIdentifier: String(describing: WeatherCell.self))

        if userLang == "fr" {
            self.navigationItem.title = "Météo"
        } else {
            self.navigationItem.title = "Weather"
        }

        //Tableview delegates
        self.weatherTableView.dataSource = self
        self.weatherTableView.delegate = self

        //PullToRefresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(getWeather), for: .valueChanged)
        self.weatherTableView.refreshControl = refreshControl

        //Button design
        selectedCityButton.setTitleColor(UIColor(hexString: "0404B4"), for: .normal)
        selectedCityButton.layer.borderWidth = 1.5
        selectedCityButton.layer.borderColor = UIColor.lightGray.cgColor
        selectedCityButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        //Load weather data
        selectedCityId = "6455259"
        getWeather()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadCities() {
        let paris = City(id: "6455259", name: "Paris")
        let london = City(id: "2643743", name: "London")
        let madrid = City(id: "3117735", name: "Madrid")
        let berlin = City(id: "2950159", name: "Berlin")
        let roma = City(id: "3169070", name: "Roma")

        citiesArray.append(paris)
        citiesArray.append(london)
        citiesArray.append(madrid)
        citiesArray.append(berlin)
        citiesArray.append(roma)
    }

    @objc func getWeather() {
        print("getWeather cityId : ", selectedCityId)
        WeatherAPI.getWeather(id: selectedCityId, units: PropertiesManager.sharedInstance.getTemperatureUnit()!, lang: userLang, appid: PropertiesManager.sharedInstance.getApiKey()!) { (wr: WeatherResponse?, error: Error?) in
            if let err = error {
                print("getWeather ERROR : ", err)
            } else {
                print("getWEATHER SUCCESS")
                self.weatherInfos = []
                for fullWeather in (wr?.list)! {
                    let infos = WeatherInfos()

                    //Load temperature
                    if let temperature = fullWeather.main?.temp {
                        infos.temperature = String(describing: Int(temperature)) + " °"
                    }
                    //Load date
                    if let dateString = fullWeather.dtTxt {

                        let df = DateFormatter()
                        df.dateFormat = "YYYY-MM-d HH:m:s"
                        let date = df.date(from: dateString)
                        let sf = DateFormatter()
                        sf.locale = NSLocale(localeIdentifier: NSLocale.preferredLanguages[0]) as Locale!
                        sf.dateFormat = "cccc d LLLL H"
                        let newDate = sf.string(from: date!)
                        infos.date = newDate + "h"
                    }

                    for weather in fullWeather.weather! {
                        //Load icon
                        if let icon = weather.icon {
                            infos.iconString = icon
                        }
                        //Load weather description
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

    @IBAction func selectedCityTapped(_ sender: Any) {
        print("selectedCity Tapped")

        self.collectionPopIn = CollectionPopIn(delegate: self, data: citiesArray, options: nil)
        self.collectionPopIn?.delegate = self

        //Highlight the selected city
        for city in citiesArray {
            if (city.id == self.selectedCityId) {
                self.collectionPopIn?.selectedItems?.append(city)
            }
        }
        //Show the Pop In
        self.collectionPopIn.showAsDialog()

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
        cell.selectionStyle = .none
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
            } else {
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

extension WeatherViewController: CollectionPopInDelegate {
    //CollectionPopinDelegate
    func didSelectItem(object: Any) {
        let city = object as? City
        if city != nil {
            if (city!.id != selectedCityId) {
                selectedCityId = city!.id
                selectedCityButton.setTitle(city?.name, for: .normal)
                getWeather()
            }
        }
        self.collectionPopIn.dismiss()
    }

    func getLabel(object: Any) -> String {
        let city = object as? City

        if city != nil {
            return city!.name
        } else {
            return "Paris"
        }
    }

    func getId(object: Any) -> String {
        let city = object as? City

        if city != nil {
            return city!.id
        } else {
            return "2643743"
        }
    }
}
