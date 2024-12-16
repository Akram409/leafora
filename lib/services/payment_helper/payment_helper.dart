import 'package:bkash/bkash.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

void paymentHelper(String selected) async {
  switch (selected) {
    case 'bkash':
      bkashPayment();
      break;

    case 'uddoktapay':
      // uddoktapay();
      break;

    case 'sslcommerz':
      // sslcommerz();
      break;

    case 'shurjopay':
      // shurjoPay();
      break;

    default:
      print('No gateway selected');
  }
}

double totalPrice = 1.00;

bkashPayment() async {
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
