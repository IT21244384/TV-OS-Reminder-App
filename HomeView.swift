import SwiftUI

// Reminder model to represent each reminder
struct Reminder: Identifiable {
    let id = UUID()
    var title: String
    var isChecked: Bool
}

// Main View: HomeView
struct HomeView: View {
    @State private var reminders: [Reminder] = [
        Reminder(title: "Doctor's appointment at 3 PM", isChecked: false),
        Reminder(title: "Buy groceries", isChecked: false),
        Reminder(title: "Call Mary", isChecked: false),
        Reminder(title: "Meeting with the team at 4 PM", isChecked: false),
        Reminder(title: "Pick up dry cleaning", isChecked: false)
    ]
    
    @State private var showingAddReminder = false
    @State private var activeReminders: [String] = [] // Reminders to display in the ticker
    @State private var isScrolling = false  // Controls the start of the scrolling animation

    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background
                LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.white]),
                               startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Text("Reminders")
                        .font(.largeTitle)
                        .bold()
                        .padding()

                    List {
                        ForEach($reminders) { $reminder in  // Use $reminder to bind each reminder
                            HStack {
                                Text(reminder.title)
                                    .font(.title2)
                                    .strikethrough(reminder.isChecked)
                                    .padding()
                                    .foregroundColor(reminder.isChecked ? .gray : .primary)

                                Spacer()

                                // Checkmark button to toggle completion status
                                Button(action: {
                                    reminder.isChecked.toggle() // Toggle the isChecked state directly
                                }) {
                                    Image(systemName: reminder.isChecked ? "checkmark.circle.fill" : "circle")
                                        .font(.title)
                                        .foregroundColor(.green)
                                        .padding()
                                }

                                // Trash button to delete reminder
                                Button(action: {
                                    if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
                                        reminders.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "trash.fill")
                                        .font(.title)
                                        .foregroundColor(.red)
                                        .padding()
                                }

                                // Show in Ticker button to add the reminder to the ticker
                                Button(action: {
                                    showInTicker(reminder.title)
                                }) {
                                    Text("Show")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                        .padding(10)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                }
                                .padding(.trailing)
                            }
                            .padding(.vertical, 5)
                        }
                        .onDelete(perform: deleteReminder)
                    }

                    // Button to show the "Add Reminder" screen
                    Button(action: {
                        showingAddReminder.toggle()
                    }) {
                        Text("Add Reminder")
                            .font(.title)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .focusable(true) // Ensure it's focusable for tvOS
                    }
                    .padding(.bottom)
                }
                .sheet(isPresented: $showingAddReminder) {
                    AddReminderView(reminders: $reminders) // Pass Binding<[Reminder]>
                }

                // Scrollable Ticker at the top of the screen
                if isScrolling {
                    ScrollableTicker(reminders: $activeReminders)
                        .frame(height: 50)
                        .padding(.top, 20)
                        .transition(.move(edge: .top))
                        .animation(.linear(duration: Double(activeReminders.count) * 2), value: isScrolling)
                }
            }
        }
    }

    // Function to show the reminder in the ticker
    private func showInTicker(_ reminder: String) {
        // Set the active reminders to be displayed in the ticker
        activeReminders = [reminder]
        isScrolling = true
        
        // Automatically stop scrolling after 10 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            isScrolling = false
        }
    }

    // Delete reminder method for swipe-to-delete functionality
    private func deleteReminder(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
    }
}

// Ticker View: Displays reminders as a scrolling news ticker
struct ScrollableTicker: View {
    @Binding var reminders: [String]
    
    var body: some View {
        HStack {
            // Repeat the list of reminders infinitely by duplicating them
            ForEach(reminders, id: \.self) { reminder in
                Text(reminder)
                    .font(.headline)
                    .padding(.horizontal, 20)
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
            }
        }
        .offset(x: UIScreen.main.bounds.width)
        .animation(.linear(duration: Double(reminders.count) * 5).repeatForever(autoreverses: false), value: reminders)
        .onAppear {
            // Start the animation immediately when the ticker appears
        }
    }
}

// AddReminderView for adding a new reminder
struct AddReminderView: View {
    @Binding var reminders: [Reminder]  // Binding to the reminders list
    @State private var newReminder = ""  // Local state for the new reminder
    @Environment(\.dismiss) private var dismiss  // Dismiss the view when done

    var body: some View {
        VStack {
            Text("Add a New Reminder")
                .font(.largeTitle)
                .bold()
                .padding()

            // Custom TextField for entering reminder
            TextField("Enter reminder", text: $newReminder)
                .padding()
                .font(.title)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal, 20)
                .focusable(true)

            Button(action: {
                if !newReminder.isEmpty {
                    let newReminderItem = Reminder(title: newReminder, isChecked: false)
                    reminders.append(newReminderItem)
                    dismiss()  // Close the AddReminderView when saved
                }
            }) {
                Text("Save Reminder")
                    .font(.title2)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
