$(function(){
	InitDate();
	InitActionType();
	InitActionUser();
	InitActions();
	InitEMRName();
	InitActionLogsList();
});

//Desc:初始化日期
function InitDate()
{
	$('#StDate').datebox('setValue', Dateformatter(new Date()));
	$('#EndDate').datebox('setValue', Dateformatter(new Date()));
}

//Desc:操作类型
function InitActionType()
{
	$('#Type').combobox({  
		valueField:'Code',  
		textField:'Desc',
		//url: "../EMRservice.Ajax.ActionsLogs.getActionsTypes.cls",
		panelHeight:85,
		data:$.parseJSON(getActionTypeData()),
		onSelect:function(record){
			$('#Model').combogrid('clear');
		}
	}); 	
}
function getActionTypeData()
{
	var result = "0";
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.ActionsLogs.getActions.cls?action=getType",
		async: false,
		success: function(d) {
			result = d;
		},
		error : function(d) {alert("获取操作类型数据错误！");}
	});
	return result;
}

//Desc:操作用户
function InitActionUser()
{
	$('#User').combogrid({  
		delay: 500,
		panelWidth:308,
		panelHeight:463,
		
		mode: 'remote',
		pageSize:15,
		pageList:[15,30,50],
		pagination:true,
		fitColumns: true,
		loadMsg:'数据装载中......',
		singleSelect:true,
		url: '../EMRservice.Ajax.getDictionaryData.cls?DicCode=S36',
		idField: 'Code',
		textField: 'DicDesc',
		columns: [[
			{field:'Alias',title:'别名',width:80},
			{field:'DicDesc',title:'描述',width:80},
			{field:'ID',title:'ID',width:50,hidden:true},
			{field:'Code',title:'代码',width:80,hidden:true}
		]],
		onBeforeLoad:function(param){
			param = $.extend(param,{Alias:$('#User').combobox('getText')});
			param = $.extend(param,{Desc:$('#User').combobox('getText')});
			return true;
		},
		onShowPanel:function(){
			$('#User').combogrid('grid').datagrid('load');
		}
	}); 		
}

//Desc:操作名称
function InitActions()
{
	$('#Model').combogrid({  
		delay: 500,
		panelWidth:308,
		panelHeight:480,
		
		pageSize:15,
		pageList:[15,30,50],
		pagination:true,
		//fitColumns: true,
		loadMsg:'数据装载中......',
		singleSelect:true,
		mode: 'remote',
		url: '../EMRservice.Ajax.ActionsLogs.getActions.cls?action=getActions',
		idField: 'ModelRowId',
		textField: 'ModelDesc',
		columns: [[
			{field:'ModelDesc',title:'名称',align:'left',width:258},
			{field:'ModelCode',title:'代码',align:'left',width:258},
			{field:'ModelRowId',title:'RowId',align:'center',width:40},
			{field:'ModelActive',title:'有效',align:'center',width:40},
			{field:'ModelFiledSet',title:'字段集',align:'center',width:50},
			{field:'ModelNote',title:'备注',align:'center',width:60},
			{field:'ModelType',title:'类型',align:'center',width:40}
		]],
		onBeforeLoad:function(param){
			param = $.extend(param,{ModelTypeCode:ActionTypeCode});
			//名称需要根据类型进行检索，类型为空，则查询出所有；
			var ActionTypeCode = "";
			var ActionTypeText = $('#Type').combobox('getText');
			if (ActionTypeText != "")
			{
				ActionTypeCode = $('#Type').combobox('getValue');
			}
			
			param = $.extend(param,{ModelTypeCode:ActionTypeCode});
			
			param = $.extend(param,{ModelDesc:param.q});
			return true;
		},
		onShowPanel:function(){
			$('#Model').combogrid('grid').datagrid('load');
		}
	}); 	
}

function InitEMRName()
{
	$('#EMRName').combotree({
		panelWidth: 260,
		value: '0',
		editable: true,
		onBeforeSelect: function(node){
			//只能选中叶子节点
			if (!$('#EMRName').tree('isLeaf',node.target))
			{
				return false;
			}
		},
		onLoadSuccess: function(node, data){
			$('#EMRName').combotree('tree').tree('collapseAll');
		}
	});
	GetEMRNameData();
}

//Desc:获取病历名称数据
function GetEMRNameData()
{
	jQuery.ajax({
		type : "GET",
		dataType : "text",
		url : "../EMRservice.Ajax.ActionsLogs.getTemplateInfo.cls",
		async : true,
		data : {"EpisodeID":episodeID,"CTLocID":CTLocID,"UserID":UserID},
		success : function(d) {
			$('#EMRName').combotree('loadData',eval(d));
		},
		error : function(d) {
			alert("get disease error");
		}
	});
}


function InitActionLogsList()
{
	var Conditions = '{"episodeID":"'+ episodeID +'"}';
	$('#actionLogsListData').datagrid({
		height:606,
		pagination:true,
		pageSize:10,
		pageList:[10,20,30], 
		loadMsg:'数据装载中......',
		autoRowHeight: true,
		url:'../EMRservice.Ajax.getActionsLogsForBrowser.cls?Conditions='+Conditions,
		idField:'EventLogRowID', 
		rownumbers:true,
		singleSelect:true,
		//fitColumns: true,
		fit:true,
		columns:[[  
			{field:'EventLogRowID',title:'EventLogRowID',width:80,hidden: true},
			{field:'LogModelDr',title:'LogModelDr',width:80,hidden: true},
            {field:'PatName',title:'患者姓名',width:60},
            {field:'PapmiNo',title:'登记号',width:80},
            {field:'MedicareNo',title:'病案号',width:60},
			{field:'LogModelDesc',title:'操作名称',width:200},
			{field:'LogModelCode',title:'LogModelCode',width:80,hidden: true},
			{field:'DetDate',title:'日期',width:70},
			{field:'DetTime',title:'时间',width:38},
			{field:'DetUserDr',title:'DetUserDr',width:40,hidden: true},
			{field:'DetUserName',title:'操作者',width:58},
			{field:'DetLocDr',title:'DetLocDr',width:80,hidden: true},
			{field:'DetLocDesc',title:'科室',width:160},
			{field:'DetGroupDr',title:'DetGroupDr',width:85,hidden: true},
			{field:'DetGroupDesc',title:'安全组',width:60},
			{field:'DetComputerIP',title:'IP地址',width:90},
			{field:'DetComputerMac',title:'MAC地址',width:110},
			{field:'DetComputerName',title:'计算机名',width:115},
			{field:'DetConditions',title:'详情',width:43,hidden: true}
		]],
		view:detailview,
		detailFormatter:function(index,row){
			return '<table id="DatagridDetail' + index + '"></table>'
		},
		onExpandRow: function(index,row){
	        $('#DatagridDetail' + index).datagrid({
				height:250,
				width:621,
				title:"操作明细",
				striped:true,
				singleSelect:true,
				columns:[[{field:'key',title:'关键字',width:300},{field:'value',title:'值',width:300}]]
			}),
			InitDatagridDetail(index,row)
		}
	});
}

function InitDatagridDetail(index,row)
{
	var DetailJson,DetailData={rows:[],total:0};
	if (!!row["DetConditions"]){
		DetailJson=row["DetConditions"]
		try{
			eval(DetailJson);
		}catch(e){}
	}
	for (var p in DetailJson){
		DetailData.rows.push({"key":p,"value":DetailJson[p]});
		DetailData.total++;
	}
	$('#DatagridDetail' + index).datagrid("loadData",DetailData);
}


$('#Find').click(function(){
	//IE11中，查询条件框中，去掉已选中的内容，再次查询，还会按照之前的查询条件进行查询，相当于查询条件框中的内容未被去掉 add by niucaicai
	//操作的病历
	var Conditions = '{"episodeID":"'+ episodeID +'"}';
	var EMRNameText = $('#EMRName').combotree('getText');
	if (EMRNameText != "")
	{
		var EMRNameValue = $('#EMRName').combotree('getValue');
		if (EMRNameValue != "0")
		{
			var categoryId = "";
			var templateId = "";
			var tree = $('#EMRName').combotree('tree');
			var SelectedNode = tree.tree('getSelected');
			templateId = SelectedNode.attributes.templateId;
			var parentNode = tree.tree('getParent',SelectedNode.target);
			categoryId = parentNode.id
			Conditions = '{"templateId":"'+ templateId +'","categoryId":"'+ categoryId +'","episodeID":"'+ episodeID +'"}'
		}
	}
	//开始日期
	var StartDate = "";
	if ($('#StDate').datebox('getText') != "")
	{
		StartDate = $('#StDate').datebox('getValue');
	}
	//结束日期
	var EndDate = "";
	if ($('#EndDate').datebox('getText') != "")
	{
		EndDate = $('#EndDate').datebox('getValue');
	}
	//操作用户
	var UserCode = "";
	if ($('#User').combogrid('getText') != "")
	{
		UserCode = $('#User').combogrid('getValue');
	}
	//操作类型
	var Type = "";
	if ($('#Type').combobox('getText') != "")
	{
		Type = $('#Type').combobox('getValue');
	}
	//操作名称
	var Model = "";
	if ($('#Model').combobox('getText') != "")
	{
		Model = $('#Model').combobox('getValue');
	}

	$('#actionLogsListData').datagrid('load',{
		StartDate:StartDate,
		EndDate:EndDate,
		UserCode:UserCode,
		AuditFlag: "N",
		Type:Type,
		Model:Model,
		Conditions:Conditions
		}
	);
});



