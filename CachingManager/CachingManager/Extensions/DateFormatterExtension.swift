/*
 * (c) 2023 ios8engineer Limited. All rights reserved.
 */

import Foundation

extension DateFormatter {
    
    static let eventDisplayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        return dateFormatter
    }()
    
    static let eventDescriptionDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy | HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        return dateFormatter
    }()
    
}
