//
//  AuthServices.swift
//  habits
//
//  Created by gio on 4/30/25.
//
import Foundation
import Firebase
protocol AuthServices{
    func singnIn(email: String ,password:String ,completion: @escaping (Result<AppUser,Error>)-> Void)
    
    func singUp(email: String , password: String, completion: @escaping(Result<AppUser, Error>)->Void)
    
    func singOut() throws
}
