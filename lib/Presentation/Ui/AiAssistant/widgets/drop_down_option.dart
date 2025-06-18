import 'package:flutter/material.dart';

class DropdownOption {
  final String value;
  final String displayText;
  final VoidCallback onTap;

  DropdownOption({
    required this.value,
    required this.displayText,
    required this.onTap,
  });
}

class CustomDropdown extends StatelessWidget {
  final String value;
  final bool isOpen;
  final VoidCallback onTap;
  final List<DropdownOption> options;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.isOpen,
    required this.onTap,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              border: Border.all(
                color: isOpen ? const Color(0xFF667eea) : const Color(0xFFe1e5e9),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
              color: isOpen ? Colors.white : const Color(0xFFf8f9fa),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 18),
                ),
                AnimatedRotation(
                  turns: isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
        ),
        if (isOpen)
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFe1e5e9), width: 2),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: options.map((option) {
                  return GestureDetector(
                    onTap: option.onTap,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xFFf8f9fa),
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        option.displayText,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}