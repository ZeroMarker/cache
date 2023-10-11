//页面Gui
function InitBaseMappingWin(){
	var obj = new Object();
	var IsCheckFlag=false;
	obj.RecRowID= "";
	obj.RecRowID2= "";
	obj.layer_rd="";
	obj.layer2_rd="";
	//分类下拉框
	obj.cbokind = $HUI.combobox('#cboCat', {              
		url:$URL,
		editable: true,
		mode: 'remote',
		valueField: 'xType',
		textField: 'xType',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCHAI.MAPS.CssMappingSrv';
			param.QueryName = 'QryBMType';
			param.ResultSetType = 'array'
		},
		onLoadSuccess:function(){   
			var data=$(this).combobox('getData');
			if (data.length>0){
				//$(this).combobox('select',data[0]['xType']);
			}
		}
	}); 
    
    obj.gridBaseMapping = $HUI.datagrid("#gridBaseMapping",{
		fit: true,
		title: "基础值域字典对照",
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
			{field:'Type',title:'分类编码',width:240,sortable:true},
			{field:'KeyVal',title:'唯一键值',width:200}, 
			{field:'KeyText',title:'键值描述',width:240},
			{field:'BRDesc',title:'标准值域',width:240},
			{field:'IsActDesc',title:'是否有效',width:80}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridBaseMapping_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridBaseMapping_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnAddMap").linkbutton("disable");
			$("#btnNoMap").linkbutton("enable");
			$("#btnDelMap").linkbutton("disable");
		}
	});
	//检查项目
	obj.gridBaseRange = $HUI.datagrid("#gridBaseRange",{
		fit: true,
		title: "标准值域字典",
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
			ClassName:"DHCHAI.MAPS.CssMappingSrv",
			QueryName:"QryBaseRange",
			aType:""
		},
		columns:[[
			{field:'Type',title:'分类编码',width:150},
			{field:'BRCode',title:'值域代码',width:100},
			{field:'BRDesc',title:'值域名称',width:150,sortable:true},
			{field:'IsActDesc',title:'是否有效',width:80}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridBaseRange_onDbselect(rowData);						
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
				$('#gridBaseRange').datagrid("unselectRow",rowIndex);
			}else{
				IsCheckFlag = false;
				 }
			if (rowIndex>-1) {
				obj.gridBaseRange_onSelect(rowData,rowIndex);
			}
		}
	});
	
	InitBaseMappingWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}