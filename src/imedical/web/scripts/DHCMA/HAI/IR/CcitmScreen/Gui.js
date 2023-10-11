//页面Gui
function InitCCItmScreenWin(){
	var obj = new Object();
	obj.RecRowID = "";
	
	//监控项目列表
	obj.gridCCItmScreen = $HUI.datagrid("#gridCCItmScreen",{
		fit: true,
		title: "",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		sortName:'ID',
		sortOrder:'asc',
		remoteSort:false,    //是否是服务器对数据排序
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100,200],
		columns:[[
			{field:'ID',title:'ID',width:70,sortable:true,sorter:Sort_int},
			{field:'Desc',title:'项目名称',width:200}, 
			{field:'Desc2',title:'项目名称2',width:200},
			{field:'KeyWords',title:'关键词',width:110,sortable:true},
			{field:'Arg1',title:'参数1',width:70},
			{field:'Arg2',title:'参数2',width:70},
			{field:'Arg3',title:'参数3',width:70},
			{field:'Arg4',title:'参数4',width:70},
			{field:'Arg5',title:'参数5',width:70},
			{field:'Arg6',title:'参数6',width:70},
			{field:'Arg7',title:'参数7',width:70},
			{field:'Arg8',title:'参数8',width:70},
			{field:'Arg9',title:'参数9',width:70},
			{field:'Arg10',title:'参数10',width:70},
			{field:'IsActive',title:'是否有效',width:80,
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridCCItmScreen_onDbselect(rowData);						
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridCCItmScreen_onSelect(rowData,rindex);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitCCItmScreenWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
	
}