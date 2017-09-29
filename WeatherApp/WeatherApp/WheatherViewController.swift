//
//  ViewController.swift
//  WeatherApp
//
//  Created by Marvin DRION on 28/09/2017.
//  Copyright © 2017 Marvin DRION. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    //Outlets
    @IBOutlet var weatherTableView: UITableView!
    
    //Class var
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.weatherTableView.dataSource = self
        self.weatherTableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



extension WeatherViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16 //FIXME : return number of data retrived
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}

