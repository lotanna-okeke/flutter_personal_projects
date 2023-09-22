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

// {id: al@saudi.com42a23b334516494e84b78833e32ccc9d, name: saudi-money, username: seyimo@gmail.com, role: merchant-admin,
//parentID: null, airtimeID: null, dataID: null, b2bID: null, portalID: gabriel, created: 2023-07-25T09:31:14.000Z, status: SUSPENDED}

class FetchMerchants {
  FetchMerchants({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    required this.parentId,
    required this.airtimeId,
    required this.dataId,
    required this.b2bId,
    required this.portalId,
    required this.status,
    this.isActive,
  });

  final String id;
  final String name;
  final String username;
  final String role;
  final String? parentId;
  final String? airtimeId;
  final String? dataId;
  final String? b2bId;
  final String? portalId;
  final String status;
  bool? isActive;
}

class CreateMerchant {
  CreateMerchant({
    required this.name,
    required this.username,
    required this.password,
    required this.airtimeId,
    required this.dataId,
    required this.b2bId,
    required this.transactionId,
    required this.transactionPassword,
  });

  final String name;
  final String username;
  final String password;
  final String airtimeId;
  final String dataId;
  final String b2bId;
  final String transactionId;
  final String transactionPassword;
}
