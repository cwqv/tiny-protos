# tiny-protos

Protobuf/gRPC 契约唯一真源（single source of truth），供三方共享：

| 消费方 | 语言 | 生成方式 |
|---|---|---|
| `tiny` (server + tinyc) | Rust | buf generate → `core/contracts/src/generated/` |
| `tiny-client-gpui` | Rust | tonic-build (build-time) |
| `tiny-client-flutter` | Dart | buf generate → `flutter/packages/contracts/lib/` |

## 快速开始

```bash
# 在各消费仓的同级目录 clone
cd D:/tiny-project
git clone <this-repo> tiny-protos
```

目录布局（开发模式）：
```
D:/tiny-project/
├── tiny-protos/          ← 本仓 (proto 源)
├── tiny/                 ← 主仓 (server + tinyc)
├── tiny-client-gpui/     ← GPUI 桌面
└── tiny-client-flutter/  ← Flutter 跨平台
```

## 目录结构

```
tiny-protos/
├── protos/
│   ├── tiny/
│   │   ├── sys/              # legacy 包 (config, product, sync)
│   │   └── v1/               # v1 包 (sys, um, task, erp/*)
│   ├── buf.yaml              # lint (STANDARD) + breaking (FILE)
│   └── buf.lock
├── gen-templates/
│   ├── rust.buf.gen.yaml          # server + tinyc (prost + tonic + serde)
│   ├── rust-client.buf.gen.yaml   # gpui (prost + tonic client only)
│   └── dart.buf.gen.yaml          # flutter (dart-proto + dart-grpc)
├── scripts/
│   └── check-breaking.sh     # CI breaking-change 检测
├── CHANGELOG.md
└── README.md
```

## 修改 Proto

1. 编辑 `protos/tiny/**/*.proto`
2. 验证: `cd protos && buf lint`
3. 检查兼容性: `./scripts/check-breaking.sh`
4. 提交 PR，合并后打 tag: `git tag v1.x.0`

## 消费方生成

### tiny 主仓 (Rust)

```bash
cd tiny
# 复制模板并生成
cp ../tiny-protos/gen-templates/rust.buf.gen.yaml ../tiny-protos/protos/buf.gen.yaml
cd ../tiny-protos/protos && buf generate
# 产物: ../../tiny/core/contracts/src/generated/
```

### tiny-client-gpui (Rust)

gpui 仓使用 build-time `tonic-build` 生成，无需手动 buf generate。
参见 `crates/client-proto/build.rs`。

### tiny-client-flutter (Dart)

```bash
cd tiny-client-flutter
cp ../tiny-protos/gen-templates/dart.buf.gen.yaml ../tiny-protos/protos/buf.gen.yaml
cd ../tiny-protos/protos && buf generate
# 产物: ../../tiny-client-flutter/flutter/packages/contracts/lib/
```

## 版本

当前: **v1.0.0**（见 [CHANGELOG.md](CHANGELOG.md)）

## 设计依据

详见 `tiny` 主仓 `docs/ADR_proto_contracts_repo.md`。
