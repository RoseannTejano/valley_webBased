import 'package:flutter/material.dart';

final Size deviceSize =
    MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
//var screenSize = double.parse(deviceSize.toString());

// Note that in the above example,
//  we're using MediaQueryData.fromWindow(WidgetsBinding.instance.window).size 
//  to get the screen size, as MediaQuery.of(context).size 
//  requires a BuildContext which might not always be available in every file 
//  where you want to use this variable. The method used in the example ensures 
//  that the screenSize variable can be accessed anywhere without requiring a BuildContext.
