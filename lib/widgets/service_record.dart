import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:gradebook/api/models/service_record.dart';
import 'package:gradebook/widgets/share.dart';

class ServiceRecord extends StatefulWidget {
  final IServiceRecord record; 
  final void Function(Uint8List) onShare;

  const ServiceRecord({super.key, required this.record, required this.onShare});

  @override
  State<ServiceRecord> createState() => _ServiceRecordState();
}

class _ServiceRecordState extends State<ServiceRecord> with TickerProviderStateMixin {
   final GlobalKey _globalKey = GlobalKey();
   
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 250),
    vsync: this
  )..forward();

  late final Animation<double> _opacityAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.ease,
  );

  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          (await image.toByteData(format: ui.ImageByteFormat.png))!;
      var pngBytes = byteData.buffer.asUint8List();
      setState(() {});
      debugPrint("Service Record PNG Generated");
      return pngBytes;
    } catch (e) {
      debugPrint(e.toString());
    }
    return null; 
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: RepaintBoundary(
        key: _globalKey,
        child:
        Container(
          height: 100,
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width - 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 15, 15, 15),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: const Color.fromARGB(255, 32, 32, 32),
              width: 1
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                      widget.record.organization,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 20
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "${widget.record.dateOfService.month}/${widget.record.dateOfService.day}/${widget.record.dateOfService.year}",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 177, 177, 177),
                          fontSize: 15
                        ),
                      ),
                    ],
                  ),
                  // TODO: Text gradient vs. background gradient
                  Text(
                    "${Duration(minutes: widget.record.minutesServed).inHours}h ${Duration(minutes: widget.record.minutesServed).inMinutes.remainder(60)}m",
                    style: TextStyle(
                      fontSize: 18,
                      foreground: Paint()..shader = const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        tileMode: TileMode.mirror,
                        colors: [
                          Color.fromARGB(255, 175, 128, 200),
                          Color.fromARGB(255, 206, 158, 116),
                        ],
                      ).createShader(const Rect.fromLTWH(0.0, 0.0, 100.0, 55.0))
                    )
                  ),
                  // Container(
                  //   padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
                  //   decoration: BoxDecoration(
                  //     color: const Color.fromARGB(255, 10, 10, 10),
                  //     borderRadius: BorderRadius.circular(5),
                  //     gradient: const LinearGradient(
                  //       begin: Alignment.topLeft,
                  //       end: Alignment.bottomRight,
                  //       tileMode: TileMode.mirror,
                  //       colors: [
                  //       Color.fromARGB(255, 154, 106, 255),
                  //       Color.fromARGB(255, 239, 192, 23),
                  //       ],
                  //     )
                  //   ),
                  //   child: Text(
                  //     "${Duration(minutes: record.minutesServed).inHours}h ${Duration(minutes: record.minutesServed).inMinutes.remainder(60)}m",
                  //     style: const TextStyle(
                  //       fontSize: 16,
                  //     )
                  //   )
                  // )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.record.description,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 52, 52, 52),
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Share(
                    onTap: () async {
                        var png = await _capturePng();
                        if (png != null) {
                          widget.onShare(png);
                        }
                    }
                  )
                ]
              )
            ],
          ),
        ),
      )
    );
  }
}