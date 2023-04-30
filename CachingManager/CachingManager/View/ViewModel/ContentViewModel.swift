/*
 * (c) 2023 ios8engineer Limited. All rights reserved.
 */

import Foundation

fileprivate let kMainEventKey = "kMainEventKey"
fileprivate let kUpcomingEvents = "kUpcomingEvents"

class ContentViewModel {
    
    // MARK: - Properties
    private let cache = Cache()
    
    // MARK: - Public Methods
    func clearCache() {
        print("\nWill clear cache\n")
        cache.clearStorage()
    }
    
    func loadEvents() {
        loadMainEvent()
        loadUpcomingEvents()
    }
    
    func saveGeneratedEvents() {
        saveMainEvent()
        saveUpcomingEvents()
    }
    
    // MARK: - Private Methods
    private func saveMainEvent() {
        let timeIntervalOffset = TimeInterval(60*60*24 * (arc4random()%90 + 1))
        
        let event = Event(
            date: Date().addingTimeInterval(timeIntervalOffset),
            title: "Some main event",
            description: "Description of some main event"
        )
        
        print("\nWill save new main event:\n\(event.logInfo)\n\n\n")
        
        cache.save(object: event, forKey: kMainEventKey, lifeTime: timeIntervalOffset)
    }
    
    private func saveUpcomingEvents() {
        var events: [(event: Event, lifeTime: TimeInterval)] = []
        
        for _ in 0..<(arc4random()%11+1) {
            let timeIntervalOffset = TimeInterval(60*60*24 * (arc4random()%30 + 1))
            
            let event = Event(
                date: Date().addingTimeInterval(timeIntervalOffset),
                title: "Some main event",
                description: "Description of some main event"
            )
            
            events.append((event: event, lifeTime: timeIntervalOffset))
        }
        
        events = events.sorted(by: { $0.lifeTime < $1.lifeTime })
        
        let desctiptions = events.map({ $0.event.logInfo }).joined(separator: "\n\n")
        print("\nWill save new upcoming evevnts:\n\(desctiptions)\n\n\n")
                
        cache.save(object: events.map({ $0.event }), forKey: kUpcomingEvents, lifeTime: events[0].lifeTime)
    }
    
    private func loadMainEvent() {
        cache.object(forKey: kMainEventKey) { (event: Event?) in
            guard let event = event else { return print("\nMain event was not saved yet!\n\n\n") }
            
            print("\nDid load saved main event:\n\(event.logInfo)\n\n\n")
        }
    }
    
    private func loadUpcomingEvents() {
        cache.object(forKey: kUpcomingEvents) { (events: [Event]?) in
            guard let events = events else { return print("\nUpcoming events was not saved yet!\n\n\n") }
            
            let desctiptions = events.map({ $0.logInfo}).joined(separator: "\n\n")
            print("\nDid load upcoming events:\n\(desctiptions)\n\n\n")
        }
    }
    
    // You may even save data structures like UIImage by simply converting it to a Data.
    /*
     
     private func saveSomeImage() {
         guard let imageData = UIImage(systemName: "heart.fill")?.pngData() else { return }
         
         print("\nWill save some image: \(imageData)")
         cache.save(object: imageData, forKey: "kSavedSomeImage", lifeTime: TimeInterval(60*60*10))
     }
     
     private func loadSomeImage() {
         cache.object(forKey: "kSavedSomeImage") { (imgData: Data?) in
             guard let imgData = imgData else { return print("\nImage was not saved yet!\n\n\n") }
             
             print("\nDid load some image: \(UIImage(data: imgData))")
         }
     }
     
     */
    
}
