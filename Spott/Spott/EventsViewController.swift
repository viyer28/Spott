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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: CGRect(x: 0, y: C.h*0.15, width: C.w, height: C.h*0.85))
        self.tableView.delegate = self
        self.view.backgroundColor = UIColor.white
        tableView.dataSource = self
        self.tableView.rowHeight = C.h*0.2
        tableView.allowsSelection = false;
        self.tableView.separatorColor = UIColor.white
        //self.view.addSubview(tableView)
        let locationLabel = UILabel(frame: CGRect(x: 0, y: C.h*0.05, width: C.w, height: C.h*0.1))
        locationLabel.textAlignment = .center
        locationLabel.font = UIFont(name: "FuturaPT-Light", size: 30)
        locationLabel.text = "events"
        //self.view.addSubview(locationLabel)
        
        let comingSoonLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        comingSoonLabel.center = CGPoint(x: C.w*0.5, y: C.h*0.5)
        comingSoonLabel.font = UIFont(name: "FuturaPT-Light", size: 18.0)
        comingSoonLabel.text = "events are coming soon"
        comingSoonLabel.textAlignment = .center
        self.view.addSubview(comingSoonLabel)
        
        //        self.navigationController?.navigationBar.titleTextAttributes =
        //            [NSAttributedStringKey.font: UIFont(name: "Chalkduster", size: 27)!,
        //             NSAttributedStringKey.foregroundColor: UIColor.black]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return C.events.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("get cell")
        let cell = EventTableCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell", event: C.events[indexPath.row], row: indexPath.row)
        //cell.textLabel!.text = "foo"
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

