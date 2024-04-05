//
//  BoxOfficeViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import Foundation
import RxSwift
import RxCocoa

class BoxOfficeViewModel {
     
    let disposeBag = DisposeBag()
    //컬렉션뷰
    //var recent = Observable.just(["테스트", "테스트1", "테스트2"])
    var recent = ["테스트", "테스트1", "테스트2"]
    //테이블뷰
    let movie = Observable.just(["테스트10", "테스트11", "테스트12"])
    
    //셀 클릭 이벤트(+텍스트)를 뷰모델에 넘기기 vs 글자를 넘길 수 있음 -> 취향껏
    struct Input {
        let searchButtonTap: ControlEvent<Void>//서치 검색 버튼 클릭
        let searchText: ControlProperty<String>//서치 검색어
        let recentText: PublishSubject<String> //셀 선택 시 글자
    }
    
    struct Output {
        let recent: BehaviorRelay<[String]>
        let movie: PublishSubject<[DailyBoxOfficeList]>
    }
    
    
    func transform(input: Input) -> Output {
        let recentList = BehaviorRelay(value: recent)
        let boxOfficeList = PublishSubject<[DailyBoxOfficeList]>()
        //검색버튼클릭 > 쿼리 > API 호출 > 디코딩 결과 > 아웃풋
        input.searchButtonTap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText) //map이나 withLatestFrom을 쓸 수 있음
            .debug()
            .map {
                guard let intText = Int($0) else { return 20240101 }
                return intText
            }
            .map { return String($0) }
            .flatMap { //map vs flatMap
                BoxOfficeNetwork.fetchBoxOfficeData(date: $0) //여기서도 구독을 하고 있음
            }
            .subscribe(with: self, onNext: { owner, value in
                let data = value.boxOfficeResult.dailyBoxOfficeList
                boxOfficeList.onNext(data)
            }, onError: { _, _ in
                print("transform error")
            }, onCompleted: { _ in
                print("transform completed")
            }, onDisposed: { _ in
                print("transform disposed")
            })
            .disposed(by: disposeBag)
        
        input.recentText
            .subscribe(with: self) { owner, value in
                owner.recent.append(value)
                recentList.accept(owner.recent)
            }
            .disposed(by: disposeBag)
        
        return Output(recent: recentList, 
                      movie: boxOfficeList)
    }
}




