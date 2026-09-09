import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Demonstrates registration locally without storing or sending form values.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const _leaf = Color(0xFF2F7448);
  static const _bone = Color(0xFFF7F6EF);
  static const _ink = Color(0xFF1C3828);
  static const _muted = Color(0xFF718076);
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    _formKey.currentState!.reset();
    Navigator.of(context).pop(true);
  }

  void _showTerms() {
    FocusScope.of(context).unfocus();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: const Text('เงื่อนไขสำหรับโหมดทดลอง'),
        content: const SingleChildScrollView(
          child: Text(
            'หน้านี้ใช้ทดลองขั้นตอนสมัครสมาชิกเท่านั้น ไม่สร้างบัญชีจริง '
            'และไม่ส่งหรือบันทึกข้อมูลที่กรอกลงฐานข้อมูลหรือพื้นที่จัดเก็บของแอป\n\n'
            'กรุณาใช้ชื่อ อีเมล และรหัสผ่านสมมติ ข้อมูลในฟอร์มจะถูกล้างเมื่อออกจากหน้านี้ '
            'หรือทดลองสมัครสำเร็จ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('ปิด'),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required String label,
    required String hint,
    required FormFieldValidator<String> validator,
    bool password = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4A6657),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          key: ValueKey(label),
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: password
              ? TextInputAction.done
              : TextInputAction.next,
          onFieldSubmitted: password ? (_) => _register() : null,
          obscureText: password && _obscurePassword,
          autocorrect: false,
          enableSuggestions: false,
          style: const TextStyle(color: _ink, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF91A097), fontSize: 15),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFD4DED3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: _leaf, width: 2),
            ),
            errorMaxLines: 3,
            suffixIcon: password
                ? IconButton(
                    tooltip: _obscurePassword ? 'แสดงรหัสผ่าน' : 'ซ่อนรหัสผ่าน',
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: _muted,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: _bone,
      ),
      child: Scaffold(
        backgroundColor: _bone,
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(28, 24, 28, 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            tooltip: 'กลับ',
                            onPressed: () => Navigator.of(context).maybePop(),
                            icon: const Icon(Icons.arrow_back, color: _leaf),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'ISANOSAURUS',
                              style: TextStyle(
                                color: _leaf,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'สร้างบัญชีใหม่',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          height: 1.4,
                        ),
                      ),
                      const Text(
                        'เริ่มสะสมความรู้เกี่ยวกับอีสานโนซอรัสในแบบของคุณ',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'โหมดทดลอง • กรุณาใช้ข้อมูลสมมติ',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _field(
                        label: 'ชื่อผู้ใช้',
                        hint: 'ชื่อที่ต้องการแสดง',
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'กรุณากรอกชื่อผู้ใช้'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      _field(
                        label: 'อีเมล',
                        hint: 'name@example.com',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          final email = value?.trim() ?? '';
                          if (email.isEmpty) return 'กรุณากรอกอีเมล';
                          return RegExp(
                                r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                              ).hasMatch(email)
                              ? null
                              : 'กรุณากรอกอีเมลให้ถูกต้อง';
                        },
                      ),
                      const SizedBox(height: 20),
                      _field(
                        label: 'รหัสผ่าน',
                        hint: 'อย่างน้อย 8 ตัวอักษร',
                        password: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'กรุณากรอกรหัสผ่าน';
                          }
                          return value.characters.length < 8
                              ? 'รหัสผ่านต้องมีอย่างน้อย 8 ตัวอักษร'
                              : null;
                        },
                      ),
                      const SizedBox(height: 16),
                      FormField<bool>(
                        initialValue: false,
                        validator: (value) => value == true
                            ? null
                            : 'กรุณายอมรับเงื่อนไขก่อนทดลองสมัครสมาชิก',
                        builder: (field) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: _leaf,
                              value: field.value ?? false,
                              onChanged: (value) {
                                field.didChange(value ?? false);
                                if (field.hasError) field.validate();
                              },
                              title: const Text(
                                'ยอมรับเงื่อนไขการใช้งานและนโยบายความเป็นส่วนตัว',
                                style: TextStyle(
                                  color: _muted,
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            if (field.hasError)
                              Text(
                                field.errorText!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            TextButton(
                              onPressed: _showTerms,
                              child: const Text('อ่านเงื่อนไขสำหรับโหมดทดลอง'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _register,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(0, 58),
                            backgroundColor: _leaf,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: const Text('สมัครสมาชิก'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          child: const Text(
                            'มีบัญชีอยู่แล้ว? เข้าสู่ระบบ',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
