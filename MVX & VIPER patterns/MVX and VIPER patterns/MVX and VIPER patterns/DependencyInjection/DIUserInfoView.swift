//
//  DIUserInfoView.swift
//  MVX and VIPER patterns
//
//  Created by Ficow on 2022/3/27.
//

import UIKit

final class DIUserInfoView: UIStackView {

    var user: DIUser? {
        didSet {
            nameLabel.text = "Name: \(user?.name ?? "-")"
            genderLabel.text = "Gender: \(user?.gender ?? "-")"
        }
    }

    private let nameLabel = UILabel()
    private let genderLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        axis = .vertical
        spacing = 8
        [nameLabel, genderLabel].forEach(addArrangedSubview(_:))
    }
}
