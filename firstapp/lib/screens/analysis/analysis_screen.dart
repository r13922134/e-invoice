import 'package:firstapp/constants.dart';
import 'package:flutter/material.dart';
import 'package:firstapp/screens/analysis/analysis_bar.dart';
import 'package:firstapp/screens/analysis/water_intake_progressbar.dart';
import 'package:firstapp/screens/analysis/water_intake_timeline.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({Key? key}) : super(key: key);
  @override
  _IdentityPageState createState() => _IdentityPageState();
}

class _IdentityPageState extends State<AnalysisScreen> {  
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        height: 145,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color.fromARGB(255, 110, 136, 148)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Flexible(
                                child: SizedBox(
                                  width: (size.width),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "BMI (Body Mass Index)",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      const Text(
                                        "You have a normal weight",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                      Container(
                                        width: 95,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color: kSecondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: const Center(
                                          child: Text(
                                            "View More",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: kBackgroundColor),
                                child: const Center(
                                  child: Text(
                                    "20.3",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 57, 161, 31)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const AnalysisBar(),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            width: (size.width - 80) / 2,
                            height: 320,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.01),
                                      spreadRadius: 20,
                                      blurRadius: 10,
                                      offset: const Offset(0, 10))
                                ],
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  const WateIntakeProgressBar(),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Flexible(
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Water Intake",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        Column(
                                          children: [
                                            Text(
                                              "Real time updates",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black
                                                      .withOpacity(0.5)),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            const WaterIntakeTimeLine()
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 70),
                    ]))));
  }
}
  