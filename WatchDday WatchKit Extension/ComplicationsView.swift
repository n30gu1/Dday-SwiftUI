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
    let dday: Dday?
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


struct ComplicationsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CLKComplicationTemplateGraphicCircularView(ComplicationViewCircular(dday: nil)).previewContext()
            CLKComplicationTemplateGraphicCircularView(ComplicationViewCircularWithBezel(dday: nil)).previewContext()
        }
    }
}
