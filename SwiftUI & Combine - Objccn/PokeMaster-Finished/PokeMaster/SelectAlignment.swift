import SwiftUI

struct VerticalAlignmentContentView: View {

    @State var selectedIndex = 0

    let names = [
        "onevcat | Wei Wang",
        "zaq | Hao Zang",
        "tyyqa | Lixiao Yang"
    ]

    var body: some View {
        HStack(alignment: .verticalSelect) {
            Text("User:")
                .font(.footnote)
                .foregroundColor(.green)
                .alignmentGuide(.verticalSelect) { d in
                    // 以底部为基准，再加上选中的行到整个 HStack 上端的总高度
                    d[.bottom] + CGFloat(self.selectedIndex) * 20.3
                }
            Image(systemName: "person.circle")
                .foregroundColor(.green)
                .alignmentGuide(.verticalSelect) { d in
                    // Image 的中心部位应该和其他部分对齐
                    d[VerticalAlignment.center]
                }
            VStack(alignment: .leading) {
                ForEach(0..<names.count) { index in
                    Group {
                        if index == self.selectedIndex {
                            Text(self.names[index])
                                .foregroundColor(.green)
                                .alignmentGuide(.verticalSelect) { d in
                                    // 把被选中行的中线位置设定成了对齐位置
                                    d[VerticalAlignment.center]
                                }
                        } else {
                            Text(self.names[index])
                                .onTapGesture {
                                    self.selectedIndex = index
                                }
                        }
                    }
                }
            }
        }
        .animation(.linear(duration: 0.2))
        .lineLimit(1)
    }
}

struct VerticalAlignmentContentView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalAlignmentContentView()
    }
}
