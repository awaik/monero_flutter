import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';

import 'entities/account_row.dart';
import 'entities/subaddress_row.dart';
import 'monero_api.dart' as monero_api;

bool isUpdating = false;

void refreshAccounts() {

  if (isUpdating) {
    return;
  }

  try {
    isUpdating = true;

    final errorBoxPointer = monero_api.buildErrorBoxPointer();
    monero_api.bindings.account_refresh(errorBoxPointer);
    final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

    if (0 != errorInfo.code) {
      throw Exception(errorInfo.getErrorMessage());
    }

    isUpdating = false;
  } catch (e) {
    isUpdating = false;
    rethrow;
  }
}

bool isSubaddressesUpdating = false;

void refreshSubaddresses({required int accountIndex}) {
  if (isSubaddressesUpdating) {
    return;
  }

  try {
    isSubaddressesUpdating = true;

    final errorBoxPointer = monero_api.buildErrorBoxPointer();
    monero_api.bindings.subaddress_refresh(accountIndex, errorBoxPointer);

    final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

    if (0 != errorInfo.code) {
      throw Exception(errorInfo.getErrorMessage());
    }

    isSubaddressesUpdating = false;
  } catch (e) {
    isSubaddressesUpdating = false;
    rethrow;
  }
}

List<AccountRow> getAllAccount() {

  final errorBoxPointer1 = monero_api.buildErrorBoxPointer();
  final size = monero_api.bindings.account_size(errorBoxPointer1);

  final errorInfo1 = monero_api.extractErrorInfo(errorBoxPointer1);

  if (0 != errorInfo1.code) {
    throw Exception(errorInfo1.getErrorMessage());
  }

  final errorBoxPointer2 = monero_api.buildErrorBoxPointer();

  final errorInfo2 = monero_api.extractErrorInfo(errorBoxPointer2);

  if (0 != errorInfo2.code) {
    throw Exception(errorInfo2.getErrorMessage());
  }

  final accountAddressesPointer = monero_api.bindings.account_get_all(errorBoxPointer2);

  final accountAddresses = accountAddressesPointer.asTypedList(size);

  final result = accountAddresses
      .map((addr) => Pointer<AccountRow>.fromAddress(addr).ref)
      .toList();

  monero_api.bindings.free_block_of_accounts(accountAddressesPointer, size);

  return result;
}

List<SubaddressRow> getAllSubaddresses() {
  final errorBoxPointer1 = monero_api.buildErrorBoxPointer();

  final size = monero_api.bindings.subaddress_size(errorBoxPointer1);

  final errorInfo1 = monero_api.extractErrorInfo(errorBoxPointer1);

  if (0 != errorInfo1.code) {
    throw Exception(errorInfo1.getErrorMessage());
  }

  final errorBoxPointer2 = monero_api.buildErrorBoxPointer();

  final subaddressAddressesPointer = monero_api.bindings.subaddress_get_all(
      errorBoxPointer2);

  final errorInfo2 = monero_api.extractErrorInfo(errorBoxPointer2);

  if (0 != errorInfo2.code) {
    throw Exception(errorInfo2.getErrorMessage());
  }

  final subaddressAddresses = subaddressAddressesPointer.asTypedList(size);

  final result = subaddressAddresses
      .map((addr) => Pointer<SubaddressRow>.fromAddress(addr).ref)
      .toList();

  monero_api.bindings.free_block_of_subaddresses(subaddressAddressesPointer, size);

  return result;
}

Future<void> addAccount({required String label}) async {
  await compute(_addAccount, label);
  //await store();
}

void _addAccount(String label) => addAccountSync(label: label);

void addAccountSync({required String label}) {
  final labelPointer = label.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_api.buildErrorBoxPointer();

  monero_api.bindings.account_add_row(labelPointer, errorBoxPointer);
  calloc.free(labelPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

Future<void> addSubaddress({required int accountIndex, required String label}) async {
  await compute<Map<String, Object>, void>(
      _addSubaddress, {'accountIndex': accountIndex, 'label': label});
  //await store();
}

void _addSubaddress(Map<String, dynamic> args) {
  final label = args['label'] as String;
  final accountIndex = args['accountIndex'] as int;

  addSubaddressSync(accountIndex: accountIndex, label: label);
}

void addSubaddressSync({required int accountIndex, required String label}) {
  final labelPointer = label.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_api.buildErrorBoxPointer();

  monero_api.bindings.subaddress_add_row(accountIndex, labelPointer, errorBoxPointer);
  calloc.free(labelPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

Future<void> setLabelForAccount(
    {required int accountIndex, required String label}) async {
  await compute(
      _setLabelForAccount, {'accountIndex': accountIndex, 'label': label});
  //await store();
}

void _setLabelForAccount(Map<String, dynamic> args) {
  final label = args['label'] as String;
  final accountIndex = args['accountIndex'] as int;

  setLabelForAccountSync(label: label, accountIndex: accountIndex);
}

void setLabelForAccountSync(
    {required int accountIndex, required String label}) {
  final labelPointer = label.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_api.buildErrorBoxPointer();

  monero_api.bindings.account_set_label_row(accountIndex, labelPointer, errorBoxPointer);
  calloc.free(labelPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

Future<void> setLabelForSubaddress(
    {required int accountIndex, required int addressIndex, required String label}) async {
  await compute<Map<String, Object>, void>(_setLabelForSubaddress, {
    'accountIndex': accountIndex,
    'addressIndex': addressIndex,
    'label': label
  });
  //await store();
}

void _setLabelForSubaddress(Map<String, dynamic> args) {
  final label = args['label'] as String;
  final accountIndex = args['accountIndex'] as int;
  final addressIndex = args['addressIndex'] as int;

  setLabelForSubaddressSync(
      accountIndex: accountIndex, addressIndex: addressIndex, label: label);
}

void setLabelForSubaddressSync(
    {required int accountIndex,
    required int addressIndex,
    required String label}) {
  final labelPointer = label.toNativeUtf8().cast<Char>();
  final errorBoxPointer = monero_api.buildErrorBoxPointer();

  monero_api.bindings
      .subaddress_set_label(accountIndex, addressIndex, labelPointer, errorBoxPointer);
  calloc.free(labelPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }
}

String getAddress({int accountIndex = 0, int addressIndex = 0}) {
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  final addressPointer =
      monero_api.bindings.get_address(accountIndex, addressIndex, errorBoxPointer);

  final address = addressPointer.cast<Utf8>().toDartString();
  calloc.free(addressPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return address;
}

int getFullBalance({int accountIndex = 0}){
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  final result = monero_api.bindings.get_full_balance(accountIndex, errorBoxPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}


int getUnlockedBalance(int accountIndex){
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  final result = monero_api.bindings.get_unlocked_balance(accountIndex, errorBoxPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return result;
}

String getSubaddressLabel(int accountIndex, int addressIndex) {
  final errorBoxPointer = monero_api.buildErrorBoxPointer();
  final labelPointer =
      monero_api.bindings.get_subaddress_label(accountIndex, addressIndex, errorBoxPointer);

  final label = labelPointer.cast<Utf8>().toDartString();
  calloc.free(labelPointer);

  final errorInfo = monero_api.extractErrorInfo(errorBoxPointer);

  if (0 != errorInfo.code) {
    throw Exception(errorInfo.getErrorMessage());
  }

  return label;
}
