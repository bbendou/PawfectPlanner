import UIKit

import UIKit
import PlaygroundSupport

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let shareButton = UIButton(type: .system)
        shareButton.setTitle("Share Content", for: .normal)
        shareButton.frame = CGRect(x: 50, y: 100, width: 200, height: 50)
        shareButton.addTarget(self, action: #selector(shareContent), for: .touchUpInside)
        view.addSubview(shareButton)
    }
    
    @objc func shareContent() {
        let text = "Hello, check out my pet tracker app!"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
}

let shareVC = ShareViewController()
PlaygroundPage.current.liveView = shareVC

