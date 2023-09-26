function InitHISUIWin(){
	var obj = new Object();
	obj.selVerID = "";
	
	obj.cboFormEp = $HUI.combobox('#cboFormEp', {              
		url: $URL,
		editable: true,
		defaultFilter:"4",
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'ID',
		textField: 'EpDesc',
		selectOnNavigation:false,
		enterNullValueClear:false,
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathFormEpSrv',
			param.QueryName = 'QryPathFormEp',
			param.aPathFormDr = obj.selVerID,
			param.ResultSetType = 'array'
		},
		onSelect:function(r){
			$('#cboOrdItem').combobox('clear');	
			$('#cboOrdItem').combobox('reload');
			$("#gridOrdDetail").datagrid("loadData", { total: 0, rows: [] });
		}
	});
	
	obj.cboOrdItem=$HUI.combobox("#cboOrdItem", {              
		url: $URL,
		editable: true,
		defaultFilter:"4",
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'ID',
		textField: 'ItemDesc',
		selectOnNavigation:false,
		enterNullValueClear:false,
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathFormEpSrv',
			param.QueryName = 'QryPathFormEpItem',
			param.aPathFormEpDr = $("#cboFormEp").combobox("getValue"),
			param.aDicCode = "B",
			param.ResultSetType = 'array'
		},
		onSelect:function(r){
			obj.gridOrdDetail.load({
				ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
				QueryName:"QryPathFormEpItemOrd",
				aPathFormEpItemDr:r.ID
			})
		}
		
	});
	
	obj.gridOrdDetail = $HUI.datagrid("#gridOrdDetail",{
		fit: true,
		//title:"关联医嘱明细",
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect:false,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
	    pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.BTS.PathFormEpSrv",
			QueryName:"QryPathFormEpItemOrd",
			aPathFormEpItemDr: $("#cboOrdItem").combobox("getValue"),
	    },
		columns:[[
			{field:'checkOrd',checkbox:'true',align:'center',width:30,auto:false},
			{field:'OrdTypeDrDesc',title:'分类标记',width:'70'},
			{field:'OrdGeneIDDesc',title:'通用名',width:'150'},
			{field:'OrdPriorityIDDesc',title:'医嘱类型',width:'70'},
			{field:'OrdLnkOrdDr',title:'关联号',width:'70'},
			{field:'OrdMastIDDesc',title:'医嘱名',width:'200'},
			{field:'OrdDoseQty',title:'单次剂量',width:'70'},
			{field:'OrdUOMIDDesc',title:'单位',width:'70'},
			{field:'OrdFreqIDDesc',title:'频次',width:'70'},
			{field:'OrdInstrucIDDesc',title:'用法',width:'70'},
			{field:'OrdDuratIDDesc',title:'疗程',width:'70'},
			{field:'OrdQty',title:'数量',width:'60'},
			{field:'OrdQtyUOMDesc',title:'数量单位',width:'70'},
			{field:'OrdIsDefault',title:'首选医嘱',width:'70'},
			{field:'OrdIsFluInfu',title:'是否主医嘱',width:'70'},
			{field:'OrdIsActive',title:'是否有效',width:'70'},
			{field:'OrdNote',title:'备注',width:'70'}
		]]
	});
	
	
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}