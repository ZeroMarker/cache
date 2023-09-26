//页面Gui
function InitHISUIWin(){
	var obj = new Object(); //初始化赋值
	 $.parser.parse(); // 解析整个页面 	
	//$.fn.pagination.defaults.showPageList=false;
	obj.dictList = $HUI.datagrid("#dictList",{
		fit: true,
		title:"医院列表",
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
			ClassName:"DHCMA.Util.EPS.HospitalSrv",
			QueryName:"QryHospInfo"
		},
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'OID',title:'OID',width:50,hidden:true},
			{field:'Code',title:'医院代码',sortable:true,width:100},
			{field:'Desc',title:'医院名称',sortable:true,width:300},
			{field:'Desc2',title:'医院别名',sortable:true,width:100},
			{field:'GroupDesc',title:'医院分组',sortable:true,width:100},
			{field:'RangeID',title:'RangeID',sortable:true,width:100,hidden:true},
			{field:'IsActDesc',title:'是否有效',width:'80'}
		]],
		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1) {
				obj.dictList_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridProduct_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#editIcon").linkbutton("disable");
			$("#delIcon").linkbutton("disable");
		}
	});	

	obj.txtGroupDr = $HUI.combobox("#txtGroupDr",{
		url:$URL+"?ClassName=DHCMA.Util.BTS.HospGroupSrv&QueryName=QryHospGrpInfo&ResultSetType=array",
		valueField:'ID',
		textField:'Desc'
	});
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
