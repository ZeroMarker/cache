//NICU调查登记表(LocDr,Paadm,RepID)
var objScreen = new Object();
function InitNICUReportWin() {
    var obj = objScreen;
  
    //NICU患者医嘱信息
    obj.gridNICUOE = $HUI.datagrid("#gridNICUOE", {
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
            { field: 'StartDt', title: '开嘱时间', width: '158'},
            { field: 'EndDt', title: '停嘱时间', width: '158'}
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

    InitNICUReportWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
