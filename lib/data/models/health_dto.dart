class HealthDto {
  final String status;

  HealthDto(this.status);

  factory HealthDto.fromJson(Map<String, dynamic> json) =>
      HealthDto(json['status'] as String);
}
