//
//  AddView.swift
//  shoppinglist
//
//  Created by refirio.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentation
    @State private var name = ""
    @State private var birthday = Date()
    @State private var memo = ""

    var body: some View {
        Form {
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
                persons.append(
                    Person(
                        name: name,
                        birthday: birthday,
                        memo: memo
                    )
                )
                for temp in temps {
                    persons.append(temp)
                }
                
                savePersons(data: persons)

                self.presentation.wrappedValue.dismiss()
            }) {
                HStack {
                    Spacer()
                    Image(systemName: "checkmark.square")
                    Text("追加")
                    Spacer()
                }
            }
        }
        .navigationTitle("追加")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // 初期値を20年前の日付に変更
            birthday = Calendar.current.date(byAdding: .year, value: -20, to: birthday)!
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
