import 'package:calculate_exchange_v2/services/costum_color.dart';
import 'package:flutter/material.dart';

class PaymentCard extends StatelessWidget {
  final String name;
  final String cost;
  final int colorInt;
  final String description;
  const PaymentCard({
    Key? key,
    required this.name,
    required this.cost,
    required this.colorInt,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = MyColors.people[colorInt] as Color;

    LinearGradient lgcolor = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color, Colors.white70]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 2,
            ),
            CircleAvatar(
              child: const Icon(
                Icons.emoji_people_outlined,
              ),
              foregroundColor: color,
              backgroundColor: Colors.white70,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              name,
              style: TextStyle(
                  fontFamily: 'aller',
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: color),
            ),
          ],
        ),
        Row(children: [
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            margin: const EdgeInsets.fromLTRB(20, 5, 10, 0),
            foregroundDecoration: BoxDecoration(gradient: lgcolor),
          ),
          Expanded(
            child: Card(
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                            style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'lato',
                                fontStyle: FontStyle.italic,
                                color: Colors.black87),
                          ),
                        ),
                      ),
                      Text(
                        cost,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: color),
                      ),
                    ],
                  ),
                ),
              ),
              elevation: 5,
              color: Colors.white38,
              shadowColor: color.withOpacity(0.1),
              margin: const EdgeInsets.all(10),
              shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide:
                      BorderSide(color: color.withOpacity(.1), width: 1)),
            ),
          ),
          const SizedBox(
            width: 2,
          )
        ])
      ],
    );
  }
}
