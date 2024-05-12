//
//  SplashScreen.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 9/5/2024.
//

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                Spacer()
                Spacer()
                Image("HVText")
                    .resizable()
                    .frame(width: 150, height: 50)
                    .scaledToFit()
                Spacer()
                Image("HVPlayer")
                    .resizable()
                    .frame(width: 300, height: 354)
                Spacer()
                Text("by Brett Moxey")
                    .foregroundStyle(Color("TextColor"))
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color("BackColor"))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
