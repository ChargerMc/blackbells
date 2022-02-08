import 'package:blackbells/models/event_model.dart';
import 'package:blackbells/providers/backend_provider.dart';
import 'package:blackbells/screens/image_view.dart';
import 'package:blackbells/theme/theme.dart';
import 'package:blackbells/widgets/custom_button.dart';
import 'package:blackbells/widgets/dashboard/custom_caption_widget.dart';
import 'package:blackbells/widgets/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_stack/image_stack.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/rider.dart';
import '../../models/user_model.dart';

class EventDetails extends StatelessWidget {
  const EventDetails({Key? key, required this.event}) : super(key: key);
  final Event event;

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Detalles del evento'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      alignment: Alignment.center,
                      imageUrl: event.img ?? '',
                      fit: BoxFit.cover,
                      height: size.height * 0.3,
                      width: size.width,
                      placeholder: (_, __) => const ShimmerEffect(),
                      errorWidget: (_, __, ___) => Image.asset(
                        'assets/icon/icon_foreground.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        width: size.width,
                        opacity: const AlwaysStoppedAnimation(0.2),
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: event.img != null
                              ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageView(
                                        imageUrl: event.img!,
                                      ),
                                    ),
                                  )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Text(
                event.name,
                style: _textTheme.headline4,
                textScaleFactor: 1,
              ),
              const SizedBox(height: 14),
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
                  if (event.link != null)
                    CaptionWidget(
                      text: 'Google Maps',
                      icon: Icons.map,
                      onPressed: () async {
                        final can = await canLaunch(event.link!);

                        if (can) {
                          await launch(event.link!);
                        }
                      },
                    ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                event.desc,
                textScaleFactor: 1,
                textAlign: TextAlign.justify,
                style: _textTheme.bodyText1,
              ),
            ],
          ),
        ),
        bottomNavigationBar: _SubmitButton(event: event));
  }
}

class _SubmitButton extends ConsumerStatefulWidget {
  const _SubmitButton({Key? key, required this.event}) : super(key: key);

  final Event event;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __SubmitButtonState();
}

bool isEnrolled = false;
bool isSending = false;
List<String> imgs = [];

class __SubmitButtonState extends ConsumerState<_SubmitButton> {
  @override
  void initState() {
    isSending = false;
    isEnrolled = false;
    for (var user in widget.event.enrolled) {
      if (ref.read(userProvider).uid == user.id) {
        isEnrolled = true;
      }
      imgs.add(user.img);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final backend = ref.watch(backendProvider);
    final event = widget.event;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          event.enrolled.isNotEmpty
              ? ImageStack(
                  imageCount: 3,
                  imageBorderColor: blackbellsColor,
                  imageBorderWidth: 4,
                  imageRadius: 50,
                  imageList: const [
                    'https://app.blackbells.com.ec/uploads/no-image.png'
                  ],
                  totalCount: event.enrolled.length,
                )
              : const SizedBox(),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: CustomButton(
              isCancel: true,
              backgroundColor: isEnrolled ? Colors.redAccent : null,
              foregroundColor: isEnrolled ? Colors.white : null,
              child: Text(!isEnrolled ? 'Inscribirme' : 'Desuscribirme'),
              onPressed: !isSending
                  ? () async {
                      setState(() {
                        isSending = true;
                      });
                      final resp =
                          await backend.modifyEvent(event, enroll: !isEnrolled);
                      if (resp) {
                        isEnrolled = !isEnrolled;
                        setState(() {});
                        ref.refresh(eventsProvider);
                      }
                      setState(() {
                        isSending = false;
                      });
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
