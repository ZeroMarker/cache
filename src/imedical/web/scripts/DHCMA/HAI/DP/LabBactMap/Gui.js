//页面Gui
function InitLabBactMapWin(){
	var obj = new Object();
   	obj.RecRowID = "";
   	obj.layer_rd=""	
   	obj.aFlag="";       //全部
   	var IsCheckFlag=false;
	//细菌字典对照维护	
	obj.gridLabBactMap = $HUI.datagrid("#gridLabBactMap",{
		fit: true,
		title: "细菌字典对照维护",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
		nowrap:true,
		fitColumns: true,
	    /*url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.DPS.LabBactSrv",
			QueryName:"QryLabBactMap"
	    },*/
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'Bacteria',title:'细菌名称',width:150},
			{field:'MapItemDesc',title:'标准细菌名称',width:200},
			{field:'MapNote',title:'备注',width:150},
			{field:'HospGroup',title:'医院',width:200},
			{field:'IsActDesc',title:'有效<br>标志',width:50}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLabBactMap_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridLabBactMap_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnEdit").linkbutton("disable");
			$("#btnAdd").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	//细菌标准字典
	obj.gridLabBacteria = $HUI.datagrid("#gridLabBacteria",{
		fit: true,
		title: "细菌标准字典",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100],
		nowrap:true,
		fitColumns: true,
	    /*url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.DPS.LabBactSrv",
			QueryName:"QryLabBacteria",
	    },*/
		columns:[[
			{field:'ID',title:'ID',width:70},
			{field:'WCode',title:'whonet码',width:100},
			{field:'BacDesc',title:'名称',width:220},
			{field:'IsActDesc',title:'有效标志',width:70}
		]],
		onSelect: function (rowIndex, rowData) {
			if(!IsCheckFlag){
				IsCheckFlag = true;
				rowIndexTo=rowIndex;
			}else if(rowIndexTo==rowIndex){
				IsCheckFlag = false;
				$('#gridLabBacteria').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
				 }
			}
	});

	InitLabBactMapWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitLabBactMapWin();
});