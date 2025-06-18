import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../Core/Base/base_state.dart';
import '../../../Core/Theme/theme.dart';
import '../../../Core/routes_manager/routes.dart';
import 'chat_view_model.dart';
import 'package:intl/intl.dart';

class ChatView extends StatefulWidget {
  final String userName;
  final String userAge;
  final String skinType;
  final String bodyArea;
  final String? diagnosis;
  final String gender;

  const ChatView({
    super.key,
    required this.userName,
    required this.userAge,
    required this.skinType,
    required this.bodyArea,
    this.diagnosis,
    required this.gender,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends BaseState<ChatView, ChatViewModel> {
  final ScrollController _scrollController = ScrollController();

  @override
  ChatViewModel initViewModel() {
    return ChatViewModel(
      userName: widget.userName,
      userAge: widget.userAge,
      skinType: widget.skinType,
      bodyArea: widget.bodyArea,
      diagnosis: widget.diagnosis,
      gender: widget.gender,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ChangeNotifierProvider.value(
      value: viewModel,
      child: Consumer<ChatViewModel>(
        builder: (context, vm, child) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => _scrollToBottom(),
          );

          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  _buildChatList(vm),
                  _buildInputArea(vm),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFF007AFF)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushNamed(context, Routes.homeRoute),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: const Text(
                  ' AI Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(ChatViewModel vm) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFFF5F7FA), const Color(0xFFE4ECF7)],
          ),
        ),
        child: ListView.builder(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          itemCount: vm.messages.length + (vm.isTyping ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < vm.messages.length) {
              final message = vm.messages[index];
              return _buildMessageBubble(
                isUser: message.sender == 'user',
                message: message.content,
                timestamp: message.timestamp,
              );
            } else {
              return _buildTypingIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget _buildMessageBubble({
    required bool isUser,
    required String message,
    required DateTime timestamp,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser)
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage("Assets/Images/done skin.png"),
            ),
          if (!isUser) SizedBox(width: 8.w),
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF007AFF) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft: Radius.circular(isUser ? 16.r : 4.r),
                  bottomRight: Radius.circular(isUser ? 4.r : 16.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: isUser ? Colors.white : Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      DateFormat('hh:mm a').format(timestamp),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: isUser ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isUser) SizedBox(width: 8.w),
          if (isUser)
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade200,
              child: const Text('👤'),
            ),
        ],
      ),
    );
  }

  Widget _buildInputArea(ChatViewModel vm) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: TextField(
                controller: vm.messageController,
                decoration: InputDecoration(
                  hintText: "Type your message...",
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => vm.sendMessage(),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF007AFF), Color(0xFF4A90E2)],
              ),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon:
                  vm.isTyping
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : const Icon(Icons.send, color: Colors.white),
              onPressed: vm.isTyping ? null : vm.sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return const Padding(
      padding: EdgeInsets.only(left: 16, bottom: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "The assistant is typing...",
          style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
