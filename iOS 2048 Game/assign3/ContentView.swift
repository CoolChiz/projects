//
//  ContentView.swift
//  assign2
//
//  Created by Duy on 9/20/21.
//

import SwiftUI



struct ContentView: View {
    var body: some View {
        TabView {
            BoardView().tabItem {
                Label("Board", systemImage: "gamecontroller")
            }
            Scores().tabItem {
                Label("Scores", systemImage: "list.dash")
            }
            About().tabItem {
                Label("About", systemImage: "info.circle")
            }
        }
    }


}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Twos())
    }
}


struct emptyCell: View {
    var body: some View {
        Text("")
            .frame(width: 40, height: 40, alignment: .center)
            .padding()
            .minimumScaleFactor(0.5)
            .background(Color.gray)
            .cornerRadius(30)
    }
}

struct Cell: View {
    var tile: Tile

    var body: some View {
        Text(String(tile.val))
            .font(.system(size: 30))
            .frame(width: 40, height: 40, alignment: .center)
            .padding()
            .minimumScaleFactor(0.5)
            .background(getColor(value: tile.val))
            .cornerRadius(30)
    }
}

func getColor(value: Int) -> Color {
    switch value {
    case 0:
        return Color.gray
    case 2:
        return Color(red: 175/255, green: 238/255, blue: 238/255)
    case 4:
        return Color(red: 181/255, green: 101/255, blue: 29/255)
    case 8:
        return Color(red: 255/255, green: 0, blue: 255/255)
    case 16:
        return Color.yellow
    case 32:
        return Color(red: 0, green: 255/255, blue: 255/255)
    case 64:
        return Color(red: 0, green: 255/255, blue: 0)
    default:
        return Color(red: 248/255, green: 131/255, blue: 121/255)
        
    }
}

struct BoardView : View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @EnvironmentObject var twos : Twos
    @State var selection: Bool = true
    @State var moved: Bool = true
    @State var isGameOver = false
    @State var dragOffset = CGSize.zero
    @State var firstAppeared: Bool = true
    let colPos : [CGFloat] = [75, 155, 235, 315]
    let rowPos : [CGFloat] = [36, 116, 196, 276]
    let colPosL : [CGFloat] = [36, 116, 196, 276]
    let rowPosL : [CGFloat] = [48.5, 128.5, 208.5, 288.5]
    let slideDuration = 0.25
    var body: some View {
        if(verticalSizeClass == .compact && horizontalSizeClass == .compact) {
            HStack {
                // Score
                Text("Score: " + String(twos.score))
                    .font(.title)
                    .padding()
                    .minimumScaleFactor(0.5)
                    .animation(nil)
                // Game Grid
                ZStack {
                    // Empty Grid Layer
                    VStack {
                        HStack {
                            emptyCell()
                            emptyCell()
                            emptyCell()
                            emptyCell()
                        }
                        HStack {
                            emptyCell()
                            emptyCell()
                            emptyCell()
                            emptyCell()
                        }
                        HStack {
                            emptyCell()
                            emptyCell()
                            emptyCell()
                            emptyCell()
                        }
                        HStack {
                            emptyCell()
                            emptyCell()
                            emptyCell()
                            emptyCell()
                        }
                    }
                    if(twos.tileList.isEmpty == false) {
                        ForEach(0..<twos.tileList.count, id: \.self) { i in
                            if(twos.tileList[i].id != -1) {
                                Cell(tile: twos.tileList[i])
                                    .position(x:colPosL[twos.tileList[i].lastCol], y:rowPosL[twos.tileList[i].lastRow])
                            }
                        }
                    }
                }
                .gesture(DragGesture()
                            .onEnded() { v in
                                if(v.startLocation.x > v.location.x + 30) {
                                    withAnimation(.linear(duration: slideDuration)){
                                        moved = twos.collapse(dir: Direction.left)
                                    }
                                    if(moved) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            twos.spawn()
                                        }
                                    }
                                    if(twos.isGameOver()) {
                                        isGameOver = true
                                    }
                                }
                                else if(v.startLocation.x < v.location.x - 30) {
                                    withAnimation(.linear(duration: slideDuration)){
                                        moved = twos.collapse(dir: Direction.right)
                                    }
                                    if(moved) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            twos.spawn()
                                        }
                                    }
                                    if(twos.isGameOver()) {
                                        isGameOver = true
                                    }
                                }
                                else if(v.startLocation.y < v.location.y - 30) {
                                    withAnimation(.linear(duration: slideDuration)){
                                        moved = twos.collapse(dir: Direction.down)
                                    }
                                    if(moved) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            twos.spawn()
                                        }
                                    }
                                    if(twos.isGameOver()) {
                                        isGameOver = true
                                    }
                                }
                                else if(v.startLocation.y > v.location.y + 30) {
                                    withAnimation(.linear(duration: slideDuration)){
                                        moved = twos.collapse(dir: Direction.up)
                                    }
                                    if(moved) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            twos.spawn()
                                        }
                                    }
                                    if(twos.isGameOver()) {
                                        isGameOver = true
                                    }
                                }
                                dragOffset = .zero
                            }
                )
                // TouchableView
                VStack {
                    Button(action: {
                        withAnimation(.linear(duration: slideDuration)){
                            moved = twos.collapse(dir: Direction.up)
                        }
                        if(moved) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                twos.spawn()
                            }
                        }
                        if(twos.isGameOver()) {
                            isGameOver = true
                        }
                    }, label: {
                        Text("Up")
                            .font(.system(size:20))
                            .padding()
                            .frame(width: 85)
                            .border(Color.blue, width: 5)
                    })
                    HStack {
                        Button(action: {
                            withAnimation(.linear(duration: slideDuration)){
                                moved = twos.collapse(dir: Direction.left)
                            }
                            if(moved) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    twos.spawn()
                                }
                            }
                            if(twos.isGameOver()) {
                                isGameOver = true
                            }
                        }, label: {
                            Text("Left")
                                .font(.system(size:20))
                                .padding()
                                .frame(width: 85)
                                .border(Color.blue, width: 5)
                        })
                        Spacer().frame(width: 50, height: 50, alignment: .center)
                        Button(action: {
                            withAnimation(.linear(duration: slideDuration)){
                                moved = twos.collapse(dir: Direction.right)
                            }
                            if(moved) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    twos.spawn()
                                }
                            }
                            if(twos.isGameOver()) {
                                isGameOver = true
                            }
                        }, label: {
                            Text("Right")
                                .font(.system(size:20))
                                .padding()
                                .frame(width: 85)
                                .border(Color.blue, width: 5)
                        })
                    }
                    Button(action: {
                        withAnimation(.linear(duration: slideDuration)){
                            moved = twos.collapse(dir: Direction.down)
                        }
                        if(moved) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                twos.spawn()
                            }
                        }
                        if(twos.isGameOver()) {
                            isGameOver = true
                        }
                    }, label: {
                        Text("Down")
                            .font(.system(size:20))
                            .padding()
                            .frame(width: 85)
                            .border(Color.blue, width: 5)
                    })
                    Button(action: {
                        isGameOver = true
                    }, label: {
                        Text("New Game")
                            .font(.system(size:25))
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                    })
                    Picker(selection: $selection, label: Text("Picker"), content: {
                        Text("Random").tag(true)
                        Text("Determ").tag(false)
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }

            }
            .onAppear() {
                if(firstAppeared) {
                    twos.spawn()
                    twos.spawn()
                }
                firstAppeared = false
            }
            .alert(isPresented: $isGameOver, content: {
                Alert(title: Text("GAME OVER"),
                      message: Text("Your final Score is " + String(twos.score)),
                      dismissButton: Alert.Button.default(Text("Start new Game"),
                                                          action:       {twos.newgame(rand: selection)
                                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                                twos.spawn()
                                                                twos.spawn()
                                                            }
                                                          })
                )
            })
        }
        else {
            VStack {
                // Score
                Text("Score: " + String(twos.score))
                    .font(.title)
                    .padding()
                // Game Grid
                ZStack {
                    // Empty Grid Layer
                    VStack {
                        HStack {
                            emptyCell()
                            emptyCell()
                            emptyCell()
                            emptyCell()
                        }
                        HStack {
                            emptyCell()
                            emptyCell()
                            emptyCell()
                            emptyCell()
                        }
                        HStack {
                            emptyCell()
                            emptyCell()
                            emptyCell()
                            emptyCell()
                        }
                        HStack {
                            emptyCell()
                            emptyCell()
                            emptyCell()
                            emptyCell()
                        }
                    }
                    if(twos.tileList.isEmpty == false) {
                        ForEach(0..<twos.tileList.count, id: \.self) { i in
                            if(twos.tileList[i].id != -1) {
                                Cell(tile: twos.tileList[i])
                                    .position(x:colPos[twos.tileList[i].lastCol], y:rowPos[twos.tileList[i].lastRow])
                            }
                        }
                    }
                }
                .gesture(DragGesture()
                            .onEnded() { v in
                                if(v.startLocation.x > v.location.x + 30) {
                                    withAnimation(.linear(duration: slideDuration)){
                                        moved = twos.collapse(dir: Direction.left)
                                    }
                                    if(moved) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            twos.spawn()
                                        }
                                    }
                                    if(twos.isGameOver()) {
                                        isGameOver = true
                                    }
                                }
                                else if(v.startLocation.x < v.location.x - 30) {
                                    withAnimation(.linear(duration: slideDuration)){
                                        moved = twos.collapse(dir: Direction.right)
                                    }
                                    if(moved) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            twos.spawn()
                                        }
                                    }
                                    if(twos.isGameOver()) {
                                        isGameOver = true
                                    }
                                }
                                else if(v.startLocation.y < v.location.y - 30) {
                                    withAnimation(.linear(duration: slideDuration)){
                                        moved = twos.collapse(dir: Direction.down)
                                    }
                                    if(moved) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            twos.spawn()
                                        }
                                    }
                                    if(twos.isGameOver()) {
                                        isGameOver = true
                                    }
                                }
                                else if(v.startLocation.y > v.location.y + 30) {
                                    withAnimation(.linear(duration: slideDuration)){
                                        moved = twos.collapse(dir: Direction.up)
                                    }
                                    if(moved) {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            twos.spawn()
                                        }
                                    }
                                    if(twos.isGameOver()) {
                                        isGameOver = true
                                    }
                                }
                                dragOffset = .zero
                            }
                )
                // TouchableView
                VStack {
                    Button(action: {
                        withAnimation(.linear(duration: slideDuration)){
                            moved = twos.collapse(dir: Direction.up)
                        }
                        if(moved) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                twos.spawn()
                            }
                        }
                        if(twos.isGameOver()) {
                            isGameOver = true
                        }
                    }, label: {
                        Text("Up")
                            .font(.system(size:25))
                            .padding()
                            .frame(width: 100)
                            .border(Color.blue, width: 5)
                    })
                    .alert(isPresented: $isGameOver, content: {
                        Alert(title: Text("GAME OVER"),
                              message: Text("Your final Score is " + String(twos.score)),
                              dismissButton: Alert.Button.default(Text("Start new Game"),
                                                                  action: {twos.newgame(rand: selection)
                                                                    twos.spawn()
                                                                    twos.spawn()
                                                                  })
                        )
                    })
                    HStack {
                        Button(action: {
                            withAnimation(.linear(duration: slideDuration)){
                                moved = twos.collapse(dir: Direction.left)
                            }
                            if(moved) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    twos.spawn()
                                }
                            }
                            if(twos.isGameOver()) {
                                isGameOver = true
                            }
                        }, label: {
                            Text("Left")
                                .font(.system(size:25))
                                .padding()
                                .frame(width: 100)
                                .border(Color.blue, width: 5)
                        })
                        Spacer().frame(width: 50, height: 50, alignment: .center)
                        Button(action: {
                            withAnimation(.linear(duration: slideDuration)){
                                moved = twos.collapse(dir: Direction.right)
                            }
                            if(moved) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    twos.spawn()
                                }
                            }
                            if(twos.isGameOver()) {
                                isGameOver = true
                            }
                        }, label: {
                            Text("Right")
                                .font(.system(size:25))
                                .padding()
                                .frame(width: 100)
                                .border(Color.blue, width: 5)
                        })
                    }
                    Button(action: {
                        withAnimation(.linear(duration: slideDuration)){
                            moved = twos.collapse(dir: Direction.down)
                        }
                        if(moved) {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                twos.spawn()
                            }
                        }
                        if(twos.isGameOver()) {
                            isGameOver = true
                        }
                    }, label: {
                        Text("Down")
                            .font(.system(size:25))
                            .padding()
                            .frame(width: 100)
                            .border(Color.blue, width: 5)
                    })
                    Button(action: {
                        isGameOver = true
                    }, label: {
                        Text("New Game")
                            .font(.system(size:25))
                            .fontWeight(.bold)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                    })
                    Picker(selection: $selection, label: Text("Picker"), content: {
                        Text("Random").tag(true)
                        Text("Determ").tag(false)
                    })
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                
            }
            .onAppear() {
                if(firstAppeared) {
                    twos.spawn()
                    twos.spawn()
                }
                firstAppeared = false
            }
            .alert(isPresented: $isGameOver, content: {
                Alert(title: Text("GAME OVER"),
                      message: Text("Your final Score is " + String(twos.score)),
                      dismissButton: Alert.Button.default(Text("Start new Game"),
                                                          action:       {twos.newgame(rand: selection)
                                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                                twos.spawn()
                                                                twos.spawn()
                                                            }
                                                          })
                )
            })
        }
    }
}


