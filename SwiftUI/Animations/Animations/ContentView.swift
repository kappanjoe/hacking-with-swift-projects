//
//  ContentView.swift
//  Animations
//
//  Created by Joseph Van Alstyne on 12/12/22.
//

import SwiftUI

struct ContentView: View {
//	let letters = Array("Hello SwiftUI")
//	@State private var enabled = false
//	@State private var dragAmount = CGSize.zero
//	@State private var animationAmount = 0.0
	@State private var isShowingRed = false
	
	var body: some View {
// ----- Cool pulsing animation ----- //
//
//		Button("Tap Me") {
//			// animationAmount += 1
//		}
//		.padding(50)
//		.background(.red)
//		.foregroundColor(.white)
//		.clipShape(Circle())
//		.overlay(
//			Circle()
//				.stroke(.red)
//				.scaleEffect(animationAmount)
//				.opacity(2 - animationAmount)
//				.animation(
//					.easeInOut(duration: 1)
//						.repeatForever(autoreverses: false),
//					value: animationAmount
//				)
//			)
//		.onAppear() {
//			animationAmount = 2
//		}

// ----- Animation Hierarchy ----- //
//
//		Button("Tap Me") {
//			enabled.toggle()
//		}
//		.frame(width: 200, height: 200)
//		.background(enabled ? .blue : .red)
//		.animation(.default, value: enabled)
//		.foregroundColor(.white)
//		.clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
//		.animation(.interpolatingSpring(stiffness: 10, damping: 1), value: enabled)
		
// ----- Card Animation ----- //
//
//		LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
//					.frame(width: 300, height: 200)
//					.clipShape(RoundedRectangle(cornerRadius: 10))
//					.offset(dragAmount)
//					.gesture(
//					DragGesture()
//						.onChanged {
//							dragAmount = $0.translation
//						}
//						.onEnded { _ in
//							withAnimation(.spring()) {
//									dragAmount = .zero
//							}
//						}
//					)

// ----- Snake Animation ----- //
//
//		HStack(spacing: 0) {
//					ForEach(0..<letters.count, id: \.self) { num in
//						Text(String(letters[num]))
//							.padding(5)
//							.font(.title)
//							.background(enabled ? .blue : .red)
//							.offset(dragAmount)
//							.animation(.default.delay(Double(num) / 20), value: dragAmount)
//					}
//				}
//				.gesture(
//					DragGesture()
//						.onChanged { dragAmount = $0.translation }
//						.onEnded { _ in
//							dragAmount = .zero
//							enabled.toggle()
//						}
//				)
		
// ----- Transitions (Broken in iOS 16?) ----- //
//
//		VStack {
//			Button("Tap Me") {
//				withAnimation {
//					isShowingRed.toggle()
//				}
//			}
//
//			if isShowingRed {
//				Rectangle()
//					.fill(.red)
//					.frame(width: 200, height: 200)
//					.transition(.asymmetric(insertion: .scale, removal: .opacity))
//			}
//		}
		
		ZStack {
					Rectangle()
						.fill(.blue)
						.frame(width: 200, height: 200)

					if isShowingRed {
						Rectangle()
							.fill(.red)
							.frame(width: 200, height: 200)
							.transition(.pivot)
					}
				}
				.onTapGesture {
					withAnimation {
						isShowingRed.toggle()
					}
				}
		
    }
}

struct CornerRotateModifier: ViewModifier {
	let amount: Double
	let anchor: UnitPoint

	func body(content: Content) -> some View {
		content
			.rotationEffect(.degrees(amount), anchor: anchor)
			.clipped()
	}
}

extension AnyTransition {
	// Broken in iOS 16?
	static var pivot: AnyTransition {
		.modifier(
			active: CornerRotateModifier(amount: -90, anchor: .topLeading),
			identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
		)
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
