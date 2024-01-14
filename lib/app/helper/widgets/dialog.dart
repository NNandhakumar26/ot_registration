import 'package:flutter/material.dart';

showLoaderDialog(BuildContext context, {String? message}){
    showDialog(
      barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return AlertDialog(
          content: Row(
            children: [
              const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
              const SizedBox(width: 10,),
              Expanded(
                child: Container(
                  height: 30,
                  alignment: Alignment.center,
                  child: Text(message??'Loading', style: Theme.of(context).textTheme.bodyText1,),
                ),
              )
            ],
          ),
        );
      },
    );
  }