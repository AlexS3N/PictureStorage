
import UIKit

class ImageManager {
    
    static let shared = ImageManager()
    private init() {}
    
    func saveImage(_ image: UIImage) -> String? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileName = UUID().uuidString
        guard let fileURL = documentsDirectory?.appendingPathComponent(fileName),
              let imageData = image.jpegData(compressionQuality: 1) else { return nil }
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let error {
                print(error.localizedDescription)
                return nil
            }
        }
        do {
            try imageData.write(to: fileURL)
            return fileName
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func loadImage(fileName: String) -> UIImage? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        let image = UIImage(contentsOfFile: fileURL.path)
        return image
    }
    
    func saveResult(_ result: Image) {
        var results = self.loadResult()
        results.append(result)
        UserDefaults.standard.set(encodable: results, forKey: "description")
    }
    
    func loadResult() -> [Image] {
        guard let results = UserDefaults.standard.value([Image].self, forKey: "description") else {
            return []
        }
        return results
    }
    
}
