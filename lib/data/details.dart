import 'package:fitness_dashboard_ui/model/detail_model.dart';
import 'package:fitness_dashboard_ui/services/api_services.dart';
import 'package:intl/intl.dart';

class Details {
  final ApiServices apiService = ApiServices();

  Future<List<DetailModel>> fetchDetails(DateTime date,
      {String? branchId}) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    // Fetch the sales details from the API with the date and branchId parameters
    Map<String, dynamic> salesDetails = await apiService.fetchSalesDetails(
      formattedDate,
      branchId: branchId, // Pass the branchId here
    );

    // Fetch the customer count from the API with the date parameter
    int customerCount = await apiService.fetchCustomerCount(formattedDate);

    // Dummy data for 'Online' payment
    String dummyOnlineAmount =
        '1500'; // Replace this with real data when available
    String dummyTotalAmount = '123'; // Dummy value for total sales amount
    // Construct the DetailModel list with dynamic data
    List<DetailModel> detailList = [
      // Move the Sales Amount section to the first position
      DetailModel(
        icon: 'assets/icons/amount.png',
        value: salesDetails['totalCashAmount'].toString(),
        title: "Cash",
        value2: salesDetails['totalCreditAmount'].toString(),
        title2: "Credit",
        value3: salesDetails['totalCreditCardAmount'].toString(),
        title3: "Credit Card",
        value4: salesDetails['Online'].toString(), // Dummy value for 'Online'
        title4: "Online",
        totalAmount: salesDetails["TotalSaleAmount"]
            .toString(), // Random number (e.g., '123') for total amount
      ),
      // Remaining details
      DetailModel(
        icon: 'assets/icons/sales.png',
        value: salesDetails['totalSalesCount'].toString(),
        title: "Total Sales",
      ),
      DetailModel(
        icon: 'assets/icons/totalCustomers.png',
        value: customerCount.toString(),
        title: "Customers",
      ),
      DetailModel(
        icon: 'assets/icons/bill.png',
        value: salesDetails['totalSalesCount'].toString(),
        title: "Sales",
        value2: salesDetails['positiveAmountSalesCount'].toString(),
        title2: "Return",
      ),
    ];

    return detailList;
  }
}
