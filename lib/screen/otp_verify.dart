import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for FilteringTextInputFormatter

class OtpVerify extends StatefulWidget {
  const OtpVerify({Key? key}) : super(key: key);

  @override
  State<OtpVerify> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerify> {
  // Controllers for each digit input field
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();

  // Focus nodes for shifting focus between fields
  final FocusNode _focusOne = FocusNode();
  final FocusNode _focusTwo = FocusNode();
  final FocusNode _focusThree = FocusNode();
  final FocusNode _focusFour = FocusNode();

  // Combined OTP string
  String? _otp;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Timer logic
  int _start = 60; // Countdown from 60 seconds
  late Timer _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _start = 60; // Reset timer
    _canResend = false; // Cannot resend while timer is active
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _canResend = true; // Can resend once timer finishes
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _fieldOne.dispose();
    _fieldTwo.dispose();
    _fieldThree.dispose();
    _fieldFour.dispose();
    _focusOne.dispose();
    _focusTwo.dispose();
    _focusThree.dispose();
    _focusFour.dispose();
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  // Widget for a single OTP input field
  Widget _otpTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required FocusNode? nextFocusNode,
    required FocusNode? previousFocusNode,
    bool autoFocus = false,
  }) {
    return SizedBox(
      width: 60, // Adjust width as needed
      height: 60, // Adjust height as needed
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1), // Only one digit per field
        ],
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.green), // Default border color
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.grey), // Border when not focused
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.green, width: 2), // Border when focused
          ),
          filled: true,
          fillColor: Colors.white,
          counterText: "", // Hide character counter
        ),
        onChanged: (value) {
          if (value.length == 1) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              focusNode.unfocus(); // Unfocus if it's the last field
            }
          } else if (value.isEmpty) {
            if (previousFocusNode != null) {
              FocusScope.of(context).requestFocus(previousFocusNode);
            }
          }
          setState(() {
            _otp = _fieldOne.text + _fieldTwo.text + _fieldThree.text + _fieldFour.text;
          });
        },
        validator: (value) {
          if (_otp == null || _otp!.length < 4) {
            return ''; // We'll handle overall validation in the button
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // You can retrieve the email/phone number passed from ForgotPasswordPage like this:
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String? emailOrPhone = args?['email'] ?? 'your phone number'; // Default if not passed

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "OTP Verification",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      text: "Enter the four digit code sent to ",
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      children: [
                        TextSpan(
                          text: emailOrPhone != null && emailOrPhone.contains('@') 
                                ? emailOrPhone 
                                : "+91 85858 85858", // Display phone number if not an email
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _otpTextField(
                        controller: _fieldOne,
                        focusNode: _focusOne,
                        nextFocusNode: _focusTwo,
                        previousFocusNode: null,
                        autoFocus: true, // Auto-focus the first field
                      ),
                      _otpTextField(
                        controller: _fieldTwo,
                        focusNode: _focusTwo,
                        nextFocusNode: _focusThree,
                        previousFocusNode: _focusOne,
                      ),
                      _otpTextField(
                        controller: _fieldThree,
                        focusNode: _focusThree,
                        nextFocusNode: _focusFour,
                        previousFocusNode: _focusTwo,
                      ),
                      _otpTextField(
                        controller: _fieldFour,
                        focusNode: _focusFour,
                        nextFocusNode: null,
                        previousFocusNode: _focusThree,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Resend text and timer
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text.rich(
                      TextSpan(
                        text: "Resend via SMS ",
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                        children: [
                          TextSpan(
                            text: _canResend ? "Resend" : "00:$_start".padLeft(5, '0'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _canResend ? Colors.green : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_otp != null && _otp!.length == 4) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("OTP Entered: $_otp")),
                            );
                            // TODO: Add your OTP verification logic here
                            // On successful verification, navigate to reset password or home
                            // Navigator.pushReplacementNamed(context, '/reset_password');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please enter a 4-digit OTP.")),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "Verify",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}