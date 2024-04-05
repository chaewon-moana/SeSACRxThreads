//
//  Network.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa

enum APIError: Error {
    case invalidURL
    case unknownResponse
    case statusError
}

class BoxOfficeNetwork {
//    static func sample() {
//        //이 과정을 생략하고 쓰는게 Operator임!
//        let sampleInt = Observable<Int>.create { observer in
//            observer.onNext(Int.random(in: 1...100))
//            return Disposables.create()
//        }
//        
//        sampleInt
//            .subscribe { value in
//                print(value)
//            } onError: { _ in
//                print("Error")
//            } onCompleted: {
//                print("Completed")
//            } onDisposed: {
//                print("Disposed")
//            }
//            .disposed(by: DisposeBag())
//    }
    
    static func fetchBoxOfficeData(date: String) -> Observable<Movie> {
        
        return Observable<Movie>.create { observer in //Observable<Movie>를 커스텀하게 만들게~
            guard let url = URL(string: "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=f5eef3421c602c6cb7ea224104795888&targetDt=\(date)") else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                print("DataTask Succeed")
                
                if let _ = error {
                    observer.onError(APIError.unknownResponse)
                    print("Error")
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    observer.onError(APIError.statusError)
                    print("Response Error")
                    return
                }
                
                if let data = data,
                   let appData = try? JSONDecoder().decode(Movie.self, from: data) {
                    observer.onNext(appData)
                    observer.onCompleted() //transform은 살아있지만 얘는 정리를 해주는 게 좋음
                    //요걸 onNext와 completed를 같이 해놓은게 Single()
                    //print(appData)
                } else {
                    print("응답은 왔으나 디코딩 실패")
                    observer.onError(APIError.unknownResponse)
                }
            }.resume()
            
            return Disposables.create()
        }.debug()
    }
}
