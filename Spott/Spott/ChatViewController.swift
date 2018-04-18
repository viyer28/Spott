//
//  ChatViewController.swift
//  Spott
//
//  Created by Brendan Sanderson on 3/27/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import JSQMessagesViewController
class ChatViewController: JSQMessagesViewController
{
    var messages: [JSQMessage]!
    var user_id1 = Auth.auth().currentUser!.uid
    var user_id2 = "9i3QV80AkXWBdboBHztm0B03nCk2"
    var name1 = C.user.name
    var name2 = "Griffon"
    var docid: String!
    var parentView: UIView!
    var messagesDict: [Dictionary<String, Any>]!
    
    convenience init (pv: UIView, u2: User)
    {
        self.init()
        self.user_id2 = u2.id
        self.name2 = u2.name
        self.parentView = pv
    }
    
    convenience init (uid2: String, n2: String)
    {
        self.init()
        user_id2 = uid2
        name2 = n2
    }
    override func viewDidLoad()
    {
        self.senderId = Auth.auth().currentUser!.uid
        self.senderDisplayName = C.user.name
        super.viewDidLoad()
        messages = []
        checkUserFirst()
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
    }
    func checkUserFirst()
    {
        C.dbChat.whereField("user_id1", isEqualTo: user_id1).whereField("user_id2", isEqualTo: user_id2).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Recieved documents")
                if querySnapshot!.documents.count == 0
                {
                    self.checkUserSecond()
                }
                for document in querySnapshot!.documents {
                    self.docid = document.documentID
                    let _ = C.dbChat.document(self.docid).addSnapshotListener { documentSnapshot, error in
                        guard let document = documentSnapshot else {
                            print("Error fetching document: \(error!)")
                            return
                        }
                        self.parseMessages(doc: document.data()!)
                    }
                    self.parseMessages(doc: document.data())
                }
            }
        }
    }
    func checkUserSecond()
    {
        C.dbChat.whereField("user_id1", isEqualTo: user_id2).whereField("user_id2", isEqualTo: user_id1).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Recieved documents")
                if querySnapshot!.documents.count == 0
                {
                    self.addChatObject()
                }
                for document in querySnapshot!.documents {
                    self.docid = document.documentID
                    _ = C.dbChat.document(self.docid).addSnapshotListener { documentSnapshot, error in
                        guard let document = documentSnapshot else {
                            print("Error fetching document: \(error!)")
                            return
                        }
                        self.parseMessages(doc: document.data()!)
                    }
                    self.parseMessages(doc: document.data())
                }
            }
        }
    }
    func addChatObject()
    {
        var ref: DocumentReference? = nil
        ref = C.dbChat.addDocument(data: [
            "user_id1" : user_id1,
            "user_id2" : user_id2,
            "messages" : []
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Added Document succesfully")
            }
        }
        self.messagesDict = []
        self.docid = ref?.documentID
        let _ = C.dbChat.document(docid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            self.parseMessages(doc: document.data()!)
        }
    }
    func parseMessages(doc: Dictionary<String, Any>)
    {
        
        messagesDict = doc["messages"] as! [Dictionary<String, Any>]
        messages = []
        for md in messagesDict
        {
            let sender = md["sender"] as! String
            let message = md["message"] as! String
            var name = name2
            if sender == user_id1
            {
                name = name1!
            }
            let m = JSQMessage(senderId: sender, displayName: name, text: message)
            messages.append(m!)
        }
        self.collectionView.collectionViewLayout.invalidateLayout()
        self.collectionView.reloadData()
        self.collectionView.setNeedsLayout()
        self.collectionView.layoutIfNeeded()
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    override func textViewDidBeginEditing(_ textView: UITextView) {
        if parentView.isKind(of: UserAtLocCalloutView.self)
        {
            parentView.frame = CGRect(x: 0, y: C.h*0.1, width: C.w, height: C.h*0.8)
            self.view.frame = CGRect(x: 0, y: C.h*0.15, width: C.w, height: C.h*0.65)
        }
        else
        {
            parentView.frame = CGRect(x: 0, y: C.h*0.15, width: C.w, height: C.h*0.75)
            self.view.frame = CGRect(x: 0, y: C.h*0.05, width: C.w, height: C.h*0.7)
        }
        //C.navigationViewController.sea
        super.textViewDidBeginEditing(textView)
    }
    override func textViewDidEndEditing(_ textView: UITextView) {
        if parentView.isKind(of: UserAtLocCalloutView.self)
        {
            parentView.frame = CGRect(x: 0, y: C.h*0.45, width: C.w, height: C.h*0.45)
            self.view.frame = CGRect(x: 0, y: C.h*0.15, width: C.w, height: C.h*0.3)
        }
        else
        {
            parentView.frame = CGRect(x: 0, y: C.h*0.575, width: C.w, height: C.h*0.35)
            self.view.frame = CGRect(x: 0, y: C.h*0.05, width: C.w, height: C.h*0.3)
        }
        super.textViewDidEndEditing(textView)
    }
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: C.goldishColor)
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        return messages[indexPath.item].senderId == user_id1 ? outgoingBubble : incomingBubble
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        
        let message = ["sender": senderId, "message": text]
        messagesDict.append(message as Any as! [String : Any])
        
        C.dbChat.document(docid).updateData(["messages":messagesDict])
        
        finishSendingMessage()
    }
    
}

