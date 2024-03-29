//
//  SignUpViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let validationButton = UIButton()
    let nextButton = PointButton(title: "다음")
    let disposeBag = DisposeBag()
    
    var email = BehaviorSubject(value: "a@a.com")//Observable.just("a@a.com")
    let buttonColor = Observable.just(UIColor.blue)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        configure()
        
        email //이렇게 구현하면,,,,클로저도 사라지고,,깔끔하게 완성할 수 있음
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
    
        
//        buttonColor //이렇게 만들수도 있지만 bind로 연결해주면 좀 더 깔끔하게 정리가능
//            .subscribe(with: self) { owner, value in
//                owner.nextButton.rx.backgroundColor = value
//            }
//            .disposed(by: disposeBag)
        buttonColor
            .bind(to: nextButton.rx.backgroundColor,
                  emailTextField.rx.textColor,
                  emailTextField.rx.tintColor) //borderColor는 cgColor라서 맞지 않는 것임
            .disposed(by: disposeBag)
        
        buttonColor //이렇게 map을 통해서 data stream을 바꾸고 다시 만들어줄 수 있음
            .map { $0.cgColor }
            .bind(to: emailTextField.layer.rx.borderColor)
            .disposed(by: disposeBag)
        
//        email
//            .bind(with: self) { owner, value in
//                owner.emailTextField.text = value
//            }
//            .disposed(by: disposeBag)
//        
        //nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        nextButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.navigationController?.pushViewController(PasswordViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
//        validationButton.rx.tap
//            .subscribe(with: self) { owner, _ in
//            
//            }
//            .disposed(by: disposeBag)
        
        validationButton.rx.tap
            .bind(with: self) { owner, _ in
                // = 로 값 바꾸지 않는다!. 값을 전달하는 모든행위를 next, complete, error 로 전달하게 됨
                //email은 Observable이라서 값을 전달만할 수 있음! 받을 수 없음! 다른 문자열을 받아주세요 하는 것 자체가 말이 안됨.
                //Observable과 Observer의 역할을 동시에 할 수 있는(값을 전달하고 처리할 수 있는) 것의 필요성이 대두됨 -> Subject
                owner.email.onNext("b@b.com")
            }
            .disposed(by: disposeBag)
    }
    
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(PasswordViewController(), animated: true)
    }

    func configure() {
        validationButton.setTitle("중복확인", for: .normal)
        validationButton.setTitleColor(Color.black, for: .normal)
        validationButton.layer.borderWidth = 1
        validationButton.layer.borderColor = Color.black.cgColor
        validationButton.layer.cornerRadius = 10
    }
    
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(validationButton)
        view.addSubview(nextButton)
        
        validationButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(100)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.trailing.equalTo(validationButton.snp.leading).offset(-8)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(emailTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    

}
