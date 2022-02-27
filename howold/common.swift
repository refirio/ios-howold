//
//  common.swift
//  howold
//
//  Created by refirio.
//

import Foundation

struct Person: Identifiable, Codable {
    var id = UUID()
    var name: String
    var birthday: Date
    var memo: String
}

func loadPersons() -> [Person] {
    var persons: [Person] = []

    if let data = UserDefaults.standard.value(forKey: "persons") as? Data {
        persons = try! PropertyListDecoder().decode(Array<Person>.self, from: data)
    } else {
        persons = []
    }

    return persons
}

func savePersons(data persons: [Person]) -> Void {
    UserDefaults.standard.set(try? PropertyListEncoder().encode(persons), forKey: "persons")
}

var dateFormat: DateFormatter {
    let format = DateFormatter()
    format.dateStyle = .full // .full | .long | .medium | .short | .none
    format.timeStyle = .full // .full | .long | .medium | .short | .none
    format.locale = Locale(identifier: "ja_JP")
    format.calendar = Calendar(identifier: .japanese)
    format.dateFormat = "YYYY-MM-dd"
    return format
}

func showAge(date: Date, kazoe: Bool) -> String {
    let dateArray = dateFormat.string(from: date).split(separator: "-")

    let year = Int(dateArray[0]) ?? 0
    let month = Int(dateArray[1]) ?? 0
    let day = Int(dateArray[2]) ?? 0

    var string = ""
    if kazoe == true {
        let today = dateFormat.string(from: Date()).split(separator: "-")
        let todayYear = Int(today[0]) ?? 0
        string = String(todayYear - year + 1)
    } else {
        let birthday = Int(String(format: "%04d%02d%02d", year, month, day))!
        let today = Int(dateFormat.string(from: Date()).replacingOccurrences(of: "-", with: ""))!
        string = String((today - birthday) / 10000)
    }
    string = string + "歳"

    return string
}

func showDate(date: Date) -> String {
    let dateArray = dateFormat.string(from: date).split(separator: "-")

    let year = Int(dateArray[0]) ?? 0
    let month = Int(dateArray[1]) ?? 0
    let day = Int(dateArray[2]) ?? 0

    let result = getWareki(year: Int(year), month: Int(month), day: Int(day))

    var string = ""
    string = String(year) + "年"
    string = string + "（" + result.0 + String(result.1) + "年）"
    string = string + String(month) + "月"
    string = string + String(day) + "日"

    return string
}

func getWareki(year: Int, month: Int, day: Int) -> (String, Int) {
    let date = Int(String(format: "%04d%02d%02d", year, month, day))!
    var wareki = ""
    var w_year = year

    if date >= 20190501 {
        wareki = "令和";
        w_year -= 2018;
    } else if date >= 19890108 {
        wareki = "平成"
        w_year -= 1988;
    } else if date >= 19261225 {
        wareki = "昭和";
        w_year -= 1925;
    } else if date >= 19120730 {
        wareki = "大正";
        w_year -= 1911;
    } else if date >= 18680125 {
        wareki = "明治";
        w_year -= 1867;
    } else {
        wareki = "";
    }

    return (wareki, w_year)
}
