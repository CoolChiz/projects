//
//  RecipeIcon.swift
//  cmsc436 recipe project
//
//  Created by Duy on 11/2/21.
//

import SwiftUI

struct RecipeIcon: View {
    @EnvironmentObject var data : RecipeApp
    @Binding var curr_recipe : SearchRecipe
    @State private var isModal: Bool = false
    
    var body: some View {
         Button(action: {recipeViewer()}) {
             VStack(alignment: .leading, spacing: 0) {
         // Card Image
                 AsyncImage(url: URL(string: "https://spoonacular.com/recipeImages/" + String(curr_recipe.id) + "-480x360.jpg"))
                     .aspectRatio(contentMode: .fill)
                     .frame(width: 400, height: 200)
                     .clipped()
                 VStack(alignment: .leading, spacing: 12) {
         // Title
                     Text(curr_recipe.title)
                         .font(.system(.title, design: .serif))
                         .fontWeight(.bold)
                         .lineLimit(1)
                     Text("Ready in: " + String(curr_recipe.readyInMinutes ?? 0) + " minutes.")
                         .font(.system(.body, design: .serif))
                         .foregroundColor(Color.gray)
                 }
                 .padding()
                 .padding(.bottom, 12)
             }
             .background(Color.white)
             .cornerRadius(20)
            }
            .sheet(isPresented: $isModal, content: {
                RecipeDetailView(ret: data.singleRecipeGetter(id_str: curr_recipe.id))
         //RecipeDetailView()
            })
         
         
        /*

        // NavigationLink(destination: RecipeDetailView(curr_id: curr_recipe.id)) {
        
        // data.search_recipes_details_map is a map that has the ID as the key, and the recipe object as the value. But unwrapping in navigationlink has been giving me errors left and right.
        // NavigationLink(destination: RecipeDetailView(curr_recip: (data.search_recipes_details_map[curr_recipe.id]!))) {
        NavigationLink(destination: RecipeDetailView(ret: data.singleRecipeGetter(id_str: curr_recipe.id))) {
                VStack(alignment: .leading, spacing: 0) {
                    // Card Image
                    AsyncImage(url: URL(string: "https://spoonacular.com/recipeImages/" + String(curr_recipe.id) + "-480x360.jpg")) { image in
                    image
                    .resizable()
                    .frame(height: 200, alignment: .bottom)

                    } placeholder: {
                    Image(systemName: "photo")
                    .resizable()
                    .frame(height: 200, alignment: .bottom)
                    }
                    VStack(alignment: .leading, spacing: 12) {
                        // Title
                        Text(curr_recipe.title)
                            .font(.system(.title, design: .serif))
                            .fontWeight(.bold)
                            .lineLimit(1)
                        Text("Ready in: " + String(curr_recipe.readyInMinutes ?? 0) + " minutes.")
                            .font(.system(.body, design: .serif))
                            .foregroundColor(Color.gray)
                    }
                    .padding()
                    .padding(.bottom, 12)
                }
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: Color("ColorBlackTransparentLight"), radius: 8, x: 0, y: 0)
            
        }
        */
    }
    
    func recipeViewer() {
        self.isModal.toggle()
    }
   
}

struct FavRecipeIcon: View {
    @EnvironmentObject var data : RecipeApp
    var curr_recipe : RecipeEachElement
    @State private var isModal: Bool = false
    
    var body: some View {
        Button(action: {recipeViewer()}) {
            VStack(alignment: .leading, spacing: 0) {
                // Card Image
                AsyncImage(url: URL(string: "https://spoonacular.com/recipeImages/" + String(curr_recipe.id) + "-480x360.jpg")) { image in
                image
                .resizable()
                .frame(height: 200, alignment: .bottom)

                } placeholder: {
                Image(systemName: "photo")
                .resizable()
                .frame(height: 200, alignment: .bottom)
                }
                VStack(alignment: .leading, spacing: 12) {
                    // Title
                    Text(curr_recipe.title)
                        .font(.system(.title, design: .serif))
                        .fontWeight(.bold)
                        .lineLimit(1)
                    Text("Ready in: " + String(curr_recipe.readyInMinutes ?? 0) + " minutes.")
                        .font(.system(.body, design: .serif))
                        .foregroundColor(Color.gray)
                }
                .padding()
                .padding(.bottom, 12)
            }
            .background(Color.white)
            .cornerRadius(20)
        }
        .sheet(isPresented: $isModal, content: {
            FavoriteRecipeDetailView(ret: curr_recipe)
        })
        
        
    }
    
    func recipeViewer() {
        self.isModal = true
    }
}

/*
 struct RecipeIcon_Previews: PreviewProvider {
 @EnvironmentObject var data : RecipeApp
 static var previews: some View {
 //RecipeIcon()
 //.previewLayout(.sizeThatFits)
 Text("Yeet")
 }
 }
 */
