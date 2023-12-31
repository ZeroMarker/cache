var cache = {
    datagrid: null,
    container: null
}

$(document).ready(function() {
    $("#StartDate").datebox("setValue", ((new Date()).addDays(-7)).format("yyyy-MM-dd"));
    $("#EndDate").datebox("setValue", ((new Date()).addDays(-1)).format("yyyy-MM-dd"));
    $("#AnDoctor").combobox({
        textField: 'Description',
        valueField: 'RowId'
    });
    cache.gridcontainer = $('#datagrid_container');
    cache.totalcontainer

    $("#btnQuery").click(function() {
        datagrid.datagrid('reload');
        dhccl.getDatas(dhccl.csp.methodservice, {
            ClassName: "DHCAN.BLL.AnesthetistWorkload",
            QueryName: "GetPersonalStat",
            Arg1: $("#StartDate").datebox("getValue"),
            Arg2: $("#EndDate").datebox("getValue"),
            Arg3: session.UserID,
            ArgCnt: 3
        }, 'json', true, function(data) {
            loadDataGrid(data);
        });
    });
});

function loadDataGrid(data) {
    if (cache.datagrid) {
        destroyDataGrid();
    }
    cache.datagrid = $('<table></table>').appendTo(cache.gridcontainer);

    cache.datagrid.datagrid({
        fit: true,
        singleSelect: true,
        rownumbers: true,
        fitColumns: false,
        columns: data.columns,
        data: data.rows
    });

    totalview.render(cache.totalcontainer, data);
}

function destroyDataGrid() {
    cache.datagrid = null;
    cache.gridcontainer.empty();
}

totalview = {
    render: function(container, data) {
        var counterElement = container.find('.counter');
        var timespanElement = container.find('.timespan');

        counterElement.text(data.Count);
        timespanElement.text(data.Timespan);
    }
}