import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

//class Scratch extends StatefulWidget {
//  @override
//  _SettingsFormState createState() => _SettingsFormState();
//}
//
//class _SettingsFormState extends State<Scratch> {
//  @override
//  Widget build(BuildContext context) {
//    print("Scratch width= " + MediaQuery.of(context).size.width.toString());
////    return StaggeredGridView.countBuilder(
////      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
////      itemCount: 20,
////      itemBuilder: (BuildContext context, int index) => new Container(
////          color: Colors.green,
////          child: new Center(
////            child: new CircleAvatar(
////              backgroundColor: Colors.white,
////              child: new Text('$index'),
////            ),
////          )),
////      staggeredTileBuilder: (int index) =>
////      new StaggeredTile.count(1, 1),
////      mainAxisSpacing: 4.0,
////      crossAxisSpacing: 4.0,
////    );
//
//    return GridView.count(
//      // Create a grid with 2 columns. If you change the scrollDirection to
//      // horizontal, this produces 2 rows.
//      crossAxisCount: 2,
//      // Generate 100 widgets that display their index in the List.
//      children: List.generate(100, (index) {
//        return Center(
//          child: Text(
//            'Item $index',
//            style: Theme.of(context).textTheme.headline5,
//          ),
//        );
//      }),
//    );
//  }
//}

class Example04 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('customScrollView'),
        ),
        body: new CustomScrollView(
          primary: false,
          slivers: <Widget>[
            new SliverStaggeredGrid.count(
              crossAxisCount: 4,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              children: const <Widget>[
                const Text('1'),
                const Text('2'),
                const Text('3'),
                const Text('4'),
                const Text('5'),
                const Text('6'),
                const Text('7'),
                const Text('8'),
              ],
              staggeredTiles: const <StaggeredTile>[
                const StaggeredTile.count(2, 2),
                const StaggeredTile.count(2, 1),
                const StaggeredTile.count(2, 2),
                const StaggeredTile.count(2, 1),
                const StaggeredTile.count(2, 2),
                const StaggeredTile.count(2, 1),
                const StaggeredTile.count(2, 2),
                const StaggeredTile.count(2, 1),
              ],
            )
          ],
        ));
  }
}
