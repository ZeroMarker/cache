//页面Gui
function InitOEDRTListWin(){
	var obj = new Object();
	obj.gridOEItemList = $HUI.datagrid("#gridOEItemList",{
		fit:true,
		title: "治疗医嘱列表",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		singleSelect: true,
		nowrap: false,
		rownumbers:true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		loadMsg:'数据加载中...',
		loading:true,
		//是否是服务器对数据排序
		sortOrder:'asc',
		remoteSort:false,
		pageSize: 20,
		pageList : [20,50,100,200,1000],
		columns:[[
			{field:'OrdDesc',title:'医嘱名称',width:300,sortable:true},
			{field:'Priority',title:'医嘱类型',width:80,sortable:true},
			{field:'OrdDate',title:'开医嘱时间',width:150,sortable:true,
				formatter: function (value, row, index) {
					return row.OrdDate+" "+row.OrdTime
				}
			},
			{field:'OrdLoc',title:'开医嘱科室',width:130,sortable:true},
			{field:'OrdDoc',title:'开医嘱医生',width:80,sortable:true},
			{field:'SttDate',title:'开始时间',width:150 ,sortable:true,
				formatter: function (value, row, index) {
					return row.SttDate+" "+row.SttTime
			}
		},
			{field:'EndDate',title:'停止时间',width:150,sortable:true,
				formatter: function (value, row, index) {
					return row.EndDate+" "+row.EndTime
			}
		},
			{field:'OrdID',title:'ID',width:100,hidden:true}
		]],
		onSelect:function(rindex,rowData){
		
		},
		onDblClickRow:function(rowIndex,rowData){
		},
		onLoadSuccess:function(data){
           // dispalyEasyUILoad(); //隐藏效果
		}
	});
	InitOEDRTListWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
