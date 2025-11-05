import Foundation

fileprivate let calendar = Calendar.current

struct CalendarModelGenerator {
    static let titles = [
        "Team Meeting", "Project Kickoff", "Client Call", "Lunch with Sarah",
        "Marketing Strategy Session", "Doctor's Appointment", "Daily Standup",
        "Gym Workout", "Coding Sprint", "Brainstorming Session", "Performance Review",
        "One-on-One Meeting", "Budget Planning", "Networking Event", "Product Launch",
        "Sales Call", "Weekly Sync", "Board Meeting", "Investor Update", "Design Review",
        "Content Planning", "UX Testing", "Sprint Planning", "Scrum Meeting",
        "Office Party", "Webinar", "Online Workshop", "Team Outing", "Business Conference",
        "Quarterly Review", "Training Session", "Customer Feedback Meeting",
        "Backend Deployment", "Frontend Demo", "System Maintenance", "Tech Talk",
        "HR Discussion", "Holiday Planning", "Personal Development", "Yoga Class",
        "Doctor Checkup", "Car Service", "Home Maintenance", "Grocery Shopping",
        "Family Dinner", "Anniversary Celebration", "Birthday Party", "Weekend Getaway",
        "Flight to New York", "Concert Night", "Date Night", "Therapy Session",
        "Meditation Session", "Dentist Appointment", "House Cleaning", "Pet Grooming",
        "Library Visit", "Book Club Meeting", "Parent-Teacher Meeting", "Kids’ Playdate",
        "Wedding Ceremony", "Job Interview", "Internship Orientation", "Hiking Trip",
        "Picnic with Friends", "Volunteer Work", "Church Service", "Online Course Session",
        "Hackathon", "Coffee Chat", "Catch-up Call", "Performance Testing", "Exam Preparation",
        "Photography Workshop", "Music Lesson", "Dance Rehearsal", "Cooking Class",
        "Language Learning Session", "DIY Project", "Virtual Happy Hour", "E-Sports Tournament",
        "Movie Night", "Housewarming Party", "Tech Meetup", "Charity Run", "Startup Pitch",
        "Summer Camp", "Winter Retreat", "Festival Celebration", "Science Fair",
        "Art Exhibition", "Stand-up Comedy Show", "Networking Brunch", "Press Conference",
        "Panel Discussion", "School Reunion", "Fundraising Event", "Fashion Show",
        "Career Fair", "Game Night", "Mindfulness Workshop", "Software Update Rollout",
        "Code Review Session", "AI Research Meeting", "Public Speaking Practice"
    ]
    
    static let startDates: [Date] = [
        Date(), // Now
        calendar.date(byAdding: .day, value: 1, to: Date())!, // Tomorrow
        calendar.date(byAdding: .day, value: -1, to: Date())!, // Yesterday
        calendar.date(byAdding: .hour, value: 3, to: Date())!, // 3 hours later
        calendar.date(byAdding: .hour, value: -5, to: Date())!, // 5 hours ago
        calendar.date(byAdding: .day, value: 7, to: Date())!, // Next week
        calendar.date(byAdding: .day, value: -7, to: Date())!, // Last week
        calendar.date(byAdding: .month, value: 1, to: Date())!, // Next month
        calendar.date(byAdding: .month, value: -1, to: Date())!, // Last month
        calendar.date(byAdding: .year, value: 1, to: Date())!, // Next year
        calendar.date(byAdding: .year, value: -1, to: Date())!, // Last year
        calendar.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!, // 9 AM today
        calendar.date(bySettingHour: 12, minute: 30, second: 0, of: Date())!, // 12:30 PM today
        calendar.date(bySettingHour: 18, minute: 15, second: 0, of: Date())!, // 6:15 PM today
        calendar.date(bySettingHour: 23, minute: 45, second: 0, of: Date())!, // 11:45 PM today
        calendar.date(byAdding: .day, value: 30, to: Date())!, // 30 days from now
        calendar.date(byAdding: .day, value: -30, to: Date())!, // 30 days ago
        calendar.date(byAdding: .day, value: 60, to: Date())!, // 60 days from now
        calendar.date(byAdding: .day, value: -60, to: Date())!, // 60 days ago
        calendar.date(byAdding: .day, value: 90, to: Date())!, // 90 days from now
        calendar.date(byAdding: .day, value: -90, to: Date())!, // 90 days ago
        calendar.date(byAdding: .day, value: 15, to: Date())!, // 15 days later
        calendar.date(byAdding: .day, value: -15, to: Date())!, // 15 days ago
        calendar.date(byAdding: .day, value: 5, to: Date())!, // 5 days later
        calendar.date(byAdding: .day, value: -5, to: Date())!, // 5 days ago
        calendar.date(byAdding: .weekOfYear, value: 4, to: Date())!, // 4 weeks from now
        calendar.date(byAdding: .weekOfYear, value: -4, to: Date())!, // 4 weeks ago
        calendar.date(byAdding: .hour, value: 12, to: Date())!, // 12 hours later
        calendar.date(byAdding: .hour, value: -12, to: Date())!, // 12 hours ago
        calendar.date(byAdding: .minute, value: 30, to: Date())!, // 30 minutes later
        calendar.date(byAdding: .minute, value: -30, to: Date())!, // 30 minutes ago
        calendar.date(byAdding: .second, value: 45, to: Date())!, // 45 seconds later
        calendar.date(byAdding: .second, value: -45, to: Date())!, // 45 seconds ago
        calendar.date(byAdding: .month, value: 3, to: Date())!, // 3 months from now
        calendar.date(byAdding: .month, value: -3, to: Date())!, // 3 months ago
        calendar.date(byAdding: .month, value: 6, to: Date())!, // 6 months from now
        calendar.date(byAdding: .month, value: -6, to: Date())!, // 6 months ago
        calendar.date(byAdding: .year, value: 2, to: Date())!, // 2 years from now
        calendar.date(byAdding: .year, value: -2, to: Date())!, // 2 years ago
        calendar.date(byAdding: .year, value: 5, to: Date())!, // 5 years from now
        calendar.date(byAdding: .year, value: -5, to: Date())!, // 5 years ago
        calendar.date(byAdding: .year, value: 10, to: Date())!, // 10 years from now
        calendar.date(byAdding: .year, value: -10, to: Date())!, // 10 years ago
        calendar.date(byAdding: .weekOfYear, value: 2, to: Date())!, // 2 weeks from now
        calendar.date(byAdding: .weekOfYear, value: -2, to: Date())!, // 2 weeks ago
        calendar.date(byAdding: .day, value: 45, to: Date())!, // 45 days later
        calendar.date(byAdding: .day, value: -45, to: Date())!, // 45 days ago
        calendar.date(byAdding: .day, value: 120, to: Date())!, // 120 days from now
        calendar.date(byAdding: .day, value: -120, to: Date())!, // 120 days ago
        calendar.date(byAdding: .day, value: 180, to: Date())!, // 180 days from now
        calendar.date(byAdding: .day, value: -180, to: Date())!, // 180 days ago
        calendar.date(byAdding: .hour, value: 24, to: Date())!, // 24 hours later
        calendar.date(byAdding: .hour, value: -24, to: Date())!, // 24 hours ago
    ]
    
    static let timeIntervals: [TimeInterval] = [
        60,        // 1 minute
        120,       // 2 minutes
        300,       // 5 minutes
        600,       // 10 minutes
        900,       // 15 minutes
        1200,      // 20 minutes
        1800,      // 30 minutes
        2700,      // 45 minutes
        3600,      // 1 hour
        4500,      // 1 hour 15 minutes
        5400,      // 1 hour 30 minutes
        6300,      // 1 hour 45 minutes
        7200,      // 2 hours
        8100,      // 2 hours 15 minutes
        9000,      // 2 hours 30 minutes
        10800,     // 3 hours
        14400,     // 4 hours
        18000,     // 5 hours
        21600,     // 6 hours
        25200,     // 7 hours
        28800,     // 8 hours
        32400,     // 9 hours
        36000,     // 10 hours
        43200,     // 12 hours
        50400,     // 14 hours
        57600,     // 16 hours
        64800,     // 18 hours
        72000,     // 20 hours
        86400,     // 1 day (24 hours)
        129600,    // 1.5 days (36 hours)
        172800,    // 2 days (48 hours)
        259200,    // 3 days (72 hours)
        345600,    // 4 days (96 hours)
        432000,    // 5 days (120 hours)
        604800,    // 1 week (7 days)
        1209600,   // 2 weeks (14 days)
        1814400,   // 3 weeks (21 days)
        2419200,   // 4 weeks (28 days)
        2678400,   // 1 month (31 days)
        5184000,   // 2 months (60 days)
        7776000,   // 3 months (90 days)
        15552000,  // 6 months (180 days)
        31536000,  // 1 year (365 days)
        63072000,  // 2 years
        94608000,  // 3 years
        157680000, // 5 years
        315360000, // 10 years
        631152000  // 20 years
    ]
    
}
