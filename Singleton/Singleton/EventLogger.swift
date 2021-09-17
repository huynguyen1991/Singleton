//
//  EventLogger.swift
//  Singleton
//
//  Created by Huy Nguyễn on 16/09/2021.
//

/*
* The primary purpose of singletons is to make sure that we can create only one instance of a given type.
* Singletons work well when there is a single resource that needs to be accessed and managed throughout the application.
* As parallel and concurrent reads and writes produce data corruption, consequently causing the app to crash, making sure that
* both reads and writes do not execute in parallel, could be a solution. In other words, preventing both reads and writes
* occurring at the same time seems to solve the issue
*/

import Foundation

/*
 * Here, the class EventLogger has been declared as final in order to prevent it from further subclassing
 */

final public class EventLogger {
    public static let shared = EventLogger()
    private var eventsFired: [String: Any] = ["initialisation": "Property initialised"]
    /*
    * Custom concurrent queue - local queue for better performance
    * where multiple reads can be happened at the same time
    */
    private let concurrentQueue = DispatchQueue(label: "DataQueue", qos: .userInitiated,
                                                attributes: .concurrent,
                                                autoreleaseFrequency: .workItem)
    /*
    * The initialiser of the class has made private so as to prevent creating instances directly
    * from outside of the class so it ensures that the initialiser can only be used within the class declaration
    */
    private init() {}
    
    /*
    *  sync - concurrentQueue.sync for reading a shared resource - to have clear API without callbacks
    */
    public func readLog(for key: String) -> String? {
        var value: String?
        concurrentQueue.sync {
            value = eventsFired[key] as? String
        }
        return value
    }
    
    /*
    * What the barrier flag does is to ensure that the work item will be executed when
    * all previously scheduled work items on the queue have finished.
    * The barrier switches between concurrent and serial queues and performs as a serial queue until the code
    * in barrier block finishes its execution and switches back to a concurrent queue after executing the barrier block.
    * This prevents race conditions and data corruptions from occurring.
    */
    public func writeToLog(key: String, content: Any) {
        concurrentQueue.async(flags: .barrier) {
            self.eventsFired[key] = content
        }
    }
}
