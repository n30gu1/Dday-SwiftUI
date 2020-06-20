//
//  DdayRow.swift
//  Dday-SwiftUI
//
//  Created by 박성헌 on 18/11/2019.
//  Copyright © 2019 n30gu1. All rights reserved.
//

import SwiftUI

struct DdayRow: View {
    let title: String?
    let date: Date?
    let sfdo: Bool
    let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title ?? "D-Day")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                Text(dateFormatter.string(from: date!))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            if sfdo {
                Text("D+\(self.calcDate(date: date) + 1)")
                    .font(.system(size: 22))
            } else {
                if self.calcDate(date: date) < 0 {
                    Text("D\(self.calcDate(date: date))")
                        .font(.system(size: 22))
                } else if self.calcDate(date: date) == 0 {
                    Text("D-Day")
                        .font(.system(size: 22))
                } else {
                    Text("D+\(self.calcDate(date: date))")
                        .font(.system(size: 22))
                }
            }
        }
    }
    
    func calcDate(date: Date?) -> Int {
        return date!.totalDistance(from: self.today!, resultIn: .day)!
    }
}

struct DdayRow_Previews: PreviewProvider {
    static var previews: some View {
        DdayRow(title: "title", date: Date(), sfdo: true)
            .previewLayout(.fixed(width: 375, height: 50))
    }
}
