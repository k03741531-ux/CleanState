import SwiftUI

struct JournalEntry: Identifiable, Codable {
    let id = UUID()
    var date: Date
    var type: EntryType
    var notes: String
    var intensityLevel: Int
    var location: String
    var triggers: [String]
    var thoughtsAndFeelings: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case type
        case notes
        case intensityLevel
        case location
        case triggers
        case thoughtsAndFeelings
        // id is excluded from coding
    }
    
    enum EntryType: String, Codable, CaseIterable {
        case craving = "Craving"
        case relapse = "Relapse"
        case note = "Note"
        case victory = "Victory"
        
        var icon: String {
            return rawValue.lowercased()
        }
        
        var color: String {
            switch self {
            case .craving: return "F87171"
            case .relapse: return "DC2626"
            case .note: return "EAB308"
            case .victory: return "22C55E"
            }
        }
    }
    
    init(date: Date = Date(), type: EntryType = .craving, notes: String = "", intensityLevel: Int = 5, location: String = "", triggers: [String] = [], thoughtsAndFeelings: String = "") {
        self.date = date
        self.type = type
        self.notes = notes
        self.intensityLevel = intensityLevel
        self.location = location
        self.triggers = triggers
        self.thoughtsAndFeelings = thoughtsAndFeelings
    }
}

class JournalManager: ObservableObject {
    @AppStorage(SaveKey.journalEntries) var entries: [JournalEntry] = []
    
    func addEntry(_ entry: JournalEntry) {
        entries.append(entry)
        entries.sort { $0.date > $1.date }
    }
    
    func updateEntry(_ entry: JournalEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            entries.sort { $0.date > $1.date }
        }
    }
    
    func deleteEntry(_ entry: JournalEntry) {
        entries.removeAll { $0.id == entry.id }
    }
    
    func addRelapse(notes: String = "") {
        let entry = JournalEntry(type: .relapse, notes: notes)
        addEntry(entry)
    }
    
    func addCraving(notes: String = "") {
        let entry = JournalEntry(type: .craving, notes: notes)
        addEntry(entry)
    }
}
