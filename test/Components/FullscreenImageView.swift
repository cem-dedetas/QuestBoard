//
//  FullscreenImageView.swift
//  test
//
//  Created by Cem Dedetas on 10.10.2023.
//

import SwiftUI

struct FullscreenImageView: View {
    let urls: [String]
    
    @GestureState private var dragOffset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var currentScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var selectedIndex:Int
    
    let minScale: CGFloat = 1.0
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            TabView(){
                ForEach(urls, id: \.self) { url in
                    CachedImageView(url: url, width: UIScreen.main.bounds.width)
                        .scaleEffect(scale * currentScale)
                                .offset(CGSize(width: imageOffset.width + dragOffset.width, height: imageOffset.height + dragOffset.height))
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { scaleDelta in
                                            currentScale = scaleDelta
                                        }
                                        .onEnded { scaleDelta in
                                            withAnimation{
                                                scale = 1.0
                                                currentScale = 1.0
                                                imageOffset = .zero
                                            }
                                        }
                                )
                                .gesture(
                                    DragGesture()
                                        .updating($dragOffset) { value, dragOffset, _ in
                                            dragOffset = value.translation
                                        }
                                        .onEnded { value in
                                            withAnimation{
                                                scale = 1.0
                                                currentScale = 1.0
                                                imageOffset = .zero
                                            }
                                        }
                                )
                            .edgesIgnoringSafeArea(.all)
                }
            }.tabViewStyle(.page(indexDisplayMode: .always))
        }.presentationDetents([.large,.large])
            .presentationDragIndicator(.visible)
            .overlay(alignment:.bottom){
                Button{
                    dismiss()
                } label :{
                    Text("Dismiss")
                }
            }
    }
    
}

#Preview {
    FullscreenImageView(urls:[
        "https://s3.amazonaws.com/edu-recordings/1696782860093",
        "https://s3.amazonaws.com/edu-recordings/1696782860113",
        "https://s3.amazonaws.com/edu-recordings/1696782860136",
        "https://s3.amazonaws.com/edu-recordings/1696782860138",
        "https://s3.amazonaws.com/edu-recordings/1696782860145",
        "https://s3.amazonaws.com/edu-recordings/1696782860154"
    ], selectedIndex: .constant(1))
}
