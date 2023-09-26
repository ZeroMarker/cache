//页面gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
	obj.editIndex=undefined;	
    $.parser.parse(); // 解析整个页面
	obj.gridItemEpis =$HUI.datagrid("#gridItemEpis",{
		fit: true,
		title: "付费项目阶段",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		//rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		autoRowHeight: false, 
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.SDS.PCItemEpisSrv",
			QueryName:"QryPCItemEpis"		
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'40'},
			{field:'BTCode',title:'项目编码',width:'500',sortable:true},
			{field:'BTDesc',title:'项目名称',width:'500',sortable:true}
			//{field:'BTID',title:'RowID',hidden:true}		
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridItemEpis_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridItemEpis_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);	
	return obj;
}