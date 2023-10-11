//加载页面
$(function () {
	InitBactGenusWin(); 
});

//页面Gui
function InitBactGenusWin(){
	var obj = new Object();
    obj.RecRowID = '';	
  	
    obj.gridBactGenus = $HUI.datagrid("#BactGenus",{
		fit: true,
		title:'细菌菌属字典',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
			ClassName:'DHCHAI.DPS.LabBactSrv',
			QueryName:'QryLabBactGenus'
	    },
		columns:[[
			{field:'ID',title:'ID',width:80},
			{field:'BCCode',title:'代码',width:100},
			{field:'BCDesc',title:'名称',width:200}		
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridBactGenus_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridBactGenus_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitBactGenusWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


