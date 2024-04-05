//
//  ShareViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/05.
//

import UIKit
import RxCocoa
import RxSwift

class ShareViewController: UIViewController {
    
    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let nicknameTextField = SignTextField(placeholderText: "닉네임을 입력해주세요")
    let signInButton = PointButton(title: "버튼")
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        //bindTest()
        driveTest()
    }
    
    //drive와 bind의 차이는 스트림이 공유됨! drive에는 share메서드가 내장되어있음
    //bind(메인스레드에서 무조건 동작하진 않음)
    //drive는 무조건 메인스레드에서 동작.
    /*
     Binder라는 친구를 받았을 때, 메인 스레드에서 동작함 - 대체적으로는 메인스레드
     */
    func driveTest() {
        let tap = signInButton.rx.tap
            .map { "안녕 \(Int.random(in: 1...100))" }
            .asDriver(onErrorJustReturn: "")
        tap
            .drive(emailTextField.rx.text, passwordTextField.rx.text, nicknameTextField.rx.text)
            .disposed(by: disposeBag)
//        tap
//            .drive(passwordTextField.rx.text)
//            .disposed(by: disposeBag)
//        tap
//            .drive(nicknameTextField.rx.text)
//            .disposed(by: disposeBag)
    }
    
    func bindTest() {
        //상수로 묶어도 각자 반응하고 있음, 각자 랜덤의 Int가 다른값이 나옴. bind에서는 독립적으로(개별적으로)보고 있음
        //구독이 3번 하고 있으므로, 이벤트가 3번 일어남
        //만약 네트워크 통신을 한다고 생각하면 통신이 3번되고 있는 것임
        //share()를 이용해서 같은 스트림을 공유하도록 만듦 -> 잘 이용하면 효율적으로 만들 수 있음
        let tap = signInButton.rx.tap
            .map { "안녕 \(Int.random(in: 1...100))" }
            .share()
        tap
            .bind(to: emailTextField.rx.text, passwordTextField.rx.text, nicknameTextField.rx.text)
            .disposed(by: disposeBag)
        
//        tap
//            .bind(to: emailTextField.rx.text)
//            .disposed(by: disposeBag)
//        
//        tap
//            .bind(to: passwordTextField.rx.text)
//            .disposed(by: disposeBag)
//        
//        tap
//            .bind(to: nicknameTextField.rx.text)
//            .disposed(by: disposeBag)
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nicknameTextField)
        view.addSubview(signInButton)
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
