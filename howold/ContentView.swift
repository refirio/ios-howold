//
//  ContentView.swift
//  howold
//
//  Created by refirio.
//

import SwiftUI

struct ContentView: View {
    @State private var persons: [Person] = []

    var body: some View {
        NavigationView {
            List {
                ForEach(persons) { person in
                    NavigationLink(destination: EditView(id: person.id).onDisappear(perform: {
                        persons = loadPersons()
                    })) {
                        HStack {
                            Text(person.name)
                            Spacer()
                            Text(showAge(date: person.birthday, kazoe: false))
                        }
                    }
                }
                .onMove(perform: move)
                .onDelete(perform: delete)
            }
            .navigationBarTitle("年齢一覧")
            .navigationBarItems(trailing:
                HStack {
                    NavigationLink(destination: AddView().onDisappear(perform: {
                        persons = loadPersons()
                    })) {
                        Image(systemName: "person.badge.plus")
                    }
                    MyEditButton()
                }
            )
        }
        .onAppear {
            persons = loadPersons()
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        persons.move(fromOffsets: source, toOffset: destination)

        savePersons(data: persons)
    }

    func delete(at offsets: IndexSet) {
        persons.remove(atOffsets: offsets)

        savePersons(data: persons)
    }
}

struct MyEditButton: View {
    @Environment(\.editMode) var editMode
    
    var body: some View {
        Button(action: {
            withAnimation() {
                if editMode?.wrappedValue.isEditing == true {
                    editMode?.wrappedValue = .inactive
                } else {
                    editMode?.wrappedValue = .active
                }
            }
        }) {
            if editMode?.wrappedValue.isEditing == true {
                Image(systemName: "checkmark.square")
            } else {
                Image(systemName: "list.bullet")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
