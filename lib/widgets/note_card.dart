import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_todo/style/card_style.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc) {
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
            style: CardStyle.title,
          ),
          const SizedBox(height: 4.0,),
          Text(
            DateFormat("dd/MM/yyy HH:mm a").format((doc["date"].toDate())).toString(),
            style: CardStyle.date,
          ),
          const SizedBox(height: 8.0,),
          Text(
            doc["content"],
            style: CardStyle.content,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    ),
  );
}