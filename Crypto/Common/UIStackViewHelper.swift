//
//  UIStackViewHelper.swift
//  Crypto
//
//  Created by Tifo Audi Alif Putra on 02/06/21.
//

import UIKit

extension UIStackView {
    @discardableResult
    public func setMargins(_ value: CGFloat) -> UIStackView {
        layoutMargins = UIEdgeInsets.init(top: value, left: value, bottom: value, right: value)
        isLayoutMarginsRelativeArrangement = true
        return self
    }
    
    @discardableResult
    public func setHorizontalMargins(_ value: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.left = value
        layoutMargins.right = value
        return self
    }
    
    @discardableResult
    public func setVerticalMargins(_ value: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.top = value
        layoutMargins.bottom = value
        return self
    }
    
    @discardableResult
    public func topMargins(_ value: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.top = value
        return self
    }
    
    @discardableResult
    public func leftMargins(_ value: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.left = value
        return self
    }
    
    @discardableResult
    public func rightMargins(_ value: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.right = value
        return self
    }
    
    @discardableResult
    public func bottomMargins(_ value: CGFloat) -> UIStackView {
        isLayoutMarginsRelativeArrangement = true
        layoutMargins.bottom = value
        return self
    }
    
    @discardableResult
    public func setDistribution(_ distribution: UIStackView.Distribution) -> UIStackView {
        self.distribution = distribution
        return self
    }
    
    @discardableResult
    public func setSpacing(_ spacing: CGFloat) -> UIStackView {
        self.spacing = spacing
        return self
    }
    
    @discardableResult
    public func setAlignment(_ alignment: UIStackView.Alignment) -> UIStackView {
        self.alignment = alignment
        return self
    }
    
    @discardableResult
    public func setAxis(_ axis: NSLayoutConstraint.Axis) -> UIStackView {
        self.axis = axis
        return self
    }
}
