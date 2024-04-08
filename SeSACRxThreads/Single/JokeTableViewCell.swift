//
//  JokeTableViewCell.swift
//  SeSACRxThreads
//
//  Created by jack on 2024/04/08.
//

import UIKit

class JokeTableViewCell: UITableViewCell {
    
    static let identifier = "JokeTableViewCell"
    
    let jokeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        jokeLabel.numberOfLines = 0
        jokeLabel.textColor = .black
        contentView.addSubview(jokeLabel)
        jokeLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
