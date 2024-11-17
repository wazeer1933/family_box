import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_box/main.dart';
import 'package:family_box/src/core/Colors.dart';
import 'package:family_box/src/feature/Authentecation/Contollers/ControllerSeginin.dart';
import 'package:family_box/src/feature/Dashbord/Model/ModelTreeUsers.dart';
// import 'package:family_box/src/feature/Dashbord/View/PageAddAction.dart';
import 'package:family_box/src/feature/Dashbord/Widgets/widgetdropDwon2.dart';
import 'package:family_box/src/feature/Profile/View/DetilesUserProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:graphview/GraphView.dart';
import 'package:multi_dropdown/models/value_item.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class WidgetTreeFmailyUsers extends StatefulWidget {
  @override
  _WidgetTreeFmailyUsersState createState() => _WidgetTreeFmailyUsersState();
}

double _scale = 1.0;
double _previousScale = 1.0;

class _WidgetTreeFmailyUsersState extends State<WidgetTreeFmailyUsers> {
  // final String jsonData = '''
  // {
    // "family": [
    //   {
    //     "id": "1",
    //     "name": "الشخص 1",
    //     "birthDate": "1950-01-01",
    //     "gender": "ذكر",
    //     "children": [
    //       {
    //         "id": "11",
    //         "name": "الشخص 11",
    //         "birthDate": "1975-05-05",
    //         "gender": "ذكر",
    //         "children": [
    //           {
    //             "id": "111",
    //             "name": "الشخص 111",
    //             "birthDate": "2000-01-01",
    //             "gender": "ذكر",
    //             "children": [
    //               {
    //                 "id": "1111",
    //                 "name": "الشخص 1111",
    //                 "birthDate": "2025-01-01",
    //                 "gender": "ذكر",
    //                 "children": []
    //               },
    //               {
    //                 "id": "1112",
    //                 "name": "الشخص 1112",
    //                 "birthDate": "2027-01-01",
    //                 "gender": "أنثى",
    //                 "children": []
    //               }
    //             ]
    //           },
    //           {
    //             "id": "112",
    //             "name": "الشخص 112",
    //             "birthDate": "2002-01-01",
    //             "gender": "أنثى",
    //             "children": [
    //               {
    //                 "id": "1121",
    //                 "name": "الشخص 1121",
    //                 "birthDate": "2028-01-01",
    //                 "gender": "أنثى",
    //                 "children": []
    //               }
    //             ]
    //           }
    //         ]
    //       },
    //       {
    //         "id": "12",
    //         "name": "الشخص 12",
    //         "birthDate": "1980-01-01",
    //         "gender": "أنثى",
    //         "children": [
    //           {
    //             "id": "121",
    //             "name": "الشخص 121",
    //             "birthDate": "2003-01-01",
    //             "gender": "ذكر",
    //             "children": []
    //           },
    //           {
    //             "id": "122",
    //             "name": "الشخص 122",
    //             "birthDate": "2005-01-01",
    //             "gender": "أنثى",
    //             "children": []
    //           }
    //         ]
    //       },
    //       {
    //         "id": "13",
    //         "name": "الشخص 13",
    //         "birthDate": "1985-01-01",
    //         "gender": "ذكر",
    //         "children": [
    //           {
    //             "id": "131",
    //             "name": "الشخص 131",
    //             "birthDate": "2010-01-01",
    //             "gender": "ذكر",
    //             "children": []
    //           },
    //           {
    //             "id": "132",
    //             "name": "الشخص 132",
    //             "birthDate": "2012-01-01",
    //             "gender": "أنثى",
    //             "children": []
    //           },
    //           {
    //             "id": "133",
    //             "name": "الشخص 133",
    //             "birthDate": "2015-01-01",
    //             "gender": "ذكر",
    //             "children": []
    //           }
    //         ]
    //       }
    //     ]
    //   },
    //   {
    //     "id": "2",
    //     "name": "الشخص 2",
    //     "birthDate": "1952-01-01",
    //     "gender": "أنثى",
    //     "children": [
    //       {
    //         "id": "21",
    //         "name": "الشخص 21",
    //         "birthDate": "1976-01-01",
    //         "gender": "أنثى",
    //         "children": [
    //           {
    //             "id": "211",
    //             "name": "الشخص 211",
    //             "birthDate": "2001-01-01",
    //             "gender": "أنثى",
    //             "children": []
    //           },
    //           {
    //             "id": "212",
    //             "name": "الشخص 212",
    //             "birthDate": "2004-01-01",
    //             "gender": "ذكر",
    //             "children": []
    //           }
    //         ]
    //       },
    //       {
    //         "id": "22",
    //         "name": "الشخص 22",
    //         "birthDate": "1981-01-01",
    //         "gender": "ذكر",
    //         "children": []
    //       }
    //     ]
    //   }
    // ]
  // }
  // ''';



List<FamilyMember> buildTree(List<Map<String, dynamic>> members) {
  // Create a map for easy lookup of members by ID
  Map<String, FamilyMember> memberMap = {
    for (var member in members) member['id']: FamilyMember.fromMap(member)
  };

  List<FamilyMember> roots = [];

  // Build the tree structure
  for (var member in members) {
    FamilyMember current = memberMap[member['id']]!;
    String parentId = current.id.length > 1 ? current.id.substring(0, current.id.length - 1) : '';

    if (parentId.isNotEmpty && memberMap.containsKey(parentId)) {
      // If a parent is found, add this member to the parent's children list
      memberMap[parentId]!.children.add(current);
    } else {
      // If no parent is found, it's a root member
      roots.add(current);
    }
  }

  return roots;
}

String? newJson;
 String? jsonDataFamilyUsers;

dsf(){
 Map<String, dynamic> parsedJson = json.decode(jsonDataFamilyUsers!);
  List<Map<String, dynamic>> familyMembers = List<Map<String, dynamic>>.from(parsedJson['family']);

  // Build the tree
  List<FamilyMember> familyTree = buildTree(familyMembers);

  // Convert the tree to a JSON-like structure and print it
  List<Map<String, dynamic>> treeJson = familyTree.map((member) => member.toMap()).toList();
  newJson='''{"family":${json.encode(treeJson)}}''';
  print(newJson);
  setState(() {
    parseFamilyTree(newJson!);
    
  });
  // print(json.encode(treeJson));

}


  List<Map<String, dynamic>> familyData = [];
  final _formKey = GlobalKey<FormState>();
   String? UidUserAddTree;
 // ignore: non_constant_identifier_names
 bool  Loding=true;
 Future<void> fetchFamilyData() async {
      Loding=true;
    try {
      // Replace 'your_collection_name' with your actual collection name
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').where('tree',isNotEqualTo: '').get();
      setState(() {
        familyData = snapshot.docs.map((doc) {
          return {
            "id": doc['tree'],
            "name": doc['name'],
            "birthDate": doc['dateBithe'],
            "gender":doc['gender'],
            "image":doc['image'],
            "uid":doc['uid'],
          };
        }).toList();
      });

      // Convert to JSON
       jsonDataFamilyUsers= json.encode({"family": familyData});
      print(jsonDataFamilyUsers); // Print or use the JSON as needed
dsf();
    } catch (e) {
      print("Error fetching family data: $e");
    }
  }

  Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();
  final TextEditingController searchController = TextEditingController();
  Node? highlightedNode;

  @override
  void initState() {
    fetchFamilyData();
    fetchUsers();
    super.initState();
    builder
      ..siblingSeparation = (50)
      ..levelSeparation = (50)
      ..subtreeSeparation = (10)
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
  }
  void parseFamilyTree(String jsonData) {
    var familyData = json.decode(jsonData);
    var family = familyData['family'] as List;

    for (var member in family) {
      var root = Node.Id(member['id']);
      graph.addNode(root);
      addChildren(root, member['children']);
    }
    setState(() {
    Loding=false;
      
    });
  }

  void addChildren(Node parent, List<dynamic> children) {
    for (var child in children) {
      var childNode = Node.Id(child['id']);
      graph.addNode(childNode);
      graph.addEdge(parent, childNode);
      if (child['children'].isNotEmpty) {
        addChildren(childNode, child['children']);
      }
    }
  }

  void searchNode(String query) {
    setState(() {
      highlightedNode = null;
      graph.nodes.forEach((node) {
        var member = findMemberById(node.key!.value as String);
        // ignore: unused_local_variable
        String id=member['id'];String name=member['name'];
        // if (member['id'] == query || member['name'] == query.trim()) {
        //   highlightedNode = node;
        // }
        //  if (id.trim() == query.trim() || name.trim()== query.trim()) {
        //   highlightedNode = node;
        // }
        if (query.trim().contains(id.trim())||  name.trim().contains(query.trim())) {
          highlightedNode = node;
        }
      });
    });
  }
int? newChildId;
///////////////////////////////////////////////////////
  var userList = <ValueItem>[];
 
 void fetchUsers() async {
    try {
      // Fetch data from Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').where('tree',isEqualTo:"").where('IsAcsept',isEqualTo: true).get();

      // Map data to ValueItem list
      var users = querySnapshot.docs.map((doc) {
        String name = doc['name'];
        String uid = doc['uid'];
        String image = doc['image'];
        String tree = doc['tree'];
        // You can include other fields such as 'numberuser' or 'image_url' if needed
        return ValueItem(label: name+tree, value:User(image: image, uid: uid, tree: tree));
        // return ValueItem(label: name, value:uid);

      }).toList();
      userList.addAll(users);
      print(userList);
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
       print("=======================");
    }

  }
  ///////////////////////////////////////////////////////////
  Future<void> updateUserTree(String userId, String newTree) async {
    if(connected==true){
  try {
      await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
    // Reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the user's document
    DocumentReference userDoc = firestore.collection('users').doc(userId);

    // Update the tree structure in the user's document
    await userDoc.update({
      'tree': newTree,
      'updateDate':DateTime.now()
    });
    EasyLoading.dismiss();
      Navigator.of(context).pop();
    snackBar('تم الاضافة بنجاح', context);
      fetchFamilyData();
      fetchUsers();
      userList.removeWhere((element) => element.value.uid==userId);
      setState(() {});
  } catch (e) {
    print('Failed to update user tree: $e');
  }
    }else{
      SnackbarNointernet();
    }
}

/////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////
  Future<void> DeleletUserFromTree(String userId) async {
    if(connected==true){
  try {
      await EasyLoading.show(
        status: '...انتظر',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
    // Reference to the Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the user's document
    DocumentReference userDoc = firestore.collection('users').doc(userId);

    // Update the tree structure in the user's document
    await userDoc.update({
      'tree': '',
      'updateDate':DateTime.now()
    });
    EasyLoading.dismiss();
      Navigator.of(context).pop();
    snackBar('تم حذف المستخدم من الشجرة بنجاح', context);
      fetchFamilyData();
      fetchUsers();

  } catch (e) {
    print('Failed to update user tree: $e');
  }
    }else{
      SnackbarNointernet();
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading :false,
        actions: [
         Container(
          decoration: BoxDecoration(
          color: AppColors().grayshade300,
          borderRadius: BorderRadius.circular(10),
          border:Border.all(color: AppColors().grayshade300)
          ),
          margin: EdgeInsets.only(right: 5),
           child: Row(children: [
              IconButton(
                    onPressed: () {
                      setState(() {
                        _scale *= 1.5;
                      });
                    },
                    icon: Icon(Icons.add_circle,color: AppColors().darkGreen,),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _scale /= 1.5;
                      });
                    },
                    icon: Icon(Icons.remove_circle,color: AppColors().darkGreen,),
                  )
           ],),
         )
        ],
        
        title: TextFormField(
          controller: searchController,
          textAlign:TextAlign.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors().grayshade300,
            contentPadding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            hintText: '...ابحث عن مستخدم في الشجرة',
            hintStyle: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.black),
              disabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors().lighBrown),
              borderRadius: BorderRadius.circular(8.0),
            ),
            border: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors().lighBrown),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder:  OutlineInputBorder(
              borderSide: BorderSide(color: AppColors().darkGreen),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onFieldSubmitted: searchNode,
          onChanged: (value) {
            searchNode(value);
          },
        ),
      ),
      body: GestureDetector(
        onScaleStart: (ScaleStartDetails details) {
          _previousScale = _scale;
        },
        onScaleUpdate: (ScaleUpdateDetails details) {
          setState(() {
            _scale = _previousScale * details.scale;
            if (_scale < 0.5) _scale = 0.5;
          });
        },
        onScaleEnd: (ScaleEndDetails details) {
          _previousScale = 1.0;
        },
        child: Loding==true?Center(child: CircularProgressIndicator()):
        InteractiveViewer(
          scaleEnabled: true,
          transformationController: TransformationController()
            ..value = Matrix4.diagonal3Values(_scale, _scale, 1),
          constrained: false,
          boundaryMargin: EdgeInsets.all(100),
          minScale: 0.01,
          maxScale: 5.6,
          child: Container(
            child: GraphView(
              graph: graph,
              algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
              builder: (Node node) {
                var memberId = node.key!.value as String;
                return GestureDetector(
                  onTap: () {
                    var member = findMemberById(memberId);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsProfileScreen(member['uid'])));
                    
                    print('Tapped on: ${member['name']}');
                  },
                  child: rectangleWidget(memberId, node == highlightedNode),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
// Function to get a new ID for a tree node.
// If the parent ID has no children, it will add a new child.
int getNewChildId(int parentId, List<int> childIds) {
  // Check if the parentId has children in the list
  bool hasChildren = childIds.isNotEmpty;

  if (hasChildren) {
    // If the parent already has children, return the next child ID
    return childIds.last + 1;
  } else {
    // If the parent has no children, create the first child ID
    return parentId * 10 + 1;
  }
}
 var UserTreeNumber=currentUserData[0]['tree']??'';
  Widget rectangleWidget(String memberId, bool isHighlighted) {
    var member = findMemberById(memberId);
    return Container(
    padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        
        color: isHighlighted ?AppColors().darkGreen : Colors.white24,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
           if(member['id']==UserTreeNumber||member['id'].contains(UserTreeNumber)||currentUserData[0]['isAdmin']==true)  Column(mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: (){
                    print(member['id']);
                    print(UserTreeNumber);
                       List<dynamic> children = member['children'] ?? [];
                       List<int> dd=children.map((child) => int.parse(child['id'])).toList();
                    print(' ${children.map((child) => child['id']).toList()}');
                      newChildId = getNewChildId(int.parse(member['id']), dd);
                     print('New child ID: $newChildId');
                           showDialog(context: context, builder: (context){
                            return AlertDialog(title: Center(child: Text('اضافة الئ الشجرة ',style: TextStyle(color: AppColors().darkGreen),)),
                            content: Container(width: double.infinity,height: 100,child: Form(
                              key: _formKey,
                              child: 
                            DropDwonWithImage(
                    
                    hitText: 'اختارالشخص ',
                    LabelValue: 'اختارالشخص ',
                    hitTextStyle: TextStyle(),
                    options: userList.toList(),
                    onOptionSelected: <User>(List<ValueItem<dynamic>> selectedOptions) {
                      for(var option in selectedOptions){
                        option.label==' ';
                        UidUserAddTree=option.value.uid;
                        print(UidUserAddTree);
                       setState(() {});
                       }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى اختيار الشخص  ';
                      }
                      return null;
                    }, searchEnabled: true, selectionType: SelectionType.single,
                  ),
                            
                            ),),
                            actions: [
                              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                                   ElevatedButton(
                                  onPressed: (){Navigator.of(context).pop();}, child: Text("الغاء",style: TextStyle(color:Colors.red),)),
                                                              ElevatedButton(
                                  onPressed: (){
                                     if (_formKey.currentState?.validate() ?? false) {
                           
                                      updateUserTree(UidUserAddTree!, newChildId.toString());
                                    }
                                  }, child: Text("اضافة",style: TextStyle(color: AppColors().darkGreen),)),
                              ],)
                            ],
                            );
                           });
                  }, icon: Icon(Icons.add_circle_outline,color: AppColors().darkGreen,)),
                  IconButton(onPressed: (){
                       List<dynamic> children = member['children'] ?? [];
                       // ignore: unnecessary_null_comparison
                       if(children.isEmpty){
                        showDialog(context: context, builder: (context)=>AlertDialog(
                          
                          content: Container(
                            height: 70,width: double.maxFinite,
                            child: Center(child: Text("هل تريد حذف ${member['name']} من الشجرة",textDirection: TextDirection.rtl,style: TextStyle(color: AppColors().darkGreen,fontWeight: FontWeight.bold),),)),
                          actions: [
                             Row(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                                   ElevatedButton(
                                  onPressed: (){Navigator.of(context).pop();}, child: Text("الغاء",style: TextStyle(color:Colors.red),)),
                                                              ElevatedButton(
                                  onPressed: (){
                                      print(member['uid']);
                                      DeleletUserFromTree(member['uid']);
                                    
                                  }, child: Text("نعم",style: TextStyle(color: AppColors().darkGreen),)),
                              ],)
                          ],
                        ));
                       }else{
                        snackBar('لايمكن حذف فرع في الشجرة لدية ابناء', context);
                       }
                      print(children);
                  }, icon: Icon(Icons.delete_forever,color:Colors.red,)),
                ],
              ),
              Column(
                children: [
                  Text('${member['name']}${member['id']}',style: TextStyle(color: AppColors().darkGreen),),
                  Text('${member['birthDate']}'),
                ],
              ),
              SizedBox(width: 5),
              CircleAvatar(radius: 40,backgroundImage: NetworkImage('${member['image']}',),),
              SizedBox(width: 5),

            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> findMemberById(String id) {
    var familyData = json.decode(newJson!);
    var family = familyData['family'] as List;

    for (var member in family) {
      var result = _findMember(member, id);
      if (result != null) return result;
    }
    return {};
  }

  Map<String, dynamic>? _findMember(Map<String, dynamic> member, String id) {
    if (member['id'] == id) return member;

    for (var child in member['children']) {
      var result = _findMember(child, id);
      if (result != null) return result;
    }
    return null;
  }
}
