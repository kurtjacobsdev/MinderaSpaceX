//
//  LaunchCell.swift
//  MinderaSpaceX
//
//  Created by Kurt Jacobs
//

import UIKit
import Kingfisher

class LaunchCell: UITableViewCell {
    private var missionPatchImageView = UIImageView()
    private var missionLabel = UILabel()
    private var dateTimeLabel = UILabel()
    private var rocketLabel = UILabel()
    private var daysLabel = UILabel()
    private var launchStatusImageView = UIImageView()
    private var textStack = UIStackView()
    private var mainStack = UIStackView()
    
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
        textStack.addArrangedSubview(missionLabel)
        textStack.addArrangedSubview(dateTimeLabel)
        textStack.addArrangedSubview(rocketLabel)
        textStack.addArrangedSubview(daysLabel)
        
        mainStack.addArrangedSubview(missionPatchImageView)
        mainStack.addArrangedSubview(textStack)
        mainStack.addArrangedSubview(launchStatusImageView)
        
        contentView.addSubview(mainStack)
    }
    
    private func layoutUI() {
        missionPatchImageView.snp.makeConstraints {
            $0.height.width.equalTo(50)
        }
        
        launchStatusImageView.snp.makeConstraints {
            $0.height.width.equalTo(50)
        }
        
        mainStack.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    private func configureUI() {
        textStack.axis = .vertical
        textStack.alignment = .fill
        textStack.distribution = .fill
        
        mainStack.axis = .horizontal
        mainStack.alignment = .top
        mainStack.distribution = .fill
        mainStack.spacing = 10
        
        missionLabel.numberOfLines = 0
        rocketLabel.numberOfLines = 0
        dateTimeLabel.numberOfLines = 0
        daysLabel.numberOfLines = 0
    }
    
    func configure(viewModel: LaunchViewModel) {
        missionLabel.attributedText = viewModel.missionName
        rocketLabel.attributedText = viewModel.rocketName
        daysLabel.attributedText = viewModel.days
        dateTimeLabel.attributedText = viewModel.dateTime
        missionPatchImageView.kf.setImage(with: viewModel.missionImage)
        if viewModel.hasLaunched {
            launchStatusImageView.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            launchStatusImageView.image = UIImage(systemName: "xmark.circle.fill")
        }
    }
}
