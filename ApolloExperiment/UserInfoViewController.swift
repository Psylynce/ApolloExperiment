//
//  UserInfoViewController.swift
//  ApolloExperiment
//
//  Created by Justin Powell on 3/16/18.
//  Copyright © 2018 Justin Powell. All rights reserved.
//

import UIKit

final class UserInfoViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var userInfoLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        userInfoLabel.text = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        textField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        textField.resignFirstResponder()
    }

    private func updateUserLabel(with user: User) {
        var string = user.login

        if user.name.isEmpty == false {
            string += " (\(user.name))\n\n"
        }

        if user.email.isEmpty == false {
            string += "Email: \(user.email)\n\n"
        }

        string += "Avatar URL: \(user.avatarUrl.absoluteString)"

        userInfoLabel.text = string
    }

    @IBAction func findUserButtonTapped(_ sender: UIButton) {
        guard let text = textField.text, text.isEmpty == false else { return }
        let query = FindUserQuery(byName: text)

        ApolloWrapper<UserContainer>().fetch(query: query) { [weak self] result in
            guard let strongSelf = self else { return }

            switch result {
            case let .success(container):
                strongSelf.updateUserLabel(with: container.user)
            case .failure:
                strongSelf.userInfoLabel.text = "Could not find that user."
            }
        }
    }
}
