import 'dart:core';

class Merchant {
  Merchant({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.airtimeId,
    required this.dataId,
    required this.b2bId,
    required this.portalId,
    required this.portalPassword,
    required this.isActive,
  });

  final String id;
  final String name;
  final String email;
  final String password;
  final String airtimeId;
  final String dataId;
  final String b2bId;
  final String portalId;
  final String portalPassword;
  bool isActive;
}
