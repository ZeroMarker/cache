$(document).ready(function() {
    $('#q_startdate,#q_enddate').datebox('setValue', new Date().format(constant.dateFormat));
    onQuery();
});

function onQuery() {
    var startdate = $('#q_startdate').datebox('getValue');
    var enddate = $('#q_enddate').datebox('getValue');

    $.ajax({
        url: ANCSP.MethodService,
        async: true,
        data: {
            ClassName: ANCLS.BLL.ToxicAnestReg,
            MethodName: 'GetToxicAnestDaySummary',
            Arg1: startdate,
            Arg2: enddate,
            ArgCnt: 2
        },
        type: "post",
        dataType: 'text',
        success: function(data) {
            var data = $.parseJSON($.trim(data));
            initGrid(data.columns, data.rows);
        },
        error: function(e) {
            var message = e;
        }
    });
}

function initGrid(columns, rows) {
    var gridContainer = $('#grid_container');
    gridContainer.empty();
    var grid = $('<table></table>').appendTo(gridContainer);
    grid.datagrid({
        fit: true,
        singleSelect: true,
        nowrap: false,
        rownumbers: true,
        pagination: true,
        pageSize: 200,
        pageList: [50, 100, 200],
        remoteSort: false,
        checkbox: false,
        frozenColumns: [
            []
        ],
        columns: columns,
        data: rows
    });
}