import UIKit
import os.log


class Symptom: NSObject, NSCoding {
    
    //MARK: Properties
    var desc: String
    var rating: Int
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("symptoms")
    
    //MARK: Types
    
    struct PropertyKey {
        static let desc = "desc"
        static let rating = "rating"
    }
    
    //MARK: Initialization
    init?(desc: String, rating: Int) {
        
        // The desc must not be empty
        guard !desc.isEmpty else {
            return nil
        }

        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialization should fail if there is no desc or if the rating is negative.
        if desc.isEmpty || rating < 0  {
            return nil
        }
        
        // Initialize stored properties.
        self.desc = desc
        self.rating = rating
        
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(desc, forKey: PropertyKey.desc)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The desc is required. If we cannot decode a desc string, the initializer should fail.
        guard let desc = aDecoder.decodeObject(forKey: PropertyKey.desc) as? String else {
            os_log("Unable to decode the desc for a Symptom object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer.
        self.init(desc: desc, rating: rating)
        
    }
}
