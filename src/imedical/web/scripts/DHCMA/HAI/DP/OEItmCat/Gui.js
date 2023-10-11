//页面Gui
function InitOEItmCatWin(){
	var obj = new Object();
	obj.RecRowID = "";
	//易感因素列表
	obj.gridOEItmCat = $HUI.datagrid("#gridOEItmCat",{
		fit: true,
		title: "医嘱分类维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList: [20,50,100,200],
		nowrap:true,
		fitColumns:true,
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'BTCode',title:'分类代码',width:200},
			{field:'BTDesc',title:'分类名称',width:200},
			{field:'TypeDesc',title:'类型',width:150}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridOEItmCat_onSelect();
			}
		},
		onDblClickRow:function(rIndex,rowData){
			if(rIndex>-1){
				obj.gridOEItmCat_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	//易感因素列表
	obj.gridOEItmType = $HUI.datagrid("#gridOEItmType",{
		fit: true,
		title: "医嘱类型维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList: [20,50,100,200],
		nowrap:true,
		fitColumns:true,
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'BTCode',title:'代码',width:300},
			{field:'BTDesc',title:'名称',width:300}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridOEItmType_onSelect();
			}
		},
		onDblClickRow:function(rIndex,rowData){
			if(rIndex>-1){
				//alert(JSON.stringify(rowData));
				obj.gridOEItmType_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd2").linkbutton("enable");
			$("#btnEdit2").linkbutton("disable");
			$("#btnDelete2").linkbutton("disable");
		}
	});	
		
	//医嘱分类下拉框
	obj.cbokind = $HUI.combobox('#cboOEType', {              
		url:$URL,
		editable: false,
		mode: 'remote',
		valueField: 'ID',
		textField: 'BTDesc',
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCHAI.DPS.OEItmCatSrv&QueryName=QryOEItmType&ResultSetType=array";
			$("#cboOEType").combobox('reload',url);
		},
		onLoadSuccess:function(){  
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['ID']);
			}
		}
	});
	
	InitOEItmCatWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}