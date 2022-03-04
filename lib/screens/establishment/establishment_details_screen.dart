import 'package:blackbells/models/establishment_model.dart';
import 'package:blackbells/screens/image_view.dart';
import 'package:blackbells/services/dialog_service.dart';
import 'package:blackbells/services/navigation_service.dart';
import 'package:blackbells/widgets/custom_circular_progress.dart';
import 'package:blackbells/widgets/dashboard/custom_caption_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/benefits_provider.dart';
import '../../widgets/shimmer.dart';

class EstablishmentDetails extends ConsumerWidget {
  const EstablishmentDetails({Key? key, required this.establishment})
      : super(key: key);
  final Establishment establishment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _textTheme = Theme.of(context).textTheme;
    Future<void> _onRefresh() async {
      ref.refresh(benefitsProvider(establishment.uid));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del establecimiento'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        strokeWidth: 2,
        color: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 14),
              Text(
                establishment.name,
                style: _textTheme.headline4,
                textScaleFactor: 1,
              ),
              const SizedBox(height: 8),
              Text(
                establishment.desc,
                textScaleFactor: 1,
                textAlign: TextAlign.justify,
                style: _textTheme.bodyText1,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (establishment.link.isNotEmpty)
                    CaptionWidget(
                      text: 'Sitio web',
                      icon: Icons.language_rounded,
                      onPressed: () async =>
                          (await canLaunch(establishment.link).then(
                              (value) async => (value)
                                  ? await launch(establishment.link)
                                  : null)),
                    ),
                  if (establishment.gmaplink.isNotEmpty)
                    CaptionWidget(
                      text: 'Google Maps',
                      icon: Icons.map_rounded,
                      onPressed: () async =>
                          (await canLaunch(establishment.gmaplink).then(
                              (value) async => (value)
                                  ? await launch(establishment.gmaplink)
                                  : null)),
                    ),
                ],
              ),
              const Divider(),
              _BenefitList(establishment, _textTheme),
            ],
          ),
        ),
      ),
    );
  }
}

class _BenefitList extends ConsumerStatefulWidget {
  const _BenefitList(this.establishment, this.textTheme, {Key? key})
      : super(key: key);
  final Establishment establishment;
  final TextTheme textTheme;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => __BenefitListState();
}

final ScrollController _scrollController = ScrollController();

class __BenefitListState extends ConsumerState<_BenefitList> {
  @override
  void initState() {
    _scrollController.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final establishment = widget.establishment;
    final benefitsProv = ref.watch(benefitsProvider(establishment.uid));
    final _textTheme = widget.textTheme;

    return benefitsProv.when(
      data: (benefits) {
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          shrinkWrap: true,
          controller: _scrollController,
          itemCount: benefits.length,
          itemBuilder: (context, index) {
            final benefit = benefits[index];
            return Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            benefit.name,
                            style: _textTheme.headline6,
                            textScaleFactor: 1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            benefit.desc,
                            style: _textTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor:
                                        Colors.white.withOpacity(0.05)),
                                onPressed: () => DialogService.show(
                                  title: benefit.name,
                                  content: benefit.desc,
                                ),
                                child: const Text(
                                  'Leer más',
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (benefit.link.isNotEmpty)
                                CaptionWidget(
                                  text: 'Ir al link',
                                  icon: Icons.attachment_rounded,
                                  onPressed: () async =>
                                      canLaunch(benefit.link).then(
                                    (value) async =>
                                        (value) ? launch(benefit.link) : null,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            alignment: Alignment.center,
                            imageUrl: benefit.img.isEmpty
                                ? establishment.img
                                : benefit.img,
                            fit: BoxFit.cover,
                            height: 125,
                            width: 125,
                            placeholder: (_, __) => const ShimmerEffect(),
                            errorWidget: (_, __, ___) => Image.asset(
                              'assets/icon/icon_foreground.png',
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              width: 50,
                              opacity: const AlwaysStoppedAnimation(0.2),
                            ),
                          ),
                          RawMaterialButton(
                            onPressed: benefit.img.isNotEmpty
                                ? () => NavigationService.navigateToPage(
                                    ImageView(imageUrl: benefit.img))
                                : null,
                            child: const SizedBox.square(
                              dimension: 125,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            );
          },
        );
      },
      error: (_, __) => const SizedBox.shrink(),
      loading: () {
        return const CustomCircularProgressIndicator(
          heightFactor: 3,
        );
      },
    );
  }
}
