//页面Gui
function InitNIBaseWin(){
	var obj = new Object();
	obj.NIBaseID=""
    $.parser.parse(); // 解析整个页面 
	$('#winNIBase').dialog({
		title: '护理项目库维护',
		iconCls:"icon-w-edit",
		closed: true,
		modal: true,
		onClose:function(){
			obj.NIBaseID="";
			obj.gridNurItemBase.clearSelections();
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	//搜索框
	$('#txtSearch').searchbox({ 
		searcher:function(value,name){
			obj.gridNurItemBase.load({
				ClassName:"DHCMA.CPW.KBS.NurItemBaseSrv",
				QueryName:"QryNIBase",
				aKeyValue:value
			});
		}, 
		prompt:'请输入项目描述' 
	});
	//诊疗项目库
	obj.gridNurItemBase = $HUI.datagrid("#gridNurItemBase",{
		fit:true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		url:$URL,
		nowrap:false,
		fitColumns:true,
		pageSize: 50,
		pageList : [10,20,50,100,200],
		queryParams:{
			ClassName:"DHCMA.CPW.KBS.NurItemBaseSrv",
			QueryName:"QryNIBase"
		},
		columns:[[
			{field:'BTID',title:'序号',width:'80'},
			{field:'BTDesc',title:'项目描述',width:'400'}, 
			{field:'BTIsActive',title:'是否启用',width:'80'},
			{field:'BTEMRCode',title:'关联病历信息',width:'300'}
		]],
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridNurItemBase_onDbselect(rowData);					
			}
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridNurItemBase_onSelect();	
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitNIBaseWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


