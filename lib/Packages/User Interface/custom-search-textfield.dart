import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({Key? key}) : super(key: key);

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  var searchController; // controller for the search textfield

@override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child:
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: TextField(
                    controller: searchController,
                    textInputAction: TextInputAction.send,
                    cursorColor: Colors.black,
                    minLines: 1,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.transparent,
                            width: 0,
                            style: BorderStyle.none),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      hintText: 'Search Chats',
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                    ),
                  ),
                ),
                searchController.text.isEmpty
                    ? Container()
                    : Expanded(
                  child: GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        searchController.clear();
                      },
                      child: const Icon(Icons.cancel)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
