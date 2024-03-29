//
//  BirthdayViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2023/10/30.
//
 
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BirthdayViewController: UIViewController {
    
    let birthDayPicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        picker.maximumDate = Date()
        return picker
    }()
    
    let infoLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.text = "만 17세 이상만 가입 가능합니다."
        return label
    }()
    
    let containerStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.spacing = 10 
        return stack
    }()
    
    let yearLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }() //2024년
    
    let monthLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }() //3월
    
    let dayLabel: UILabel = {
       let label = UILabel()
        label.textColor = Color.black
        label.snp.makeConstraints {
            $0.width.equalTo(100)
        }
        return label
    }() //29일
  
    let nextButton = PointButton(title: "가입하기")
    
    let year = PublishSubject<Int>()//BehaviorSubject(value: 2024)//Observable.just(2024)
    let month = PublishSubject<Int>()//Observable.just(3)
    let day = PublishSubject<Int>() //비어있는 인스턴스를 생성하는 기능을 담당
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.white
        bind()
        test2()
        configureLayout()
        
        nextButton.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
    }
    func test() {
        let publish = PublishSubject<Int>()
        
        publish.onNext(1)
        publish.onNext(2)
        publish.subscribe { value in
            print("publish - \(value)")
        } onError: { error in
            print("publish onError")
        } onCompleted: {
            print("publish onCompleted")
        } onDisposed: {
            print("publish onDisposed")
        }
        .disposed(by: disposeBag)
        
        publish.onNext(3)
        publish.onNext(4)
        
        publish.onCompleted()
        
        publish.onNext(5)
        publish.onNext(6)
    }
    
    func test2() {//구독전에는 이벤트 못 받음. 초기값 있음
        let publish = BehaviorSubject(value: 100)
        
        publish.onNext(1)
        publish.onNext(2)
        publish.subscribe { value in
            print("publish - \(value)")
        } onError: { error in
            print("publish onError")
        } onCompleted: {
            print("publish onCompleted")
        } onDisposed: {
            print("publish onDisposed")
        }
        .disposed(by: disposeBag)
        
        publish.onNext(3)
        publish.onNext(4)
        
        publish.onCompleted()
        
        publish.onNext(5)
        publish.onNext(6)
    }
    
    func bind() {
        //yearLabel은 옵저버블이라 전달만하고 있었는데, 데이트피커로 값을 전달받아서 옵저버가 되기도 함!그래서 등호가 아니라 next 이벤트로 전달을 해야함
          //그럼 옵저버블은 datepicker가 됨
        //근데 datepicker를 먼저 올려놓으면 label에 아무것도 안나오게 됨
          birthDayPicker.rx.date//datepicker는 항상 값을 가지고 있음. 그래서 publish로 바꾸어도 값이 나오게 되는 것. 만약 이 코드를 주석처리하면 아무것도 안나옴
              .bind(with: self) { owner, date in
                  print(date)
                  let component = Calendar.current.dateComponents([.year, .month, .day], from: date)
                  //observable
                  owner.year.onNext(component.year!)
                  owner.month.on(.next(component.month!))
                  owner.day.onNext(component.day!)

              }
              .disposed(by: disposeBag)
        year
            .observe(on: MainScheduler.instance)//UI를 변경하는 거기 떄문에 무조건 메인스레드에서 동작할 수 있도록 만들어야함
            .subscribe(with: self) { owner, value in
                owner.yearLabel.text = "\(value)년"
            }
            .disposed(by: disposeBag)
        
        month
            .map { "\($0)월" } //얘는 UI를 핸들링하고 있는건 아니기에, 먼저 와도 됨!
        //나중에 많은 Stream이 붙도록 한다면, 순서가 중요해짐. 시간의 흐름에 따라 변경이 되는거라,,,
            .observe(on: MainScheduler.instance)//UI를 변경하는 거기 떄문에 무조건 메인스레드에서 동작할 수 있도록 만들어야함
            .subscribe(with: self) { owner, value in
                owner.monthLabel.text = value
            }
            .disposed(by: disposeBag)
        
        day
            .map { "\($0)일" }
            .bind(to: dayLabel.rx.text) //bind는 어차피 UI관련 그리고 메인스레드에서 동작하기에 observe나 이런게 필요없어짐
            .disposed(by: disposeBag)
        


    }
    
    @objc func nextButtonClicked() {
        print("가입완료")
    }

    
    func configureLayout() {
        view.addSubview(infoLabel)
        view.addSubview(containerStackView)
        view.addSubview(birthDayPicker)
        view.addSubview(nextButton)
 
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
   
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

}
