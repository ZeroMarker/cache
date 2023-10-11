//页面Gui
function InitWin(){
	var obj = new Object();
	obj.RecRowID = "";

	obj.gridSysUser = $HUI.datagrid("#gridSysUser",{
		fit: true,
		//title: "字典类型",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap:true,
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],	   	
		columns:[[		
			{field:'ID',title:'ID',width:80,align:'center',align:'center'},
			{field:'UserCode',title:'用户工号',width:100},
			{field:'UserDesc',title:'用户名称',width:160},
			{field:'LocDesc',title:'用户科室',width:220},
			{field:'TypeDesc',title:'医护类型',width:200},
			{field:'Active',title:'是否有效',width:80,align:'center',
				formatter: function (value) {
					return (value=="1"?"是":"否")
				}
			},
			{field:'ActDate',title:'日期',width:180,align:'center',
				formatter: function (value, type, row) {
					return value; //+ ' ' + row.BTActTime
				}
			},
			{field:'ActUser',title:'操作人',width:150}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridSysUser_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
		},
		onLoadSuccess:function(data){
            dispalyEasyUILoad(); //隐藏效果
		}
	});
	
	
	InitWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}
$(InitWin);

