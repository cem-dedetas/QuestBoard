//
//  InputView.swift
//  test
//
//  Created by Cem Dedetas on 18.09.2023.
//

import SwiftUI

struct InputView: View {
    
    @Binding var text:String
    let title: String
    let placeholder:String
    var isSecureField:Bool = false;
    
    var body: some View {
        VStack(alignment: .leading,spacing: 12){
            Text(title)
                .foregroundColor(Color(.darkGray))
                .fontWeight(.semibold)
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size:14)).autocorrectionDisabled()
            }
            else{
                TextField(placeholder, text: $text)
                    .font(.system(size:14)).autocorrectionDisabled()
                
            }
        }
    }
}

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "E-mail", placeholder: "Example@example.com")
    }
}
