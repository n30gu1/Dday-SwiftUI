//
//  ContentView.swift
//  Dday-SwiftUI
//
//  Created by 박성헌 on 17/11/2019.
//  Copyright © 2019 n30gu1. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Dday.entity(), sortDescriptors: []) var ddays: FetchedResults<Dday>
    
    @State private var showAddView = false
    
    let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.ddays, id: \.self) { dday in
                    HStack() {
                        Text(dday.title ?? "D-Day")
                        Spacer()
                        if dday.startFromDayOne {
                            Text("D+\(self.calcDate(date: dday.date))")
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
                }
                .onDelete { indexPath in
                    let target = self.ddays[indexPath.first!]
                    self.moc.delete(target)
                    try? self.moc.save()
                }
            }
            .navigationBarTitle("디데이 목록")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {self.showAddView.toggle()}) {
                HStack {
                    Text("디데이 추가")
                    Image(systemName: "plus")
                }
            })
                .sheet(isPresented: $showAddView) {
                    AddDdayView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
    
    func calcDate(date: Date?) -> Int {
        return date!.totalDistance(from: self.today, resultIn: .day)!
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
