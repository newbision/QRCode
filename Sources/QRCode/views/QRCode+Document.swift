//
//  File.swift
//  
//
//  Created by Darren Ford on 23/1/2022.
//

import Foundation

public extension QRCode {

	/// A docuemnt wrapper for a QR code
	@objc(QRCodeDocument) class Document: NSObject {

		/// The correction level to use when generating the QR code
		@objc public var errorCorrection: QRCode.ErrorCorrection = .low {
			didSet {
				self.regenerate()
			}
		}

		/// Binary data to display in the QR code
		@objc public var data = Data() {
			didSet {
				self.regenerate()
			}
		}

		/// The style to use when drawing the qr code
		@objc public var design = QRCode.Design()

		/// This is the pixel dimension for the current QR Code.
		@objc public var pixelSize: Int { return self.qrcode.pixelSize }

		/// A simple ASCII representation of the core QRCode data
		@objc public var asciiRepresentation: String { return self.qrcode.asciiRepresentation() }

		/// A simple smaller ASCII representation of the core QRCode data
		@objc public var smallAsciiRepresentation: String { return self.qrcode.smallAsciiRepresentation() }

		// The qrcode content generator
		private let qrcode = QRCode()

		// Build up the qr representation
		private func regenerate() {
			self.qrcode.update(self.data, errorCorrection: self.errorCorrection)
		}
	}
}

// MARK: - Save/Load

public extension QRCode.Document {

	/// The current settings for the data, shape and design for the QRCode
	@objc func settings() -> [String: Any] {
		return [
			"correction": errorCorrection.ECLevel,
			"data": data.base64EncodedString(),
			"design": self.design.settings()
		]
	}

	@objc static func Create(settings: [String: Any]) -> QRCode.Document? {
		let doc = QRCode.Document()

		let data: Data = {
			if let value = settings["data"] as? String,
				let data = Data(base64Encoded: value) {
				return data
			}
			return Data()
		}()
		doc.data = data

		let ec: QRCode.ErrorCorrection = {
			if let value = settings["correction"] as? String,
				let first = value.first,
				let ec = QRCode.ErrorCorrection.Create(first) {
				return ec
			}
			return .quantize
		}()
		doc.errorCorrection = ec

		if let design = settings["design"] as? [String: Any],
			let d = QRCode.Design.Create(settings: design) {
			doc.design = d
		}

		doc.regenerate()

		return doc
	}
}

public extension QRCode.Document {

	/// Generate a JSON string representation of the document.
	@objc func jsonData() -> Data? {
		let dict = self.settings()
		return try? JSONSerialization.data(withJSONObject: dict)
	}

	/// Generate a pretty-printed JSON string representation of the document.
	@objc func jsonStringFormatted() -> String? {
		let dict = self.settings()
		if #available(macOS 10.13, *) {
			if let data = try? JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted, .sortedKeys]) {
				return String(data: data, encoding: .utf8)
			}
		} else {
			if let data = try? JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted]) {
				return String(data: data, encoding: .utf8)
			}
		}
		return nil
	}

	/// Create a QRCode document from the provided json formatted data
	@objc static func Create(jsonData: Data) -> QRCode.Document? {
		guard
			let s = try? JSONSerialization.jsonObject(with: jsonData, options: []),
			let settings = s as? [String: Any]
		else {
			return nil
		}
		return QRCode.Document.Create(settings: settings)
	}
}

// MARK: - Update

public extension QRCode.Document {
	/// Build the QR Code using the given data and error correction
	@objc func update(_ data: Data, errorCorrection: QRCode.ErrorCorrection) {
		self.qrcode.update(data, errorCorrection: errorCorrection)
	}

	/// Build the QR Code using the given text and error correction
	@objc func update(text: String, errorCorrection: QRCode.ErrorCorrection = .default) {
		self.qrcode.update(text: text, errorCorrection: errorCorrection)
	}

	/// Build the QR Code using the given message formatter and error correction
	@objc func update(message: QRCodeMessageFormatter, errorCorrection: QRCode.ErrorCorrection = .default) {
		self.qrcode.update(message: message, errorCorrection: errorCorrection)
	}
}

// MARK: - Draw

public extension QRCode.Document {
	/// Draw the current qrcode into the context using the specified style
	@objc func draw(ctx: CGContext, rect: CGRect, design: QRCode.Design) {
		self.qrcode.draw(ctx: ctx, rect: rect, design: design)
	}
}

// MARK: Imaging

public extension QRCode.Document {

	/// Returns a CGImage representation of the qr code using the specified style
	/// - Parameters:
	///   - size: The pixel size of the image to generate
	///   - scale: The scale
	///   - design: The design for the qr code
	/// - Returns: The image, or nil if an error occurred
	@objc func cgImage(
		_ size: CGSize,
		scale: CGFloat = 1,
		design: QRCode.Design = QRCode.Design()
	) -> CGImage? {
		self.qrcode.cgImage(size, scale: scale, design: design)
	}

	/// Returns an pdf representation of the qr code using the specified style
	/// - Parameters:
	///   - size: The page size of the generated PDF
	///   - pdfResolution: The resolution of the pdf output
	///   - design: The design to use when generating the pdf output
	/// - Returns: A data object containing the PDF representation of the QR code
	@objc func pdfData(_ size: CGSize, pdfResolution: CGFloat = 72.0, design: QRCode.Design = QRCode.Design()) -> Data? {
		self.qrcode.pdfData(size, pdfResolution: pdfResolution, design: design)
	}
}