//
//  HomeView.swift
//  WeatherAPI
//
//  Created by Çağla Karakuş on 10.03.2023.
//


import SwiftUI

struct HomeView: View {
    // MARK: Properties
    @ObservedObject var viewModel: HomeViewModel = .init()
    // MARK: Body
    var body: some View {
        NavigationView{
            
            ZStack{
                
                LinearGradient(colors: [.blue,.white], startPoint:.topLeading , endPoint:.bottomTrailing).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 10){
                    searchBarView
                    weatherDetailView
                }
                .navigationTitle("Weather App")
                
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert("Error Occured", isPresented: $viewModel.isAlertActive) {
            Button("OK", role: .cancel) { }
        }
    }
    
    
    var weatherDetailView: some View {
        // MARK: WEATHER MAIN
        VStack(spacing: 10){
            HStack{
                Spacer()
                Text(String(viewModel.weatherData?.current.temperature ?? Int(0)))
                    .font(.system(size: 130, weight: .medium))
                    .overlay(alignment: .topTrailing){
                        Text("°C")
                            .font(.system(size: 40, weight: .light))
                            .offset(x:40, y:-5)
                    }
                Spacer()
            }
            Text(viewModel.weatherData?.request.query ?? "City not found")
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("DarkGray")))
            HStack(spacing: 10){
                ForEach(viewModel.weatherData?.current.weatherDescriptions ?? ["No Information"], id:\.self){ weatherDescription in

                    VStack(spacing: 2){
                        Text(weatherDescription)
                    }
                }
                ForEach((viewModel.weatherData?.current.weatherIcons) ?? Constant.DummyURL.dummyIconURLs, id:\.self){ imageURL in
                        AsyncImage(url: URL(string: imageURL), content: { image in
                            image
                                .resizable()
                                .scaledToFit()
                        }, placeholder: {
                            ProgressView()
                        })
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("DarkGray"))
            )
        }
        .frame(maxHeight: .infinity)
    }
    
    var searchBarView: some View {
        HStack{
            // MARK: SEARCH BAR
            TextField("Search City", text: $viewModel.searchString)
            Spacer()
            Button {
                viewModel.fetchWeatherData(for: viewModel.searchString) { response in
                    switch response{
                    case .success(_):
                        break
                    case .failure(_):
                        DispatchQueue.main.async {
                            viewModel.isAlertActive.toggle()
                        }
                    }
                }
                
            } label: {
                Image("search")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .padding(.trailing, 4)
            }
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("DarkGray")))
        .padding(10)
    }
    
}



// MARK: - Preview Provider
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
