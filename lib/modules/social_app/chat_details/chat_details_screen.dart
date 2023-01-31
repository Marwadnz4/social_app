import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/social_user_model.dart';
import 'package:social_app/shared/style/colors.dart';
import 'package:social_app/shared/style/icon_broken.dart';

class ChatDetailsScreen extends StatelessWidget {
  ChatDetailsScreen({Key? key, required this.userModel}) : super(key: key);
  final SocialUserModel userModel;
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getMessages(receiverId: userModel.uId!);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            SocialCubit cubit = SocialCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        '${userModel.image}',
                      ),
                      radius: 20.0,
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      '${userModel.name}',
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    ConditionalBuilder(
                      condition: cubit.messages.isNotEmpty,
                      builder: (context) => Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            MessageModel message = cubit.messages[index];

                            if (cubit.userModel!.uId != message.receiverId) {
                              return buildMessage(message, true);
                            }
                            return buildMessage(message, false);
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10.0,
                          ),
                          itemCount: cubit.messages.length,
                        ),
                      ),
                      fallback: (context) => const Spacer(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      padding: const EdgeInsetsDirectional.only(start: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: messageController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'type your message here ...',
                              ),
                            ),
                          ),
                          if (cubit.chatImage != null)
                            Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  height: 140.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.0),
                                    image: DecorationImage(
                                      image: FileImage(cubit.postImage!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    cubit.removeChatImage();
                                  },
                                  icon: const CircleAvatar(
                                    radius: 20.0,
                                    child: Icon(
                                      Icons.close,
                                      size: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          Container(
                            height: 50.0,
                            color: defaultColor,
                            child: MaterialButton(
                              minWidth: 1.0,
                              onPressed: () {
                                SocialCubit.get(context).sendMessage(
                                  receiverId: userModel.uId!,
                                  dateTime: DateTime.now().toString(),
                                  text: messageController.text,
                                );
                                messageController.text = '';
                              },
                              child: const Icon(
                                IconBroken.Send,
                                size: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 1.0,
                          ),
                          Container(
                            height: 50.0,
                            color: defaultColor,
                            child: MaterialButton(
                              minWidth: 1.0,
                              onPressed: () {
                                SocialCubit.get(context).getChatImage();
                              },
                              child: const Icon(
                                IconBroken.Image_2,
                                size: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel model, bool isMe) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 10.0,
            ),
            decoration: BoxDecoration(
              color: isMe ? defaultColor.withOpacity(.2) : Colors.grey[300],
              borderRadius: isMe
                  ? const BorderRadiusDirectional.only(
                      topEnd: Radius.circular(10.0),
                      topStart: Radius.circular(10.0),
                      bottomStart: Radius.circular(10.0),
                    )
                  : const BorderRadiusDirectional.only(
                      topEnd: Radius.circular(10.0),
                      topStart: Radius.circular(10.0),
                      bottomEnd: Radius.circular(10.0),
                    ),
            ),
            child: Text('${model.text}')),
      );
}
