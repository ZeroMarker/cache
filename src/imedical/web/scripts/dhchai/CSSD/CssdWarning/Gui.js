﻿//器械预警
//页面Gui
var objScreen = new Object();
function InitAssRateWin(){
	var obj = objScreen;
	var objStaDate = $('#StartDate').datebox('getValue');
	var objEndDate = $('#EndDate').datebox('getValue');
	var objBatchNumberS = $('#txtRegNo').val();
	obj.gridAssRate = $HUI.datagrid("#AssessRate", {
	    fit: true,
	    title: '器械追溯预警',
	    headerCls: 'panel-header-gray',
	    iconCls: 'icon-resort',
	    pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
	    rownumbers: true, //如果为true, 则显示一个行号列
	    singleSelect: true,
	    loadMsg: '数据加载中...',
	    pageSize: 20,
	    pageList: [20, 50, 100, 200],
	    url: $URL,
	    queryParams: {
	        ClassName: 'DHCHAI.DI.DHS.SyncCSSDInfo',
	        QueryName: 'QryCssdListLoc',
	        iDateFrom: objStaDate,
	        iDateTo: objEndDate,
	        iBatchNumberS: objBatchNumberS,
	    },
	    columns: [[
			{
			    field: 'Desc', title: '绑定(使用)科室', width: 200, align: 'center',
			    formatter: function (value, row, index){
			        var data = "<a href='#' style='white-space:normal; color:blue' onclick='objScreen.OpenLocDr(\"" + value + "\");'>" + value + "</a>";
			        return data;
			    }
			},
			{   field: 'BarCode', title: '使用人数', width: 100, align: 'center'},
			{   field: 'LocDr', title: '感染人数', width: 100, align: 'center' }
	    ]],
	    toolbar: [{
	        text: '打印', id: 'btnPrint', iconCls: 'icon-print', handler: function () {
	            obj.btnPrint();
	        }
	    },
        {
            text: '导出', id: 'btnExport', iconCls: 'icon-save', handler: function () {
                 obj.btnexport();
            }
        }],
	});

	InitAssRateWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

