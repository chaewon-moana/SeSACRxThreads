//
//  SearchViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/01.
//

import UIKit
import RxSwift
import RxCocoa
/*
 searchBar에서 입력한 글자가 Observable이 되고, data 배열에서 해당 글자를 찾고, 그 결과를 tableView에 보여줌
 */

class SearchViewController: UIViewController {
    let viewModel = SearchViewModel()
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(SearchTableViewCell.self, forCellReuseIdentifier: SearchTableViewCell.identifier)
        view.backgroundColor = .white
        view.rowHeight = 180
        view.separatorStyle = .none
       return view
     }()
    let searchBar = UISearchBar()
//    var data = ["A", "B", "C", "AB", "D", "ABC", "BBB", "EC", "SA", "AAAB", "ED", "F", "G", "H"]
    let disposeBag = DisposeBag()
    //let items = Observable.just(["1", "2", "3"]) //observable은 데이터를 전달만 할 수 있음
//    lazy var items = BehaviorSubject(value: data)//behavior는 초기값을 가지고 있음, observable과 observer 둘 다의 기능을 가지고 있음
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configure()
        setSearchController()
        bind()
          
    }
    
    private func bind() {
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: SearchTableViewCell.identifier, cellType: SearchTableViewCell.self)) { (row, element, cell) in
                cell.appNameLabel.text = "테스트 \(element)"
                cell.appIconImageView.backgroundColor = .systemBlue
                //cell.tap() //이렇게 함수를 호출하는 느낌으로 cell쪽으로 넘길 수 있음
                //각 cell이 재사용을 하기 때문에 구독이 중첩해서 쌓이고 있음. 재사용이슈임!
                //인스턴스를 계속 초기화 해줘야함.
                //cell 파일에 prepareFoeReuse에 dispose를 새로 초기화해줘야함!
                cell.downloadButton.rx.tap
                    .bind(with: self) { owner, _ in
                        owner.navigationController?.pushViewController(BirthdayViewController(), animated: true)
                        print("버튼 탭 됨요")
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
//        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self)) //itemselected, modelselected 둘 다 실행될거면 빠르게 하나로 실행하자! -> 데이터를 결합할 수 있음, 그래서 2개를 결합해서 1번만 실행할 수 있도로 ㄱ만들기 -> zip이랑 비슷한게 combindLastest
//            .bind(with: self) { owner, value in
//                print(value.0, value.1)
//                owner.data.remove(at: value.0.row)
//                owner.items.onNext(owner.data)
//            }
//            .disposed(by: disposeBag)
        
        //서비차 텍스트가 포함된 결과를 테이블뷰에 보여주기
        //서비차 텍스트로 네트워크 통신을 한다면?
        //사용자가 검색하면 1초뒤에 네트워크 통신을 진행합니다.
        
//        searchBar.rx.text.orEmpty //실시간 검색으로 하면 항상 콜이 되기 때문에 추천되진 않음. 입력을 다 하고 0.5초 뒤에 콜한다거나 그러면 콜수를 줄일 수 있음,,과제전형에서도 이런식으로 주문요건이 나온것이 있었음
//            .debounce(.seconds(1), scheduler: MainScheduler.instance) //debounce라는 operator가 있음, 멈추었을 때 해당시간만큼 멈추고 실행하는 것을 도와줌
//            .distinctUntilChanged() //값이 변화했을 때 호출되는 것! -> 같은 값을 여러번 누르면 값 차단시켜서 호출안되게함
//            .subscribe(with: self) { owner, value in
//                print(value)
//                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
//                owner.items.onNext(result)
//            }
//            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .bind(to: viewModel.inputQuery)
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .bind(to: viewModel.inputSearchButtonTap)
            .disposed(by: disposeBag)
        
        //검색버튼 클릭 + 서치바 텍스트
//        searchBar.rx //delegate를 쓸 필요가 없어짐!, 당연하게 안써도 될 상황에서 쓴다면은 마이너스가 될 수 있음
//            .searchButtonClicked
//            .withLatestFrom(searchBar.rx.text.orEmpty)//버튼을 클릭했을 떄, 가장 마지막요소를 꺼내줌 -> Void였던게 String으로 바뀜. stream의 값에 변화를 주었음
//            .distinctUntilChanged()
//            .subscribe(with: self) { owner, value in
//                let result = value.isEmpty ? owner.data : owner.data.filter { $0.contains(value) }
//                owner.items.onNext(result)
//            }
//            .disposed(by: disposeBag)

      
        
//        tableView.rx.itemSelected //itemSelected는 indexPath를 알려줌 - didselectedRowAt의 역할
//            .bind(with: self) { owner, indexPath in
//                owner.data.remove(at: indexPath.row)
//                owner.items.onNext(owner.data)
//            }
//            .disposed(by: disposeBag)
//        
//        tableView.rx.modelSelected(String.self)
//            .withUnretained(self) //순환참조를 여기서 해결하는 너낌, 나눠서 해결할래? 같이 해결할래? 임 -> 2개의 코드는 결론적으로는 동일함 - didselectedRowAt의 역할
//            .bind { (owner, model) in
//                print(model)
//            }
//            .disposed(by: disposeBag)
    }
     
    private func setSearchController() {
        view.addSubview(searchBar)
        navigationItem.titleView = searchBar
      //  navigationItem.rightBarButtonItem = UIBarButtonItem(title: "추가", style: .plain, target: self, action: #selector(plusButtonClicked))
    }
    
    @objc func plusButtonClicked() {
//        let sample = ["A", "B", "C", "D", "E"]
//        data.append(sample.randomElement()!)
//        items.onNext(data) //이렇게하면 기존의 1,2,3이 없어지고 sample로 대체가 됨, next 이벤트를 받은대로 보여주기 때문에 abc가보이는것
       
        
//        data.append(sample.randomElement()!)
    }

    
    private func configure() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

    }
}
