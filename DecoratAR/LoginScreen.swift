//
//  ContentView.swift
//  DecoratAR
//
//  Created by Quincy Williams on 11/22/20.
//
import SwiftUI
import Firebase

struct LoginScreen: View {
    @State var userEmail = ""
    @State var userPassword = ""
    @State var showSignUpScreen = false
    @State var showMainScreen = false
    
    var mainScreen = MainScreen()
    
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
                    .disableAutocorrection(true)
                    .foregroundColor(.black)
            }
            .padding(.all, 20)
            .background(Color.white)
            .cornerRadius(8)
            .padding(.horizontal, 150)
            HStack{
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                SecureField("Password", text: $userPassword)
                    .foregroundColor(.black)
            }
            .padding(.all, 20)
            .background(Color.white)
            .cornerRadius(8)
            .padding(.horizontal, 150)
            Button(action:{
                Auth.auth().signIn(withEmail: self.userEmail, password: self.userPassword, completion: {(result, err) in
                    if err != nil {
                        self.showMainScreen.toggle()
                    }
                })
            }) {
                Text("Sign In")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .medium))
            }.frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.blue.opacity(0.8))
            .cornerRadius(8)
            .padding(.horizontal, 200)
            Button(action:{
                self.showSignUpScreen.toggle()
            }) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .medium))
            }.sheet(isPresented: $showSignUpScreen, content: {
                SignUpScreen()
            })
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.green.opacity(0.8))
            .cornerRadius(8)
            .padding(.horizontal, 200)
            Spacer()
        }.background(
            Image("Room Background")
                .resizable()
                .padding(-38.0)
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
