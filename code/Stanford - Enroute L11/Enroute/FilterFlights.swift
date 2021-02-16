//
//  FilterFlights.swift
//  Enroute
//
//  Created by CS193p Instructor on 5/12/20.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI

struct FilterFlights: View {
    @ObservedObject var allAirports = Airports.all
    @ObservedObject var allAirlines = Airlines.all

    @Binding var flightSearch: FlightSearch
    @Binding var isPresented: Bool
    
    @State private var draft: FlightSearch
    
    init(flightSearch: Binding<FlightSearch>, isPresented: Binding<Bool>) {
        _flightSearch = flightSearch
        _isPresented = isPresented
        // @Binding / @State creates STRUCTS
        // _draft accesses the structure
        _draft = State(wrappedValue: flightSearch.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            /*
             Form is absolutely key here
             Greatly greatly helps the look
             
             FUNDAMENTAL ASPECT OF SWIFTUI
             
             ADAPTS THE UI TO WHAT ELEMENT ITS IN
             
             Elements are not only cross platform but even INTER platform adaptable
             
             ALSO NEEDS TO BE IN A NAVIGATION VIEW SO THAT IT can navigate
             
             
             */
            Form {
                /*
                 Second argument is a BINDING to the thing that you want to change
                 Picker you provide a LIST of views
                 So you're basically always going to want to do a ForEach
                 
                 .tag
                 Whenever you pick the view, it's going to put it into the selection variable
                 
                 THE TAG HAS TO HAVE EXACTLY THE SAME AS WHAT WE'RE BINDING TO
                 this is all accomplished by tag
                 */
                Picker("Destination", selection: $draft.destination) {
                    ForEach(allAirports.codes, id: \.self) { airport in
                        Text("\(self.allAirports[airport]?.friendlyName ?? airport)").tag(airport)
                    }
                }
//                .pickerStyle(WheelPicker())
                
                /*
                 subtlety: optional string is NOT the same as
                 draft.origin is OPTIONAL string
                 .tag is optional
                 */
                Picker("Origin", selection: $draft.origin) {
                    /*
                     Picker picks views! So if we want any we need to have that as an actual option!
                     
                     */
                    Text("Any").tag(String?.none)
                    ForEach(allAirports.codes, id: \.self) { (airport: String?) in
                        Text("\(self.allAirports[airport]?.friendlyName ?? airport ?? "Any")").tag(airport)
                    }
                }
                Picker("Airline", selection: $draft.airline) {
                    Text("Any").tag(String?.none)
                    ForEach(allAirlines.codes, id: \.self) { (airline: String?) in
                        Text("\(self.allAirlines[airline]?.friendlyName ?? airline ?? "Any")").tag(airline)
                    }
                }
                /*
                 Toggle takes a binding to something it's going to toggle
                 in the air vs on the ground
                 */
                Toggle(isOn: $draft.inTheAir) { Text("Enroute Only") }
            }
            .navigationBarTitle("Filter Flights")
                .navigationBarItems(leading: cancel, trailing: done)
        }
    }
    
    var cancel: some View {
        Button("Cancel") {
            self.isPresented = false
        }
    }
    var done: some View {
        Button("Done") {
            /*
             This is a good way of doing things. You keep almost a local draft
             and then only when they cancel out do you set the rest back.
             L11 is providing increasingly helpful for Assignment 6.
             */
            self.flightSearch = self.draft
            self.isPresented = false
        }
    }
}

//struct FilterFlights_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterFlights()
//    }
//}
