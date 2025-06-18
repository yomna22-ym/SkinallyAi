import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../../../Core/Theme/theme.dart';

class PharmacySearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;
  final VoidCallback onClear;
  final String? hintText;
  final bool enabled;

  const PharmacySearchBar({
    Key? key,
    required this.controller,
    required this.onSearch,
    required this.onClear,
    this.hintText,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<PharmacySearchBar> createState() => _PharmacySearchBarState();
}

class _PharmacySearchBarState extends State<PharmacySearchBar> {
  bool _hasFocus = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  void _onSearchChanged(String value) {
    // Debounce search to avoid too many API calls
    Future.delayed(const Duration(milliseconds: 500), () {
      if (widget.controller.text == value) {
        widget.onSearch(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: isDark ? MyTheme.darkBlue : MyTheme.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: _hasFocus
              ? MyTheme.blue
              : (isDark ? Colors.grey.shade600 : Colors.grey.shade300),
          width: _hasFocus ? 2.0 : 1.0,
        ),
        boxShadow: [
          if (_hasFocus)
            BoxShadow(
              color: MyTheme.blue.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Row(
        children: [
          // Search Icon
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Icon(
              Icons.search,
              color: _hasFocus
                  ? MyTheme.blue
                  : (isDark ? Colors.grey.shade400 : Colors.grey.shade500),
              size: 24.w,
            ),
          ),

          // Search TextField
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              enabled: widget.enabled,
              onChanged: _onSearchChanged,
              onSubmitted: widget.onSearch,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? MyTheme.offWhite : MyTheme.darkBlue,
                fontSize: 16.sp,
              ),
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'Search medicines...',
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? Colors.grey.shade400
                      : Colors.grey.shade500,
                  fontSize: 16.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
              ),
            ),
          ),

          // Clear Button
          if (widget.controller.text.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: InkWell(
                onTap: () {
                  widget.controller.clear();
                  widget.onClear();
                  setState(() {});
                },
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  child: Icon(
                    Icons.clear,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                    size: 20.w,
                  ),
                ),
              ),
            ),

          // Voice Search Button (Optional)
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: InkWell(
              onTap: () {
                // Implement voice search if needed
                _showVoiceSearchDialog();
              },
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                padding: EdgeInsets.all(8.w),
                child: Icon(
                  Icons.mic_outlined,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                  size: 20.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showVoiceSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Voice Search'),
        content: const Text('Voice search feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}