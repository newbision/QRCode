import XCTest
@testable import QRCode

final class QRCodeTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(QRCodeView().text, "Hello, World!")

		 let q = QRCode.Message.Mail(mailTo: "poodlebox@pobox.eu",
											  subject: "This is a test!",
											  body: "Groovy and wonderful bits")

    }
}