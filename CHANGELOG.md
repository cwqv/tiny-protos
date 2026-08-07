# Changelog

All notable changes to this proto contracts repository are documented here.
The format is based on [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Security
- Removed `User.encrypted_password` field from `tiny.v1.um.User` (`protos/tiny/v1/sys/um.proto`).
  Password hashes must not travel in client-facing messages. Field number 3 is now `reserved`
  to prevent future reuse for any credential-like field. Server-side code that populated this
  field on `LoginResponse`/`GetMeResponse`/`GetUserResponse`/`CreateUserResponse`/
  `UpdateUserResponse` must stop assigning it; existing persisted hashes are unaffected.
  This is a wire-compatible removal for clients (none consumed the field) but a breaking
  change for any server that serialized it.

### Fixed
- `.gitignore`: ignore `.reasonix/`, `reasonix.toml`, `.workbuddy/` tooling-private state.

## [1.0.0] - 2026-08

### Added
- Extracted 21 `.proto` source files from `tiny` monorepo `dev_infra/protos/`.
- Three generation templates: `rust`, `rust-client`, `dart`.
- `buf.yaml` with STANDARD lint + FILE breaking detection.
- `scripts/check-breaking.sh` for CI breaking-change checks.

### Packages included
- `tiny.sys.config` — config items (legacy)
- `tiny.sys.product` — product management (legacy, 3 files)
- `tiny.sys.sync.v1` — sync service (legacy)
- `tiny.v1.sys` — auth, tenant, RBAC, common types
- `tiny.v1.um` — user management
- `tiny.v1.task` — task service
- `tiny.v1.erp` — ERP common types
- `tiny.v1.erp.{base,product,sale,purchase,account,stock,hr,project,crm}` — ERP domains

### Known tech debt (lint-excepted)
- `tiny.sys.product` enum values use `ProductStatus_*` naming (not `UPPER_SNAKE_CASE`)
- `tiny/v1/sys/um.proto` package `tiny.v1.um` lives in `sys/` directory
- Legacy RPC responses use `Empty` / `TaskDTO` instead of `XxxResponse`
- Unused imports in legacy `product.proto` and `auth.proto`
