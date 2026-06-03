# Flutter 项目构建 Makefile
# 使用方法: make <target>

# 默认目标
.DEFAULT_GOAL := help

# 颜色定义 (Windows PowerShell 不支持 ANSI，需要检测)
ifeq ($(OS),Windows_NT)
    # Windows 环境 - 使用 Windows Terminal 或禁用颜色
    DETECTED := $(shell echo 1)
    # 如果不是 Windows Terminal，使用无颜色版本
    ifeq ($(TERMINAL_EMULATOR),)
        GREEN  :=
        YELLOW :=
        BLUE   :=
        RESET  :=
        ECHO_PREFIX := ==>
    else
        GREEN  := \033[32m
        YELLOW := \033[33m
        BLUE   := \033[34m
        RESET  := \033[0m
        ECHO_PREFIX := ==>
    endif
else
    # Unix/Linux/macOS
    GREEN  := \033[32m
    YELLOW := \033[33m
    BLUE   := \033[34m
    RESET  := \033[0m
    ECHO_PREFIX := ==>
endif

# 目录
ANDROID_DIR := android
APK_OUTPUT  := build/app/outputs/flutter-apk

# =============================================================================
# 代码生成
# =============================================================================

.PHONY: build-runner
build-runner: ## 运行 build_runner 生成 freezed/json_serializable 代码
	@echo "$(BLUE)==> 运行 build_runner...$(RESET)"
	dart run build_runner build --delete-conflicting-outputs

.PHONY: build-runner-watch
build-runner-watch: ## 监听模式运行 build_runner
	@echo "$(BLUE)==> 启动 build_runner 监听模式...$(RESET)"
	dart run build_runner watch --delete-conflicting-outputs

# =============================================================================
# Android 构建
# =============================================================================

.PHONY: apk-debug
apk-debug: ## 构建 Debug 版本 APK
	@echo "$(GREEN)==> 构建 Debug APK...$(RESET)"
	flutter build apk --debug

.PHONY: apk-release
apk-release: ## 构建 Release 版本 APK (不分割 ABI)
	@echo "$(GREEN)==> 构建 Release APK...$(RESET)"
	flutter build apk --release

.PHONY: apk-release-split
apk-release-split: ## 构建 Release 版本 APK (按 CPU 架构分割)
	@echo "$(GREEN)==> 构建 Release APK (分割)...$(RESET)"
	flutter build apk --split-per-abi

.PHONY: apk-clean
apk-clean: ## 清理 Android 构建产物
	@echo "$(YELLOW)==> 清理 Android 构建产物...$(RESET)"
	flutter clean
	flutter pub get

.PHONY: aab-release
aab-release: ## 构建 Release 版本 App Bundle (用于 Google Play 发布)
	@echo "$(GREEN)==> 构建 Release AAB...$(RESET)"
	flutter build appbundle --release

# =============================================================================
# 发布
# =============================================================================

.PHONY: tag-patch
tag-patch: ## 创建 patch 版本 tag 并推送 (如 v1.0.1)
	@ifndef VERSION
	@echo "$(YELLOW)请提供版本号: make tag-patch VERSION=1.0.1$(RESET)"
	@exit 1
	@endif
	@echo "$(BLUE)==> 创建并推送 patch tag v$(VERSION)...$(RESET)"
	git tag -a v$(VERSION) -m "patch: v$(VERSION)"
	git push origin v$(VERSION)

.PHONY: tag-minor
tag-minor: ## 创建 minor 版本 tag 并推送 (如 v1.1.0)
	@ifndef VERSION
	@echo "$(YELLOW)请提供版本号: make tag-minor VERSION=1.1.0$(RESET)"
	@exit 1
	@endif
	@echo "$(BLUE)==> 创建并推送 minor tag v$(VERSION)...$(RESET)"
	git tag -a v$(VERSION) -m "minor: v$(VERSION)"
	git push origin v$(VERSION)

.PHONY: tag-major
tag-major: ## 创建 major 版本 tag 并推送 (如 v2.0.0)
	@ifndef VERSION
	@echo "$(YELLOW)请提供版本号: make tag-major VERSION=2.0.0$(RESET)"
	@exit 1
	@endif
	@echo "$(BLUE)==> 创建并推送 major tag v$(VERSION)...$(RESET)"
	git tag -a v$(VERSION) -m "major: v$(VERSION)"
	git push origin v$(VERSION)

# =============================================================================
# 辅助命令
# =============================================================================

.PHONY: pub-get
pub-get: ## 获取依赖
	@echo "$(BLUE)==> 获取依赖...$(RESET)"
	flutter pub get

.PHONY: doctor
doctor: ## 检查 Flutter 环境
	@echo "$(BLUE)==> 检查 Flutter 环境...$(RESET)"
	flutter doctor

.PHONY: analyze
analyze: ## 代码静态分析
	@echo "$(BLUE)==> 运行静态分析...$(RESET)"
	flutter analyze

.PHONY: help
help: ## 显示帮助信息
	@echo "$(BLUE)Flutter 项目构建命令$(RESET)"
	@echo ""
	@echo "$(GREEN)代码生成:${RESET}"
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | grep -E 'build-runner|generate' | sort | awk 'BEGIN {FS = ":.*## "}; {printf "  $(YELLOW)make %-25s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Android 构建:${RESET}"
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | grep -E 'apk|aab' | sort | awk 'BEGIN {FS = ":.*## "}; {printf "  $(YELLOW)make %-25s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)发布:${RESET}"
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | grep -E 'tag' | sort | awk 'BEGIN {FS = ":.*## "}; {printf "  $(YELLOW)make %-25s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)辅助命令:${RESET}"
	@grep -E '^[a-zA-Z_-]+:.*##' $(MAKEFILE_LIST) | grep -E 'pub|doctor|analyze|clean|help' | sort | awk 'BEGIN {FS = ":.*## "}; {printf "  $(YELLOW)make %-25s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(BLUE)使用示例:${RESET}"
	@echo "  make build-runner              # 生成代码"
	@echo "  make apk-release-split         # 构建分割 APK"
	@echo "  make tag-patch VERSION=1.0.1   # 创建并推送 patch tag"
