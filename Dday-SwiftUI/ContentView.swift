//
//  ContentView.swift
//  Dday-SwiftUI
//
//  Created by 박성헌 on 17/11/2019.
//  Copyright © 2019 n30gu1. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(fetchRequest: Dday.fetchAllItems()) var ddays: FetchedResults<Dday>
    
    @State private var showAddView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(ddays) { dday in
                    DdayRow(title: dday.title, date: dday.date, sfdo: dday.startFromDayOne)
                }
                .onDelete { indexPath in
                    let target = self.ddays[indexPath.first!]
                    self.moc.delete(target)
                    do {
                        try self.moc.save()
                    } catch {
                        print(error)
                    }
                }
            }
            .listStyle(.plain)
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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext)
    }
}
