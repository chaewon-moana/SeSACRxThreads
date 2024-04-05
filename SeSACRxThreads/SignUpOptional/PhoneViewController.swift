//
//  PhoneViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PhoneViewController: UIViewController {
   
    let phoneTextField = SignTextField(placeholderText: "연락처를 입력해주세요")
    let nextButton = PointButton(title: "다음")
    let viewModel = PhoneViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        
        configureLayout()
        bind()
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    func bind() {
        //
        viewModel.validText
            .bind(to: nextButton.rx.title())
            .disposed(by: disposeBag)
        
        //만약 validText가 nil, 버튼 title은 무조건 string - 그럼 문제가 생길 수 있음
        //굳이 예시를 들어보자
        //버튼은 무조건 string 타입이어야함. 그래서 nil이면 안된다고 가정을 해보자!
        //그럼 전달하는 이벤트도 nil을 전달해서는 안됨
        //근데 코드를 짜다보면 nil을 전달하게 될 상황이 나올수도 있는데, 버튼은 nil을 못받고, error도 못받음
        //asDriver로 error 전달하는게 있음
        viewModel.validText
            .asDriver(onErrorJustReturn: "") //앞에 as가붙어잇으면 기존 타입을 drive 타입으로 바꾸는 것을 의미함,
            .drive(nextButton.rx.title())
            .disposed(by: disposeBag)

        let validation = phoneTextField
            .rx
            .text
            .orEmpty
            .map { $0.count >= 8 }
        validation
            .bind(to: nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    @objc func nextButtonClicked() {
        navigationController?.pushViewController(NicknameViewController(), animated: true)
    }
    func configureLayout() {
        view.addSubview(phoneTextField)
        view.addSubview(nextButton)
         
        phoneTextField.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(phoneTextField.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
