//
//  IssPassesListViewController.swift
//  ISSPasses
//
//  Created by Balamurugan Gopal on 2/16/18.
//  Copyright © 2018 Balamurugan Gopal. All rights reserved.
//
 
 import UIKit
 
 class IssPassesListViewController: UIViewController {
    
    @IBOutlet var viewModel: IssPassesListViewModel!
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
 
 extension IssPassesListViewController: UITableViewDataSource {
    
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
 
 extension IssPassesListViewController: IssPassesListViewDelegate {

    func updateIssPassesList() {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            strongSelf.latitudeValueLabel.text = self?.viewModel.getLatitude()
            strongSelf.longitudeValueLabel.text = self?.viewModel.getLongitude()
            strongSelf.altitudeValueLabel.text = self?.viewModel.getAltitude()
            strongSelf.noOfPassesLabel.text = self?.viewModel.getNoOfPasses()
            strongSelf.tableView.reloadData()
            strongSelf.loadingIndicator.stopAnimating()
            strongSelf.view.alpha = 1
        }
    }
    
    func requestUserToEnableLocation() {
        let message = NSLocalizedString("ISS Passes needs your location in order to perdict passes for your current location. You can authorize the app in Settings.", comment: "")
        let alertController = UIAlertController(title: NSLocalizedString("Location Error", comment: ""), message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: "Settings"), style: .default, handler: { _ in
            if let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(settingsUrl)
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        present(alertController, animated: true, completion: nil)
        self.loadingIndicator.stopAnimating()
    }
    
    func handleError(error: IssPassesListError) {
        var errorMessage = ""
        switch error {
        case .serviceError:
            errorMessage = NSLocalizedString("ISS API service failure. Please try again later!", comment: "Service Error")
        case .locationError:
            errorMessage = NSLocalizedString("Location service failure. Please try again later!", comment: "Location  Error")
        }
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: "Error"), message: errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: .cancel, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.sync { [weak self] in
            self?.present(alertController, animated: true, completion: nil)
            self?.loadingIndicator.stopAnimating()
        }
    }
    
 }
 
