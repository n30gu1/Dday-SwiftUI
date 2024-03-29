//
//  ComplicationController.swift
//  WatchDday WatchKit Extension
//
//  Created by Seongheon Park on 2022/01/21.
//  Copyright © 2022 n30gu1. All rights reserved.
//

import ClockKit
import SwiftUI

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Complication Configuration

    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "Dday-SwiftUI", supportedFamilies: CLKComplicationFamily.allCases)
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Do any necessary work to support these newly shared complication descriptors
    }

    // MARK: - Timeline Configuration
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        // Call the handler with your desired behavior when the device is locked
        handler(.showOnLockScreen)
    }

    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
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
        if let template = makeTemplate(dday: dday, complication: complication) {
            let entry = CLKComplicationTimelineEntry(
                date: Date(),
                complicationTemplate: template)
            handler(entry)
        } else {
            handler(nil)
        }
        
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }

    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
}

extension ComplicationController {
  func makeTemplate(
    dday: Dday?,
    complication: CLKComplication
  ) -> CLKComplicationTemplate? {
    switch complication.family {
    case .graphicCircular:
      return CLKComplicationTemplateGraphicCircularView(
        ComplicationViewCircular(
            dday: dday
        ))
    case .graphicBezel:
        let textProvider = CLKTextProvider(format: getDdayString(dday: dday))
        return CLKComplicationTemplateGraphicBezelCircularText(circularTemplate: CLKComplicationTemplateGraphicCircularView(ComplicationViewCircularWithBezel()), textProvider: textProvider)
    case .graphicRectangular:
        return CLKComplicationTemplateGraphicRectangularFullView(ComplicationViewGraphicRectangular(dday: dday))
    case .utilitarianLarge:
        let textProvider = CLKTextProvider(format: getDdayString(dday: dday))
        let imageProvider = CLKImageProvider(onePieceImage: UIImage(systemName: "calendar")!)
        return CLKComplicationTemplateUtilitarianLargeFlat(textProvider: textProvider, imageProvider: imageProvider)
    case .utilitarianSmall:
        let textProvider = CLKTextProvider(format: getDdayString(dday: dday))
        let imageProvider = CLKImageProvider(onePieceImage: UIImage(systemName: "calendar")!)
        return CLKComplicationTemplateUtilitarianSmallFlat(textProvider: textProvider, imageProvider: imageProvider)
    default:
      return nil
    }
  }
}
