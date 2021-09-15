//
//  MockRequestDispatcher.swift
//
//  Created by Rahmi Bozdağ on 1.02.2021.
//

import Foundation

public final class MockRequestDispatcher: RequestDispatcher {
    public var requestInterceptors: [RequestInterceptor]?
    public var responseInterceptors: [ResponseInterceptor]?
    private let mockContainer: [MockRequest]

    public init(mockContainer: [MockRequest],
                requestInterceptors: [RequestInterceptor]? = nil,
                responseInterceptors: [ResponseInterceptor]? = nil) {
        self.mockContainer = mockContainer
        self.requestInterceptors = requestInterceptors
        self.responseInterceptors = responseInterceptors
    }

    public func dispatch(urlRequest: URLRequest, completion: @escaping NetworkDispatchCompletion) -> URLSessionTask? {
        let task = MockURLSessionTask { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard let mock = self.mockContainer.last(where: { $0 == urlRequest.mock }),
                      let outputFileUrl = mock.outputFileUrl else {
                    completion(DispatchResult(data: nil, response: nil, error: NetworkErrors.cannotFindHost))
                    return
                }
                do {
                    let jsonData = try Data(contentsOf: outputFileUrl)
                    completion(DispatchResult(data: jsonData, response: mock.toUrlResponse, error: nil))
                } catch {
                    completion(DispatchResult(data: nil, response: nil, error: error))
                }
            }
        }
        return task
    }
}

public struct MockRequest: Equatable {
    let path: String
    let method: HTTPMethod
    let expectedHttpStatus: HTTPStatusCode?
    let outputFileUrl: URL?

    var toUrlResponse: URLResponse {
        return HTTPURLResponse(url: outputFileUrl!, statusCode: expectedHttpStatus!.rawValue, httpVersion: nil, headerFields: nil)!
    }

    public static func == (lhs: MockRequest, rhs: MockRequest) -> Bool {
        return lhs.path == rhs.path && lhs.method.rawValue == rhs.method.rawValue
    }
}

private extension URLRequest {
    var mock: MockRequest? {
        guard let path = url?.path else { return nil }
        guard let methodRawValue = httpMethod?.uppercased(), let method = HTTPMethod(rawValue: methodRawValue) else { return nil }
        return MockRequest(path: path, method: method, expectedHttpStatus: nil, outputFileUrl: nil)
    }
}

private class MockURLSessionTask: URLSessionTask {
    private let resumeListener: () -> Void

    init(resumeListener: @escaping () -> Void) {
        self.resumeListener = resumeListener
    }

    override func resume() {
        resumeListener()
    }

    override func cancel() {
        /* not required */
    }
}
