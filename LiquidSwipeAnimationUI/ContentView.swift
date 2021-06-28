//
//  ContentView.swift
//  LiquidSwipeAnimationUI
//
//  Created by 张亚飞 on 2021/6/27.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct Home: View {
    
    //Liquid swipe offset
    @State var offset: CGSize = .zero
    @State var showHome = false
    
    
    var body: some View {
        
        ZStack {
            
            Color.purple
                .overlay(
                    
                    //conten ....
                    VStack(alignment: .leading, spacing: 10, content: {
                        Text("For Gamers")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    })
                    .foregroundColor(.white)
                )
                .clipShape(LiquidSwipe(offset: offset))
                .ignoresSafeArea()
                .overlay(
                    
                    Image(systemName: "chevron.left")
                        .font(.largeTitle)
                    //For Draggesture to identify
                        .frame(width: 50, height: 50)
                        .contentShape(Rectangle())
                        .gesture(DragGesture().onChanged({ value in
                        
//                            let offset = value.translation
//                            print(offset)
                    
                            withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.6, blendDuration: 0.6)) {
                                
                                offset = value.translation
                            }
                        }).onEnded({ (value) in
                            
                            let screen = UIScreen.main.bounds
                            
                            withAnimation(.spring()) {
                                
                                //validating
                                if -offset.width > screen.width / 2 {
                                    
                                    //removing view
                                    offset.width = -screen.height
                                    showHome.toggle()
                                    
                                    
                                } else {
                                    
                                    offset = .zero
                                }
                                
                            }
                        }))
                        .offset(x:15, y: 58)
                        //hiding while dragging starts...
                        .opacity(offset == .zero ? 1 : 0)
                    
                    ,alignment: .topTrailing
                )
                
                .padding(.trailing)
            
            if showHome {
                
                Text("Welcome To Home")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .onTapGesture {
                        
                        // resetingview
                        withAnimation(.spring()) {
                            
                            offset = .zero
                            showHome.toggle()
                        }
                    }
            }
            
        }
    }
}


struct LiquidSwipe: Shape {
    
    var offset: CGSize
    
    //animation Path...
    var animatableData: CGSize.AnimatableData {
        get{ return offset.animatableData}
        set{offset.animatableData = newValue}
    }
    
    
    func path(in rect: CGRect) -> Path {
        
        return Path { path in
            
            //when user moves left...
            //increasing size both in top and bottom...
            let width = rect.width + (-offset.width > 0 ? offset.width : 0)
            
            //First Constructing Rectangle Shape
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            
            //now constructing curve shape
            
            //from
            let  from = 80 + (offset.width)
            path.move(to: CGPoint(x: rect.width, y: from > 80 ? 80 : from))
            
            var to = 180 + (offset.height) + (-offset.width)
            to = to < 180 ? 180 : to
            //mid between 80 -180..
            let mid: CGFloat = 80 + ((to - 80 ) / 2)
            
            path.addCurve(to: CGPoint(x: rect.width, y: to), control1: CGPoint(x: width - 50, y: mid), control2: CGPoint(x: width - 50, y: mid))
            
            
        }
    }
}
