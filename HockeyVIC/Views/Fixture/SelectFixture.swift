//
//  SelectFixture.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 7/5/2024.
//

import SwiftUI

struct SelectFixture: View {
    @Binding var fixtures: [Fixture]
    @Binding var currentFixture: Fixture?
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(fixtures, id: \.self) { fixture in
                        VStack {
                            Text(fixture.roundNo)
                                .foregroundStyle(Color("TextColor"))
                                .multilineTextAlignment(.center)
                                .fontWeight(.bold)
                            Text(getDay(date: fixture.date))
                                .foregroundStyle(Color("TextColor"))
                                .multilineTextAlignment(.center)
                                .font(.footnote)
                        }
                        .frame(width: 150, height: 80)
                        .background(Color("BackColor"))
                        .cornerRadius(15.0)
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                        .shadow(radius: 5, y: 5)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.75)
                                .scaleEffect(phase.isIdentity ? 1 : 0.5)
                                .saturation(phase.isIdentity ? 1 : 0.75)
                                .rotation3DEffect(.init(radians: phase.value*1.57), axis: (0,0,1))
                        }
                        .onTapGesture {
                            self.currentFixture = fixture
                        }
                    }
                }
                .frame(height: 115)
                .scrollTargetLayout()
            }
            .safeAreaPadding(.horizontal, CGFloat(UIScreen.main.bounds.width/3))
            .scrollTargetBehavior(.viewAligned)
            .scrollClipDisabled()
            .scrollPosition(id: $currentFixture, anchor: .center)
            .background(Color("AccentColor"))
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                guard let currentFixture, let index = fixtures.firstIndex(of: currentFixture) ,
                                      index > 0 else { return }
                                self.currentFixture = fixtures[index - 1]
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(currentFixture == fixtures.first ? Color.clear : Color("AccentColor"))
                                .font(Font.system(size: 17, weight: .semibold))
                        }
                        Spacer()
                        ForEach(fixtures, id: \.self) {fixture in
                            let isCurrent = fixture.roundNo == currentFixture?.roundNo ?? "1"
                            let col = getColor(result: fixture.result)
                            Image(systemName: getSymbol(result: fixture.result, roundNo: fixture.roundNo, isCurrent: isCurrent))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(isCurrent ? col : Color("NavyBlue"), isCurrent ? Color("NavyBlue") : col)
                                .scaleEffect(isCurrent ? 1.2 : 0.8)
                                .padding(.all, -5)
                                .onTapGesture {
                                    withAnimation {
                                        currentFixture = fixture
                                    }
                                }
                        }
                        Spacer()
                        Button {
                            withAnimation {
                                guard let currentFixture, let index = fixtures.firstIndex(of: currentFixture),
                                      index < fixtures.count - 1 else { return }
                                self.currentFixture = fixtures[index + 1]
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(currentFixture == fixtures.last ? Color.clear : Color("AccentColor"))
                                .font(Font.system(size: 17, weight: .semibold))
                        }
                        Spacer()
                    }
                    .frame(minWidth: geometry.size.width)
                    .frame(height: 25)
                }
            }
            .frame(height: 25)
            .background(Color.white)
        }
        .background(Color.white)
    }
}

#Preview {
    SelectFixture(fixtures: .constant([]), currentFixture: .constant(Fixture()))
}
