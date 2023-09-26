//页面Gui
function InitSystemListWin(){
	var obj = new Object();
	obj.RecRowID = "";
    $.parser.parse(); // 解析整个页面 
	
	obj.gridSystem = $HUI.datagrid("#gridSystem",{
		fit: true,
		title: "HIS应用系统列表",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.Util.BTS.SYSTEMSrv",
			QueryName:"QrySystem"
	    },
		columns:[[
			{field:'SYSID',title:'ID',width:'100'},
			{field:'SYSCode',title:'系统代码',width:'160'},
			{field:'SYSDesc',title:'系统名称',width:'240'},
			{field:'SYSExCode',title:'系统外部码',width:'180'},
			{field:'SYSNote',title:'系统说明',width:'400'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {	
				obj.gridSystem_onSelect();	
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridSystem_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitSystemListWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


