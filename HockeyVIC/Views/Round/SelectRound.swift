//
//  SelectRound.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 8/5/2024.
//

import SwiftUI

struct SelectRound: View {
    @Binding var rounds: [Rounds]
    @Binding var currentRound: Rounds?
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(rounds, id: \.self) { item in
                            VStack {
                                Text(item.roundNo)
                                    .foregroundStyle(Color("TextColor"))
                                    .multilineTextAlignment(.center)
                                    .fontWeight(.bold)
                                Text(item.textdate)
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
                                self.currentRound = item
                            }
                        }
                    }
                    .frame(height: 115)
                    .scrollTargetLayout()
                }
                .safeAreaPadding(.horizontal, CGFloat(UIScreen.main.bounds.width/3))
                .scrollTargetBehavior(.viewAligned)
                .scrollClipDisabled()
                .scrollPosition(id: $currentRound, anchor: .center)
                .background(Color("AccentColor"))
                HStack {
                    Spacer()
                    Rectangle()
                        .frame(width: 75, height: 80)
                        .foregroundStyle(Color.white.opacity(0.001))
                        .onTapGesture {
                            withAnimation {
                                guard let currentRound, let index = rounds.firstIndex(of: currentRound) ,
                                      index > 0 else { return }
                                self.currentRound = rounds[index - 1]
                            }
                        }
                    Spacer()
                    Rectangle()
                        .frame(width: 150, height: 80)
                        .foregroundStyle(Color.clear)
                    Spacer()
                    Rectangle()
                        .frame(width: 75, height: 80)
                        .foregroundStyle(Color.white.opacity(0.001))
                        .onTapGesture {
                            withAnimation {
                                guard let currentRound, let index = rounds.firstIndex(of: currentRound),
                                      index < rounds.count - 1 else { return }
                                self.currentRound = rounds[index + 1]
                            }
                        }
                    Spacer()
                }
            }
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                guard let currentRound, let index = rounds.firstIndex(of: currentRound) ,
                                      index > 0 else { return }
                                self.currentRound = rounds[index - 1]
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(currentRound == rounds.first ? Color.clear : Color("AccentColor"))
                                .font(Font.system(size: 24, weight: .semibold))
                        }
                        Spacer()
                        ForEach(rounds, id: \.self) {round in
                            let isCurrent = round.roundNo == currentRound?.roundNo ?? "1"
                            Image(systemName: getSymbol(result: round.result, roundNo: round.roundNo, isCurrent: isCurrent))
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(isCurrent ? Color(UIColor.lightGray) : Color("TextColor"), isCurrent ? Color("TextColor") : Color(UIColor.lightGray))
                                .scaleEffect(isCurrent ? 1.5 : 1)
                                .padding(.horizontal, -2)
                                .onTapGesture {
                                    withAnimation {
                                        currentRound = round
                                    }
                                }
                        }
                        Spacer()
                        Button {
                            withAnimation {
                                guard let currentRound, let index = rounds.firstIndex(of: currentRound),
                                      index < rounds.count - 1 else { return }
                                self.currentRound = rounds[index + 1]
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(currentRound == rounds.last ? Color.clear : Color("AccentColor"))
                                .font(Font.system(size: 24, weight: .semibold))
                        }
                        Spacer()
                    }
                    .frame(minWidth: geometry.size.width)
                    .frame(height: 30)
                }
            }
            .frame(height: 30)
//            .background(Color.white)
        }
        .background(Color("BackColor"))
    }
}

#Preview {
    SelectRound(rounds: .constant([]), currentRound: .constant(Rounds()))
}
