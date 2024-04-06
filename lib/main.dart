import 'dart:convert';                                                                     
//import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Food App',
      theme: ThemeData(
        //primarySwatch: const Color.fromARGB(255, 171, 193, 211),
        primaryColor: const Color.fromARGB(255, 214, 165, 102),
        hintColor: Color.fromARGB(255, 253, 205, 190),
        //scaffoldBackgroundColor: Color.fromARGB(255, 246, 247, 241),
        scaffoldBackgroundColor: Colors.yellow[50],
      ),
      home: const OrderFoodHomePage(),
    );
  }
}

class OrderFoodHomePage extends StatelessWidget {
  const OrderFoodHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const SizedBox(height: 45),
            const Text('ร้านอาหารดีเลิศ', style: TextStyle(fontSize: 45)),
            const SizedBox(height: 30),
          ],
        ),
        centerTitle: true,
        leading: SizedBox(width: AppBar().preferredSize.height),
      ),
      //body: Column(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderFoodPage(foodCategory: 'เมนูอาหาร', unit: 'กล่อง')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
              ),
              child: const Text(
                'เมนูอาหาร',
                style: TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderFoodPage(foodCategory: 'เมนูของหวาน', unit: 'ถุง')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
              ),
              child: const Text(
                'เมนูของหวาน',
                style: TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OrderFoodPage(foodCategory: 'น้ำดื่ม', unit: 'ขวด')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
              ),
              child: const Text(
                'น้ำดื่ม',
                style: TextStyle(fontSize: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderFoodPage extends StatefulWidget {
  final String foodCategory;
  final String unit;

  const OrderFoodPage({Key? key, required this.foodCategory, required this.unit}) : super(key: key);

  @override
  _OrderFoodPageState createState() => _OrderFoodPageState();
}

class _OrderFoodPageState extends State<OrderFoodPage> {
  String _selectedFood = '';
  String _quantity = '';

  List<String> _foods = [];

  final TextEditingController _otherFoodController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  
  //var dio;

  @override
  void initState() {
    super.initState();
    _populateFoods(); // เรียกเมธอด _populateFoods() เพื่อกำหนดรายการอาหารเริ่มต้น
    _populateFood(); // เรียกเมธอด _populateFood() เพื่อโหลดข้อมูลอาหารจาก API
  }
  void _populateFoods() {
    if (widget.foodCategory == 'เมนูอาหาร') {
      _foods = [
        'หมูทอดกระเทียม',
        'ข้าวผัดกะเพราหมู',
        'ข้าวมันไก่',
        'ผัดผักบุ้ง',
        'แกงจืดเต้าหู้หมูสับ',
        'ผัดไท',
        'ต้มยำกุ้ง',
        'ข้าวต้มปลา',
        'ยำปลาดุกฟู',
        'ทอดมันปลากราย',
        'ข้าวผัดหมู',
        'น้ำพริกอ่อง',
        'ขนมจีนน้ำยา',
        'ข้าวขาหมู'
      ];
    // void _populateFoods() {
    // if (widget.foodCategory == 'เมนูของหวาน') {
    //   _foods = [
    //     'ปลากริม', 'สลิ่ม' , 'กล้วยบวชชี' , 'แกงบวชข้าวโพด' , 'เฉาก๊วย', 'ลอดช่อง'
    //   ];
    } else if (widget.foodCategory == 'เมนูของหวาน') {
      _foods = ['ปลากริม', 'สลิ่ม' , 'กล้วยบวชชี' , 'แกงบวชข้าวโพด' , 'เฉาก๊วย', 'ลอดช่อง'];
    } else if (widget.foodCategory == 'น้ำดื่ม') {
      _foods = ['น้ำเป๊บซี่', 'น้ำแดง', 'น้ำสไปรท์', 'น้ำส้ม', 'น้ำเปล่า'];
    }
  }

  Future<void> _populateFood() async { // Make the method asynchronous
    try {
      //var response = await dio.get('http://localhost:3000/foods');
      http.Response response = await http.get(Uri.parse('http://localhost:3000/foods')); // Make the HTTP GET request
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body); // Decode the JSON response
        List<String> foods = [];
        for (var item in jsonData) {
          foods.add(item['name']);
        }
        setState(() {
          _foods = foods;
        });
      } else {
        throw Exception('Failed to load foods');
      }
    } catch (error) {
      print('Error fetching foods: $error');
    }
  }

  @override
  void dispose() {
    _otherFoodController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _showQuantityDialog(String food) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$food'),
          content: TextField(
            controller: _quantityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'จำนวน (${widget.unit})',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('ยืนยัน'),
              onPressed: () {
                setState(() {
                  _selectedFood = food;
                  _quantity = _quantityController.text;
                  _quantityController.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showOtherFoodDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เพิ่มรายการอื่นๆ'),
          content: TextField(
            controller: _otherFoodController,
            decoration: InputDecoration(
              labelText: 'ชื่ออาหาร',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('ยืนยัน'),
              onPressed: () {
                setState(() {
                  _selectedFood = _otherFoodController.text;
                  _otherFoodController.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.foodCategory),
      ),
      body: ListView.builder(
        itemCount: _foods.length,
        itemBuilder: (BuildContext context, int index) {
          final food = _foods[index];
          return ListTile(
            title: Text(food),
            onTap: () {
              if (food == 'เพิ่มอื่นๆ') {
                _showOtherFoodDialog();
              } else {
                _showQuantityDialog(food);
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_selectedFood.isNotEmpty && _quantity.isNotEmpty) {
            _showConfirmationDialog();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('กรุณาเลือกรายการอาหารและจำนวน')),
            );
          }
        },
        label: const Text('สั่งอาหาร'),
        icon: const Icon(Icons.food_bank),
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการสั่งอาหาร'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('รายการ: $_selectedFood'),
              Text('จำนวน: $_quantity ${widget.unit}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ระบบทำการสั่งซื้ออาหารเรียบร้อย')),
                );
                setState(() {
                  _selectedFood = '';
                  _quantity = '';
                });
                Navigator.of(context).pop();
              },
              child: const Text('ยืนยัน'),
            ),
          ],
        );
      },
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'dart:convert';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Order Food App',
//       theme: ThemeData(
//         primaryColor: Color.fromARGB(255, 252, 214, 166), // เปลี่ยนสีหลักของแอปเป็นสีส้ม
//         hintColor: Color.fromARGB(255, 253, 205, 190), // เปลี่ยนสีเส้นขอบเมนูเป็นสีส้มเข้ม
//         scaffoldBackgroundColor: Color.fromARGB(255, 252, 226, 200), // เปลี่ยนสีพื้นหลังของ Scaffold เป็นสีขาว
//       ),
//       home: const OrderFoodHomePage(),
//     );
//   }
// }

// class OrderFoodHomePage extends StatelessWidget {
//   const OrderFoodHomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           children: [
//             const SizedBox(height: 50), // ระยะห่างด้านบน
//             const Text('ร้านอาหารดีเลิศ', style: TextStyle(fontSize: 40)), // ข้อความหัวข้อ
//             const SizedBox(height: 40), // ระยะห่างด้านล่าง
//           ],
//         ),
//         centerTitle: true,
//         leading: SizedBox(width: AppBar().preferredSize.height),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const OrderFoodPage(foodCategory: 'เมนูอาหาร', unit: 'กล่อง')),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orangeAccent, // เปลี่ยนสีพื้นหลังของปุ่มเป็นสีส้ม
//                 padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 30), // เพิ่มระยะห่างของปุ่ม
//               ),
//               child: const Text(
//                 'เมนูอาหาร',
//                 style: TextStyle(fontSize: 40), // เปลี่ยนขนาดตัวอักษรของปุ่ม
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OrderFoodPage extends StatefulWidget {
//   final String foodCategory;
//   final String unit;

//   const OrderFoodPage({Key? key, required this.foodCategory, required this.unit}) : super(key: key);

//   @override
//   _OrderFoodPageState createState() => _OrderFoodPageState();
// }

// class _OrderFoodPageState extends State<OrderFoodPage> {
//   String _selectedFood = '';
//   String _quantity = '';

//   List<String> _foods = [];

//   final TextEditingController _otherFoodController = TextEditingController();
//   final TextEditingController _quantityController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _populateFoods();
//   }

//   @override
//   void dispose() {
//     _otherFoodController.dispose();
//     _quantityController.dispose();
//     super.dispose();
//   }

//   void _populateFoods() async {
//     var dio = Dio(BaseOptions(responseType: ResponseType.plain));
//     var response = await dio.get('http://localhost:3000/foods');
//     List<dynamic> jsonData = jsonDecode(response.data);
//     List<String> foods = [];
//     for (var item in jsonData) {
//       foods.add(item['name']);
//     }
//     setState(() {
//       _foods = foods;
//     });
//   }
  

//   void _showQuantityDialog(String food) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('$food'),
//           content: TextField(
//             controller: _quantityController,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               labelText: 'จำนวน (${widget.unit})',
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('ยกเลิก'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('ยืนยัน'),
//               onPressed: () {
//                 setState(() {
//                   _selectedFood = food;
//                   _quantity = _quantityController.text;
//                   _quantityController.clear();
//                 });
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showOtherFoodDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('เพิ่มรายการอื่นๆ'),
//           content: TextField(
//             controller: _otherFoodController,
//             decoration: InputDecoration(
//               labelText: 'ชื่ออาหาร',
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('ยกเลิก'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('ยืนยัน'),
//               onPressed: () {
//                 setState(() {
//                   _selectedFood = _otherFoodController.text;
//                   _otherFoodController.clear();
//                 });
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.foodCategory),
//       ),
//       body: ListView.builder(
//         itemCount: _foods.length,
//         itemBuilder: (BuildContext context, int index) {
//           final food = _foods[index];
//           return ListTile(
//             title: Text(food),
//             onTap: () {
//               if (food == 'เพิ่มอื่นๆ') {
//                 _showOtherFoodDialog();
//               } else {
//                 _showQuantityDialog(food);
//               }
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           if (_selectedFood.isNotEmpty && _quantity.isNotEmpty) {
//             _showConfirmationDialog();
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('กรุณาเลือกรายการอาหารและจำนวน')),
//             );
//           }
//         },
//         label: const Text('สั่งอาหาร'),
//         icon: const Icon(Icons.food_bank),
//       ),
//     );
//   }

//   void _showConfirmationDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('ยืนยันการสั่งอาหาร'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text('รายการ: $_selectedFood'),
//               Text('จำนวน: $_quantity ${widget.unit}'),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('ยกเลิก'),
//             ),
//             TextButton(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('สั่งอาหารเรียบร้อย')),
//                 );
//                 setState(() {
//                   _selectedFood = '';
//                   _quantity = '';
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: const Text('ยืนยัน'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               


// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Order Food App',
//       theme: ThemeData(
//         primaryColor: const Color.fromARGB(255, 214, 165, 102), // เปลี่ยนสีหลักของแอปเป็นสีส้ม
//         hintColor: Color.fromARGB(255, 253, 205, 190), // เปลี่ยนสีเส้นขอบเมนูเป็นสีส้มเข้ม
//         scaffoldBackgroundColor: Color.fromARGB(255, 246, 247, 241), // เปลี่ยนสีพื้นหลังของ Scaffold เป็นสีขาว
//       ),
//       home: const OrderFoodHomePage(),
//     );
//   }
// }

// class OrderFoodHomePage extends StatelessWidget {
//   const OrderFoodHomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           children: [
//             const SizedBox(height: 8), // ระยะห่างด้านบน
//             const Text('ร้านอาหารดีเลิศ', style: TextStyle(fontSize: 45)), // ข้อความหัวข้อ
//             const SizedBox(height: 8), // ระยะห่างด้านล่าง
//           ],
//         ),
//         centerTitle: true,
//         leading: SizedBox(width: AppBar().preferredSize.height),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const OrderFoodPage(foodCategory: 'เมนูอาหาร', unit: 'กล่อง')),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orangeAccent, // เปลี่ยนสีพื้นหลังของปุ่มเป็นสีส้ม
//                 padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 30), // เพิ่มระยะห่างของปุ่ม
//               ),
//               child: const Text(
//                 'เมนูอาหาร',
//                 style: TextStyle(fontSize: 40), // เปลี่ยนขนาดตัวอักษรของปุ่ม
//               ),
//             ),
//             const SizedBox(height: 30), // เพิ่มระยะห่างระหว่างปุ่ม
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const OrderFoodPage(foodCategory: 'เมนูของหวาน', unit: 'ถุง')),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orangeAccent, // เปลี่ยนสีพื้นหลังของปุ่มเป็นสีส้ม
//                 padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 30), // เพิ่มระยะห่างของปุ่ม
//               ),
//               child: const Text(
//                 'เมนูของหวาน',
//                 style: TextStyle(fontSize: 40), // เปลี่ยนขนาดตัวอักษรของปุ่ม
//               ),
//             ),
//             const SizedBox(height: 30), // เพิ่มระยะห่างระหว่างปุ่ม
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const OrderFoodPage(foodCategory: 'น้ำดื่ม', unit: 'แก้ว')),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orangeAccent, // เปลี่ยนสีพื้นหลังของปุ่มเป็นสีส้ม
//                 padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 30), // เพิ่มระยะห่างของปุ่ม
//               ),
//               child: const Text(
//                 'น้ำดื่ม',
//                 style: TextStyle(fontSize: 40), // เปลี่ยนขนาดตัวอักษรของปุ่ม
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class OrderFoodPage extends StatefulWidget {
//   final String foodCategory;
//   final String unit;

//   const OrderFoodPage({Key? key, required this.foodCategory, required this.unit}) : super(key: key);

//   @override
//   _OrderFoodPageState createState() => _OrderFoodPageState();
// }

// class _OrderFoodPageState extends State<OrderFoodPage> {
//   String _selectedFood = '';
//   String _quantity = '';

//   List<String> _foods = [];

//   final TextEditingController _otherFoodController = TextEditingController();
//   final TextEditingController _quantityController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _populateFoods();
//   }

//   void _populateFoods() {
//     if (widget.foodCategory == 'เมนูอาหาร') {
//       _foods = [
//         'ผัดกะเพรา',
//         'ผัดพริกแกง',
//         'หมูทอดกระเทียม',
//         'ข้าวผัด',
//         'ผัดพริกสด',
//         'ต้มจืด',
//         'ต้มยำ',
//         'แกงป่า',
//         'ต้มแซ่บ',
//         'แกงส้ม',
//         'แกงเลียง',
//         'ราดหน้า',
//         'ผัดซีอิ๊ว',
//         'ไข่ข้น',
//         'ไก่ทอด',
//         'สุกี้'
//       ];
//     } else if (widget.foodCategory == 'เมนูของหวาน') {
//       _foods = ['ปลากริม', 'สลิ่ม' , 'กล้วยบวชชี' , 'แกงบวชข้าวโพด' , 'เฉาก๊วย', 'ลอดช่อง'];
//     } else if (widget.foodCategory == 'น้ำดื่ม') {
//       _foods = ['เป๊บซี่', 'น้ำแดง', 'น้ำสไปรท์', 'น้ำส้ม', 'น้ำเปล่า'];
//     }
//   }

//   @override
//   void dispose() {
//     _otherFoodController.dispose();
//     _quantityController.dispose();
//     super.dispose();
//   }

//   void _showQuantityDialog(String food) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('$food'),
//           content: TextField(
//             controller: _quantityController,
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               labelText: 'จำนวน (${widget.unit})',
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('ยกเลิก'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('ยืนยัน'),
//               onPressed: () {
//                 setState(() {
//                   _selectedFood = food;
//                   _quantity = _quantityController.text;
//                   _quantityController.clear();
//                 });
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showOtherFoodDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('เพิ่มรายการอื่นๆ'),
//           content: TextField(
//             controller: _otherFoodController,
//             decoration: InputDecoration(
//               labelText: 'ชื่ออาหาร',
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('ยกเลิก'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('ยืนยัน'),
//               onPressed: () {
//                 setState(() {
//                   _selectedFood = _otherFoodController.text;
//                   _otherFoodController.clear();
//                 });
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.foodCategory),
//       ),
//       body: ListView.builder(
//         itemCount: _foods.length,
//         itemBuilder: (BuildContext context, int index) {
//           final food = _foods[index];
//           return ListTile(
//             title: Text(food),
//             onTap: () {
//               if (food == 'เพิ่มอื่นๆ') {
//                 _showOtherFoodDialog();
//               } else {
//                 _showQuantityDialog(food);
//               }
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           if (_selectedFood.isNotEmpty && _quantity.isNotEmpty) {
//             _showConfirmationDialog();
//           } else {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('กรุณาเลือกรายการอาหารและจำนวน')),
//             );
//           }
//         },
//         label: const Text('สั่งอาหาร'),
//         icon: const Icon(Icons.food_bank),
//       ),
//     );
//   }

//   void _showConfirmationDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('ยืนยันการสั่งอาหาร'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text('รายการ: $_selectedFood'),
//               Text('จำนวน: $_quantity ${widget.unit}'),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('ยกเลิก'),
//             ),
//             TextButton(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('สั่งอาหารเรียบร้อย')),
//                 );
//                 setState(() {
//                   _selectedFood = '';
//                   _quantity = '';
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: const Text('ยืนยัน'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }



// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';

// // POJO (Plain Old Java Object)
// class Country {
//   final String? name;
//   final String? capital;
//   final String? flag;

//   Country({
//     required this.name,
//     required this.capital,
//     required this.flag,
//   });

//   factory Country.fromJson(Map<String, dynamic> json) {
//     return Country(
//       name: json['name'],
//       capital: json['capital'],
//       flag: json['media']['flag'],
//     );
//   }
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Countries of the World',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const TimeTable(),
//     );
//   }
// }

// class TimeTable extends StatefulWidget {
//   const TimeTable({Key? key}) : super(key: key);

//   @override
//   State<TimeTable> createState() => _TimeTableState();
// }

// class _TimeTableState extends State<TimeTable> {
//   List<Country>? _countries;
//   List<Country>? _filteredCountries;

//   @override
//   void initState() {
//     super.initState();
//     _getCountries();
//   }

//   void _getCountries() async {
//     var dio = Dio(BaseOptions(responseType: ResponseType.plain));
//     var response = await dio.get(
//         'https://api.sampleapis.com/countries/countries'
//     );
//     List list = jsonDecode(response.data);

//     setState(() {
//       _countries = list.map(
//               (country) => Country.fromJson(country)
//       ).toList();
//       _filteredCountries = _countries;
//     });
//   }

//   void _filterCountries(String query) {
//     setState(() {
//       _filteredCountries = _countries
//           ?.where((country) =>
//           country.name!.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Countries of the World'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               showSearch(
//                 context: context,
//                 delegate: CountrySearchDelegate(_countries ?? []),
//               );
//             },
//           ),
//         ],
//       ),
//       body: _filteredCountries == null
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: _filteredCountries!.length,
//         itemBuilder: (context, index) {
//           var country = _filteredCountries![index];
//           return ListTile(
//             title: Text(country.name ?? ''),
//             subtitle: Text(country.capital ?? ''),
//             trailing: country.flag == null || country.flag!.isEmpty
//                 ? null
//                 : Image.network(
//               country.flag!,
//               errorBuilder: (context, error, stackTrace) {
//                 return Icon(Icons.error, color: Colors.red);
//               },
//             ),
//             onTap: () {
//               showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AlertDialog(
//                     title: Text(country.name ?? ''),
//                     content: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text('Capital: ${country.capital ?? ''}'),
//                         Text('Flag: ${country.flag ?? ''}'),
//                       ],
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: const Text('Close'),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

// class CountrySearchDelegate extends SearchDelegate<Country> {
//   final List<Country> countries;

//   CountrySearchDelegate(this.countries);

//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = '';
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, Country(name: '', capital: '', flag: ''));
//       },
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return _buildList(query);
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return _buildList(query);
//   }

//   Widget _buildList(String query) {
//     final List<Country> filteredList = countries
//         .where((country) =>
//     country.name!.toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     return ListView.builder(
//       itemCount: filteredList.length,
//       itemBuilder: (context, index) {
//         final Country country = filteredList[index];
//         return ListTile(
//           title: Text(country.name ?? ''),
//           subtitle: Text(country.capital ?? ''),
//           onTap: () {
//             close(context, country);
//           },
//         );
//       },
//     );
//   }
// }

// void main() {
//   runApp(const MyApp());
// }
