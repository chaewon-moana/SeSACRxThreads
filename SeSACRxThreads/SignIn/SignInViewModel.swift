//
//  SignInViewModel.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import Foundation
import RxSwift
import RxCocoa
/*
 input, output struct를 만들어서 처리를 할 수 있음
 => Input Output Pattern
 */
class SignInViewModel {
    //input
    //이메일 텍스트, 비밀번호 텍스트, 로그인버튼 클릭, 회원가입 클릭
    //struct는 초기화구문을 자동으로 만들어주기때문에 init 할 필요없음!
    struct Input {
        let email: ControlProperty<String?>
        let password: ControlProperty<String?>
        let signInTap: ControlEvent<Void>
        let signUpTap: ControlEvent<Void>
    }
    
    //output
    //이메일 텍스트, 비밀번호 텍스트, 로그인버튼 클릭 여부(조건부족시 isenabled = false), 로그인버튼 클릭, 회원가입 클릭
    struct Output {
        let email: Driver<String>
        let password: Driver<String>
        let signInTap: ControlEvent<Void>
        let signUpTap: ControlEvent<Void>
        let enabled: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        //ControlProperty<String?>로 받아와서 Driver<String>으로 output을 만듦
        let email = input.email
            .orEmpty //옵셔널 해제를 해주어서 string으로 받아오게땀!
            .asDriver()
        let password = input.password
            .orEmpty
            .asDriver() //근데 그럼 여기는 왜 asDriver()가 나오지?
        //8글자, @
        let enabled = input.email
            .orEmpty
            .map { $0.count > 8 && $0.contains("@") }
            .asDriver(onErrorJustReturn: false) //driver는 error를 전달해주지 않는데, 혹시 에러가 발생하면 어떠케함? //근데 그럼 여기는 왜 asDriver()가 안나옴?
        
        return Output(email: email, //Output은 필요한것만 뽑아서 전달해주는 것
                      password: password,
                      signInTap: input.signInTap, //받았던걸 그대로 내뱉는 애들은 이렇게 적어두기도 함
                      signUpTap: input.signUpTap,
                      enabled: enabled)
    }
}
