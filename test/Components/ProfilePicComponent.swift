//
//  ProfilePicComponent.swift
//  test
//
//  Created by Cem Dedetas on 4.11.2023.
//

import SwiftUI

struct ProfilePicComponent: View {
    
    let user:User
    
    let width:CGFloat
    
    var body: some View {
        if let imageURL = URL(string: user.profilePicUrl) {
            return AnyView(
                AsyncImage(
                    url: imageURL,
                    placeholder: {
                        ZStack{
                            Circle().foregroundStyle(.secondary.opacity(0.5)).shadow(radius: 2)
                                
                            Text(user.name.first?.uppercased() ?? "")
                                .font(.system(size: width/3))
                                .fontWeight(.black)
                                .foregroundStyle(.primary)
                                
                        }
                    },
                    image: { image in
                        Image(uiImage: image)
                            .resizable()
                    }
                )
                .scaledToFill()
                .frame(width:  width, height: width).clipShape(Circle())
                
            )
        } else {
            return AnyView(
                ZStack{
                    Circle().foregroundStyle(.secondary.opacity(0.5)).shadow(radius: 2)
                        
                    Text(user.name.first?.uppercased() ?? "")
                        .font(.system(size: width/3))
                        .fontWeight(.black)
                        .foregroundStyle(Color(red: .random(in: 0.3..<0.5), green: .random(in: 0.3..<0.5), blue: .random(in: 0.3..<0.5)))
                }
                    .frame(width:  width, height: width).clipShape(Circle())
                    
                    
            )
        }
    }
}

#Preview {
    ProfilePicComponent(user: User(_id: "", name: "Cem Dedetassdfsdfsdf", email: "cemdedetas@gmail.com", profilePicUrl: "https://d2g5r6q74hb2rv.cloudfront.net/eyJidWNrZXQiOiJmbG93Y3YtaW1hZ2VzLXByb2QiLCJrZXkiOiJ3ZWJzaXRlLWludHJvLXBob3RvLzU0UTMtTkJ1eWJqOXJuR1Y0OTBkMS5qcGVnIiwiZWRpdHMiOnsiZ3JheXNjYWxlIjpmYWxzZSwid2VicCI6dHJ1ZSwianBlZyI6dHJ1ZSwicG5nIjpmYWxzZSwicmVzaXplIjp7IndpZHRoIjoxMDAwfX1", favorites: []), width: 200)
}
