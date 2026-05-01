# 🚀 GitHub Repo Explorer

This project serves as a showcase for **Clean Architecture**, **Swift 6 Concurrency**, and **Robust Testing** patterns.

## ✅ Technical Requirements Checklist

This project was built to satisfy a specific technical assessment. Here is how the requirements were addressed:

### Core Requirements
- [x] **Public Repo Fetching:** Connects to `api.github.com/repositories` for initial data.
- [x] **Advanced Grouping:** Implemented grouping logic for both **Owner Type** and **Fork Status**.
- [x] **Local Persistence:** Uses **SwiftData** to bookmark and persist favorite repositories across sessions.
- [x] **Graceful Error Handling:** Custom `NetworkError` enum handles 403 (Rate Limits), decoding issues, and connectivity failures.
- [x] **Loading States:** UI provides visual feedback via `ProgressView` and activity indicators during all network operations.

### Bonus Points Addressed
- [x] **Modern SwiftUI:** Uses `NavigationStack`, `List` sections, and the latest `@Observable` state management.
- [x] **Modern Swift Concurrency:** Fully implemented using `async/await`, `Tasks`, and `Actors` for thread-safe caching.
- [x] **Pagination / Infinite Scroll:** Implemented a robust Link-header parser to follow `rel="next"` URLs as per GitHub API standards.
- [x] **Language Fetching & Caching:** Dynamically fetches repository language data and uses an **Actor-based cache** to prevent redundant network requests.

### Technical Constraints
- [x] **100% Native:** No third-party libraries (e.g., Alamofire, Kingfisher). Built entirely with `URLSession`, `SwiftUI`, and `SwiftData`.


## 🏗️ Technical Architecture

This project is built using a decoupled **MVVM (Model-View-ViewModel)** architecture, adhering strictly to solid principles:

- **Dependency Injection (DI):** All ViewModels are injected with a `RepositoryService` protocol. This decouples the UI from the networking layer and enables seamless testing.
- **Swift Concurrency:** Uses **Actors** (e.g., `NetworkClient`, `MockRepositoryService`) to handle data races and ensure thread-safe network calls and caching.
- **Observation:** Leverages the modern Swift `@Observable` macro for efficient, high-performance UI updates.
- **Persistence:** Uses **SwiftData** for local database management, utilizing the latest Apple framework for model-based persistence.

## 🧪 Testing Strategy

The project maintains a high standard of reliability through a dual-layered testing approach:

### 1. Unit Testing (Swift Testing)
Comprehensive tests covering the core logic of the application:
- **ViewModel Logic:** Validates state transitions (Loading/Error/Success) and proper error message mapping.
- **Data Sorting:** Ensures repository languages are correctly transformed and sorted by size.
- **Parsing Robustness:** Dedicated tests for the `Link` header parser to handle malformed strings and edge-case pagination.

### 2. UI Testing (XCUITest)
The app supports two distinct UI testing modes:
- **Hermetic Mode:** Uses the `-UseMockData` launch argument to inject a `MockRepositoryService`. These tests are 100% stable, fast, and require no internet connection.
- **Integration Mode:** Optionally tests against the live GitHub API to ensure end-to-end compatibility.

## 🛠️ Requirements

- **iOS:** 17.0+
- **Xcode:** 16.0+ (Swift 6.0 compatible)
- **Language:** Swift 6

## 🚦 Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/abir4u/githubrepoexplorer.git
   ```

2. **Open the project**
   Open `GitHubRepoExplorer.xcodeproj` in Xcode.

3. **Run the tests**
   Press `Cmd + U` to run the full test suite and verify the architecture.

4. **Launch the app**
   Select a simulator and press `Cmd + R`.

---
*Created by [Abir](https://github.com)*
