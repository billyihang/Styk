//
//  Bootcamp.swift
//  Styk
//
//  Created by William Yang on 10/11/18.
//  Copyright © 2018 William Yang. All rights reserved.
//

import Foundation
import UIKit

class Bootcamp {
    
    var name = ""
    var taskShortDescription = ""
    var taskLongDescription = ""
    var imageName: String?
    
    init(titl: String, sDesc: String, lDesc: String) {
        self.name = titl
        self.taskShortDescription = sDesc
        self.taskLongDescription = lDesc
    }
    
    init(titl: String, sDesc: String, lDesc: String, img: String) {
        self.name = titl
        self.taskShortDescription = sDesc
        self.taskLongDescription = lDesc
        self.imageName = img
    }
    
    static func createTasks() -> [Bootcamp] {
        var array = [Bootcamp]()
        
        let task1 = Bootcamp(titl: "Day 1: Be aware of your habits", sDesc: "Track where your time goes", lDesc: "Do you know where most of your time goes? You may be suprised how you actually spend your time, especially online. You don't need to do anything today except observe. Go through your day normally, but be aware of how you're spending your time. I personally use Moment for mobile and rescuetime for desktop to track device usage, but the IOS screentime works too. After the day, take a few minutes to reflect on where most of your time went. Is it what you expected?", img: "Mindful")
        array.append(task1)
        
        let task2 = Bootcamp(titl: "Daay 2: Clean up your workspace", sDesc: "Clear clutter to bolster productivity", lDesc: "Does your work environment encourage you to work? Or does it distract you more often than not? Your environment sets the stage for your productivity, so set up the right environment for you to work. Clean up your desk, organize your papers and anything else in your workspace. A clean and organized environment helps you focus on being productive.", img: "Desk")
        array.append(task2)
        
        let task3 = Bootcamp(titl: "Day 3: Write down daily goals", sDesc: "Write down tasks you need to accomplish", lDesc: "You've probably heard a lot of people tell you to set goals and targets. Do you know why? It’s because it really works. When you set goals, you focus on the things you want to achieve. Write down all the things you need to get done by today, including homework and any other tasks.", img: "ToDoList")
        array.append(task3)
        
        let task4 = Bootcamp(titl: "Day 4: Set time for each task", sDesc: "Time-box one task at a time", lDesc: "Set aside specific times to do each task. For example: math homework from 5:00-6:00 pm. Time boxing is a good strategy because it prevents your task from dragging on and on. There’s a saying that your work will take however long that you want it to, and I find it’s very true. Set a reasonable time limit and adhere strictly to it, you'll be so much more productive to get it done in your time limit." , img: "Clock")
        array.append(task4)
        
        let task5 = Bootcamp(titl: "Day 5: Remove distractions", sDesc: "Keep distractions away when working", lDesc: "There are distractions everywhere in today's world, especially the internet. While you shouldn't completely quit using the internet, when you're trying to be productive, keep any bad habits in check and refrain from checking other websites or social media until after you finish your task. Set a rule for yourself where you can only use social media or surf the net when you're not working on a task", img: "Distractions")
        array.append(task5)
        
        let task6 = Bootcamp(titl: "Day 6: Hold yourself accountable", sDesc: "Check in on your progress", lDesc: "Progress tracking is essential to know how you are doing. We can be frantically working to up our productivity but if we know there’s no accountability, at some point we’re going to slow down. At the end of the day, check in with yourself and see how you did. If you met your goals, give yourself a pat on the back. If you didn’t, understand what went wrong and what you could do next time to prevent the same thing from happening.", img: "Graphs")
        array.append(task6)
        
        let task7 = Bootcamp(titl: "Day 7: Take care of yourself", sDesc: "It's a marathon, not a sprint", lDesc: "You aren't a robot. You can’t sustain the same output endlessly without rest, so get the sleep you need to be productive. I find that when I choose to stay late, I’m still able to do my work, but at a dismal pace. When I get enough sleep though, I can get a lot more done, even though I spend less time overall. In addition to sleep, take a few minutes of your day to exercise and be mindful. These small things can go a long way in terms of your overall health and well-being. You can't be productive without those", img: "Bed")
        array.append(task7)
        
        
        return array
    }
    
}
