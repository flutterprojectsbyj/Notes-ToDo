import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_todo/style/card_style.dart';

Widget todoCard(Function()? onTap, QueryDocumentSnapshot doc) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          color: CardStyle.cardColors[doc['colorId']],
          borderRadius: BorderRadius.circular(8.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doc["title"],
            style: CardStyle.title.copyWith(color: CardStyle.getTextColorForBackground(CardStyle.cardColors[doc["colorId"]])),
          ),
          const SizedBox(height: 4.0,),
          Text(
            doc['date'] != null ? DateFormat("dd/MM/yyy HH:mm a").format((doc["date"].toDate())).toString() : "",
            style: CardStyle.date.copyWith(color: CardStyle.getTextColorForBackground(CardStyle.cardColors[doc["colorId"]])),
          ),
          const SizedBox(height: 8.0,),
          ListView.builder(
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (context, index) {
                return ListTileTheme(
                  contentPadding: const EdgeInsets.all(0), // Remove all padding
                  dense: true,
                  horizontalTitleGap: 0.0,
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                    onChanged: (bool? value) {  },
                    value: doc["completed"][index],
                    checkColor: Colors.white,
                    activeColor: Colors.green,
                    side: MaterialStateBorderSide.resolveWith(
                          (states) => BorderSide(
                          width: 1.0,
                          color: CardStyle.getTextColorForBackground(CardStyle.cardColors[doc["colorId"]])
                      ),
                    ),
                    title: Text(
                      doc["content"][index],
                      style: CardStyle.content.copyWith(color: CardStyle.getTextColorForBackground(CardStyle.cardColors[doc["colorId"]])),
                    ),
                  ),
                );
              }
          ),
        ],
      ),
    ),
  );
}