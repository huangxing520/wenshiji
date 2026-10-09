// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../event_filter_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EventCategory, EventCategory>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EventCategory, EventCategory>,
              EventCategory,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(filteredEvents)
final filteredEventsProvider = FilteredEventsFamily._();

final class FilteredEventsProvider
    extends $FunctionalProvider<List<Event>, List<Event>, List<Event>>
    with $Provider<List<Event>> {
  FilteredEventsProvider._({
    required FilteredEventsFamily super.from,
    required FilterType super.argument,
  }) : super(
         retry: null,
         name: r'filteredEventsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filteredEventsHash();

  @override
  String toString() {
    return r'filteredEventsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<Event>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Event> create(Ref ref) {
    final argument = this.argument as FilterType;
    return filteredEvents(ref, filterType: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Event> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Event>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredEventsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filteredEventsHash() => r'9397931d3dbc9a0e771e05e9f2ceca3c1617157a';

final class FilteredEventsFamily extends $Family
    with $FunctionalFamilyOverride<List<Event>, FilterType> {
  FilteredEventsFamily._()
    : super(
        retry: null,
        name: r'filteredEventsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FilteredEventsProvider call({required FilterType filterType}) =>
      FilteredEventsProvider._(argument: filterType, from: this);

  @override
  String toString() => r'filteredEventsProvider';
}

@ProviderFor(getEvent)
final getEventProvider = GetEventFamily._();

final class GetEventProvider extends $FunctionalProvider<Event?, Event?, Event?>
    with $Provider<Event?> {
  GetEventProvider._({
    required GetEventFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getEventProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getEventHash();

  @override
  String toString() {
    return r'getEventProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Event?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Event? create(Ref ref) {
    final argument = this.argument as String;
    return getEvent(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Event? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Event?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetEventProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getEventHash() => r'6cbe207425aea352faf18431292a2ddb24eb7815';

final class GetEventFamily extends $Family
    with $FunctionalFamilyOverride<Event?, String> {
  GetEventFamily._()
    : super(
        retry: null,
        name: r'getEventProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetEventProvider call(String id) =>
      GetEventProvider._(argument: id, from: this);

  @override
  String toString() => r'getEventProvider';
}
