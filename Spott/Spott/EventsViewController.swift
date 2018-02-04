//
//  EventsViewController.swift
//  test2
//
//  Created by Brendan Sanderson on 2/2/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import UIKit

class EventsViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
       self.title = "Events";
        self.tableView.backgroundColor = UIColor.black
        self.tableView.rowHeight = C.h*0.25
        self.tableView.separatorColor = UIColor.black
        //        self.navigationController?.navigationBar.titleTextAttributes =
        //            [NSAttributedStringKey.font: UIFont(name: "Chalkduster", size: 27)!,
        //             NSAttributedStringKey.foregroundColor: UIColor.black]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        NSLog("get cell")
        let cell = EventTableCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        //cell.textLabel!.text = "foo"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

