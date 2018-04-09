//
//  eventTableCell.swift
//  Spott
//
//  Created by Brendan Sanderson on 2/4/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class EventTableCell: UITableViewCell {
    
    var rightView: UIView!
    var wholeView: UIView!
    var dayLabel: UILabel!
    var dateLabel: UILabel!
    var timeLabel: UILabel!
    var titleLabel: UILabel!
    var locationLabel: UILabel!
    var goingImage: UIImageView!
    var notGoingImage: UIImageView!
    var friendImage1: UIImageView!
    var friendImage2: UIImageView!
    var dotLabel: UILabel!
    var goingLabel:UILabel!
    var distanceLabel:UILabel!
    var event: Event!
    var friendsLabel:UILabel!
    var numFriendsLabel:UILabel!
    var potentialLabel:UILabel!
    var numPotentialLabel:UILabel!
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, event: Event, row: Int) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.separatorInset = UIEdgeInsets.zero;
        self.frame = CGRect(x: 0, y: 0, width: C.w, height:C.h*0.2)
        
        wholeView = UIView(frame: CGRect(x: self.frame.width*0.1, y: self.frame.height*0.05, width: self.frame.width*0.8, height: self.frame.height*0.9))
        wholeView.layer.cornerRadius = wholeView.frame.size.width / 15;
        let shadowView = UIView(frame: wholeView.frame)
        rightView = UIView(frame: CGRect(x: self.frame.width*0.35, y: self.frame.height*0.1, width: self.frame.width*0.55, height: self.frame.height*0.8))
        rightView.layer.cornerRadius = wholeView.frame.size.width / 15;
        self.wholeView.backgroundColor = UIColor.blue
        if row % 2 == 0
        {
            let blueGradient = CAGradientLayer()
            blueGradient.frame = wholeView.bounds
            blueGradient.locations = [0.0, 1.0]
            blueGradient.colors = [C.eventDarkBlueColor.cgColor, C.eventLightBlueColor.cgColor]
            wholeView.layer.addSublayer(blueGradient)
        }
        else
        {
            let brownGradient = CAGradientLayer()
            brownGradient.frame = wholeView.bounds
            brownGradient.colors = [C.eventDarkBrownColor.cgColor, C.eventLightBrownColor.cgColor]
            wholeView.layer.addSublayer(brownGradient)
        }
        wholeView.clipsToBounds = true
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: wholeView.layer.cornerRadius).cgPath
        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
        self.contentView.addSubview(shadowView)
        self.contentView.addSubview(wholeView)
        self.contentView.addSubview(rightView)
        
        dayLabel = UILabel(frame: CGRect(x: wholeView.frame.size.width*0.05, y: wholeView.frame.height*0.2, width: wholeView.frame.size.width*0.2, height: wholeView.frame.height * 0.2))
        dayLabel.textColor = UIColor.white
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont(name: "FuturaPT-Book", size: 12)
        
        dateLabel = UILabel(frame: CGRect(x: wholeView.frame.size.width*0.05, y: wholeView.frame.height*0.4, width: wholeView.frame.size.width*0.2, height: wholeView.frame.height * 0.2))
        dateLabel.textColor = UIColor.white
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont(name: "FuturaPT-Book", size: 12)
        
        timeLabel = UILabel(frame: CGRect(x: wholeView.frame.size.width*0.05, y: wholeView.frame.height * 0.6, width: wholeView.frame.size.width*0.2, height: wholeView.frame.height * 0.2))
        timeLabel.textColor = UIColor.white
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont(name: "FuturaPT-Book", size: 12)
        
        let rw = rightView.frame.width
        let rh = rightView.frame.height
        
        titleLabel = UILabel(frame: CGRect(x: rw*0.1, y: rh * 0.1, width: rw*0.8, height: rh * 0.2))
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "FuturaPT-Book", size: 12)
        
        locationLabel = UILabel(frame: CGRect(x: rw*0.3, y: rh * 0.7, width: rw*0.5, height: rh * 0.2))
        locationLabel.textColor = UIColor.white
        locationLabel.textAlignment = .center
        locationLabel.font = UIFont(name: "FuturaPT-Book", size: 12)
        
        //statusImage = UIImageView(frame:CGRect(x: rw*0.2, y: rh * 0.8-rw * 0.05, width: rw * 0.1, height: rw * 0.1))
        //statusImage.image = UIImage(named: "goingIcon")
        
        if(event.numFriends > 0)
        {
            friendImage1 = UIImageView(frame:CGRect(x: rw*0.05, y: rh * 0.5-rw*0.075, width: rw * 0.15, height: rw * 0.15))
            friendImage1.layer.cornerRadius = friendImage1.frame.size.width / 2;
            friendImage1.clipsToBounds = true;
            friendImage1.image = UIImage(named: "sample_prof")
            rightView.addSubview(friendImage1)
        }
        if (event.numFriends > 1)
        {
            friendImage2 = UIImageView(frame:CGRect(x: rw*0.25, y: rh * 0.5-rw*0.075, width: rw * 0.15, height: rw * 0.15))
            friendImage2.layer.cornerRadius = friendImage1.frame.size.width / 2;
            friendImage2.clipsToBounds = true;
            friendImage2.image = UIImage(named: "sample_prof")
            rightView.addSubview(friendImage2)
        }
        if (event.numFriends > 2)
        {
            dotLabel = UILabel(frame: CGRect(x: rw*0.4, y: rh * 0.5-rw*0.05, width: rw * 0.15, height: rw * 0.15))
            dotLabel.textColor = UIColor.white
            dotLabel.textAlignment = .center
            dotLabel.font = UIFont(name: "FFuturaPT-Book", size: 12)
            dotLabel.text="..."
            rightView.addSubview(dotLabel)
        }
        
        goingLabel = UILabel(frame: CGRect(x: rw*0.1+(rw*0.175*CGFloat(min(event.numFriends, 3))), y: rh * 0.35-rw*0.05, width: rw * 0.325, height: rw * 0.15))
        goingLabel.textColor = UIColor.white
        goingLabel.textAlignment = .left
        goingLabel.font = UIFont(name: "FuturaPT-Book", size: 10)
        
        let loccord = CLLocation(latitude: Double(event.location.latitude), longitude: Double(event.location.longitude))
        
        let distanceInMeters = C.navigationViewController.userLocation.distance(from: loccord)
        let distance = distanceInMeters/1609.344
        
        distanceLabel = UILabel(frame: CGRect(x: rw*0.8, y: rh * 0.9-rw*0.075, width: rw * 0.15, height: rw * 0.15))
        distanceLabel.textColor = UIColor.white
        distanceLabel.textAlignment = .left
        distanceLabel.font = UIFont(name: "FuturaPT-Book", size: 8)
        distanceLabel.text = String(format: "%.1f", distance) + " M"
        
        friendsLabel = UILabel(frame: CGRect(x: (rw*0.175*CGFloat(min(event.numFriends, 3))), y: rh * 0.525-rw*0.05, width: rw * 0.325, height: rw * 0.1))
        friendsLabel.textColor = UIColor.white
        friendsLabel.textAlignment = .center
        friendsLabel.font = UIFont(name: "FuturaPT-Book", size: 6)
        friendsLabel.text="Friends:"
        
        numFriendsLabel = UILabel(frame: CGRect(x: (rw*0.175*CGFloat(min(event.numFriends, 3))), y: rh * 0.625-rw*0.05, width: rw * 0.325, height: rw * 0.1))
        numFriendsLabel.textColor = UIColor.white
        numFriendsLabel.textAlignment = .center
        numFriendsLabel.font = UIFont(name: "FuturaPT-Book", size: 12)
        numFriendsLabel.text = String(event.numFriends)
        
        potentialLabel = UILabel(frame: CGRect(x: rw*0.15+(rw*0.175*CGFloat(min(event.numFriends, 3))), y: rh * 0.525-rw*0.05, width: rw * 0.325, height: rw * 0.1))
        potentialLabel.textColor = UIColor.white
        potentialLabel.textAlignment = .center
        potentialLabel.font = UIFont(name: "FuturaPT-Book", size: 6)
        potentialLabel.text="Potentials:"
        
        numPotentialLabel = UILabel(frame: CGRect(x: rw*0.15+(rw*0.175*CGFloat(min(event.numFriends, 3))), y: rh * 0.625-rw*0.05, width: rw * 0.325, height: rw * 0.1))
        numPotentialLabel.textColor = UIColor.white
        numPotentialLabel.textAlignment = .center
        numPotentialLabel.font = UIFont(name: "FuturaPT-Book", size: 12)
       
        dayLabel.text="Today"
        dateLabel.text="Feb. 4"
        timeLabel.text="3:00 pm"
        titleLabel.text = event.name
        locationLabel.text = event.location.name
        goingLabel.text = String(event.going) + " going"
        numFriendsLabel.text = "\(event.numFriends!)"
        numPotentialLabel.text = String(event.potentials)
        
        wholeView.addSubview(dayLabel)
        wholeView.addSubview(dateLabel)
        wholeView.addSubview(timeLabel)
        rightView.addSubview(goingLabel)
        rightView.addSubview(distanceLabel)
        rightView.addSubview(titleLabel)
        rightView.addSubview(locationLabel)
        // rightView.addSubview(statusImage)
        rightView.addSubview(friendsLabel)
        rightView.addSubview(numFriendsLabel)
        rightView.addSubview(potentialLabel)
        rightView.addSubview(numPotentialLabel)
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
