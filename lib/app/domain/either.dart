class Either<S, E> {
  final E? _error;
  final S? _success;
  final bool isError;

  Either._(this._error, this._success, this.isError);

  factory Either.error(E error) => Either._(error, null, true);
  factory Either.success(S success) => Either._(null, success, false);

  R validator<R>(Function(S) success, Function(E) error) {
    if (isError) {
      return error(_error as E);
    } else {
      return success(_success as S);
    }
  }
}
