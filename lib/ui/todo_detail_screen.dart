import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/model/todo_detail.dart';

import '../Controller/todo_controller.dart';

class DetailForm extends StatefulWidget {
  const DetailForm({Key? key}) : super(key: key);

  @override
  State<DetailForm> createState() => _DetailFormState();
}

class _DetailFormState extends State<DetailForm> {
  final DetailController detailsController = Get.put(DetailController());
  GlobalKey<FormState> valkey = GlobalKey();

  dynamic argumentData = Get.arguments;
  ToDoDetail? todoData;
  bool isEditable = true;
  bool isDoneVisible = true;
  bool isEditVisible = false;
  bool isDeleteVisible = false;
  bool isItemDeleted = false;

  @override
  void initState() {
    super.initState();
    if (argumentData != null) {
      todoData = argumentData[0]['TodoData'];
      detailsController.uuid = todoData!.id;
      detailsController.titlec.text = todoData!.title;
      detailsController.descrptionc.text = todoData!.description;
      detailsController.selectedPriority = todoData!.priority;
      detailsController.dueDatec.text = todoData!.dueDate;
      detailsController.createdDatec.text = todoData!.createdDate;
    } else {
      detailsController.uuid = "";
      detailsController.titlec.clear();
      detailsController.descrptionc.clear();
      detailsController.dueDatec.clear();
      detailsController.createdDatec.clear();
    }

    if (todoData == null) {
      isEditable = false;
      isDoneVisible = true;
      isEditVisible = false;
      isDeleteVisible = false;
    } else {
      isEditable = true;
      isDoneVisible = false;
      isEditVisible = true;
      isDeleteVisible = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F0F0),
      appBar: AppBar(
        title: Text(
          todoData == null ? "ADD TODO" : todoData!.title.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff3D3542),
        leading: IconButton(
          onPressed: () {
            setState(() {
              Get.back();
              detailsController.selectedPriority = null;
            });
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          Visibility(
            visible: isDoneVisible,
            child: IconButton(
                onPressed: () {
                  if (valkey.currentState!
                      .validate() /*&& detailsController.date.value != 0*/) {
                    /*if(detailsController.date.value == 0) {
                      Get.snackbar('Error','Please Select Due Date');
                      return;
                    }*/

                    if (todoData == null) {
                      detailsController.showNotification();
                      detailsController.addListToDoDetails();
                      detailsController.selectedPriority = null;
                    } else {
                      // detailsController.showNotification();
                      detailsController.updateDetails(todoData!);
                    }
                  } else {
                    Get.snackbar('Error', 'Enter Valid Data');
                  }
                },
                icon: const Icon(Icons.done, color: Colors.white)),
          ),
          Visibility(
            visible: isEditVisible,
            child: IconButton(
                onPressed: () {
                  setState(() {
                    isEditable = false;
                    isDoneVisible = true;
                    isEditVisible = false;
                  });
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                )),
          ),
          Visibility(
            visible: isDeleteVisible,
            child: IconButton(
                onPressed: () async {
                  Get.defaultDialog(
                    backgroundColor: Colors.white,
                    radius: 10,
                    title: '',
                    titleStyle: const TextStyle(fontSize: 0),
                    content: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Are you sure you want to delete this action?",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              )),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10, top: 15),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  "This will delete this task permanently. \nYou cannot undo this action.",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, top: 25, right: 15, bottom: 0),
                                child: SizedBox(
                                  height: 45,
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            side: const BorderSide(
                                                color: Colors.black)),
                                        backgroundColor: Colors.white),
                                    child: const Text("No",
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 0.0, top: 25, right: 15, bottom: 0),
                                child: SizedBox(
                                  height: 45,
                                  width: 100,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      isItemDeleted = true;
                                      detailsController.deleteDetails();
                                      Navigator.of(context).pop();
                                      Get.back(result: [todoData, true]);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            side: const BorderSide(
                                                color: Colors.black)),
                                        backgroundColor: Colors.red),
                                    child: const Text("Yes",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: Obx(
        () => AbsorbPointer(
          absorbing: isEditable,
          child: Form(
            key: valkey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 15, left: 15),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Title : ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 5.0, left: 14, right: 14),
                    child: TextFormField(
                      maxLines: 1,
                      minLines: 1,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: detailsController.titlec,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.black),
                        hintText: "Title",
                        hintStyle: const TextStyle(color: Colors.black38),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (myvalue) {
                        if (myvalue!.isEmpty) {
                          return "Title is required";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 25, left: 15),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Priority : ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 08, left: 14, right: 14),
                    child: Center(
                      child: DropdownButtonFormField2(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            value == null ? 'Field required' : null,
                        isExpanded: true,
                        hint: Row(
                          children: const [
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Text(
                                'Select Priority',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        items: detailsController.item
                            .map(
                              (location) => DropdownMenuItem<String>(
                                value: location,
                                child: Text(
                                  location,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        value: detailsController.selectedPriority,
                        onChanged: (newValue) {
                          setState(() {
                            detailsController.selectedPriority = newValue!;
                            print(detailsController.selectedPriority);
                            // selectedValue = value as String;
                          });
                        },

                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: 380,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            color: Colors.white,
                          ),
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                          ),
                          iconSize: 30,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.grey,
                        ),
                        dropdownStyleData: DropdownStyleData(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            elevation: 8,
                            scrollbarTheme: ScrollbarThemeData(
                              radius: const Radius.circular(40),
                              thickness: MaterialStateProperty.all(6),
                              thumbVisibility: MaterialStateProperty.all(true),
                            )),
                        menuItemStyleData: const MenuItemStyleData(
                          height: 40,
                          padding: EdgeInsets.only(left: 14, right: 14),
                        ),

                        // decoration:  const InputDecoration(
                        //   border: InputBorder.none,
                        //
                        // ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15, left: 15),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Task Description : ",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 14, right: 14, top: 5),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: detailsController.descrptionc,
                      maxLines: 6,
                      minLines: 5,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(5.5),
                        ),
                        hintText: "Description",
                        hintStyle: const TextStyle(
                          color: Colors.black38,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (myvalue) {
                        if (myvalue!.isEmpty) {
                          return "Descrption is requried";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 12, left: 12, top: 20),
                    child: GestureDetector(
                      onTap: () {
                        detailsController.selectDate();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Card(
                            shadowColor: Colors.white,
                            elevation: 0.1,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 14, left: 14),
                                  child: Row(
                                    children: [
                                      const Text(
                                        "Due Date : ",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        DateFormat('dd/MM/yyyy').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                detailsController.date.value)),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 120,
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Icon(Icons.calendar_month),
                                ),
                              ],
                            ),
                          )
                        ],
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
