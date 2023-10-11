//页面Gui
function InitMapRuleWin(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.aCatID = "";
	//易感因素列表
	obj.gridMapRule = $HUI.datagrid("#gridMapRule",{
		fit: true,
		//title: "对照匹配规则",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		nowrap:true,
		fitColumns: true,
		url:$URL,
	    queryParams:{
		    ClassName:"DHCHAI.DPS.DataMapRuleSrv",
			QueryName:"QryRulebByCat",
			aCatID:""
	    },
		columns:[[
			{field:'ID',title:'ID',width:200},
			{field:'Desc',title:'标准名称',width:600},
			{field:'MapDesc',title:'对照短语',width:500},
			{field:'TypeDesc',title:'类型',width:200}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridMapRule_onSelect();
			}
		},
		onDblClickRow:function(rIndex,rowData){
			if(rIndex>-1){
				obj.gridMapRule_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	//分类下拉框
	obj.cbokind = $HUI.combobox('#cboCat', {              
		url:$URL,
		editable: false,
		mode: 'remote',
		valueField: 'ID',
		textField: 'DicDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCHAI.BTS.DictionarySrv';
			param.QueryName = 'QryDic';
			param.aTypeCode = 'MapRule';
			param.aActive = '1';
			param.ResultSetType = 'array'
		},
		onLoadSuccess:function(){   
			var data=$(this).combobox('getData');
			if (data.length>0){
				$(this).combobox('select',data[0]['ID']);
			}
		}
	});
	
	InitMapRuleWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

