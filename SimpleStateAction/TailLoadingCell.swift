//
//  TailLoadingCell.swift
//  SimpleStateAction
//
//  Created by Yuske Fukuyama on 2018/12/21.
//  Copyright © 2018 Yuske Fukuyama. All rights reserved.
//

import UIKit

final class TailLoadingCell: UITableViewCell {
  
  let spinner = UIActivityIndicatorView(style: .gray)
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    contentView.addSubview(spinner)
    spinner.translatesAutoresizingMaskIntoConstraints = false
    spinner.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    spinner.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    spinner.startAnimating()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
