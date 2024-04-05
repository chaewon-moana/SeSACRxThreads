//
//  PhoneViewModel.swift
//  SeSACRxThreads
//
//  Created by cho on 4/3/24.
//

import Foundation
import RxSwift
import RxCocoa


//Observable, Observer
//Subject //bind, subscribe
//Relay(accept) //drive 요런식으로 많이 사용함

final class PhoneViewModel {
    
    //어차피 next 이벤트만 처리할거면 relay로 쓰면 됨
   // let validText = BehaviorSubject(value: "연락처는 8자 이상")
    let validText = BehaviorRelay(value: "연락처는 8자 이상") //relay를 쓰려면 rxcocoa가 필요함! relay는 UI친화적이라 rxcocoa가 필요한것임,,,,
    
    
    
    
    
}
