//
//  QRCodePixelShapeSquare.swift
//
//  Copyright © 2024 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial
//  portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
//  WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
//  OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
//  OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import CoreGraphics
import Foundation

public extension QRCode.PixelShape {
	/// A square pixel shape
	@objc(QRCodePixelShapeSquare) class Square: NSObject, QRCodePixelShapeGenerator {
		/// The generator name
		@objc public static let Name: String = "square"
		/// The generator title
		@objc public static var Title: String { "Square" }

		/// Create
		/// - Parameters:
		///   - insetFraction: The inset between each pixel
		///   - useRandomInset: If true, chooses a random inset value (between 0.0 -> `insetFraction`) for each pixel
		///   - rotationFraction: A rotation factor (0 -> 1) to apply to the rotation of each pixel
		///   - useRandomRotation: If true, randomly sets the rotation of each pixel within the range `0 ... rotationFraction`
		@objc public init(
			insetFraction: CGFloat = 0,
			useRandomInset: Bool = false,
			rotationFraction: CGFloat = 0,
			useRandomRotation: Bool = false
		) {
			self.common = CommonPixelGenerator(
				pixelType: .square,
				insetFraction: insetFraction,
				useRandomInset: useRandomInset,
				rotationFraction: rotationFraction,
				useRandomRotation: useRandomRotation
			)
			super.init()
		}

		/// Create an instance of this path generator with the specified settings
		@objc public static func Create(_ settings: [String: Any]?) -> QRCodePixelShapeGenerator {
			let insetFraction = DoubleValue(settings?[QRCode.SettingsKey.insetFraction, default: 0]) ?? 0
			let useRandomInset = BoolValue(settings?[QRCode.SettingsKey.useRandomInset]) ?? false
			let rotationFraction = CGFloatValue(settings?[QRCode.SettingsKey.rotationFraction]) ?? 0.0
			let useRandomRotation = BoolValue(settings?[QRCode.SettingsKey.useRandomRotation]) ?? false
			return Square(
				insetFraction: insetFraction,
				useRandomInset: useRandomInset,
				rotationFraction: rotationFraction,
				useRandomRotation: useRandomRotation
			)
		}

		/// Make a copy of this shape
		@objc public func copyShape() -> QRCodePixelShapeGenerator {
			return Square(
				insetFraction: self.common.insetFraction,
				useRandomInset: self.common.useRandomInset,
				rotationFraction: self.common.rotationFraction,
				useRandomRotation: self.common.useRandomRotation
			)
		}

		/// Generate a CGPath from the matrix contents
		/// - Parameters:
		///   - matrix: The matrix to generate
		///   - size: The size of the resulting CGPath
		/// - Returns: A path
		public func generatePath(from matrix: BoolMatrix, size: CGSize) -> CGPath {
			common.generatePath(from: matrix, size: size)
		}

		/// The fractional inset for the pixel
		@objc public var insetFraction: CGFloat { self.common.insetFraction }

		private let common: CommonPixelGenerator
	}
}

// MARK: - Settings

public extension QRCode.PixelShape.Square {
	/// Returns true if the shape supports setting a value for the specified key, false otherwise
	@objc func supportsSettingValue(forKey key: String) -> Bool {
		return key == QRCode.SettingsKey.insetFraction
			|| key == QRCode.SettingsKey.useRandomInset
			|| key == QRCode.SettingsKey.rotationFraction
			|| key == QRCode.SettingsKey.useRandomRotation
	}

	/// Returns the current settings for the shape
	@objc func settings() -> [String: Any] {
		return [
			QRCode.SettingsKey.insetFraction: self.common.insetFraction,
			QRCode.SettingsKey.useRandomInset: self.common.useRandomInset,
			QRCode.SettingsKey.rotationFraction: self.common.rotationFraction,
			QRCode.SettingsKey.useRandomRotation: self.common.useRandomRotation,
		]
	}

	/// Set a configuration value for a particular setting string
	@objc func setSettingValue(_ value: Any?, forKey key: String) -> Bool {
		if key == QRCode.SettingsKey.insetFraction {
			return self.common.setInsetFractionValue(value)
		}
		else if key == QRCode.SettingsKey.useRandomInset {
			return self.common.setUsesRandomInset(value)
		}
		else if key == QRCode.SettingsKey.rotationFraction {
			return self.common.setRotationFraction(value)
		}
		else if key == QRCode.SettingsKey.useRandomRotation {
			return self.common.setUsesRandomRotation(value)
		}
		return false
	}
}
