//页面Gui
function InitOEANTListWin(){
	var obj = new Object();
	
	//抗菌用药医嘱列表
	obj.gridOEItemList = $HUI.datagrid("#gridOEItemList",{
		fit:true,
		title: "抗菌用药医嘱列表",
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
		// url:$URL,
		// queryParams:{
		//     ClassName: "DHCHAI.DPS.OEOrdItemSrv",
		//     QueryName: "QryOEOrdItemByANT",
		//     aEpisodeDr:PaadmID
		// },
		columns:[[
			{field:'OrdDesc',title:'医嘱名称',width:300,sortable:true},
			{field:'Priority',title:'医嘱类型',width:80,sortable:true},
			{field:'OrdDate',title:'开医嘱时间',width:150,sortable:true,
				formatter: function (value, row, index) {
					return row.OrdDate+" "+row.OrdTime
				}
			},
			{field:'OrdLoc',title:'开医嘱科室',width:130,sortable:true},
			{field:'OrdDoc',title:'开医嘱医生',width:100,sortable:true},
			{field:'SttDate',title:'开始时间',width:150,sortable:true,sorter:Sort_int ,
				formatter: function (value, row, index) {
					return row.SttDate+" "+row.SttTime
			}
		},
			{field:'EndDate',title:'停止时间',width:150,sortable:true,sorter:Sort_int,
				formatter: function (value, row, index) {
					return row.EndDate+" "+row.EndTime
			}
		},
			{field:'Generic',title:'通用名',width:300,sortable:true},
			{field:'AntDrgPoison',title:'等级',width:120,sortable:true},
			{field:'AntUsePurpose',title:'用药目的',width:200,sortable:true},
			{field:'OEFreqDesc',title:'频次',width:80,sortable:true},
			{field:'OEInstruc',title:'用法',width:100,sortable:true},
			{field:'OEDoseQty',title:'用量',width:80,sortable:true,
				formatter: function (value, row, index) {
					return row.OEDoseQty+""+row.OEDoseQtyUom
			}
		},
			{field:'OrdID',title:'ID',width:100,hidden:true,sortable:true}
		]],
		onSelect:function(rindex,rowData){
		
		},
		onDblClickRow:function(rowIndex,rowData){
		},
		onLoadSuccess:function(data){
           // dispalyEasyUILoad(); //隐藏效果
		}
	});
	InitOEANTListWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
