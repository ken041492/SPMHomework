//
//  MainViewController.swift
//  StudentManage
//
//  Created by imac-3373 on 2024/3/2.
//

import UIKit

import Network_Manager

class MainViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var tbvStudent: UITableView!
    
    // MARK: - Variables
    
    var btnRegist: UIBarButtonItem?
    
    var btnReload: UIBarButtonItem?
    
    var btnAdd: UIBarButtonItem?

    var students: [StudentResponse]?

    var placeHolders: [String] = ["FirstName", "LastName", "Email"]
    
    var test: String?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - UI Settings
    
    func setupUI() {
        
        tbvStudent.delegate = self
        tbvStudent.dataSource = self
        tbvStudent.register(UINib(nibName: ProductCell.identifier, bundle: nil),
                            forCellReuseIdentifier: ProductCell.identifier)
    }
    
    func setupNavigation() {
        
        navigationController?.navigationBar.barTintColor = .systemBlue
        btnRegist = UIBarButtonItem(title: "註冊", style: .done, target: self, action: #selector(regist))
        
        btnReload = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
        
        btnAdd = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .done, target: self, action: #selector(add))
        
        
        navigationItem.rightBarButtonItem = btnRegist
        navigationItem.leftBarButtonItems = [btnReload!, btnAdd!]
        navigationItem.rightBarButtonItem?.tintColor = .systemBlue
        title = "Home"
    }
    
    // MARK: - IBAction
    
    @objc func regist() {
        let vc = RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func reload() {
        
        NetworkManager.requestData(method: .get, 
                                   http: .http,
                                   server: NetworkServer.localServer,
                                   path: ApiPathConstants.student.rawValue,
                                   parameter: Empty(),
                                   token: UserPreferences.shared.jwtToken) {
            (result: Result<[StudentResponse], Error>) in
            switch result {
            case .success(let student):
                self.students = student
                DispatchQueue.main.async {
                    self.tbvStudent.reloadData()
                }
                print(self.students ?? [])
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func add() {
        Alert().showInputAlert(vc: self,
                               title: "Add Student",
                               message: "輸入學生資料",
                               placeholders: placeHolders,
                               onConfirm: { inputs in
            
            let request = studentRegisterRequest(firstName: inputs[0],
                                          lastName: inputs[1],
                                          email: inputs[2])
            
            NetworkManager.requestData(method: .post,
                                       http: .http,
                                       server: NetworkServer.localServer,
                                       path: ApiPathConstants.studentRegister.rawValue,
                                       parameter: request,
                                       token: UserPreferences.shared.jwtToken){ (result: Result<NoData, Error>) in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.reload()
                        Alert().showAlert(title: "Success", message: "Register Success", vc: self)
                    }
                    print("Form submitted successfully")
                    
                case .failure(let error):
                    print(error)
                }
            }
        })
    }
}
// MARK: - Extension

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return "Product"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvStudent.dequeueReusableCell(withIdentifier: ProductCell.identifier,
                                                  for: indexPath) as! ProductCell
        cell.lbFirstName.text = students?[indexPath.row].firstName
        cell.lbLastName.text = students?[indexPath.row].lastName
        cell.lbEmail.text = students?[indexPath.row].email
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { (_, _, completionHandler) in
            
            guard let deleteId = self.students?[indexPath.row].id else { return }
            let request = studentDeleteRequest(id: deleteId)
            
            NetworkManager.requestData(method: .delete,
                                       http: .http,
                                       server: NetworkServer.localServer,
                                       path: ApiPathConstants.student.rawValue,
                                       parameter: request,
                                       token: UserPreferences.shared.jwtToken) { (result: Result<NoData, Error>) in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self.students?.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            completionHandler(true)
        }
        deleteAction.backgroundColor = UIColor.red
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let editAction = UIContextualAction(style: .normal, title: "edit") {(_, _, completionHandler) in
            
            Alert().showInputAlert(vc: self,
                                   title: "Edit Student",
                                   message: "編輯學生個人資料",
                                   placeholders: ["FirstName", "LastName", "Email"], onConfirm:  { inputs in
                
                let firstName = inputs[0].isEmpty ? self.students?[indexPath.row].email : inputs[0]
                let lastName = inputs[1].isEmpty ? self.students?[indexPath.row].email : inputs[1]
                let email = inputs[2].isEmpty ? self.students?[indexPath.row].email : inputs[2]
                
                NetworkManager.requestData(method: .put,
                                           http: .http,
                                           server: NetworkServer.localServer,
                                           path: ApiPathConstants.student.rawValue,
                                           parameter: studentUpdateRequest(id: self.students?[indexPath.row].id ?? 0, 
                                                                    firstName: firstName ?? "",
                                                                    lastName: lastName ?? "",
                                                                    email: email ?? ""),
                                           token: UserPreferences.shared.jwtToken) { (result: Result<NoData, Error>) in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self.reload()
                            Alert().showAlert(title: "Success", message: "Edit Success", vc: self)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            })
            completionHandler(true)
        }
        editAction.backgroundColor = UIColor.systemGreen
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [editAction])
        return swipeConfiguration
    }
}
// MARK: - Protocol


