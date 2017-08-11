

import UIKit

class Toast: NSObject {
    
    static func show(message: String, target: UIViewController) {
        let myAlert = UIAlertController(title: "提示", message: message, preferredStyle: .alert);
        let myOkAction = UIAlertAction(title: "确定", style: .default, handler: nil);
        myAlert.addAction(myOkAction);
        target.present(myAlert, animated: true, completion: nil);
    }
    
}
