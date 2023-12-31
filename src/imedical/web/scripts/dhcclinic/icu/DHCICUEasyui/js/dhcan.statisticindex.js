var statisticIndex = {}
$(document).ready(function() {
    statisticIndex.strategies = $("#strategy_tree");

    var strategyData = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: dhcan.bll.dataQuery,
        QueryName: "FindStatisticStrategy",
        ArgCnt: 0
    }, "json", false);
    var strategyClassData = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: dhcan.bll.dataQuery,
        QueryName: "FindStatStrategyClass",
        ArgCnt: 0
    }, "json", false);

    var treeData = [];
    $.each(strategyClassData, function(class_ind, class_row) {
        var node = {
            text: class_row.Description,
            state: !class_ind ? "open" : "closed",
            tag: class_row,
            children: []
        };

        $.each(strategyData, function(strategy_ind, strategy) {
            if (strategy.Class == class_row.RowId) {
                node.children.push({
                    text: strategy.Description,
                    tag: strategy
                });
            }
        });

        treeData.push(node);
    });

    var module = {
        Numberic: 59,
        Filtered: 60
    }
    statisticIndex.strategies.tree({
        data: treeData,
        onClick: function(node) {
            var strategy = node.tag;
            if (strategy.Class) {
                var href = "dhcan.statisticnumericgrid.csp?strategyId=" + strategy.RowId + "&moduleId=" + module[strategy.Type == "N" ? "Numberic" : "Filtered"],
                    title = strategy.Description;
                window.parent.addTab(title, href);
            }
        }
    });

    showSJCharts();
});

function showSJCharts() {
    var barChart = echarts.init(document.getElementById("sj_bar_chart"), "macarons");

    option = {
        title: {
            title: '麻醉分级（ASA分级）管理例数',
        },
        tooltip: {
            trigger: 'axis',
            axisPointer: {
                type: 'shadow'
            }
        },
        legend: {
            data: ['总例数', '术后死亡']
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            containLabel: true
        },
        xAxis: {
            type: 'value',
            boundaryGap: [0, 0.01]
        },
        yAxis: {
            type: 'category',
            data: ['VI', 'V', 'IV', 'III', 'II', 'I']
        },
        series: [{
                name: '总例数',
                type: 'bar',
                data: [0, 321, 641, 1214, 823, 719]
            },
            {
                name: '术后死亡',
                type: 'bar',
                data: [0, 6, 15, 34, 12, 0]
            }
        ]
    };

    barChart.setOption(option, true);
}

function showZKCharts() {
    var barChart = echarts.init($("#bar_chart")[0], "macarons");

    var option = {
        title: {},
        tooltip: {},
        legend: {
            data: ["医生1"]
        },
        xAxis: {
            data: ["医生1", "医生2", "医生3", "医生4", "医生5", "医生6", "医生7", "医生8", "医生9"]
        },
        yAxis: {},
        series: [{
            name: "医生1",
            type: "bar",
            data: [15, 23, 5, 12, 20, 22, 21, 11, 6]
        }, {
            name: "医生2",
            type: "bar",
            data: [8, 11, 14, 23, 34, 4, 18, 20, 8]
        }, {
            name: "医生3",
            type: "bar",
            data: [21, 5, 12, 3, 12, 10, 12, 10, 21]
        }]
    };

    barChart.setOption(option);
}