//
//  AddDdayView.swift
//  Dday-SwiftUI
//
//  Created by 박성헌 on 17/11/2019.
//  Copyright © 2019 n30gu1. All rights reserved.
//

import SwiftUI

struct AddDdayView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
    
    @State private var title = ""
    @State private var date = Date()
    @State private var startFromDayOne = true
    
    @State private var showAlert = false
    
    var rangeWhenTrue: ClosedRange<Date> {
        var components: DateComponents {
            var c = DateComponents()
            c.year = 1972
            c.month = 11
            c.day = 21
            return c
        }
        
        let min = Calendar.current.date(from: components)!
        return min...Date()
    }
    var rangeWhenFalse: ClosedRange<Date> {
        var components: DateComponents {
            var c = DateComponents()
            c.year = 3972
            c.month = 11
            c.day = 21
            return c
        }
        
        let max = Calendar.current.date(from: components)!
        return Date()...max
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("제목")) {
                    TextField("디데이 제목", text: $title)
                }
                Section(header: Text("날짜 선택")) {
                    DatePicker(selection: $date, in: startFromDayOne ? rangeWhenTrue : rangeWhenFalse, displayedComponents: .date) {
                        Text("")
                    }.labelsHidden()
                    Toggle(isOn: $startFromDayOne) {
                        Text("1일부터 시작")
                    }
                }
            }
        .navigationBarTitle("디데이 추가")
            .navigationBarItems(leading: Button("취소") {
                self.presentationMode.wrappedValue.dismiss()
            }, trailing: Button("저장") {
                if self.title != "" {
                    let newDday = Dday(context: self.moc)
                    newDday.title = self.title
                    newDday.date = self.date
                    newDday.startFromDayOne = self.startFromDayOne
                    
                    try? self.moc.save()
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.showAlert.toggle()
                }
            })
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("제목 없음"), message: Text("제목을 입력하세요."), dismissButton: .default(Text("확인")))
                }
        }
    }
}

struct AddDdayView_Previews: PreviewProvider {
    static var previews: some View {
        AddDdayView()
    }
}
