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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PassCell") {
            configureCell(cell, forRowAt: indexPath)
            return cell
        } else {
            return UITableViewCell()
        }
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
        let alertController = UIAlertController(title: NSLocalizedString("Location Error", comment: "Location Error") , message: NSLocalizedString("ISS Passes needs your location in order to perdict passes for your current location. You can authorize the app in Settings.", comment: "Location Error") , preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: "Settings") , style: .default, handler: { action in
            if let seetingsUrl = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(seetingsUrl)
            }
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
            errorMessage = NSLocalizedString("ISS API service failure. Please try again later!", comment: "Service Error")
        case .LocationError:
            errorMessage = NSLocalizedString("Location service failure. Please try again later!", comment: "Location  Error")
        }
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        self.loadingIndicator.stopAnimating()
    }
    
 }
 
