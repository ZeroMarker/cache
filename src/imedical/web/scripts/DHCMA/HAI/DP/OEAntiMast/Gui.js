//页面Gui
function InitOEAntiMastWin(){
	var obj = new Object();
	obj.RecRowID = "";
	//易感因素列表
	obj.gridOEAntiMast = $HUI.datagrid("#gridOEAntiMast",{
		fit: true,
		//title: "抗菌药物字典维护",
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
			{field:'ID',title:'ID',width:100},
			{field:'BTCode',title:'代码',width:180},
			{field:'BTName',title:'名称',width:400},
			{field:'BTName1',title:'英文名',width:400},
			{field:'BTCatDesc',title:'抗菌药物分类',width:200},
			{field:'KeyDrugs',title:'重点药物',width:100},
			{field:'BTIsActive',title:'是否有效',width:100,
				formatter: function ( value,row,index ) {
					return (row['BTIsActive'] == '1' ? '是' : '否');
				}
			}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridOEAntiMast_onSelect();
			}
		},
		onDblClickRow:function(rIndex,rowData){
			if(rIndex>-1){
				obj.gridOEAntiMast_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			dispalyEasyUILoad(); //隐藏效果
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	//抗菌药物分类下拉框
	obj.cbokind = $HUI.combobox('#cboBTCatDr', {              
		url:$URL,
		editable: false,
		mode: 'remote',
		valueField: 'ID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCHAI.DPS.OEAntiCatSrv';
			param.QueryName = 'QryOEAntiCat';
			param.ResultSetType = 'array'
		},
		onLoadSuccess:function(){  
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['ID']);
			}
		}
	});
	
	InitOEAntiMastWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}