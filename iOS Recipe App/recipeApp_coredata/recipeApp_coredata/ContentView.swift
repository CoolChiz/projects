//
//  ContentView.swift
//  cmsc436 recipe project
//
//  Created by Duy on 11/1/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var data : RecipeApp

    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
                .padding(.bottom, 1)
            
                
            FavoritesView(fav_recipes: data.getFavorites())
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Favorites")
                }
                .padding(.bottom, 1)
            
            ShoppingListView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Shopping List")
                }
                .padding(.bottom, 1)

            PantryView()
                .tabItem {
                    Image(systemName: "tortoise.fill")
                    Text("In the Campus Pantry")
                }
            
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
        }
        .padding(.bottom, 0)
    }
}

struct ContentView_Previews: PreviewProvider {
    @EnvironmentObject var data : RecipeApp

    static var previews: some View {
        ContentView()
    }
}
