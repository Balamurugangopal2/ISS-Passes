 //
 //  PassesListViewController.swift
 //  ISSPasses
 //
 //  Created by Balamurugan Gopal on 2/16/18.
 //  Copyright © 2018 Balamurugan Gopal. All rights reserved.
 //
 
 import UIKit
 
 class PassesListViewController: UIViewController {
    
    @IBOutlet var viewModel: PassesListViewModel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var latitudeValueLabel: UILabel!
    @IBOutlet weak var longitudeValueLabel: UILabel!
    @IBOutlet weak var altitudeValueLabel: UILabel!
    @IBOutlet weak var noOfPassesLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        viewModel.getCurrentLocation()
    }
    
 }
 
 extension PassesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberofItemsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PassCell")! // FIXME: use CustomCell
        configureCell(cell, forRowAt: indexPath)
        return cell
    }
    
    func configureCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = viewModel.titleForItemAtIndexPath(indexPath: indexPath)
        cell.detailTextLabel?.text = viewModel.subTitleForItemAtIndexPath(indexPath: indexPath)
    }
    
 }
 
 extension PassesListViewController: PassesListViewDelegate {

    func updatePassesList() {
        DispatchQueue.main.async { [weak self] in
            self?.latitudeValueLabel.text = self?.viewModel.getLatitude()
            self?.longitudeValueLabel.text = self?.viewModel.getLongitude()
            self?.altitudeValueLabel.text = self?.viewModel.getAltitude()
            self?.noOfPassesLabel.text = self?.viewModel.getNoOfPasses()
            self?.tableView.reloadData()
            self?.loadingIndicator.stopAnimating()
            self?.view.alpha = 1
        }
    }
    
    func requestUserToEnableLocation() {
        let alertController = UIAlertController(title: "Location Error", message: "ISS Passes needs your location in order to perdict passes for your current location. You can authorize the app in Settings.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { action in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        present(alertController, animated: true, completion: nil)
        self.loadingIndicator.stopAnimating()
    }
    
    func handleError(error: PassesListError) {
        var errorMessage = ""
        switch (error) {
        case .ServiceError:
            errorMessage = "ISS API service failure. Please try again later!"
        case .LocationError:
            errorMessage = "Location service failure. Please try again later!"
        }
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        self.loadingIndicator.stopAnimating()
    }
    
 }
 
