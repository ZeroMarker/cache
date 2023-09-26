//查询科室消毒病人信息 
//页面Gui
var objScreen = new Object();
function InitAssRateWin() {
    var obj = objScreen;

    obj.gridAssRate = $HUI.datagrid("#AssessRate",{
		fit: true,
		title: '',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
	        ClassName: 'DHCHAI.DI.DHS.SyncCSSDInfo',
	        QueryName: 'LocInfoTracking',
	        iLocInfo: LocInfo,
	        iDateFrom: DateFrom,
	        iDateTo: DateTo,
	        iBatNumS: BatNumS
	    },
	    rowStyler: function(index,row){
	        if (row.CssdInfDiagnos!="") {
	            return 'color:red';  
	        }
	    },
	    columns: [[
            { field: 'CssdDesc', title: '消毒包名', width: 150, align: 'center' },
			{
			    field: 'CssdBarCode', title: '器械条码', width: 170, align: 'center',
			    formatter: function (value, row, index) {
			        return value.substring(1);
			    }
			},
            { field: 'PatName', title: '患者姓名', width: 150, align: 'center'},
            { field: 'PatBedNo', title: '床位号', width: 150, align: 'center' },	
            { field: 'CssdSend', title: '发放时间', width: 150, align: 'center' },
			{ field: 'CssdSendUser', title: '发放人', width: 120, align: 'center' },
            { field: 'CssdClean', title: '清洗时间', width: 150, align: 'center' },
			{ field: 'CssdCleanUser', title: '清洗人', width: 120, align: 'center' },
			{ field: 'CssdStril', title: '灭菌时间', width: 150, align: 'center' },
			{ field: 'CssdStrilUser', title: '灭菌人', width: 120, align: 'center' },
			{ field:'CssdBack',title:'回收时间',width:150,align:'center'},
			{ field: 'CssdBackUser', title: '回收人', width: 120, align: 'center' },
            { field: 'CssdInfDiagnos', title: '感染名称', width: 200, align: 'center'},
		]],
		toolbar:[
			    {
			       text: '打印', id: 'btnPrint', iconCls: 'icon-print', handler: function () {
			           obj.btnPrint();
			       }
			    },
                {
                    text: '导出', id: 'btnExport', iconCls: 'icon-save', handler: function () {
                        obj.btnexport();
                    }
                }
		],
	});	
	InitAssRateWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}


