//
//  SampleView.swift
//  SwiftUIViewToPDFPOC
//
//  Created by Arya Vashisht on 10/10/24.
//

import SwiftUI

struct SampleView: View {
  var body: some View {
    ScrollView {
      VStack {
        ForEach(0..<100) { i in
          HStack {
            Text("Item \(i)")
            Spacer()
          }
          .padding(.leading)
        }
      }
      .frame(maxWidth: .infinity)
    }
  }
}

#Preview {
  SampleView()
}
