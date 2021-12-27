//
//  SearchView.swift
//  cmsc436 recipe project
//
//  Created by Duy on 11/1/21.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var data : RecipeApp
    @State var searchQuery: String = ""
    @State var searchType = 1
    let diet_type = ["None", "Vegetarian", "Vegan"]
    @State var selectedDiet = 0
    @State var reloader: Bool = false
    @ViewBuilder
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea(.all, edges: .all)
            // Search Bar
            VStack {
                VStack {
                    Picker(selection: $searchType, label: Text("Picker"), content: {
                        Text("By Recipe").tag(1)
                        Text("By Ingredient").tag(2)
                    })
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.horizontal)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 23, weight: .bold))
                            .foregroundColor(.gray)
                        TextField("Search", text: $searchQuery)
                            .onSubmit {
                                data.getSearchResults(search_text: searchQuery, diet_numb: selectedDiet, picker_val: searchType)
                                reloader.toggle()
                            }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(Color.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    
                    if searchType == 1 {
                        HStack(alignment: .lastTextBaseline) {
                            Text("Select Diet Type:")
                                .font(.system(size: 15))
                            Spacer()
                            Picker(selection: $selectedDiet, label: Text("Select Diet Type")) {
                                ForEach(0 ..< diet_type.count) {
                                    Text(self.diet_type[$0])
                                }
                            }
                            .foregroundColor(Color.pink)
                            .pickerStyle(MenuPickerStyle())
                        }
                        .frame(alignment: .leading)
                        .padding(.horizontal)
                    }
                }
                /*
                 ScrollView {
                 VStack(alignment: .center, spacing: 20) {
                 // Recipes
                 ForEach(0 ..< data.search_recipes.results.count, id: \.self) { i in
                 RecipeIcon(curr_recipe: $data.search_recipes.results[i])
                 }
                 }
                 }
                 */
                ScrollView {
                     ScrollView {
                         VStack(alignment: .center, spacing: 20) {
                             // Recipes
                             ForEach(0 ..< data.search_recipes.results.count, id: \.self) { i in
                                 RecipeIcon(curr_recipe: $data.search_recipes.results[i])
                             }
                         }
                     }
                 }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    @EnvironmentObject var data : RecipeApp
    
    static var previews: some View {
        SearchView()
    }
}
