import 'package:flutter/material.dart';

get budgetTab => const BudgetTab();

class BudgetTab extends StatefulWidget {
  const BudgetTab({super.key});

  @override
  State<BudgetTab> createState() => _BudgetTabState();
}

abstract class ListItem {
  Widget buildTitle(BuildContext context);

  Widget buildSubtitle(BuildContext context);
}

class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}

class _BudgetTabState extends State<BudgetTab> {
  List<ListItem> items = List<ListItem>.generate(
      5, (index) => MessageItem('Sender $index', 'Message body $index'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.only(
                  left: 12, right: 12, top: 24, bottom: 12),
              child: Text(
                "Orçamento",
                style: Theme.of(context).textTheme.headlineLarge,
              )),
          Expanded(
              child: ListView(
            padding:
                const EdgeInsets.only(left: 12, right: 12, top: 24, bottom: 12),
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.arrow_upward, color: Colors.green),
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Receita'),
                    Text('Salário'),
                    Text('01/04/2024'),
                    Text('R\$ 4500,00')
                  ],
                ),
                trailing: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {},
                            child: const Icon(Icons.edit,
                                color: Colors.black, size: 20)),
                      ),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {},
                              child: const Icon(Icons.delete,
                                  color: Colors.black, size: 20))),
                    ]),
              ),
              ListTile(
                leading: const Icon(Icons.arrow_downward, color: Colors.red),
                title: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Despesa'),
                    Text('Aluguel'),
                    Text('03/04/2024'),
                    Text('R\$ 2000,00')
                  ],
                ),
                trailing: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {},
                            child: const Icon(Icons.edit,
                                color: Colors.black, size: 20)),
                      ),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {},
                              child: const Icon(Icons.delete,
                                  color: Colors.black, size: 20))),
                    ]),
              ),
            ],
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        tooltip: 'Adicionar registro',
        elevation: 5,
        splashColor: Colors.grey,
        child: const Icon(
          Icons.add,
          color: Colors.black,
          size: 29,
        ),
      ),
    );
  }
}
