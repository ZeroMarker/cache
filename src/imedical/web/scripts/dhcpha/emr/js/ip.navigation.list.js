var TempData = "";
var GridData = "";

document.getElementById("cordDisplay").onclick = function(){
	loadTemplateRecrod();
	displayConfig = "CORD";
	selectDisplayType();
	//saveDisplayUserConfig();
}

document.getElementById("listDisplay").onclick = function(){
	loadListRecrod();
	displayConfig = "LIST";
	selectDisplayType();
	//saveDisplayUserConfig();
}

//表格视图显示
function loadListRecrod()
{
	$('.display').empty();
	$("#corddisplay").hide();
	$("#listdisplay").show();
	$("#listdisplay").layout('expand','north');
	getListTemplate("EMRservice.BL.BLClientCategory","GetTempCateJsonByCategoryID",categoryID,episodeID,false,"List");
   	getListRecord("EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",categoryID,episodeID,false,"List",displaySeq);
	TempData = $("#listtemplate").datagrid("getData").rows;
	GridData = $("#gridshow").datagrid("getData").rows;
}
//加载新建模板列表
function getListTemplate(className,methodName,parentID,episodeID,async,displaytype)
{
	debugger;
	jQuery.ajax({
		type: "Get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: async,
		data: {
			"OutputType":"Stream",
			"Class":className,
			"Method":methodName,
			"p1":parentID,
			"p2":episodeID,
			"p3":userID,
			"p4":displaytype
		},
		success: function(d) {
			var data = eval("["+d+"]");
			TemplateList(data);
		},
		error : function(d) { 
			alert("getListTemplate error");
		}
	});
}
//加载模板表格视图列表
function TemplateList(data)
{
	$('#listtemplate').datagrid({
	    fitColumns:true, 
	    loadMsg:'数据装载中......',
	    autoRowHeight:true,
	    data:data,
	    singleSelect:true,
	    idField:'emrDocId',
	    sortName:'text',
	    sortOrder:'desc',
	    remoteSort:false,
	    nowrap:true,
	    striped:true,
	    fit:true,
	    overflow:'auto',
	    columns:[[
	    	{field:'emrDocId',title:'emrDocId',hidden:true},
	        {field:'text',title:'名称',width:200,sortable:true},
			{field:'createoperate',title:'新建操作',width:150,sortable:true,formatter: CreateOperate},
			{field:'quoteoperate',title:'引用操作',width:150,sortable:true,formatter: QuoteOperate},{field:'quotation',hidden:true},
			{field:'documentType',hidden:true},{field:'chartItemType',hidden:true},
			{field:'categoryId',hidden:true},{field:'templateId',hidden:true},
			{field:'isLeadframe',hidden:true},{field:'isMutex',hidden:true},
			{field:'JaneSpell',hidden:true},{field:'FullFight',hidden:true}
		]]
	});
}

//搜索知情同意书新建模板列表
function searchListTemplate(className,methodName,searchValue,parentID,episodeID,async,displaytype)
{
	jQuery.ajax({
		type: "Get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: async,
		data: {
			"OutputType":"Stream",
			"Class":className,
			"Method":methodName,
			"p1":searchValue,
			"p2":parentID,
			"p3":episodeID,
			"p4":userID,
			"p5":displaytype
		},
		success: function(d) {
			var data = eval("["+d+"]");
			TemplateList(data);
		},
		error : function(d) { 
			alert("searchListTemplate error");
		}
	});
}

//新建操作
function CreateOperate(val,row,index)
{
	var span = '<a id="createoperate" onclick="CreateClick('+"'"+index+"'"+')">新建</a>';  
	return span;
}
//从模板新建
function CreateClick(index)
{
	$('#listtemplate').datagrid('selectRow',index);
	var row = $('#listtemplate').datagrid('getSelected');
	if (row)
	{
		var tabParam ={
			"id":"",
			"text":row.text,
			"pluginType":row.documentType,
			"chartItemType":row.chartItemType,
			"emrDocId":row.emrDocId,
			"templateId":row.templateId,
			"isLeadframe":row.isLeadframe,
			"isMutex":row.isMutex,
			"categoryId":row.categoryId,
			"actionType":"CREATE",
			"status":"NORMAL",
			"closable":true,
			"flag":"List"
		};
		
		tabParam = getParamByUserTemplate(tabParam);
		if (tabParam == "") return;
		parent.operateRecord(tabParam);
	    //自动记录病例操作日志
	    CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");
	}
}
//引用操作
function QuoteOperate(val,row,index)
{
	if(row.quotation == "1")
	{
		var span = '<a id="quoteoperate" onclick="QuoteClick('+"'"+index+"'"+')">引用</a>';  
		return span;
	}else
	{ 
		var span = '<a id="quoteoperate" style="color:grey;text-decoration:none;">引用</a>';  
		return span;
	}
}
//从既往病历新建
function QuoteClick(index)
{
	$('#listtemplate').datagrid('selectRow',index);
	var row = $('#listtemplate').datagrid('getSelected');
	if (row)
	{
		var xpwidth=window.screen.width-20;
		var xpheight=window.screen.height-35;
		var returnValue = window.showModalDialog("emr.record.quotation.csp?EpisodeID="+episodeID+"&PatientID="+patientID+"&DocID="+row.emrDocId,"","dialogHeight:"+xpheight+"px;dialogWidth:"+xpwidth+"px;status:no");
		if ((!returnValue)||(returnValue == "")) return;
		var tabParam ={
			"id":"",
			"text":row.text,
			"pluginType":row.documentType,
			"chartItemType":row.chartItemType,
			"emrDocId":row.emrDocId,
			"templateId":row.templateId,
			"isLeadframe":row.isLeadframe,
			"isMutex":row.isMutex,
			"categoryId":row.categoryId,
			"actionType":"QUOTATION",
			"status":"NORMAL",
			"closable":true,
			"pInstanceId":returnValue,
			"flag":"List"
		};
		parent.operateRecord(tabParam);
		
	    //自动记录病例操作日志
	    CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.CreateInOld");
	}
}
//加载表格病历实例
function getListRecord(className,methodName,parentID,episodeID,async,displaytype,sequence)
{
	jQuery.ajax({
		type: "Get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: async,
		data: {
			"OutputType":"Stream",
			"Class":className,
			"Method":methodName,
			"p1":parentID,
			"p2":episodeID,
			"p3":displaytype,
			"p4":sequence
		},
		success: function(d)
		{
			var data = eval("["+d+"]");
			ListInstance(data);
		},
		error: function(d){alert("getListRecord error");}
	});
}
//表格视图列表
function ListInstance(data)
{
	$('#gridshow').datagrid({
	    fitColumns:true, 
	    loadMsg:'数据装载中......',
	    autoRowHeight:true,
	    data:data,
	    singleSelect:true,
	    idField:'id',
	    sortOrder:'desc',
	    remoteSort:false,
	    nowrap:true,
	    striped:true,
	    fit:true,
	    overflow:'auto',
	    columns:[[
	    	{field:'id',title:'id',hidden:true},
			{field:'status',title:'签名状态',width:130,formatter: StatusOperate,sortable:true},
	        {field:'text',title:'名称',width:400,sortable:true},
	        {field:'createdate',title:'创建日期',width:150,sortable:true},
			{field:'createtime',title:'创建时间',width:130,sortable:true},
			{field:'happendate',title:'发生日期',width:150,sortable:true,hidden:true},
			{field:'happentime',title:'发生时间',width:130,sortable:true,hidden:true},
			{field:'creator',title:'创建人',width:150},
			{field:'operator',title:'最后修改人',width:150},
			{field:'summary',title:'备注',width:442,resizable:true},
			//{field:'action',title:'操作',width:200,formatter: Action},
			{field:'documentType',hidden:true},
			{field:'chartItemType',hidden:true},
			{field:'emrDocId',hidden:true},{field:'emrNum',hidden:true},
			{field:'templateId',hidden:true},{field:'isLeadframe',hidden:true},
			{field:'isMutex',hidden:true},{field:'categoryId',hidden:true},
			{field:'JaneSpell',hidden:true},{field:'FullFight',hidden:true}
			
		]],
		//点击表格病历打开
		onDblClickRow:function(index,row)
		{
			var tabParam ={
				"id":row.id,
				"text":row.text,
				"pluginType":row.documentType,
				"chartItemType":row.chartItemType,
				"emrDocId":row.emrDocId,
				"templateId":row.templateId,
				"isLeadframe":row.isLeadframe,
				"isMutex":row.isMutex,
				"categoryId":row.categoryId,
				"actionType":"LOAD",
				"status":"NORMAL",
		    	"closable":true,
		    	"flag":"List"
			};
			parent.operateRecord(tabParam);
			
			//自动记录病例操作日志
			openDocumentLog(tabParam,"EMR.Nav.RecordNav.Open");
		}
	});
}
//签名状态设置
function StatusOperate(val,row,index)
{
	if(row.hasSign == "0")
	{
		var span = '<a>待签</a>';  
		return span;
	}else{
		var span = '<a>'+row.status+'</a>';  
		return span;
	}
}
//操作
function Action(val,row,index)
{
	var span = '<a style="cursor:pointer;" onclick="EditSummary('+"'"+index+"'"+')">编辑备注</a>';  
	return span;
}
//编辑备注
function EditSummary(index)
{
	$('#gridshow').datagrid('selectRow',index);
	var row = $('#gridshow').datagrid('getSelected');
	if (row)
	{
		instanceId = row.id;
		$('#memo').window('open');
		$('#memoText').html(row.summary);
	}
}

function saveDisplayUserConfig()
{
	addUserConfigData(userID,locID,"DISPLAYTYPE",displayConfig);
}