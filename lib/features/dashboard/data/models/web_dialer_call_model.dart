class WebDialerCall {
  final String id;
  final String toNumber;
  final String fromNumber;
  final String status;
  final String direction;
  final int duration;
  final String createdAt;

  WebDialerCall({
    required this.id,
    required this.toNumber,
    required this.fromNumber,
    required this.status,
    required this.direction,
    required this.duration,
    required this.createdAt,
  });

  factory WebDialerCall.fromJson(Map<String, dynamic> json) {
    final toNum = json['to_number'] ?? json['toNumber'] ?? json['to'] ?? '';
    final fromNum = json['from_number'] ?? json['fromNumber'] ?? json['from'] ?? '';
    final statusVal = json['status'] ?? json['state'] ?? 'Completed';
    final dir = json['direction'] ?? 'outbound';
    final dur = json['duration'] ?? 0;
    final created = json['created_at'] ?? json['createdAt'] ?? json['timestamp'] ?? json['date'] ?? '';

    return WebDialerCall(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      toNumber: toNum.toString(),
      fromNumber: fromNum.toString(),
      status: statusVal.toString(),
      direction: dir.toString(),
      duration: dur is num ? dur.toInt() : (int.tryParse(dur.toString()) ?? 0),
      createdAt: created.toString(),
    );
  }
}
