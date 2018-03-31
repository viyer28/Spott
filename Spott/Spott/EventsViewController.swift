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
    var mapButton: UIButton!
    var eventsButton: UIButton!
    var spottButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: CGRect(x: 0, y: C.h*0.15, width: C.w, height: C.h*0.85))
        self.tableView.delegate = self
        self.view.backgroundColor = UIColor.white
        tableView.dataSource = self
        self.tableView.rowHeight = C.h*0.2
        tableView.allowsSelection = false;
        self.tableView.separatorColor = UIColor.white
        self.view.addSubview(tableView)
        let locationLabel = UILabel(frame: CGRect(x: 0, y: C.h*0.05, width: C.w, height: C.h*0.1))
        locationLabel.textAlignment = .center
        locationLabel.font = UIFont(name: "FuturaPT-Light", size: 30)
        locationLabel.text = "friday, march 3"
        self.view.addSubview(locationLabel)
        addNav()
        
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
    
    func addNav()
    {
        self.spottButton = UIButton(type: UIButtonType.custom) as UIButton
        self.mapButton = UIButton(type: UIButtonType.custom) as UIButton
        self.eventsButton = UIButton(type: UIButtonType.custom) as UIButton
        let mImage = UIImage(named: "MapIcon") as UIImage?
        mapButton.frame = CGRect(x: C.w*0.85, y: C.w*0.1, width: C.w * 0.1, height: C.w * 0.1)
        mapButton.center = CGPoint(x: C.w*0.5, y: C.h*0.95)
        mapButton.setImage(mImage, for: .normal)
        mapButton.backgroundColor = UIColor.white
        mapButton.layer.cornerRadius = mapButton.frame.width/2
        mapButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        mapButton.clipsToBounds = true
        mapButton.addTarget(self, action: #selector(clickMap), for: UIControlEvents.touchUpInside)
        self.view.addSubview(mapButton)
        
        var eImage = UIImage(named: "EventsIcon") as UIImage?
        eImage = eImage?.withRenderingMode(.alwaysTemplate)
        eventsButton.frame = CGRect(x: 0, y: 0, width: C.w * 0.1, height: C.w * 0.1)
        eventsButton.center = CGPoint(x: C.w*0.25, y: C.h*0.95)
        eventsButton.setImage(eImage, for: .normal)
        eventsButton.backgroundColor = UIColor.white
        eventsButton.imageView?.tintColor = C.eventLightBlueColor
        eventsButton.layer.cornerRadius = mapButton.frame.width/2
        eventsButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        eventsButton.clipsToBounds = true
        eventsButton.addTarget(self, action: #selector(clickEvents), for: UIControlEvents.touchUpInside)
        self.view.addSubview(eventsButton)
        
        let sImage = UIImage(named: "PeopleIcon") as UIImage?
        spottButton.frame = CGRect(x: C.w*0.85, y: C.w*0.1, width: C.w * 0.1, height: C.w * 0.1)
        spottButton.center = CGPoint(x: C.w*0.75, y: C.h*0.95)
        spottButton.backgroundColor = UIColor.white
        spottButton.layer.cornerRadius = mapButton.frame.width/2
        spottButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        spottButton.setImage(sImage, for: .normal)
        spottButton.clipsToBounds = true
        spottButton.addTarget(self, action: #selector(clickSpott), for: UIControlEvents.touchUpInside)
        self.view.addSubview(spottButton)
        
    }
    
    @objc func clickMap ()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func clickSpott()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func clickEvents()
    {
    }
    
}

