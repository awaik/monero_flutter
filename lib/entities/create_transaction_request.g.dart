// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTransactionRequest _$CreateTransactionRequestFromJson(
        Map<String, dynamic> json) =>
    CreateTransactionRequest(
      destinations: (json['destinations'] as List<dynamic>)
          .map((e) => CreateTransactionRequestDestination.fromJson(
              e as Map<String, dynamic>))
          .toList(),
      accountIndex: json['accountIndex'] as int,
      subaddressIndices: (json['subaddressIndices'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$CreateTransactionRequestToJson(
        CreateTransactionRequest instance) =>
    <String, dynamic>{
      'destinations': instance.destinations.map((e) => e.toJson()).toList(),
      'accountIndex': instance.accountIndex,
      'subaddressIndices': instance.subaddressIndices,
    };

CreateTransactionRequestDestination
    _$CreateTransactionRequestDestinationFromJson(Map<String, dynamic> json) =>
        CreateTransactionRequestDestination(
          address: json['address'] as String,
          amount: json['amount'] as int,
        );

Map<String, dynamic> _$CreateTransactionRequestDestinationToJson(
        CreateTransactionRequestDestination instance) =>
    <String, dynamic>{
      'address': instance.address,
      'amount': instance.amount,
    };
