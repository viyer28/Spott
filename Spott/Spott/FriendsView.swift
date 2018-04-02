
//
//  File.swift
//  Spott
//
//  Created by Brendan Sanderson on 3/31/18.
//  Copyright © 2018 Brendan Sanderson. All rights reserved.
//

import Foundation

class FriendsView : UIView
{
    override init (frame : CGRect) {
        super.init(frame: frame)
    }
    convenience init() {
        self.init(frame: CGRect(x: C.w * 0.6, y: 0, width: C.w*0.4, height: C.h))
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = self.frame.height / 15
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
