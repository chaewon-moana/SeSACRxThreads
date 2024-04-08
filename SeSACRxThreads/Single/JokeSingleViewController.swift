//
//  JokeSingleViewController.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/08.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class JokeSingleViewController: UIViewController {
    
    let addJokeButton: UIButton = {
       let button = UIButton()
        button.setTitle("농담 추가하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 22
        button.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        return button
    }()
    
    let tableView: UITableView = {
       let tv = UITableView()
        tv.register(JokeTableViewCell.self, forCellReuseIdentifier: JokeTableViewCell.identifier)
        return tv
    }()
    
    let bag = DisposeBag()
    
    let jokeCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        return label
    }()
    
    var jokes: [Joke] = []
    lazy var jokesSubject = BehaviorSubject<[Joke]>(value: jokes)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        bindRx()
    }
    
    func bindRx() {

    } 
    
    func configure() {
        view.backgroundColor = .white
        
        view.addSubview(jokeCountLabel)
        jokeCountLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(jokeCountLabel.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview()
        }
        
        view.addSubview(addJokeButton)
        addJokeButton.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(30)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
