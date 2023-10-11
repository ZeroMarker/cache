//页面Gui
var obj = new Object();
function InitLabAntibioticWin(){
	obj.RecRowID = "";
	$HUI.combobox('#cboAntCat',
	    {
			url:$URL+'?ClassName=DHCHAI.DPS.LabAntiSrv&QueryName=QryLabAntiCat&ResultSetType=Array',
			valueField:'ID',
			textField:'ACDesc',
			panelHeight:300,
			editable:true   		    
	    })
	
	//抗生素
	obj.gridLabAntibiotic = $HUI.datagrid("#gridLabAntibiotic",{
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
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'AntCode',title:'代码',width:150},
			{field:'AntDesc',title:'名称',width:250},
			{field:'CatDesc',title:'分类',width:250},
			{field:'WCode',title:'whonet码',width:200},
			{field:'IsActDesc',title:'是否有效',width:70,align:'center'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLabAntibiotic_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridLabAntibiotic_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	InitLabAntibioticWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitLabAntibioticWin();
});