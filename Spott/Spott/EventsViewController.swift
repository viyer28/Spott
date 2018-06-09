//
//  EventsViewController.swift
//  test2
//
//  Created by Brendan Sanderson on 2/2/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var tableView: UITableView!
    var userView: LeaderView!
    var userRank = -1
    var updateLeaderboardTime = NSDate()
    override func viewDidLoad() {
        super.viewDidLoad()
        //let blankView = UIView(frame: CGRect(x: 0, y: 0, width: C.w, height: C.h))
        //blankView.backgroundColor = .white
        //self.view.addSubview(blankView)
        self.tableView = UITableView(frame: CGRect(x: C.w*0.1, y: C.h*0.15, width: C.w*0.8, height: C.h*0.625))
        self.tableView.delegate = self
        self.view.backgroundColor = UIColor.clear
        tableView.dataSource = self
        self.tableView.rowHeight = C.h*0.075
        tableView.allowsSelection = false;
        self.tableView.separatorColor = C.goldishColor
        tableView.separatorInset = UIEdgeInsets.zero;
        self.tableView.layer.borderWidth = 1
        self.tableView.layer.borderColor = C.goldishColor.cgColor
        self.view.addSubview(tableView)
      
        
        userView = LeaderView(frame: CGRect(x: C.w * 0.1, y: C.h*0.775, width: C.w*0.8, height: tableView.rowHeight), leader: C.leader, rank: 1)
        self.view.addSubview(userView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
        if NSDate().timeIntervalSince(updateLeaderboardTime as Date) >= 300
        {
            C.getLeaderboardUsers()
            updateLeaderboardTime = NSDate()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for l in C.leaders {
            if l.name == C.leader.name
            {
                C.leader.score = l.score
                userRank = C.leaders.index(of: l)!
                self.userView.rankLabel.text = String(userRank+1)
            }
        }
        return C.leaders.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("get cell")
        let cell = LeaderTableCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell", leader: C.leaders[indexPath.row], row: indexPath.row)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
}

