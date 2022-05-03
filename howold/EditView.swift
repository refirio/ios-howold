//
//  EditView.swift
//  shoppinglist
//
//  Created by refirio.
//

import SwiftUI

struct EditView: View {
    @Environment(\.presentationMode) var presentation
    @State var id: UUID
    @State private var name = ""
    @State private var birthday = Date()
    @State private var memo = ""
    
    var userDefaults = UserDefaults.standard

    var body: some View {
        Form {
            Section(header: Text("入力")) {
                HStack {
                    TextField("名前", text: $name)
                }
                DatePicker("誕生日", selection: $birthday, displayedComponents: .date)
                ZStack {
                    if memo.isEmpty {
                        VStack {
                            HStack {
                                Text("メモ")
                                    .padding(EdgeInsets(
                                        top: 8,
                                        leading: 0,
                                        bottom: 0,
                                        trailing: 0
                                    ))
                                    .opacity(0.25)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    TextEditor(text: $memo)
                        .padding(EdgeInsets(
                            top: 0,
                            leading: -4,
                            bottom: 0,
                            trailing: 0
                        ))
                        .frame(height: 100)
                }
                Button(action: {
                    let temps = loadPersons()
                    
                    var persons: [Person] = []
                    for temp in temps {
                        if temp.id == id {
                            persons.append(
                                Person(
                                    id: id,
                                    name: name,
                                    birthday: birthday,
                                    memo: memo
                                )
                            )
                        } else {
                            persons.append(temp)
                        }
                    }
                    
                    savePersons(data: persons)

                    self.presentation.wrappedValue.dismiss()
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: "checkmark.square")
                        Text("編集")
                        Spacer()
                    }
                }
            }
            Section(header: Text("表示")) {
                HStack {
                    Text("満年齢")
                    Spacer()
                    Text(showAge(date: birthday, kazoe: false))
                }
                HStack {
                    Text("数え年")
                    Spacer()
                    Text(showAge(date: birthday, kazoe: true))
                }
                HStack {
                    Text("誕生日")
                    Spacer()
                    Text(showDate(date: birthday))
                }
                HStack {
                    Text("今日")
                    Spacer()
                    Text(showDate(date: Date()))
                }
            }
        }
        .navigationTitle("編集")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let persons = loadPersons()
            
            for person in persons {
                if person.id == id {
                    name = person.name
                    birthday = person.birthday
                    memo = person.memo

                    break
                }
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(id: UUID())
    }
}
