//
//  SkeletonView.swift
//  Skeleton
//
//  Created by Steven Kirke on 05.04.2023.
//

import SwiftUI

struct SkeletonView: View {
    
    var body: some View {
        VStack {
            Sceleton(heighContainer: 200,
                     widthContainer: 300, shape: .roundRectangle(12))
            HStack(spacing: 0) {
                Sceleton(heighContainer: 100,
                         widthContainer: 100, shape: .circle)
                Spacer()
                VStack {
                    Sceleton(heighContainer: 20,
                             widthContainer: 200)
                    Sceleton(heighContainer: 20,
                             widthContainer: 200)
                    Sceleton(heighContainer: 20,
                             widthContainer: 200)
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0...5, id: \.self) { elem in
                        Sceleton(heighContainer: 200,
                                 widthContainer: 200, shape: .roundRectangle(12))
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal, 40)
    }
}

struct Sceleton: View {
    
    private let background: Color = Color.black.opacity(0.1)
    private let color: [Color] = [
        Color.gray.opacity(0.0),
        Color.gray.opacity(0.1),
        Color.gray.opacity(0.0)
    ]
    
    @State var tempOffset: CGFloat = 0
    
    var heighContainer: CGFloat
    var widthContainer: CGFloat
    
    var widthGradient: CGFloat = 100
    var heigtGradient: CGFloat {
        heighContainer * (1 + (40 / 100))
    }
    var shape: Form = Form.roundRectangle(6)
    
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { proxy in
                    background
                        .frame(maxHeight: heighContainer)
                    Rectangle()
                        .fill(
                            LinearGradient(colors: color, startPoint: .leading, endPoint: .trailing)
                        )
                        .background(LinearGradient(colors: color, startPoint: .leading, endPoint: .trailing))
                        .rotationEffect(Angle(degrees: 7))
                        .frame(width: widthGradient, height: heigtGradient)
                        .offset(y: (heighContainer - heigtGradient) / 2)
                        .offset(x: CGFloat(tempOffset))
                }
            }
            .onAppear() {
                DispatchQueue.main.async {
                    self.tempOffset = -(widthGradient)
                    withAnimation(Animation.linear(duration: 3)
                        .repeatForever(autoreverses: false)) {
                            self.tempOffset = widthContainer + (widthGradient / 2)
                        }
                }
            }
        }
        .frame(width: widthContainer, height: heighContainer)
        .mask(shape.translation)
    }
}

extension Sceleton {
    enum Form  {
        case rectangle
        case roundRectangle(_ radius: CGFloat)
        case circle
        
        var translation: AnyView {
            switch self {
                case .rectangle:
                    return  AnyView(Rectangle())
                case .roundRectangle(let radius):
                    return  AnyView(RoundedRectangle(cornerRadius: radius))
                case .circle:
                    return  AnyView(Circle())
            }
        }
    }
}

#if DEBUG
struct SkeletonView_Previews: PreviewProvider {
    static var previews: some View {
        SkeletonView()
    }
}
#endif
