//
//  SignUpScreen.swift
//  DecoratAR
//
//  Created by Quincy Williams on 1/24/21.
//

import SwiftUI
struct SignUpScreen: View {
    @State var firstName = ""
    @State var lastName = ""
    @State var userEmail = ""
    @State var userPassword = ""
    @State var passwordConfirm = ""
    
    var body: some View{
        VStack(spacing :15) {
            Text("Create Account")
                .font(.system(size: 70, weight: .semibold))
                .foregroundColor(.green)
                .shadow(radius: 10 )
            HStack{
                Image(systemName: "person")
                    .foregroundColor(.gray)
                TextField("First Name", text: $firstName)
            }
            .padding(.all, 20)
            .background(Color.white)
            .cornerRadius(8)
            .padding(.horizontal, 90)
            HStack{
                Image(systemName: "person")
                    .foregroundColor(.gray)
                TextField("LastName", text: $lastName)
            }
            .padding(.all, 20)
            .background(Color.white)
            .cornerRadius(8)
            .padding(.horizontal, 90)
            HStack{
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                TextField("Email", text: $userEmail)
                    .disableAutocorrection(true)
            }
            .padding(.all, 20)
            .background(Color.white)
            .cornerRadius(8)
            .padding(.horizontal, 90)
            HStack{
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                SecureField("Password", text: $userPassword)
                    .foregroundColor(.black)
            }
            .padding(.all, 20)
            .background(Color.white)
            .cornerRadius(8)
            .padding(.horizontal, 90)
            HStack{
                Image(systemName: "lock")
                    .foregroundColor(.gray)
                TextField("Confirm Password", text:$passwordConfirm)
                    .foregroundColor(.black)
            }
            .padding(.all, 20)
            .background(Color.white)
            .cornerRadius(8)
            .padding(.horizontal, 90)
            Button(action:{}) {
                Text("Create Account")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .medium))
            }.frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.blue.opacity(0.8))
            .cornerRadius(8)
            .padding(.horizontal, 150)
            Button(action:{}) {
                Text("Cancel")
                    .foregroundColor(.white)
                    .font(.system(size: 24, weight: .medium))
            }.frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color.red.opacity(0.8))
            .cornerRadius(8)
            .padding(.horizontal, 150)
        }.background(
            Image("Room Background")
                .resizable()
                .padding(-70.0)
                .opacity(0.8)
                .aspectRatio(contentMode: .fill)
        ).edgesIgnoringSafeArea(.all)
    }
}

struct SignUpScreen_Preview: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}
