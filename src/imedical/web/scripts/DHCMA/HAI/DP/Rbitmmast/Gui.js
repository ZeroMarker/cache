//页面Gui
function InitRBItmMastWin(){
	var obj = new Object();
	var IsCheckFlag=false;
	obj.RecRowID= "";
	obj.RecRowID2= "";
	obj.layer_rd=""	
	obj.layer2_rd="" 
    
    obj.gridRBItmMastMap = $HUI.datagrid("#gridRBItmMastMap",{
		fit: true,
		title: "检查项目对照",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'BTMRCHKItem',title:'检查名称',width:240,sortable:true},
			{field:'MapItemDesc',title:'标准名称',width:240}, 
			{field:'BTMapNote',title:'标准备注',width:200},
			{field:'HospGroup',title:'医院',width:220},
			{field:'BTIsActive',title:'是否有效',width:80,
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridRBItmMastMap_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridRBItmMastMap_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAll").linkbutton("enable");
			$("#btnPend").linkbutton("enable");
			$("#btnFin").linkbutton("enable");
			$("#btnSyn").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnAdd").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	//检查项目
	obj.gridRBItmMast = $HUI.datagrid("#gridRBItmMast",{
		fit: true,
		title: "检查项目",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap:true,
		fitColumns: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCHAI.DPS.RBItmMastSrv",
			QueryName:"QryRBItmMast"
		},
		columns:[[
			{field:'BTCode',title:'检查代码',width:150},
			{field:'BTCName',title:'检查名称',width:150,sortable:true},
			{field:'BTIsActive',title:'是否有效',width:80,
				formatter: function(value,row,index){
						return (value == '1' ? '是' : '否');
				}
			}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridRBItmMast_onDbselect(rowData);						
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd_one").linkbutton("enable");
			$("#btnEdit_one").linkbutton("disable");
			$("#btnDelete_one").linkbutton("disable");
		},
		onSelect: function (rowIndex, rowData) {
			if(!IsCheckFlag){
				IsCheckFlag = true;
				rowIndexTo=rowIndex;
			}else if(rowIndexTo==rowIndex){
				IsCheckFlag = false;
				$('#gridRBItmMast').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
				 }
			if (rowIndex>-1) {
				obj.gridRBItmMast_onSelect(rowData,rowIndex);
			}
		}
	});
	
	InitRBItmMastWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}