import SwiftUI

struct ImageCarouselView<Content: View, T:Hashable>: View {
    var content: (T) -> Content
    var list: [T]
    
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    @GestureState var offset:CGFloat = 0
    @State var currentIndex:Int = 0
    
    init(spacing: CGFloat = 15, trailingSpace:CGFloat = 100,
         index:Binding<Int>, items:[T], @ViewBuilder content: @escaping (T) -> Content
    ){
        self.list = items
        self.trailingSpace = trailingSpace
        self.spacing = spacing
        self._index = index
        self.content = content
    }
    
    
    var body: some View {
        GeometryReader{ proxy in
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustmentWidth = (trailingSpace/2) - spacing
            HStack(spacing:spacing){
                ForEach(list, id:\.self){item in
                    
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                    
                }
            }.padding(.horizontal, spacing)
                .offset(x:offset + (currentIndex != 0 ? adjustmentWidth : 0) + (CGFloat(currentIndex) * -width))
                .gesture(
                    DragGesture()
                        .updating($offset, body: {value,out,_ in
                            out = value.translation.width
                        })
                        .onEnded({ value in
                            let offsetX = value.translation.width
                            let progress = -offsetX / width
                            let roundIndex = progress.rounded()
                            
                            currentIndex = max(min (currentIndex + Int (roundIndex), list.count - 1) , 0)
                        })
                        .onChanged({value in
                            let offsetX = value.translation.width
                            let progress = -offsetX / width
                            let roundIndex = progress.rounded()
                            
                            index = max(min (currentIndex + Int (roundIndex), list.count - 1) , 0)
                        })
                    
                )
        }.animation(.easeInOut, value: offset == 0)
    }
}


func ImageLoader(from url:String, width:CGFloat) -> some View {
    return AsyncImage(url: URL(string:url)){ phase in
        if let image = phase.image {
            image
                .resizable()
                .scaledToFit()
                .frame(width:width)
            
        }
        else if phase.error != nil {
            Text("Could not load image")
                .padding()
                .background(.gray)
                .frame(width:width, height:200)
                
        }
        else {
            ProgressView()
        }
    }
}

