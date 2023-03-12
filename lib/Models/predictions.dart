import 'dart:convert';

class Predictions {
  String? placeId;
  String? mainText;
  String? secondaryText;
  Predictions({
    this.placeId,
    this.mainText,
    this.secondaryText,
  });

  Predictions copyWith({
    String? placeId,
    String? mainText,
    String? secondaryText,
  }) {
    return Predictions(
      placeId: placeId ?? this.placeId,
      mainText: mainText ?? this.mainText,
      secondaryText: secondaryText ?? this.secondaryText,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'mainText': mainText,
      'secondaryText': secondaryText,
    };
  }

  factory Predictions.fromMap(Map<String, dynamic> map) {
    return Predictions(
      placeId: map['placeId'],
      mainText: map['mainText'],
      secondaryText: map['secondaryText'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Predictions.fromJson(String source) =>
      Predictions.fromMap(json.decode(source));

  @override
  String toString() =>
      'Predictions(placeId: $placeId, mainText: $mainText, secondaryText: $secondaryText)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Predictions &&
        other.placeId == placeId &&
        other.mainText == mainText &&
        other.secondaryText == secondaryText;
  }

  @override
  int get hashCode =>
      placeId.hashCode ^ mainText.hashCode ^ secondaryText.hashCode;
}
