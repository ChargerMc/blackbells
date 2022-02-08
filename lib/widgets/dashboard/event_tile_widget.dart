import 'package:blackbells/helpers/rider.dart';
import 'package:blackbells/models/event_model.dart';

import 'package:blackbells/screens/event/event_details_screen.dart';
import 'package:blackbells/theme/theme.dart';
import 'package:blackbells/widgets/dashboard/custom_caption_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EventTileWidget extends StatelessWidget {
  const EventTileWidget({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final _textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetails(event: event),
        ),
      ),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        alignment: Alignment.bottomLeft,
        margin: const EdgeInsets.all(8),
        width: width * 0.8,
        height: width * 0.3,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(18),
          image: DecorationImage(
            opacity: event.img != null ? 1 : 0.2,
            image: CachedNetworkImageProvider(
              event.img ?? 'https://app.blackbells.com.ec/uploads/no-image.png',
            ),
            fit: event.img != null ? BoxFit.cover : BoxFit.fitWidth,
          ),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: _textTheme.headline5,
                      textScaleFactor: 1,
                    ),
                    Row(
                      children: [
                        CaptionWidget(
                          text:
                              '${event.start.day}/${event.start.month}/${event.start.year}',
                          icon: Icons.calendar_today,
                        ),
                        CaptionWidget(
                          text: Rider.getRouteTime(event.start, event.end),
                          icon: Icons.two_wheeler,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: CircleAvatar(
                  child: Icon(Icons.arrow_forward_ios),
                  backgroundColor: blackbellsColor,
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(18)),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  blackbellsColor.withOpacity(0),
                  blackbellsColor.withOpacity(0.7),
                  blackbellsColor.withOpacity(0.9),
                ]),
          ),
        ),
      ),
    );
  }
}
