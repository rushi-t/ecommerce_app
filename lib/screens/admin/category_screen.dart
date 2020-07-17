import 'package:ecommerce_app/models/category.dart';
import 'package:ecommerce_app/models/user.dart';
import 'package:ecommerce_app/screens/authenticate/auth.dart';
import 'package:ecommerce_app/services/auth.dart';
import 'package:ecommerce_app/services/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'category_form.dart';

class CategoryTile extends StatefulWidget {
  final Category category;

  CategoryTile({this.category});

  @override
  _CategoryTileState createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile> {
  @override
  Widget build(BuildContext context) {
    void _showCategoryAddUpdatePanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: CategoryForm(category: widget.category),
            );
          });
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
            leading: widget.category.imgUrl == null || widget.category.imgUrl == ""
                ? CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.brown[200],
                    backgroundImage: AssetImage('assets/coffee_icon.png'),
                  )
                : CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.brown[200],
                    backgroundImage: NetworkImage(widget.category.imgUrl),
                  ),
            title: Text(widget.category.name),
            subtitle: Text(''),
            trailing: PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              onSelected: (selectedMenu) {
                if (selectedMenu == "Edit") {
                  _showCategoryAddUpdatePanel();
                } else if (selectedMenu == "Delete") {
                  CategoryService().deleteCategory(widget.category);
                }
              },
              itemBuilder: (context) => <PopupMenuItem<String>>[
                PopupMenuItem<String>(
                  value: "Edit",
                  child: Text("Edit"),
                ),
                PopupMenuItem<String>(
                  value: "Delete",
                  child: Text("Delete"),
                ),
              ],
            )),
      ),
    );
  }
}

class CategoryList extends StatefulWidget {
  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<List<Category>>(context) ?? [];

    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoryTile(category: categories[index]);
      },
    );
  }
}

class CategoryScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
//    print( AuthService().userInstance);
//    if( AuthService().userInstance == null)
//      Navigator.pushReplacementNamed(context, '/signin');
//    print("sssss");
    void _showCategoryAddUpdatePanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: CategoryForm(category: null),
            );
          });
    }

    return StreamProvider<List<Category>>.value(
      value: CategoryService().categoriesStream,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Categories'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: CategoryList()),
        floatingActionButton: new FloatingActionButton(elevation: 0.0, child: new Icon(Icons.add), onPressed: () => _showCategoryAddUpdatePanel()),
      ),
    );
  }
}
