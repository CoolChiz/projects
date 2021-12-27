//
//  ContentView.swift
//  assign2
//
//  Created by Duy on 9/20/21.
//

import SwiftUI



struct ContentView: View {
    @EnvironmentObject var twos : Twos
    @State var selection: Bool = true
    @State var moved: Bool = true
    @State var isGameOver = false
    var body: some View {
        VStack {
            // Score
            Text("Score: " + String(twos.score))
                .font(.title)
                .padding()
            // Game Grid
            VStack {
                HStack {
                    Cell(tile: twos.board[0][0])
                    Cell(tile: twos.board[0][1])
                    Cell(tile: twos.board[0][2])
                    Cell(tile: twos.board[0][3])
                }
                HStack {
                    Cell(tile: twos.board[1][0])
                    Cell(tile: twos.board[1][1])
                    Cell(tile: twos.board[1][2])
                    Cell(tile: twos.board[1][3])
                }
                HStack {
                    Cell(tile: twos.board[2][0])
                    Cell(tile: twos.board[2][1])
                    Cell(tile: twos.board[2][2])
                    Cell(tile: twos.board[2][3])
                }
                HStack {
                    Cell(tile: twos.board[3][0])
                    Cell(tile: twos.board[3][1])
                    Cell(tile: twos.board[3][2])
                    Cell(tile: twos.board[3][3])
                }
            }
            
            // TouchableView
            VStack {
                Button(action: {
                    moved = twos.collapse(dir: Direction.up)
                    if(moved) {
                        twos.spawn()
                    }
                    if(twos.isGameOver()) {
                        isGameOver = true
                    }
                }, label: {
                    Text("Up")
                        .font(.system(size:35))
                        .padding()
                        .frame(width: 150)
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
                        moved = twos.collapse(dir: Direction.left)
                        if(moved) {
                            twos.spawn()
                        }
                        if(twos.isGameOver()) {
                            isGameOver = true
                        }
                    }, label: {
                        Text("Left")
                            .font(.system(size:35))
                            .padding()
                            .frame(width: 150)
                            .border(Color.blue, width: 5)
                    })
                    .alert(isPresented: $isGameOver, content: {
                        Alert(title: Text("GAME OVER"),
                              message: Text("Your final Score is " + String(twos.score)),
                              dismissButton: Alert.Button.default(Text("Start new Game"),
                                                                  action:       {twos.newgame(rand: selection)
                                                           twos.spawn()
                                                           twos.spawn()
                                                          })
                        )
                    })
                    Spacer().frame(width: 50, height: 50, alignment: .center)
                    Button(action: {
                        moved = twos.collapse(dir: Direction.right)
                        if(moved) {
                            twos.spawn()
                        }
                        if(twos.isGameOver()) {
                            isGameOver = true
                        }
                    }, label: {
                        Text("Right")
                            .font(.system(size:35))
                            .padding()
                            .frame(width: 150)
                            .border(Color.blue, width: 5)
                    })
                    .alert(isPresented: $isGameOver, content: {
                        Alert(title: Text("GAME OVER"),
                              message: Text("Your final Score is " + String(twos.score)),
                              dismissButton: Alert.Button.default(Text("Start new Game"),
                                                                  action:       {twos.newgame(rand: selection)
                                                           twos.spawn()
                                                           twos.spawn()
                                                          })
                        )
                    })
                }
                Button(action: {
                    moved = twos.collapse(dir: Direction.down)
                    if(moved) {
                        twos.spawn()
                    }
                    if(twos.isGameOver()) {
                        isGameOver = true
                    }
                }, label: {
                    Text("Down")
                        .font(.system(size:35))
                        .padding()
                        .frame(width: 150)
                        .border(Color.blue, width: 5)
                })
                .alert(isPresented: $isGameOver, content: {
                    Alert(title: Text("GAME OVER"),
                          message: Text("Your final Score is " + String(twos.score)),
                          dismissButton: Alert.Button.default(Text("Start new Game"),
                                                              action:       {twos.newgame(rand: selection)
                                                           twos.spawn()
                                                           twos.spawn()
                                                          })
                    )
                })
                Button(action: {
                    twos.newgame(rand: selection)
                    twos.spawn()
                    twos.spawn()
                }, label: {
                    Text("New Game")
                        .font(.system(size:35))
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Twos())
    }
}


struct Cell: View {
    var tile: Tile
    var body: some View {
        // 0
        if(tile.val == 0) {
            Text("")
                .font(.system(size: 35))
                .frame(width: 50, height: 50, alignment: .center)
                .padding()
                .minimumScaleFactor(0.5)
                .background(Color.gray)
                .cornerRadius(30)
        }
        // 2 Turquoise
        if(tile.val == 2) {
            Text("2")
                .font(.system(size: 35))
                .frame(width: 50, height: 50, alignment: .center)
                .padding()
                .minimumScaleFactor(0.5)
                .background(Color(red: 175/255, green: 238/255, blue: 238/255))
                .cornerRadius(30)
        }
        // 4 Light Brown
        if(tile.val == 4) {
            Text("4")
                .font(.system(size: 35))
                .frame(width: 50, height: 50, alignment: .center)
                .padding()
                .minimumScaleFactor(0.5)
                .background(Color(red: 181/255, green: 101/255, blue: 29/255))
                .cornerRadius(30)
        }
        // 8 Magenta
        if(tile.val == 8) {
            Text("8")
                .font(.system(size: 35))
                .frame(width: 50, height: 50, alignment: .center)
                .padding()
                .minimumScaleFactor(0.5)
                .background(Color(red: 255/255, green: 0, blue: 255/255))
                .cornerRadius(30)
        }
        // 16 yellow
        if(tile.val == 16) {
            Text("16")
                .font(.system(size: 35))
                .frame(width: 50, height: 50, alignment: .center)
                .padding()
                .minimumScaleFactor(0.5)
                .background(Color.yellow)
                .cornerRadius(30)
        }
        // 32 Cyan
        if(tile.val == 32) {
            Text("32")
                .font(.system(size: 35))
                .frame(width: 50, height: 50, alignment: .center)
                .padding()
                .minimumScaleFactor(0.5)
                .background(Color(red: 0, green: 255/255, blue: 255/255))
                .cornerRadius(30)
        }
        // 64 Lime
        if(tile.val == 64) {
            Text("64")
                .font(.system(size: 35))
                .frame(width: 50, height: 50, alignment: .center)
                .padding()
                .minimumScaleFactor(0.5)
                .background(Color(red: 0, green: 255/255, blue: 0))
                .cornerRadius(30)
        }
        // 128 or more light pink
        if(tile.val >= 128) {
            Text("128")
                .font(.system(size: 35))
                .frame(width: 50, height: 50, alignment: .center)
                .padding()
                .minimumScaleFactor(0.5)
                .background(Color(red: 248/255, green: 131/255, blue: 121/255))
                .cornerRadius(30)
        }
    }
}
