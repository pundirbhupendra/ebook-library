# Digital Ebook Library Backend

Rails 8 API backend for uploading, listing, searching, downloading, and deleting PDF ebooks.

## Tech Stack

- Ruby 3.3.6
- Rails 8 API mode
- PostgreSQL
- Active Storage with local disk service
- RSpec request specs
- Optional Faker seed data support

## Setup

```sh
cd backend
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server
```

By default the API runs at `http://localhost:3000`.

For Android emulator builds, the Flutter app should call the backend through
`http://10.0.2.2:3000`.

PostgreSQL environment variables:

```sh
POSTGRES_USER=postgres
POSTGRES_PASSWORD=
POSTGRES_HOST=localhost
```

## Run Tests

```sh
cd backend
bundle exec rspec
```

## API Overview

### List ebooks

`GET /api/ebooks`

Returns the 2 newest ebooks sorted by newest first.

```json
[
  {
    "id": 1,
    "title": "Flutter Clean Architecture",
    "author": "Riya Sharma",
    "file_type": "application/pdf",
    "file_size": 12345,
    "filename": "flutter-clean-architecture.pdf",
    "uploaded_at": "2026-07-02T00:00:00Z",
    "download_url": "/rails/active_storage/blobs/proxy/..."
  }
]
```

### Upload ebook

`POST /api/ebooks`

Send `multipart/form-data`:

- `ebook[title]`
- `ebook[author]`
- `ebook[file]`

Only PDF files are accepted.

### Show ebook

`GET /api/ebooks/:id`

Returns one ebook with metadata and download URL.

### Search ebooks

`GET /api/ebooks/search?q=rails`

Searches title, author, and uploaded filename.

### Download ebook

`GET /api/ebooks/:id/download`

Returns:

```json
{
  "id": 1,
  "title": "Flutter Clean Architecture",
  "download_url": "/rails/active_storage/blobs/proxy/..."
}
```

### Delete ebook

`DELETE /api/ebooks/:id`

Deletes the ebook record and purges the attached file. Returns `204 No Content`.

## Error Responses

Validation errors return `422 Unprocessable Entity`.

```json
{
  "errors": ["Title can't be blank", "File must be a PDF"]
}
```

Missing records return `404 Not Found`.

```json
{
  "error": "Ebook not found"
}
```

## Postman

Import `postman/ebook-library.postman_collection.json` into Postman and set the collection variable `base_url` to `http://localhost:3000`.
