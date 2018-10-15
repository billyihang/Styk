//
//  FirstViewController.swift
//  Styk
//
//  Created by William Yang on 8/1/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import UIKit
import CoreData

protocol CurrentTaskViewDelegate: class {
    func updateTask(_ task: Task)
}

class FirstViewController: UIViewController, CurrentTaskDelegate {
    

    // MARK: - IBOutlet properties
    @IBOutlet weak var line: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var taskCountLabel: UILabel!
    //@IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var taskView: UIView!
    @IBOutlet weak var AMLabel: UILabel!
    
    // MARK: - Variables
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchedRC: NSFetchedResultsController<Task>!
    var clockLayer: CAShapeLayer = CAShapeLayer()
    var lineLayer = CAShapeLayer()
    var time: CGFloat = 0
    var point: CGPoint!
    var userFetchedRC: NSFetchedResultsController<User>!
    var indexes = [(task:Task, row: Int)]()
    //var todayTasks = [(Task, TaskIndexPath)]() // TaskIndexPath used to update global user
    weak var currentTaskViewDelegate: CurrentTaskViewDelegate?
    var AM = false {
        didSet {
            if AM == true {
                AMLabel.text = "AM"
            } else {
                AMLabel.text = "PM"
            }
        }
    }
    
    // MARK: - Load functions
    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
        drawClock()
        AMLabel.frame.origin = CGPoint(x: view.center.x, y: view.center.y - 200)
        // Set name
        
        
        /* Set number of tasks in welcome
        let count = getNumOfTasks()
        if count > 1 {
            taskCountLabel.text = "You have \(count) tasks left today"
        } else if count == 1 {
            taskCountLabel.text = "You have \(count) task left today"
        } else {
            taskCountLabel.text = "You have no tasks left today. Woohoo!"
        }
        */
        // Rounding corners
        //calendarButton.layer.cornerRadius = calendarButton.frame.size.width/2
        
        // Notification for returning from home screen
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.viewWillAppear(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        print("View did load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
        getTime()
        point = getPoint()
        self.clockTasks()
        drawLine(onLayer: view.layer, fromPoint: view.center, toPoint: point)
        
        userRefresh()
        let user = userFetchedRC.fetchedObjects?.first
        if let name = user?.name {
            welcomeLabel.text = "It's Productivity Time \(name)!"
        } else {
            welcomeLabel.text = "It's Productivity Time!"
        }
        
        if let color = user?.favoriteColor as? UIColor {
            welcomeLabel.textColor = color
        } else {
            welcomeLabel.textColor = UIColor.black
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Dashboard view did appear")
        

        if let currentTask = getCurrentTask() {
            self.currentTaskViewDelegate?.updateTask(currentTask)
            taskView.alpha = 1
            taskView.isHidden = false
        } else {
            taskView.isHidden = true
        }
        
        // Number of tasks label
        let count = getNumOfTasks()
        if count > 1 {
            taskCountLabel.text = "You have \(count) tasks left today"
        } else if count == 1 {
            taskCountLabel.text = "You have \(count) task left today"
        } else {
            taskCountLabel.text = "You have no tasks left today. Woohoo!"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CurrentTask" {
            // Set delegate
            let currentTaskController = segue.destination as? CurrentTaskViewController
            currentTaskController?.delegate = self
            currentTaskController?.task = getCurrentTask()
            self.currentTaskViewDelegate = currentTaskController
        }
    }
    
    func userRefresh() {
        let request = User.fetchRequest() as NSFetchRequest<User>
        let sort = NSSortDescriptor(keyPath: \User.name, ascending: true)
        request.sortDescriptors = [sort]
        do {
            userFetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try userFetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if (userFetchedRC.fetchedObjects?.isEmpty)! {
            let user = User(entity: User.entity(), insertInto: context)
            let green = Color.toHex("Green")
            let greenColor = Color.toUIColor(green)
            user.favoriteColor = greenColor
            user.favoriteColorName = "Green"
            appDelegate.saveContext()
            userRefresh()
        }
    }
    
    func refresh() {
        let request = Task.fetchRequest() as NSFetchRequest<Task>
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date())
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
        
        // Set predicate as date being today's date
        let fromPredicate = NSPredicate(format: "startDate >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "dueDate < %@", dateTo! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        request.predicate = datePredicate
        
        let sort = NSSortDescriptor(keyPath: \Task.startDate, ascending: true)
        request.sortDescriptors = [sort]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Functions
    func getNumOfTasks() -> Int {
        //var count = 0
        guard let tasks = fetchedRC.fetchedObjects else {return 0}
        /*
        guard let projects = globalUser.projects
            else {return 0}
        for project in projects {
            let tasks = project.tasks
            for task in tasks {
                if let taskDate = task.dueDate{
                    // Check if the task is due today
                    if (calendar.component(.day, from: date) == calendar.component(.day, from: taskDate)){
                        count += 1
                    }
                }
            }
        }
 */
        return tasks.count
    }
    
    /* Fills in today tasks array with all tasks due today
    func getTodayTasks() {
        let date = Date()
        let calendar = Calendar.current
        guard let projects = globalUser.projects
            else {
                print("Today tasks didn't load")
                return
        }
        var projectIndex = 0
        for project in projects {
            let tasks = project.tasks
            var taskIndex = 0
            for task in tasks {
                if let taskDate = task.dueDate{
                    // Check if the task is due today
                    if (calendar.component(.day, from: date) == calendar.component(.day, from: taskDate)){
                        todayTasks.append((task, TaskIndexPath(projectIndex: projectIndex, taskIndex: taskIndex)))
                    }
                }
                taskIndex = taskIndex + 1
            }
            projectIndex = projectIndex + 1
        }
    }
    */
    
    // Set up tasks on the clock
    func clockTasks() {
        // Test if it's AM or PM
        let date = Date()
        let calendar = Calendar.current
        
        let dateComponents = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year, Calendar.Component.weekOfYear, Calendar.Component.hour, Calendar.Component.minute], from: date)
        
        if dateComponents.hour! >= 12 {
            AM = false
        } else {
            AM = true
        }
        
        guard let todayTasks = fetchedRC.fetchedObjects else {
            return
        }
        
        for task in todayTasks {
            if let startDate = task.startDate,
                let dueDate = task.dueDate {
                let startTimeComponents = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year, Calendar.Component.weekOfYear, Calendar.Component.hour, Calendar.Component.minute], from: startDate as Date)
                let endTimeComponents = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year, Calendar.Component.weekOfYear, Calendar.Component.hour, Calendar.Component.minute], from: dueDate as Date)
            if let startHour = startTimeComponents.hour,
                let startMinutes = startTimeComponents.minute,
                let endHour = endTimeComponents.hour,
                let endMinutes = endTimeComponents.minute,
                let color = task.project?.color as? UIColor {
                
                if (startHour >= 12) && (AM == false) {
                    let startRadians = timeToRadians(hours: startHour, minutes: startMinutes)
                    let endRadians = timeToRadians(hours: endHour, minutes: endMinutes)
                    drawPieces(startTimeRadians: startRadians, endTimeRadians: endRadians, color: color.cgColor, task: task)
                } else if (endHour < 12) && (AM == true) {
                    let startRadians = timeToRadians(hours: startHour, minutes: startMinutes)
                    let endRadians = timeToRadians(hours: endHour, minutes: endMinutes)
                    drawPieces(startTimeRadians: startRadians, endTimeRadians: endRadians, color: color.cgColor, task: task)
                } else if AM == true {
                    let startRadians = timeToRadians(hours: startHour, minutes: startMinutes)
                    let endRadians = 3 * CGFloat.pi/2
                    drawPieces(startTimeRadians: startRadians, endTimeRadians: endRadians, color: color.cgColor, task: task)
                } else {
                    let startRadians = -CGFloat.pi/2
                    let endRadians = timeToRadians(hours: endHour, minutes: endMinutes)
                    drawPieces(startTimeRadians: startRadians, endTimeRadians: endRadians, color: color.cgColor, task: task)
                }
                }
            }
        }
        
    }
    
    func timeToRadians(hours: Int, minutes: Int) -> CGFloat {
        
        var hour = hours
        let time: CGFloat
        let pi = CGFloat.pi
        
        if hour >= 12 {
            hour = hour - 12
        }
        time = CGFloat(hour) * 60 + CGFloat(minutes)
        
        let radians = time/720 * 2 * pi
        
        return radians - pi/2
    }
    
    // Draws pie slice for input of hours and minutes
    func drawPieces(startTimeRadians: CGFloat, endTimeRadians: CGFloat, color: CGColor, task: Task) {
        
        let shapeLayer = CAShapeLayer()
        let center = view.center
        
        
        // UIBezierPath extension in misc
        let circularLayer = UIBezierPath(circleSegmentCenter: center, radius: 155, startAngle: startTimeRadians, endAngle: endTimeRadians)
        
        shapeLayer.path = circularLayer.cgPath
        shapeLayer.fillColor = color
        
        let row = view.layer.sublayers?.count
        indexes.append((task: task, row: row!))
        view.layer.addSublayer(shapeLayer)
        
    }
    
    // MARK: - Current task functions
    // Returns the task for which the current time is between start and due time
    func getCurrentTask() -> Task? {
        refresh()
        let date = Date()
        let calendar = Calendar.current
        
        guard let todayTasks = fetchedRC.fetchedObjects else {
            return nil
        }
        
        for task in todayTasks {
            if let startTime = task.startDate,
                let endTime = task.dueDate {
                let startDateComponents = calendar.dateComponents([Calendar.Component.hour, Calendar.Component.minute], from: date, to: startTime as Date)
                let endDateComponents = calendar.dateComponents([Calendar.Component.hour, Calendar.Component.minute], from: endTime as Date, to: date)
                if let startHour = startDateComponents.hour,
                    let startMinutes = startDateComponents.minute,
                    let endHour = endDateComponents.hour,
                    let endMinutes = endDateComponents.minute {
                    
                    if startHour >= 0 && endHour >= 0 && startMinutes <= 15 && endMinutes <= 15 {
                        //let index = fetchedRC.indexPath(forObject: task)
                        //let tIndex = TaskIndexPath(iPath: index!)
                        return task
                    }
                }
            }
        }
        return nil
    }
    
    // Current Task Delegate functions
    func completedTask(task: Task) {
        context.delete(task)
        appDelegate.saveContext()
        if let currentTask = getCurrentTask() {
            self.taskView.isHidden = false
            
            UIView.animate(withDuration: 0.3, animations: {
                self.taskView.alpha = 0
            }, completion: nil)
            
            currentTaskViewDelegate?.updateTask(currentTask)
            
            UIView.animate(withDuration: 0.3, animations: {
            self.taskView.alpha = 1
            }, completion:  nil)
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.taskView.alpha = 0
            }, completion:  {
                (value: Bool) in
            })
        }
        
        clockTasks()
    }
    
    func noTask() {
        taskView.isHidden = true
    }
    
    // MARK: - Clock functions
    func getTime() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        time = CGFloat(hour*60 + minute)*2*CGFloat.pi/720
    }
    
    func getPoint() -> CGPoint {
        let pi = CGFloat.pi
        let center = view.center
        let x = cos(-pi/2 + time)*155
        let y = sin(-pi/2 + time)*155
        return CGPoint(x: center.x + x, y: center.y + y)
    }
    /*
    func startSpinning() {
        line.startRotating(duration: 3600*24, start: time)
    }
    
    func setTime()
    {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        time = (Float)(hour*60 + minute)*2*Float.pi/720
        line.transform = line.transform.rotated(by: CGFloat(time))
    }
    
    @objc func setClock()
    {
        setTime()
        startSpinning()
    }
    */
    
    func drawLine(onLayer layer: CALayer, fromPoint start: CGPoint, toPoint end: CGPoint) {
        let linePath = UIBezierPath()
        linePath.move(to: start)
        linePath.addLine(to: end)
        lineLayer.path = linePath.cgPath
        lineLayer.fillColor = nil
        lineLayer.lineWidth = 5
        lineLayer.opacity = 1.0
        lineLayer.strokeColor = UIColor.red.cgColor
        lineLayer.lineCap = CAShapeLayerLineCap.round
        layer.addSublayer(lineLayer)
    }
    
    func drawClock() {
        
        let center = view.center
        let pi = CGFloat.pi
        
        let circularLayer = UIBezierPath(arcCenter: center, radius: 160, startAngle: -pi/2, endAngle:3*pi/2, clockwise: true)
        //let circularLayer = UIBezierPath(circleSegmentCenter: center, radius: 160, startAngle: -pi/2, endAngle:3*pi/2 )
        
        clockLayer.path = circularLayer.cgPath
        clockLayer.fillColor = UIColor.clear.cgColor
        clockLayer.strokeColor = UIColor.lightGray.cgColor
        clockLayer.lineWidth = 10
        
        let centerLayer = CAShapeLayer()
        let circleLayer = UIBezierPath(arcCenter: center, radius: 5, startAngle: 0, endAngle: 2*pi, clockwise: true)
        centerLayer.path = circleLayer.cgPath
        centerLayer.fillColor = UIColor.lightGray.cgColor
        
        view.layer.addSublayer(clockLayer)
        view.layer.addSublayer(centerLayer)
        
        clockPieces()
    }
    
    func clockPieces() {
        let pi = CGFloat.pi
        let start = -pi/2
        
        for i in 0..<12 {
            let angle = start + (pi/6) * CGFloat(i)
            let startAngle = angle - pi/256
            let endAngle = angle + pi/256
            
            self.drawClockNubs(startTimeRadians: startAngle, endTimeRadians: endAngle)
            
        }
        
        for i in 1...4 {
            let labelAngle = -pi/2 + CGFloat(i)*pi/2
            let xCoor = view.center.x + cos(labelAngle) * 185 - 10
            let yCoor = view.center.y + sin(labelAngle) * 185 - 10
            let label = UILabel(frame: CGRect(x: xCoor, y: yCoor, width: 20, height: 20))
            label.text = String(i*3)
            label.font = UIFont(name: "HelveticaNeue", size: 16)
            label.textAlignment = .center
            label.contentMode = .center
            self.view.addSubview(label)
        }
        
    }
    
    func drawClockNubs(startTimeRadians: CGFloat, endTimeRadians: CGFloat) {
        
        let shapeLayer = CAShapeLayer()
        let center = view.center
        
        let circularLayer = UIBezierPath(arcCenter: center, radius: 150, startAngle: startTimeRadians, endAngle: endTimeRadians, clockwise: true)
        
        shapeLayer.path = circularLayer.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 15
        shapeLayer.lineCap = CAShapeLayerLineCap.butt
        
        view.layer.addSublayer(shapeLayer)
    }
    
}
    


