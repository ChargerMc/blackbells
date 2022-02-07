import 'package:blackbells/models/establishment_model.dart';
import 'package:flutter/material.dart';

class EstablishmentDetails extends StatelessWidget {
  const EstablishmentDetails({Key? key, required this.establishment})
      : super(key: key);
  final Establishment establishment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(establishment.name),
      ),
    );
  }
}
