//
//  ViewController.swift
//  DigiTinder
//
//  Created by Kaustubh on 25/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {
    var previousProfileViewIndex: Int = 0
    var profileDataSource = [DigiTinderSwipeModel]()
    var responseForTinderProfiles = [TinderUserResponseModel]() // This needs to be reset, once emptyView is called and n/w request is completed.
    var digiTinderPresenterView : DigiTinderPresenterView!
    var commonUI: CommonUI!
    
    private var networkManager: DTNetworkManager?
    
    
    lazy var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: TinderUser.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "ssn", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStore.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    // MARK: - View Lifecycle Method(s).
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        
        commonUI = CommonUI()
        
        digiTinderPresenterView = DigiTinderPresenterView()
        view.addSubview(digiTinderPresenterView)
        configurePresenterContainer()
        digiTinderPresenterView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        digiTinderPresenterView.dataSource = self
        let networkManager = DTNetworkManager(persistentContainer: CoreDataStore.sharedInstance.persistentContainer)
        self.networkManager = networkManager

        view.backgroundColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadFavouriteProfiles()
        
        super.viewDidAppear(true)

    }
    //MARK: - Configurations
    func configurePresenterContainer() {
        digiTinderPresenterView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        digiTinderPresenterView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60).isActive = true
        digiTinderPresenterView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        digiTinderPresenterView.heightAnchor.constraint(equalToConstant: 400).isActive = true
    }
    
    //MARK: Handlers
    @objc func resetTapped() {
        digiTinderPresenterView.reloadData()
    }
}

// MARK: - Request/Response.
extension ViewController {
    func getProfiles() {
        let aFrame = CGRect(x: self.view.frame.width/2,
                            y: self.view.frame.height/2,
                            width: 24.0,
                            height: 24.0)
        self.commonUI.createActivityIndicator(using: self.view, aFrame: aFrame)
//        let activityIndicator = UIActivityIndicatorView.init(frame: aFrame)
//        activityIndicator.color = .darkGray
//        activityIndicator.style = .large
//        activityIndicator.backgroundColor = UIColor.clear
//        activityIndicator.startAnimating()
//        self.view.addSubview(activityIndicator)
        self.networkManager!.getDigiTinderProfile(page: 1) { results, error in
            if error == nil {
                var isProfileSavedToDataSource = false
                self.responseForTinderProfiles.removeAll() // Array Flushed.
                self.profileDataSource.removeAll()
                for result in results! as [Result] {
                    isProfileSavedToDataSource = self.addProfileDataSource(user: result.user,
                                                                           isFavourite: false)
                }
                DispatchQueue.main.async {
                    self.commonUI.stopActivityIndicator()
                    //activityIndicator.stopAnimating()
                    if isProfileSavedToDataSource {
                        if self.previousProfileViewIndex > 0 {
                            self.digiTinderPresenterView.reloadData(at: self.previousProfileViewIndex)
                        }
                        else {
                            self.digiTinderPresenterView.reloadData()
                        }
                    }
                    else {
                        self.loggerMin("Do Nothing...")
                    }
                }
            }
            else {
                self.loggerMin(String(describing: error))
                DispatchQueue.main.async {
                    self.commonUI.stopActivityIndicator()
                    //activityIndicator.stopAnimating()
                    self.showAlertWith(title: "Error", message: error!)
                }
            }
        }
    }
    
    func addProfileDataSource(user: TinderUserResponseModel!, isFavourite: Bool) -> Bool {
        let element = DigiTinderSwipeModel(bgColor: .white,
                                           image: self.secureURLRequest(url: user.picture),
                                           name: self.getProfileDisplayName(user: user),
                                           subText: self.getProfileDetails(user: user),
                                           dob: self.getTinderUserAge(dob: user.dob),
                                           email: user.email,
                                           city: user.location.city,
                                           state: user.location.state,
                                           zip: user.location.zip,
                                           phone: user.phone,
                                           cell: user.cell,
                                           privacyInfo: user.ssn,
                                           isMarkedFavourite: isFavourite)
        profileDataSource.append(element)
        responseForTinderProfiles.append(user)
        return true
    }
}

// MARK: - CoreData Method(s).
extension ViewController {
    func loadFavouriteProfiles() {
        let tinderFavourites = CoreDataStore.sharedInstance.favouriteProfiles()
        self.loggerMin("Found \(tinderFavourites.count) Favourite Profile(s)")
        var isFavouriteFound = false
        for tinderProfile in tinderFavourites {
            isFavouriteFound = self.addProfileDataSource(user: tinderProfile as? TinderUserResponseModel, isFavourite: true)
        }
        if isFavouriteFound {
            digiTinderPresenterView.reloadData()
        }
        else {
            self.getProfiles()
        }
    }
    
    private func saveTinderUser(user: TinderUserResponseModel) -> Bool {
        let isUserExits = CoreDataStore.sharedInstance.findExistingUser(user: user)
        if (isUserExits) {
            return true
        }
        _ = CoreDataStore.sharedInstance.createTinderEntity(user: user)
        do {
            try CoreDataStore.sharedInstance.persistentContainer.viewContext.save()
            return true
        } catch let error {
            self.loggerMin("error: \(error.localizedDescription)")
            return false
        }
    }
    
    private func removeFavouriteUser(user: TinderUserResponseModel) -> Bool {
        return CoreDataStore.sharedInstance.removeTinderUser(user: user)
    }
    
    private func restDataStore() {
        CoreDataStore.sharedInstance.clearData()
    }
}

// MARK: - Additional Method(s).
extension ViewController {
    // MARK: This method will display alert with Title and Message.
    func showAlertWith(title: String,
                       message: String,
                       style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title,
                                                message: "",
                                                preferredStyle: style)
        let action = UIAlertAction(title: message, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Fix for arbitraryLoads causing unknown issue in iOS(13.*), relevant keys in plist don't resolve issue. */
    func secureURLRequest(url: String) -> String {
        var comps = URLComponents(string: url)!
        comps.scheme = "https"
        //let secureRequest = comps.string!
        return comps.string!
    }
    
    func getProfileDisplayName(user: TinderUserResponseModel) -> String {
        let profileName = "\(user.name.title.capitalizingFirstLetter()) \(user.name.first.capitalizingFirstLetter()) \(user.name.last.capitalizingFirstLetter())"
        return profileName
    }
    
    func getProfileDetails(user: TinderUserResponseModel) -> String {
        let profileDetails = "\(user.gender.capitalizingFirstLetter()), \(user.location.city.capitalizingFirstLetter())"
        return profileDetails
    }
    
    func getTinderUserAge(dob: String) -> Int {
        let commonUtils = CommonUtility()
        let age = commonUtils.calculateAge(dob: dob)
        return age.year
//        let dateFormatter = ISO8601DateFormatter()
//        let date = dateFormatter.date(from:dob)!
//        return Calendar.current.dateComponents([.year], from: date, to: Date()).year!
    }
}

// MARK: - DigiTinderView DataSource Method(s).
extension ViewController : DigiTinderDataSource {
    func numberOfCardsToShow() -> Int {
        if profileDataSource.count > 0 {
            return profileDataSource.count
        }
        else {
            return 0
        }
    }
    
    func card(at index: Int) -> DigiTinderView {
        let card = DigiTinderView()
        card.dataSource = profileDataSource[index]
        return card
    }
    
    func emptyView() {
        self.loggerMin("datasource: \(self.profileDataSource.count)")
        self.previousProfileViewIndex = self.profileDataSource.count
        self.getProfiles()
    }

    func markProfile(asFavourite: Bool, using profileData: DigiTinderSwipeModel) {
        let favouriteUsers = responseForTinderProfiles.filter({return $0.email == profileData.email && $0.phone == profileData.phone && $0.ssn ==  profileData.privacyInfo})
        if favouriteUsers.count > 0 {
            if asFavourite {
                let saveStatus = self.saveTinderUser(user: favouriteUsers[0])
                self.loggerMin("save: \(saveStatus)")
            }
            else {
                let removeStatus = self.removeFavouriteUser(user: favouriteUsers[0])
                self.loggerMin("remove: \(removeStatus)")
            }
        }
    }

}
