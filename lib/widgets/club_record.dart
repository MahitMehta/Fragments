import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:gradebook/api/models/club.dart';
import 'package:gradebook/widgets/share.dart';
import 'package:gradebook/widgets/share_menu.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ClubRecord extends StatefulWidget {
  final IClubRecord record;
  final void Function(Uint8List, String) onShare;

  const ClubRecord({super.key, required this.record, required this.onShare});

  @override
  State<ClubRecord> createState() => _ClubRecordState();
}

class _ClubRecordState extends State<ClubRecord> with TickerProviderStateMixin {
  final GlobalKey _globalKey = GlobalKey();

  late final AnimationController _controller =
      AnimationController(duration: const Duration(milliseconds: 250), vsync: this)..forward();

  late final Animation<double> _opacityAnimation = CurvedAnimation(
    parent: _controller,
    curve: Curves.ease,
  );

  Future<Uint8List?> _capturePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData = (await image.toByteData(format: ui.ImageByteFormat.png))!;
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
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width - 40,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 15, 15, 15),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: const Color.fromARGB(255, 32, 32, 32), width: 1)),
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
                          widget.record.clubName,
                          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 20),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text(
                              "${widget.record.startDate.month}/${widget.record.startDate.day}/${widget.record.startDate.year}",
                              style: const TextStyle(color: Color.fromARGB(255, 177, 177, 177), fontSize: 15),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              "-",
                              style: TextStyle(color: Color.fromARGB(255, 177, 177, 177), fontSize: 15),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "${widget.record.endDate.month}/${widget.record.endDate.day}/${widget.record.endDate.year}",
                              style: const TextStyle(color: Color.fromARGB(255, 177, 177, 177), fontSize: 15),
                            ),
                          ],
                        )
                      ],
                    ),
                    // TODO: Text gradient vs. background gradient
                    Text(widget.record.positionHeld,
                        style: TextStyle(
                            fontSize: 18,
                            foreground: Paint()
                              ..shader = const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                tileMode: TileMode.mirror,
                                colors: [
                                  Color.fromARGB(255, 175, 128, 200),
                                  Color.fromARGB(255, 206, 158, 116),
                                ],
                              ).createShader(const Rect.fromLTWH(0.0, 0.0, 100.0, 55.0)))),
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
                      Share(onTap: () async {
                        showCupertinoModalBottomSheet(
                            context: context,
                            isDismissible: true,
                            builder: (context) {
                              return ShareMenu(
                                onShareFB: () async {
                                  final pngBytes = await _capturePng();
                                  if (pngBytes != null) {
                                    widget.onShare(pngBytes, "SHARE_FB");
                                  }
                                },
                                onShareIG: () async {
                                  final pngBytes = await _capturePng();
                                  if (pngBytes != null) {
                                    widget.onShare(pngBytes, "SHARE_IG");
                                  }
                                },
                                onShareFBDirectly: () async {
                                  final pngBytes = await _capturePng();
                                  if (pngBytes != null) {
                                    widget.onShare(pngBytes, "SHARE_FB_DIALOG");
                                  }
                                },
                              );
                            });
                      })
                    ])
              ],
            ),
          ),
        ));
  }
}
