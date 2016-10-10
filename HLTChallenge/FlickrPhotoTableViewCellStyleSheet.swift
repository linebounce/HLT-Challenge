//
//  FlickrTableViewCellStyleSheet.swift
//  HLTChallenge
//
//  Created by Key Hoffman on 10/4/16.
//  Copyright © 2016 Key Hoffman. All rights reserved.
//

import UIKit

// MARK: - FlickrPhotoTableViewCellStyleSheet

struct FlickrPhotoTableViewCellStyleSheet: ViewPreparer {
    
    // MARK: - ViewPreparer Conformance
    
    static func prepare(_ flickrCell: FlickrPhotoTableViewCell) {
        
        defer { flickrCell.layoutSubviews() }
        
        flickrCell.backgroundColor = .blue
        
        // MARK: AutoLayout
        
        flickrCell.flickrView.translatesAutoresizingMaskIntoConstraints = false
        
        let flickrViewTop      = curry(NSLayoutConstraint.init) <^> flickrCell.flickrView <^> .top      <^> .equal <^> flickrCell <^> .top      <^> 1 <^> 0
        let flickrViewBottom   = curry(NSLayoutConstraint.init) <^> flickrCell.flickrView <^> .bottom   <^> .equal <^> flickrCell <^> .bottom   <^> 1 <^> 0
        let flickrViewLeading  = curry(NSLayoutConstraint.init) <^> flickrCell.flickrView <^> .leading  <^> .equal <^> flickrCell <^> .leading  <^> 1 <^> 0
        let flickrViewTrailing = curry(NSLayoutConstraint.init) <^> flickrCell.flickrView <^> .trailing <^> .equal <^> flickrCell <^> .trailing <^> 1 <^> 0
        
        let flickrViewConstraints = [flickrViewTop, flickrViewBottom, flickrViewLeading, flickrViewTrailing]
        
        let activeConstraints = flickrViewConstraints
        
        NSLayoutConstraint.activate(activeConstraints)
    }
    
    // MARK: - View
    
    enum View: Int {
        case flickr = 1
        
        var view: UIView {
            let v                                       = _view
            v.tag                                       = rawValue
            v.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
            return v
        }
        
        private var _view: UIView {
            switch self {
            case .flickr: return FlickrView()
            }
        }
        
        private var translatesAutoresizingMaskIntoConstraints: Bool {
            switch self {
            case .flickr: return false
            }
        }
        
    }
}