//
//  UserInfoView.swift
//  DigitsGamble
//
//  Created by Mia on 04/01/2018.
//  Copyright © 2018 Mia. All rights reserved.
//

import UIKit
import SnapKit
import HexColors
import RxSwift
import RxCocoa

class UserInfoView: UIView {

    var userLabel: UILabel = UILabel()
    var nameLabel: UILabel = UILabel()
    var moneyLabel: UILabel = UILabel()
    var moneyValueLabel: UILabel = UILabel()
    var digitsLabel: UILabel = UILabel()
    var digitsOwnedLabel: UILabel = UILabel()
    var offerLabel: UILabel = UILabel()
    var currentOfferLabel: UILabel = UILabel()
    
    let bag = DisposeBag()
    
    var isActivated: Bool = false {
        didSet {
            backgroundColor = isActivated ? HexColor("7DA8EF") : UIColor.lightGray
        }
    }
    
    var user: User? {
        didSet {
            
            nameLabel.text = user?.name
            
            user?.offer
                .asObservable()
                .filter({ (offer) -> Bool in
                    switch offer {
                    case .pass:
                        return false
                    default:
                        return true
                    }
                })
                .map{$0.description}
                .bind(to: currentOfferLabel.rx.text)
                .addDisposableTo(bag)
            
            user?.ownedDigits
                .asObservable()
                .map({ (arr) -> String in
                    arr.description
                })
                .bind(to: digitsOwnedLabel.rx.text)
                .addDisposableTo(bag)
            
            user?.availableFund
                .asObservable()
                .map { String($0) }
                .bind(to: moneyValueLabel.rx.text)
                .addDisposableTo(bag)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubviews()
    }
    
    func addSubviews() {
        userLabel.text = "User"
        nameLabel.text = user?.name
        moneyLabel.text = "Money:"
        moneyValueLabel.text = String(1000)
        digitsLabel.text = "Digits:"
        digitsOwnedLabel.text = user?.ownedDigits.value.description
        offerLabel.text = "Current Offer:"
        
        addSubview(userLabel)
        addSubview(nameLabel)
        addSubview(moneyLabel)
        addSubview(moneyValueLabel)
        addSubview(digitsLabel)
        addSubview(digitsOwnedLabel)
        addSubview(offerLabel)
        addSubview(currentOfferLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(userLabel.snp.centerY)
            make.leading.equalTo(userLabel.snp.trailing).offset(8)
        }
        
        moneyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(userLabel.snp.bottom).offset(8)
            make.leading.equalTo(userLabel)
        }
        
        moneyValueLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(moneyLabel.snp.centerY)
            make.leading.equalTo(moneyLabel.snp.trailing).offset(8)
        }
        
        digitsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(moneyLabel.snp.bottom).offset(8)
            make.leading.equalTo(moneyLabel)
        }
        
        digitsOwnedLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(digitsLabel.snp.centerY)
            make.leading.equalTo(digitsLabel.snp.trailing).offset(8)
        }
        
        offerLabel.snp.makeConstraints { (make) in
            make.top.equalTo(digitsLabel.snp.bottom).offset(8)
            make.leading.equalTo(digitsLabel)
        }
        
        currentOfferLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(offerLabel.snp.centerY)
            make.leading.equalTo(offerLabel.snp.trailing).offset(8)
        }
    }

}
