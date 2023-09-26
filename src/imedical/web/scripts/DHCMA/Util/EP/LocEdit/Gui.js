//页面Gui
function InitHISUIWin(){
	var obj = new Object(); //初始化赋值
	 $.parser.parse(); // 解析整个页面 	
	//$.fn.pagination.defaults.showPageList=false;
	obj.dictList = $HUI.datagrid("#dictList",{
		fit: true,
		title:"科室列表",
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
			ClassName:"DHCMA.Util.EPS.LocationSrv",
			QueryName:"QryLocInfo"
		},
		columns:[[
			{field:'ID',title:'ID',width:50},
			{field:'OID',title:'OID',width:50,hidden:true},
			{field:'Code',title:'科室代码',sortable:true,width:100},
			{field:'Desc',title:'科室名称',sortable:true,width:300},
			{field:'Desc2',title:'科室别名',sortable:true,width:100},
			{field:'TypeDesc',title:'科室类型',sortable:true,width:100},
			{field:'AdmTypeDesc',title:'就诊类型',sortable:true,width:100},
			{field:'HospDesc',title:'所属医院',sortable:true,width:400},
			{field:'RangeID',title:'值域',sortable:true,width:100,hidden:true},
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
	obj.txtType = $HUI.combobox("#txtType",{
		valueField:'id', textField:'text',
		data:[
			{id:'E',text:'执行科室'}
			,{id:'W',text:'病区'}
		]
	});
	obj.txtAdmType = $HUI.combobox("#txtAdmType",{
		valueField:'id', textField:'text',
		data:[
			//OP门诊 IP住院 EP急诊 Sup医技辅助  Manage管理职能部门
			{id:'O',text:'门诊'}
			,{id:'I',text:'住院'}
			,{id:'E',text:'急诊'}
			,{id:'S',text:'医技'}
			,{id:'M',text:'职能'}
		]
	});
	obj.txtHospDr = $HUI.combobox("#txtHospDr",{
		url:$URL+"?ClassName=DHCMA.Util.EPS.HospitalSrv&QueryName=QryHospInfo&ResultSetType=array",
		valueField:'OID',
		textField:'Desc',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
	});
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
