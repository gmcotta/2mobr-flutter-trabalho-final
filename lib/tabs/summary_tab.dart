import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_charts/flutter_charts.dart';

get summaryTab => const SummaryTab();

class SummaryTab extends StatefulWidget {
  const SummaryTab({super.key});

  @override
  State<SummaryTab> createState() => _SummaryTabState();
}

class _SummaryTabState extends State<SummaryTab> {
  Widget chartToRun() {
    LabelLayoutStrategy? xContainerLabelLayoutStrategy;
    ChartData chartData;
    ChartOptions chartOptions = const ChartOptions();
    // Example shows a mix of positive and negative data values.
    chartData = ChartData(
      dataRows: const [
        [4000.0, 4000.0, 4000.0, 4500.0],
        [3500.0, 3200.0, 3700.0, 4000.0],
      ],
      xUserLabels: const ['Jan', 'Fev', 'Mar', 'Abr'],
      dataRowsLegends: const [
        'Receitas',
        'Despesas',
      ],
      chartOptions: chartOptions,
    );
    var lineChartContainer = LineChartTopContainer(
      chartData: chartData,
      xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
    );

    var lineChart = LineChart(
      painter: LineChartPainter(
        lineChartContainer: lineChartContainer,
      ),
    );
    return lineChart;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 24,
                bottom: 12
            ),
                child: Text("Mês: 04/2024", style: Theme.of(context).textTheme.headlineLarge,)),
            Padding(padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 12,
                bottom: 12
            ),
                child: Text("Receitas: R\$4500,00", style: Theme.of(context).textTheme.titleLarge,)),
            Padding(padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 12,
                bottom: 12
            ),
                child: Text("Despesas: R\$4000,00", style: Theme.of(context).textTheme.titleLarge,)),
            Padding(padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 12,
                bottom: 12
            ),
                child: Text("Saldo: R\$500,00", style: Theme.of(context).textTheme.titleLarge,)),
            Padding(padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 48,
                bottom: 12
            ),
                child: Text("Principal despesa", style: Theme.of(context).textTheme.titleLarge,)),
            Padding(padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 12,
                bottom: 12
            ),
                child: Text("Aluguel - R\$ 2000,00", style: Theme.of(context).textTheme.titleMedium,)),
            Padding(padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 48,
                bottom: 12
            ),
                child: Text("Evolução - 2024", style: Theme.of(context).textTheme.titleLarge,)),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    // #### Core chart
                    child: chartToRun(), // verticalBarChart, lineChart
                  ),
                ],
              ),
            ),

          ],
        ),
      )
    );
  }
}
