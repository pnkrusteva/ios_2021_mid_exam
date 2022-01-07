//
//  Model.swift
//  Calendar
//
//  Created by Petya Krysteva on 7.01.22.
//

import UIKit

struct Month {
    let date: String
    var events: [Event] = []
}

struct Event {
    let date: String
    let time: Int   //00:00 is 0 ... 23:45 is 2345
    let title: String
    let notes: String
}

struct Model {
    let month = Month(
        date: "2022-01-06",
        events: [
            Event(date:"2022-01-06", time: 1800, title: "Swift Mid-term Exam", notes: "UIKit, Swift, UITableView, UICollectionView" ),
            Event(date:"2022-01-07", time: 1800, title: "Swift Mid-term Exam", notes: "UIKit, Swift, UITableView, UICollectionView" ),
            Event(date:"2022-01-10", time: 1800, title: "C++ Mid-term Exam", notes: "C++, Pointers" ),
            Event(date:"2022-01-16", time: 1000, title: "Calculus Final Exam", notes: "Simple Math" ),
            Event(date:"2022-01-26", time: 1800, title: "Calculus 2 Mid-term Exam", notes: "Advanced Calculus, FMI 325" ),
            Event(date:"2022-01-30", time: 1800, title: "Rust Mid-term Exam", notes: "Rust, C++" ),
            Event(date:"2022-01-31", time: 1800, title: "Java Final Exam", notes: "Java, Spring, Kotlin" ),
            Event(date:"2022-01-31", time: 2200, title: "HTML Final Project", notes: "HTML, Github" ),
            Event(date:"2022-01-31", time: 2300, title: "Session Final - Party", notes: "Fun, Friends, Freadom" )
        ]
    )
}
