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

struct ComplicationViewCircular: View {
    let dday: Dday?
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.init(white: 0.1))
            ComplicationCell(topString: getDdayString(dday: dday))
        }
    }
}

struct ComplicationViewCircularWithBezel: View {
    let f: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return f
    }()
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.init(white: 0.1))
            ComplicationCell(topString: f.string(from: Date()).uppercased())
        }
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
                .foregroundColor(.red)
            Text(dateFormatter.string(from: Date()))
                .font(.system(size: 20, weight: .semibold, design: .monospaced))
                .offset(y: -2)
        }
    }
}

struct ComplicationViewGraphicRectangular: View {
    let dday: Dday?
    let f: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy. M. d."
        return f
    }()
    
    
    var body: some View {
        if let dday = dday {
            let upcomingAnniversary = compare(value: calcDate(date: dday.date))
            let days = calcDate(date: dday.date)
            HStack {
                VStack(alignment: .leading) {
                    Text(dday.title ?? "nil Error")
                        .bold()
                    Text(f.string(from: dday.date ?? Date()))
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .padding(.bottom, -10)
                        .foregroundColor(.gray)
                    Text("D+\(days)")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("D+\(upcomingAnniversary)")
                    Text(f.string(from: Date().addingTimeInterval(TimeInterval(upcomingAnniversary) * 86400)))
                        .font(.system(size: 12, weight: .regular, design: .rounded))
                        .padding(.bottom, -10)
                    Text(String(format: "%.0f%%", Double(days)/Double(upcomingAnniversary)*100))
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                }
            }
        } else {
            Text("No Dday Selected")
        }
    }
}

func compare(value: Int) -> Int {
    let criteria = [50, 100, 200, 300, 500, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 365, 365*2, 365*3, 365*4, 365*5, 365*6].sorted()
    for i in 0...criteria.count-1 {
        if (i == 0 ? 0 : criteria[i-1]) < value && value < criteria[i] {
            return criteria[i]
        }
    }
    return 0
}


struct ComplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CLKComplicationTemplateGraphicCircularView(ComplicationViewCircular(dday: nil)).previewContext()
            CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: CLKComplicationTemplateGraphicCircularView(ComplicationViewCircularWithBezel()), textProvider: CLKTextProvider(format: "None")).previewContext()
            CLKComplicationTemplateGraphicRectangularFullView(ComplicationViewGraphicRectangular(dday: nil)).previewContext()
        }
    }
}
