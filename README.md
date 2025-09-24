# FXViewer
FXViewer is an iOS application designed to display currency exchange rates with offline support and favorites functionality.   The app provides a clean and minimalistic UI for monitoring currencies and allows marking currencies as favorites for quick access.

---

## Dependencies

| Dependency | Version | Purpose |
|------------|---------|---------|
| Apollo | 1.23.0 | GraphQL client |
| KeychainSwift | 24.0.0 | Secure storage of sensitive data |
| Kingfisher | 7.12.0 | Image downloading and caching |
| KingfisherSVG | 1.0.0 | Support for `.svg` images in Kingfisher |
| swift-collections | 1.2.1 | Additional Swift collection types |

---

## Technical Description  

### How to Build and Run  
1. Clone the repository:  
   ```bash
   git clone https://github.com/your-repo/currency-tracker.git
2. Open the project in Xcode (version 14+ recommended).
3. Select the target device or simulator.
4. Build and run the app (Cmd + R).
  
  ---

## Architecture and Design Choices
- `MVVM` for maintainable code, `Coordinator` pattern for clean navigation, `Combine` for reactive data handling
- Repository pattern handles data management and caching.
- UICollectionView with `pull-to-refresh` feature.
- Skeleton with shimmer animation for loading state.
- Clean UI with emphasis on clarity and quick access to important information.

## Key Features.
- Favorites functionality.
- Long press / context menu for marking currencies as favorite.
- `Kingfisher + KingfisherSVG` for flags.
- `JSON/GraphQL` API support for live rates.
- Favorites are maintained in memory and persisted to disk.
- Ensures usability without internet connectivity.

## Offline Mode
- Offline mode uses `FileManagerService` to store data.
- Currencies are maintained in memory and persisted to disk.
- Ensures usability without internet connectivity.
- Icon indicating offline mode.

---

## App Structure and Major Components
- `Service/Repository` — data layer access.
- `Service/Storage` — local caching via FileManager.
- `DIContainer` — resolves dependencies for modules.
- `GraphQL` — scheme, queries.
- `Network` — request layer abstraction (Apollo).
- `Base` — base classes and shared utilities.
- `Navigation` — essential classes for app navigation.
- `Resources` — assets, colors.
- `Tools` — helpers, formatters, utility classes.
- `Extensions` — custom extensions for Swift built-in classes.
- `Models` — data models (e.g., CurrencyModel).
- `Modules` — feature modules.
