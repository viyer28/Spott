//
//  MatchViewController.swift
//  Spott
//
//  Created by Brendan Sanderson on 2/16/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation
import UIKit

class MatchProflieView : UIView, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView
    override init (frame : CGRect) {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        let th = (C.w + C.h*3)) * 0.8
        let tw = C.w * 0.8
        let x  = C.w * 0.1
        let y = C.h - (C.w + C.h*3)) * 0.1
        let frame = CGRect(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        super.init(frame : frame)
        self.layer.borderWidth = 2.0 as CGFloat
        self.layer.borderColor = UIColor(red:213.0/255.0, green:177.0/255.0, blue:132.0/255.0, alpha:1.0) as! CGColor
        self.tableView.backgroundColor = UIColor.white
        tableView.allowsSelection = false;
        self.tableView.separatorColor = UIColor.black
        tableView.separatorInset = UIEdgeInsets.zero;
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.separatorInset = UIEdgeInsets.zero;
        //cell.textLabel!.text = "foo"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}


