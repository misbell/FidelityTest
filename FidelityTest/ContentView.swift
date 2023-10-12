//
//  ContentView.swift
//  FidelityTest
//
//  Created by Michael Prenez-Isbell on 9/21/23.
//

import SwiftUI



struct ContentView: View {
    
    @State private var results = [Response]()


    struct Response: Codable {
        let id: Int
        let name, username, email: String
        let address: Address
        let phone, website: String
        let company: Company
    }

    // MARK: - Address
    struct Address: Codable {
        let street, suite, city, zipcode: String
        let geo: Geo
    }

    // MARK: - Geo
    struct Geo: Codable {
        let lat, lng: String
    }

    // MARK: - Company
    struct Company: Codable {
        let name, catchPhrase, bs: String
    }

    
    var body: some View {
        VStack {
            List(results, id: \.id) { item in
                   VStack(alignment: .leading) {
                    
                       Text(item.name)
                       Text(item.username)
                       Text(item.email)
                   }
               }
            .task {
                await loadData()
            }
            
        }
        .padding()
    }
    
    func loadData() async {
        // "https://itunes.apple.com/search?term=taylor+swift&entity=song"
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") 
        else
        {
            print("Invalid URL")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            

            if let decodedResponse = try? JSONDecoder().decode([Response].self, from: data) {
            
                results = decodedResponse
               
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}



 
