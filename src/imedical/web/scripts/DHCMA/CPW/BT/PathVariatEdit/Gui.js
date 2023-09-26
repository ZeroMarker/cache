//页面Gui
function InitPathVariatListWin(){
	var obj = new Object();
	obj.RecRowID = "";
    $.parser.parse(); // 解析整个页面 
	
	obj.gridPathVariat = $HUI.datagrid("#gridPathVariat",{
		fit: true,
		title: "变异字典维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.BTS.PathVariatSrv",
			QueryName:"QryPathVariat"
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'50'},
			{field:'BTCode',title:'代码',width:'120',sortable:true},
			{field:'BTDesc',title:'名称',width:'260'}, 
			{field:'BTCatDesc',title:'变异原因分类',width:'180'},
			{field:'BTTypeDesc',title:'变异原因类型',width:'180'},
			{field:'BTAdmTypeDesc',title:'就诊类型',width:'80'},
			{field:'BTIsExactly',title:'正负变异',width:'80'},
			{field:'BTIsActive',title:'是否有效',width:'80'},
			/*{field:'BTActDate',title:'处置日期',width:'100'},	
			{field:'BTActTime',title:'处置时间',width:'120'}, */
			{field:'BTActUserDesc',title:'处置人',width:'120'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridPathVariat_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPathVariat_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	//变异原因分类
	obj.cboCause = $HUI.combobox('#cboCatDr', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.CPW.BTS.PathVarCatSrv';
			param.QueryName = 'QryPathVarCat';
			param.ResultSetType = 'array'
		}
	});
	//变异原因类型
	obj.cboKind= $HUI.combobox('#cboTypeDr', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.BTS.DictionarySrv';
			param.QueryName = 'QryDictByType';
			param.ResultSetType = 'array';
			param.aTypeCode = 'CPWVariatType'
		}
	});
	obj.AdmType = $HUI.combobox('#cboAdmType', {
		valueField:'id',
		textField:'text',
		selectOnNavigation:true,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'O',text:'门诊'},
			{id:'I',text:'住院'},
			{id:'IO',text:'门诊+住院'}
		]
	})
	InitPathVariatListWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


