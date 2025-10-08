// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pet_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$PetState {
  List<Pet>? get pets => throw _privateConstructorUsedError;
  List<Pet>? get filteredPets => throw _privateConstructorUsedError;
  String? get selectedCategory => throw _privateConstructorUsedError;
  String? get searchQuery => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of PetState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PetStateCopyWith<PetState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PetStateCopyWith<$Res> {
  factory $PetStateCopyWith(PetState value, $Res Function(PetState) then) =
      _$PetStateCopyWithImpl<$Res, PetState>;
  @useResult
  $Res call(
      {List<Pet>? pets,
      List<Pet>? filteredPets,
      String? selectedCategory,
      String? searchQuery,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class _$PetStateCopyWithImpl<$Res, $Val extends PetState>
    implements $PetStateCopyWith<$Res> {
  _$PetStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PetState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pets = freezed,
    Object? filteredPets = freezed,
    Object? selectedCategory = freezed,
    Object? searchQuery = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      pets: freezed == pets
          ? _value.pets
          : pets // ignore: cast_nullable_to_non_nullable
              as List<Pet>?,
      filteredPets: freezed == filteredPets
          ? _value.filteredPets
          : filteredPets // ignore: cast_nullable_to_non_nullable
              as List<Pet>?,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PetStateImplCopyWith<$Res>
    implements $PetStateCopyWith<$Res> {
  factory _$$PetStateImplCopyWith(
          _$PetStateImpl value, $Res Function(_$PetStateImpl) then) =
      __$$PetStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Pet>? pets,
      List<Pet>? filteredPets,
      String? selectedCategory,
      String? searchQuery,
      bool isLoading,
      String? errorMessage});
}

/// @nodoc
class __$$PetStateImplCopyWithImpl<$Res>
    extends _$PetStateCopyWithImpl<$Res, _$PetStateImpl>
    implements _$$PetStateImplCopyWith<$Res> {
  __$$PetStateImplCopyWithImpl(
      _$PetStateImpl _value, $Res Function(_$PetStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of PetState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pets = freezed,
    Object? filteredPets = freezed,
    Object? selectedCategory = freezed,
    Object? searchQuery = freezed,
    Object? isLoading = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$PetStateImpl(
      pets: freezed == pets
          ? _value._pets
          : pets // ignore: cast_nullable_to_non_nullable
              as List<Pet>?,
      filteredPets: freezed == filteredPets
          ? _value._filteredPets
          : filteredPets // ignore: cast_nullable_to_non_nullable
              as List<Pet>?,
      selectedCategory: freezed == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String?,
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$PetStateImpl implements _PetState {
  _$PetStateImpl(
      {final List<Pet>? pets,
      final List<Pet>? filteredPets,
      this.selectedCategory,
      this.searchQuery,
      this.isLoading = false,
      this.errorMessage})
      : _pets = pets,
        _filteredPets = filteredPets;

  final List<Pet>? _pets;
  @override
  List<Pet>? get pets {
    final value = _pets;
    if (value == null) return null;
    if (_pets is EqualUnmodifiableListView) return _pets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Pet>? _filteredPets;
  @override
  List<Pet>? get filteredPets {
    final value = _filteredPets;
    if (value == null) return null;
    if (_filteredPets is EqualUnmodifiableListView) return _filteredPets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? selectedCategory;
  @override
  final String? searchQuery;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'PetState(pets: $pets, filteredPets: $filteredPets, selectedCategory: $selectedCategory, searchQuery: $searchQuery, isLoading: $isLoading, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PetStateImpl &&
            const DeepCollectionEquality().equals(other._pets, _pets) &&
            const DeepCollectionEquality()
                .equals(other._filteredPets, _filteredPets) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_pets),
      const DeepCollectionEquality().hash(_filteredPets),
      selectedCategory,
      searchQuery,
      isLoading,
      errorMessage);

  /// Create a copy of PetState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PetStateImplCopyWith<_$PetStateImpl> get copyWith =>
      __$$PetStateImplCopyWithImpl<_$PetStateImpl>(this, _$identity);
}

abstract class _PetState implements PetState {
  factory _PetState(
      {final List<Pet>? pets,
      final List<Pet>? filteredPets,
      final String? selectedCategory,
      final String? searchQuery,
      final bool isLoading,
      final String? errorMessage}) = _$PetStateImpl;

  @override
  List<Pet>? get pets;
  @override
  List<Pet>? get filteredPets;
  @override
  String? get selectedCategory;
  @override
  String? get searchQuery;
  @override
  bool get isLoading;
  @override
  String? get errorMessage;

  /// Create a copy of PetState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PetStateImplCopyWith<_$PetStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
