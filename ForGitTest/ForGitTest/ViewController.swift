//
//  ViewController.swift
//  ForGitTest
//
//  Created by 김하늘 on 2022/12/23.
//

import UIKit

final class ViewController: UIViewController {

    var customers: [User] = [
        User(name: "a", age: 10),
        User(name: "b", age: 20),
        User(name: "c", age: 30),
        User(name: "d", age: 40)
    ]
    var userInfoAge: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonDidTapped(_ sender: UIButton) {
    }
    
    func buttonEvent() {
        print("aa")
    }
    
    func addCustomer(user: User) {
        customers.append(user)
    }
    
    func 서버에데이터올리는작업() {
            
    }
    
    func fetchUserAge() {
        // user default에서 유저 ID 받아오기
        userInfoAge = 32
    }
}

struct User {
    var name: String
    var age: Int
}
