//
//  ViewController.swift
//  JsonPlaceHolderUsers
//
//  Created by Firat Tamur on 7/30/21.
//

import UIKit
import Moya

protocol Controller {
    
    func setSubViewsAttribute();
    func setSubViewsConstraint();
    
}

class ViewController: UIViewController, Controller {
    
    private var tableView: UITableView = {
       
        let tableView = UITableView()
        return tableView
        
    }()
    
    private var users = [User(id: 0, name: "firat")]
    private let userProvider = MoyaProvider<UserService>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // attributes
        self.setSubViewsAttribute()
        
        // users data
        self.getUsers()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // constraints
        self.setSubViewsConstraint()
        
    }
    
    func setSubViewsAttribute() {
        
        // self
        self.navigationItem.title = "Users"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // tableview
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.addSubview(self.tableView)
        
    }
    
    func setSubViewsConstraint() {
        
        // tableview
        self.tableView.frame = self.view.frame
        
    }
    
    func getUsers() {
        
        self.userProvider.request(.readUsers) { result in
            
            switch result {
                
                case .success(let response):
                    
                    let apiUsers = try! JSONDecoder().decode([User].self, from: response.data)
                    self.users = apiUsers
                    
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    
                    print("Getting users failed!")
                    print(error)
                
            }
            
        }
        
    }
    
    @IBAction func createRandomUser(_ sender: Any) {
                
        self.userProvider.request(.createUser(name: "NewUser")) { result in
            
            switch result {
            
            case .failure(let error):
                print("Error while creating new user: \(error)")
                
            case .success(let response):
                let newUser = try! JSONDecoder().decode(User.self, from: response.data)
                self.users.insert(newUser, at: 0)
                
                self.tableView.reloadData()
            
            }
            
        }
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = users[indexPath.row].name.capitalized
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = self.users[indexPath.row]
        
        self.userProvider.request(.updateUser(id: user.id, name: "Modified \(user.name)")) { result in
            
            switch result {
            
            case .failure(let error):
                print("Error while updating user: \(error)")
                
            case .success(let response):
                let modifiedUser = try! JSONDecoder().decode(User.self, from: response.data)
                self.users[indexPath.row] = modifiedUser
                
                self.tableView.reloadData()
        
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else {
            return
        }
        
        let user = self.users[indexPath.row]
        
        // delete user
        self.userProvider.request(.deleteUser(id: user.id)) { result in
            
            switch result {
            
            case .failure(let error):
                print("Error while deleting user -> \(error)")
                
            
            case .success(let response):
                self.users.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            }
            
        }
        
    }
    
}
