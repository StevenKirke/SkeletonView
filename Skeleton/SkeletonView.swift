//
//  SkeletonView.swift
//  Skeleton
//
//  Created by Steven Kirke on 05.04.2023.
//

import SwiftUI

struct SkeletonView: View {
    @State var multiplierHeight: CGFloat = 1
    
    var body: some View {
        VStack {
            Sceleton(tempOffset: 0,
                     heighContainer: 200,
                     widthContainer: 300, shape: .roundRectangle(12))
            HStack(spacing: 0) {
                Sceleton(tempOffset: 0,
                         heighContainer: 100,
                         widthContainer: 100, shape: .circle)
                Spacer()
                VStack {
                    Sceleton(tempOffset: 0,
                             heighContainer: 20,
                             widthContainer: 200, shape: .roundRectangle(4))
                    Sceleton(tempOffset: 0,
                             heighContainer: 20,
                             widthContainer: 200, shape: .roundRectangle(4))
                    Sceleton(tempOffset: 0,
                             heighContainer: 20,
                             widthContainer: 200, shape: .roundRectangle(4))
                }
            }
            .border(.blue)
            Spacer()
            Slider(value: $multiplierHeight, in: 0...100, step: 1)
            Text("multiplierHeight - \(multiplierHeight)")
        }
        .border(.orange)
        .padding(.horizontal, 40)
    }
    
}

struct Sceleton: View {
    
    private let background: Color = Color.gray
    private let color: [Color] = [  Color.clear.opacity(0.0),
                                    Color.white.opacity(0.05),
                                    Color.white.opacity(0.2),
                                    Color.white.opacity(0.05),
                                    Color.clear.opacity(0.0)
    ]
    
    @State var tempOffset: CGFloat = 0
    
    var heighContainer: CGFloat
    var widthContainer: CGFloat
    
    
    var heigtGradient: CGFloat {
        heighContainer * (1 + (40 / 100))
    }
    var widthGradient: CGFloat = 40
    
    var shape: Form = Form.roundRectangle(3)
    
    
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
                        //.border(Color.red)
                        .rotationEffect(Angle(degrees: 7))
                        .frame(width: 100, height: heigtGradient)
                        .offset(y: (heighContainer - heigtGradient) / 2)
                        .offset(x: CGFloat(tempOffset))
                }
            }
            .onAppear() {
                DispatchQueue.main.async {
                    print("widthGradient \(widthGradient)")
                    self.tempOffset = -(widthGradient)
                    withAnimation(Animation.linear(duration: 3)
                        .repeatForever(autoreverses: false)) {
                            self.tempOffset = widthContainer + (widthGradient / 2)
                        }
                }
            }
        }
        .frame(width: widthContainer, height: heighContainer)
        //.mask(RoundedRectangle(cornerRadius: 10) .frame(width: 300, height: heightContaiener))
        .mask(shape.translation)
        //.border(.green, width: 3)
        
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


struct SkeletonView_Previews: PreviewProvider {
    static var previews: some View {
        SkeletonView()
    }
}
