class Pair<K, V> {
  final K _first;
  final V _second;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pair &&
          runtimeType == other.runtimeType &&
          _first == other._first &&
          _second == other._second;

  @override
  int get hashCode => _first.hashCode ^ _second.hashCode;

  Pair(this._first, this._second);

  V get second => _second;

  K get first => _first;

  @override
  String toString() {
    return 'Pair{_first: $_first, _second: $_second}';
  }
}
