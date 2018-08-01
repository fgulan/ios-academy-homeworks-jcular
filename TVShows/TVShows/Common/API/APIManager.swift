//
//  APIManager.swift
//  TVShows
//
//  Created by Jure Cular on 17/07/2018.
//  Copyright © 2018 Jure Čular. All rights reserved.
//

import Foundation
import SVProgressHUD
import Alamofire
import CodableAlamofire
import PromiseKit

class APIManager {

    public static func registerUser(withEmail email: String, password: String) -> Promise<User> {
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]

        return Alamofire
            .request(_registerUserURL,
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
    }

    public static func loginUser(withEmail email: String, password: String) -> Promise<LoginData>{
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]

        return Alamofire
            .request(_loginUserURL,
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
    }

    public static func getShows(withToken token: String) -> Promise<[Show]> {

        let headers = ["Authorization": token]

        return Alamofire
            .request(_showsURL,
                        method: .get,
                        encoding: JSONEncoding.default,
                        headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
    }

    public static func getShowDetails(withToken token: String, showID: String) -> Promise<ShowDetails> {

        let headers = ["Authorization": token]

        return Alamofire
            .request("\(_showsURL)/\(showID)",
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
    }

    public static func getShowEpisodes(withToken token: String, showID: String) -> Promise<[Episode]> {

        let headers = ["Authorization": token]

        return Alamofire
            .request("\(_showsURL)/\(showID)/episodes",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
    }

    public static func getEpisode(withToken token: String, episodeID: String) -> Promise<Episode> {

        let headers = ["Authorization": token]

        return Alamofire
            .request("\(_episodesURL)/\(episodeID)",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
    }

    public static func addEpisode(withToken token: String,
                                  showID: String,
                                  mediaID: String?,
                                  title: String?,
                                  description: String?,
                                  episodeNumber: String?,
                                  season: String?) -> Promise<Episode> {

        let headers = ["Authorization": token]

        let parameters = ["showId": showID,
                      "mediaId": mediaID,
                      "title": title,
                      "description": description,
                      "episodeNumber": episodeNumber,
                      "season": season
        ]

        return Alamofire
            .request(_episodesURL,
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())

    }

    public static func uploadImage(withToken token: String,
                                   image: UIImage) -> Promise<Media> {

        let headers = ["Authorization": token]

        let imageByteData = UIImagePNGRepresentation(image)!

        return Promise<Media> { seal in
            Alamofire
                .upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(imageByteData,
                                             withName: "file",
                                             fileName: "image.png",
                                             mimeType: "image/png")
                }, to: _mediaURL,
                   method: .post,
                   headers: headers) { result in
                        switch result {
                        case .success(let uploadRequest, _, _):
                            _process(uploadRequest: uploadRequest, seal: seal)
                        case .failure(let encodingError):
                            seal.reject(encodingError)
                    }
                }
        }
    }

    private static func _process(uploadRequest: UploadRequest, seal: Resolver<Media>) {
        uploadRequest
            .responseDecodableObject(keyPath: "data") { (response: DataResponse<Media>) in
                switch response.result {
                case .success(let media):
                    seal.fulfill(media)
                case .failure(let error):
                    seal.reject(error)
                }
        }
    }

    public static func getComments(withToken token: String, forEpisodeID episodeID: String) -> Promise<[Comment]> {

        let headers = ["Authorization": token]

        return Alamofire
            .request("\(_episodesURL)/\(episodeID)/comments",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
    }

    public static func postComment(withToken token: String, forEpisodeID episodeID: String, text: String) -> Promise<Comment> {

        let headers = ["Authorization": token]

        let parameters = [
            "text": text,
            "episodeId": episodeID
        ]

        return Alamofire
            .request(_commentsURL,
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder())
    }

}

extension APIManager {

    // MARK: - API URLs -

    private static let _URL = "https://api.infinum.academy"

    private static let _APIURL = "\(_URL)/api"

    private static let _loginUserURL = "\(_APIURL)/users/sessions"
    private static let _registerUserURL = "\(_APIURL)/users"

    private static let _showsURL = "\(_APIURL)/shows"
    private static let _episodesURL = "\(_APIURL)/episodes"

    private static let _mediaURL = "\(_APIURL)/media"
    private static let _commentsURL = "\(_APIURL)/comments"
}

extension APIManager {

    public static func createImageURL(withResource imageResource: String) -> URL {
        return URL(string: "\(_URL)\(imageResource)")!
    }

}
