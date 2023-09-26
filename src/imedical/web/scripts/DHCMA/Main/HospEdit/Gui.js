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
			ClassName:"DHCMed.SSService.HospitalSrv",
			QueryName:"QrySSHospital"
		},
		columns:[[
			{field:'SSHospID',title:'ID',width:50},
			{field:'SSHospCode',title:'医院代码',sortable:true,width:100},
			{field:'SSHospDesc',title:'医院名称',sortable:true,width:300},
			{field:'CTHospDesc',title:'医院别名',sortable:true,width:100},
			{field:'ProductDesc',title:'产品',sortable:true,width:100},
			{field:'IsActiveDesc',title:'是否有效',width:'80'},
			{field:'Resume',title:'备注',sortable:true,width:100}
		]],
 		onSelect:function(rowIndex,rowData){
			if (rowIndex>-1) {
				obj.gridProduct_onSelect();
			}
		}, 
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridProduct_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#addIcon").linkbutton("enable");
			$("#editIcon").linkbutton("disable");
			$("#delIcon").linkbutton("disable");
		}
	});	

	/*
	obj.cboCTHosp = $HUI.combobox("#cboCTHosp",{
		url:$URL+"?ClassName=DHCMed.SSService.HospitalSrv&QueryName=QryCTHospital&ResultSetType=array",
		valueField:'HospID',
		textField:'HospDesc'
	});
	obj.cboProduct = $HUI.combobox("#cboProduct",{
		url:$URL+"?ClassName=DHCMed.SSService.ProductsSrv&QueryName=QueryProInfo&ResultSetType=array",
		valueField:'rowid',
		textField:'ProName'
	});
	*/
	//所属产品加载-保存
	obj.cboCTHosp = $HUI.combobox('#cboCTHosp', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		mode: 'remote',
		valueField:'HospID',
		textField:'HospDesc',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMed.SSService.HospitalSrv';
			param.QueryName = 'QryCTHospital';
			param.ResultSetType = 'array'
		}
	});
	obj.cboProduct = $HUI.combobox('#cboProduct', {              
		url: $URL,
		editable: true,
		//multiple:true,  //多选
		mode: 'remote',
		valueField:'rowid',
		textField:'ProName',
		onBeforeLoad: function (param) {
			param.ClassName = 'DHCMed.SSService.ProductsSrv';
			param.QueryName = 'QueryProInfo';
			param.ResultSetType = 'array'
		}
	});
	
	InitHISUIWinEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}
