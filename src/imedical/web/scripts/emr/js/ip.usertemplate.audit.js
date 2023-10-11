$(function(){
	if (roleLevel != "")
	{
		if (parseInt(roleLevel) == NaN)
		{
			top.$.messager.alert('提示','参数RoleLevel配置错误，联系管理员重新挂菜单配置参数', 'info');
			return;
		}
		if ((maxLevel == "")||(parseInt(maxLevel) == NaN)||(maxLevel < roleLevel))
		{
			top.$.messager.alert('提示','参数MaxLevel配置错误，联系管理员重新挂菜单配置参数', 'info');
			return;
		}
	}
	if (GetAllLoc == "Y")
	{
		$("#hosAndLoc")[0].style.display = "block";
		initAllHospital();
		initAllLoc(userHospitalId);
		$("#westNorth").layout('panel','north').panel('resize',{height:140});
	}
	if (window.screen.width/2 < 920) $("#userTemplateAudit").layout('panel','west').panel('resize',{width:window.screen.width/2});
	$("#userTemplateAudit").layout('resize');
	$("#btnBack").linkbutton('disable');	//需要修正的按钮需要双击打开模板才能使用
	$("#btnModify").linkbutton('disable');
	initButton();
	initPendAudit();
	initPendModify();
	initPassAudit();
	initData();
	$('#statusTypeTabs').tabs({
		onSelect:function(title,index){
			if (title == "待审核模板")
			{
				StatusAndId = "2"+tmpValue+"^pendAudit";
				$("#btnWithdraw")[0].style.display = "none";
				$("#btnCommit")[0].style.display = "block";
			}
			else if (title == "待审核修正模板")
			{
				StatusAndId = "3"+tmpValue+"^pendModify";
				$("#btnWithdraw")[0].style.display = "none";
				$("#btnCommit")[0].style.display = "block";
			}
			else if(title == "已审核模板")
			{
				if ((maxLevel == roleLevel)||(maxLevel == ""))
				{
					StatusAndId = "1^passAudit";
				}
				else
				{
					StatusAndId = "2."+roleLevel+"@3."+roleLevel+"^passAudit";
				}
				$("#btnCommit")[0].style.display = "none";
				$("#btnWithdraw")[0].style.display = "block";
			}
			$(".textbox").val("");
			$("#selectLoc").combobox('clear');
			$("#allSelect").checkbox('uncheck');
			openTemplateInfo = {"RowId":"","Code":"","TemplateVersionId":""};
			cleanDocument();
			initData();
		}
	});
	$('#templateName').bind('keypress',function(event){
		if(event.keyCode == 13)
		{
			initData();
		}
	});
})

//获取数据装载datagrid
function initData()
{
	var Name = $("#templateName").val();
	var hospitalId = "";
	var locId = userLocId;
	if (GetAllLoc == "Y")
	{
		hospitalId = ($("#selectHospital").combobox("getValue") == "") ? userHospitalId :$("#selectHospital").combobox("getValue");
		locId = ($("#selectLoc").combobox("getValue") == "0") ? "" :$("#selectLoc").combobox("getValue");
	}
	var tmpMaxLevel = "1";
	if (maxLevel !== "") tmpMaxLevel = maxLevel;
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLIEUserTemplate",
			"Method":"GetUserTemplateByStatus",
			"p1":StatusAndId.split('^')[0],
			"p2":locId,
			"p3":Name,
			"p4":hospitalId,
			"p5":tmpMaxLevel
		},
		success: function(d){
			data = eval("("+d+")");
			$('#'+StatusAndId.split('^')[1]).datagrid('loadData',data);
		},
		error: function(d) {alert("newUserFlod error");}
	});

}

//院区信息
function initAllHospital()
{
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLIEUserTemplate",
			"Method":"GetAllHospitalID",
			"p1":userId+"^"+ssgroupId+"^"+userLocId+"^"+userHospitalId
		},
		success: function(d){
			data = eval("("+d+")");
			$("#selectHospital").combobox({
				valueField:"RowID",
				textField:"Desc",
				data:data,
				filter: function (q, row) {
				var opts = $(this).combobox('options');
				return (row["Desc"].toLowerCase().indexOf(q.toLowerCase()) >= 0)||(row[opts.textField].toLowerCase().indexOf(q.toLowerCase()) >= 0);
				},
				onSelect: function (record) {
					initAllLoc($("#selectHospital").combobox("getValue"));
				}
			});
		},
		error: function(d) {alert("newUserFlod error");}
	});
}


//科室信息
function initAllLoc(hospitalId)
{
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLIEUserTemplate",
			"Method":"GetAllLocInfo",
			"p1":hospitalId
		},
		success: function(d){
			data = eval("("+d+")");
			$("#selectLoc").combobox({
				valueField:"RowID",
				textField:"Desc",
				data:data,
				filter: function (q, row) {
				var opts = $(this).combobox('options');
				return (row["Desc"].toLowerCase().indexOf(q.toLowerCase()) >= 0)||(row[opts.textField].toLowerCase().indexOf(q.toLowerCase()) >= 0);
				},
				onSelect: function (record) {
					initData();
				}
			});
		},
		error: function(d) {alert("newUserFlod error");}
	});
}

//初始化按钮
function initButton()
{
	//查询
	$('#btnSearch').click(function () {
		initData();
	});
	//清空查询条件
	$('#btnCancel').click(function () {
		$("#templateName").val("");
		$("#selectHospital").combobox('clear');
		$("#selectLoc").combobox('clear');
	});
	//审签
	$('#btnCommit').click(function () {
		commitAudit();
	});
	//需要修正
	$('#btnBack').click(function () {
		refuseAudit();
	});
	//修改模板
	$('#btnModify').click(function () {
		openModifyTemplate();
	});
	//撤回
	$('#btnWithdraw').click(function () {
		withdrawAudit();
	});
}

//全选
function selectAllData()
{
	$("#"+StatusAndId.split('^')[1]).datagrid("selectAll");
}
//取消全选
function unSelectData()
{
	$("#"+StatusAndId.split('^')[1]).datagrid("unselectAll");
}

///未审核列表
function initPendAudit()
{
	var arr = getColumn(0);
	$('#pendAudit').datagrid({
	    loadMsg:'数据装载中......',
	    fit:true,
		border:false,
	    autoSizeColumn:false,
		fitColumns:true,
		pagination:false,
		toolbar:[],
	    columns:[arr],
		onDblClickRow:function(rowIndex, rowData)
		{
			if (!loadTempFlag) return;
			loadTempFlag = false;
			cleanDocument();
			$("#userTemplatePath").val(rowData.Path);
			$("#txaMemo").val(rowData.Memo);
			openTemplateInfo = {"RowId":rowData.RowID,"Code":rowData.Code,"TemplateVersionId":rowData.TemplateVersionId};
			openTemplate(rowData.TemplateVersionId);
		}
	});
}

///待修改列表
function initPendModify()
{
	var arr = getColumn(0);
	$('#pendModify').datagrid({
	    loadMsg:'数据装载中......',
	    fit:true,
		border:false,
	    autoSizeColumn:false,
		fitColumns:true,
		pagination:false,
		toolbar:[],
	    columns:[arr],
		onDblClickRow:function(rowIndex, rowData)
		{
			if (!loadTempFlag) return;
			loadTempFlag = false;
			cleanDocument();
			$("#userTemplatePath").val(rowData.Path);
			$("#txaMemo").val(rowData.Memo);
			openTemplateInfo = {"RowId":rowData.RowID,"Code":rowData.Code,"TemplateVersionId":rowData.TemplateVersionId};
			openTemplate(rowData.TemplateVersionId);
		}
	});
}

///已审核列表
function initPassAudit()
{
	var arr = getColumn(1);
	$('#passAudit').datagrid({
	    loadMsg:'数据装载中......',
	    fit:true,
		border:false,
	    autoSizeColumn:false,
		fitColumns:true,
		pagination:false,
		toolbar:[],
	    columns:[arr],
		onDblClickRow:function(rowIndex, rowData)
		{
			if (!loadTempFlag) return;
			loadTempFlag = false;
			cleanDocument();
			$("#userTemplatePath").val(rowData.Path);
			$("#txaMemo").val(rowData.Memo);
			openTemplateInfo = {"RowId":rowData.RowID,"Code":rowData.Code,"TemplateVersionId":rowData.TemplateVersionId};
			openTemplate(rowData.TemplateVersionId);
		}
	});
}

//获取列名
function getColumn(tmpLevelVal)
{
	var arr = [];
	arr.push({field:'ck',checkbox:"true"});
	arr.push({field:'UserTemplateName',title:'名称',width:120});
	arr.push({field:'Creator',title:'创建者',width:80});
	arr.push({field:'CreateTime',title:'创建时间',width:160});
	if ((roleLevel != "")&&(parseInt(roleLevel) != NaN)) {
		for (var i=1;i<(parseInt(roleLevel)+tmpLevelVal);i++)
		{
			arr.push({field:'Auditor'+i,title:i+'级审核者',width:80});
			arr.push({field:'AuditTime'+i,title:i+'级审核时间',width:160});
		}
	} else {
		arr.push({field:'Auditor',title:'审核者',width:80});
		arr.push({field:'AuditTime',title:'审核时间',width:160});
	}
	arr.push({field:'LocName',title:'科室名称',width:100});
	arr.push({field:'Memo',title:'审核未通过原因',width:120});
	
	return arr;
}

//审签
function commitAudit()
{
	var rows = $("#"+StatusAndId.split('^')[1]).datagrid('getSelections');
	var rowIds = "";
	for(var i=0;i<rows.length;i++)
	{
		if (rowIds != "")
		{
			rowIds = rowIds+"^";
		}
		rowIds = rowIds+rows[i].RowID;
	}
	if (roleLevel != "")
	{
		if (StatusAndId.split('^')[1] == "pendAudit")	//待审
		{
			var tmpStatus = (roleLevel >= maxLevel) ? "1":"2."+roleLevel;
		}
		else		//待审修正
		{
			var tmpStatus = (roleLevel >= maxLevel) ? "1":"3."+roleLevel;
		}
	}
	else
	{
		var tmpStatus = "1";
	}
	modifyUserTempInfo(rowIds,tmpStatus,"");
}

//需要修正
function refuseAudit()
{
	if (openTemplateInfo.RowId == "")
	{
		top.$.messager.alert('提示','需要打开模板才能进行修正操作', 'info');
		return;
	}
	modifyUserTempInfo(openTemplateInfo.RowId,"4",$("#txaMemo").val());
}

//撤回已通过审核的模板
function withdrawAudit()
{
	var rows = $("#"+StatusAndId.split('^')[1]).datagrid('getSelections');
	var rowIds = "";
	for(var i=0;i<rows.length;i++)
	{
		if (rowIds != "")
		{
			rowIds = rowIds+"^";
		}
		rowIds = rowIds+rows[i].RowID;
	}
	if (rowIds.length == 0)
	{
		top.$.messager.alert('提示','未勾选数据', 'info');
		return;
	}
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"string",
			"Class":"EMRservice.BL.BLIEUserTemplate",
			"Method":"WithdrawAudit",
			"p1":rowIds,
			"p2":userId,
			"p3":getIpAddress()
		},
		success: function(d){
			if(d == "1"){
				initData();
			}else{
				top.$.messager.alert('提示','撤回失败', 'info');
			}
		},
		error: function(d) {alert("withdrawAudit error");}
	})
}

//修改模板信息
function modifyUserTempInfo(ids,status,memo)
{
	if (ids.length == 0)
	{
		top.$.messager.alert('提示','未勾选数据', 'info');
		return;
	}
	var tmpMaxLevel = "1";
	if (maxLevel !== "") tmpMaxLevel = maxLevel;
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"string",
			"Class":"EMRservice.BL.BLIEUserTemplate",
			"Method":"ModifyUserTempStatus",
			"p1":ids,
			"p2":status,
			"p3":memo,
			"p4":userId,
			"p5":tmpMaxLevel,
			"p6":getIpAddress()
		},
		success: function(d){
			if(d == "1"){
				initData();
				cleanDocument();
			}else{
				top.$.messager.alert('提示','修改状态失败', 'info');
			}
		},
		error: function(d) {alert("commitAudit error");}
	})
}

//打开模板
function openTemplate(TemplateVersionId)
{
	if (plugin() == undefined)
	{
		var objString = "<object id='plugin' type='application/x-iemrplugin' style='width:100%;height:100%;padding:0px;'></object>";
		$('#divPlugin').append(objString);
	}
	pluginAdd();
	plugin().initWindow("iEditor");
	//建立数据连接
	if (setConnect() == "err") 
	{
		top.$.messager.alert('提示','链接数据库失败，可能登录超时', 'info');
		return;
	}
	//设置工作环境
	cmdDoExecute({
		"action" : "SET_WORKSPACE_CONTEXT",
		"args" : "Template"
	});
	cmdDoExecute({
		action : "SET_NOTE_STATE",
		args : "Browse"
	});
	setTemplateLoadSection();
	//加载文档
	loadlTemplate(TemplateVersionId);
}

//异步执行execute
function cmdDoExecute(argJson) {
	plugin().execute(JSON.stringify(argJson));
};

//同步执行
function cmdSyncExecute(argJson) {
	return plugin().syncExecute(JSON.stringify(argJson));
};

//查找插件
function plugin() {
	return $("#plugin")[0];
}

//建立数据库连接
function setConnect(){
	var netConnect = "";
	
	var port = window.location.port;
	var protocol = window.location.protocol.split(":")[0];
	
	if (protocol == "http")
	{
		port = port==""?"80":port;
	}
	else if (protocol == "https")
	{
		port = port==""?"443":port;
	}
	
    $.ajax({
        type: 'Post',
        dataType: 'text',
        url: '../EMRservice.Ajax.common.cls',
        async: false,
        cache: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLSysOption",
            "Method":"GetNetConnectJson",
            "p1":window.location.hostname,
			"p2":port,
			"p3":protocol
        },
        success: function (ret) {
			try{
            	netConnect = eval("("+ret+")");
			}catch(err){
				return "err";
			}
        },
        error: function (ret) {
            alert('setConnect err');
            if (!onError) {}
            else {
                onError(ret);
            }
        }
    });
    var strJson = {
        action: 'SET_NET_CONNECT',
        args: netConnect
    };
	return cmdSyncExecute(strJson);
}

//挂接插件\事件监听
function pluginAdd() {
	addEvent(plugin(), 'onFailure', function (command) {
		alert(command);
	});
	addEvent(plugin(), 'onExecute', function (command) {
		var commandJson = jQuery.parseJSON(command);
		if (commandJson.action == "eventElementChanged") {
			eventElementChanged(commandJson);
		} else if (commandJson.action == "eventLoadDocument") {
			eventLoadDocument(commandJson);
		}
	});
}

//添加监听事件
function addEvent(obj, name, func) {
	if (obj.attachEvent) {
		obj.attachEvent("on" + name, func);
	} else {
		obj.addEventListener(name, func, false);
	}
}

//加载模板
function loadlTemplate(TemplateVersionId) {
	var strJson = {
		"action" : "LOAD_DOCUMENT",
		"args" : {
			"params" : {
				"action" : "LOAD_TEMPLATE",
				"TemplateVersionId" : TemplateVersionId
			}
		}
	};
    cmdDoExecute(strJson);
}

function setTemplateLoadSection()
{
	cmdDoExecute({
		action : "SET_TEMPLATE_LOAD_SECTION",
		args : {"LoadSection":true,"UserTemplateCode":openTemplateInfo.Code}
	});
}

//清空文档
function cleanDocument()
{
	if (plugin() != undefined)
	{
		var strJson = {
			"action" : "CLEAN_DOCUMENT",
			"args" : ""
		};
	    cmdDoExecute(strJson);
	}
	$("#userTemplatePath").val("");
	$("#txaMemo").val("");
	$("#btnBack").linkbutton('disable');
	$("#btnModify").linkbutton('disable');
}

//加载科室模板
function eventLoadDocument(commandJson) {
	loadTempFlag = true;
	if (commandJson.args.result == "ERROR") {
		alert('加载失败！');
		return;
	}
	$("#btnBack").linkbutton('enable');
	var tab = $('#statusTypeTabs').tabs('getSelected');
	var index = $('#statusTypeTabs').tabs('getTabIndex',tab);
	if (index != 2) $("#btnModify").linkbutton('enable');	//不是已审核的模板可以修改
	argJson = {action:"SET_READONLY", args:{"ReadOnly":true}};
	cmdDoExecute(argJson);
}

function eventElementChanged(commandJson) {
	
}

//打开修改科室模板的模态框
function openModifyTemplate()
{
	if (openTemplateInfo.RowId == "")
	{
		top.$.messager.alert('提示','需要打开模板才能进行修改模板操作', 'info');
		return;
	}
	var tempFrame = "<iframe id='iframeUserTempModify'  frameborder='0' src='emr.ip.usertemplate.audit.make.csp?UserTempId="+openTemplateInfo.RowId+"&UserTempCode="+openTemplateInfo.Code+"&TemplateVersionId="+openTemplateInfo.TemplateVersionId+"' style='width:100%; height:100%; display:block;'></iframe>";
	var winWidth = document.body.clientWidth-100;
	var winHeight = document.body.clientHeight-100; 
	createModalDialog("dialogUserTempModify","科室模板修改",winWidth,winHeight,"iframeUserTempModify",tempFrame,openModifyTempBack,"");       
}

//
function openModifyTempBack()
{
	$("#plugin").css("height","100%");
	$("#plugin").css("width","100%");
	if (plugin() != undefined)
	{
		var strJson = {
			"action" : "CLEAN_DOCUMENT",
			"args" : ""
		};
	    cmdDoExecute(strJson);
	}
	openTemplate(openTemplateInfo.TemplateVersionId);
}