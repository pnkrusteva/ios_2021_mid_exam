//
//  CalendarView.swift
//  Calendar
//
//  Created by Petya Krysteva on 7.01.22.
//

import UIKit

class CalеndarView: UIView {
    private var appDelegate: AppDelegate?
    //is the padding of the dayview on one given side
    private var dayViewPaddingSize = 0
    private var curYear = 0
    private var curMonth = 0
    private var curDay = 0
    private var labWidth: CGFloat = 0.0
    private var finishHandler: ((Bool, Int, Int, Int) -> Void)?

    @objc func show(in view: UIView?, withHandler handler: @escaping (Bool, Int, Int, Int) -> Void) {
        finishHandler = handler
        view?.addSubview(self)
        let frameEnd = contentView?.frame
        var frame = contentView?.frame
        frame!.origin.y = 200
        contentView?.frame = frame ?? CGRect.zero
        let color = backgroundColor
        backgroundColor = UIColor.clear
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.contentView?.frame = frameEnd ?? CGRect.zero
            self.backgroundColor = color
        }) { finished in
        }
    }

    @objc init(date showDate: Date?, withFrame frame: CGRect) {
        super.init(frame: frame)
        appDelegate = UIApplication.shared.delegate as? AppDelegate

        daysButtons = []
        dayViewPaddingSize = Int((self.frame.size.width - CGFloat(((15 + ROUND_BUTTON_SIZE) * 6)) - CGFloat(ROUND_BUTTON_SIZE)) / 2)
        configView(showDate, withFrame: frame)

        let rightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightHandler(_:)))
        rightGestureRecognizer.direction = .right
        contentView?.addGestureRecognizer(rightGestureRecognizer)

        let leftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftHandler(_:)))
        leftGestureRecognizer.direction = .left
        contentView?.addGestureRecognizer(leftGestureRecognizer)

    
    }

    var contentView: UIView?
    var closeButton: UIButton?
    var titleLabel: UILabel?
    var selectedDateLabel: UILabel?
    var topLine: UIView?
    var monthLabel: UILabel?
    var weekDayLabels: [AnyHashable]?
    var daysView: UIView?
    var daysButtons: [AnyHashable]?
    var leftButton: UIButton?
    var rightButton: UIButton?
    var bottomLine: UIView?
    var components: DateComponents?

    private var _eventDays: [AnyHashable]?
    var eventDays: [AnyHashable]? {
        get {
            _eventDays
        }
        set(eventDays) {
            _eventDays = eventDays
        }
    }

    //defines the size of the button
let ROUND_BUTTON_SIZE = 70
    //defines the vert gap of the buttons
let DAY_VERT_GAP = 60

    func configView(_ showDate: Date?, withFrame frame: CGRect) {
        let now = Calendar.current.dateComponents([.day, .month, .year], from: Date())

        if let showDate = showDate {
            components = Calendar.current.dateComponents([.day, .month, .year], from: showDate)
        }
        components?.day = 20
        var dateComponents: DateComponents? = nil
        if let showDate = showDate {
            dateComponents = Calendar.current.dateComponents([.day, .month, .year], from: showDate)
        }
        curDay = dateComponents?.day ?? 0
        curMonth = dateComponents?.month ?? 0
        curYear = dateComponents?.year ?? 0

        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)

        contentView = UIView()
        contentView?.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            contentView?.layer.masksToBounds = true
            contentView?.layer.cornerRadius = 20
            contentView?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        if let contentView = contentView {
            addSubview(contentView)
        }

        
        
        titleLabel = UILabel(frame: CGRect(x: 10, y:10, width: frame.size.width - 2 * (closeButton?.frame.size.width ?? 0.0), height: 40))
        titleLabel?.text = "Calendar"
        titleLabel?.textColor = UIColor(red: 123 / 255.0, green: 123 / 255.0, blue: 136 / 255.0, alpha: 1.0)
        titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
        titleLabel?.textAlignment = .center

        if let titleLabel = titleLabel {
            contentView?.addSubview(titleLabel)
        }

        let selectedDateLabelY = (titleLabel?.frame.origin.y ?? 0) + (titleLabel?.frame.height ?? 0)
        selectedDateLabel = UILabel(frame: CGRect(x: 0, y: selectedDateLabelY, width: frame.size.width, height: 28))
        selectedDateLabel?.text = String(format: "%ld %@ %ld", curDay, monthNum(toString: curMonth) ?? "", curYear)
        selectedDateLabel?.textColor = UIColor(red: 123 / 255.0, green: 123 / 255.0, blue: 136 / 255.0, alpha: 1.0)
        selectedDateLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 17)
        selectedDateLabel?.textAlignment = .center
        if let selectedDateLabel = selectedDateLabel {
            contentView?.addSubview(selectedDateLabel)
        }

        let topLineY = (selectedDateLabel?.frame.origin.y ?? 0) + (selectedDateLabel?.frame.height ?? 0) + 5
        topLine = UIView(frame: CGRect(x: 16, y: topLineY, width: self.frame.size.width - 32, height: 1))
        topLine?.backgroundColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 244 / 255.0, alpha: 1.0)
        if let topLine = topLine {
            contentView?.addSubview(topLine)
        }
        
        let leftButtonY = (topLine?.frame.origin.y ?? 0) + (topLine?.frame.height ?? 0) + 5
        leftButton = UIButton(frame: CGRect(x: 0, y: leftButtonY, width: 40, height: 40))
        leftButton?.setImage(UIImage(named: "ic_arrow_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton?.tintColor = UIColor(red: 123 / 255.0, green: 123 / 255.0, blue: 136 / 255.0, alpha: 1.0)
        //leftButton?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        if let leftButton = leftButton {
            contentView?.addSubview(leftButton)
        }

        rightButton = UIButton(frame: CGRect(x: frame.size.width - 40, y: leftButton?.frame.origin.y ?? 0, width: 40, height: 40))
        rightButton?.setImage(UIImage(named: "ic_arrow_right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        rightButton?.tintColor = UIColor(red: 123 / 255.0, green: 123 / 255.0, blue: 136 / 255.0, alpha: 1.0)
        //rightButton?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        if let rightButton = rightButton {
            contentView?.addSubview(rightButton)
        }

        monthLabel = UILabel(frame: CGRect(x: leftButton?.frame.size.width ?? 0.0, y: leftButton?.frame.origin.y ?? 0, width: frame.size.width - 2 * (leftButton?.frame.size.width ?? 0.0), height: 40))
        monthLabel?.textAlignment = .center
        monthLabel?.text = String(format: "%@ %ld", monthNum(toString: components?.month ?? 0) ?? "", Int(components?.year ?? 0))
        monthLabel?.textColor = UIColor(red: 123 / 255.0, green: 123 / 255.0, blue: 136 / 255.0, alpha: 1.0)
        monthLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
        monthLabel?.textAlignment = .center
        if let monthLabel = monthLabel {
            contentView?.addSubview(monthLabel)
        }

        let weekDays = ["Sunday", "Monday", "Tuesday","Wednesday","Thursday","Friday","Saturday"]
        labWidth = frame.size.width / CGFloat(weekDays.count)
        let weekDayY = (monthLabel?.frame.origin.y ?? 0) + (monthLabel?.frame.height ?? 0)
        for i in 0..<weekDays.count {
            let weekDay = UILabel(frame: CGRect(x: CGFloat(i) * labWidth, y: weekDayY, width: labWidth, height: 20))
            weekDay.text = weekDays[i]
            weekDay.font = UIFont(name: "HelveticaNeue-Light", size: 12)
            weekDay.textColor = UIColor(red: 123 / 255.0, green: 123 / 255.0, blue: 136 / 255.0, alpha: 1.0)
            weekDay.textAlignment = .center
            contentView?.addSubview(weekDay)
        }

        let daysViewY = weekDayY + 20//WeekDay height
        daysView = UIView(frame: CGRect(x: 0, y: daysViewY, width: self.frame.size.width, height: 400))
        daysView?.backgroundColor = UIColor.white

        fillDaysView(now, withDaysView: daysView, withNumDays: getNumOfDays(forDate: now))
        if let daysView = daysView {
            contentView?.addSubview(daysView)
        }
        
        let bottomLineY = (daysView?.frame.origin.y ?? 0.0) + (daysView?.frame.height ?? 0.0)
        bottomLine = UIView(frame: CGRect(x: 16, y: bottomLineY, width: self.frame.size.width - 32, height: 1))
        bottomLine?.backgroundColor = UIColor(red: 239 / 255.0, green: 239 / 255.0, blue: 244 / 255.0, alpha: 1.0)
        if let bottpmLine = bottomLine {
            contentView?.addSubview(bottpmLine)
        }
        
        



        contentView?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }

    @objc func swipeRightHandler(_ recognizer: UISwipeGestureRecognizer?) {
        if components?.month == 1 {
            components?.month = 12
            let y = (components?.year ?? 0)
            components?.year = y - 1
        } else {
            let m = (components?.month ?? 0)
            components?.month = m - 1
        }
        removeMonthLabel(forNewMonth: components?.year ?? 0, month: components?.month ?? 0, directionForward: false)
        switchMonth(forNewMonth: components, directionForward: false)
    }

    @objc func swipeLeftHandler(_ recognizer: UISwipeGestureRecognizer?) {
        if components?.month == 12 {
            components?.month = 1
            let y = (components?.year ?? 0)
            components?.year = y + 1
        } else {
            let m = (components?.month ?? 0)
            components?.month = m + 1
        }
        removeMonthLabel(forNewMonth: components?.year ?? 0, month: components?.month ?? 0, directionForward: true)
        switchMonth(forNewMonth: components, directionForward: true)
    }

    func fillDaysView(_ currentDate: DateComponents?, withDaysView daysView: UIView?, withNumDays numDays: Int) {
        let firstWeekOffset = getDaysOffset(forDate: currentDate)
        var dayIndicator = firstWeekOffset
        print(String(format: "%ld", firstWeekOffset))
        var posX = 0
        var posY = 10

        for _ in 0..<firstWeekOffset {
            posX += Int(labWidth)
        }

        for i in 0..<numDays {
            if let day = dayButton(CGRect(x: CGFloat(posX) + (labWidth - CGFloat(ROUND_BUTTON_SIZE)) / 2, y: CGFloat(posY), width: CGFloat(ROUND_BUTTON_SIZE), height: CGFloat(ROUND_BUTTON_SIZE)), withDay: i + 1) {
                daysButtons?.append(day)
            }
            if let last = daysButtons?.last as? UIView {
                daysView?.addSubview(last)
            }
            dayIndicator += 1
            posX += Int(labWidth)
            if dayIndicator > 6 {
                posX = 0
                posY += DAY_VERT_GAP
                dayIndicator = 0
            }
        }
    }

    func removeMonthLabel(forNewMonth newYear: Int, month newMonth: Int, directionForward forward: Bool) {
        if forward {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.monthLabel?.frame = CGRect(x: -(self.monthLabel?.frame.size.width ?? 0.0), y: self.monthLabel?.frame.origin.y ?? 0.0, width: self.monthLabel?.frame.size.width ?? 0.0, height: self.monthLabel?.frame.size.height ?? 0.0)
            }) { finished in
                self.monthLabel?.text = String(format: "%@ %ld", self.monthNum(toString: newMonth) ?? "", newYear)
                self.monthLabel?.frame = CGRect(x: 0 + (self.monthLabel?.frame.size.width ?? 0.0), y: self.monthLabel?.frame.origin.y ?? 0.0, width: self.monthLabel?.frame.size.width ?? 0.0, height: self.monthLabel?.frame.size.height ?? 0.0)
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.monthLabel?.frame = CGRect(x: CGFloat(self.dayViewPaddingSize), y: self.monthLabel?.frame.origin.y ?? 0.0, width: self.monthLabel?.frame.size.width ?? 0.0, height: self.monthLabel?.frame.size.height ?? 0.0)
                }) { finished in

                }
            }
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.monthLabel?.frame = CGRect(x: self.bounds.size.width + (self.monthLabel?.frame.size.width ?? 0.0) / 2, y: self.monthLabel?.frame.origin.y ?? 0.0, width: self.monthLabel?.frame.size.width ?? 0.0, height: self.monthLabel?.frame.size.height ?? 0.0)
            }) { finished in
                self.monthLabel?.text = String(format: "%@ %ld", self.monthNum(toString: newMonth) ?? "", newYear)
                self.monthLabel?.frame = CGRect(x: -(self.monthLabel?.frame.size.width ?? 0.0), y: self.monthLabel?.frame.origin.y ?? 0.0, width: self.monthLabel?.frame.size.width ?? 0.0, height: self.monthLabel?.frame.size.height ?? 0.0)
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.monthLabel?.frame = CGRect(x: CGFloat(self.dayViewPaddingSize), y: self.monthLabel?.frame.origin.y ?? 0.0, width: self.monthLabel?.frame.size.width ?? 0.0, height: self.monthLabel?.frame.size.height ?? 0.0)
                }) { finished in

                }
            }
        }
    }

    func switchMonth(forNewMonth date: DateComponents?, directionForward forward: Bool) {
        if forward {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.daysView?.frame = CGRect(x: -(self.daysView?.frame.size.width ?? 0.0), y: self.daysView?.frame.origin.y ?? 0.0, width: self.daysView?.frame.size.width ?? 0.0, height: self.daysView?.frame.size.height ?? 0.0)
            }) { finished in
                self.removeButtonsFromSuperView()
                self.daysView?.frame = CGRect(x: self.frame.size.width + (self.daysView?.frame.size.width ?? 0.0), y: self.daysView?.frame.origin.y ?? 0.0, width: self.daysView?.frame.size.width ?? 0.0, height: self.daysView?.frame.size.height ?? 0.0)
                self.fillDaysView(self.components, withDaysView: self.daysView, withNumDays: self.getNumOfDays(forDate: self.components))
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.daysView?.frame = CGRect(x: 0, y: self.daysView?.frame.origin.y ?? 0.0, width: self.daysView?.frame.size.width ?? 0.0, height: self.daysView?.frame.size.height ?? 0.0)
                }) { finished in

                }
            }
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.daysView?.frame = CGRect(x: self.frame.size.width + (self.daysView?.frame.size.width ?? 0.0) / 2, y: self.daysView?.frame.origin.y ?? 0.0, width: self.daysView?.frame.size.width ?? 0.0, height: self.daysView?.frame.size.height ?? 0.0)
            }) { finished in
                self.removeButtonsFromSuperView()
                self.daysView?.frame = CGRect(x: -(self.daysView?.frame.size.width ?? 0.0), y: self.daysView?.frame.origin.y ?? 0.0, width: self.daysView?.frame.size.width ?? 0.0, height: self.daysView?.frame.size.height ?? 0.0)
                self.fillDaysView(self.components, withDaysView: self.daysView, withNumDays: self.getNumOfDays(forDate: self.components))
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                    self.daysView?.frame = CGRect(x: 0, y: self.daysView?.frame.origin.y ?? 0.0, width: self.daysView?.frame.size.width ?? 0.0, height: self.daysView?.frame.size.height ?? 0.0)
                }) { finished in

                }
            }
        }
    }
    public func UIColorFromARGB(_ rgbValue: UInt32) -> UIColor {
        UIColor(red: CGFloat((Float((rgbValue & 0x00ff0000) >> 16)) / 255.0), green: CGFloat((Float((rgbValue & 0x0000ff00) >> 8)) / 255.0), blue: CGFloat((Float((rgbValue & 0x000000ff) >> 0)) / 255.0), alpha: CGFloat((Float((rgbValue & 0xff000000) >> 24)) / 255.0))
    }

    func dayButton(_ frame: CGRect, withDay dayNum: Int) -> UIButton? {
        let matRed = UIColor.clear
        let selColor = UIColorFromARGB(0xffb50900)
        let matText = UIColor(red: 123 / 255.0, green: 123 / 255.0, blue: 136 / 255.0, alpha: 1.0)
        let selText = UIColor.white

        let dayButton = UIButton(frame: frame)
        dayButton.layer.cornerRadius = CGFloat(Double(ROUND_BUTTON_SIZE) / 2.0)
        dayButton.setTitle("\(dayNum)", for: .normal)
        
        let events = appDelegate?.model?.month.events
        
        /*for event in events {
            
        }*/
        
        
        if dayNum == curDay && components?.month == curMonth && components?.year == curYear {
            dayButton.backgroundColor = selColor
            dayButton.setTitleColor(selText, for: .normal)
        } else {
            dayButton.backgroundColor = matRed
            dayButton.setTitleColor(matText, for: .normal)
        }

        return dayButton
    }
    
    



    func getNumOfDays(forDate comp: DateComponents?) -> Int {
        let c = Calendar.current
        var currentDate: Date? = nil
        if let comp = comp {
            currentDate = c.date(from: comp)
        }
        var days: Range<Int>? = nil
        if let currentDate = currentDate {
            days = c.range(of: Calendar.Component.day, in: Calendar.Component.month, for: currentDate)
        }
        return Int(days?.count ?? 0)
    }

    func getDaysOffset(forDate date: DateComponents?) -> Int {
        //1-7 sunday - saturday
        var date = date
        date?.day = 1

        let gregorian = Calendar(identifier: .gregorian)
        var weekdayComponents: DateComponents? = nil
        if let date = date, let date1 = gregorian.date(from: date) {
            weekdayComponents = gregorian.dateComponents([.day, .weekday], from: date1)
        }

        //0-6 offset
        return (weekdayComponents?.weekday ?? 0) - 1
    }


    func monthNum(toString num: Int) -> String? {
        switch num {
            case 1:
                return "January"
            case 2:
                return "February"
            case 3:
                return "March"
            case 4:
                return "April"
            case 5:
                return "May"
            case 6:
                return "text_june"
            case 7:
                return "July"
            case 8:
                return "August"
            case 9:
                return "September"
            case 10:
                return "October"
            case 11:
                return "November"
            case 12:
                return "December"
            default:
                return "null"
        }
    }

    func removeButtonsFromSuperView() {
        for i in 0..<(daysButtons?.count ?? 0) {
            (daysButtons?[i] as! UIView).removeFromSuperview()
        }
        daysButtons?.removeAll()
        daysButtons = []
    }

    func getbutton(forDay day: Int) -> UIButton? {
        return daysButtons?[day] as? UIButton
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
