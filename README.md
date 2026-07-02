# Digital Ebook Library

A production-minded ebook library assignment built with a Rails API backend and a Flutter client using feature-first Clean Architecture, BLoC, GetIt, Dio, AutoRoute, and a polished bookshelf experience.

## Highlights

- Bookshelf-style library inspired by classic iOS ebook shelves
- PDF upload with metadata, validation, progress, and success/error states
- Debounced search by title, author, and filename
- Ebook detail view with read, download, and delete actions
- Syncfusion PDF reader with page navigation, zoom, fullscreen, and last-page memory
- Dev, staging, and prod flavors with separate app names and API base URLs
- Rails API-ready networking with Dio interceptors, error mapping, and `Either<Failure, T>`
- Widget and BLoC test structure using `flutter_test`, `bloc_test`, and `mocktail`

## Tech Stack

Frontend:

- Flutter / Material 3
- `flutter_bloc`, `equatable`
- `dartz` for `Either`-based failure handling
- `dio` with request/response/error logging
- `get_it` for dependency injection
- `go_router` for navigation
- `freezed_annotation`, `json_annotation`, `json_serializable`, `build_runner`
- `file_picker`, `syncfusion_flutter_pdfviewer`, `path_provider`, `permission_handler`
- `font_awesome_flutter` for icons
- `shimmer`, `cached_network_image`

Backend:

- Ruby on Rails API
- PostgreSQL
- Active Storage
- RSpec request specs

## Architecture

The Flutter client follows feature-first Clean Architecture:

```text
frontend/lib/
├── core/
│   ├── network/
│   ├── error/
│   ├── constants/
│   ├── services/
│   ├── theme/
│   ├── widgets/
│   ├── extensions/
│   └── utils/
├── features/
│   └── ebook/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/
│           ├── pages/
│           ├── widgets/
│           └── states/
├── di/
├── router/
├── flavor/
└── main.dart
```

Layering:

- Presentation owns pages, widgets, animations, and BLoC events/states.
- Domain owns entities, repository contracts, and use cases.
- Data owns Dio datasources, API models, mock support, and repository implementations.
- Core owns cross-cutting concerns such as failures, logging, theme, file picking, and utilities.

## Prerequisites

- Flutter SDK 3.x (or later) and Dart
- Ruby 3.x with Bundler
- PostgreSQL 12+
- Android emulator or physical device (for Android testing)
- iOS simulator or device (for iOS testing; macOS required)

## Flavors

| Flavor  | App name              | Default API base URL                            | Banner |
| ------- | --------------------- | ----------------------------------------------- | ------ |
| dev     | Ebook Library Dev     | `http://10.0.2.2:3000`                          | Yes    |
| staging | Ebook Library Staging | `https://staging-api.ebook-library.example.com` | Yes    |
| prod    | Ebook Library         | `https://api.ebook-library.example.com`         | No     |

Override the API URL with:

```sh
--dart-define=API_BASE_URL=https://your-api.example.com
```

## Running

Backend:

```sh
cd backend
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

Frontend:

```sh
cd frontend
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --flavor dev -t lib/main_dev.dart
```

During development, watch for code generation changes:

```sh
dart run build_runner watch --delete-conflicting-outputs
```

Other flavors:

```sh
flutter run --flavor staging -t lib/main_staging.dart
flutter run --flavor prod -t lib/main_prod.dart --release
```

**Note:** On Android emulator, the dev API defaults to `http://10.0.2.2:3000` (the host machine). Ensure the Rails server is running locally. On physical devices or iOS simulator, update `API_BASE_URL` via `--dart-define` or modify the flavor config.

## API Contract

The Flutter app is prepared for these Rails endpoints:

```text
GET    /api/ebooks
POST   /api/ebooks
GET    /api/ebooks/:id
GET    /api/ebooks/search?q=query
GET    /api/ebooks/:id/download
DELETE /api/ebooks/:id
```

Expected ebook payload:

```json
{
  "id": 1,
  "title": "Flutter Clean Architecture",
  "author": "Riya Sharma",
  "file_type": "application/pdf",
  "file_size": 13002342,
  "filename": "flutter-clean-architecture.pdf",
  "uploaded_at": "2026-06-28T10:00:00Z",
  "download_url": "/rails/active_storage/blobs/..."
}
```

Upload uses multipart form data:

```text
ebook[title]
ebook[author]
ebook[file]
```

## Testing

Frontend:

```sh
cd frontend
flutter test
flutter analyze
# Watch for test changes
flutter test --watch
```

Backend:

```sh
cd backend
bundle exec rspec
```

Covered frontend areas:

- Library loading states
- Ebook card rendering
- Empty bookshelf state
- Search bar clear action
- Delete confirmation dialog
- BLoC load/search/upload/delete flows

## Manual Testing Checklist

Use this checklist for the main user flows during assignment demo or review:

- Open the app and confirm the ebook library loads successfully.
- Upload a valid PDF and verify it appears in the library with the expected metadata.
- Try uploading a non-PDF file and confirm the validation error message is shown.
- Search for an ebook by title, author, or filename and verify the results update correctly.
- Open an ebook and confirm the download action is available.
- Delete an ebook and verify the confirmation dialog appears and the record is removed.
- Confirm the empty-state screen appears when no ebooks are available.

## Product Thinking Decisions

These are the product-oriented choices that shape the user experience:

- When the library is empty, the app shows a friendly empty-state screen with a clear upload action instead of a blank page.
- When upload fails or validation is triggered, the app shows clear inline feedback and a snackbar so the user understands what went wrong.
- When the file is too large, the upload flow blocks the action and explains that PDFs must be smaller than 20 MB.
- When search has no results, the app shows a no-results message and offers a quick way to clear the search.
- While data is loading, the app displays a shimmer state so the interface feels responsive rather than frozen.
- Delete confirmation is handled through a dedicated dialog before removing an ebook, which prevents accidental loss.
- The experience stays simple by keeping actions focused on upload, search, open, download, and delete with minimal friction.

## Product Decisions

- The default dev flavor falls back to mock data if the Rails server is unavailable, keeping demos smooth while preserving API-ready code.
- The library UI uses generated book covers so uploaded PDFs feel like a real shelf even before cover extraction exists.
- Error handling is centralized through typed failures, which keeps pages focused on product states rather than transport details.
- The reader remembers the last viewed page through the repository contract, ready to be swapped for local persistence later.

## AI Tool Usage

### AI Tools Used

- GitHub Copilot
- ChatGPT

### How AI Was Used

AI tools were used for architecture discussions, code suggestions, debugging, testing guidance, package evaluation, UI improvements, and documentation. They helped explore different implementation approaches and accelerate development.

### Which Parts Were AI-Assisted

AI was used to explore different implementation approaches and evaluate trade-offs for:

- State management selection and architecture discussions
- Dependency Injection setup and service registration strategy
- Route management and navigation architecture
- Package evaluation and selection
- Flutter project structure and Clean Architecture organization
- API design and backend implementation guidance
- UI/UX improvement suggestions
- Error handling and testing strategies
- Documentation and README preparation
  AI provided multiple implementation options and recommendations, which helped accelerate decision-making during development.

### Manual Review and Improvements

All AI-generated suggestions were reviewed before implementation. I manually:

- Selected the final state management, routing, and DI approach
- Evaluated and chose packages based on project requirements
- Refined UI/UX decisions
- Reviewed API contracts and application architecture
- Improved code organization, error handling, and maintainability
- Tested features and validated business logic

### AI-Generated Suggestions Reviewed and Refined

During development, several AI-generated suggestions were evaluated and refined before implementation:

1. Rejected default UI recommendations (themes, colors, fonts, and icons) and implemented a custom design to improve usability and visual consistency.
2. Refined architectural recommendations to better align with Clean Architecture principles and project requirements.
3. Selected alternative packages after comparing multiple options based on maintainability, community support, and feature requirements.
4. Revised routing, dependency injection, and state management recommendations to create a simpler and more scalable application structure.
5. Modified generated code and implementation approaches where necessary to improve readability, performance, and maintainability.
6. Adjusted API integration and error-handling strategies based on real-world testing and application requirements.

### How AI Helped

- Architecture: Evaluated trade-offs for state management, DI, routing, and project structure.
- Debugging: Assisted with Rails, PostgreSQL, package configuration, and API integration issues.
- Testing: Suggested validation scenarios, edge cases, and API test coverage.
- Product Decisions: Provided ideas for UI improvements, search experience, reader workflow, and bonus features.

### Ownership Statement

AI was used as a development assistant, not as a replacement for engineering judgment. All architecture decisions, code reviews, testing, refinements, and final implementations were manually verified and remain my responsibility.
