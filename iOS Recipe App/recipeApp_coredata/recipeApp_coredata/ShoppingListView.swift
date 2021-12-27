//
//  ShoppingListView.swift
//  cmsc436 recipe project
//
//  Created by Duy on 11/9/21.
//

import SwiftUI
import CoreData

// CoreData is used to store the shopping list here

struct ShoppingListView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(entity: Ingredient.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Ingredient.name, ascending: true)])
    var ingredients: FetchedResults<Ingredient>
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea(.all, edges: .all)
            VStack {
                // Title
                Text("My Shopping List")
                    .font(.system(.largeTitle))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                // Ingredients
                List {
                    ForEach(ingredients) { i in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text((i.name)!)
                                    .font(.headline)
                                    .multilineTextAlignment(.leading)
                                    .padding()
                            }
                        }
                    }
                    .onDelete{ indexSet in
                        for index in indexSet {
                            viewContext.delete(ingredients[index])
                        }
                        do {
                            try viewContext.save()
                        } catch {
                            print("Error deleting")
                        }
                    }
                }
                
                .listStyle(InsetGroupedListStyle())
                
            }
        }
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
    }
}
