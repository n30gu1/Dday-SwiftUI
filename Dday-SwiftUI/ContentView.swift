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
    @FetchRequest(entity: Dday.entity(), sortDescriptors:
        [NSSortDescriptor(key: "startFromDayOne", ascending: true),
        NSSortDescriptor(key: "date", ascending: true)]
    ) var ddays: FetchedResults<Dday>
    
    @State private var showAddView = false
    
    let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.ddays, id: \.self) { dday in
                    DdayRow(title: dday.title, date: dday.date, sfdo: dday.startFromDayOne)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
