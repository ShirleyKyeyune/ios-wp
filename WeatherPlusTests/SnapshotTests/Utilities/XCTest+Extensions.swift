//
//  XCTest+Extensions.swift
//  WeatherPlusTests
//
//  Created by Shirley Kyeyune on 23/08/2022.
//

import SnapshotTesting
import XCTest

extension XCTest {
    /// Use this function to record a new reference on a global level
    ///
    /// - Parameters:
    /// - value: Whether or not to record a new reference for all assertions
    func recordSnapshots(_ value: Bool = true) {
        isRecording = value
    }

    /// Asserts that a given value matches a reference on disk.
    /// Snapshots have been configured to run on an iPhoneX in portrait
    ///
    /// - Parameters:
    ///   - value: A value to compare against a reference.
    ///   - name: An optional description of the snapshot.
    ///   - recording: Whether or not to record a new reference.
    ///   - timeout: The amount of time a snapshot must be generated in.
    ///   - file: The file in which failure occurred. Defaults to the file name of the test case in
    ///   which this function was called.
    ///   - testName: The name of the test in which failure occurred. Defaults to the function name
    ///   of the test case in which this function was called.
    ///   - line: The line number on which failure occurred. Defaults to the line number on which
    ///   this function was called.
    func assertValidSnapshot<Value: UIViewController>(
        matching value: @autoclosure () throws -> Value,
        named name: String? = nil,
        record recording: Bool = false,
        timeout: TimeInterval = 5,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        diffTool = "ksdiff"
        let failure = verifySnapshot(
            matching: try value(),
            as: .image(on: .iPhoneX(.portrait)),
            named: name,
            record: recording,
            timeout: timeout,
            file: file,
            testName: testName,
            line: line
        )
        guard let message = failure else { return }
        XCTFail(message, file: file, line: line)
    }

    func assertValidSnapshot<Value: UIView>(
        matching value: @autoclosure () throws -> Value,
        as snapshotting: Snapshotting<UIView, UIImage> = .image,
        named name: String? = nil,
        record recording: Bool = false,
        timeout: TimeInterval = 5,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        diffTool = "ksdiff"
        let failure = verifySnapshot(
            matching: try value(),
            as: snapshotting,
            named: name,
            record: recording,
            timeout: timeout,
            file: file,
            testName: testName,
            line: line
        )
        guard let message = failure else { return }
        XCTFail(message, file: file, line: line)
    }
}
