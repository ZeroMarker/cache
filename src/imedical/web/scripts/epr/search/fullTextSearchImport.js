(function($) {

    $(function() {

        function importData() {
            //debugger;
            var rows = $('#importTable').datagrid("getChecked");
            var exportID = rows[0]["exportID"];
            var obj = $.ajax({ url: "../DHCEPRSearch.web.eprajax.AjaxExportQuery.cls?Action=update&ExportID=" + exportID + "&UserID=" + userID, async: false });
            var ret = obj.responseText;
            //debugger;
            $('#importWin').window('close');
        }

        function removeImport() {
            //debugger;
            var obj = $.ajax({ url: "../DHCEPRSearch.web.eprajax.AjaxExportQuery.cls?Action=remove&UserID=" + userID, async: false });
            var ret = obj.responseText;
            //debugger;
            $('#importWin').window('close');
        }

        //导入结果列表外层
        $('#importTable').datagrid({
            url: '../DHCEPRSearch.web.eprajax.AjaxExportQuery.cls',
            queryParams: {
                UserID: userID
            },
            method: 'post',
            loadMsg: '数据装载中......',
            singleSelect: true,
            showHeader: true,
            fitColumns: true,
            sortName: 'exportDateTime',
            remoteSort: false,
            columns: [[
                    { field: 'ck', checkbox: true },
                    { field: 'exportID', title: 'id', width: 80, hidden: true },
                    { field: 'exportDateTime', title: '导入时间', width: 80 },
                    { field: 'disLocName', title: '出院科室', width: 80 },
                    { field: 'startDisDate', title: '出院起始日期', width: 80 },
                    { field: 'endDisDate', title: '出院结束日期', width: 80 }
                ]],
            view: detailview,
            toolbar: [{
                text: '导入作为搜索范围',
                handler: importData
            },
            '-',
            {
                text: '去除导入搜索范围',
                handler: removeImport
}],
                detailFormatter: function(index, row) {
                    return '<div style="padding:2px"><table class="ddv" id="ddv' + row["exportID"] + '"></table></div>';
                },
                onExpandRow: function(index, row) {
                    var ddv = $(this).datagrid('getRowDetail', index).find('table.ddv');
                    ddv.datagrid({
                        url: '../DHCEPRSearch.web.eprajax.AjaxExportQuery.cls',
                        queryParams: {
                            Action: 'detail',
                            ExportID: row["exportID"]
                        },
                        fitColumns: true,
                        singleSelect: false,
                        rownumbers: true,
                        loadMsg: '',
                        height: 'auto',
                        columns: [[
                        { field: 'MrEpisode', title: 'MrEpisode', width: 200 }
                    ]],
                        onResize: function() {
                            $('#importTable').datagrid('fixDetailRowHeight', index);
                        },
                        onLoadSuccess: function() {
                            setTimeout(function() {
                                $('#importTable').datagrid('fixDetailRowHeight', index);
                            }, 0);
                        }
                    });
                    $('#importTable').datagrid('fixDetailRowHeight', index);
                }
            });
        });
    })(jQuery);
