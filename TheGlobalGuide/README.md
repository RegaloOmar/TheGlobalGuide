# The Global Guide 🌍

The Global Guide is a native iOS application developed in SwiftUI that allows users to explore detailed information about countries around the world. The application stands out for its robust architecture, efficient network handling, and a custom persistence system that enables a completely offline experience for your favorite countries.

## ✨ Key Features

* **Global Exploration:** Search and list countries consuming the REST Countries API.

* **In-Depth Detail:** Information regarding population, currency, languages, time zones, and geographic location.

* **Favorites Management:** Intuitive system to mark countries of interest.

* **True Offline Mode:** Favorite country data is persisted locally.
  * **Smart Image Caching:** Flags are downloaded once and saved to the file system (`FileManager`), allowing them to be viewed without an internet connection.

* **Modern UI/UX:** Clean interface built with SwiftUI, featuring loading states, error handling, and fluid animations.

# 🛠 Tech Stack

* **Language:** Swift

* **UI Framework:** SwiftUI

* **Architecture:** MVVM (Model-View-ViewModel)

* **Concurrency:** Swift Concurrency (async / await / MainActor)

* **Networking:** URLSession + Codable + Dependency Injection (Protocols)

* **Persistence:** FileManager for efficient image storage.

  * **JSONEncoder/Decoder** for structured data persistence.

# 🏗 Architecture and Technical Solutions

**MVVM Pattern**

The application strictly follows the MVVM pattern to decouple business logic from the user interface.

  * **Models:** Immutable data structures (Country, Flags, etc.).

  * **ViewModels:** (CountryListViewModel, FlagImageViewModel) Manage state, network calls, and persistence logic.

  * **Views:** Declarative SwiftUI components that react to state changes.

**Image Caching Strategy (Smart Caching)**

One of the biggest challenges was handling flag images without relying on heavy external libraries while guaranteeing offline access.

**Implemented Solution:**

**1. Local Check:** When requesting a flag, the FlagImageViewModel first checks the device's document directory using the country ID.

**2. Network Fallback:** If it doesn't exist locally, it downloads it using async/await.

**3. Auto-Save:** Upon successful download, the image is automatically saved to disk.

**4. Optimization:** This reduces data and battery usage, and enables the "Offline Favorites" functionality.


```swift
// Simplified example of the caching logic
if let localImg = loadLocalImage(countryId: countryId) {
    self.image = localImg // Instant load from disk
} else {
    let data = try await networkManager.download(url)
    saveImageLocally(data: data, countryId: countryId) // Automatic persistence
    self.image = UIImage(data: data)
}
```

# 🔮 Future Improvements

* Error Handling
* Implement MapKit to show the exact location of the country on an interactive map.
* Make saved locally procees more eficcient
* Unit Test

# ✍️ Author

**Omar Regalado Mendoza**
