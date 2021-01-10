//
//  ContentView.swift
//  DecoratAR
//
//  Created by Quincy Williams on 11/22/20.
//

import SwiftUI
struct LoginScreen: View {
    @State var userEmail = ""
    @State var userPassword = ""
    var body: some View{
        VStack(spacing: 15) {
            Spacer()
            Text("DecoratAR")
                .font(.system(size: 70, weight: .semibold))
                .foregroundColor(.green)
                .italic()
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            HStack{
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                TextField("Email", text: $userEmail)
            }
            .padding(.all, 20)
            .background(Color.white)
            .cornerRadius(8)
            .padding(.horizontal, 50)
            HStack{
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                SecureField("Password", text: $userPassword)
            }
            .padding(.all, 20)
            .background(Color.white)
            .cornerRadius(8)
            .padding(.horizontal, 50)
            Button(action:{}) {
                Text("Sign In")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .medium))
            }.frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.blue.opacity(0.8))
            .cornerRadius(8)
            .padding(.horizontal, 100)
            Button(action:{}) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .medium))
            }.frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.green.opacity(0.8))
            .cornerRadius(8)
            .padding(.horizontal, 100)
            Spacer()
        }.background(
            Image("Room Background")
                .resizable()
                .opacity(0.8)
                .aspectRatio(contentMode: .fill)
        ).edgesIgnoringSafeArea(.all)
    }
}

struct LoginScreen_Preview: PreviewProvider {
    static var previews: some View{
        LoginScreen()
    }
}
