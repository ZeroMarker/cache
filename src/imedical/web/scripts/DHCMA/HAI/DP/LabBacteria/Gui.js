//页面Gui
function InitLabBacteriaWin(){
	var obj = new Object();
	obj.RecRowID=""
	Common_ComboToBact()
	//感染科室
	$HUI.combobox('#cboBacType',
	    {
			url:$URL+'?ClassName=DHCHAI.DPS.LabBactSrv&QueryName=QryLabBactType&ResultSetType=Array',
			valueField:'ID',
			textField:'BCDesc',
			panelHeight:300,
			editable:true   		    
	    })
	$HUI.combobox('#cboBacCat',
	    {
			url:$URL+'?ClassName=DHCHAI.DPS.LabBactSrv&QueryName=QryLabBactCat&ResultSetType=Array',
			valueField:'ID',
			textField:'BCDesc',
			panelHeight:300,
			editable:true   		    
	    })
	//细菌
	obj.gridLabBacteria = $HUI.datagrid("#gridLabBacteria",{
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
		    ClassName:"DHCHAI.DPS.LabBactSrv",
			QueryName:"QryLabBacteria"
	    },*/
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'WCode',title:'whonet码',width:80},
			{field:'BacCode',title:'代码',width:80},
			{field:'BacDesc',title:'名称',width:200},
			{field:'BacName',title:'英文名',width:280},
			{field:'TypeDesc',title:'细菌类型',width:150},//,align:'center'},
			{field:'CatDesc',title:'细菌分类',width:150},
			{field:'IsCommonDesc',title:'是否常见菌',width:150},
			{field:'IsSkinBactDesc',title:'是否皮肤共生菌',width:150},
			{field:'IsActDesc',title:'是否有效',width:70}
			
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridLabBacteria_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridLabBacteria_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	InitLabBacteriaWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
$(function () {
	InitLabBacteriaWin();
});