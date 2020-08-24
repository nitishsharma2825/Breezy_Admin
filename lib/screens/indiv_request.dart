import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RequestStatus extends StatefulWidget {
 String docId;
 int track;
  RequestStatus(this.docId,this.track);

  @override
  _RequestStatusState createState() => _RequestStatusState();
}

class _RequestStatusState extends State<RequestStatus> {
  DocumentReference  doc;
  bool step1 = false;
  bool step2 = false;
  bool step3 = false;
  bool step4 = false;
  List<Step> steps = [
    Step(
        title: Text("Accept Request"),
        content: Container(),
        state:StepState.indexed,
        isActive: true,

    ),
    Step(
        title: Text("On-route"),
        content: Container(),
        state: StepState.indexed,
        isActive: false),
    Step(
        title: Text("In process"),
        content: Container(),
        state: StepState.indexed,
        isActive: false),
    Step(
        title: Text("Picked up"),
        content: Container(),
        state: StepState.indexed,
        isActive: false),
  ];

  void getDoc()async{
    doc = Firestore.instance.collection("requests").document(widget.docId);
  }

@override
  void initState() {
    getDoc();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Status"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              steps: steps,
              currentStep: widget.track==5?3:widget.track-1,
              type: StepperType.vertical,
              onStepTapped: (step) {

              },
              controlsBuilder: (context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                return RaisedButton(
                  onPressed: () async{
                    if(widget.track<=3){
                      setState(() {
                        widget.track++;
                      });
                      doc.updateData({'track':widget.track});
                    }
                    else{
                      doc.updateData({'track':5});
                    }
                  },
                  child: Text("Done"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
