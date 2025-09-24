import SwiftUI

struct JournalView: View {
    @EnvironmentObject var journalManager: JournalManager
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text("My Journal")
                    .font(.poppins(.bold, size: 24))
                    .foreground("FFFDFE")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                NavigationLink(destination: AddEditEntryView()) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(.accent)
                }
            }
            .frame(height: 44)
            .padding(.horizontal, 24)
            
            // Content
            if journalManager.entries.isEmpty {
                emptyStateView
            } else {
                journalEntriesView
            }
        }
        .background {
            Color("31383E")
                .ignoresSafeArea()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No journal entries yet")
                .font(.poppins(.medium, size: 18))
                .foregroundColor(.white)
            
            Text("Log your first craving or thought!")
                .font(.poppins(.regular, size: 14))
                .foregroundColor(.gray)
            
            NavigationLink(destination: AddEditEntryView()) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Entry")
                }
                .font(.poppins(.medium, size: 16))
                .foregroundColor(.black)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color.accent)
                .cornerRadius(25)
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    private var journalEntriesView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(journalManager.entries) { entry in
                    NavigationLink(destination: AddEditEntryView(entry: entry)) {
                        JournalEntryCard(entry: entry)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 30)
        }
    }
}

struct JournalEntryCard: View {
    let entry: JournalEntry
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy • h:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: entry.date)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(formattedDate)
                    .font(.poppins(.regular, size: 14))
                    .foreground("D1D5DB")
                
                Spacer()
                
                Text(entry.type.rawValue)
                    .font(.poppins(.medium, size: 12))
                    .foreground("31383E")
                    .padding(.horizontal, 8)
                    .frame(height: 24)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(entry.type.color))
                    }
            }
            
            ZStack {
                if !entry.thoughtsAndFeelings.isEmpty {
                    Text(entry.thoughtsAndFeelings)
                } else if !entry.notes.isEmpty {
                    Text(entry.notes)
                } else {
                    Text("No additional notes")
                }
            }
            .font(.poppins(.regular, size: 16))
            .foreground("FFFDFE")
            .multilineTextAlignment(.leading)
            .lineLimit(2)
        }
        .padding(16)
        .background(Color.cardBackground)
        .cornerRadius(12)
    }
}

#Preview {
    JournalView()
        .environmentObject(JournalManager())
}
