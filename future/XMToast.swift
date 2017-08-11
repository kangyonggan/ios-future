//
//  XMToast.swift
//  future
//
//  Created by kangyonggan on 8/10/17.
//  Copyright © 2017 kangyonggan. All rights reserved.
//

import UIKit

class XMToast: UILabel {
    
    private static var _instance: XMToast?
    
    class func create(text: String) -> XMToast{
        _instance?.hide()
        let toast: XMToast = {
            let toast = XMToast()
            toast.text = text
            return toast
        }()
        _instance = toast
        return toast
    }
    
    private static let _showTime: TimeInterval = 2
    private static let _animDuration: TimeInterval = 0.5
    private var _window: UIWindow?
    private var _disposable: XMDisposable? {
        didSet{
            oldValue?.dispose()
        }
    }
    
    /** 显示函数，2秒后消失 */
    func show() -> XMToast {
        
        guard let text = (text.flatMap{ $0.cString(using: NSUTF8StringEncoding) }
            .flatMap{ String(CString: $0, encoding: NSUTF8StringEncoding)} ) else {
                return self
        }
        
        font = UIFont.systemFont(ofSize: 13)
        textColor = UIColor.white
        textAlignment = NSTextAlignment.center
        numberOfLines = 0
        
        let uiScreenSize = UIScreen.main.bounds.size
        let screenWidth = uiScreenSize.width
        let screenHeight = uiScreenSize.height
        let rect = text.boundingRectWithSize(SizeMake(screenWidth * 0.7, screenHeight * 0.4), options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                                             attributes: [NSFontAttributeName: font],
                                             context: nil)
        let lableY: CGFloat = 10
        let lableX = min(rect.height / 2, 20) + lableY
        self.frame = RectMake(lableX , lableY, rect.width , rect.height )
        
        let width = rect.width + lableX * 2
        let height = rect.height + lableY * 2
        let x = (screenWidth  - width) / 2
        let y = (screenHeight - height) * 0.8
        
        let window = UIWindow()
        self._window = window
        window.frame = CGRectMake(x, y, width, height)
        window.layer.cornerRadius = min(lableX, height / 2)
        window.backgroundColor = UIColor(white: 0, alpha: 0.7)
        window.windowLevel = UIWindowLevelAlert
        window.isHidden = false
        window.addSubview(self)
        
        statusShowBefore()
        UIView.animate(withDuration: XMToast._animDuration,
                                   animations: { self.statusShowing() },
                                   completion: nil )
        
        _disposable = delayerOnMain(XMToast._showTime) { [weak self] in self?.dismiss() }
        return self
    }
    
    func dismiss() {
        UIView.animate(withDuration: XMToast._animDuration,
                                   animations: { self.statusHideAfter() },
                                   completion: {  _ in self.hide() } )
    }
    
    private func hide(){
        _disposable = nil
        removeFromSuperview()
        if let window = _window {
            window.isHidden = true
            window.resignKey()
            XMToast._instance = nil
        }
        _window = nil
    }
    
    private func statusShowBefore(){
        _window?.alpha = 0.1
        let scareTransform = CGAffineTransform(scaleX: 1.0, y: 0.7)
        let translateTransform = scareTransform.translatedBy (x: 0, y: -1 * (self.frame.height + self.frame.origin.y ))
        _window?.transform = translateTransform
    }
    
    private func statusShowing(){
        _window?.alpha = 1.0
        let scareTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        let translateTransform = scareTransform.translatedBy (x: 0, y: 0)
        _window?.transform = translateTransform
    }
    
    private func statusHideAfter(){
        _window?.alpha = 0.1
        let scareTransform = CGAffineTransform(scaleX: 1.0, y: 0.7)
        let translateTransform = scareTransform.translatedBy (x: 0, y: self.frame.height + self.frame.origin.y )
        _window?.transform = translateTransform
    }
    
    deinit {
        print("XMToast:\(hash) is deinit ")
    }
}
