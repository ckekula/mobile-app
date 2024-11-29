import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_app/features/auth/domain/entities/app_user.dart';
import 'package:mobile_app/features/auth/presentation/cubits/auth_cubits.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //cubits
  late final authCubit = context.read<AuthCubit>();

  //curent user
  late AppUser? currentUser = authCubit.currentUser;

  //Build ui

  @override
  Widget build(BuildContext context) {

    //Scaffold
    return Scaffold(
      appBar: AppBar(
        title: Text(currentUser!.email),
      ),
    );
  }
}
