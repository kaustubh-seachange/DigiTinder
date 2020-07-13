//
//  ViewController.swift
//  DigiTinder
//
//  Created by Kaustubh on 25/06/20.
//  Copyright © 2020 Kaustubh. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate  {
    var profileDataSource = [DigiTinderSwipeModel]()
    var digiTinderPresenterView : DigiTinderPresenterView!
    
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
        self.loadFavouriteProfiles()
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
            self.networkManager!.getDigiTinderProfile(page: 1) { user, error in
                if error == nil {
                    let saveStatus = self.saveTinderUser(user: user!)
                    if saveStatus {
                        DispatchQueue.main.async {
                            if (self.addProfileDataSource(user: user)) {
                                self.digiTinderPresenterView.reloadData()
                            }
                        }
                    }
                }
                else {
                    print("error: \(String(describing: error))")
                    DispatchQueue.main.async {
                        self.showAlertWith(title: "Error", message: error!)
                    }
                }
            }
    }
    
    func fetchProfileImage(photoUrl: String)  {
        let secureRequest = self.secureURLRequest(url: photoUrl)
        self.digiTinderPresenterView.visibleCards[0].imageView.resourceCachingFrom(secureRequest,
            placeHolder: UIImage(named: "placeholder"))
    }
    
    func addProfileDataSource(user: TinderUserResponseModel!) -> Bool {
        let element = DigiTinderSwipeModel(bgColor: UIColor.lightGray,
                                           image: self.secureURLRequest(url: user.picture),
                                           text: self.getProfileDisplayName(user: user),
                                           subText: self.getProfileDetails(user: user))
        profileDataSource.append(element)
        return true
    }
}

// MARK: - CoreData Method(s).
extension ViewController {
    func loadFavouriteProfiles() {
        let tinderFavourites = CoreDataStore.sharedInstance.favouriteProfiles()
        var isAdded = false
        for tinderProfile in tinderFavourites {
            isAdded = self.addProfileDataSource(user: tinderProfile as? TinderUserResponseModel)
        }
        if isAdded {
            digiTinderPresenterView.reloadData()
        }
        self.getProfiles()

//        let service = APIService()
//        service.getDataWith { (result) in
//            switch result {
//            case .Success(let data):
//                self.clearData()
//                self.saveInCoreDataWith(array: data)
//            case .Error(let message):
//                DispatchQueue.main.async {
//                    self.showAlertWith(title: "Error", message: message)
//                }
//            }
//        }
    }
    
    private func saveTinderUser(user: TinderUserResponseModel) -> Bool {
        _ = CoreDataStore.sharedInstance.createTinderEntity(user: user)
        do {
            try CoreDataStore.sharedInstance.persistentContainer.viewContext.save()
            return true
        } catch let error {
            print("error: \(error.localizedDescription)")
            return false
        }
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
        let profileDetails = "\(user.gender.capitalizingFirstLetter()), \(user.location.city)"
        return profileDetails
    }
    
    func getTinderUserAge(dob: String) -> Int {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from:dob)!
        return Calendar.current.dateComponents([.year], from: date, to: Date()).year!
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
    
    func emptyView() -> UIView? {
        return nil
    }
}
