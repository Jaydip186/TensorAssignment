//
//  DetailViewController.swift
//  TensorAssignment
//
//  Created by Moksh Marakana on 23/09/23.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windGustLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var tempratureLabel: UILabel!
    
    var tempratureDetail = Daily()
    override func viewDidLoad() {
        super.viewDidLoad()
        pressureLabel.text = "\(tempratureDetail.pressure ?? 0)" 
        humidityLabel.text = "\(tempratureDetail.humidity ?? 0)"
        windGustLabel.text = "\(tempratureDetail.windGust ?? 0)"
        windSpeedLabel.text = "\(tempratureDetail.windSpeed ?? 0)"
        weatherLabel.text = tempratureDetail.weather?[0].description ?? ""
        tempratureLabel.text = "\(tempratureDetail.temp?.day ?? 0.0)"
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
