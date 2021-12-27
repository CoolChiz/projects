//
//  SearchedRecipeView.swift
//  cmsc436 recipe project
//
//  Created by Duy on 11/21/21.
//

import SwiftUI

struct SearchedRecipeView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea(.all, edges: .all)
            ScrollView {
                VStack {
                    // Title
                    Text("\"Spaghetti\"")
                        .font(.system(.largeTitle))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding()
                    // Recipes
                    ForEach(0..<5, id: \.self) { i in
                        VStack(alignment: .center, spacing: 20) {
                            //RecipeIcon()
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

/*
struct SearchedRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        SearchedRecipeView()
    }
}
*/
