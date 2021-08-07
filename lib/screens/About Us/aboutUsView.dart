import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('About Us'),
        ),
        body: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                  child: RichText(
                text: TextSpan(
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                          text: 'We Are Loyal to Our Core Values\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              'We are dedicated to our fundamental beliefs that give included advantages '
                              'in our customers business that extend past the underlying venture, be it in website '
                              'composition or a versatile application advancement venture.\n\n'),
                      TextSpan(
                          text:
                              'We Build Strong Relationships. We put vigorously in building long haul '
                              'connections by giving quality, client encounters, and execution in your product items.'),
                      TextSpan(
                          text: '\n\nWe Are Quality Conscious\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              'We adore quality searchers. Henceforth, our prime center is programming '
                              'quality that wins us some genuine praises from customers and their end-clients.'),
                      TextSpan(
                          text: '\n\nWe Are Creative and Innovative\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              'Our capacities to thoroughly consider of-box bring advancement, upheaval,'
                              ' and uniqueness even by pushing the limits somewhat more distant than anybody can.'),
                      TextSpan(
                          text: '\n\nOur Mission\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              'To decide our strength in the present and up and coming programming '
                              'innovations by conveying modern arrangements that keeping them serving and remaining '
                              'for more.'),
                      TextSpan(
                          text: '\n\nOur Vision\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text:
                              'To acquire profound respect from the supporters over the globe and distinctive'
                              ' verticals of the business by conveying intriguing yet answers for their issues/challenges.'),
                      TextSpan(
                          text:
                              '\n\nCopyright © [DAMN group of industries] [2020-2040]All Rights Reserved\n\n',
                          style: TextStyle(fontSize: 14)),
                    ]),
              )),
            )));
  }
}
