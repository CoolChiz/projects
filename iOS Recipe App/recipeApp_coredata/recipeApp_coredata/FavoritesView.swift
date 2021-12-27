//
//  FavoritesView.swift
//  cmsc436 recipe project
//
//  Created by Duy on 11/21/21.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var data : RecipeApp
    var fav_recipes : [RecipeEachElement]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea(.all, edges: .all)

            VStack {
                // Title
                Text("My Favorites")
                    .font(.system(.largeTitle))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                // Favorites
                /*
                List {
                    ForEach(0..<5, id: \.self) { i in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack(spacing: 10) {
                                Image("spaghetti")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    
                                Text("Spaghetti and Meatballs")
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                    .padding()
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                 */
                
                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        // Recipes
                        ForEach(fav_recipes, id: \.self) { i in
                            FavRecipeIcon(curr_recipe: i)
                        }
                    }
                }
            }
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        //FavoritesView()
        Text("yeet")
    }
}
