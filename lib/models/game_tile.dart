class GameTile {
  final int value;
  final bool isNew;
  final bool isMerged;

  GameTile({
    required this.value,
    this.isNew = false,
    this.isMerged = false,
  });

  GameTile copyWith({
    int? value,
    bool? isNew,
    bool? isMerged,
  }) {
    return GameTile(
      value: value ?? this.value,
      isNew: isNew ?? this.isNew,
      isMerged: isMerged ?? this.isMerged,
    );
  }

  @override
  String toString() => 'GameTile(value: $value, isNew: $isNew, isMerged: $isMerged)';
}
