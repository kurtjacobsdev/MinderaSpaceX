//
//  CompanyInfoCell.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import UIKit

class CompanyInfoCell: UITableViewCell {
    private var titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        layoutUI()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
    }
    
    private func layoutUI() {
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(15)
        }
    }
    
    private func configureUI() {
        titleLabel.numberOfLines = 0
    }
    
    func configure(viewModel: CompanyInfoViewModel) {
        titleLabel.text = viewModel.title
    }
}
