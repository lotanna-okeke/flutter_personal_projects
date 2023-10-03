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

class FetchTransaction {
  FetchTransaction({
    required this.amount,
    required this.balanceBefore,
    required this.billerCategory,
    required this.billerDescription,
    required this.billerId,
    required this.commission,
    required this.customerId,
    required this.dateCreated,
    required this.extraInfo,
    required this.referenceId,
    required this.requestId,
    required this.reversed,
    required this.status,
    required this.walletDescription,
    this.isSuccessful,
  });

  final String amount;
  final String balanceBefore;
  final String? billerCategory;
  final String? billerDescription;
  final String? billerId;
  final String? commission;
  final String? customerId;
  final String? dateCreated;
  final String? extraInfo;
  final String? referenceId;
  final String? requestId;
  final String? reversed;
  final String? status;
  final String? walletDescription;
  bool? isSuccessful;
}
