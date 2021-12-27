//
//  model.swift
//  cmsc436 recipe project
//
//  Created by Tahmid Hannan on 11/28/21.
//

import Foundation
import SwiftUI

let apiKey = "dc1423a55emsh1f517d9a3737426p19667ajsna2dedc1378f6"

struct SingleRecipeExtendedIngredient: Codable, Identifiable  {
    let id: Int?
    let aisle, image, name, unit, unitShort, unitLong, originalString: String?
}

struct SingleRecipeInfo: Codable {
    var vegetarian, vegan, glutenFree, dairyFree, veryHealthy, cheap, veryPopular, sustainable: Bool?
    var weightWatcherSmartPoints: Int?
    var gaps: String?
    var lowFodmap, ketogenic, whole30: Bool?
    var servings: Int?
    var sourceUrl, spoonacularSourceUrl: String?
    var aggregateLikes: Int?
    var creditText, sourceName: String?
    var extendedIngredients: [SingleRecipeExtendedIngredient]
    var id: Int
    var title: String
    var readyInMinutes: Int?
    var image: String!
    var imageType: StringLiteralType?
    var instructions: String
}

struct SearchRecipe: Codable, Identifiable {
    var id: Int
    var title: String
    var readyInMinutes, servings, usedIngredientCount, missedIngredientCount, openLicense, likes: Int?
    var sourceUrl: String?
    var image: String?
}

struct SearchResults: Codable {
    var results: [SearchRecipe]
}

struct RecipeEachElement: Codable, Hashable, Equatable {
    struct ExtendedIngredient: Codable, Hashable  {
        let id: Int?
        let aisle, image, name, unit, unitShort, unitLong, originalString: String?
        let originalName: String?
    }
    
    let vegetarian, vegan, glutenFree, dairyFree: Bool?
    let healthScore: Int?
    let extendedIngredients: [ExtendedIngredient]
    let id: Int
    let title: String
    let readyInMinutes, servings: Int?
    let image: String?
    let summary: String
    let instructions: String
    let preparationMinutes, cookingMinutes: Int?
    
}

class RecipeApp: ObservableObject {
    @Published var favorite_recipes : [RecipeEachElement] = [RecipeEachElement]()
    @Published var search_recipes: SearchResults = SearchResults(results: [SearchRecipe]())
    //var search_arr: [String] = []
    // var search_recipes_details : [RecipeEachElement] = [RecipeEachElement]()
    //@Published var single_details : [RecipeEachElement] = []
    //@Published var search_recipes_details_map : [Int : RecipeEachElement] = [Int: RecipeEachElement]()
    @Published var curr_rec: SingleRecipeInfo = SingleRecipeInfo(extendedIngredients: [SingleRecipeExtendedIngredient](), id: 0, title: "placeholder", instructions: "placeholder")
    var prev_id: Int = 0
    @Published var fav_recipe_ID: [String] = ["766301","1449149"]
    var old_fav_recipe_ID: [String] = []
    @Published var fav_checker: [Int : String] = [766301: "star.fill", 1449149: "star.fill"]
    
    func getFavorites() -> [RecipeEachElement] {
        if fav_recipe_ID.sorted() != old_fav_recipe_ID.sorted() {
            old_fav_recipe_ID = fav_recipe_ID
            let ids = fav_recipe_ID.joined(separator: "%2C")
            let url_string = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/informationBulk?ids=" + ids
            
            let headers = [
                "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
                "x-rapidapi-key": apiKey
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: url_string)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error!)
                } else {
                    // let httpResponse = response as? HTTPURLResponse
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        var data_cleaned = dataString.replacingOccurrences(of: "</b>", with: "", options: .literal, range: nil)
                        data_cleaned = data_cleaned.replacingOccurrences(of: "<b>", with: "", options: .literal, range: nil)
                        data_cleaned = data_cleaned.replacingOccurrences(of: "</a>", with: "", options: .literal, range: nil)
                        data_cleaned = data_cleaned.replacingOccurrences(of: "(?:<\\/a>)", with: "", options: [.regularExpression])
                        data_cleaned = data_cleaned.replacingOccurrences(of: "(?:<a href).+?(?:\">)", with: "", options: [.regularExpression])
                        
                        let jsonData = data_cleaned.data(using: .utf8)!
                        let response = try! JSONDecoder().decode([RecipeEachElement].self, from: jsonData)
                        self.favorite_recipes = response
                    }
                }
            })
            
            dataTask.resume()
            
        }
        
        return self.favorite_recipes
    }
    /*
     func getBulkSearchInfo() {
     let ids = search_arr.joined(separator: "%2C")
     let url_string = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/informationBulk?ids=" + ids
     
     let headers = [
     "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
     "x-rapidapi-key": "b64ce2b608msh0bf1f84f47b8ebep15afbejsnd29461ce5150"
     ]
     
     let request = NSMutableURLRequest(url: NSURL(string: url_string)! as URL,
     cachePolicy: .useProtocolCachePolicy,
     timeoutInterval: 10.0)
     request.httpMethod = "GET"
     request.allHTTPHeaderFields = headers
     
     let session = URLSession.shared
     let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
     if (error != nil) {
     print(error!)
     } else {
     // let httpResponse = response as? HTTPURLResponse
     if let data = data, let dataString = String(data: data, encoding: .utf8) {
     var data_cleaned = dataString.replacingOccurrences(of: "</b>", with: "", options: .literal, range: nil)
     data_cleaned = data_cleaned.replacingOccurrences(of: "<b>", with: "", options: .literal, range: nil)
     data_cleaned = data_cleaned.replacingOccurrences(of: "</a>", with: "", options: .literal, range: nil)
     data_cleaned = data_cleaned.replacingOccurrences(of: "(?:<\\/a>)", with: "", options: [.regularExpression])
     data_cleaned = data_cleaned.replacingOccurrences(of: "(?:<a href).+?(?:\">)", with: "", options: [.regularExpression])
     
     let jsonData = data_cleaned.data(using: .utf8)!
     let response = try! JSONDecoder().decode([RecipeEachElement].self, from: jsonData)
     self.search_recipes_details = response
     }
     }
     })
     
     dataTask.resume()
     }
     */
    
    func addFavorites(recipe_id: String) {
        if fav_recipe_ID.contains(recipe_id) == false {
            fav_recipe_ID.append(recipe_id)
            fav_checker[Int(recipe_id)!] = "star.fill"
        }
    }
    
    func removeFavorites(recipe_id: String) {
        fav_recipe_ID.removeAll(where: { $0 == recipe_id })
        
    }
    
    
    
    func getSearchResults(search_text: String, diet_numb: Int, picker_val: Int) {
        search_recipes = SearchResults(results: [SearchRecipe]())
        var search_str = search_text.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        var url_str: String = ""
        
        if picker_val == 1 {
            var diet = ""
            
            if diet_numb == 1 {
                diet = "&diet=vegetarian"
            } else if diet_numb == 2 {
                diet = "&diet=vegan"
            } else {
                diet = ""
            }
            
            url_str = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/search?query=" + search_str + "&instructionsRequired=true" + diet + "&number=1&offset=0"
            
            let headers = [
                "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
                "x-rapidapi-key": apiKey
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: url_str)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error!)
                } else {
                    // let httpResponse = response as? HTTPURLResponse
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        var data_cleaned = dataString.replacingOccurrences(of: "</b>", with: "", options: .literal, range: nil)
                        data_cleaned = data_cleaned.replacingOccurrences(of: "<b>", with: "", options: .literal, range: nil)
                        data_cleaned = data_cleaned.replacingOccurrences(of: "</a>", with: "", options: .literal, range: nil)
                        data_cleaned = data_cleaned.replacingOccurrences(of: "(?:<\\/a>)", with: "", options: [.regularExpression])
                        data_cleaned = data_cleaned.replacingOccurrences(of: "(?:<a href).+?(?:\">)", with: "", options: [.regularExpression])
                        
                        let jsonData = data_cleaned.data(using: .utf8)!
                        let response = try! JSONDecoder().decode(SearchResults.self, from: jsonData)
                        self.search_recipes = response
                        
                        /*
                         self.search_arr.removeAll()
                         self.search_recipes_details.removeAll()
                         
                         
                         response.results.forEach { recp in
                         self.search_arr.append(String(recp.id))
                         if self.fav_checker[recp.id] == nil {
                         self.fav_checker[recp.id] = "star"
                         }
                         }
                         
                         self.getBulkSearchInfo()
                         
                         self.search_arr.forEach { i in
                         print(i + " " + i + " " + i + " " + i + " " + i)
                         
                         }
                         
                         self.search_recipes_details.forEach { curr in
                         self.search_recipes_details_map[curr.id] = curr
                         }
                         */
                    }
                }
            })
            
            dataTask.resume()
            
        } else {
            search_str = search_str.replacingOccurrences(of: ",", with: "%2C", options: .literal, range: nil)
            url_str = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/findByIngredients?ingredients=" + search_str + "&number=5&ignorePantry=true"
            
            let headers = [
                "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
                "x-rapidapi-key": apiKey
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: url_str)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let dataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error!)
                } else {
                    // let httpResponse = response as? HTTPURLResponse
                    if let data = data, let dataString = String(data: data, encoding: .utf8) {
                        var data_cleaned = dataString.replacingOccurrences(of: "</b>", with: "", options: .literal, range: nil)
                        data_cleaned = data_cleaned.replacingOccurrences(of: "<b>", with: "", options: .literal, range: nil)
                        data_cleaned = data_cleaned.replacingOccurrences(of: "</a>", with: "", options: .literal, range: nil)
                        data_cleaned = data_cleaned.replacingOccurrences(of: "(?:<\\/a>)", with: "", options: [.regularExpression])
                        data_cleaned = data_cleaned.replacingOccurrences(of: "(?:<a href).+?(?:\">)", with: "", options: [.regularExpression])
                        
                        let jsonData = data_cleaned.data(using: .utf8)!
                        let response = try! JSONDecoder().decode([SearchRecipe].self, from: jsonData)
                        self.search_recipes = SearchResults(results: response)
                        /*
                         self.search_arr.removeAll()
                         self.search_recipes_details.removeAll()
                         
                         
                         response.forEach { recp in
                         self.search_arr.append(String(recp.id))
                         if self.fav_checker[recp.id] == nil {
                         self.fav_checker[recp.id] = "star"
                         }
                         }
                         
                         self.getBulkSearchInfo()
                         
                         self.search_arr.forEach { i in
                         print(i + " " + i + " " + i + " " + i + " " + i)
                         
                         }
                         
                         self.search_recipes_details.forEach { curr in
                         self.search_recipes_details_map[curr.id] = curr
                         }
                         */
                    }
                }
            })
            dataTask.resume()
        }
    }
    
    func singleRecipeGetter(id_str: Int) -> SingleRecipeInfo {
        if prev_id != id_str {
            prev_id = id_str
            print(id_str)
            let url_string = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/" + String(id_str) + "/information?includeNutrition=false"
            
            let headers = [
                "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
                "x-rapidapi-key": apiKey
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: url_string)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error!)
                } else {
                    print(url_string)
                    let data_raw = String(data: data!, encoding: .utf8)
                    var data_cleaned = data_raw!.replacingOccurrences(of: "</b>", with: "", options: .literal, range: nil)
                    data_cleaned = data_cleaned.replacingOccurrences(of: "<b>", with: "", options: .literal, range: nil)
                    data_cleaned = data_cleaned.replacingOccurrences(of: "</a>", with: "", options: .literal, range: nil)
                    data_cleaned = data_cleaned.replacingOccurrences(of: "<li>", with: "", options: .literal, range: nil)
                    data_cleaned = data_cleaned.replacingOccurrences(of: "</li>", with: "", options: .literal, range: nil)
                    data_cleaned = data_cleaned.replacingOccurrences(of: "<ul>", with: "", options: .literal, range: nil)
                    data_cleaned = data_cleaned.replacingOccurrences(of: "</ul>", with: "", options: .literal, range: nil)
                    data_cleaned = data_cleaned.replacingOccurrences(of: "(?:<\\/a>)", with: "", options: [.regularExpression])
                    data_cleaned = data_cleaned.replacingOccurrences(of: "(?:<a href).+?(?:\">)", with: "", options: [.regularExpression])
                    
                    let jsonData = data_cleaned.data(using: .utf8)!
                    let curr_val = try! JSONDecoder().decode(SingleRecipeInfo.self, from: jsonData)
                    print(curr_val.title)
                    self.curr_rec = curr_val
                }
            })
            dataTask.resume()
        }
        return self.curr_rec
    }
    
    func getEmptyArray(num: Int) -> [Int] {
        var array = [Int]()
        for _ in 0..<num {
            array.append(0)
        }
        return array
    }
    /*
     func singleRecipeGetter(id_str: Int) {
     print(id_str)
     let url_string = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/" + String(id_str) + "/information?includeNutrition=false"
     
     let headers = [
     "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
     "x-rapidapi-key": "b64ce2b608msh0bf1f84f47b8ebep15afbejsnd29461ce5150"
     ]
     
     let request = NSMutableURLRequest(url: NSURL(string: url_string)! as URL,
     cachePolicy: .useProtocolCachePolicy,
     timeoutInterval: 10.0)
     request.httpMethod = "GET"
     request.allHTTPHeaderFields = headers
     let session = URLSession.shared
     let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
     if (error != nil) {
     print(error!)
     } else {
     print(url_string)
     let data_raw = String(data: data!, encoding: .utf8)
     var data_cleaned = data_raw!.replacingOccurrences(of: "</b>", with: "", options: .literal, range: nil)
     data_cleaned = data_cleaned.replacingOccurrences(of: "<b>", with: "", options: .literal, range: nil)
     data_cleaned = data_cleaned.replacingOccurrences(of: "</a>", with: "", options: .literal, range: nil)
     data_cleaned = data_cleaned.replacingOccurrences(of: "<li>", with: "", options: .literal, range: nil)
     data_cleaned = data_cleaned.replacingOccurrences(of: "</li>", with: "", options: .literal, range: nil)
     data_cleaned = data_cleaned.replacingOccurrences(of: "<ul>", with: "", options: .literal, range: nil)
     data_cleaned = data_cleaned.replacingOccurrences(of: "</ul>", with: "", options: .literal, range: nil)
     data_cleaned = data_cleaned.replacingOccurrences(of: "(?:<\\/a>)", with: "", options: [.regularExpression])
     data_cleaned = data_cleaned.replacingOccurrences(of: "(?:<a href).+?(?:\">)", with: "", options: [.regularExpression])
     
     let jsonData = data_cleaned.data(using: .utf8)!
     let curr_val = try! JSONDecoder().decode(SingleRecipeInfo.self, from: jsonData)
     print(curr_val.title)
     self.curr_rec = curr_val
     }
     })
     
     dataTask.resume()
     }
     */
}
