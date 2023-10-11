//页面Gui
function InitDictTypeListWin(){
	var obj = new Object();
	obj.RecRowID = "";
    $.parser.parse(); // 解析整个页面 
	
	obj.gridDicType = $HUI.datagrid("#gridDicType",{
		fit: true,
		title: "字典类型维护",
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
		    ClassName:"DHCMA.Util.BTS.DicTypeSrv",
			QueryName:"QryDicType",
			aProCode:ProductCode
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'80'},
			{field:'BTCode',title:'代码',width:'200',sortable:true},
			{field:'BTDesc',title:'名称',width:'500'}, 
			{field:'BTTypeDesc',title:'产品线',width:'400'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridDicType_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridDicType_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	if (ProductCode!='') {  //如果存在产品代码，列表中不显示产品线
		$('#gridDicType').datagrid('hideColumn','BTTypeDesc');
	}
	//所属产品加载
	obj.cbokind = $HUI.combobox('#cboTypeDr', {              
		url: $URL,
		editable: false,
		//multiple:true,  //多选
		mode: 'remote',
		valueField: 'ProID',
		textField: 'ProDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.BTS.ProductSrv';
			param.QueryName = 'QryProduct';
			param.aActive	= '1';
			param.ResultSetType = 'array'
		}
	});
		
	InitDicTypeListWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


