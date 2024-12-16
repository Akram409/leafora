import 'dart:convert';
import 'package:bkash/bkash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:uddoktapay/models/customer_model.dart';
import 'package:uddoktapay/models/request_response.dart';
import 'package:uddoktapay/uddoktapay.dart';
import 'package:shurjopay/models/config.dart';
import 'package:shurjopay/models/payment_verification_model.dart';
import 'package:shurjopay/models/shurjopay_request_model.dart';
import 'package:shurjopay/models/shurjopay_response_model.dart';
import 'package:shurjopay/shurjopay.dart';

void paymentHelper(String selected) async {
  switch (selected) {
    case 'bkash':
      bkashPayment();
      break;

    case 'uddoktapay':
      uddoktapay();
      break;

    case 'sslcommerz':
      sslcommerz();
      break;

    case 'shurjopay':
      shurjoPay();
      break;

    default:
      print('No gateway selected');
  }
}

double totalPrice = 1.00;

// bkash
void bkashPayment() async {
  // instance of bkash
  final bkash = Bkash(
    // for Live bkash payment production
    bkashCredentials: BkashCredentials(
      username: dotenv.env['BKASH_PAYMENT_USER']!,
      password: dotenv.env['BKASH_PAYMENT_PASS']!,
      appKey: dotenv.env['BKASH_PAYMENT_API_KEY']!,
      appSecret: dotenv.env['BKASH_PAYMENT_API_SECRET']!,
      isSandbox: false, // if pay without agreement not needed
    ),
    logResponse: true,
  );

  try {
    // pay without agreement
    final response = await bkash.pay(
      context: Get.context!,
      amount: totalPrice,
      merchantInvoiceNumber: "invoice2002", // invoice number here
    );
    print(response.trxId);
    print(response.paymentId);
  } on BkashFailure catch (e) {
    print(e.message);
  }
}

/// UddoktaPay
void uddoktapay() async {
  final response = await UddoktaPay.createPayment(
    context: Get.context!,
    customer: CustomerDetails(
      // set the full name and email by auth user details
      fullName: 'Md Shirajul Islam',
      email: 'ytshirajul@icould.com',
    ),
    amount: totalPrice.toString(),
  );

  if (response.status == ResponseStatus.completed) {
    print('Payment completed, Trx ID: ${response.transactionId}');
    print(response.senderNumber);
  }

  if (response.status == ResponseStatus.canceled) {
    print('Payment canceled');
  }

  if (response.status == ResponseStatus.pending) {
    print('Payment pending');
  }
}

/// SslCommerz
void sslcommerz() async {
  // Sslcommerz sslcommerz = Sslcommerz(
  //   initializer: SSLCommerzInitialization(
  //     multi_card_name: "visa,master,bkash", // name of payment method name here
  //     currency: SSLCurrencyType.BDT, // BDT for bangladesh currency
  //     product_category: "Digital Product",
  //     sdkType: SSLCSdkType.TESTBOX, // for testing
  //     // sdkType: SSLCSdkType.LIVE, // for live
  //     store_id: dotenv.env['SSL_PAYMENT_STORE_ID']!,
  //     store_passwd: dotenv.env['SSL_PAYMENT_STORE_PASS']!,
  //     total_amount: totalPrice,
  //     tran_id: "TestTRX001", // Custom Transaction id provide here
  //   ),
  // );
  //
  // final response = await sslcommerz.payNow();
  //
  // if (response.status == 'VALID') {
  //   print(jsonEncode(response));
  //
  //   print('Payment completed, TRX ID: ${response.tranId}');
  //   print(response.tranDate);
  // }
  //
  // if (response.status == 'Closed') {
  //   print('Payment closed');
  // }
  //
  // if (response.status == 'FAILED') {
  //   print('Payment failed');
  // }
}

// TODO: initialize this: initializeShurjopay(environment: 'sandbox'); in -> main.dart file
void shurjoPay() async  {
  final shurjoPay = ShurjoPay();

  final paymentResponse = await shurjoPay.makePayment(
    context: Get.context!,
    shurjopayRequestModel: ShurjopayRequestModel(
      configs: ShurjopayConfigs(
        prefix: 'NOK', // example use from surjoPay
        // provide from surjoPay merchent account
        userName: dotenv.env['SURJO_PAYMENT_USER']!,
        password: dotenv.env['SURJO_PAYMENT_PASS']!,
        clientIP: dotenv.env['SURJO_PAYMENT_CLIENT_IP']!,
      ),
      currency: 'BDT',
      amount: totalPrice,
      orderID: 'test00255588',
      // This data are set by current login user data
      customerName: 'Md Shirajul Islam',
      customerPhoneNumber: '+8801700000000',
      customerAddress: 'Dhaka, Bangladesh',
      customerCity: 'Dhaka',
      customerPostcode: '1000',
      returnURL: 'url',
      cancelURL: 'url',
    ),
  );

  if (paymentResponse.status == true) {
    try {
      final verifyResponse = await shurjoPay.verifyPayment(
          orderID: paymentResponse.shurjopayOrderID!);

      if (verifyResponse.spCode == '1000') {
        print(verifyResponse.bankTrxId);
      } else {
        print(verifyResponse.spMessage);
      }

      // if (verifyResponse.bankTrxId == null || verifyResponse.bankTrxId!.isEmpty || verifyResponse.bankTrxId == '') {
      //
      //   print('Something is wrong with your payment');
      //
      // }
      // else {
      //
      //   print(verifyResponse.bankTrxId);
      //   print(verifyResponse.message);
      //
      // }
    } catch (e) {
      print(e);
    }
  }
}
