//
//  Session.swift
//  trySwift
//
//  Created by Natasha Murashev on 2/21/16.
//  Copyright © 2016 NatashaTheRobot. All rights reserved.
//

import Foundation
import Timepiece
import RealmSwift
import WatchKit

struct Session {
    let startTime: NSDate
    let endTime: NSDate
    let info: Info
    let index: Int
    
    var timeString: String {
        return "\(startTime.stringFromFormat("h:mm")) - \(endTime.stringFromFormat("h:mm a"))"
    }
    
    static let sessions: [Session] = {
        return [Session.sessionsAug31, Session.sessionsSept1, Session.sessionsSept2].flatMap{ $0 }
    }()
}

// Description Details
extension Session {
    
    enum Info {
        
        case Workshop(Event)
        case Meetup(Event)
        case Breakfast(String)
        case Announcement(String)
        case Talk(Presentation)
        case SponsoredDemo(Sponsor)
        case CoffeeBreak(Sponsor?)
        case Lunch
        case Party
        
        var title: String {
            switch self {
            case .Workshop(let event):
                return "💻 \(event.title)"
            case .Meetup(let event):
                return "🌇 \(event.title)"
            case .Breakfast(let title):
                return "🍩 \(title)"
            case .Announcement(let title):
                return "📣 \(title)"
            case .Talk(let presentation):
                return "🤓 \(presentation.title)"
            case .SponsoredDemo(_):
                return "🤓 Sponsored Demo"
            case .CoffeeBreak(_):
                return "☕️ Break"
            case .Lunch:
                return "🍴 Lunch"
            case .Party:
                return "🍕 & 🎸 Party with Airplane Mode"
            }
        }
        
        var subtitle: String {
            switch self {
            case .Meetup(let event):
                return event.sponsor.name
            case .Workshop(let event):
                return event.sponsor.name
            case .Breakfast(_), .Announcement(_), .Lunch:
                return "try! NYC"
            case .Talk(let presentation):
                return presentation.speaker?.name ?? "try! NYC"
            case .SponsoredDemo(let sponsor):
                return sponsor.name
            case .CoffeeBreak(let sponsor):
                if let sponsor = sponsor {
                    return sponsor.name
                } else {
                    return "try! NYC"
                }
            case .Party:
                return "Perfect.org"
            }
        }
        
        var logo: UIImage {
            let defaultImage = UIImage(named: "tryLogo")!
            
            switch self {
            case .Workshop(let event):
                return UIImage(named: event.sponsor.logo) ?? defaultImage
            case .Meetup(let event):
                return UIImage(named: event.sponsor.logo) ?? defaultImage
            case .Breakfast(_), .Lunch, .Announcement(_):
                return defaultImage
            case .CoffeeBreak(let sponsor):
                if let sponsor = sponsor {
                    // currently, the only sponsor is DOMO
                    return UIImage(named: sponsor.logo) ?? defaultImage
                }
                return defaultImage
            case .Talk(let presentation):
                return presentation.speaker?.getImage() ?? defaultImage
            case .SponsoredDemo(_):
                // currently the only sponsor is Twilio
                return UIImage(named: "twilio-small") ?? defaultImage
            case .Party:
                return UIImage(named: "airplanemode-short") ?? defaultImage
            }
        }
        
        var twitter: String {
            switch self {
            case .Workshop(let event):
                return "@\(event.sponsor.twitter)"
            case .Meetup(let event):
                return "@\(event.sponsor.twitter)"
            case .CoffeeBreak(let sponsor):
                if let sponsor = sponsor {
                    return "@\(sponsor.twitter)"
                }
                return "tryswiftnyc"
            case .Talk(let presentation):
                let twitterHandle = presentation.speaker?.twitter ?? "tryswiftnyc"
                return "@\(twitterHandle)"
            case .SponsoredDemo(let sponsor):
                return "@\(sponsor.twitter)"
            default:
                return "@tryswiftnyc"
            }
        }
    }
}

// default data
extension Session {
    
    // MARK: August 31 Schedule
    static let sessionsAug31: [Session] = [
        {
            return Session(
                startTime: NSDate.date(year: 2016, month: 8, day: 31, hour: 16, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 8, day: 31, hour: 18, minute: 0, second: 0),
                info: .Workshop(Event.gaWorkshop),
                index: 0)
            }(),
        {
            return Session(
                startTime: NSDate.date(year: 2016, month: 8, day: 31, hour: 19, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 8, day: 31, hour: 21, minute: 15, second: 0),
                info: .Meetup(Event.meetup),
                index: 1)
            }()
        
    ]
    
    // MARK: September 1 Schedule
    static let sessionsSept1: [Session] = [
        {
            let title = "Breakfast & Registration"
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 8, minute: 45, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 9, minute: 45, second: 0),
                info: .Breakfast(title),
                index: 2
            )
            
            return session
            }(),
        {
            let title = "Opening Remarks"
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 9, minute: 45, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 10, minute: 0, second: 0),
                info: .Announcement(title),
                index: 3
            )
            
            return session
            }(),
        {
            let realm = try! Realm()
            var presentation = realm.objects(Presentation.self).filter("id == 3").first ?? defaultPresentations[2]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 10, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 10, minute: 30, second: 0),
                info: .Talk(presentation),
                index: 4
            )
            
            return session
            }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 5").first ?? defaultPresentations[4]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 10, minute: 30, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 11, minute: 0, second: 0),
                info: .Talk(presentation),
                index: 5
            )
            
            return session
            }(),
        {
            return Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 11, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 11, minute: 30, second: 0),
                info: .CoffeeBreak(Sponsor.domo),
                index: 6)
            }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 12").first ?? defaultPresentations[11]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 11, minute: 30, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 12, minute: 0, second: 0),
                info: .Talk(presentation),
                index: 7
            )
            
            return session
            }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 11").first ?? defaultPresentations[10]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 12, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 12, minute: 30, second: 0),
                info: .Talk(presentation),
                index: 8
            )
            
            return session
            }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 19").first ?? defaultPresentations[18]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 12, minute: 30, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 13, minute: 15, second: 0),
                info: .Talk(presentation),
                index: 9
            )
            
            return session
            }(),
        {
            return Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 13, minute: 15, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 14, minute: 30, second: 0),
                info: .Lunch,
                index: 10)
            }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 14").first ?? defaultPresentations[13]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 14, minute: 30, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 15, minute: 0, second: 0),
                info: .Talk(presentation),
                index: 11
            )
            
            return session
            }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 2").first ?? defaultPresentations[1]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 15, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 15, minute: 30, second: 0),
                info: .Talk(presentation),
                index: 12
            )
            
            return session
            }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 4").first ?? defaultPresentations[3]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 15, minute: 30, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 16, minute: 0, second: 0),
                info: .Talk(presentation),
                index: 13
            )
            
            return session
            }(),
        {
            return Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 16, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 16, minute: 30, second: 0),
                info: .CoffeeBreak(nil),
                index: 14)
            }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 1").first ?? defaultPresentations[0]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 16, minute: 30, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 17, minute: 0, second: 0),
                info: .Talk(presentation),
                index: 15
            )
            
            return session
            }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 10").first ?? defaultPresentations[9]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 17, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 17, minute: 30, second: 0),
                info: .Talk(presentation),
                index: 16
            )
            
            return session
            }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 8").first ?? defaultPresentations[7]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 17, minute: 30, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 18, minute: 0, second: 0),
                info: .Talk(presentation),
                index: 17
            )
            
            return session
            }(),
        {
            let title = "Closing Announcements"
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 18, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 1, hour: 18, minute: 30, second: 0),
                info: .Announcement(title),
                index: 18
            )
            
            return session
            }(),
        {
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 18, minute: 30, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 20, minute: 30, second: 0),
                info: .Party,
                index: 19
            )
            
            return session
            }()
    ]
    
    // MARK: September 2 Schedule
    static let sessionsSept2: [Session] = [
        {
            let title = "Breakfast"
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 9, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 9, minute: 45, second: 0),
                info: .Breakfast(title),
                index: 20
            )
            
            return session
            }(),
        {
            let title = "Opening Remarks"
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 9, minute: 45, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 10, minute: 0, second: 0),
                info: .Announcement(title),
                index: 21
            )
            
            return session
            }(),
        {
            let realm = try! Realm()
            var presentation = realm.objects(Presentation.self).filter("id == 21").first ?? defaultPresentations[20]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 10, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 10, minute: 30, second: 0),
                info: .Talk(presentation),
                index: 22
            )
            
            return session
            }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 7").first ?? defaultPresentations[6]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 10, minute: 30, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 11, minute: 0, second: 0),
                info: .Talk(presentation),
                index: 23
            )
            
            return session
            }(),
        {
            return Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 11, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 11, minute: 30, second: 0),
                info: .CoffeeBreak(Sponsor.domo),
                index: 24)
            }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 13").first ?? defaultPresentations[12]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 11, minute: 30, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 12, minute: 0, second: 0),
                info: .Talk(presentation),
                index: 25
            )
            
            return session
            }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 16").first ?? defaultPresentations[15]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 12, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 12, minute: 30, second: 0),
                info: .Talk(presentation),
                index: 26
            )
            
            return session
            }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 15").first ?? defaultPresentations[14]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 12, minute: 30, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 13, minute: 0, second: 0),
                info: .Talk(presentation),
                index: 27
            )
            
            return session
            }(),
        {
            return Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 13, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 13, minute: 15, second: 0),
                info: .SponsoredDemo(Sponsor.twilio),
                index: 28
            )
        }(),
        {
            return Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 13, minute: 15, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 14, minute: 30, second: 0),
                info: .Lunch,
                index: 29)
            }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 9").first ?? defaultPresentations[8]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 14, minute: 30, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 15, minute: 0, second: 0),
                info: .Talk(presentation),
                index: 30
            )
            
            return session
            }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 22").first ?? defaultPresentations[21]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 15, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 15, minute: 30, second: 0),
                info: .Talk(presentation),
                index: 31
            )
            
            return session
            }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 18").first ?? defaultPresentations[17]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 15, minute: 30, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 16, minute: 0, second: 0),
                info: .Talk(presentation),
                index: 32
            )
            
            return session
        }(),
        {
            return Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 16, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 16, minute: 30, second: 0),
                info: .CoffeeBreak(nil),
                index: 33)
        }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 17").first ?? defaultPresentations[16]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 16, minute: 30, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 17, minute: 0, second: 0),
                info: .Talk(presentation),
                index: 34
            )
            
            return session
        }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 6").first ?? defaultPresentations[5]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 17, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 17, minute: 30, second: 0),
                info: .Talk(presentation),
                index: 35
            )
            
            return session
        }(),
        {
            let realm = try! Realm()
            let presentation = realm.objects(Presentation.self).filter("id == 20").first ?? defaultPresentations[19]
            
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 17, minute: 30, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 18, minute: 0, second: 0),
                info: .Talk(presentation),
                index: 36
            )
            
            return session
        }(),
        {
            let title = "Closing Announcements"
            let session = Session(
                startTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 18, minute: 0, second: 0),
                endTime: NSDate.date(year: 2016, month: 9, day: 2, hour: 18, minute: 30, second: 0),
                info: .Announcement(title),
                index: 37
            )
            
            return session
            }()
    ]
}
