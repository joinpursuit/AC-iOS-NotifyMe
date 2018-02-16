import Foundation

class JSONParser {
    static func parseJSONFile(filename: String, type: String) -> [Podcast]? {
        var fellows: [Podcast]? = nil
        if let pathname = Bundle.main.path(forResource: filename, ofType: type) {
            guard let jsonData = FileManager.default.contents(atPath: pathname) else { return nil }
            do {
                let decoder = JSONDecoder()
                let search = try decoder.decode(Results.self, from: jsonData)
                fellows = search.results
            } catch {
                print("read json error: \(error)")
            }
        }
        return fellows
    }
}
