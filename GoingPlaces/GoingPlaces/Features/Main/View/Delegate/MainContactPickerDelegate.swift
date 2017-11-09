//
//  ViewController+CNContactPickerDelegate.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/5/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import GoogleMaps
import ContactsUI
import MessageUI

final class MainContactPickerDelegate: NSObject, CNContactPickerDelegate {
    
    weak var router: MainRouter?
    weak var presenter: MainPresenter?
    
    private var messageComposeDelegate: MainMFMessageComposeViewController?
    private var mailComposeDelegate: MainMFMailComposeViewController?

    init(presenter: MainPresenter) {
        self.presenter = presenter
        self.router = presenter.view?.mainRouter
    }
    
    // MARK: - Public functions
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        picker.dismiss(animated: true, completion: {
            guard let currentPlace = self.presenter?.view?.mapView?.selectedMarker else {
                // show error -> You need to select a place
                return
            }
            
            if let emailAddress = contact.emailAddresses.first?.value as? String,
                let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                // Ask email or phone
                
                self.presentShareActionSheet(phoneNumber: phoneNumber,
                                             emailAddress: emailAddress,
                                             contact: contact,
                                             currentPlace: currentPlace)
                return
            }
            
            // Else by default -> Send text.
            guard let phoneNumber = contact.phoneNumbers.first?.value.stringValue else {
                return
            }
            
            self.sendText(contact: contact, phoneNumber: phoneNumber, currentPlace: currentPlace)
        })
        
    }
    
    // MARK: - Private functions
    
    private func bodyText(currentPlace: GMSMarker) -> String {
        var urlString = "from=Morgan&location=\(currentPlace.position.latitude),\(currentPlace.position.longitude)&name=\(currentPlace.title!)&address=\(currentPlace.snippet!)"
        urlString = "goingplaces://openLocation?" + urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        return "Hey, just sharing a location with you. Check this out via this link: \(urlString)"
    }
    
    private func subjectText(from: String = "Morgan") -> String {
        return "\(from) shared a location with you!"
    }
    
    private func sendText(contact: CNContact, phoneNumber: String, currentPlace: GMSMarker) {
        let body = bodyText(currentPlace: currentPlace)
        
        guard let presenter = presenter,
            let view = presenter.view else {
                return
        }
        
        let messageComposeDelegate = MainMFMessageComposeViewController(presenter: presenter)
        self.messageComposeDelegate = messageComposeDelegate
        
        router?.routeToMessage(viewController: view,
                               body: body,
                               phoneNumber: phoneNumber,
                               contact: contact,
                               messageComposeDelegate: messageComposeDelegate)
    }
    
    private func sendEmail(contact: CNContact, email: String, currentPlace: GMSMarker) {
        let body = bodyText(currentPlace: currentPlace)
        let subject = subjectText()
        
        guard let presenter = presenter,
            let view = presenter.view else {
            return
        }
        
        let mailComposeDelegate = MainMFMailComposeViewController(presenter: presenter)
        self.mailComposeDelegate = mailComposeDelegate
        
        router?.routeToMail(viewController: view,
                            body: body,
                            subject: subject,
                            email: email,
                            mailComposeDelegate: mailComposeDelegate,
                            contact: contact)
    }
    
    private func presentShareActionSheet(phoneNumber: String, emailAddress: String, contact: CNContact, currentPlace: GMSMarker) {
        let alertController = UIAlertController(title: "Share", message: "Share this location via text or email. Pick one:", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        let emailAction = UIAlertAction(title: "Email", style: .default, handler: { (action) in
            self.sendEmail(contact: contact, email: emailAddress, currentPlace: currentPlace)
        })
        let textAction = UIAlertAction(title: "Text", style: .default, handler: { (action) in
            self.sendText(contact: contact, phoneNumber: phoneNumber, currentPlace: currentPlace)
        })
        
        alertController.addAction(emailAction)
        alertController.addAction(textAction)
        alertController.addAction(cancelAction)
        
        presenter?.view?.present(alertController, animated: true, completion: nil)
    }
    
    
}
