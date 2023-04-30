/*
 * (c) 2023 ios8engineer Limited. All rights reserved.
 */

import Foundation

extension Cache {
    
    class Entry<T: Codable>: Codable {
        
        // MARK: - Properties
        let value: T
        let expirationDate: Date
        
        // MARK: - Initializers
        init(value: T, expirationDate: Date) {
            self.value = value
            self.expirationDate = expirationDate
        }
        
    }
    
}
