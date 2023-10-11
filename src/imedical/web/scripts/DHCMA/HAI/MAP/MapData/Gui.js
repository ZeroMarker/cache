$(function () {
	InitMapDataWin();
});

//页面Gui
var aflg=""
function InitMapDataWin(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.ItemRowID = "";

	//数据对照
	obj.gridMapData = $HUI.datagrid("#gridMapData",{
		fit: true,
		title: "数据对照",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		nowrap:true,
		fitColumns: true,
		url:$URL,
	    queryParams:{
			ClassName:"DHCHAI.MAPS.MappingSrv",
			QueryName:"QryMapData",	
	    },
		columns:[[
			{field:'ItemCate',title:'分类',width:120},
			{field:'KeyVal',title:'唯一键值',width:100},
			{field:'KeyText',title:'键值描述',width:200},
			{field:'ItemCode',title:'标准值域代码',width:120},
			{field:'ItemDesc',title:'标准值域描述',width:180},
			{field:'IsActDesc',title:'有效标志',width:80}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridMapData_onSelect();
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	
	obj.gridMapItem = $HUI.datagrid("#gridMapItem",{
		fit: true,
		title: "标准值域字典",
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
		url:$URL,
	    queryParams:{
			ClassName:"DHCHAI.MAPS.MappingSrv",
			QueryName:"QryMapItem",
			aType:'',
			aAlias:''
	    },
		columns:[[
			{field:'Cate',title:'分类',width:180},
			{field:'Code',title:'值域代码',width:100},
			{field:'Desc',title:'值域名称',width:150},
			{field:'IsActDesc',title:'有效标志',width:80}
		]],
		onSelect: function (rowIndex, rowData) {
			obj.gridMapItem_onSelect();		
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridMapItem_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd_two").linkbutton("enable");
			$("#btnEdit_two").linkbutton("disable");
			$("#btnDelete_two").linkbutton("disable");
		}
	});
	
	
	//分类
	$HUI.combobox('#cboMapCate',{
		url:$URL+'?ClassName=DHCHAI.MAPS.MappingSrv&QueryName=QryMapCate&ResultSetType=Array',
		editable:true,
		valueField:'Type',
		textField:'Cate',
		panelHeight:300,
		onSelect:function(rec) {
			obj.gridMapItem.load({
				ClassName:"DHCHAI.MAPS.MappingSrv",
				QueryName:"QryMapItem",	
				aType:rec.Type,
				aAlias:$('#btnsearch_two').searchbox('getValue')					
			}); 
			
			obj.gridMapData.load({
				ClassName:"DHCHAI.MAPS.MappingSrv",
				QueryName:"QryMapData",	
				aType:rec.Type,
				aNoMapFlg:aflg,
				aAlias:$('#search').searchbox('getValue')						
			})	  
		}			
		
    });
	
	InitMapDataWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
