//
//  FilterFlights.swift
//  Enroute
//
//  Created by CS193p Instructor.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI

struct FilterFlights: View {
    
    /*
     This is hardwiring the appropriate object in here
     You can also do NSPredicate(format: "TRUEPREDICATE")
     
     context in environment is not connected to a persistent store coordinator
     
     This is a sheet!
     
     So we need to pass into this sheet the context that we want
     That's why we have this appropriate line
     
     FilterFlights(flightSearch: self.$flightSearch, isPresented: self.$showFilter)
         .environment(\.managedObjectContext, self.context)
     
     
     */
    @FetchRequest(fetchRequest: Airport.fetchRequest(.all)) var airports: FetchedResults<Airport>
    @FetchRequest(fetchRequest: Airline.fetchRequest(.all)) var airlines: FetchedResults<Airline>

    @Binding var flightSearch: FlightSearch
    @Binding var isPresented: Bool
    
    @State private var draft: FlightSearch
    
    init(flightSearch: Binding<FlightSearch>, isPresented: Binding<Bool>) {
        _flightSearch = flightSearch
        _isPresented = isPresented
        _draft = State(wrappedValue: flightSearch.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Destination", selection: $draft.destination) {
                    ForEach(airports.sorted(), id: \.self) { airport in
                        Text("\(airport.friendlyName)").tag(airport)
                    }
                }
                Picker("Origin", selection: $draft.origin) {
                    Text("Any").tag(Airport?.none)
                    ForEach(airports.sorted(), id: \.self) { (airport: Airport?) in
                        Text("\(airport?.friendlyName ?? "Any")").tag(airport)
                    }
                }
                Picker("Airline", selection: $draft.airline) {
                    Text("Any").tag(Airline?.none)
                    ForEach(airlines.sorted(), id: \.self) { (airline: Airline?) in
                        Text("\(airline?.friendlyName ?? "Any")").tag(airline)
                    }
                }
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
            if self.draft.destination != self.flightSearch.destination {
                self.draft.destination.fetchIncomingFlights()
            }
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
