import SwiftUI

struct AddEditEntryView: View {
    @Environment(\.goBack) var goBack
    @EnvironmentObject var journalManager: JournalManager
    
    @State private var date = Date()
    @State private var selectedType: JournalEntry.EntryType = .craving
    @State private var intensityLevel = 5
    @State private var location = ""
    @State private var selectedTriggers: Set<String> = []
    @State private var thoughtsAndFeelings = ""
    @State private var showDatePicker = false
    @State private var tempDate = Date()
    
    let entry: JournalEntry?
    
    private let availableTriggers = ["Stress", "Boredom", "Social", "Anxiety", "Anger", "Celebration"]
    
    init(entry: JournalEntry? = nil) {
        self.entry = entry
        
        if let entry = entry {
            _date = State(initialValue: entry.date)
            _selectedType = State(initialValue: entry.type)
            _intensityLevel = State(initialValue: entry.intensityLevel)
            _location = State(initialValue: entry.location)
            _selectedTriggers = State(initialValue: Set(entry.triggers))
            _thoughtsAndFeelings = State(initialValue: entry.thoughtsAndFeelings)
        }
    }
    
    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                HStack {
                    Button {
                        goBack()
                    } label: {
                        Image(.backButton)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 28)
                    }
                    
                    Spacer()
                    
                    Button {
                        saveEntry()
                    } label: {
                        Text("Save")
                            .font(.poppins(.medium, size: 16))
                            .foreground("31383E")
                            .frame(width: 71, height: 40)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("F0C042"))
                            }
                    }
                }
                
                Text(entry == nil ? "New Entry" : "Edit Entry")
                    .font(.poppins(.semibold, size: 20))
                    .foreground("FFFDFE")
                    .frame(maxWidth: .infinity)
                
            }
            .frame(height: 44)
            .padding(.horizontal, 24)
            
            ScrollView {
                VStack(spacing: 24) {
                    dateTimeSection
                    entryTypeSection
                    intensityLevelSection
                    locationSection
                    triggersSection
                    thoughtsSection
                    saveButton
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
            }
        }
        .background {
            Color("31383E").ignoresSafeArea()
        }
        .hideSystemNavBar()
        .addDoneButtonToKeyboard()
        .sheet(isPresented: $showDatePicker) {
            if #available(iOS 16.0, *) {
                datePickerModal
                    .presentationDetents([.height(350)])
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    private var dateTimeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Date & Time")
                .font(.poppins(.medium, size: 14))
                .foreground("D1D5DB")
            
            Button {
                tempDate = date
                showDatePicker = true
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(formattedDate)
                            .font(.poppins(.medium, size: 16))
                            .foreground("FFFDFE")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Tap to change")
                            .font(.poppins(.regular, size: 14))
                            .foreground("9CA3AF")
                    }
                    
                    Image(.calendar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .padding(16)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color("3D454C"))
                }
            }
        }
    }
    
    private var datePickerModal: some View {
        NavigationView {
            if #available(iOS 16.0, *) {
                VStack {
                    Text("Select Date & Time")
                        .font(.poppins(.semibold, size: 18))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    DatePicker(
                        "",
                        selection: $tempDate,
                        in: ...Date(),
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.wheel)
                    .labelsHidden()
                    .colorScheme(.dark)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button("Cancel") {
                            showDatePicker = false
                        }
                        .font(.poppins(.medium, size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color("3D454C"))
                        .cornerRadius(12)
                        
                        Button("Done") {
                            date = tempDate
                            showDatePicker = false
                        }
                        .font(.poppins(.medium, size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color("F0C042"))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .background(Color("31383E"))
                .presentationDetents([.medium])
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    private var entryTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Entry Type")
                .font(.poppins(.medium, size: 14))
                .foreground("D1D5DB")
            
            LazyVGrid(columns: Array(repeating: .init(spacing: 12), count: 2), spacing: 12) {
                ForEach(JournalEntry.EntryType.allCases, id: \.self) { type in
                    VStack(spacing: 8) {
                        Image(type.icon)
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(height: 32)
                        
                        Text(type.rawValue)
                            .font(.poppins(.medium, size: 16))
                    }
                    .foreground(selectedType == type ? "31383E" : "FFFDFE")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(selectedType == type ? "F0C042" : "3D454C"))
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedType = type
                    }
                }
            }
        }
    }
    
    private var intensityLevelSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Intensity Level")
                .font(.poppins(.medium, size: 14))
                .foreground("D1D5DB")

            VStack(spacing: 8) {
                HStack {
                    Text("Low")
                        .font(.poppins(.regular, size: 14))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("High")
                        .font(.poppins(.regular, size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 4)
                
                
                CustomSlider(
                    value: Binding(
                        get: { Double(intensityLevel) },
                        set: { intensityLevel = Int($0) }
                    ),
                    range: 1...10,
                    step: 1
                )
                
                HStack {
                    ForEach(1...10, id: \.self) { number in
                        Text("\(number)")
                            .font(.poppins(.regular, size: 12))
                            .foreground("9CA3AF")
                            .frame(maxWidth: .infinity)
                    }
                }
                
                Text("\(intensityLevel)")
                    .font(.poppins(.medium, size: 16))
                    .foreground("F0C042")
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color("3D454C"))
            }
        }
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Where did this happen?")
                .font(.poppins(.medium, size: 14))
                .foreground("D1D5DB")
            
            MainTextField(placeholder: "e.g., Home, Work, Restaurant...", text: $location)
        }
    }
    
    private var triggersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Common Triggers (Optional)")
                .font(.poppins(.medium, size: 14))
                .foreground("D1D5DB")
            
            WrappingHStack(
                items: availableTriggers,
                spacing: 8,
                action: { trigger in
                    if selectedTriggers.contains(trigger) {
                        selectedTriggers.remove(trigger)
                    } else {
                        selectedTriggers.insert(trigger)
                    }
                },
                isSelected: { trigger in
                    selectedTriggers.contains(trigger)
                }
            )
            .frame(height: 84)
        }
    }
    
    private var thoughtsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Thoughts & Feelings")
                .font(.poppins(.medium, size: 14))
                .foreground("D1D5DB")

            MainTextField(
                placeholder: "Describe what happened, how you felt, and what you did to cope... • What triggered this moment? • How did you handle it? • What would you do differently next time?",
                text: $thoughtsAndFeelings,
                isMultiline: true,
                minHeight: 176
            )
        }
    }
    
    private var saveButton: some View {
        Button {
            saveEntry()
        } label: {
            HStack(spacing: 8) {
                Image(.save)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 24)
                
                Text("Save")
            }
        }
        .buttonStyle(.customRounded)
    }
    
    private func saveEntry() {
        let newEntry = JournalEntry(
            date: date,
            type: selectedType,
            notes: "",
            intensityLevel: intensityLevel,
            location: location,
            triggers: Array(selectedTriggers),
            thoughtsAndFeelings: thoughtsAndFeelings
        )
        
        if let existingEntry = entry {
            // Update existing entry
            var updatedEntry = existingEntry
            updatedEntry.date = date
            updatedEntry.type = selectedType
            updatedEntry.intensityLevel = intensityLevel
            updatedEntry.location = location
            updatedEntry.triggers = Array(selectedTriggers)
            updatedEntry.thoughtsAndFeelings = thoughtsAndFeelings
            
            journalManager.updateEntry(updatedEntry)
        } else {
            // Add new entry
            journalManager.addEntry(newEntry)
        }
        
        goBack()
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d • yyyy 'at' hh:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
}

private struct CustomSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double

    private let trackHeight: CGFloat = 8
    private let thumbSize: CGFloat = 18

    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let progress = CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound))
            let thumbOffset = progress * (totalWidth - thumbSize)

            ZStack(alignment: .leading) {
                // Background track
                Capsule()
                    .fill(Color(.systemGray5))
                    .frame(height: trackHeight)

                // Filled portion
                Capsule()
                    .fill(Color.yellow)
                    .frame(width: thumbOffset + thumbSize / 2, height: trackHeight)

                // Draggable Thumb
                Circle()
                    .fill(Color.yellow)
                    .frame(width: thumbSize, height: thumbSize)
                    .offset(x: thumbOffset)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gesture in
                                let locationX = gesture.location.x
                                let clamped = min(max(0, locationX - thumbSize / 2), totalWidth - thumbSize)
                                let percent = clamped / (totalWidth - thumbSize)
                                let newValue = range.lowerBound + Double(percent) * (range.upperBound - range.lowerBound)
                                let stepped = (newValue / step).rounded() * step
                                value = min(max(range.lowerBound, stepped), range.upperBound)
                            }
                    )
            }
        }
        .frame(height: max(thumbSize, trackHeight))
        .animation(.easeInOut(duration: 0.25), value: value)
    }
}

private struct WrappingHStack: View {
    let items: [String]
    let spacing: CGFloat
    let action: (String) -> Void
    let isSelected: (String) -> Bool
    
    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }
    
    private func generateContent(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        
        return ZStack(alignment: .topLeading) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                Button(action: { action(item) }) {
                    Text(item)
                        .font(.poppins(.regular, size: 14))
                        .foreground(isSelected(item) ? "31383E" : "D1D5DB")
                        .padding(.horizontal, 12)
                        .frame(height: 38)
                        .background {
                            if isSelected(item) {
                                RoundedRectangle(cornerRadius: 19)
                                    .fill(Color("F0C042"))
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 19)
                                        .fill(Color("3D454C"))
                                    RoundedRectangle(cornerRadius: 19)
                                        .strokeBorder(Color("4B5563"), lineWidth: 1)
                                }
                            }
                        }
                }
                .alignmentGuide(.leading) { dimension in
                    if abs(width - dimension.width) > geometry.size.width {
                        width = 0
                        height -= dimension.height + spacing
                    }
                    let result = width
                    if index == items.count - 1 {
                        width = 0
                    } else {
                        width -= dimension.width + spacing
                    }
                    return result
                }
                .alignmentGuide(.top) { dimension in
                    let result = height
                    if index == items.count - 1 {
                        height = 0
                    }
                    return result
                }
            }
        }
    }
}

#Preview {
    AddEditEntryView()
        .environmentObject(JournalManager())
}
