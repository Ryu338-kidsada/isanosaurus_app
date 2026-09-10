import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'register_page.dart';
import '../home/home_page.dart';

/// A local demo form. No credentials are persisted or authenticated.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const _leaf = Color(0xFF2F7448);
  static const _bone = Color(0xFFF7F6EF);
  static const _ink = Color(0xFF1C3828);
  static const _muted = Color(0xFF718076);
  static const _border = Color(0xFFD4DED3);
  final _formKey = GlobalKey<FormState>();
  final _password = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    _openHome();
  }

  void _openHome() {
    FocusScope.of(context).unfocus();
    _password.clear();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const HomePage()));
  }

  Future<void> _openRegistration() async {
    FocusScope.of(context).unfocus();
    _password.clear();
    final completed = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const RegisterPage()));
    if (!mounted || completed != true) return;
    _showMessage('ทดลองสมัครสมาชิกสำเร็จ ไม่มีการสร้างบัญชีหรือบันทึกข้อมูล');
  }

  InputDecoration _decoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF91A097), fontSize: 15),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: _leaf, width: 2),
      ),
      errorMaxLines: 2,
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
          child: Center(
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
                      const SizedBox(height: 32),
                      const Text(
                        'ยินดีต้อนรับกลับ',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          height: 1.4,
                        ),
                      ),
                      const Text(
                        'เข้าสู่ระบบเพื่อเดินทางต่อในโลกของไดโนเสาร์',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'โหมดทดลอง • ไม่มีการบันทึกบัญชีหรือรหัสผ่าน',
                        style: TextStyle(
                          color: _muted,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      const _FieldLabel('อีเมล'),
                      TextFormField(
                        decoration: _decoration('name@example.com'),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        enableSuggestions: false,
                        validator: (value) {
                          final email = value?.trim() ?? '';
                          if (email.isEmpty) return 'กรุณากรอกอีเมล';
                          if (!RegExp(
                            r'^[^\s@]+@[^\s@]+\.[^\s@]+$',
                          ).hasMatch(email)) {
                            return 'กรุณากรอกอีเมลให้ถูกต้อง';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const _FieldLabel('รหัสผ่าน'),
                      TextFormField(
                        controller: _password,
                        obscureText: _obscurePassword,
                        autocorrect: false,
                        enableSuggestions: false,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _login(),
                        decoration: _decoration(
                          '••••••••',
                          suffixIcon: IconButton(
                            tooltip: _obscurePassword
                                ? 'แสดงรหัสผ่าน'
                                : 'ซ่อนรหัสผ่าน',
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: _muted,
                            ),
                          ),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'กรุณากรอกรหัสผ่าน'
                            : null,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => _showMessage(
                            'โหมดทดลองไม่มีบัญชีที่บันทึกไว้ คุณสามารถเข้าใช้งานแบบผู้เยี่ยมชมได้',
                          ),
                          child: const Text('ลืมรหัสผ่าน?'),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: FilledButton(
                          onPressed: _login,
                          style: FilledButton.styleFrom(
                            backgroundColor: _leaf,
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: const Text('เข้าสู่ระบบ'),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Row(
                          children: [
                            Expanded(child: Divider(color: _border)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'หรือ',
                                style: TextStyle(color: _muted),
                              ),
                            ),
                            Expanded(child: Divider(color: _border)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _openHome,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 56),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: _ink,
                            side: const BorderSide(color: _border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'เข้าใช้งานแบบผู้เยี่ยมชม',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      Center(
                        child: TextButton(
                          onPressed: _openRegistration,
                          child: const Text(
                            'ยังไม่มีบัญชี? สมัครสมาชิก',
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        color: Color(0xFF4A6657),
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
