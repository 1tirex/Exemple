//
//  ViewController.swift
//  dogma-uk-ios
//
//  Created by Ilya on 10.02.23.
//  Copyright © 2023 orgName. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    private var item = [UIImage(systemName: "01.circle"),
                        UIImage(systemName: "02.circle"),
                        UIImage(systemName: "03.circle"),
                        UIImage(systemName: "04.circle"),
                        UIImage(systemName: "05.circle"),
                        UIImage(systemName: "06.circle")]
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var SPB: SegmentedProgressBar = {
        let segment = SegmentedProgressBar(count: item.count)
        segment.delegate = self
        return segment
    }()
    
    private var buttonNext: UIButton = {
        let but = PushButton(
            title: "Next",
            titleColor: .blue,
            backgroundColor: .white,
            font: .systemFont(ofSize: 20),
            cornerRadius: 10,
            transformScale: 0.8)
        but.addTarget(.none, action: #selector(nexts), for: .touchUpInside)
        return but
    }()
    
    private var buttonReverse: UIButton = {
        let but = PushButton(
            title: "Reverse",
            titleColor: .blue,
            backgroundColor: .white,
            font: .systemFont(ofSize: 20),
            cornerRadius: 10,
            transformScale: 0.9)
        but.addTarget(.none, action: #selector(reverse), for: .touchUpInside)
        return but
    }()
    
    private var buttonPause: UIButton = {
        let but = PushButton(
            title: "Pause",
            titleColor: .blue,
            backgroundColor: .white,
            font: .systemFont(ofSize: 20),
            cornerRadius: 10,
            transformScale: 0.8)
        but.addTarget(.none, action: #selector(pause), for: .touchUpInside)
        return but
    }()
    
    private var buttonResume: UIButton = {
        let but = PushButton(
            title: "Resume",
            titleColor: .blue,
            backgroundColor: .white,
            font: .systemFont(ofSize: 20),
            cornerRadius: 10,
            transformScale: 0.8)
        but.addTarget(.none, action: #selector(resume), for: .touchUpInside)
        return but
    }()
    
    private var buttonStart: UIButton = {
        let but = PushButton(
            title: "Start",
            titleColor: .blue,
            backgroundColor: .white,
            font: .systemFont(ofSize: 20),
            cornerRadius: 10,
            transformScale: 0.8)
        but.addTarget(.none, action: #selector(start), for: .touchUpInside)
        return but
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        stack.distribution = .fillEqually
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        
        view.addSubview(stack)
        view.addSubview(SPB)
        view.addSubview(imageView)
        stack.addArrangedSubview(buttonStart)
        stack.addArrangedSubview(buttonNext)
        stack.addArrangedSubview(buttonReverse)
        stack.addArrangedSubview(buttonPause)
        stack.addArrangedSubview(buttonResume)
        
        imageView.image = item[SPB.currentAnimationIndex]
        
        setupConstraints()
    }
}

@objc private extension ViewController {
    func start() {
        DispatchQueue.main.async { [unowned self] in
            SPB.startAnimation()
        }
    }
    
    func nexts() {
        DispatchQueue.main.async { [unowned self] in
            SPB.skip()
        }
    }
    
    func reverse() {
        DispatchQueue.main.async { [unowned self] in
            SPB.rewind()
        }
    }
    
    func pause() {
        DispatchQueue.main.async { [unowned self] in
            SPB.pause()
        }
    }
    
    func resume() {
        DispatchQueue.main.async { [unowned self] in
            SPB.resume()
        }
    }
}

private extension ViewController {
    func setupConstraints() {
        SPB.translatesAutoresizingMaskIntoConstraints = false
        SPB.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        SPB.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        SPB.widthAnchor.constraint(equalToConstant: 300).isActive = true
        SPB.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.bottomAnchor.constraint(equalTo: SPB.topAnchor, constant: -20)
        ])
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: SPB.bottomAnchor, constant: 20),
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.widthAnchor.constraint(equalToConstant: 300),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
}

extension ViewController: SegmentedProgressBarDelegate {
    func moveLeft() {
        imageView.image = item[SPB.currentAnimationIndex]
        print("left")
    }
    
    func moveRight() {
        imageView.image = item[SPB.currentAnimationIndex]
        print("right")
    }
    
    func finished() {
        DispatchQueue.main.async { [unowned self] in
            SPB.startOver()
        }
        print("startOver")
    }
}
