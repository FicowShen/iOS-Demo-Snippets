//
//  TrySwiftUIProtocols.swift
//  PokeMaster
//
//  Created by Ficow on 2021/12/29.
//  Copyright © 2021 OneV's Den. All rights reserved.
//

import UIKit


//public protocol View {
//
//    associatedtype Body : View
//
//    var body: Self.Body { get }
//}
//
//extension UIView: View {
//    public var body: Never { fatalError() }
//}
//
//extension Never: View {
//    public var body: Never { fatalError() }
//}
//
//@frozen public struct Transaction {}
//public struct EnvironmentValues {}
//
//public struct UIViewRepresentableContext<Representable> where Representable : UIViewRepresentable {
//
//    /// The view's associated coordinator.
//    public let coordinator: Representable.Coordinator
//
//    /// The current transaction.
//    public var transaction: Transaction { fatalError() }
//
//    /// The current environment.
//    ///
//    /// Use the environment values to configure the state of your view when
//    /// creating or updating it.
//    public var environment: EnvironmentValues { fatalError() }
//}
//
//public protocol UIViewRepresentable : View where Self.Body == Never {
//
//    associatedtype UIViewType : UIView
//
//    func makeUIView(context: Self.Context) -> Self.UIViewType
//    func updateUIView(_ uiView: Self.UIViewType, context: Self.Context)
//    static func dismantleUIView(_ uiView: Self.UIViewType, coordinator: Self.Coordinator)
//
//    associatedtype Coordinator = Void
//
//    func makeCoordinator() -> Self.Coordinator
//
//    typealias Context = UIViewRepresentableContext<Self>
//}
//
//struct MyView: UIViewRepresentable {
//
//    var body: Never
//
//
//    func makeUIView(context: Context) -> UIView {
//        UIView()
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {
//        context.coordinator.view
//    }
//
//    static func dismantleUIView(_ uiView: UIView, coordinator: Coordinator) {
//
//    }
//
//    class Coordinator {
//        let view: MyView
//
//        init(view: MyView) {
//            self.view = view
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(view: self)
//    }
//}
