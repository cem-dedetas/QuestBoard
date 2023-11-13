import SwiftUI

struct CachedImageView: View {
    let url: String
    let width: CGFloat

    var body: some View {
        if let imageURL = URL(string: url) {
            return AnyView(
                AsyncImage(
                    url: imageURL,
                    placeholder: {
                        ProgressView().frame(width: width, height: width)
                    },
                    image: { image in
                        Image(uiImage: image)
                            .resizable()
                    }
                )
                .scaledToFill()
                .frame(width: width)
                .background(Color.gray)
            )
        } else {
            return AnyView(
                Text("Could not load image")
                    .padding()
                    .background(Color.gray)
                    .frame(width: width, height: 300)
            )
        }
    }
}
