//页面Gui
function InitMBRListInfoWin(){
	var obj = new Object();
	obj.RecRowID = "";
	//多重耐药查询处理
	obj.gridMBRInfo = $HUI.datagrid("#gridMBRInfo",{
		fit:true,
		title: "多重耐药查询处理",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		singleSelect: true,
		nowrap: false,
		rownumbers:true,
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		loadMsg:'数据加载中...',
		loading:true,
		//是否是服务器对数据排序
		sortOrder:'asc',
		remoteSort:false,
		pageSize: 20,
		pageList : [20,50,100,200,1000],
		columns:[[
			{field:'MrNo',title:'病案号',width:100},
			{field:'PapmiNo',title:'登记号',width:100},
			{field:'PatName',title:'姓名',width:100},
			{field:'Sex',title:'性别',width:40},
			{field:'Age',title:'年龄',width:60},
			{field:'MRBDesc',title:'多耐分类',width:150},
			{field:'SpeDesc',title:'标本',width:60},
			{field:'BacDesc',title:'病原体',width:120},
			{field:'IsolateInfo',title:'隔离医嘱',width:150},
			{field:'ActDate',title:'送检日期',width:110},
			{field:'RepDate',title:'报告日期',width:110},
			{field:'MRBActFlag',title:'处置情况',width:100},
		]],
		onSelect:function(rindex,rowData){
            if (rindex>-1) {
				obj.grid_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
		},
		onLoadSuccess:function(data){
           $("#btnEdit").linkbutton("disable");
		}
	});
    //隔离医嘱
	var Alias = encodeURI("隔离");
	$HUI.combobox('#cboMRBIsoOEOrd',
	    {
			url:$URL+'?ClassName=DHCHAI.DPS.OEItmMastMapSrv&QueryName=QryOEItmMastMap&ResultSetType=Array&aFlg='+"1"+'&aAlias='+Alias,
			valueField:'ID',
			textField:'BTOrdDesc',
			panelHeight:300,
			editable:true,
            onLoadSuccess:function(data){
                // 院区默认选择
                $('#cboMRBIsoOEOrd').combobox('select',data[0].ID);
            }   		    
	    });
	InitMBRListInfoEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}