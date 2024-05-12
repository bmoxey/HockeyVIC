//
//  GetCompsView.swift
//  HockeyVIC
//
//  Created by Brett Moxey on 5/5/2024.
//

import SwiftUI

struct GetCompsView: View {
    @State private var comps: [Team] = []
    @State private var haveData: Bool = false
    @State private var selectedTypeFilter = "All"
    @State private var selectedCompFilter = "All"
    @State private var compfilterOptions: [String] = []
    @State private var typeFilterOptions: [String] = []
    var filteredComps: [Team] {
        var filteredComps = comps
        if selectedCompFilter != "All" { filteredComps = filteredComps.filter { $0.compName == selectedCompFilter }}
        if selectedTypeFilter != "All" { filteredComps = filteredComps.filter { $0.type == selectedTypeFilter }}
        return filteredComps
    }
    var body: some View {
        List{
            if comps.isEmpty {
                if haveData {
                    Text("No competitions")
                        .foregroundStyle(Color("TextColor"))
                        .listRowBackground(Color("BackColor"))
                } else {
                    Text("Loading...")
                        .foregroundStyle(Color("TextColor"))
                        .listRowBackground(Color("BackColor"))
                        .task {
                            comps = await getComps(assoc: currentAssoc)
                            compfilterOptions = Array(Set(comps.map { $0.compName }))
                            compfilterOptions.insert("All", at: 0)
                            compfilterOptions.sort()
                            typeFilterOptions = Array(Set(comps.map { $0.type }))
                            typeFilterOptions.insert("All", at: 0)
                            typeFilterOptions.sort()
                            haveData = true
                        }
                }
            } else {
                if compfilterOptions.count > 2 || typeFilterOptions.count > 2 {
                    VStack {
                        if compfilterOptions.count > 2 {
                            Picker(selection: $selectedCompFilter, label: Text("Filter:").foregroundStyle(Color("TextColor"))) {
                                ForEach(compfilterOptions, id: \.self) { option in
                                    Text(option)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .onChange(of: selectedCompFilter) {
                                if selectedCompFilter == "All" {
                                    typeFilterOptions = Array(Set(comps.map { $0.type }))
                                } else {
                                    typeFilterOptions = Array(Set(comps.filter { $0.compName == selectedCompFilter }.map { $0.type }))
                                }
                                typeFilterOptions.insert("All", at: 0)
                                typeFilterOptions.sort()
                            }
                        }
                        if typeFilterOptions.count > 2 {
                            Picker(selection: $selectedTypeFilter, label: Text("Type:")) {
                                ForEach(typeFilterOptions, id: \.self) { option in
                                    Text(option)
                                }
                            }
                            .onAppear {
                                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color("AccentColor"))
                                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color("NavyBlue"))], for: .selected)
                                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(Color("AccentColor"))], for: .normal)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .onChange(of: selectedTypeFilter) {
                                if selectedTypeFilter == "All" {
                                    compfilterOptions = Array(Set(comps.map { $0.compName }))
                                } else {
                                    compfilterOptions = Array(Set(comps.filter { $0.type == selectedTypeFilter }.map { $0.compName }))
                                }
                                compfilterOptions.insert("All", at: 0)
                                compfilterOptions.sort()
                            }
                        }
                    }
                    .listRowBackground(Color("BackColor"))
                }
                ForEach(filteredComps) { comp in
                    NavigationLink {
                        SelectCompsTeam(myComp: comp)
                    } label: {
                        HStack {
                            Text(comp.type)
                            Text(comp.divName)
                                .foregroundStyle(Color("TextColor"))
                        }
                    }
                    .listRowBackground(Color("BackColor"))
                    .foregroundStyle(Color("TextColor"), Color("AccentColor"))
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("ListColor"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Select your competition")
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
    GetCompsView()
}
