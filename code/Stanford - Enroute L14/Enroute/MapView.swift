//
//  MapView.swift
//  Enroute
//
//  Created by CS193p Instructor on 5/27/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit

struct MapView: UIViewRepresentable {
    let annotations: [MKAnnotation] // this is just a protocol! 
    @Binding var selection: MKAnnotation?
    
    func makeUIView(context: Context) -> MKMapView {
        let mkMapView = MKMapView()
        mkMapView.delegate = context.coordinator // COORDINATOR COMES FROM THE CONTEXT
        mkMapView.addAnnotations(self.annotations)
        return mkMapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let annotation = selection {
            
            // town size view!
            // span is an MKCoordianteSpan
            let town = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            uiView.setRegion(MKCoordinateRegion(center: annotation.coordinate, span: town), animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selection: $selection)
    }
    
    
    /*
     DELEGATES ARE ALWAYS INHERITING FROM NSOBJECT
     
     MKMapViewDelete
     
     mapView(mapView, viewFor annotation: MKAnnotation) -> MkAnnotationView
     */
    class Coordinator: NSObject, MKMapViewDelegate {
        @Binding var selection: MKAnnotation?
        
        init(selection: Binding<MKAnnotation?>) {
            self._selection = selection
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            // Not really here to learn MapKit so we're just going to use a pin
            // dequeueReusableAnnotationView
            // MKPinAnnotationView is just a pin
            // canShowCallout -> don't really know what this does actually
            // how the mapview knows what view to use to draw a certain annotation
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "MapViewAnnotation") ??
                MKPinAnnotationView(annotation: annotation, reuseIdentifier: "MapViewAnnotation")
            view.canShowCallout = true
            return view
        }
        
        // this is called whenever one of the pin views is touched on
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            
            // get the annotation by saying pin thing what's your annotation
            
            // we need to BIND this selection to the outside
            if let annotation = view.annotation {
                self.selection = annotation
            }
        }
    }
}
