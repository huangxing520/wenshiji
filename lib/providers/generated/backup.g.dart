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

String _$backupNotifierHash() => r'e3080587c5783b4e272193f2e78a0897c688f5e3';

abstract class _$BackupNotifier extends $AsyncNotifier<List<BackupRecord>> {
  FutureOr<List<BackupRecord>> build();
  @$mustCallSuper
  @override
  void runBuild() {
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
    element.handleCreate(ref, build);
  }
}
