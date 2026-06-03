// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../event.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 自动生成 provider 名称为 eventNotifierProvider

@ProviderFor(EventNotifier)
final eventProvider = EventNotifierProvider._();

/// 自动生成 provider 名称为 eventNotifierProvider
final class EventNotifierProvider
    extends $AsyncNotifierProvider<EventNotifier, List<Event>> {
  /// 自动生成 provider 名称为 eventNotifierProvider
  EventNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eventProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eventNotifierHash();

  @$internal
  @override
  EventNotifier create() => EventNotifier();
}

String _$eventNotifierHash() => r'd4f561ed65f1625e56b3d351b02eae9cc5862a92';

/// 自动生成 provider 名称为 eventNotifierProvider

abstract class _$EventNotifier extends $AsyncNotifier<List<Event>> {
  FutureOr<List<Event>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Event>>, List<Event>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Event>>, List<Event>>,
              AsyncValue<List<Event>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SelectedCategory)
final selectedCategoryProvider = SelectedCategoryProvider._();

final class SelectedCategoryProvider
    extends $NotifierProvider<SelectedCategory, EventCategory> {
  SelectedCategoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedCategoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedCategoryHash();

  @$internal
  @override
  SelectedCategory create() => SelectedCategory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EventCategory value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EventCategory>(value),
    );
  }
}

String _$selectedCategoryHash() => r'965e94e79a692858d9f9f4963971a8b30245104f';

abstract class _$SelectedCategory extends $Notifier<EventCategory> {
  EventCategory build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<EventCategory, EventCategory>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EventCategory, EventCategory>,
              EventCategory,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredEvents)
final filteredEventsProvider = FilteredEventsProvider._();

final class FilteredEventsProvider
    extends $FunctionalProvider<List<Event>, List<Event>, List<Event>>
    with $Provider<List<Event>> {
  FilteredEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredEventsHash();

  @$internal
  @override
  $ProviderElement<List<Event>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Event> create(Ref ref) {
    return filteredEvents(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Event> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Event>>(value),
    );
  }
}

String _$filteredEventsHash() => r'5d46e1f447d4c6c9b615b28344600022c5472eb6';

@ProviderFor(stats)
final statsProvider = StatsProvider._();

final class StatsProvider
    extends
        $FunctionalProvider<
          Map<String, int>,
          Map<String, int>,
          Map<String, int>
        >
    with $Provider<Map<String, int>> {
  StatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statsHash();

  @$internal
  @override
  $ProviderElement<Map<String, int>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Map<String, int> create(Ref ref) {
    return stats(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, int>>(value),
    );
  }
}

String _$statsHash() => r'b03b39ca920c8c2ffa38451701ef6e196b1c7661';

@ProviderFor(imageService)
final imageServiceProvider = ImageServiceProvider._();

final class ImageServiceProvider
    extends $FunctionalProvider<ImageService, ImageService, ImageService>
    with $Provider<ImageService> {
  ImageServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'imageServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$imageServiceHash();

  @$internal
  @override
  $ProviderElement<ImageService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ImageService create(Ref ref) {
    return imageService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ImageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ImageService>(value),
    );
  }
}

String _$imageServiceHash() => r'7b43252a6533977db0be2e7b070e1e84a254b7ce';

@ProviderFor(savedImagePathsForId)
final savedImagePathsForIdProvider = SavedImagePathsForIdFamily._();

final class SavedImagePathsForIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  SavedImagePathsForIdProvider._({
    required SavedImagePathsForIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'savedImagePathsForIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$savedImagePathsForIdHash();

  @override
  String toString() {
    return r'savedImagePathsForIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    final argument = this.argument as String;
    return savedImagePathsForId(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SavedImagePathsForIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$savedImagePathsForIdHash() =>
    r'966625fee85bdcd528fc197c8062021763d2f30b';

final class SavedImagePathsForIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<String>>, String> {
  SavedImagePathsForIdFamily._()
    : super(
        retry: null,
        name: r'savedImagePathsForIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SavedImagePathsForIdProvider call(String id) =>
      SavedImagePathsForIdProvider._(argument: id, from: this);

  @override
  String toString() => r'savedImagePathsForIdProvider';
}

@ProviderFor(savedImageFilesForId)
final savedImageFilesForIdProvider = SavedImageFilesForIdFamily._();

final class SavedImageFilesForIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<File>>,
          List<File>,
          FutureOr<List<File>>
        >
    with $FutureModifier<List<File>>, $FutureProvider<List<File>> {
  SavedImageFilesForIdProvider._({
    required SavedImageFilesForIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'savedImageFilesForIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$savedImageFilesForIdHash();

  @override
  String toString() {
    return r'savedImageFilesForIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<File>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<File>> create(Ref ref) {
    final argument = this.argument as String;
    return savedImageFilesForId(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SavedImageFilesForIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$savedImageFilesForIdHash() =>
    r'504e7d144db20215a44f7a0adaf757872d5259a4';

final class SavedImageFilesForIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<File>>, String> {
  SavedImageFilesForIdFamily._()
    : super(
        retry: null,
        name: r'savedImageFilesForIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SavedImageFilesForIdProvider call(String id) =>
      SavedImageFilesForIdProvider._(argument: id, from: this);

  @override
  String toString() => r'savedImageFilesForIdProvider';
}

@ProviderFor(getCardItems)
final getCardItemsProvider = GetCardItemsFamily._();

final class GetCardItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CardItem>>,
          List<CardItem>,
          FutureOr<List<CardItem>>
        >
    with $FutureModifier<List<CardItem>>, $FutureProvider<List<CardItem>> {
  GetCardItemsProvider._({
    required GetCardItemsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getCardItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getCardItemsHash();

  @override
  String toString() {
    return r'getCardItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<CardItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CardItem>> create(Ref ref) {
    final argument = this.argument as String;
    return getCardItems(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetCardItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getCardItemsHash() => r'7567ce70f440092fbf42b83855d6baccb6b90a92';

final class GetCardItemsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<CardItem>>, String> {
  GetCardItemsFamily._()
    : super(
        retry: null,
        name: r'getCardItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetCardItemsProvider call(String id) =>
      GetCardItemsProvider._(argument: id, from: this);

  @override
  String toString() => r'getCardItemsProvider';
}
