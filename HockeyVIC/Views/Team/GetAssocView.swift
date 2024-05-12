//
//  GetAssocView.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import SwiftUI

struct GetAssocView: View {
    @EnvironmentObject var pathState: PathState
        var body: some View {
            List{
                LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())], spacing: 10) {
                    ForEach(assocs, id: \.id) { assoc in
                        VStack {
                            Image(assoc.code)
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal)
                                .padding(.vertical, -4)
                            Text(assoc.name)
                                .foregroundStyle(Color("TextColor"))
                                .multilineTextAlignment(.center)
                        }
                        .onTapGesture {
                            currentAssoc = assoc
                            pathState.path = []
                        }
                    }
                }
                .listRowBackground(Color("BackColor"))
            }
            .scrollContentBackground(.hidden)
            .background(Color("ListColor"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text("Select your association")
                            .foregroundStyle(Color("TextColor"))
                            .fontWeight(.semibold)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Image(currentAssoc.code)
                        .resizable()
                        .frame(width: 35, height: 35)
                }
            }
            .toolbarBackground(Color("BackColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }


#Preview {
    GetAssocView()
}
