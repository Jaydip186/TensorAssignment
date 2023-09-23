//
//  ProfileViewController.swift
//  TensorAssignment
//
//  Created by Moksh Marakana on 23/09/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
import MBProgressHUD

class ProfileViewController: UIViewController {
    // Outlet
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var weatherTableview: UITableView!
    
    //Variable
    private let viewModel = ProfileViewModel()
    var weeklyDta = [Daily]()
    
    // MARK:  View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TempratureCellTableViewCell", bundle: nil)
        weatherTableview.register(nib,forCellReuseIdentifier: "TempratureCellTableViewCell")
        
        let dbRef = Database.database().reference().child("users").child(getCurrentUser()?.uid ?? "")
        
        // Get user deail from database
        dbRef.observe(DataEventType.value) { (snapshot) in
            if snapshot.exists() {
                if let userData = snapshot.value as? [String: Any] {
                    // Process and use the retrieved userData here
                    print("Retrieved Data: \(userData)")
                    if let username = userData["displayName"] as? String {
                        self.nameLabel.text = username
                    } else {
                        self.nameLabel.text = ""
                    }
                    if let bioString = userData["biography"] as? String {
                        self.bioLabel.text = bioString
                    } else {
                        self.bioLabel.text = ""
                    }
                    if userData.contains(where: { $0.key == "profilePictureURL" }) {
                        self.profileImageView.sd_setImage(with: URL(string: userData["profilePictureURL"] as! String), placeholderImage: UIImage(named: "user"))
                    } else {
                        self.profileImageView.image = UIImage(named: "user")
                    }
                    
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.getWeatherAction(UIButton())
        }
        
    }

    // MARK: - Button click action
    @IBAction func signoutAction(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            openLoginScreen()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    @IBAction func getWeatherAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if cityTextField.text?.isEmpty ?? true {
            self.showAlert(titleString: "", messageString: EmptyCity)
        } else {
            let geocoder = Geocoder()
            geocoder.getCoordinatesForCity(cityName: cityTextField.text ?? "") { coordinates, error in
                if let coordinates = coordinates {
                    print("Latitude: \(coordinates.latitude), Longitude: \(coordinates.longitude)")
                    self.getWeeklyData(latitideString: "\(coordinates.latitude)", longitudeString: "\(coordinates.longitude)")
                } else if let error = error {
                    print("Error: \(error)")
                    self.showAlert(titleString: "Error", messageString: "\(error.localizedDescription)")
                }
            }
        }
    }
    // MARK: - Function
    func openLoginScreen() {
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") ?? LoginViewController()
        self.pushVC(loginViewController)
    }
    
    func getWeeklyData(latitideString: String, longitudeString: String) {
        
        if Reachability.isConnectedToNetwork() {
            showHud("Please wait..")
            viewModel.fetchWeatherData(for: latitideString, cityLogitude: longitudeString) { result in
                self.hideHUD()

                switch result {
                case .success(let data):
                    
                    
                    let decoder = JSONDecoder()
                    do {
                        let jsonDecoder = JSONDecoder()
                        let responseModel = try jsonDecoder.decode(Temperatures.self, from: data)
                        self.weeklyDta = responseModel.daily ?? [Daily]()
                        self.weatherTableview.reloadData()
                    } catch {
                        print(error)
                    }
                    
                    break
                    // Parse and handle the data (e.g., decode JSON)
                    // Update the UI with the weather information
                case .failure(let error):
                    print("Error fetching weather data: \(error)")
                }
                    }
            
        } else {
            self.showAlert(titleString: "", messageString: NoInterNet)
        }
        
        
    }
   
    func convertTimesamptoDate(seconds: Int) -> String {
       
        let date = Date(timeIntervalSince1970: TimeInterval(seconds))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" // Customize the date format as needed
        return dateFormatter.string(from: date)
    }
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
    
   
}

extension ProfileViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyDta.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "TempratureCellTableViewCell") as! TempratureCellTableViewCell
        cell.dateLabel.text = convertTimesamptoDate(seconds: weeklyDta[indexPath.row].dt ?? 0)
        cell.tempratureLabel.text =   "\(weeklyDta[indexPath.row].temp?.day ?? 0.0)"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailController.tempratureDetail = weeklyDta[indexPath.row]
        self.pushVC(detailController, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
}
