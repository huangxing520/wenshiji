// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_config.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppConfigNotifier)
final appConfigProvider = AppConfigNotifierProvider._();

final class AppConfigNotifierProvider
    extends $AsyncNotifierProvider<AppConfigNotifier, AppConfig> {
  AppConfigNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appConfigNotifierHash();

  @$internal
  @override
  AppConfigNotifier create() => AppConfigNotifier();
}

String _$appConfigNotifierHash() => r'10505c4e413f7ee6a1c81a2605f20d984a7d9d71';

abstract class _$AppConfigNotifier extends $AsyncNotifier<AppConfig> {
  FutureOr<AppConfig> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppConfig>, AppConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppConfig>, AppConfig>,
              AsyncValue<AppConfig>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
