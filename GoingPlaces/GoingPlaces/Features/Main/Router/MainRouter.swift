//
//  MainRouter.swift
//  GoingPlaces
//
//  Created by Morgan Collino on 11/8/17.
//  Copyright © 2017 Morgan Collino. All rights reserved.
//

import Foundation
import GooglePlaces
import GoogleMaps
import ContactsUI
import MessageUI

final class MainRouter {
    
    func routeToRoot(place: Place? = nil) {
        let mainBuilder = MainBuilder()
        guard let viewController = mainBuilder.build(with: place) else {
            return
        }
        
        let navigationViewController = UINavigationController(rootViewController: viewController)
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = navigationViewController
    }
    
    func routeToAutoCompletePlaces(viewController: UIViewController, delegate: GMSAutocompleteViewControllerDelegate) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = delegate
        viewController.present(autocompleteController, animated: true, completion: nil)
    }
    
    func routeToShare(viewController: UIViewController, delegate: CNContactPickerDelegate) {
        let pickerViewController = CNContactPickerViewController()
        pickerViewController.delegate = delegate
        pickerViewController.displayedPropertyKeys = [CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
        viewController.present(pickerViewController, animated: true, completion: nil)
    }
    
    func routeToMessage(viewController: UIViewController,
                        body: String,
                        phoneNumber: String,
                        contact: CNContact,
                        messageComposeDelegate: MFMessageComposeViewControllerDelegate) {
        let messageViewController = MFMessageComposeViewController()
        messageViewController.body = body
        messageViewController.messageComposeDelegate = messageComposeDelegate
        messageViewController.recipients = [phoneNumber]
        messageViewController.subject = contact.givenName
        messageViewController.title = contact.givenName
        viewController.present(messageViewController, animated: true, completion: nil)
    }
    
    func routeToMail(viewController: UIViewController, body: String, subject: String, email: String, mailComposeDelegate: MFMailComposeViewControllerDelegate, contact: CNContact) {
        let messageViewController = MFMailComposeViewController()
        messageViewController.setMessageBody(body, isHTML: false)
        messageViewController.setSubject(subject)
        messageViewController.setToRecipients([email])
        messageViewController.mailComposeDelegate = mailComposeDelegate
        messageViewController.title = contact.givenName
        viewController.present(messageViewController, animated: true, completion: nil)
    }
    
}
