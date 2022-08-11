import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/account/account_overview_bloc.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          BlocBuilder<AccountOverviewBloc, AccountOverviewState>(
            builder: (context, state) {
              if (state is AccountLoaded) {
                return Text('${state.balance}');
              }

              return Card(
                child: Container(),
              );
            },
          )
        ],
      ),
    );
  }
}
