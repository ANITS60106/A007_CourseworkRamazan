class CreditHistoryEntry {
  final int id;
  final String providerName;
  final int originalAmount;
  final String? openedAt; // ISO date
  final String? closedAt; // ISO date
  final String status; // ontime/late/default
  final int latePayments;
  final String note;

  CreditHistoryEntry({
    required this.id,
    required this.providerName,
    required this.originalAmount,
    required this.openedAt,
    required this.closedAt,
    required this.status,
    required this.latePayments,
    required this.note,
  });

  factory CreditHistoryEntry.fromJson(Map<String, dynamic> j) {
    return CreditHistoryEntry(
      id: (j['id'] ?? 0) as int,
      providerName: (j['provider_name'] ?? '') as String,
      originalAmount: (j['original_amount'] ?? 0) as int,
      openedAt: j['opened_at'] as String?,
      closedAt: j['closed_at'] as String?,
      status: (j['status'] ?? 'ontime') as String,
      latePayments: (j['late_payments'] ?? 0) as int,
      note: (j['note'] ?? '') as String,
    );
  }
}
