//
//  BirthdayViewModel.swift
//  SeSACRxThreads
//
//  Created by cho on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa //UIKit 기반이라서 UIKit을 import하는 것이랑 같다고 볼 수 있음


class BirthdayViewModel {
    
    let disposeBag = DisposeBag()
    
    struct Input {
        let birthday: ControlProperty<Date>
    }
    
    //생각보다 Output에 relay나 driver를 많이 쓰게 될 것임! 보통 유저에게 보여주는 것(UI)라 메인 스레드에서 동작하게 될 것임. 그래서 많을 수 밖에,,?
    //백그라운드 로직자체가 없다면은 UI관련 프로퍼티가 많음
    struct Output {
        let year: Driver<String>
        let month: Driver<String>
        let day: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let year = BehaviorRelay(value: 999)
        let month = BehaviorRelay(value: 999)
        let day = BehaviorRelay(value: 999)
        
        input.birthday
            .subscribe(with: self) { owner, date in
                print(date)
                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                year.accept(component.year!)
                month.accept(component.month!)
                day.accept(component.day!)
            }
            .disposed(by: disposeBag)
        
        let resultYear = year
            .map { "\($0)년" }
            .asDriver(onErrorJustReturn: "2024")
        
        let resultMonth = month
            .map { "\($0)월" }
            .asDriver(onErrorJustReturn: "4")
        
        let resultDay = day
            .map { "\($0)일" }
            .asDriver(onErrorJustReturn: "4")
        
        return Output(year: resultYear,
                      month: resultMonth,
                      day: resultDay)
    }
}
//class BirthdayViewModel {
//    
//    struct Input {
//        let birthday: ControlProperty<Date>
//    }
//    
//    struct Output {
//        let year: Driver<String>
//        let month: Driver<String>
//        let day: Driver<String>
//    }
//    
//    func transform(input: Input) -> Output {
//        let year = input.birthday
//
//        
//        return Output(year: year,
//                      month: <#T##Driver<String>#>,
//                      day: <#T##Driver<String>#>)
//    }
//    
//    
//    //input -> datePicker에서 선택할 날짜(date type)
//   // let birthday: BehaviorSubject<Date> = BehaviorSubject(value: .now)
//    //선택한 날짜를 behavior에 넣어주기만 할 뿐 UI가 아님
//    //output -> label (year, month, day)
//    
//    //얘네는 label을 보여주기 위한 용도로 사용하고 있음. UI에 특화가 되어있음
//    let year = PublishRelay<Int>()//BehaviorSubject(value: 2024)//Observable.just(2024)
//    let month = BehaviorRelay(value: 4)//Observable.just(3)
//    let day = PublishRelay<Int>() //비어있는 인스턴스를 생성하는 기능을 담당
//    
////    init() {
////        birthday
////            .subscribe(with: self) { owner, date in
////                print(date)
////                let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
////                //observable
////                owner.year.accept(component.year!)
////                owner.month.accept(component.month!)
////                owner.day.accept(component.day!)
////            }
////            .disposed(by: disposeBag)
////    }
//}
