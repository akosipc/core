# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased](https://github.com/obudget/core/compare/v0.1.0...HEAD)

### Added

- This changelog.
- Use GPL 3.0 as the license for this project.
- Add Code of Conduct.
- Add Contributing Guidelines.
- Add Budget resource (schema/endpoint).
- Add active budgets and allow users to switch between budgets.

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
