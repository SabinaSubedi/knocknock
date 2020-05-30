import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medicad/notifiers/app_title.dart';
import 'package:medicad/screens/tab_content/home.dart';
import 'package:medicad/screens/tab_content/chat.dart';
import 'package:medicad/screens/tab_content/account.dart';
import 'package:medicad/strings.dart';

class  DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin{
  BuildContext _context;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController( vsync: this, length: 3);
    _tabController.addListener(_handleTabSelection);
  }

 void _handleTabSelection() {
    String title = '';
    if (! _tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          title = '';
          break;
        case 1:
          title = Strings.CHAT;
          break;
        case 2:
          title = Strings.ACCOUNT;
          break;
        default:
          title = '';
          break;
      }
      Provider.of<AppTitleNotifier>(context, listen: false).setTitle(title);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Consumer<AppTitleNotifier>(
            builder: (context, appTitle, child) {
              return Text(appTitle.title);
            }
          ),
          backgroundColor: Colors.blue.shade300,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              HomeTabContent(),
              ChatTabContent(),
              AccountTabContent(),
            ],
          )
        ),
        bottomNavigationBar: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Icon(Icons.home),
            ),
            Tab(
              icon: Icon(Icons.chat),
            ),
            Tab(
              icon: Icon(Icons.perm_identity),
            ),
          ],
          labelColor: Colors.yellow.shade600,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.grey,
        ),
      ),
    );
  }
}