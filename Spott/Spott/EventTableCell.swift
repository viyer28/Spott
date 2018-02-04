//
//  eventTableCell.swift
//  Spott
//
//  Created by Brendan Sanderson on 2/4/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation
import UIKit

class EventTableCell: UITableViewCell {
    
    var rightView: UIView!
    var wholeView: UIView!
    var dayLabel: UILabel!
    var dateLabel: UILabel!
    var timeLabel: UILabel!
    var titleLabel: UILabel!
    var locationLabel: UILabel!
    var locationImage: UIImageView!
    var friendImage1: UIImageView!
    var friendImage2: UIImageView!
    var dotLabel: UILabel!
    var goingLabel:UILabel!
    var friendsGoing = 3
    var going = 123
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.black
        self.separatorInset = UIEdgeInsets.zero;
        self.frame = CGRect(x: 0, y: 0, width: C.w, height:C.h*0.25)
        wholeView = UIView(frame: CGRect(x: self.frame.width*0.1, y: self.frame.height*0.1, width: self.frame.width*0.8, height: self.frame.height*0.8))
        wholeView.backgroundColor = UIColor.blue
        wholeView.layer.cornerRadius = wholeView.frame.size.width / 15;
        rightView = UIView(frame: CGRect(x: self.frame.width*0.35, y: self.frame.height*0.1, width: self.frame.width*0.55, height: self.frame.height*0.8))
        rightView.layer.cornerRadius = wholeView.frame.size.width / 15;
        rightView.backgroundColor = UIColor.white
        self.contentView.addSubview(wholeView)
        self.contentView.addSubview(rightView)
        
        dayLabel = UILabel(frame: CGRect(x: wholeView.frame.size.width*0.05, y: wholeView.frame.height*0.2, width: wholeView.frame.size.width*0.2, height: wholeView.frame.height * 0.2))
        dayLabel.textColor = UIColor.white
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont(name: "Futura", size: 12)
        dayLabel.text="Today"
        
        dateLabel = UILabel(frame: CGRect(x: wholeView.frame.size.width*0.05, y: wholeView.frame.height*0.4, width: wholeView.frame.size.width*0.2, height: wholeView.frame.height * 0.2))
        dateLabel.textColor = UIColor.white
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont(name: "Futura", size: 12)
        dateLabel.text="Feb. 4"
        
        timeLabel = UILabel(frame: CGRect(x: wholeView.frame.size.width*0.05, y: wholeView.frame.height * 0.6, width: wholeView.frame.size.width*0.2, height: wholeView.frame.height * 0.2))
        timeLabel.textColor = UIColor.white
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont(name: "Futura", size: 12)
        timeLabel.text="3:00 pm"
        
        wholeView.addSubview(dayLabel)
        wholeView.addSubview(dateLabel)
        wholeView.addSubview(timeLabel)
        
        let rw = rightView.frame.width
        let rh = rightView.frame.height
        
        titleLabel = UILabel(frame: CGRect(x: rw*0.1, y: rh * 0.1, width: rw*0.8, height: rh * 0.2))
        titleLabel.textColor = UIColor.blue
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "Futura", size: 12)
        titleLabel.text="Physics Study Group"
        
        locationLabel = UILabel(frame: CGRect(x: rw*0.3, y: rh * 0.7, width: rw*0.5, height: rh * 0.2))
        locationLabel.textColor = UIColor.blue
        locationLabel.textAlignment = .center
        locationLabel.font = UIFont(name: "Futura", size: 12)
        locationLabel.text="Reg Library"
        
        locationImage = UIImageView(frame:CGRect(x: rw*0.2, y: rh * 0.8-rw * 0.05, width: rw * 0.1, height: rw * 0.1))
        locationImage.image = UIImage(named: "eventPinIcon")
        
        if(friendsGoing > 0)
        {
            friendImage1 = UIImageView(frame:CGRect(x: rw*0.05, y: rh * 0.5-rw*0.075, width: rw * 0.15, height: rw * 0.15))
            friendImage1.layer.cornerRadius = friendImage1.frame.size.width / 2;
            friendImage1.clipsToBounds = true;
            friendImage1.image = UIImage(named: "sample_prof")
            rightView.addSubview(friendImage1)
        }
        if (friendsGoing > 1)
        {
            friendImage2 = UIImageView(frame:CGRect(x: rw*0.25, y: rh * 0.5-rw*0.075, width: rw * 0.15, height: rw * 0.15))
            friendImage2.layer.cornerRadius = friendImage1.frame.size.width / 2;
            friendImage2.clipsToBounds = true;
            friendImage2.image = UIImage(named: "sample_prof")
            rightView.addSubview(friendImage2)
        }
        if (friendsGoing > 2)
        {
            dotLabel = UILabel(frame: CGRect(x: rw*0.4, y: rh * 0.5-rw*0.05, width: rw * 0.15, height: rw * 0.15))
            dotLabel.textColor = UIColor.blue
            dotLabel.textAlignment = .center
            dotLabel.font = UIFont(name: "Futura", size: 12)
            dotLabel.text="..."
            rightView.addSubview(dotLabel)
        }
        
        goingLabel = UILabel(frame: CGRect(x: rw*0.075+(rw*0.15*CGFloat(min(friendsGoing, 3))), y: rh * 0.5-rw*0.05, width: rw * 0.325, height: rw * 0.15))
        goingLabel.textColor = UIColor.blue
        goingLabel.textAlignment = .left
        goingLabel.font = UIFont(name: "Futura", size: 12)
        goingLabel.text = String(going) + " going"
        rightView.addSubview(goingLabel)
        
        rightView.addSubview(titleLabel)
        rightView.addSubview(locationLabel)
        rightView.addSubview(locationImage)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
