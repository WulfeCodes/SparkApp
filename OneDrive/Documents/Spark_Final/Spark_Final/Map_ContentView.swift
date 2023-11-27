//
//  ContentView.swift
//  Spark
//
//  Created by Avihhan Arya Kumarr on 11/4/23.
//

import MapKit
import SwiftUI

struct ContentView: View {
    
    // runs the ContentViewModel
    @StateObject private var viewModel = ContentViewModel()
    
    
    var body: some View {
        // zoom in n out (map)
        // shows user's location
        Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
            .ignoresSafeArea()
            .accentColor(Color(red: 234/255, green: 32/255, blue: 432/255))
            .onAppear {
                viewModel.checkIfLocationServicesIsEnabled()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    // running the ContentView()
    static var previews: some View {
        ContentView()
    }
}

