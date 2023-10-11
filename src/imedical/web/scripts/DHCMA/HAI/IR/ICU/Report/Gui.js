var objScreen = new Object();
function InitICUReportWin() {
    var obj = objScreen;
   
    //ICU->PICC表格
    obj.gridPICC = $HUI.datagrid("#gridPICC", {
        title: '中心静脉插管',
        headerCls: 'panel-header-gray',
        iconCls: 'icon-resort',
        singleSelect: true,
        nowrap: true, fitColumns: true,
        loadMsg: '数据加载中...',
        columns: [[
			{ field: 'IRPICCTypeDesc', title: '导管类型', width: 80 },
			{ field: 'IRPICCCntDesc', title: '导管腔数', width: 80 },
			{ field: 'IRPICCPosDesc', title: '置管部位', width: 80 },
			{ field: 'IRIntuDate', title: '置管时间', width: 100 },
			{ field: 'IRExtuDate', title: '拔管时间', width: 100 },
			{ field: 'IROperDocDesc', title: '置管人员', width: 100, sortable: true },
            { field: 'IROperLocDesc', title: '置管地点', width: 80 },
			{
			    field: 'IRIsInf', title: '是否感染', width: 80,
			    formatter: function (value, row, index) {
			        var rst = "";
			        if (value == "1")
			            rst = '是';
			        else
			            rst = '否';
			        return rst
			    }
			},
			{ field: 'IRInfDate', title: '感染日期', width: 100 },
			{ field: 'IRInfSymptomsDesc', title: '感染症状', width: 100 }
        ]],
        onDblClickRow: function (rowIndex, rowData) {
            if (rowIndex > -1) {
                obj.SelectPICCData = rowData;
                obj.rowIndex=rowIndex;
                $('#LayerPICC').show();

                obj.OpenLayerPICC();
            }
        },
        onLoadSuccess: function (data) {
            dispalyEasyUILoad(); //隐藏效果
        }
    });

    //ICU->VAP表格
    obj.gridVAP = $HUI.datagrid("#gridVAP", {
        title: '呼吸机',
        headerCls: 'panel-header-gray',
        iconCls: 'icon-resort',
        singleSelect: true,
        nowrap: true, fitColumns: true,
        loadMsg: '数据加载中...',
        columns: [[
			{ field: 'IRVAPTypeDesc', title: '气管类型', width: 80 },
			{ field: 'IRIntuDate', title: '上机时间', width: 100 },
			{ field: 'IRExtuDate', title: '脱机时间', width: 100 },
			{ field: 'IROperDocDesc', title: '置管人员', width: 100, sortable: true },
            { field: 'IROperLocDesc', title: '置管地点', width: 80 },
			{
			    field: 'IRIsInf', title: '是否感染', width: 80,
			    formatter: function (value, row, index) {
			        var rst = "";
			        if (value == "1")
			            rst = '是';
			        else
			            rst = '否';
			        return rst
			    }
			},
			{ field: 'IRInfDate', title: '感染日期', width: 100 },
			{ field: 'IRInfSymptomsDesc', title: '感染症状', width: 100 }
        ]],
        onDblClickRow: function (rowIndex, rowData) {
            if (rowIndex > -1) {
                obj.SelectVAPData = rowData;
                $('#LayerVAP').show();
                obj.rowIndex=rowIndex;
                obj.OpenLayerVAP();
            }
        },
        onLoadSuccess: function (data) {
            dispalyEasyUILoad(); //隐藏效果
        }
    });

    //ICU->UC表格
    obj.gridUC = $HUI.datagrid("#gridUC", {
        title: '泌尿道插管',
        headerCls: 'panel-header-gray',
        iconCls: 'icon-resort',
        singleSelect: true,
        nowrap: true, fitColumns: true,
        loadMsg: '数据加载中...',
        columns: [[
			{ field: 'IRUCTypeDesc', title: '尿管类型', width: 80 },
			{ field: 'IRIntuDate', title: '置管时间', width: 100 },
			{ field: 'IRExtuDate', title: '拔管时间', width: 100 },
			{ field: 'IROperDocDesc', title: '置管人员', width: 100, sortable: true },
            { field: 'IROperLocDesc', title: '置管地点', width: 80 },
			{
			    field: 'IRIsInf', title: '是否感染', width: 80,
			    formatter: function (value, row, index) {
			        var rst = "";
			        if (value == "1")
			            rst = '是';
			        else
			            rst = '否';
			        return rst
			    }
			},
			{ field: 'IRInfDate', title: '感染日期', width: 100 },
			{ field: 'IRInfSymptomsDesc', title: '感染症状', width: 100 }
        ]],
        onDblClickRow: function (rowIndex, rowData) {
            if (rowIndex > -1) {
                obj.SelectUCData = rowData;
                $('#LayerUC').show();
                obj.rowIndex=rowIndex;
                obj.OpenLayerUC();
            }
        },
        onLoadSuccess: function (data) {
            dispalyEasyUILoad(); //隐藏效果
        }
    });
    //ICU患者医嘱信息
    obj.gridICUOE = $HUI.datagrid("#gridICUOE", {
        fit: true,
        title: "三管医嘱",
        iconCls: "icon-resort",
        headerCls: 'panel-header-gray',
        singleSelect: true,
        nowrap: false,   //自动换行
        loadMsg: '数据加载中...',
        pageSize: 999,
        columns: [[
			{ field: 'OeItemDesc', title: '医嘱名称', width: '100' },
			{ field: 'StartDt', title: '开嘱时间', width: '158' },
			{ field: 'EndDt', title: '停嘱时间', width: '158' }
        ]],
        rowStyler: function (index, row) {
            if (row.TypeValue == "临时医嘱") {
                return 'background-color:pink;';
            }
        },
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
		}
    });
    InitICUReportWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
