//
//  ContentView.swift
//  Coverflow
//
//  Created by Егор Аблогин on 01.04.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var items: [CoverFlowItem] = [
        .red,
        .blue,
        .green,
        .yellow
    ].compactMap {
        .init(color: $0)
    }
    /// View Properties
    @State private var spacing: CGFloat = 0
    @State private var rotation: CGFloat = .zero
    @State private var enableReflections: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer(minLength: 0)
                
                CoverFlowView(
                    itemWidth: 280,
                    enableReflections: enableReflections,
                    spacing: spacing,
                    rotation: rotation,
                    items: items
                ) { item in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(item.color.gradient)
                }
                .frame(height: 180)
                
                Spacer(minLength: 0)
                
                /// Customization View
                VStack(alignment: .leading, spacing: 10) {
                    Toggle("Toggle reflection", isOn: $enableReflections)
                    
                    Text("Card Spacing")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    
                    Slider(value: $spacing, in: -90...20)
                    
                    Text("Card Rotation")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    
                    Slider(value: $rotation, in: 0...90)
                }
                .padding(15)
                .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                .padding(15)
            }
            .navigationTitle("Coverflow")
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
