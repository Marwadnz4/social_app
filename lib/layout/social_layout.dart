import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/social_app/new_post/new_post_screen.dart';
import 'package:social_app/modules/social_app/social_login/social_login_screen.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/network/local/cache_helper.dart';
import 'package:social_app/shared/style/icon_broken.dart';

class SocialLayout extends StatelessWidget {
  const SocialLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if(state is SocialNewPostState){
          navigateTo(context, NewPostScreen());
        }
      },
      builder: (context, state) {

        SocialCubit cubit = SocialCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
                cubit.titles[cubit.currentIndex],
            ),
            actions: [
              IconButton(onPressed: () {

              }, icon: const Icon(
                IconBroken.Notification,
              ),),
              IconButton(onPressed: () {

              }, icon: const Icon(
                IconBroken.Search,
              ),),
              IconButton(onPressed: () {
                FirebaseAuth.instance.signOut();
                CacheHelper.removeDate(key: 'uId').then((value) {
                  if (value) {
                    navigateAndFinish(context,  SocialLoginScreen());
                  }
                });
              }, icon: const Icon(
                IconBroken.Delete,
              ),),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                    IconBroken.Home,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Chat,
                ),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Paper_Upload,
                ),
                label: 'Post',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Setting,
                ),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}

// ConditionalBuilder(
// condition: SocialCubit.get(context).model != null,
// builder: (context) {
// bool model = FirebaseAuth.instance.currentUser!.emailVerified;
// return Column(
// children: [
// if(!model)
// Container(
// color: Colors.amber.withOpacity(.6),
// padding: EdgeInsets.symmetric(horizontal: 20.0),
// child: Row(
// children: [
// Icon(Icons.info_outline),
// SizedBox(width: 15.0,),
// Expanded(
// child: Text(
// 'please verify you email',
// ),
// ),
// SizedBox(width: 15.0,),
// defaultTextButton(
// title: 'send',
// onPressed: (){
// FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value) {
// showToast(
// message: 'check your email',
// state: ToastStates.SUCCESS);
// }).catchError((error){
//
// });
// }),
// ],
// ),
// ),
// ],
// );
// } ,
// fallback: (context) => Center(child: CircularProgressIndicator()),
// ),