//
//  Notification.swift
//  Geofencing
//
//  Created by Abisola Adeniran on 2016-12-02.
//  Copyright © 2016 Abisola Adeniran. All rights reserved.
//

import UIKit

@IBDesignable
class NotificationView: UINavigationBar{
    
    override init(frame: CGRect){
        super.init(frame: frame)
        self.initializeViews()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        self.initializeViews()
    }
    
    private func initializeViews(){
    
     self.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 160.0)
    }
    
}
