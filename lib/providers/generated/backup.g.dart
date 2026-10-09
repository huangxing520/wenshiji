// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../backup.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BackupNotifier)
final backupProvider = BackupNotifierProvider._();

final class BackupNotifierProvider
    extends $AsyncNotifierProvider<BackupNotifier, List<BackupRecord>> {
  BackupNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'backupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$backupNotifierHash();

  @$internal
  @override
  BackupNotifier create() => BackupNotifier();
}

String _$backupNotifierHash() => r'a50770277dfb0fe16478b80477df6e6ec0495334';

abstract class _$BackupNotifier extends $AsyncNotifier<List<BackupRecord>> {
  FutureOr<List<BackupRecord>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<BackupRecord>>, List<BackupRecord>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<BackupRecord>>, List<BackupRecord>>,
              AsyncValue<List<BackupRecord>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
