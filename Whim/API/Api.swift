//
//  Api.swift
//  Whim
//
//  Created by Gica Gugui on 11/01/2020.
//  Copyright © 2020 Gica Gugui. All rights reserved.
//

import Alamofire
import RxSwift

public class Api: ApiProtocol {
    public var manager: SessionManager!
    
    private func executeBaseRequest<T>(
        url: URL,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?) -> Observable<T> where T: Codable {
        
        return Observable.create({ (observer) -> Disposable in
            let urlRequest = ApiHelper.getRequest(url, method: method, headers: headers, body: body)
            
            let request = self.manager
                .request(urlRequest)
                .validate()
                .response { aResponse in
                    if let error = aResponse.error {
                        observer.onError(ApiError(error: error, data: aResponse.data))
                    } else {
                        do { // decode json data without fragments
                            let decoder = JSONDecoder()
                            decoder.dateDecodingStrategy = .formatted(Date.sharedGeneralDateFormatter())
                            let value: T = try decoder.decode(T.self, from: aResponse.data!.forDecoding())

                            observer.onNext(value)
                            observer.onCompleted()
                        } catch {
                            do { // decode json data with fragments
                                if let value = String(data: aResponse.data!, encoding: .utf8) as? T {
                                    observer.onNext(value)
                                    observer.onCompleted()
                                }
                                
                                observer.onError(error)
                            }
                        }
                    }
                }
            
            return Disposables.create() {
                request.cancel()
                print("Finished request: \(request)")
            }
        })
        .observeOn(InfraHelper.backgroundWorkScheduler)
    }

    public func executeRequest<T>(
        url: URL,
        method: HTTPMethod,
        headers: [String: String]?,
        body: Data?) -> Observable<T> where T: Codable {
        
        return executeBaseRequest(url: url, method: method, headers: headers, body: body)
    }
        
    public func cancelAllRequests() {
        manager.session.getAllTasks { (tasks) -> Void in
            tasks.forEach({ $0.cancel() })
        }
    }
}
