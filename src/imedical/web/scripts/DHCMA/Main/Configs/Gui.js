function InitDictionaryListWin(){
	var obj=new Object();
	obj.CurrDicType = "";//获取字典表类型
	obj.CurrNode = null;//获取选定节点
	$.parser.parse();
	
	obj.GetStrDic=function(RowId){
		var strDic=$m({
			ClassName :'DHCMed.SS.Dictionary',
			MethodName : 'GetStringById',
			id :RowId,
			separete:'^'
		},false)
		return strDic
	}
	
	obj.gridMdlDef = $HUI.datagrid("#gridMdlDef",{
		fit: true,
		title: "配置项目-产品模块",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		//pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.Util.BTS.ProductSrv",
			QueryName:"QryConProduct",
			aProduct:ProductCode
	    },
		columns:[[
			{field:'ProCode',title:'产品代码',width:'80'},
			{field:'ProDesc',title:'产品名称',width:'200'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridMdlDef_onSelect();
			}
		}
	});
		
	//表
	obj.gridItems=$HUI.datagrid("#gridItems",{			
		fit: true,
		title: "配置项目",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [10,20,50,100,200],
		url:$URL,
		queryParams:{
			 
			ClassName:"DHCMed.SSService.ConfigSrv",
			QueryName:"QryConfig",
			aProCode:ProductCode
		},
		columns:[[
			{field:'myid',title:'ID',width:'50'},
			{field:'Keys',title:'代码',width:'100'},
			{field:'Description',title:'描述',width:'320'}, 
			{field:'Val',title:'值',width:'100'}, 
			{field:'ValueDesc',title:'值描述',width:'220'}, 
			{field:'ProName',title:'产品',width:'150'}, 
			{field:'HispsDescs',title:'医院',width:'100'},
			{field:'Resume',title:'备注',width:'320'},
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridItems_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
				if(rowIndex>-1){
					obj.gridItems_onDbselect(rowData);
				}
			},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDel").linkbutton("disable");
		}
	});
	//加载医院和产品下拉框
	var ComboHosp = $HUI.combobox("#cboHosp", {
		url: $URL,
		editable: true,
		valueField: 'rowid',
		textField: 'hosName',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCMed.Base.Hospital';
			param.QueryName = 'QueryHosInfo';
			param.ResultSetType = 'array';
		}
	});
	var ComboToSSHosp = $HUI.combobox("#cboPro", {
		url: $URL,
		editable: true,
		valueField: 'rowid',
		textField: 'ProName',
		onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
			param.ClassName = 'DHCMed.SSService.ConfigSrv';
			param.QueryName = 'QueryProInfo';
			param.ResultSetType = 'array';
		}
	});
	
	InitDictWinEvent(obj);
	obj.LoadEvent(arguments);	
	return obj;
}