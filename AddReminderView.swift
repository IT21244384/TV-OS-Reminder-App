import SwiftUI

struct AddReminderView1: View {
    @Binding var reminders: [String]
    @State private var newReminder = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("Add a New Reminder")
                .font(.largeTitle)
                .bold()
                .padding()

            // Custom TextField Style
            HStack {
                TextField("Enter reminder", text: $newReminder)
                    .padding()
                    .font(.title)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12) // Make it rounded
                    .padding(.horizontal, 20)
                    .focusable(true) // Make it focusable on tvOS remote
                    .onSubmit {
                        // Optionally handle submit action
                    }
            }
            .padding(.vertical)

            Button(action: {
                if !newReminder.isEmpty {
                    reminders.append(newReminder)
                    dismiss()
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

struct AddReminderView_Previews: PreviewProvider {
    static var previews: some View {
        AddReminderView1(reminders: .constant(["Test Reminder"]))
    }
}
