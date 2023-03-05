//
//  SegmentedProgressBar.swift
//  dogma-uk-ios
//
//  Created by Ilya on 10.02.23.
//  Copyright © 2023 orgName. All rights reserved.
//

import UIKit

/// Send event about moved
public protocol SegmentedProgressBarDelegate: AnyObject {
    func moveLeft()
    func moveRight()
    func finished()
}

fileprivate final class Segment {
    let bottomSegmentView = UIView()
    let topSegmentView = UIView()
}

/// Animation segments
public final class SegmentedProgressBar: UIView {
    
    // MARK: Public Properties
    public weak var delegate: SegmentedProgressBarDelegate?
    
    /// slider color - defoult white
    public var topColor = UIColor.white {
        didSet { updateColors() }
    }
    
    ///  backgraundColor - defoult white with alpha 0.5
    public var bottomColor = UIColor.white.withAlphaComponent(0.5) {
        didSet { updateColors() }
    }
    
    // MARK: Private Properties
    /// between segments
    private let padding: Double
    /// Count segments
    private let count: Int
    /// speed move
    private let duration: TimeInterval
    /// all segments
    private var segments = [Segment]()
    /// who create all magic
    private var animator: UIViewPropertyAnimator?
    /// current segment index
    public private(set) var currentAnimationIndex = 0
    
    // MARK: init
    /// Init segments
    /// - Parameters:
    ///   - count: How many segments you want
    ///   - duration: What speed animation
    ///   - padding: padding between segments
    public init(
        count: Int,
        duration: TimeInterval = 5.0,
        padding: Double = 5
    ) {
        self.count = count
        self.duration = duration
        self.padding = padding
        super.init(frame: CGRect.zero)
        //        createSegments(count)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        createSegments(count)
    }
    
    // MARK: Public Methods
    /// Start animate segments
    /// - Parameter index: if you want start to any segment
    public func startAnimation(index: Int = 0) {
        if animator == nil {
            if !segments.isEmpty {
                if index != 0 {
                    for i in 0..<index {
                        let currentSegment = segments[i]
                        currentSegment.topSegmentView.frame.size.width = currentSegment.bottomSegmentView.frame.width
                        currentSegment.topSegmentView.layer.removeAllAnimations()
                    }
                }
                animate(animationIndex: index)
            }
        }
    }
    
    /// Pause animation
    public func pause() {
        if animator?.isRunning == true {
            animator?.pauseAnimation()
        }
    }
    
    /// resume animation
    public func resume() {
        if animator?.isRunning == false {
            animator?.startAnimation()
        }
    }
    
    /// Skip curret segment
    public func skip() {
        let currentSegment = segments[currentAnimationIndex]
        currentSegment.topSegmentView.frame.size.width = currentSegment.bottomSegmentView.frame.width
        currentSegment.topSegmentView.layer.removeAllAnimations()
        
        finish(animation: .end)
        
        next()
    }
    
    /// Rewind segment
    public func rewind() {
        let currentSegment = segments[currentAnimationIndex]
        currentSegment.topSegmentView.layer.removeAllAnimations()
        
        finish(animation: .start)
        
        back(segment: currentSegment)
    }
    
    /// When finished adtivated and start again
    public func startOver() {
        segments.forEach {
            $0.topSegmentView.frame.size.width = 0
            $0.topSegmentView.layer.removeAllAnimations()
        }
        
        finish(animation: .start)
        currentAnimationIndex = 0
        animate(animationIndex: currentAnimationIndex)
        delegate?.moveRight()
    }
    
    /// finish all animation
    /// - Parameter animation: what position on segment
    public func finish(animation: UIViewAnimatingPosition) {
        animator?.pauseAnimation()
        animator?.stopAnimation(false)
        animator?.finishAnimation(at: animation)
    }
}

// MARK: Private Methods
private extension SegmentedProgressBar {
    func updateColors() {
        for segment in segments {
            segment.topSegmentView.backgroundColor = topColor
            segment.bottomSegmentView.backgroundColor = bottomColor
        }
    }
    
    func createSegments(_ count: Int?) {
        guard let count, segments.isEmpty else { return }
        for _ in 0..<count {
            let segment = Segment()
            addSubview(segment.bottomSegmentView)
            addSubview(segment.topSegmentView)
            segments.append(segment)
        }
        updateColors()
        setupSegments()
    }
    
    func setupSegments() {
        let width = (frame.width - (padding * Double(segments.count - 1))) / Double(segments.count)
        for (index, segment) in segments.enumerated() {
            let segFrame = CGRect(
                x: Double(index) * (width + padding),
                y: 0,
                width: width,
                height: frame.height
            )
            segment.bottomSegmentView.frame = segFrame
            segment.topSegmentView.frame = segFrame
            segment.topSegmentView.frame.size.width = 0
            
            let cornerRadius = frame.height / 2
            segment.bottomSegmentView.layer.cornerRadius = cornerRadius
            segment.topSegmentView.layer.cornerRadius = cornerRadius
        }
    }
    
    func animate(animationIndex: Int = 0) {
        let nextSegment = segments[animationIndex]
        currentAnimationIndex = animationIndex
        
        animator = UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: duration,
            delay: 0.0,
            options: .curveLinear) {
                nextSegment.topSegmentView.frame.size.width = nextSegment.bottomSegmentView.frame.width
            } completion: { [weak self] finished in
                
                if finished == .end, self?.animator?.isRunning == true {
                    self?.next()
                }
            }
    }
    
    func next() {
        let newIndex = currentAnimationIndex + 1
        
        if newIndex < segments.count {
            animate(animationIndex: newIndex)
            delegate?.moveRight()
        } else {
            delegate?.finished()
        }
    }
    
    func back(segment currentSegment: Segment) {
        let newIndex = currentAnimationIndex - 1
        if newIndex >= 0 {
            currentSegment.topSegmentView.frame.size.width = 0
            
            let prevSegment = segments[newIndex]
            prevSegment.topSegmentView.frame.size.width = 0
            
            currentAnimationIndex = newIndex
            animate(animationIndex: newIndex)
            delegate?.moveLeft()
        } else {
            segments.forEach {
                $0.topSegmentView.frame.size.width = currentSegment.bottomSegmentView.frame.width
            }
            
            let currentSegment = segments.last
            currentSegment?.topSegmentView.frame.size.width = 0
            
            animate(animationIndex: segments.count - 1)
            delegate?.moveLeft()
        }
    }
}
