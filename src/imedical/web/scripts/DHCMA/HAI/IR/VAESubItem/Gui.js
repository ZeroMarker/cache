//页面Gui
function InitVAESubItemWin(obj){
	var obj = new Object();
	obj.RecRowID = "";	 //监测项目
	obj.RecRowID_two = "";  //监测规则
	
	obj.gridMonitSItem = $HUI.datagrid("#gridMonitSItem",{
		fit: true,
		title: "VAE子项维护",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true,
		rownumbers: false,
		singleSelect: true,
		autoRowHeight: false,
		nowrap:true,
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	  	queryParams:{  
			ClassName : "DHCHAI.IRS.VAESubItemSrv",
			QueryName : "QueryMonitSItem"
	    },		
		columns:[[
			{field:'ID',title:'ID',width:80},
			{field:'VASItmCode',title:'项目代码',width:100},
			{field:'VASItmDesc',title:'项目名称',width:120},
			{field:'VASResume',title:'项目说明',width:520},
			{field:'VASIsActive',title:'是否有效',width:80},
			{field:'VASActDate',title:'更新日期',width:80},
			{field:'VASActTime',title:'更新时间',width:80},
			{field:'VASActUser',title:'更新人',width:80}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridMonitSItem_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridMonitSItem_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitVAESubItemEvent(obj);
	obj.LoadEvent(arguments);
	return obj;	
}
$(InitVAESubItemWin);