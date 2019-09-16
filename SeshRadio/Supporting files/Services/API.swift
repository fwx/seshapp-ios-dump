//
//  API.swift
//  SeshRadio
//
//  Created by spooky on 12/15/18.
//  Copyright © 2018 lesovoy. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

class API {
    static let shared = API()
    
    private var sessionManager: Alamofire.SessionManager!
    func sessionManger() -> Alamofire.SessionManager! {
        return self.sessionManager
    }
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    static let kParseError = NSError(domain: "io.lesovoy.SeshRadio", code: 500, userInfo: [:])
    
    
    func configureSession() {
        self.sessionManager = nil
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 100
        configuration.timeoutIntervalForResource = 100
        
        configuration.httpAdditionalHeaders = [:]
        configuration.httpAdditionalHeaders?["User-Agent"] = Globals.kUserAgent
        
        self.sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    init() {
        self.configureSession()
    }
    
    func request(method: Methods, params: [String: Any]? = nil, httpMethod: HTTPMethod = .get) -> Single<(Data, HTTPURLResponse)> {
        var params = params

        var methodWithParams = ""
        
        if httpMethod == .post {
            methodWithParams = method.rawValue
        } else {
            methodWithParams = String(format: "%@?%@",
                                      method.rawValue,
                                      params?.asStringParams ?? "") 
        }
        
        let url = String(format: Globals.API.kApiUrl, methodWithParams)
        
        print("[URL] \(url) \(String(describing: methodWithParams))")
        
        return self
            .sessionManger()
            .rx
            .request(httpMethod, url,
                     parameters: httpMethod == .post ? params : nil,
                     encoding: JSONEncoding.default,
                     headers: nil)
            .validate(statusCode: 200..<500)
            .responseString(encoding: .utf8)
            .asSingle()
            .flatMap({ (response, input) -> Single<(Data, HTTPURLResponse)> in
                if response.statusCode == 422 || response.statusCode == 500 {
                    throw API.Errors.kCommonError
                } else {
                    guard let data = input.data(using: .utf8) else {
                        throw API.kParseError
                    }
                    return Single.just((data, response))
                }
            })
            .do(onSuccess: nil, afterSuccess: nil, onError: { (error) in
                LogBuilder()
                    .setMessage("api_general [\(method.rawValue)]")
                    .appendParams(key: "description", value: "failed to perform API request")
                    .appendParams(key: "error", value: error.localizedDescription)
                    .appendParams(key: "params", value: url)
                    .appendParams(key: "post_params", value: params ?? [:])

            })
    }
    
    func map<T: Decodable>(_ data: Data, path: String? = nil) throws -> T {
        do {
            let model = try self.decoder.decode(T.self, from: data, keyPath: path)
            return model
        } catch {
            print(error)
            LogBuilder()
                .setMessage("api_parsing")
                .appendParams(key: "description", value: "failed to serialize JSON")
                .appendParams(key: "error", value: error.localizedDescription)
                .send(with: .error)
        }
        
        throw API.kParseError
    }
    
    // if data is nil => error
    func download(_ url: String) throws -> Observable<(Data?, RxProgress)> {
        guard let url = URL(string: url) else {
            throw API.kParseError
        }
        
       return self
            .sessionManager
            .rx
            .request(.get, url)
            .flatMap({ (request) -> Observable<(Data?, RxProgress)> in
                let dataPart = request.rx
                    .data()
                    .map { d -> Data? in d }
                    .startWith(nil as Data?)
                let progressPart = request.rx.progress()
                return Observable.combineLatest(dataPart, progressPart) { ($0, $1) }
            })
        
        
    }
}


extension API {
    struct Errors {
        static let kCommonError = NSError(domain: "seshapp", code: 1, userInfo: nil)
        static let kParseError = NSError(domain: "seshapp", code: 2, userInfo: nil)
    }
    
    
    
    enum Methods: String {
        case news = "news"
        
        case stations = "stations"
        case stationsHistory = "stations/history"
        
        case members = "members"
        case membersDetailed = "members/detailed/"
        
        case albums = "albums"
        case albumsDetailed = "albums/detailed/"
        
        case playlists = "playlists"
        case playlistsDetailed = "playlists/detailed/"
        
        case tracks = "songs"
        case tours
        
        case search
        case push = "users/register"
    }
    
    enum SortKey: String {
        case asc
        case desc
    }
    
}
