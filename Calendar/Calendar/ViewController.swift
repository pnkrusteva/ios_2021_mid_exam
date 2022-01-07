//
//  ViewController.swift
//  Calendar
//
//  Created by Petya Krysteva on 7.01.22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var calendarView: CalеndarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let frame = CGRect(x: 0, y: 0, width: calendarView.frame.width, height:calendarView.frame.height)
        let cv = CalеndarView(date: Date(), withFrame: frame)
        cv.show(in: calendarView, withHandler: { retOK, year, month, day in
          
            if retOK {
                let calendar = Calendar(identifier: .gregorian)
                var components = DateComponents()
                components.year = year
                components.month = month
                components.day = day
                components.hour = 23
                components.minute = 59
                components.second = 59
                let date = calendar.date(from: components)
            }
        })
    }


}

