//页面gui
var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
	obj.RecRowID = "";
    $.parser.parse(); // 解析整个页面
	obj.gridAppendixCard =$HUI.datagrid("#gridAppendixCard",{
		fit: true,
		title: "传染病附卡维护",
		headerCls:'panel-header-gray',
		iconCls:'icon-write-order',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMed.EPDService.AppendixCardSrv",
			QueryName:"QryAppendixCard"		
	    },
		columns:[[
			{field:'Code',title:'代码',width:'150'},
			{field:'Description',title:'描述',width:'250'},
			{field:'IsActive',title:'是否生效',width:'100',align:'center'},
			{field:'Type',title:'类别',width:'200'},
			{field:'FromDate',title:'生效日期',width:'100'},
			{field:'ResumeText',title:'备注',width:'150'},
			{field:'ID',title:'ID',hidden:true}
		]],
		onDblClickRow:function(rowIndex,rowData){
			obj.openHandler(rowData);
		},
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1) { 
				obj.gridInfType_onSelect(rowData);
			}
		}
	});

	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);	
	return obj;
}