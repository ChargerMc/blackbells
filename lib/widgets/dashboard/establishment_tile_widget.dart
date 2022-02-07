import 'package:blackbells/models/establishment_model.dart';
import 'package:blackbells/screens/establishment/establishment_details_screen.dart';
import 'package:blackbells/theme/theme.dart';
import 'package:blackbells/widgets/dashboard/custom_caption_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EstablishmentTileWidget extends StatelessWidget {
  const EstablishmentTileWidget({Key? key, required this.establishment})
      : super(key: key);

  final Establishment establishment;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final _textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              EstablishmentDetails(establishment: establishment),
        ),
      ),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        alignment: Alignment.bottomLeft,
        margin: const EdgeInsets.all(8),
        width: width * 0.8,
        height: width * 0.4,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(18),
          image: DecorationImage(
            image: CachedNetworkImageProvider(establishment.logo),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                establishment.name,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: _textTheme.headline6,
                textScaleFactor: 1,
              ),
              Row(
                children: [
                  CaptionWidget(
                    text: 'Beneficios: ${establishment.benefits.length}',
                    icon: Icons.local_offer_rounded,
                  ),
                ],
              ),
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
