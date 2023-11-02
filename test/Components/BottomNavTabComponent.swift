//
//  BottomNavTabComponent.swift
//  test
//
//  Created by Cem Dedetas on 21.09.2023.
//

import SwiftUI

struct BottomNavTabComponent: View {
    @Binding var tabSelection : Int
    @Namespace var tabAnimationNamespace
    let tabBarItems:[(image:String, title:String)]
    
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius:36)
                .frame(width: UIScreen.main.bounds.width - 24, height: 80)
                .foregroundStyle(.thickMaterial)
                .shadow(radius: 9)
            HStack(spacing:1){
                ForEach(0..<4){ index in
                    Button{
                        tabSelection = index + 1
                    } label:{
                        VStack(spacing:8){
                            Spacer()
                            
                            Image(systemName: tabBarItems[index].image)
                            Text(tabBarItems[index].title).font(.footnote)
                            
                            
                            if(index + 1 == tabSelection){
                                Capsule()
                                    .frame(width:50,height: 8)
                                    .foregroundColor(Color.accentColor)
                                    .matchedGeometryEffect(id: "SelectedTabID", in: tabAnimationNamespace)
                                    .offset(y:3)
                                
                            } else {
                                Capsule()
                                    .frame(width:50,height: 8)
                                    .foregroundColor(.clear)
                                    .offset(y:3)
                            }
                        }.padding(.horizontal,25)
                        .foregroundColor(index + 1 == tabSelection ? .blue : .gray)
                    }
                }
            }.frame(height:80)
                .clipShape(RoundedRectangle(cornerRadius:36))
        }
        .padding(.horizontal,5)
        .keyboardAdaptive()
    }
}

extension View {
    func keyboardAdaptive() -> some View {
        ModifiedContent(
            content: self,
            modifier: KeyboardAdaptive())
    }
}

struct KeyboardAdaptive: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .opacity(keyboardHeight > 0 ? 0 : 1) // Hide the content when the keyboard is shown
            .onAppear(perform: {
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
                    guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
                        return
                    }
                        keyboardHeight = keyboardFrame.height
                }
                
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    withAnimation{
                        keyboardHeight = 0
                    }
                }
            })
    }
}


#Preview {
    BottomNavTabComponent(tabSelection: .constant(1), tabBarItems: [("map","Map"),
                                                                    ("list.bullet.indent","List"),
                                                                    ("rectangle.stack.badge.person.crop","My Ads"),
                                                                    ("person","Profile")])
}
