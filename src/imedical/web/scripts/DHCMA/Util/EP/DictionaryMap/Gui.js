//页面Gui
function InitDicMapWin(){
	var obj = new Object();

    $.parser.parse(); // 解析整个页面 
	
	//字典类型
	obj.cboDicType = $HUI.combobox("#cboDicType", {
		editable: true,     
		valueField: 'BTID',
		textField: 'BTDesc', 
		defaultFilter:4,     
		allowNull: true,
		onShowPanel: function () {
			var url=$URL+"?ClassName=DHCMA.Util.EPS.DictionarySrv&QueryName=QryHISDicType&ResultSetType=array";
		    $("#cboDicType").combobox('reload',url);
		},
		onChange:function(newvalue,oldvalue){			
			obj.gridDictionaryLoad();
			obj.gridDicMapLoad();
		}
	});	
	
	//业务字典加载
	obj.gridDictionary = $HUI.datagrid("#gridDictionary",{
		fit:true,
		title:"业务字典",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'ID',title:'ID',width:'50'},
			{field:'Code',title:'代码',width:'80'},
			{field:'Desc',title:'名称',width:'160'},
			{field:'IsActive',title:'是否有效',width:'80'}
		]]
	});
	
	
	//表单加载
	obj.gridDicMap = $HUI.datagrid("#gridDicMap",{
		fit:true,
		title:"基础字典",
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		columns:[[
			{field:'MapID',title:'ID',width:'40'},
			{field:'Product',title:'产品代码',width:'100'},
			{field:'DicTypeDesc',title:'字典类型',width:'120'},
			{field:'Code',title:'代码',width:'120'},
			{field:'Desc',title:'名称',width:'180'},
			{field:'MapDicDesc',title:'标准名称',width:'140'},
			{field:'IsActDesc',title:'是否有效',width:'80'}
		]]
	});
	
	InitDicMapWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


