//  <--------- Async State --------->
//* TO model the loading, data and error states every API-backed controller exposes so views render them the same way
sealed class AsyncState<T> {
  const AsyncState();

  //  <--------- Factories --------->
  const factory AsyncState.loading() = AsyncLoading<T>;
  const factory AsyncState.data(T value) = AsyncData<T>;
  const factory AsyncState.error(Object error) = AsyncError<T>;

  //  <--------- State Checks --------->
  bool get isLoading => this is AsyncLoading<T>;
  bool get hasError => this is AsyncError<T>;

  //  <--------- Value Access --------->
  //* TO read the loaded value or error without a type check, returning null otherwise
  T? get valueOrNull => switch (this) {
    AsyncData<T>(:final value) => value,
    _ => null,
  };

  Object? get errorOrNull => switch (this) {
    AsyncError<T>(:final error) => error,
    _ => null,
  };

  //  <--------- Pattern Matching --------->
  //* TO map each state to a result with one call
  R when<R>({
    required R Function() loading,
    required R Function(T value) data,
    required R Function(Object error) error,
  }) => switch (this) {
    AsyncLoading<T>() => loading(),
    AsyncData<T>(:final value) => data(value),
    AsyncError<T>(error: final e) => error(e),
  };
}

//  <--------- Async Loading --------->
//* TO mark a request that is still in flight
final class AsyncLoading<T> extends AsyncState<T> {
  const AsyncLoading();
}

//  <--------- Async Data --------->
//* TO carry the value of a request that succeeded
final class AsyncData<T> extends AsyncState<T> {
  const AsyncData(this.value);

  final T value;
}

//!  <--------- Async Error --------->
//* TO carry the error of a request that failed
final class AsyncError<T> extends AsyncState<T> {
  const AsyncError(this.error);

  final Object error;
}
