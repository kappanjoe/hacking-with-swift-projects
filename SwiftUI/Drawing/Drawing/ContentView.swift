//
//  ContentView.swift
//  Drawing
//
//  Created by Joseph Van Alstyne on 12/14/22.
//

import SwiftUI

struct ContentView: View {
	struct Triangle: Shape {
		func path(in rect: CGRect) -> Path {
			var path = Path()

			path.move(to: CGPoint(x: rect.midX, y: rect.minY))
			path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
			path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
			path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))

			return path
		}
	}
	
	struct Arc: InsettableShape {
		var startAngle: Angle
		var endAngle: Angle
		var clockwise: Bool
		
		var insetAmount = 0.0

		func path(in rect: CGRect) -> Path {
			let rotationAdjustment = Angle.degrees(90)
			let modifiedStart = startAngle - rotationAdjustment
			let modifiedEnd = endAngle - rotationAdjustment

			var path = Path()
			path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)

			return path
		}
		
		// Added to conform with InsettableShape to allow .strokeBorder
		func inset(by amount: CGFloat) -> some InsettableShape {
			var arc = self
			arc.insetAmount += amount
			return arc
		}
	}
	
	struct Flower: Shape {
		// How much to move this petal away from the center
		var petalOffset: Double = -20

		// How wide to make each petal
		var petalWidth: Double = 100

		func path(in rect: CGRect) -> Path {
			// The path that will hold all petals
			var path = Path()

			// Count from 0 up to pi * 2, moving up pi / 8 each time
			for number in stride(from: 0, to: Double.pi * 2, by: Double.pi / 8) {
				// rotate the petal by the current value of our loop
				let rotation = CGAffineTransform(rotationAngle: number)

				// move the petal to be at the center of our view
				let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))

				// create a path for this petal using our properties plus a fixed Y and height
				let originalPetal = Path(ellipseIn: CGRect(x: petalOffset, y: 0, width: petalWidth, height: rect.width / 2))

				// apply our rotation/position transformation to the petal
				let rotatedPetal = originalPetal.applying(position)

				// add it to our main path
				path.addPath(rotatedPetal)
			}

			// now send the main path back
			return path
		}
	}
	
	@State private var petalOffset = -20.0
	@State private var petalWidth = 100.0
	
	struct ColorCyclingCircle: View {
		var amount = 0.0
		var steps = 100

		var body: some View {
			ZStack {
				ForEach(0..<steps) { value in
					Circle()
						.inset(by: Double(value))
						.strokeBorder(
							LinearGradient(
								gradient: Gradient(colors: [
									color(for: value, brightness: 1),
									color(for: value, brightness: 0.5)
								]),
								startPoint: .top,
								endPoint: .bottom
							),
							lineWidth: 2
						)
				}
			}
			.drawingGroup()
		}

		func color(for value: Int, brightness: Double) -> Color {
			var targetHue = Double(value) / Double(steps) + amount

			if targetHue > 1 {
				targetHue -= 1
			}

			return Color(hue: targetHue, saturation: 1, brightness: brightness)
		}
	}
	
	@State private var colorCycle = 0.0
	
	// @State private var amount = 0.0
	
	struct Trapezoid: Shape {
		var insetAmount: Double
		
		var animatableData: Double {
			get { insetAmount }
			set { insetAmount = newValue }
		}

		func path(in rect: CGRect) -> Path {
			var path = Path()

			path.move(to: CGPoint(x: 0, y: rect.maxY))
			path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
			path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
			path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
			path.addLine(to: CGPoint(x: 0, y: rect.maxY))

			return path
	   }
	}
	
	@State private var insetAmount = 50.0
	
	struct Checkerboard: Shape {
		var rows: Int
		var columns: Int
		
		var animatableData: AnimatablePair<Double, Double> {
			get {
			   AnimatablePair(Double(rows), Double(columns))
			}

			set {
				rows = Int(newValue.first)
				columns = Int(newValue.second)
			}
		}

		func path(in rect: CGRect) -> Path {
			var path = Path()

			// figure out how big each row/column needs to be
			let rowSize = rect.height / Double(rows)
			let columnSize = rect.width / Double(columns)

			// loop over all rows and columns, making alternating squares colored
			for row in 0..<rows {
				for column in 0..<columns {
					if (row + column).isMultiple(of: 2) {
						// this square should be colored; add a rectangle here
						let startX = columnSize * Double(column)
						let startY = rowSize * Double(row)

						let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
						path.addRect(rect)
					}
				}
			}

			return path
		}
	}
	
	@State private var rows = 4
	@State private var columns = 4
	
	struct Roulette: Shape {
		let innerRadius: Int
		let outerRadius: Int
		let distance: Int
		let amount: Double
		
		func gcd(_ a: Int, _ b: Int) -> Int {
			var a = a
			var b = b

			while b != 0 {
				let temp = b
				b = a % b
				a = temp
			}

			return a
		}
		
		func path(in rect: CGRect) -> Path {
			let divisor = gcd(innerRadius, outerRadius)
			let outerRadius = Double(self.outerRadius)
			let innerRadius = Double(self.innerRadius)
			let distance = Double(self.distance)
			let difference = innerRadius - outerRadius
			let endPoint = ceil(2 * Double.pi * outerRadius / Double(divisor)) * amount

			var path = Path()

			for theta in stride(from: 0, through: endPoint, by: 0.01) {
				var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
				var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)

				x += rect.width / 2
				y += rect.height / 2

				if theta == 0 {
					path.move(to: CGPoint(x: x, y: y))
				} else {
					path.addLine(to: CGPoint(x: x, y: y))
				}
			}

			return path
		}
	}
	
	@State private var innerRadius = 125.0
	@State private var outerRadius = 75.0
	@State private var distance = 25.0
	@State private var amount = 1.0
	@State private var hue = 0.6
	
	var body: some View {
// ----- Triangle with rounded corners ----- //
//
//		Path { path in
//			path.move(to: CGPoint(x: 200, y: 100))
//			path.addLine(to: CGPoint(x: 100, y: 300))
//			path.addLine(to: CGPoint(x: 300, y: 300))
//			path.addLine(to: CGPoint(x: 200, y: 100))
//			// path.closeSubpath()
//		}
//		.stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
		
// ----- Triangle from struct ----- //
//
//		Triangle()
//			.stroke(.red, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
//			.frame(width: 300, height: 300)
		
// ----- Arc from struct ----- //
//
//		Arc(startAngle: .degrees(0), endAngle: .degrees(110), clockwise: true)
//			.stroke(.blue, lineWidth: 10)
//			.frame(width: 300, height: 300)
		
// ----- Use .stroke for middle stroke, .strokeBorder for inside stroke ----- //
//		Circle()
//			.strokeBorder(.blue, lineWidth: 40)
//
//		Arc(startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
//			.strokeBorder(.blue, lineWidth: 40)
		
// ----- Roulette Lite ----- //
//
//		VStack {
//			Flower(petalOffset: petalOffset, petalWidth: petalWidth)
//				.fill(.red, style: FillStyle(eoFill: true))
//
//			Text("Offset")
//			Slider(value: $petalOffset, in: -40...40)
//				.padding([.horizontal, .bottom])
//
//			Text("Width")
//			Slider(value: $petalWidth, in: 0...100)
//				.padding(.horizontal)
//		}
		
// ----- ImagePaint ----- //
//
//		VStack {
//			Text("Hello World")
//				.frame(width: 300, height: 300)
//				.border(ImagePaint(image: Image("Example"), sourceRect: CGRect(x: 0, y: 0.25, width: 1, height: 0.5), scale: 0.1), width: 30)
//
//			Capsule()
//				.strokeBorder(ImagePaint(image: Image("Example"), scale: 0.1), lineWidth: 20)
//				.frame(width: 300, height: 200)
//		}
		
// ----- drawingGroup() ----- //
//
//		VStack {
//			ColorCyclingCircle(amount: colorCycle)
//				.frame(width: 300, height: 300)
//
//			Slider(value: $colorCycle)
//		}
		
// ----- Blend Modes: Multiply ----- //
//
//		ZStack {
//			Image("Example")
//
//			Rectangle()
//				.fill(.red)
//				.blendMode(.multiply)
//		// Shortcut version of .blendMode(.multiply):
//			Image("Example")
//					.colorMultiply(.red)
//		}
//		.frame(width: 400, height: 500)
//		.clipped()

// ----- Blend Modes: Screen ----- //
//
//		VStack {
//			ZStack {
//				Circle()
//					.fill(.red)
//					.frame(width: 200 * amount)
//					.offset(x: -50, y: -80)
//					.blendMode(.screen)
//
//				Circle()
//					.fill(.green)
//					.frame(width: 200 * amount)
//					.offset(x: 50, y: -80)
//					.blendMode(.screen)
//
//				Circle()
//					.fill(.blue)
//					.frame(width: 200 * amount)
//					.blendMode(.screen)
//			}
//			.frame(width: 300, height: 300)
//
//			Slider(value: $amount)
//				.padding()
//		}
//		.frame(maxWidth: .infinity, maxHeight: .infinity)
//		.background(.black)
//		.ignoresSafeArea()
		
// ----- Blur ----- //
//
//		VStack {
//			Spacer()
//			Image("Example")
//				.resizable()
//				.scaledToFit()
//				.frame(width: 200, height: 200)
//				.saturation(amount)
//				.blur(radius: (1 - amount) * 20)
//			Spacer()
//			Slider(value: $amount)
//				.padding()
//		}
		
// ----- Animatable Data ----- //
//
//		Trapezoid(insetAmount: insetAmount)
//			.frame(width: 200, height: 100)
//			.onTapGesture {
//				withAnimation {
//					insetAmount = Double.random(in: 10...90)
//				}
//			}
		
// ----- Animatable Pair ----- //
//
//		Checkerboard(rows: rows, columns: columns)
//			.onTapGesture {
//				withAnimation(.linear(duration: 3)) {
//					rows = 8
//					columns = 16
//				}
//			}
		
// ----- Roulette ----- //
//
		VStack(spacing: 0) {
			Spacer()

			Roulette(innerRadius: Int(innerRadius), outerRadius: Int(outerRadius), distance: Int(distance), amount: amount)
				.stroke(Color(hue: hue, saturation: 1, brightness: 1), lineWidth: 1)
				.frame(width: 300, height: 300)

			Spacer()

			Group {
				Text("Inner radius: \(Int(innerRadius))")
				Slider(value: $innerRadius, in: 10...150, step: 1)
					.padding([.horizontal, .bottom])

				Text("Outer radius: \(Int(outerRadius))")
				Slider(value: $outerRadius, in: 10...150, step: 1)
					.padding([.horizontal, .bottom])

				Text("Distance: \(Int(distance))")
				Slider(value: $distance, in: 1...150, step: 1)
					.padding([.horizontal, .bottom])

				Text("Amount: \(amount, format: .number.precision(.fractionLength(2)))")
				Slider(value: $amount)
					.padding([.horizontal, .bottom])

				Text("Color")
				Slider(value: $hue)
					.padding(.horizontal)
			}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
