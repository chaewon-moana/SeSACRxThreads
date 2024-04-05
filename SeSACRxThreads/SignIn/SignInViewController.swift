//
//  SignInViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {

    let emailTextField = SignTextField(placeholderText: "이메일을 입력해주세요")
    let passwordTextField = SignTextField(placeholderText: "비밀번호를 입력해주세요")
    let signInButton = PointButton(title: "로그인")
    let signUpButton = UIButton()
    
    let viewModel = SignInViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.white
        configureLayout()
        configure()
        bind()
       // signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
    }
    
    func bind() {
//        let email = emailTextField.rx.text //orEmpty는 비즈니스 로직으로 가져가는게 맞을지, VC에서 처리하는게 맞을지 판단하고 기준을 세워야함
//        let password = passwordTextField.rx.text
//        let signInTap = signInButton.rx.tap
//        let signUpTap = signUpButton.rx.tap
        
        //Input을 struct으로 구성을 해서 초기화구문이 자동으로 완성됨!
        let input = SignInViewModel.Input(
            email: emailTextField.rx.text,
            password: passwordTextField.rx.text,
            signInTap: signInButton.rx.tap,
            signUpTap: signUpButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.email
            .drive(emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.password
            .drive(passwordTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.signInTap
            .bind(with: self) { owner, _ in
                print("화면전환 - Sign IN")
            }
            .disposed(by: disposeBag)
        
        output.signUpTap
            .bind(with: self) { owner, _ in
                owner.navigationController?.pushViewController(SignUpViewController(), animated: true)
            }
            .disposed(by: disposeBag)
        
        output.enabled
            .drive(signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
//    @objc func signUpButtonClicked() {
//        navigationController?.pushViewController(SignUpViewController(), animated: true)
//    }
    func configure() {
        signUpButton.setTitle("회원이 아니십니까?", for: .normal)
        signUpButton.setTitleColor(Color.black, for: .normal)
    }
    func configureLayout() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        
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
        
        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(signInButton.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
