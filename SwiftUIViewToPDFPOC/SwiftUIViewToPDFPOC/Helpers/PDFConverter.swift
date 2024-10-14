//
//  PDFConverter.swift
//  SwiftUIViewToPDFPOC
//
//  Created by Arya Vashisht on 10/10/24.
//

import PDFKit
import SwiftUI
import Foundation

enum PageSizing {
  case a4
  
  var pageSize: CGSize {
    switch self {
    case .a4:
      return CGSize(width: 595.2 , height: 841.8)
    }
  }
}

@MainActor
struct PDFRenderer<Content> where Content : View {
  /// Used to render
  /// - Parameter view: The SwiftUI View that you want to be rendered
  /// - Parameter urlPathString:The path at which the pdf is to be updated
  /// - Returns: Returns the URL at which the pdf was updated
  func render(
    urlPathString: String = UrlPath.url,
    view: Content,
    headerView: Content,
    footerView: Content
  ) -> URL {

    let header = AnyView(headerView)
    let footer = AnyView(footerView)
    
    let renderer = ImageRenderer(content: view)
    let url = URL.documentsDirectory.appending(path: UrlPath.url)
    
    renderer.render { size, context in
      let pageSize = PageSizing.a4.pageSize
      /// Current y position of the pdf renderer
      var currentY: CGFloat = 0
      /// Current page number at which the pdf renderer is
      var currentPageNumber = 1
      /// Page size
      var box = CGRect(x: 0, y: 0, width: pageSize.width, height: pageSize.height)
      
      /// Create the CGContext for our PDF pages
      guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
        return
      }
      
      /// Start rendering the content for each page in loop
      while currentY < size.height {
        
        let numberOfCutFrames = size.height / PageSizing.a4.pageSize.height
        
        /// For page to show clipping from the start.
        /// By default the box cuts from the bottom of the view
        let translateValue: CGFloat = CGFloat(numberOfCutFrames - CGFloat(currentPageNumber)) * (PageSizing.a4.pageSize.height)
        
        /// Begin new pdf page
        pdf.beginPDFPage(nil)
        
        /// Save the graphics state before translating
        pdf.saveGState()
        
        /// Translate the original content by -y
        pdf.translateBy(x: 0, y: -translateValue)

        pdf.restoreGState()
        
        /// Render the view on the page
        context(pdf)
        
        /// Restore the graphics state to prevent cumulative translations
        pdf.restoreGState()
        
        /// End the current page
        pdf.endPDFPage()
        
        /// Move the currentY position forward by the page height
        currentY += pageSize.height
        /// Move Current page number to next
        currentPageNumber += 1
      }
      
      /// Close the PDF file
      pdf.closePDF()
    }
    
    return url
  }
}
