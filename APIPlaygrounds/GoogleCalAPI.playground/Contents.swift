import UIKit

import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let accessToken = "YOUR_ACCESS_TOKEN" //we tried this with our own tokens

guard let url = URL(string: "https://www.googleapis.com/calendar/v3/calendars/primary/events") else {
    fatalError("Invalid URL")
}

var request = URLRequest(url: url)
request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

let task = URLSession.shared.dataTask(with: request) { data, response, error in
    if let error = error {
        print("Error fetching calendar events: \(error)")
        PlaygroundPage.current.finishExecution()
        return
    }
    guard let data = data else {
        print("No data returned")
        PlaygroundPage.current.finishExecution()
        return
    }
    
    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
        print("Calendar events: \(json)")
    }
    PlaygroundPage.current.finishExecution()
}

task.resume()
