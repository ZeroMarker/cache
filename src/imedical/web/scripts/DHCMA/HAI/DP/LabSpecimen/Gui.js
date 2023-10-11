//页面Gui
function InitLabSpecimenWin(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.cboProperty = Common_ComboDicID("cboProperty","LabSpecType",$.LOGON.LOCID);
	//标本列表
	obj.gridLabSpecimen = $HUI.datagrid("#gridLabSpecimen",{
		fit: true,
		title: "",
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
			{field:'SpecCode',title:'代码',width:150},
			{field:'SpecDesc',title:'名称',width:250},
			{field:'WCode',title:'whonet码',width:200},
			{field:'IsActDesc',title:'是否有效',width:70,align:'center'},
			{field:'PropertyDesc',title:'属性',width:250},
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
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	InitLabSpecimenWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitLabSpecimenWin();
});