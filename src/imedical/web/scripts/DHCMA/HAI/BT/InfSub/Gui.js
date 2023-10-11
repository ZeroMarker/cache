//页面Gui
function InitInfSubWin(){
	var obj = new Object();
	obj.RecRowID = "";
	//感染诊断分类列表
	obj.gridInfSub = $HUI.datagrid("#gridInfSub",{
		fit: true,
		//title: "感染诊断分类维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		sortName:'ID',
		sortOrder:'asc',
		remoteSort:false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		columns:[[
			{field:'ID',title:'ID',width:100,
				sortable:true,sorter:
				function numberSort(a,b){  
 					var number1 = parseFloat(a);  
 					var number2 = parseFloat(b);  
 					return (number1 > number2 ? 1 : -1);    
				}			
			},
			{field:'Code',title:'代码',width:180},
			{field:'Desc',title:'名称',width:400},
			{field:'IsActive',title:'是否有效',width:100}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				
				obj.gridInfSub_onSelect();
			}
		},
		onDblClickRow:function(rIndex,rowData){
			if(rIndex>-1){
				obj.gridInfSub_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitInfSubWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}	
