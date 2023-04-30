/*
 * (c) 2023 ios8engineer Limited. All rights reserved.
 */

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    private let viewModel = ContentViewModel()

    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Button {
                viewModel.loadEvents()
            } label: {
                Text("Load events")
            }
            
            Button {
                viewModel.saveGeneratedEvents()
            } label: {
                Text("Save generated events")
            }
            
            Button {
                viewModel.clearCache()
            } label: {
                Text("Clear cache")
            }
            
            Spacer()
            
            Text("© 2023 ios8engineer")
        }
        .padding()
    }
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
