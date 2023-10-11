//页面Gui
function InitMricddxWin(){
	var obj = new Object();
	var IsCheckFlag=false;
	obj.RecRowID= "";
	obj.RecRowID2= "";
	obj.layer_rd=""	
	obj.layer2_rd=""
    
    obj.gridMRICDDxMap = $HUI.datagrid("#gridMRICDDxMap",{
		fit: true,
		title: "诊断项目对照",
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
			{field:'ID',title:'ID',width:70},
			{field:'BTDiagDesc',title:'诊断名称',width:270,sortable:true},
			{field:'MapItemDesc',title:'标准名称',width:200}, 
			{field:'BTMapNote',title:'标准备注',width:160},
			{field:'HospGroup',title:'医院',width:180},
			{field:'BTIsActive',title:'是否有效',width:70,
				formatter: function(value,row,index){
					return (value == '1' ? '是' : '否');
				}
			}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridMRICDDxMap_onDbselect(rowData);						
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridMRICDDxMap_onSelect(rowData,rindex);
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
	
	obj.gridMRICDDx = $HUI.datagrid("#gridMRICDDx",{
		fit: true,
		title: "诊断项目字典",
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
		pageList : [10,20,50,100,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCHAI.DPS.MRICDDxSrv",
			QueryName:"QryMRICDDx"
		},
		columns:[[
			{field:'BTCode',title:'代码',width:150},
			{field:'BTDesc',title:'名称',width:220,sortable:true},
			{field:'BTIsActive',title:'是否有效',width:70,
				formatter: function(value,row,index){
						return (value == '1' ? '是' : '否');
				}
			}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridMRICDDx_onDbselect(rowData);						
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
				$('#gridMRICDDx').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
				 }
			if (rowIndex>-1) {
				obj.gridMRICDDx_onSelect(rowData,rowIndex);
			}
		}
	});
	
	InitDictionaryWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}