//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages : [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        navigationItem.title = K.appName
        // tableView.delegate = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
        
    }
    
    func loadMessages(){
        
        
  
        
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
            
            self.messages = []
            if let e = error{
                print("There was a problem fetching Data \(e)")
            }else{
                if let snapshotDocumet = querySnapshot?.documents{
                    
                    for doc in snapshotDocumet{
                        let data = doc.data()
                        print(data)
                        if let sender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String{
                            self.messages.append(Message(sender: sender, body: messageBody))
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
        
        
        // To get a the snapshop of the document once and not when its changed us GET DOCUMENT
//        db.collection(K.FStore.collectionName).getDocuments { querySnapshot, error in
//            if let e = error{
//                print("There was a problem fetching Data \(e)")
//            }else{
//                if let snapshotDocumet = querySnapshot?.documents{
//                    for doc in snapshotDocumet{
//                        let data = doc.data()
//                        if let sender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String{
//                            self.messages.append(Message(sender: sender, body: messageBody))
//                            DispatchQueue.main.async {
//                                self.tableView.reloadData()
//                            }
//                        }
//                    }
//                }
//            }
//        }
        
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        if let messageSender = Auth.auth().currentUser?.email, let messageBody = messageTextfield.text{
            //created a collection with name messages(in our K struct), then add Document
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField : messageSender,
                                                                      K.FStore.bodyField : messageBody,
                                                                      K.FStore.dateField : Date().timeIntervalSince1970
                                                                     ]) { error in
                if let e = error{
                    print("There was an Issue saving data to FireStore \(e)")
                }else{
                    print("Successfully Saved Data")
                    
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                    
                    
                }
            }
        }
        
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
    }
    
    
}

extension ChatViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        // The cells will be populated according to the given Array
        // Now we can use the variables form the MessageCell View Controller as we casted our cell as Message Cell
        
        let message = messages[indexPath.row]
        // This is the message from the current user
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messagebubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor.black
            
        }else{
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messagebubble.backgroundColor = UIColor(named: K.BrandColors.lighBlue)
            cell.label.textColor = UIColor.black
            
        }
        cell.label.text = message.body
        
        
        
        return cell
        
    }
    
    
}



// For Interacation with the Table, such as touching a row, pressing an element
//extension ChatViewController : UITableViewDelegate{
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
//
//}
