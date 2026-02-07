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
}

enum CalendarActionState {
    case readyToGo
    case creatingEvents(count: Int)
    case deletingAllEvents
    
    var title: String {
        switch self {
        case .readyToGo: "Ready to Go!"
        case .creatingEvents(let count): "Creating \(count) Events"
        case .deletingAllEvents: "Deleting "
        }
    }
}
