class SwingData {
  final List<double> flexionExtension;
  final List<double> ulnarRadial;

  SwingData({required this.flexionExtension, required this.ulnarRadial});

  factory SwingData.fromJson(Map<String, dynamic> json) {
    final params = json['parameters'];
    final flexionExtensionData = (params['HFA_crWrFlexEx']['values'] as List)
        .map((item) => (item as num).toDouble())
        .toList();
    final ulnarRadialData = (params['HFA_crWrRadUln']['values'] as List)
        .map((item) => (item as num).toDouble())
        .toList();

    return SwingData(
      flexionExtension: flexionExtensionData,
      ulnarRadial: ulnarRadialData,
    );
  }
}
