//
//  Scores.swift
//  assign3
//
//  Created by Duy on 10/6/21.
//

import SwiftUI

struct Scores: View {
    @EnvironmentObject var twos: Twos
    var body: some View {
        VStack {
            Text("High Scores")
                .font(.largeTitle)
                .padding()
            Spacer()
            List {
                ForEach(0..<twos.scoreList.count, id: \.self) { i in
                    HStack {
                        Text(String(i + 1) + ".")
                        Spacer()
                            .frame(width: 100)
                        Text(String(twos.scoreList[i].score))
                        Spacer()
                            .frame(width: 100)
                        Text(formatDate(date: twos.scoreList[i].time))
                    }
                }
            }
        }
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: date)
    }
}

struct Scores_Previews: PreviewProvider {
    static var previews: some View {
        Scores().environmentObject(Twos())
    }
}
