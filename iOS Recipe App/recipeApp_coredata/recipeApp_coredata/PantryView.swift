//
//  PantryView.swift
//  cmsc436 recipe project
//
//  Created by Nafi Mondal on 12/5/21.
//

import SwiftUI

struct PantryView: View {
    let foods = loadCSV(csv: "pantry")
    var body: some View {
        List(foods) { line in
            Text(line.foodName + " | Quantity: \(line.amount ?? 0)")
        }
    }
}

struct Item: Identifiable {
    var id: UUID
    var foodName: String
    var amount: Int?
    
    init(data: [String]) {
        id = UUID()
        foodName = data[0]
        amount = Int(data[1])
    }
}

func loadCSV(csv: String) -> [Item] {
    var toItem = [Item]()
    guard let filePath = Bundle.main.path(forResource: csv, ofType: "csv") else {
        return []
    }
    
    var data = ""
    do {
        data = try String(contentsOfFile: filePath)
    } catch {
        print(error)
        return []
    }
    
    let rows = data.components(separatedBy: "\n")
    for row in rows {
        let cols = row.components(separatedBy: ",")
        if cols != [""] {
            let i = Item.init(data: cols)
            toItem.append(i)
        }
    }
    return toItem
}
