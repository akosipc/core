# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased](https://github.com/obudget/core/compare/v0.2.2...HEAD)

## [0.2.2](https://github.com/obudget/core/releases/tag/v0.2.2) - 2017-11-06 - [Diff](https://github.com/obudget/core/compare/v0.2.1...0.2.2)

### Changed

- Change CORS library from CORSPlug to Corsica. [#46](https://github.com/obudget/core/pull/46)
- Change CORS origin URL depending on the application's environment. [#47](https://github.com/obudget/core/pull/47)

## [0.2.1](https://github.com/obudget/core/releases/tag/v0.2.1) - 2017-11-02 - [Diff](https://github.com/obudget/core/compare/v0.2.0...v0.2.1)

### Fixed

- Fix Token deletion URL to be /auth/token instead of /token. [#42](https://github.com/obudget/core/pull/42)
- Fix repeated controller render after Guardian returns 401. [#43](https://github.com/obudget/core/pull/43)

## [0.2.0](https://github.com/obudget/core/releases/tag/v0.2.0) - 2017-10-28 - [Diff](https://github.com/obudget/core/compare/v0.1.0...v0.2.0)

### Added

- This changelog.
- Use GPL 3.0 as the license for this project.
- Add Code of Conduct.
- Add Contributing Guidelines.
- Add Budget resource (schema/endpoint).
- Add active budgets and allow users to switch between budgets.
- Automatically create a default active budget and authenticate for users created through `POST /users`.

### Changed

- Convert authentication error responses to JSON API.
- Require user authentication for User endpoints except create (`POST /users`).
- Require user authentication for Budget endpoints.
- Require user authentication for Account endpoints.
- Include location (`links` key) inside API response body instead of header.
- Change all Budget endpoints to only show budgets associated with the current logged-in user.
- Change all Account endpoints to only show accounts associated with the current logged-in user's active budget.
- Improve all error responses to adhere to JSON API.

### Fixed

- Fix clients being able to access `DELETE /token` without being authenticated.

## 0.1.0 - 2017-10-08

### Added

- This project.
- Use JSON API spec as our preferred standard.
- Add Account resource (schema/endpoint).
- Add User resource (schema/endpoint).
- Add Token endpoint.
- Add user authentication through Token endpoint.
