//
//  ContentView.swift
//  SwiftUIViewToPDFPOC
//
//  Created by Arya Vashisht on 10/10/24.
//

import SwiftUI

enum UrlPath {
  static let url = "\(UUID().uuidString).pdf"
}

struct ContentView: View {
  
  var body: some View {
    ShareLink("Export PDF", item: PDFRenderer().render(view: SampleView()))
  }
}

#Preview {
  ContentView()
}
