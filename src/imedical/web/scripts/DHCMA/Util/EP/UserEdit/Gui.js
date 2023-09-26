//页面Gui
function InitHISUIWin(){
	var obj = new Object(); //初始化赋值
	 $.parser.parse(); // 解析整个页面 	
	
	obj.dictList = $HUI.datagrid("#dictList",{
		fit: true,
		title:"用户列表",
		headerCls:'panel-header-gray',
		iconCls:'icon-apply-check',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
		url:$URL,
		queryParams:{
			ClassName:"DHCMA.Util.EPS.SSUserSrv",
			QueryName:"QryUserInfo"
		},
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'OID',title:'OID',width:50,hidden:true},
			{field:'Code',title:'用户工号',sortable:true,width:100},
			{field:'Desc',title:'用户名称',sortable:true,width:300},
			{field:'LocID',title:'LocID',width:50,hidden:true},
			{field:'LocDesc',title:'用户科室',sortable:true,width:100},
			{field:'CareProvTpDesc',title:'医护类型',sortable:true,width:100},
			{field:'RangeDesc',title:'值域',sortable:true,width:100,hidden:true},
			{field:'IsActDesc',title:'是否有效',width:'80'}
		]],
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1) {
				obj.dictList_onSelect();
				var temp_selected = rowData;
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridProduct_onDbselect(rowData);
				var temp_selected = rowData;
			}
		},
		onLoadSuccess:function(data){
			$("#editIcon").linkbutton("disable");
			$("#delIcon").linkbutton("disable");
		}
	});	

	obj.txtLocDr = $HUI.combobox("#txtLocDr",{
		url:$URL+"?ClassName=DHCMA.Util.EPS.LocationSrv&QueryName=QryLocInfo&ResultSetType=array",
		valueField:'OID',
		textField:'Desc'
	});
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
