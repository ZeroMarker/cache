//加载页面
$(function () {
	InitDeleteControlWin(); 
});

//页面Gui
function InitDeleteControlWin(){
	var obj = new Object();
    obj.RecRowID = '';	
  	
    obj.gridDeleteControl = $HUI.datagrid("#DeleteControl",{
		fit: true,
		title:'基础字典删除控制权限',
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
	    queryParams:{
			ClassName:'DHCMA.Util.BTS.DeleteControlSrv',
			QueryName:'QryDeleteControl',
			aKeyWords:''
	    },
		columns:[[
			{field:'ID',title:'ID',width:80},			
			{field:'ProDesc',title:'产品',width:300},
			{field:'TableCode',title:'代码',width:300},
			{field:'TableDesc',title:'名称',width:300},
			{field:'AllowDelDesc',title:'是否允许删除',width:150}			
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridDeleteControl_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridDeleteControl_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	obj.cboProduct = $HUI.combobox('#cboProduct', {              
		url: $URL,
		editable: false,
		mode: 'remote',
		valueField: 'ProCode',
		textField: 'ProDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMA.Util.BTS.ProductSrv';
			param.QueryName = 'QryProduct';
			param.ResultSetType = 'array'
		}
	});
	
	//搜索框定义
	$('#txtSearch').searchbox({ 
		searcher:function(value,name){
			$cm ({
			 	ClassName:"DHCMA.Util.BTS.DeleteControlSrv",
				QueryName:"QryDeleteControl",
				aKeyWords: value
			},function(rs){
				$('#DeleteControl').datagrid('loadData', rs);				
			});
		}, 
		prompt:'输入产品名称或菜单名称查询' 
	}); 
	
	InitDeleteControlWinEvent(obj);
	obj.LoadEvent(arguments);
		
	return obj;
}


