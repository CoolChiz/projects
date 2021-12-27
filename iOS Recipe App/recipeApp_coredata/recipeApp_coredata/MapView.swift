//
//  MapView.swift
//  cmsc436 recipe project
//
//  Base code from Paul Hudson (publically available)
//  Created by Nafi Mondal on 12/4/21.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var txt: String = ""
    @State private var locations = [MKPointAnnotation]()
    
    private func getLocations(str: String) -> [MKPointAnnotation] {
        var arr: [MKPointAnnotation] = []
        if (txt == "Bananas") {
            let a = MKPointAnnotation()
            a.title = "Lidl"
            a.coordinate = CLLocationCoordinate2D(latitude: 38.996, longitude: -76.931)
            let b = MKPointAnnotation()
            b.title = "Whole Foods"
            b.coordinate = CLLocationCoordinate2D(latitude: 38.969, longitude: -76.935)
            arr.append(a)
            arr.append(b)
        } else if (txt == "Flour") {
            let a = MKPointAnnotation()
            a.title = "Lidl"
            a.coordinate = CLLocationCoordinate2D(latitude: 38.996, longitude: -76.931)
            let b = MKPointAnnotation()
            b.title = "Whole Foods"
            b.coordinate = CLLocationCoordinate2D(latitude: 38.969, longitude: -76.935)
            let c = MKPointAnnotation()
            b.title = "Target"
            b.coordinate = CLLocationCoordinate2D(latitude: 38.982, longitude: -76.937)
            arr.append(a)
            arr.append(b)
            arr.append(c)
        } else if (txt == "Cookies") {
            let a = MKPointAnnotation()
            a.title = "Lidl"
            a.coordinate = CLLocationCoordinate2D(latitude: 38.996, longitude: -76.931)
            let b = MKPointAnnotation()
            b.title = "Whole Foods"
            b.coordinate = CLLocationCoordinate2D(latitude: 38.969, longitude: -76.935)
            let c = MKPointAnnotation()
            b.title = "Target"
            b.coordinate = CLLocationCoordinate2D(latitude: 38.982, longitude: -76.937)
            let d = MKPointAnnotation()
            b.title = "Insomnia Cookies"
            b.coordinate = CLLocationCoordinate2D(latitude: 38.982, longitude: -76.937)
            arr.append(a)
            arr.append(b)
            arr.append(c)
            arr.append(d)
        } else {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = str
            print("This is the query: " + request.naturalLanguageQuery!)
            let search = MKLocalSearch(request: request)
            search.start { response, error in
                guard let response = response else {
                    print("Error")
                    return
                }
                
                for i in response.mapItems {
                    let a = MKPointAnnotation()
                    a.title = i.name
                    a.coordinate = i.placemark.coordinate
                    arr.append(a)
                }
            }
        }
        return arr
    }

    
    var body: some View {
        ZStack(alignment: .top) {
            MiniMapView(annotations: locations)
                .edgesIgnoringSafeArea(.all)
            TextField("Search...", text: $txt, onEditingChanged: {_ in}) {
                locations = self.getLocations(str: txt)
                print("This is locations: \(locations)")
                }.textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
        }
    }
}

struct MiniMapView: UIViewRepresentable {
    var annotations: [MKPointAnnotation]
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = reg()
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if annotations.count != view.annotations.count {
            view.removeAnnotations(view.annotations)
            view.addAnnotations(annotations)
        }
        print("Updating")
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MiniMapView

        init(_ parent: MiniMapView) {
            self.parent = parent
        }
    }
}

extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}

private func reg() -> MKCoordinateRegion {
    return MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 38.99,
            longitude: -76.94),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1)
    )
}
