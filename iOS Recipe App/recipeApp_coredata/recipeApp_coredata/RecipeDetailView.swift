//
//  RecipeDetailView.swift
//  cmsc436 recipe project
//
//  Created by Duy on 11/8/21.
//

import SwiftUI
import CoreData

struct RecipeDetailView: View {
    @EnvironmentObject var data : RecipeApp
    var ret: SingleRecipeInfo
    @State var fav_but = "star"
    @Environment(\.managedObjectContext) var viewContext
    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                // Image
                AsyncImage(url: URL(string: "https://spoonacular.com/recipeImages/" + String(ret.id) + "-480x360.jpg")) { image in
                    image
                        .resizable()
                        .frame(height: 200, alignment: .bottom)
                    
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(height: 200, alignment: .bottom)
                }
                    .overlay(
                        HStack {
                            Spacer()
                            VStack {
                               // Image(systemName: data.fav_checker[ret.id]!)
                                Image(systemName: fav_but)
                                    .font(Font.title.weight(.light))
                                    .foregroundColor(Color.white)
                                    .background(Color.black)
                                    .cornerRadius(10)
                                    .imageScale(.large)
                                    .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .padding()
                                    .gesture(TapGesture()
                                                .onEnded() { _ in
                                        print("Add this recipe to favorites")
                                        /*
                                         if data.fav_checker[ret.id]! == "star.fill" {
                                             data.fav_checker[ret.id] = "star"
                                             data.removeFavorites(recipe_id: String(ret.id))
                                         } else {
                                             data.fav_checker[ret.id] = "star.fill"
                                             data.addFavorites(recipe_id: String(ret.id))
                                         }
                                         
                                         fav_but.toggle()
                                        */
                                        
                                        
                                        if fav_but == "star.fill" {
                                            fav_but = "star"
                                            data.removeFavorites(recipe_id: String(ret.id))
                                        } else {
                                            fav_but = "star.fill"
                                            data.addFavorites(recipe_id: String(ret.id))
                                        }
                                        
                                    })
                                Spacer()
                            }
                        }
                    )
                // Recipe Details
                Group {
                    // Title
                    Text(ret.title)
                        .font(.system(.largeTitle))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()
                        .border(Color.green, width: 5)
                    // Ingredient Heading
                    Text("Ingredients")
                        .underline()
                        .font(.system(.title))
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.green)
                    
                    // Ingredients
                    
                    ForEach(0..<ret.extendedIngredients.count, id: \.self) { i in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(ret.extendedIngredients[i].originalString!)
                                    .font(.footnote)
                                    .multilineTextAlignment(.leading)
                                    .padding()
                                Spacer()
                                Button {
                                    // Add ingredient to shopping list
                                    let newIngredient = Ingredient(context: viewContext)
                                    newIngredient.name = ret.extendedIngredients[i].name!
                                    do {
                                        try viewContext.save()
                                    } catch {
                                        print(error.localizedDescription)
                                    }
                                } label: {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 20, height: 20, alignment: .center)
                                }
                                .padding()
                            }
                            Divider().background(Color.blue)
                        }
                    }
                    
                    // Instruction Heading
                    Text("Instructions")
                        .underline()
                        .font(.system(.title))
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.green)
                    // Instructions
                    Text(ret.instructions)
                        .padding()
                        .lineSpacing(15)
                    
                }
                .padding()
                
            }
        }
    }
    
    
}

struct FavoriteRecipeDetailView: View {
    @EnvironmentObject var data : RecipeApp
    var ret: RecipeEachElement
    //@State var fav_but = true
    @State var fav_but = "star"
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                // Image
                AsyncImage(url: URL(string: "https://spoonacular.com/recipeImages/" + String(ret.id) + "-480x360.jpg")) { image in
                    image
                        .resizable()
                        .frame(height: 200, alignment: .bottom)
                    
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .frame(height: 200, alignment: .bottom)
                }
                    .overlay(
                        HStack {
                            Spacer()
                            VStack {
                                Image(systemName: data.fav_checker[ret.id]!)
                                //Image(systemName: fav_but)
                                    .font(Font.title.weight(.light))
                                    .foregroundColor(Color.white)
                                    .background(Color.black)
                                    .cornerRadius(10)
                                    .imageScale(.large)
                                    .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .padding()
                                    .gesture(TapGesture()
                                                .onEnded() { _ in
                                        print("Add this recipe to favorites")
                                        
                                        /*
                                        if data.fav_checker[ret.id!]! == "star.fill" {
                                            data.fav_checker[ret.id!] = "star"
                                            data.removeFavorites(recipe_id: String(ret.id!))
                                        } else {
                                            data.fav_checker[ret.id!] = "star.fill"
                                            data.addFavorites(recipe_id: String(ret.id!))
                                        }
                                        
                                        fav_but.toggle()
                                        */
                                        
                                        
                                        if fav_but == "star.fill" {
                                            fav_but = "star"
                                            data.removeFavorites(recipe_id: String(ret.id))
                                        } else {
                                            fav_but = "star.fill"
                                            data.addFavorites(recipe_id: String(ret.id))
                                        }
                                        
                                    })
                                Spacer()
                            }
                        }
                    )
                // Recipe Details
                Group {
                    // Title
                    Text(ret.title)
                        .font(.system(.largeTitle))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()
                        .border(Color.green, width: 5)
                    // Ingredient Heading
                    Text("Ingredients")
                        .underline()
                        .font(.system(.title))
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.green)
                    
                    // Ingredients
                    
                    ForEach(0..<ret.extendedIngredients.count, id: \.self) { i in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(ret.extendedIngredients[i].originalString!)
                                    .font(.footnote)
                                    .multilineTextAlignment(.leading)
                                    .padding()
                                Spacer()
                                Button {
                                    print("Add ingredient to shopping list")
                                } label: {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .frame(width: 20, height: 20, alignment: .center)
                                }
                                .padding()
                            }
                            Divider().background(Color.blue)
                        }
                    }
                    
                    // Instruction Heading
                    Text("Instructions")
                        .underline()
                        .font(.system(.title))
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.green)
                    // Instructions
                    Text(ret.instructions)
                        .padding()
                    
                }
                .padding()
                
            }
        }
    }
    
    
}

struct RecipeDetailView_Previews: PreviewProvider {
    @EnvironmentObject var data : RecipeApp
    
    static var previews: some View {
        Text("Hah")
        //RecipeDetailView(curr_id: 156992, curr_recp: SingleRecipeInfo(extendedIngredients: [SingleRecipeExtendedIngredient]()))
    }
}
