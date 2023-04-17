//
//  SwiftUIView.swift
//  WeatherAPI
//
//  Created by Çağla Karakuş on 4/7/23.
//

import SwiftUI

struct SwiftUIView: View {
    
    
     let temperature: CGFloat
     let city: String
     let desriptions :[String]
     let icons : [URL]
    
    var body: some View {
        VStack(spacing: 10){
            HStack{
                Spacer()
                Text(temperature)
                    .font(.system(size: 130, weight: .medium))
                    .overlay(alignment: .topTrailing){
                        Text("°C")
                            .font(.system(size: 40, weight: .light))
                            .offset(x: 40.rawValue, y: -5)
                    }
                Spacer()
            }
            Text(city)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius:10)
                        .foregroundColor(Color("DarkGray")))
            HStack(spacing: 10){
                ForEach(desriptions, id:\.self){ weatherDescription in

                    VStack(spacing: 2){
                        Text(weatherDescription)
                    }
                }
                ForEach(icons, id:\.self){ imageURL in
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
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
