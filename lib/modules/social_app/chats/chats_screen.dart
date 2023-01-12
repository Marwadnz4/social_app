import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/modules/social_app/chat_details/chat_details_screen.dart';
import 'package:social_app/shared/components/components.dart';

class SocialChatsScreen extends StatelessWidget {
  const SocialChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        return ConditionalBuilder(
            condition: cubit.users.isNotEmpty,
            builder: (context) => ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (context, index) => myDivider(),
                  itemBuilder: (context, index) =>
                      buildChatItem(cubit.users[index], context),
                  itemCount: cubit.users.length,
                ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget buildChatItem(SocialUserModel model, context) => InkWell(
        onTap: () {
          navigateTo(context, ChatDetailsScreen(userModel: model));
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  '${model.image}',
                ),
                radius: 25.0,
              ),
              const SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Text(
                  '${model.name}',
                  style: const TextStyle(
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
