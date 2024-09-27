import 'package:fitness_dashboard_ui/data/details.dart';
import 'package:fitness_dashboard_ui/model/detail_model.dart';
import 'package:fitness_dashboard_ui/util/responsive.dart';
import 'package:fitness_dashboard_ui/widgets/custom_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ActivityDetailsCard extends StatefulWidget {
  final DateTime selectedDate;
  final String? branchId;

  const ActivityDetailsCard({
    super.key,
    required this.selectedDate,
    this.branchId,
  });

  @override
  _ActivityDetailsCardState createState() => _ActivityDetailsCardState();
}

class _ActivityDetailsCardState extends State<ActivityDetailsCard> {
  final Details details = Details();
  Future<List<DetailModel>>? _futureDetails;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  void _fetchDetails() {
    setState(() {
      _futureDetails = details.fetchDetails(
        widget.selectedDate,
        branchId: widget.branchId, // Pass branch ID
      );
    });
  }

  @override
  void didUpdateWidget(covariant ActivityDetailsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate ||
        oldWidget.branchId != widget.branchId) {
      _fetchDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DetailModel>>(
      future: _futureDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          // Separate the Sales Amount (isSpecialCard) data to show it first
          List<DetailModel> specialCards = snapshot.data!
              .where((data) => data.title == "Sales" || data.title == "Cash")
              .toList();
          List<DetailModel> otherCards = snapshot.data!
              .where((data) => data.title != "Sales" && data.title != "Cash")
              .toList();

          return StaggeredGridView.countBuilder(
            crossAxisCount: Responsive.isMobile(context) ? 2 : 4,
            itemCount: specialCards.length + otherCards.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            crossAxisSpacing: Responsive.isMobile(context) ? 12 : 15,
            mainAxisSpacing: 12.0,
            itemBuilder: (context, index) {
              // Show the Sales Amount section first
              if (index < specialCards.length) {
                final data = specialCards[index];
                return CustomCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Display the icon and totalAmount near each other

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            data.icon,
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(
                              width: 10), // Space between icon and amount
                          if (data.totalAmount != null)
                            Text(
                              "${data.totalAmount}",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 4),
                        child: Text(
                          data.title == "Sales" ? "Bill Count" : "Sales Amount",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Show the four payment methods: Cash, Credit, Credit Card, Online
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          buildDetailColumn(
                            data.value,
                            data.title,
                            Colors.white,
                          ),
                          if (data.value2 != null)
                            buildDetailColumn(
                              data.value2!,
                              data.title2!,
                              Colors.white,
                            ),
                          if (data.value3 != null)
                            buildDetailColumn(
                              data.value3!,
                              data.title3!,
                              Colors.white,
                            ),
                          if (data.value4 != null)
                            buildDetailColumn(
                              data.value4!,
                              data.title4!,
                              Colors.white,
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              }

              // Show the other cards after the Sales Amount section
              else {
                final data = otherCards[index - specialCards.length];
                return CustomCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        data.icon,
                        width: 50,
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 4),
                        child: Text(
                          data.value,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 240, 236, 236),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        data.title,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            staggeredTileBuilder: (index) {
              final data = index < specialCards.length
                  ? specialCards[index]
                  : otherCards[index - specialCards.length];

              bool isSpecialCard =
                  data.title == "Sales" || data.title == "Cash";
              return isSpecialCard
                  ? StaggeredTile.count(2, 1)
                  : StaggeredTile.count(1, 1);
            },
          );
        }
      },
    );
  }

  Widget buildDetailColumn(String value, String title, Color titleColor) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 212, 203, 203),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            color: titleColor,
          ),
        ),
      ],
    );
  }
}
