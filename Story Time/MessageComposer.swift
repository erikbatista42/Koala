//
//  MessageComposer.swift
//  Story Time
//
//  Created by Erik Batista on 2/17/18.
//  Copyright © 2018 swift.lang.eu. All rights reserved.
//

import Foundation
import MessageUI

let textMessageRecipients = ["1-347-641-4125"]

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate {
    
    // Checks if a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController() -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self
        messageComposeVC.recipients = textMessageRecipients
        messageComposeVC.body = "Hey Story Time! I have some feedback about the app: "
        return messageComposeVC
    }
    // Dismisses the view controller when the user is finished with it
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
