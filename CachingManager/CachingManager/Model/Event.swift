/*
 * (c) 2023 ios8engineer Limited. All rights reserved.
 */

import Foundation

class Event: Codable {
    
    // MARK: - Properties
    let date: Date
    let title: String
    let description: String
    
    // MARK: - Initializers
    init(
        date: Date,
        title: String,
        description: String
    ) {
        self.date = date
        self.title = title
        self.description = description
    }
    
    // MARK: - Computed Properties
    var logInfo: String {
        let date = DateFormatter.eventDisplayDateFormatter.string(from: self.date)
        let title = "\(self.title) on \(DateFormatter.eventDescriptionDateFormatter.string(from: self.date))"
        
        return "Date: \(date)\nTitle: \(title)\nDescription: \(description)"
    }
    
}
