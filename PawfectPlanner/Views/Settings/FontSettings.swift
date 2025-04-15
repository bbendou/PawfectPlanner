import SwiftUI

class FontSettings: ObservableObject {
    @Published var fontSize: CGFloat {
        didSet {
            UserDefaults.standard.set(Float(fontSize), forKey: "fontSize")
        }
    }

    init() {
        let savedSize = UserDefaults.standard.float(forKey: "fontSize")
        self.fontSize = savedSize == 0 ? 16 : CGFloat(savedSize)
    }
}
