var statisticNumbericGrid = {};
$(document).ready(function() {
    var strategy = {
        RowId: $.getUrlParam("strategyId")
    };

    initiateDataGrid(strategy);
    initiateQueryTools(strategy);
});

function initiateDataGrid(strategy) {
    statisticNumbericGrid.datagrid = $(".result-datagrid");
    var strategyColumns = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: dhcan.bll.dataQuery,
        QueryName: "FindStatisticStrategyColumn",
        Arg1: strategy.RowId,
        ArgCnt: 1
    }, "json", false);
    var strategyRows = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: dhcan.bll.dataQuery,
        QueryName: "FindStatisticStrategyRow",
        Arg1: strategy.RowId,
        ArgCnt: 1
    }, "json", false);

    var frozenColumns = [
        []
    ];

    if (strategyRows) {
        frozenColumns[0].push({
            field: "RowDesc",
            title: "行名",
            width: 160
        });
    };

    var columns = [
        []
    ];

    $.each(strategyColumns, function(index, col) {
        columns[0].push({
            field: "Column_" + col.RowId,
            title: col.Name,
            width: 60
        });
    });

    statisticNumbericGrid.datagrid.datagrid({
        fit: true,
        singleSelect: true,
        rownumbers: true,
        bodyCls: 'panel-body-gray',
        toolbar: $("#datagrid_tool"),
        treeField: "RelatedRow",
        frozenColumns: frozenColumns,
        columns: columns
    });
}

function initiateQueryTools(strategy) {
    statisticNumbericGrid.queryForm = $("#datagrid_tool").children("form");
    $(statisticNumbericGrid.queryForm).form({});
    $("input[name='strategyId']").val(strategy.RowId);

    $("#btn_execute_query").linkbutton({
        onClick: function() {
            var formData = $(statisticNumbericGrid.queryForm).serializeJson();
            var params = {
                ClassName: "DHCAN.BLL.StatisticStrategy",
                MethodName: "ProceedStrategy",
                Arg1: formData.strategyId || "",
                Arg2: formData.startDate || "",
                Arg3: formData.endDate || "",
                ArgCnt: 3
            };

            dhccl.getDatas(dhccl.csp.methodService, params, "text", true, function(data) {
                if (data) {
                    /// typeOf data == "json" ?
                    var jsonData = $.parseJSON(data);
                    $(statisticNumbericGrid.datagrid).datagrid("loadData", jsonData);
                    showCharts();
                }
            });
        }
    })
}

function showCharts() {
    var barChart = echarts.init($("#bar_chart")[0], "macarons");

    var option = {
        title: {},
        tooltip: {},
        legend: {
            data: ["工作量", "工作时间"]
        },
        xAxis: {
            data: ["丁振", "蒋力"]
        },
        yAxis: {},
        series: [{
            name: "工作量",
            type: "bar",
            data: [1, 1]
        }, {
            name: "工作时间",
            type: "bar",
            data: [2.5, 2.5]
        }]
    };

    barChart.setOption(option);
}

$.extend($.fn.datebox.defaults, {
    formatter: function(date) {
        var y = date.getFullYear();
        var m = date.getMonth() + 1;
        var d = date.getDate();
        return y + "-" + (m > 9 ? m : "0" + m) + '-' + (d > 9 ? d : "0" + d);
    }
});

$.getUrlParam = function(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);

    if (r) return unescape(r[2]);

    return null;
}