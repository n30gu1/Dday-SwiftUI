//
//  ComplicationsView.swift
//  Dday-SwiftUI
//
//  Created by Seongheon Park on 2022/01/21.
//  Copyright © 2022 n30gu1. All rights reserved.
//

import SwiftUI
import CoreData
import ClockKit

struct ComplicationsView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// 1
struct ComplicationViewCircular: View {
    let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())
    
    
    let dday: Dday? = {
        let idString = UserDefaults.standard.string(forKey: "selectedID") ?? ""
        if let url = URL(string: idString) {
            print(url)
            if let object = PersistenceController.shared.container.viewContext.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: url) {
                return PersistenceController.shared.container.viewContext.object(with: object) as? Dday
            }
            return nil
        }
        return nil
    }()
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.init(white: 0.1))
            if let unwpd = dday {
                if unwpd.startFromDayOne {
                    ComplicationCell(topString: "D+\(self.calcDate(date: unwpd.date) + 1)")
                } else {
                    if self.calcDate(date: unwpd.date) < 0 {
                        ComplicationCell(topString: "D\(self.calcDate(date: unwpd.date))")
                    } else if self.calcDate(date: unwpd.date) == 0 {
                        ComplicationCell(topString: "D-Day")
                    } else {
                        ComplicationCell(topString: "D+\(self.calcDate(date: unwpd.date))")
                    }
                }
            } else {
                ComplicationCell(topString: "None")
            }
        }
    }
    func calcDate(date: Date?) -> Int {
        return date!.totalDistance(from: self.today!, resultIn: .day)!
    }
}

struct ComplicationCell: View {
    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f
    }()
    
    let topString: String

    var body: some View {
        VStack(spacing: 0) {
            Text(topString)
                .font(.system(size: 10))
                .kerning(-0.5)
                .foregroundColor(.gray)
            Text(dateFormatter.string(from: Date()))
                .font(.system(size: 20, weight: .semibold, design: .monospaced))
                .offset(y: -2)
        }
    }
}


struct ComplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CLKComplicationTemplateGraphicCircularView( ComplicationViewCircular()).previewContext()
        }
    }
}
