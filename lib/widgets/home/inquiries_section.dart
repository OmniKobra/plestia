import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../general.dart';
import 'mytextfield.dart';

class InquirySection extends StatefulWidget {
  const InquirySection({super.key});

  @override
  State<InquirySection> createState() => _InquirySectionState();
}

class _InquirySectionState extends State<InquirySection> {
  final firestore = FirebaseFirestore.instance;
  bool sent = false;
  bool isLoading = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Widget buildField(
      {required bool widthQuery,
      required bool isSubject,
      required controller,
      required validator,
      required label,
      required minLines,
      required maxLines,
      required maxLength}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: isSubject ? 150 : 75,
      width: isSubject
          ? widthQuery
              ? 405
              : 300
          : widthQuery
              ? 200
              : 150,
      child: MyTextField(
          controller: controller,
          validator: validator,
          label: label,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength),
    );
  }

  Future<void> sendInquiry() async {
    if (!isLoading && !sent) {
      setState(() {
        isLoading = true;
      });
      var batch = firestore.batch();
      final name = nameController.value.text.trim();
      final email = emailController.value.text.trim();
      final subject = subjectController.value.text.trim();
      final doc = firestore.collection('inquiries').doc();
      batch.set(doc, {'name': name, 'email': email, 'subject': subject});
      return batch.commit().then((value) {
        isLoading = false;
        sent = true;
        nameController.clear();
        emailController.clear();
        subjectController.clear();
        setState(() {});
      }).catchError((_) {
        isLoading = false;
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    subjectController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = General.language(context);
    String? emailValidator(String? value) {
      final RegExp exp2 = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      if (value!.isEmpty ||
          value.replaceAll(' ', '') == '' ||
          value.trim() == '') return lang.inquiries1;
      if (value.length > 100) return lang.inquiries3;
      if (!exp2.hasMatch(value)) return lang.inquiries2;
      if (exp2.hasMatch(value)) return null;
      return null;
    }

    String? nameValidator(String? value) {
      final RegExp exp2 = RegExp(r"^[a-zA-z ]+$", caseSensitive: false);
      if (value!.isEmpty ||
          value.replaceAll(' ', '') == '' ||
          value.trim() == '') return lang.inquiries4;
      if (value.length < 2 || value.length > 50) return lang.inquiries5;
      if (!exp2.hasMatch(value)) return lang.inquiries6;
      if (exp2.hasMatch(value)) return null;
      return null;
    }

    String? subjectValidator(String? value) {
      if (value!.isEmpty ||
          value.replaceAll(' ', '') == '' ||
          value.trim() == '') return lang.inquiries7;
      return null;
    }

    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final deviceWidth = MediaQuery.of(context).size.width;
    final widthQuery = deviceWidth >= 800;
    return Form(
      key: formKey,
      child: Container(
        width: deviceWidth,
        // height: 400,
        padding: const EdgeInsets.all(8),
        color: Colors.grey.shade50,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        lang.inquiries12,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: widthQuery ? 22 : 17),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildField(
                        widthQuery: widthQuery,
                        controller: nameController,
                        isSubject: false,
                        validator: nameValidator,
                        label: lang.inquiries8,
                        minLines: 1,
                        maxLines: 1,
                        maxLength: 50),
                    Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: buildField(
                          widthQuery: widthQuery,
                          controller: emailController,
                          isSubject: false,
                          validator: emailValidator,
                          label: lang.inquiries9,
                          minLines: 1,
                          maxLines: 1,
                          maxLength: 100),
                    )
                  ],
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  buildField(
                      widthQuery: widthQuery,
                      controller: subjectController,
                      validator: subjectValidator,
                      isSubject: true,
                      label: lang.inquiries10,
                      minLines: 5,
                      maxLines: 10,
                      maxLength: 500)
                ]),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          if (!sent) {
                            if (formKey.currentState!.validate() &&
                                !sent &&
                                !isLoading) {
                              sendInquiry();
                            } else {}
                          }
                        },
                        style: ButtonStyle(
                            splashFactory: NoSplash.splashFactory,
                            elevation: MaterialStateProperty.all<double?>(0),
                            shape: MaterialStateProperty.all<OutlinedBorder?>(
                                const BeveledRectangleBorder()),
                            backgroundColor: MaterialStateProperty.all<Color?>(
                                sent ? primaryColor : secondaryColor)),
                        child: isLoading
                            ? const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                sent ? lang.inquiries13 : lang.inquiries11,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: widthQuery ? 17 : 13),
                              ))
                  ],
                )
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
