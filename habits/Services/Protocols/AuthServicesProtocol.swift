//
//  AddHabitViewModel.swift
//  habits
//
//  Created by gio on 4/3/25.
//


import Foundation

protocol AuthServiceProtocol {
    func login(email: String, password: String, completion: @escaping (Result<AppUser, Error>) -> Void)
    func register(email: String, password: String, displayName: String, completion: @escaping (Result<AppUser, Error>) -> Void)
    func logout()
    func currentUser() -> AppUser?
}
