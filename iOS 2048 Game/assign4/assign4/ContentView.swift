//
//  ContentView.swift
//  assign4
//
//  Created by Duy on 10/25/21.
//

import SwiftUI
import CoreData
import CoreLocation
import MapKit

extension CLLocationCoordinate2D : Identifiable {
    public var id : String {"\(latitude), \(longitude)"}
}


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var tabSelection = 0
    var body: some View {
        TabView(selection: $tabSelection) {
            MapView(tabSelection: $tabSelection)
            .tabItem {
                Label("Map", systemImage: "map")
                Text("Map")
            }
            .tag(0)
            tracksView()
            .tabItem {
                Label("Saved Tracks", systemImage: "list.dash")
            }
            .tag(1)
        }

    }
}

struct tracksView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Track.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Track.name, ascending: true)])
    var tracks: FetchedResults<Track>
    var body: some View {
        NavigationView {
            List {
                ForEach(tracks) { track in
                    NavigationLink(
                        destination: TrackView(track: track, coordinateRegion: bounds(track: track), coordinate2Ds: convertTo2DCoordinates(track: track)),
                        label: {
                            Text("\(track.name) - \(track.time)")
                        })
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        viewContext.delete(tracks[index])
                    }
                    do {
                        try viewContext.save()
                    } catch {
                        print("Error deleting")
                    }
                }
            }
        }
    }
}

struct MapView : View {
    @Environment(\.managedObjectContext) var viewContext
    @EnvironmentObject var locationManager: LocationManager
    @State var region: MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37, longitude: -67), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    @State var recordState: String = "Start"
    @Binding var tabSelection: Int
    @FetchRequest(entity: Track.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Track.name, ascending: true)])
    var tracks: FetchedResults<Track>
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: locationManager.currPath) {
                MapAnnotation(coordinate: $0, content: {
                    Circle().strokeBorder(Color.red, lineWidth: 2).frame(width: 5, height: 5)
                })
            }
            Button(action: {
                if(recordState == "Start") {
                    locationManager.startState = true
                    recordState = "Stop"
                } else {
                    locationManager.startState = false
                    let newTrack = Track(context: viewContext)
                    newTrack.name = ("Track #\(tracks.count + 1)")
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM d, YY, HH:mm:ss"
                    newTrack.time = dateFormatter.string(from: date)
                    for p in locationManager.currPath {
                        let newPoint = Point(context: viewContext)
                        newPoint.latitude = p.latitude
                        newPoint.longitude = p.longitude
                        newTrack.addToPoints(newPoint)
                    }
                    do {
                        try viewContext.save()
                    } catch {
                        print("Failed to save viewContext()")
                    }
                    self.tabSelection = 1
                    locationManager.currPath = []
                    recordState = "Start"
                }
            }, label: {
                Text(recordState)
                    .font(.system(size: 15))
                    .padding()
                    .border(Color.red)
            })
            .padding()
        }
    }
}

struct TrackView : View {
    var track: Track
    @State var coordinateRegion: MKCoordinateRegion
    var coordinate2Ds: [CLLocationCoordinate2D]
    var body: some View {
        VStack {
            Map(coordinateRegion: $coordinateRegion, interactionModes: .all, showsUserLocation: false, annotationItems: coordinate2Ds) {
                MapAnnotation(coordinate: $0, content: {
                    Circle().strokeBorder(Color.red, lineWidth: 2).frame(width: 5, height: 5)
                })
            }
            Text("\(track.name) - \(track.time)")
                .padding()
        }

    }
    

}

func convertTo2DCoordinates(track: Track) -> [CLLocationCoordinate2D] {
    var arr: [CLLocationCoordinate2D] = []
    for point in track.points {
        if let p = point as? Point {
            arr.append(CLLocationCoordinate2D(latitude: p.latitude, longitude: p.longitude))
        }
    }
    return arr
}

func bounds(track: Track) -> MKCoordinateRegion {
    let points2d: [CLLocationCoordinate2D] = convertTo2DCoordinates(track: track)
    let sortedPointsLat = points2d.sorted {
        $0.latitude < $1.latitude
    }
    let sortedPointsLong = points2d.sorted {
        $0.longitude < $1.longitude
    }
    let minLat: CLLocationDegrees = sortedPointsLat[0].latitude
    let maxLat: CLLocationDegrees = sortedPointsLat.last!.latitude
    let minLon: CLLocationDegrees = sortedPointsLong[0].longitude
    let maxLon: CLLocationDegrees = sortedPointsLong.last!.longitude
    return MKCoordinateRegion(center: CLLocationCoordinate2D(
                                latitude: 0.5*(minLat + maxLat),
                                longitude: 0.5*(minLon+maxLon))
                              , span: MKCoordinateSpan(latitudeDelta: 1.5*(maxLat-minLat)
                                                       , longitudeDelta: 1.5*(maxLon-minLon)))
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
