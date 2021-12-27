//
//  About.swift
//  assign3
//
//  Created by Duy on 10/8/21.
//

import SwiftUI

struct About: View {
    @State var showButton = false
    @State var isRotated: Bool = false
    @State var isShown: Bool = true
    @EnvironmentObject var twos : Twos
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @State var coinName : String = ""
    var body: some View {
        if(verticalSizeClass == .compact && horizontalSizeClass == .compact) {
            HStack {
                Text("Tap the coin to flip the coin!")
                    .font(.largeTitle)
                    .padding()
                Spacer()
                Text(twos.coin)
                    .padding()
                    .font(.system(size: 60))
                    .foregroundColor(.black)
                    .opacity(isShown ? 1 : 0)
                    .background(Circle()
                                    .fill(Color.yellow)
                                    .frame(width: 300, height: 300, alignment: .center)
                    )
                    .frame(width: 300, height: 300)
                    .rotation3DEffect(Angle.degrees(isRotated ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                    .onTapGesture {
                        withAnimation(Animation.linear(duration: 0.5).repeatCount(3, autoreverses: false)) {
                            isRotated.toggle()
                        }
                        isShown.toggle()
                        twos.flipCoin()
                        withAnimation(Animation.spring().delay(1.5)) {
                            isShown.toggle()
                        }
                    }
                Spacer()
                Text("You got \(twos.coin)")
                    .font(.largeTitle)
                    .padding()
                    .opacity(isShown ? 1 : 0)
                Spacer()
            }
        } else {
            VStack {
                Text("Tap the coin to flip the coin!")
                    .font(.largeTitle)
                    .padding()
                Spacer()
                Text(twos.coin)
                    .padding()
                    .font(.system(size: 60))
                    .foregroundColor(.black)
                    .opacity(isShown ? 1 : 0)
                    .background(Circle()
                                    .fill(Color.yellow)
                                    .frame(width: 300, height: 300, alignment: .center)
                    )
                    .frame(width: 300, height: 300)
                    .rotation3DEffect(Angle.degrees(isRotated ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                    .onTapGesture {
                        withAnimation(Animation.linear(duration: 0.5).repeatCount(3, autoreverses: false)) {
                            isRotated.toggle()
                        }
                        isShown.toggle()
                        twos.flipCoin()
                        withAnimation(Animation.spring().delay(1.5)) {
                            isShown.toggle()
                        }
                    }
                Spacer()
                Text("You got \(twos.coin)")
                    .font(.largeTitle)
                    .padding()
                    .opacity(isShown ? 1 : 0)
                Spacer()
            }
        }
    }
}

func spinAnimation() -> Animation {
    return Animation.linear(duration: 1).repeatCount(5, autoreverses: false)
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About().environmentObject(Twos())
    }
}
