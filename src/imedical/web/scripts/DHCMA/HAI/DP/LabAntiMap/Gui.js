//页面Gui
var obj = new Object();
function InitLabAntiMapWin(){
	obj.aFlag = "";  //全部
	obj.RecRowID = "";
	obj.layer_rd=""	
	var IsCheckFlag=false;
	//抗生素字典对照维护
	obj.gridLabAntiMap = $HUI.datagrid("#gridLabAntiMap",{
		fit: true,
		title: "抗生素字典对照",
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
		    ClassName:"DHCHAI.DPS.LabAntiSrv",
			QueryName:"QryLabAntiMap"
	    },*/
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'AntiDesc',title:'抗生素名称',width:150},
			{field:'MapItemDesc',title:'标准抗生素名称',width:150},
			{field:'MapNote',title:'备注',width:150},
			{field:'HospGroup',title:'医院',width:200},
			{field:'IsActDesc',title:'有效标志',width:70}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLabAntiMap_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridLabAntiMap_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnEdit").linkbutton("disable");
			$("#btnAdd").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	//抗生素标准字典
	obj.gridLabAntibiotic = $HUI.datagrid("#gridLabAntibiotic",{
		fit: true,
		title: "抗生素标准字典",
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
		    ClassName:"DHCHAI.DPS.LabAntiSrv",
			QueryName:"QryLabAntibiotic"
	    },*/
		columns:[[
			{field:'AntCode',title:'代码',width:150},
			{field:'WCode',title:'whonet码',width:100},
			{field:'AntDesc',title:'名称',width:150},
			{field:'IsActDesc',title:'有效标志',width:70}
		]],
		onSelect: function (rowIndex, rowData) {
			if(!IsCheckFlag){
				IsCheckFlag = true;
				rowIndexTo=rowIndex;
			}else if(rowIndexTo==rowIndex){
				IsCheckFlag = false;
				$('#gridLabAntibiotic').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
				 }
			}
	});
	InitLabAntiMapWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitLabAntiMapWin();
});