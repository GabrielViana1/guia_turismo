class LocalModel {
  final String endereco;

  final double latitude;
  final double longitude;

  LocalModel({
    required this.endereco,
    required this.latitude,
    required this.longitude,
  });

  factory LocalModel.fromJson(Map<String, dynamic> json) {
    return LocalModel(
      endereco: json['display_name'],

      latitude: double.parse(json['lat']),
      longitude: double.parse(json['lon']),
    );
  }
}
