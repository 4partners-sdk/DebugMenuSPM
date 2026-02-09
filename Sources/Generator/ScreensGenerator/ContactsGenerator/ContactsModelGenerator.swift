import Foundation

struct ContactsModelGenerator {
    static let names = [
        "John", "Jane", "Michael", "Emily", "Chris", "Sarah", "David", "Emma",
        "Daniel", "Sophia", "Oliver", "Isabella", "James", "Charlotte", "Benjamin",
        "Amelia", "Lucas", "Mia", "Henry", "Harper", "Liam", "Noah", "Ethan", "Ava",
        "Alexander", "Ella", "Mason", "Lily", "Logan", "Grace", "Jacob", "Zoe",
        "Elijah", "Scarlett", "William", "Victoria", "Jackson", "Hannah", "Sebastian",
        "Aria", "Matthew", "Abigail", "Samuel", "Avery", "Joseph", "Chloe", "Owen",
        "Penelope", "Nathan", "Lillian", "Caleb", "Layla", "Wyatt", "Brooklyn", "Ryan",
        "Nora", "Leo", "Riley", "Gabriel", "Ellie", "Julian", "Madison", "Carter",
        "Savannah", "Isaac", "Bella", "Dylan", "Stella", "Anthony", "Violet", "Ezra",
        "Hazel", "Joshua", "Aurora", "Grayson", "Lucy", "Andrew", "Paisley", "Lincoln",
        "Audrey", "Hudson", "Skylar", "Jaxon", "Nova", "Eli", "Genesis", "Hunter",
        "Aaliyah", "Thomas", "Delilah", "Aaron", "Claire", "Dominic", "Autumn",
        "Josiah", "Kennedy", "Mateo", "Alice", "Jonathan", "Sadie", "Adrian",
        "Nevaeh", "Landon", "Caroline", "Colton", "Valentina", "Brayden", "Ruby",
        "Damian", "Sophie", "Xavier", "Eva", "Evan", "Everly", "Kevin", "Anna",
        "Zachary", "Kaylee", "Angel", "Eliana", "Asher", "Lydia", "Easton", "Clara",
        "Nicholas", "Isla", "Brandon", "Sarah", "Cooper", "Ivy", "Parker", "Jade",
        "Roman", "Brielle", "Maxwell", "Kinsley", "Jasper", "Emery", "Miles",
        "Adeline", "Sawyer", "Piper", "Charlie", "Aspen", "Nathaniel", "Reagan",
        "Harrison", "Maya", "Leon", "Axel", "Jude", "Theo", "Finn", "Beau",
        "Weston", "Santiago", "Emmett", "Lorenzo", "Zane", "Max", "August",
        "Kieran", "Calvin", "Orion", "Ronan", "Tobias", "Felix"
    ]
    
    static let surnames = [
        "Doe", "Smith", "Brown", "Davis", "Johnson", "Wilson", "Lee", "Taylor",
        "Harris", "White", "Walker", "Hall", "Allen", "Young", "King", "Wright",
        "Scott", "Torres", "Mitchell", "Hill", "Adams", "Baker", "Campbell",
        "Carter", "Clark", "Collins", "Cooper", "Edwards", "Evans", "Fisher",
        "Flores", "Gonzalez", "Green", "Hernandez", "Jackson", "James", "Jenkins",
        "Kelly", "Lewis", "Long", "Martinez", "Miller", "Moore", "Morales",
        "Morgan", "Murphy", "Nelson", "Parker", "Perez", "Peterson", "Phillips",
        "Ramirez", "Reed", "Richardson", "Roberts", "Rodriguez", "Ross", "Russell",
        "Sanders", "Simmons", "Stewart", "Sullivan", "Thomas", "Thompson", "Turner",
        "Vasquez", "Ward", "Watson", "Wood", "Wright", "Young", "Anderson",
        "Armstrong", "Barnes", "Bennett", "Brooks", "Bryant", "Butler", "Castillo",
        "Chapman", "Cole", "Curtis", "Delgado", "Diaz", "Dunn", "Fernandez",
        "Freeman", "Gibson", "Graham", "Grant", "Griffin", "Gutierrez", "Harper",
        "Hawkins", "Hudson", "Hunter", "Jordan", "Lambert", "Lawrence", "Marshall",
        "Mendoza", "Nguyen", "Ortiz", "Palmer", "Payne", "Ramsey", "Reyes", "Romero",
        "Schmidt", "Shelton", "Silva", "Spencer", "Stanley", "Tucker", "Vargas",
        "Webb", "Wheeler", "Wilkerson", "Winters", "Yates"
    ]
    
    static let phoneNumbers = [
        "123-456-7890", "987-654-3210", "555-123-4567", "111-222-3333", "444-555-6666",
        "999-888-7777", "333-444-5555", "777-666-5555", "222-333-4444", "888-777-6666",
        "121-212-1212", "343-434-3434", "565-656-5656", "787-878-7878", "909-090-9090",
        "234-567-8901", "876-543-2109", "678-901-2345", "890-123-4567", "210-987-6543",
        "101-202-3030", "404-505-6060", "707-808-9090", "313-424-5353", "626-737-8484",
        "919-282-3737", "515-626-7373", "858-969-0707", "474-585-6969", "686-797-8080",
        "222-111-3333", "444-333-5555", "666-555-7777", "888-777-9999", "112-233-4455",
        "223-344-5566", "334-455-6677", "445-566-7788", "556-677-8899", "667-788-9900",
        "101-010-1010", "212-121-2121", "323-232-3232", "434-343-4343", "545-454-5454",
        "656-565-6565", "767-676-7676", "878-787-8787", "989-898-9898", "131-414-5151",
        "616-727-8383", "929-303-4040", "818-505-6060", "707-404-5050", "606-303-4040",
        "505-202-3030", "404-101-2020", "303-909-8080", "202-808-7070", "101-707-6060",
        "123-321-4567", "789-987-6543", "654-765-4321", "234-345-6789", "876-678-5432",
        "890-901-1234", "345-678-9012", "678-543-2109", "765-432-1098", "543-210-9876",
        "321-654-9870", "654-987-3210", "901-234-5678", "432-109-8765", "678-901-3456",
        "111-000-9999", "333-222-8888", "555-444-7777", "777-666-4444", "888-999-2222",
        "999-111-5555", "222-555-9999", "444-777-1111", "666-888-3333", "000-123-3210"
    ]
    
    static let emails = [
        "johndoe@example.com", "janesmith@example.com", "michaelb@example.com",
        "emilyd@example.com", "chrisj@example.com", "sarahw@example.com",
        "davidl@example.com", "emmat@example.com", "danielh@example.com",
        "sophiaw@example.com", "oliverk@example.com", "isabellaw@example.com",
        "jamesp@example.com", "charlottek@example.com", "benjamins@example.com",
        "amelial@example.com", "lucasm@example.com", "miap@example.com",
        "henryh@example.com", "harpert@example.com", "liamg@example.com",
        "noahf@example.com", "ethana@example.com", "avab@example.com",
        "alexanderc@example.com", "ellad@example.com", "masonm@example.com",
        "lilyr@example.com", "logang@example.com", "graceh@example.com",
        "jacobw@example.com", "zoet@example.com", "elijahk@example.com",
        "scarlettl@example.com", "williamd@example.com", "victoriaf@example.com",
        "jacksonp@example.com", "hannahm@example.com", "sebastiant@example.com",
        "ariav@example.com", "matthewb@example.com", "abigailc@example.com",
        "samuelw@example.com", "averyp@example.com", "josephh@example.com",
        "chloem@example.com", "owenr@example.com", "penelopeg@example.com",
        "nathanj@example.com", "lillianb@example.com", "calebf@example.com",
        "laylar@example.com", "wyattk@example.com", "brooklynm@example.com",
        "ryana@example.com", "norae@example.com", "leog@example.com",
        "rileys@example.com", "gabrielt@example.com", "elliel@example.com",
        "julianb@example.com", "madisonh@example.com", "carterj@example.com",
        "savannahp@example.com", "isaacm@example.com", "bellad@example.com",
        "dyland@example.com", "stellar@example.com", "anthonyw@example.com",
        "violetb@example.com", "ezrak@example.com", "hazeld@example.com",
        "joshuap@example.com", "aurorar@example.com", "graysong@example.com",
        "lucyw@example.com", "andrews@example.com", "paisleyj@example.com",
        "lincolnm@example.com", "audreyl@example.com", "hudsonb@example.com",
        "skylark@example.com", "jaxonj@example.com", "novam@example.com",
        "elif@example.com", "genesisl@example.com", "hunterp@example.com",
        "aaliyahw@example.com", "thomasc@example.com", "delilaha@example.com",
        "aaronj@example.com", "claireb@example.com", "dominicm@example.com",
        "autumnr@example.com", "josiahk@example.com", "kennedyl@example.com",
        "mateog@example.com", "alices@example.com", "jonathanh@example.com",
        "sadieb@example.com", "adrianw@example.com", "nevaehk@example.com"
    ]
}

enum ContactsActionState {
    case readyToGo
    case creatingContacts(count: Int)
    case deletingAllContacts
    
    var title: String {
        switch self {
        case .readyToGo: "Ready to Go!"
        case .creatingContacts(let count): "Creating \(count) Contacts..."
        case .deletingAllContacts: "Deleting..."
        }
    }
}

enum DuplicateType: Hashable {
    case name, number, email
}
