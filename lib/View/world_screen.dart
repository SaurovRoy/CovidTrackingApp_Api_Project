import 'package:covid_tracker/Model/WorldStateModel.dart';
import 'package:covid_tracker/ViewModel/world_states_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
class WorldState_Screen extends StatefulWidget {
  const WorldState_Screen({Key? key}) : super(key: key);

  @override
  State<WorldState_Screen> createState() => _WorldState_ScreenState();
}

class _WorldState_ScreenState extends State<WorldState_Screen> with TickerProviderStateMixin{
  @override
   late final AnimationController _controller=AnimationController(
      duration: Duration(seconds: 3),
      vsync: this)..repeat();
  void dispose(){
    _controller.dispose();
    super.dispose();

  }
WorldRecords newListViewModel=WorldRecords();
  final colorList=<Color>[
    const Color(0xff4285F4),
    const Color(0xff1ac260),
    const Color(0xffde5246),
  ];
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(1.58),
          child: Column(

            children: [
              SizedBox(height: MediaQuery.of(context).size.height*.1,),
              FutureBuilder(
                future: newListViewModel.getWorldRecords(),
                builder: (context,AsyncSnapshot<WorldStateModel> snapshot){
                  if(!snapshot.hasData){
                    return Expanded(
                        child: SpinKitFadingCircle(
                          color: Colors.white,
                          size: 50,
                          controller: _controller,
                        ) );
                  }else{
                    return Column(
                      children: [
                        PieChart(dataMap:
                        {
                          "Total":double.parse(snapshot.data!.cases!.toString()),
                          "Recovered":double.parse(snapshot.data!.critical!.toString()),
                          "Deaths":double.parse(snapshot.data!.deaths!.toString()),
                        },
                          chartRadius: MediaQuery.of(context).size.width/3.2,
                          legendOptions: LegendOptions(
                            legendPosition: LegendPosition.left,
                          ),
                          chartType: ChartType.ring,
                          colorList: colorList,
                          animationDuration: Duration(milliseconds: 1200),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.1,
                        ),
                        Card(
                          child: Column(
                            children: [
                              ReUseableRow(title: "Total Cases", value: snapshot.data!.cases!.toString()),
                              ReUseableRow(title: "Total Critical Paitent", value: snapshot.data!.critical!.toString()),
                              ReUseableRow(title: 'Total Deaths', value: snapshot.data!.deaths!.toString()),

                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),


              SizedBox(height: MediaQuery.of(context).size.height*.01,),
              Container(
                height: 50,
               width: 150,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text('Track Countries'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
 class ReUseableRow extends StatelessWidget {
  String title,value;
    ReUseableRow({Key? key, required this.title, required this.value}) : super(key: key);

   @override
   Widget build(BuildContext context) {
     return Padding(padding: EdgeInsets.all(10),
     child: Column(
         children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text(title),
               Text(value),
             ],
           ),
           SizedBox(height: 5,),
            Divider(),
       ],
     ),
     );
   }
 }
