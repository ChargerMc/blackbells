import 'package:blackbells/models/event_model.dart';
import 'package:blackbells/providers/backend_provider.dart';
import 'package:blackbells/services/dialog_service.dart';
import 'package:blackbells/services/navigation_service.dart';
import 'package:blackbells/services/notification_service.dart';
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
import '../../providers/events_provider.dart';

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
                      imageUrl: event.img,
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
                          onTap: event.img.isNotEmpty
                              ? () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ImageView(
                                        imageUrl: event.img,
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
                  if (event.end != null)
                    CaptionWidget(
                      text: Rider.getRouteTime(event.start, event.end),
                      icon: Icons.two_wheeler,
                    ),
                  if (event.link.isNotEmpty)
                    CaptionWidget(
                      text: 'Ver ruta',
                      icon: Icons.map,
                      onPressed: () async => (await canLaunch(event.link).then(
                          (value) async =>
                              (value) ? await launch(event.link) : null)),
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
List<ImageProvider<Object>> imgs = [];
Event? eventLoaded;

class __SubmitButtonState extends ConsumerState<_SubmitButton> {
  @override
  void initState() {
    eventLoaded = widget.event;
    isSending = false;
    isEnrolled = false;
    _refreshImgs();
    super.initState();
  }

  void _refreshImgs() {
    imgs.clear();
    for (var user in eventLoaded!.enrolled) {
      if (ref.read(userProvider).uid == user.id) {
        isEnrolled = true;
      }
      if (user.img.contains('no-image')) {
        imgs.insert(0, const AssetImage('assets/icon/icon_foreground.png'));
      } else {
        imgs.insert(0, NetworkImage(user.img));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final backend = ref.watch(backendProvider);
    final user = ref.watch(userProvider);
    final _textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          eventLoaded!.enrolled.isNotEmpty
              ? GestureDetector(
                  onTap: () => DialogService.showBottomPage(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14),
                          child: Text(
                            'Riders inscritos. (${widget.event.enrolled.length})',
                            style: _textTheme.titleLarge,
                          ),
                        ),
                        const Divider(),
                        SizedBox(
                          height: size.height * 0.5,
                          child: ListView.builder(
                            itemCount: widget.event.enrolled.length,
                            itemBuilder: (context, index) {
                              final rider = widget.event.enrolled[index];
                              return ListTile(
                                leading: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: rider.img,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) => const ShimmerEffect(
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  rider.name ?? 'An??nimo',
                                  style: _textTheme.titleMedium,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    isScrollControlled: true,
                  ),
                  child: ImageStack.providers(
                    providers: imgs,
                    showTotalCount: false,
                    imageCount: 3,
                    imageBorderColor: blackbellsColor,
                    imageBorderWidth: 4,
                    imageRadius: 40,
                    totalCount: eventLoaded!.enrolled.length,
                  ),
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
                  ? () {
                      setState(() => isSending = true);
                      try {
                        DialogService.show(
                          title: '??Est??s seguro/a rider?',
                          content: !isEnrolled
                              ? 'Vas a inscribirte a la rodada ${eventLoaded!.name}.'
                              : 'Vas a desuscribirte a la rodada ${eventLoaded!.name}.',
                          actions: [
                            CustomButton(
                              child: const Text('Confirmar'),
                              onPressed: () => NavigationService.pop(true),
                            ),
                            CustomButton(
                              child: const Text('Cancelar'),
                              isCancel: true,
                              onPressed: () => NavigationService.pop(false),
                            ),
                          ],
                        ).then((value) async {
                          if (value != null && value) {
                            final resp = await backend.modifyEvent(eventLoaded!,
                                enroll: !isEnrolled);
                            if (resp) {
                              isEnrolled = !isEnrolled;

                              if (isEnrolled) {
                                eventLoaded!.enrolled.add(
                                  UserResumed(
                                    id: user.uid,
                                    img: user.img,
                                    name: user.name,
                                  ),
                                );
                              } else {
                                eventLoaded!.enrolled.removeWhere(
                                    (element) => element.id == user.uid);
                              }
                              _refreshImgs();
                              await NotificationService.showNotification(
                                title: isEnrolled
                                    ? '??Excelente rider! vamos a RODARRR!'
                                    : 'No hay problema nos vemos en la pr??xima',
                                body: isEnrolled
                                    ? 'Te inscribiste a ${eventLoaded!.name}.'
                                    : 'Te desuscribiste a ${eventLoaded!.name}.',
                                payload: eventLoaded!.uid,
                              );

                              ref.refresh(eventsProvider);
                            }
                          }

                          setState(() => isSending = false);
                        });
                      } catch (e) {
                        setState(() => isSending = false);
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
