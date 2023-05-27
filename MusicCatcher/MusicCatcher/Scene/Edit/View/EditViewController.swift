//
//  EditViewController.swift
//  MusicCatcher
//
//  Created by Lena on 2023/05/26.
//

import UIKit

class EditViewController: UIViewController {
    
    var recorder: Recorder?
    let recorderFileManager = RecordFileManager.shared

    var items = AudioModel.items
    var item = AudioModel()
    var playViewModel = PlayViewModel()
    var recordingViewModel = RecordingViewModel()
    
    // MARK: Properties
    
    private var titleLabel = ReusableLabel(labelText: "제목", labelColor: .black, labelFont: .boldSystemFont(ofSize: 26))
    private var contextLabel = ReusableLabel(labelText: "메모", labelColor: .black, labelFont: .boldSystemFont(ofSize: 26))
    private var tagLabel = ReusableLabel(labelText: "태그", labelColor: .black, labelFont: .boldSystemFont(ofSize: 26))
    
    private var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목 입력하기"
        textField.textAlignment = .left
        textField.font = .systemFont(ofSize: 20)
        textField.backgroundColor = .white
        return textField
    }()
    
    public var contentTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .justified
        textView.font = .systemFont(ofSize: 22)
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.sizeToFit()
        textView.text = "메모를 입력해주세요"
        textView.textColor = .lightGray
        return textView
    }()
    
    private var keywordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "띄어쓰기로 구분해 태그 추가하기"
        textField.font = .systemFont(ofSize: 20)
        textField.backgroundColor = .white
        return textField
    }()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "제목"
        view.backgroundColor = .custombackgroundGrayColor
        [titleLabel, titleTextField, contextLabel, contentTextView, tagLabel, keywordTextField].forEach { view.addSubview($0) }
        contentTextView.delegate = self
        configureLayout()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = recorderFileManager.recordName.value
        navigationController?.navigationBar.isHidden = false
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureLayout() {
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          trailing: view.trailingAnchor,
                          paddingTop: 25,
                          paddingLeading: 15,
                          paddingTrailing: 15)
        
        titleTextField.anchor(top: titleLabel.bottomAnchor,
                              leading: view.leadingAnchor,
                              trailing: view.trailingAnchor,
                              paddingTop: 10,
                              paddingLeading: 15,
                              paddingTrailing: 15)
        titleTextField.setHeight(height: 40)
        contextLabel.anchor(top: titleTextField.bottomAnchor,
                            leading: view.leadingAnchor,
                            trailing: view.trailingAnchor,
                            paddingTop: 20,
                            paddingLeading: 15,
                            paddingTrailing: 15)
        contentTextView.anchor(top: contextLabel.bottomAnchor,
                               leading: view.leadingAnchor,
                               trailing: view.trailingAnchor,
                               paddingTop: 10,
                               paddingLeading: 15,
                               paddingTrailing: 15)
//        contentTextView.setHeight(height: 200)
        tagLabel.anchor(top: contentTextView.bottomAnchor,
                        leading: view.leadingAnchor,
                        trailing: view.trailingAnchor,
                        paddingTop: 20,
                        paddingLeading: 15,
                        paddingTrailing: 15)
        keywordTextField.anchor(top: tagLabel.bottomAnchor,
                                leading: view.leadingAnchor,
                                trailing: view.trailingAnchor,
                                paddingTop: 10,
                                paddingLeading: 15,
                                paddingTrailing: 15)
        keywordTextField.setHeight(height: 40)
        
    }
    

}

extension EditViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {

        
        if textView.text.isEmpty {
            textView.text = "메모를 입력해주세요"
            textView.textColor = .lightGray
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.contentTextView.resignFirstResponder()
    }
}
