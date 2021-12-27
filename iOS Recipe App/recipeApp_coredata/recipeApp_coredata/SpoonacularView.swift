//
//  Spoonacular.swift
//  cmsc436 recipe project
//
//  Created by Nafi Mondal on 11/26/21.
//

import Foundation
import SwiftUI

let headers = [
    "content-type": "application/x-www-form-urlencoded",
    "accept": "text/html",
    "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com",
    "x-rapidapi-key": "a888e4f200mshf45c369587dc9ecp1efe2bjsn12b57f1f904f"
]

func getPostData() -> NSMutableData {
    let postData = NSMutableData(data: "showBacklink=true".data(using: String.Encoding.utf8)!)
    postData.append("&ingredientList=3 oz flour".data(using: String.Encoding.utf8)!)
    postData.append("&servings=2".data(using: String.Encoding.utf8)!)
    postData.append("&defaultCss=true".data(using: String.Encoding.utf8)!)
    return postData
}

func getRequest() -> NSMutableURLRequest {
    let request = NSMutableURLRequest(url: NSURL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/visualizeNutrition")! as URL,
                                            cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 10.0)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = getPostData() as Data
    return request
}

func doDataTask() -> String {
    var resp : String = ""
    let session = URLSession.shared
    _ = session.dataTask(with: getRequest() as URLRequest, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            resp = "error"
        } else {
            let httpResponse = response as? HTTPURLResponse
            resp = "\(httpResponse!)"
            print(resp)
        }
    })
    
    return resp
}

struct SpoonacularView: View {
    var body: some View {
        Text(doDataTask())
            .font(.headline)
    }
}

struct SpoonacularView_Previews : PreviewProvider {
    static var previews: some View {
        SpoonacularView()
    }
}
