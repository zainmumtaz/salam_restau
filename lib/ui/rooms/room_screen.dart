import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../fitness_app_theme.dart';
import 'room_controller.dart';




class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RoomController controller = Get.put(RoomController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rooms Information',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: FitnessAppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 22 ,
            letterSpacing: 1.2,
            color: FitnessAppTheme.darkerText,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Obx(() {


            return AnimatedOpacity(
              opacity: controller.isVisible.value ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              child: AnimatedSlide(
                offset:
                controller.isVisible.value ? Offset.zero : const Offset(0, 0.3),
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                child: Stack(
                children:[
                  Column(
              children: <Widget>[
                Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 0, bottom: 0),
              child: Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: FitnessAppTheme.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0),
                            topRight: Radius.circular(8.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: FitnessAppTheme.grey.withOpacity(0.4),
                              offset: Offset(1.1, 1.1),
                              blurRadius: 10.0),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.topLeft,
                        children: <Widget>[
                          ClipRRect(
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                            child: SizedBox(
                              height: 74,
                              child: AspectRatio(
                                aspectRatio: 1.714,
                                child: Image.asset(
                                    "assets/fitness_app/back.png"),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 100,
                                      right: 16,
                                      top: 16,
                                    ),
                                    child: Text(
                                      "Rooms Information",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily:
                                        FitnessAppTheme.fontName,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        letterSpacing: 0.0,
                                        color:
                                        FitnessAppTheme.nearlyDarkBlue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 100,
                                  bottom: 12,
                                  top: 4,
                                  right: 16,
                                ),
                                child: Text(
                                  "Keep Track of Your Rooms information",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 10,
                                    letterSpacing: 0.0,
                                    color: FitnessAppTheme.grey
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 40,
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.asset("assets/fitness_app/txhs.png"),
                    ),
                  )
                ],
              ),
            ),
                if(controller.savedRoom.value!.roomNumber.isEmpty)...[
                  const Center(child: Text("No there Is not Room Alloted ."))

                ]
            else...[
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 0, bottom: 0),
                    child: Card(
                      color: Colors.white,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Village",
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w500)),
                                Text(controller.savedRoom.value!.villageName,
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w400)),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Building",
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w500)),
                                Text(controller.savedRoom.value!.buildingName,
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w400)),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Room No.",
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w500)),
                                Text(controller.savedRoom.value!.roomNumber,
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w400)),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Start Date",
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w500)),
                                Text(controller.savedRoom.value!.startDate,
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w400)),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                              thickness: 1,
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("End Date",
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w500)),
                                Text(controller.savedRoom.value!.endDate,
                                    style: const TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w400)),
                              ],
                            ),



                          ],


                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
                    child: Text(
                      'Billing Summary',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FitnessAppTheme.fontName,
                        fontWeight: FontWeight.w700,
                        fontSize: 22 ,
                        letterSpacing: 1.2,
                        color: FitnessAppTheme.darkerText,
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
                      child:  Obx(() {


                        final txList = controller.savedRoom.value!.details;

                        if (txList.isEmpty) {
                          return const Center(child: Text("No transactions found."));
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: txList.length,
                          itemBuilder: (context, index) {
                            final tx = txList[index];
                            final roid = tx.roomOrderId ?? 0;
                            final id = tx.id ?? 0;
                            final month = tx.billMonth;
                            final price = tx.price;
                            String status = tx.paymentStatus;
                            Color amountColor;

                            if (status == "payed") {
                              amountColor = Colors.green;
                            } else {
                              amountColor = Colors.blue;
                              status = "Pay Now";
                            }

                            return Card(
                              color: Colors.white,
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: const Color(0x946BBEFB),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  "Price: $price",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text("Month: $month"),
                                            ],
                                          ),
                                        ),

                                        // Agar Payed hai to sirf Text dikhaye
                                        // Agar Pay Now hai to Button bana do
                                        status == "Pay Now"
                                            ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: amountColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                          onPressed: () async {
                                            // Controller method call karo aur id pass karo

                                            await controller.payNow(context,id,roid);
                                          },
                                          child: Text(
                                            status,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                            : Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: amountColor,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            "${status.toString().capitalize}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                      }))
            ]

            ],
            ),


            ]
            ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

