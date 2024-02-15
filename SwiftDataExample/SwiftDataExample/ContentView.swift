//
//  ContentView.swift
//  SwiftDataExample
//
//  Created by singsys on 04/10/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var isShowingSheet: Bool = false
    @Query(sort: \Expense.date) var expenses: [Expense]
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(expenses) { expense in
                    ExpenseCell(expense: expense)
                }
            }
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $isShowingSheet) {
                AddExpenseSheet()
            }
            .toolbar {
                if !expenses.isEmpty {
                    Button("Add Expense", systemImage: "plus") {
                        isShowingSheet = true
                    }
                }
            }
            .overlay {
                if expenses.isEmpty {
                    ContentUnavailableView(
                        label:
                            { Label("No Expenses", systemImage: "list.bullet.rectangle.portrait")
                            },
                        description: {
                            Text("Start adding expenses to see your list.")
                        },
                        actions: {
                            Button("Add Expense") {
                                isShowingSheet = true
                            }
                        })
                    .offset(y: -60)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

struct AddExpenseSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State var name: String = ""
    @State var date: Date = .now
    @State var value: Double = 0
    
    var body: some View {
        
        NavigationStack {
            Form {
                TextField("Expense Name", text: $name)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Value", value: $value, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        let expense = Expense(name: name, date: date, value: value)
                        context.insert(expense)
                        dismiss()
                    }
                }
            }
        }
        
    }
}
struct ExpenseCell: View {
    let expense: Expense

    var body: some View {
        
        HStack {
            Text(expense.date, format: .dateTime.month(.abbreviated).day())
                .frame(width: 70, alignment: .leading)
            Text(expense.name)
            Spacer()
            Text(expense.value, format: .currency(code: "USD"))
        }
    }
}
