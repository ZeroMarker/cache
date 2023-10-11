//页面Gui
function InitLabSpecMapWin(){
	var obj = new Object();
	obj.RecRowID=""
	obj.RecRowID2=""
	obj.aFlag =""; //全部
	$.parser.parse(); // 解析整个页面
	obj.cboProperty = Common_ComboDicID("cboProperty","LabSpecType",$.LOGON.LOCID);
	//标本对照维护
	obj.gridLabSpecMap = $HUI.datagrid("#gridLabSpecMap",{
		fit: true,
		title: "标本对照",
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
		    ClassName:"DHCHAI.DPS.LabSpecSrv",
			QueryName:"QryLabSpecMap"
	    },*/
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'SpecDesc',title:'标本名称',width:150},
			{field:'MapItemDesc',title:'标准名称',width:150},
			{field:'MapNote',title:'备注',width:150},
			{field:'HospGroup',title:'医院',width:200},
			{field:'IsActDesc',title:'有效<br>标志',width:50}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLabSpecMap_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridLabSpecMap_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnEdit").linkbutton("disable");
			$("#btnAdd").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	obj.gridLabSpecimen = $HUI.datagrid("#gridLabSpecimen",{
		fit: true,
		title: "标本标准字典",
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
		    ClassName:"DHCHAI.DPS.LabSpecSrv",
			QueryName:"QryLabSpecimen"
	    },*/
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'SpecCode',title:'标本代码',width:70},
			{field:'SpecDesc',title:'标本名称',width:150},
			{field:'WCode',title:'whonet码',width:100},
			{field:'IsActDesc',title:'有效标志',width:70},
			{field:'PropertyDesc',title:'属性',width:90},
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLabSpecimen_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridLabSpecimen_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd_two").linkbutton("enable");
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
		}
	});
	
	InitLabSpecMapWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitLabSpecMapWin();
});