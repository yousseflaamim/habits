//
//  HabitServices.swift
//  habits
//
//  Created by gio on 4/30/25.
//

import Foundation

protocol HabitServices{
    func fetchHabit(for userId: String, completion:@escaping([Habit])-> Void)
    
    func addHabit(_habit: Habit, userId: String)
}
