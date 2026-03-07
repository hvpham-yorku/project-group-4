//
//  PersonalFinancialPlannerApp.swift
//  PersonalFinancialPlanner
//
//  Created by Harneet Arri on 2026-02-26.
//  Edited by Mehrshad Zarastounia on 2026-03-05.
//

import SwiftUI

@main
struct PersonalFinancialPlannerApp: App {
    
    // Switch between repositories by changing only this line
    private let repository = StudentRepositoryReal()
    // private let repository = StudentRepositoryReal()
    
    var body: some Scene {
        WindowGroup {
            ContentView(repository: repository)
        }
    }
}
