//
//  SearchViewModel.swift
//  SeSACRxThreads
//
//  Created by cho on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa

//input output pattern

class SearchViewModel {
    lazy var items = BehaviorSubject(value: data)
    let disposeBag = DisposeBag()
    
    //searchBar.rx.text.orEmpty
    let inputQuery = PublishSubject<String>()
    
    //search.rx.searchButonClicked
    let inputSearchButtonTap = PublishSubject<Void>()
    
    var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
    
    init() {
        inputQuery//실시간 검색으로 하면 항상 콜이 되기 때문에 추천되진 않음. 입력을 다 하고 0.5초 뒤에 콜한다거나 그러면 콜수를 줄일 수 있음,,과제전형에서도 이런식으로 주문요건이 나온것이 있었음
            .debounce(.seconds(1), scheduler: MainScheduler.instance) //debounce라는 operator가 있음, 멈추었을 때 해당시간만큼 멈추고 실행하는 것을 도와줌
            .distinctUntilChanged() //값이 변화했을 때 호출되는 것! -> 같은 값을 여러번 누르면 값 차단시켜서 호출안되게함
            .subscribe(with: self) { owner, value in
                print(value)
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
        
        inputSearchButtonTap
            .withLatestFrom(inputQuery)
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
                owner.items.onNext(result)
            }
            .disposed(by: disposeBag)
    }
}
