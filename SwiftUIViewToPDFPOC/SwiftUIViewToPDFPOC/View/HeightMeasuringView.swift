//
//  HeightMeasuringView.swift
//  SwiftUIViewToPDFPOC
//
//  Created by Arya Vashisht on 11/10/24.
//

import SwiftUI

struct ViewPreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  
  static func reduce(
    value: inout CGSize,
    nextValue: () -> CGSize
  ) {
    value = nextValue()
  }
}

//struct HeightMeasuringView<Content: View>: View {
//  let content: Content
//  let onHeightChange: (CGFloat) -> Void
//  
//  var body: some View {
//    content
//      .background(
//        GeometryReader { geometry in
//          Color.clear
//            .preference(key: ViewHeightKey.self, value: geometry.size.height)
//        }
//      )
//      .onPreferenceChange(ViewHeightKey.self) { newHeight in
//        onHeightChange(newHeight)
//      }
//  }
//}

struct HeightModifier: ViewModifier {
  @Binding var viewHeight: CGFloat
  
  func body(content: Content) -> some View {
    content
      .background(
        GeometryReader { geometry in
          Color.clear // Invisible background to measure the size
            .onAppear {
              viewHeight = geometry.size.height
            }
            .onChange(of: geometry.size.height) { newHeight in
              viewHeight = newHeight
            }
        }
      )
  }
}
