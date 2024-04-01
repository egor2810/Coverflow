//
//  CoverFlowView.swift
//  Coverflow
//
//  Created by Егор Аблогин on 01.04.2024.
//

import SwiftUI

/// Custom view
struct CoverFlowView<Content: View,Item: RandomAccessCollection>: View where Item.Element: Identifiable {
    /// Customization Properties
    var itemWidth: CGFloat
    var enableReflections: Bool = false
    var spacing: CGFloat = 0
    var rotation: Double
    var items: Item
    var content: (Item.Element) -> Content
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    ForEach(items) { item in
                        content(item)
                            .frame(width: itemWidth)
                            .reflection(enableReflections)
                            .visualEffect {
                                content,
                                geometryProxy in
                                content
                                    .rotation3DEffect(
                                        .init(degrees: rotation(geometryProxy)),
                                        axis: (x: 0, y: 1, z: 0),
                                        anchor: .center
                                    )
                            }
                            .padding(.trailing, item.id == items.last?.id ? 0 : spacing)
                    }
                }
                .padding(.horizontal, (size.width - itemWidth) / 2)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
        }
        
    }
    
    func rotation(_ proxy: GeometryProxy) -> Double {
        let scrollViewWidth = proxy.bounds(of: .scrollView(axis: .horizontal))?.width ?? 0
        let midX = proxy.frame(in: .scrollView(axis: .horizontal)).midX
        
        /// Converting into progress
        let progress = midX / scrollViewWidth
        
        /// Limiting progress between 0-1
        let cappedProgress = max(min(progress, 1), 0)
        
        let degree = cappedProgress * (rotation * 2)
        
        return rotation - degree
    }
}

/// Cover Flow Item Model
struct CoverFlowItem: Identifiable {
    let id: UUID = .init()
    var color: Color
}


///View Extensions
fileprivate extension View {
    @ViewBuilder
    func reflection(_ added: Bool) -> some View {
        self
            .overlay {
                if added {
                    GeometryReader {
                        let size = $0.size
                        
                        self
                        /// Flipping Upside Down
                            .scaleEffect(y: -1)
                            .mask {
                                Rectangle()
                                    .fill(
                                        .linearGradient(
                                            colors: [
                                                .white,
                                                .white.opacity(0.7),
                                                .white.opacity(0.5),
                                                .white.opacity(0.3),
                                                .white.opacity(0.1),
                                                .white.opacity(0)
                                            ] + Array(repeating: Color.clear, count: 4),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            }
                        /// Moving to Bottom
                            .offset(y: size.height + 5)
                            .opacity(0.5)
                        
                        
                    }
                }
            }
    }
    

}
