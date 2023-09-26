//页面Gui
function InitPathItemCatListWin(){
	var obj = new Object();
	obj.RecRowID = "";	
    $.parser.parse(); // 解析整个页面 
	
	obj.gridPathItemCat = $HUI.datagrid("#gridPathItemCat",{
		fit: true,
		title: "项目分类维护",
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
		    ClassName:"DHCMA.CPW.BTS.PathItemCatSrv",
			QueryName:"QryPathItemCat"
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'50'},
			{field:'BTCode',title:'代码',width:'245',sortable:true},
			{field:'BTDesc',title:'名称',width:'400'}, 
			{field:'BTTypeDesc',title:'项目大类',width:'380'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {	
				obj.gridPathItemCat_onSelect();	
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPathItemCat_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	obj.cboItemType = $HUI.combobox('#cboItemType', {              
		url: $URL,
		blurValidValue:true,
		editable: true,
		//multiple:true,  //多选
		//mode: 'remote',
		valueField: 'BTID',
		textField: 'BTDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.BTS.DictionarySrv';
			param.QueryName = 'QryDictByType';
			param.ResultSetType = 'array'
			param.aTypeCode = 'CPWFormItemType'
		},
		filter: function(q, row){
			return (row["BTDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
		}
	});
	
	InitPathItemCatListWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


