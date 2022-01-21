//
//  ContentView.swift
//  WatchDday WatchKit Extension
//
//  Created by Seongheon Park on 2022/01/21.
//  Copyright © 2022 n30gu1. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(fetchRequest: Dday.fetchAllItems()) var fetchedResults: FetchedResults<Dday>
    @AppStorage("selectedID") var selectedID = UserDefaults.standard.string(forKey: "selectedID") ?? ""
    let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
    var body: some View {
        List {
            ForEach(fetchedResults) { dday in
                HStack {
                    Text(dday.title ?? "nil")
                    Spacer()
                    if dday.startFromDayOne {
                        Text("D+\(self.calcDate(date: dday.date) + 1)")
                    } else {
                        if self.calcDate(date: dday.date) < 0 {
                            Text("D\(self.calcDate(date: dday.date))")
                        } else if self.calcDate(date: dday.date) == 0 {
                            Text("D-Day")
                        } else {
                            Text("D+\(self.calcDate(date: dday.date))")
                        }
                    }
                }
                .onTapGesture {
                    UserDefaults.standard.set("\(String(describing: dday.objectID.uriRepresentation().absoluteString))", forKey: "selectedID")
                    print(UserDefaults.standard.string(forKey: "selectedID"))
                }
            }
        }
            .padding()
            .navigationTitle("Ddays")
    }
    func calcDate(date: Date?) -> Int {
        return date!.totalDistance(from: self.today!, resultIn: .day)!
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
