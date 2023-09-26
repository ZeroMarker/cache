var TempData = "";
var GridData = "";

$(function(){
	$("#listdisplay").hide();
	///dws 2017-03-14 刷新页面时确定卡片的视图显示方式
	switch(parent.parent.ListOrPicFlag){
		case "listshow":
			loadListRecrod(parent.parent.$("#sortName").attr("categoryId"));
			break;
		case "Picshow":
			loadTemplateRecrod(parent.parent.$("#sortName").attr("categoryId"));
			break;
	};
	//loadTemplateRecrod(categoryID);
	
	//从模板新建
	$(".template .title").live('click',function(){
	    var obj = $(this).closest("li");
	    var tabParam ={
			"id":"",
			"text":obj.attr("text"),
			"pluginType":obj.attr("documentType"),
			"chartItemType":obj.attr("chartItemType"),
			"emrDocId":obj.attr("id"),
			"templateId":obj.attr("templateId"),
			"isLeadframe":obj.attr("isLeadframe"),
			"isMutex":obj.attr("isMutex"),
			"categoryId":obj.attr("categoryId"),
			"actionType":"CREATE",
			"status":"NORMAL",
			"closable":true
		 }; 	
		parent.parent.operateRecord(tabParam);	
		//自动记录药例操作日志
		CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");
	});
	
	//从既往药历新建
	$(".template .quote").live('click',function(){
		var obj = $(this).closest("li");
		var xpwidth=window.screen.width-20;
		var xpheight=window.screen.height-35;
		var returnValue = window.showModalDialog("emr.record.quotation.csp?EpisodeID="+episodeID+"&PatientID="+patientID+"&DocID="+obj.attr("id"),"","dialogHeight:"+xpheight+"px;dialogWidth:"+xpwidth+"px;status:no");
		if ((!returnValue)||(returnValue == "")) return;
	    var tabParam ={
			"id":"",
			"text":obj.attr("text"),
			"pluginType":obj.attr("documentType"),
			"chartItemType":obj.attr("chartItemType"),
			"emrDocId":obj.attr("id"),
			"templateId":obj.attr("templateId"),
			"isLeadframe":obj.attr("isLeadframe"),
			"isMutex":obj.attr("isMutex"),
			"categoryId":obj.attr("categoryId"),
			"actionType":"QUOTATION",
			"status":"NORMAL",
			"closable":true,
			"pInstanceId":returnValue
		 }; 	
		parent.parent.operateRecord(tabParam);
	
		//自动记录药例操作日志
		CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.CreateInOld");

	});

	//点击药历打开 打开卡片
	$(".instance .content").live('click',function(){
		var obj = $(this).closest("li");
	    var tabParam ={
			"id":obj.attr("id"),
			"text":obj.attr("text"),
			"pluginType":obj.attr("documentType"),
			"chartItemType":obj.attr("chartItemType"),
			"emrDocId":obj.attr("emrDocId"),
			"templateId":obj.attr("templateId"),
			"isLeadframe":obj.attr("isLeadframe"),
			"isMutex":obj.attr("isMutex"),
			"categoryId":obj.attr("categoryId"),
			"characteristic":obj.attr("characteristic"),
			"actionType":"LOAD",
			"status":obj.attr("status"),
			"closable":true
		}; 	
		parent.parent.operateRecord(tabParam);
		//自动记录药例操作日志
		openDocumentLog(tabParam,"EMR.Nav.RecordNav.Open");
	});
});﻿
//视图显示方式
function loadRecord(categoryId)
{
	if(parent.parent.$("#ChangeShowMethod").combobox('getValue') == "listshow")
	{
		//显示表格视图
		loadListRecrod(categoryId);
		parent.parent.ListOrPicFlag="listshow"; //dws 2017-03-14 视图显示方式切换为表格
	}
	else if(parent.parent.$("#ChangeShowMethod").combobox('getValue') == "Picshow")
	{
		//显示卡片视图
		loadTemplateRecrod(categoryId);
		parent.parent.ListOrPicFlag="Picshow"; //dws 2017-03-14  视图显示方式切换为卡片
	}
}

//表格视图显示
function loadListRecrod(categoryId)
{
	$('.display').empty();
	$("#corddisplay").hide();
	$("#listdisplay").show();
	$("#listdisplay").layout('expand','north');
	getListTemplate("web.DHCCM.EMRservice.BL.BLClientCategory","GetTempCateJsonByCategoryID",categoryId,episodeID,false,"List");
   	getListRecord("web.DHCCM.EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",categoryId,episodeID,false,"List");
	TempData = $("#listtemplate").datagrid("getData").rows;
	GridData = $("#gridshow").datagrid("getData").rows;
}
//加载新建模板列表
function getListTemplate(className,methodName,parentID,episodeID,async,displaytype)
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
	        {field:'text',title:'名称',width:200,sortable:true,sorter:function(a,b){  
				a = a.split('/');  
				b = b.split('/');  
				if (a[2] == b[2]){  
					if (a[0] == b[0]){  
						return (a[1]>b[1]?1:-1);  
					} else {  
						return (a[0]>b[0]?1:-1);  
					}  
				} else {  
					return (a[2]>b[2]?1:-1);  
				}  
			}},
			{field:'createoperate',title:'新建操作',width:150,sortable:true,sorter:function(a,b){  
				a = a.split('/');  
				b = b.split('/');  
				if (a[2] == b[2]){  
					if (a[0] == b[0]){  
						return (a[1]>b[1]?1:-1);  
					} else {  
						return (a[0]>b[0]?1:-1);  
					}  
				} else {  
					return (a[2]>b[2]?1:-1);  
				}  
			},formatter: CreateOperate},
			{field:'quoteoperate',title:'引用操作',width:150,sortable:true,sorter:function(a,b){  
				a = a.split('/');  
				b = b.split('/');  
				if (a[2] == b[2]){  
					if (a[0] == b[0]){  
						return (a[1]>b[1]?1:-1);  
					} else {  
						return (a[0]>b[0]?1:-1);  
					}  
				} else {  
					return (a[2]>b[2]?1:-1);  
				}  
			},formatter: QuoteOperate},{field:'quotation',hidden:true},
			{field:'documentType',hidden:true},{field:'chartItemType',hidden:true},
			{field:'categoryId',hidden:true},{field:'templateId',hidden:true},
			{field:'isLeadframe',hidden:true},{field:'isMutex',hidden:true}
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
		parent.parent.operateRecord(tabParam);
		
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
//从既往药历新建
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
		parent.parent.operateRecord(tabParam);
		
	    //自动记录病例操作日志
	    CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.CreateInOld");
	}
}
//加载表格药历实例
function getListRecord(className,methodName,parentID,episodeID,async,displaytype)
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
			"p3":displaytype
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
	    sortName:['text','happendate','happentime'],
	    sortOrder:'desc',
	    remoteSort:false,
	    nowrap:true,
	    striped:true,
	    fit:true,
	    overflow:'auto',
	    columns:[[
	    	{field:'id',title:'id',hidden:true},
			{field:'status',title:'签名状态',width:100,formatter: StatusOperate},
	        {field:'text',title:'名称',width:200,sortable:true,sorter:function(a,b){  
				a = a.split('/');  
				b = b.split('/');  
				if (a[2] == b[2]){  
					if (a[0] == b[0]){  
						return (a[1]>b[1]?1:-1);  
					} else {  
						return (a[0]>b[0]?1:-1);  
					}  
				} else {  
					return (a[2]>b[2]?1:-1);  
				}  
			}},
			{field:'happendate',title:'发生日期',width:150,sortable:true,sorter:function(a,b){  
				a = a.split('/');  
				b = b.split('/');  
				if (a[2] == b[2]){  
					if (a[0] == b[0]){  
						return (a[1]>b[1]?1:-1);  
					} else {  
						return (a[0]>b[0]?1:-1);  
					}  
				} else {  
					return (a[2]>b[2]?1:-1);  
				}  
			}},
			{field:'happentime',title:'发生时间',width:150,sortable:true,sorter:function(a,b){  
				a = a.split('/');  
				b = b.split('/');  
				if (a[2] == b[2]){  
					if (a[0] == b[0]){  
						return (a[1]>b[1]?1:-1);  
					} else {  
						return (a[0]>b[0]?1:-1);  
					}  
				} else {  
					return (a[2]>b[2]?1:-1);  
				}  
			}},
			{field:'summary',title:'备注',width:642,resizable:true,hidden:true},	// qunaianpeng 2018/3/30 隐藏备注列
			{field:'documentType',hidden:true},{field:'chartItemType',hidden:true},
			{field:'emrDocId',hidden:true},{field:'emrNum',hidden:true},
			{field:'templateId',hidden:true},{field:'isLeadframe',hidden:true},
			{field:'isMutex',hidden:true},{field:'categoryId',hidden:true}
		]],
		//点击表格病历打开
		onClickRow:function(index,row)
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
			parent.parent.operateRecord(tabParam);
			
			//自动记录病例操作日志
			openDocumentLog(tabParam,"EMR.Nav.RecordNav.Open");
		}
	});
}
//签名状态设置
function StatusOperate(val,row,index)
{
	if(row.status == "草稿")
	{
		var span = '<a>待签</a>';  
		return span;
	}else{
		var span = '<a>'+row.status+'</a>';  
		return span;
	}
}
//卡片视图显示
function loadTemplateRecrod(categoryId)
{
	$("#listdisplay").hide();
	$("#corddisplay").show();
	$('.display').empty();
   	getTemplate("web.DHCCM.EMRservice.BL.BLClientCategory","GetTempCateJsonByCategoryID",categoryId,episodeID,false);
    //getRecord("EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",categoryId,episodeID,false,"List");
    getRecord("web.DHCCM.EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",categoryId,episodeID,false,"List");  /// 2016-09-26 bianshuai
}

//获得模板
function getTemplate(className,methodName,parentID,episodeID,async)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: async,
		data: {
			"OutputType":"Stream",
			"Class":className,
			"Method":methodName,
			"p1":parentID,
			"p2":episodeID,
			"p3":userID
		},
		success: function(d) {
			setTemplate(eval("["+d+"]"),parentID);
		},
		error : function(d) { 
			alert("getTemplate error");
		}
	});
}

//加载模板
function setTemplate(data,categoryId)
{
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li></li>');
		$(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].attributes.isLeadframe});
		$(link).attr({"chartItemType":data[i].attributes.chartItemType,"documentType":data[i].attributes.documentType});
		$(link).attr({"isMutex":data[i].attributes.isMutex,"categoryId":categoryId});
		$(link).attr({"templateId":data[i].attributes.templateId});
		
		var div = $('<div class="template"></div>');
		if (data[i].attributes.quotation == "1")
		{
			$(div).append('<a href="#"><div class="new" ><div class="title">' +data[i].text+ '</div></div></a>');
			$(div).append('<a href="#"><div class="quote"></div></a>');	
		}
		else
		{
			$(div).append('<a href="#"><div class="title">' +data[i].text+ '</div></a>');
		}
		$(link).append(div);
		$('.display').append(link);		
	}
}

//搜索知情同意书模板
function searchTemplate(className,methodName,searchValue,parentID,episodeID,async)
{
	jQuery.ajax({
		type: "get",
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
			"p4":userID
		},
		success: function(d) {
			setSearchTemplate(eval("["+d+"]"),parentID);
		},
		error : function(d) { 
			alert("searchTemplate error");
		}
	});
}

//加载知情同意书搜索后模板
function setSearchTemplate(data,categoryId)
{
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li></li>');
		$(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].attributes.isLeadframe});
		$(link).attr({"chartItemType":data[i].attributes.chartItemType,"documentType":data[i].attributes.documentType});
		$(link).attr({"isMutex":data[i].attributes.isMutex,"categoryId":categoryId});
		$(link).attr({"templateId":data[i].attributes.templateId});
		
		var div = $('<div class="template"></div>');
		if(data[i].attributes.disCurDocGropName != "")
		{
			if (data[i].attributes.quotation == "1")
			{
				$(div).append('<a href="#"><div class="new" ><div class="title" style="height:100px; line-height:45px;">' +data[i].text+ '</div></div></a>');
				$(div).append('<a href="#"><div class="quote" style="height:90px;"></div></a>');	
			}
			else
			{
				$(div).append('<a href="#"><div class="title" style="height:190px;">' +data[i].text+ '</div></a>');
				//$(div).append('<a href="#"><div class="new" ><div class="title" style="height:100px; line-height:45px;">' +data[i].text+ '</div></div></a>');
				//$(div).append('<a href="#"><div class="quote" style="height:90px;"></div></a>');
			}
			$(div).append('<a id="search" class="groupName" href="#" class="easyui-tooltip" title='+data[i].attributes.disCurDocGropName+ '>' +data[i].attributes.disCurDocGropName+ '</a>');
		}
		else
		{
			if (data[i].attributes.quotation == "1")
			{
				$(div).append('<a href="#"><div class="new" ><div class="title">' +data[i].text+ '</div></div></a>');
				$(div).append('<a href="#"><div class="quote"></div></a>');	
			}
			else
			{
				$(div).append('<a href="#"><div class="title">' +data[i].text+ '</div></a>');
			}
		}
		$(link).append(div);
		$('.display').append(link);		
	}
}

//加载实例
function getRecord(className,methodName,parentID,episodeID,async,resultType)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: async,
		data: {
			"OutputType":"Stream",
			"Class":className,
			"Method":methodName,
			"p1":parentID,
			"p2":episodeID,
			"p3":resultType
		},
		success: function(d) {
			setRecord(eval("["+d+"]"),parentID);
		},
		error : function(d) { 
			alert("getRecord error");
		}
	});	
}

//加载文档
function setRecord(data,categoryId)
{
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li></li>');
		$(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].isLeadframe});
		$(link).attr({"chartItemType":data[i].chartItemType,"documentType":data[i].documentType});		
		$(link).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":categoryId});
		$(link).attr({"templateId":data[i].templateId,"characteristic":data[i].characteristic,"status":data[i].status});
		
		var div = $('<div class="instance"></div>');
		if (data[i].status == "草稿") $(div).append('<div class="pic" >待签</div>');
		$(div).append('<a href="#"><div class="content">' +data[i].summary+ '</div></a>');
		var tag = $('<div class="tag"></div>');
		$(tag).append('<div title="'+data[i].text+ '" class="title">' +data[i].text+ '</div>');
		if(data[i].summary!=""){
			$(tag).append('<div class="time">' +data[i].happendate+" "+data[i].happentime+" "+'<img class="instancedimg" src="../scripts/dhcpha/emr/image/icon/happendtime.png"/>'+" "+'<span onmouseover="tip.show(this)" onmouseout="tip.hide()">'+"详细"+'<span class="description" style="display:none">'+data[i].summary+'</span>'+'</span>'+'</div>');
		}else
		{
			$(tag).append('<div class="time">' +data[i].happendate+" "+data[i].happentime+" "+'<img class="instancedimg" src="../scripts/dhcpha/emr/image/icon/happendtime.png"/></div>');
		}
		$('.display').append($(link).append($(div).append(tag)));
	}
}
/*
//从模板新建
$(".template .title").live('click',function(){
    var obj = $(this).closest("li");
    var tabParam ={
		"id":"",
		"text":obj.attr("text"),
		"pluginType":obj.attr("documentType"),
		"chartItemType":obj.attr("chartItemType"),
		"emrDocId":obj.attr("id"),
		"templateId":obj.attr("templateId"),
		"isLeadframe":obj.attr("isLeadframe"),
		"isMutex":obj.attr("isMutex"),
		"categoryId":obj.attr("categoryId"),
		"actionType":"CREATE",
		"status":"NORMAL",
		"closable":true
	 }; 	
	parent.parent.parent.operateRecord(tabParam);	
	
	//自动记录病例操作日志
	CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");
});


//从既往病历新建
$(".template .quote").live('click',function(){
	var obj = $(this).closest("li");
	var xpwidth=window.screen.width-20;
	var xpheight=window.screen.height-35;
	var returnValue = window.showModalDialog("emr.record.quotation.csp?EpisodeID="+episodeID+"&PatientID="+patientID+"&DocID="+obj.attr("id"),"","dialogHeight:"+xpheight+"px;dialogWidth:"+xpwidth+"px;status:no");
	if ((!returnValue)||(returnValue == "")) return;
    var tabParam ={
		"id":"",
		"text":obj.attr("text"),
		"pluginType":obj.attr("documentType"),
		"chartItemType":obj.attr("chartItemType"),
		"emrDocId":obj.attr("id"),
		"templateId":obj.attr("templateId"),
		"isLeadframe":obj.attr("isLeadframe"),
		"isMutex":obj.attr("isMutex"),
		"categoryId":obj.attr("categoryId"),
		"actionType":"QUOTATION",
		"status":"NORMAL",
		"closable":true,
		"pInstanceId":returnValue
	 }; 	
	parent.parent.parent.operateRecord(tabParam);
	
	//自动记录病例操作日志
	CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.CreateInOld");

});

//点击病历打开
$(".instance .content").live('click',function(){
	var obj = $(this).closest("li");
    var tabParam ={
		"id":obj.attr("id"),
		"text":obj.attr("text"),
		"pluginType":obj.attr("documentType"),
		"chartItemType":obj.attr("chartItemType"),
		"emrDocId":obj.attr("emrDocId"),
		"templateId":obj.attr("templateId"),
		"isLeadframe":obj.attr("isLeadframe"),
		"isMutex":obj.attr("isMutex"),
		"categoryId":obj.attr("categoryId"),
		"characteristic":obj.attr("characteristic"),
		"actionType":"LOAD",
		"status":"NORMAL",
		"closable":true
	}; 	
	parent.parent.parent.operateRecord(tabParam);
	
	//自动记录病例操作日志
	openDocumentLog(tabParam,"EMR.Nav.RecordNav.Open");
});
*/
///检索当前药历
function selectRecord(value)
{
	var categoryId = parent.parent.$("#sortName").attr("categoryId")
	if(parent.parent.$("#ChangeShowMethod").combobox('getValue') == "Picshow")
	{
		if (categoryId == "7")
		{
			if (value != "")
			{
				$('.display').empty();
   				searchTemplate("web.DHCCM.EMRservice.BL.BLClientCategory","GetInformConsentTempCateJson",value,categoryId,episodeID,false);
    			getRecord("web.DHCCM.EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",categoryId,episodeID,false,"List")	
    			$("#corddisplay .display li .instance").parent().hide();
    			var $instance = $("#corddisplay .display li .instance .tag").filter(":contains('"+$.trim(value)+"')");
				$instance.parent().parent().show();
			}
			else
			{
				$('.display').empty();
   				getTemplate("web.DHCCM.EMRservice.BL.BLClientCategory","GetTempCateJsonByCategoryID",categoryId,episodeID,false);
    			getRecord("web.DHCCM.EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",categoryId,episodeID,false,"List")	
			}
		}
		else
		{
			$("#corddisplay .display li").hide();
			var $instance = $("#corddisplay .display li .instance .tag").filter(":contains('"+$.trim(value)+"')");
			$instance.parent().parent().show();
			var $template = $("#corddisplay .display li .template").filter(":contains('"+$.trim(value)+"')");
			$template.parent().show();
		}
	}else if(parent.parent.$("#ChangeShowMethod").combobox('getValue') == "listshow")
	{
		if (categoryId == "7")
		{
			$('.display').empty();
			searchListTemplate("web.DHCCM.EMRservice.BL.BLClientCategory","GetInformConsentTempCateJson",value,categoryId,episodeID,false,"List");
   			getListRecord("web.DHCCM.EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",categoryId,episodeID,false,"List");
			TempData = $("#listtemplate").datagrid("getData").rows;
			GridData = $("#gridshow").datagrid("getData").rows;
			$("#gridshow").hide();
			var newGrid = [];
			for(var i=0;i<GridData.length;i++){
				if(value != ""){
					if(GridData[i].text.indexOf(value)!=-1){
						newGrid.push(GridData[i]);
					}
				}else if(value == ""){
					newGrid.push(GridData[i]);
				}
			}
			$("#gridshow").datagrid("loadData",newGrid).show();
		}
		else
		{
			$("#listtemplate").hide();
			$("#gridshow").hide();
			var newTemp = [];
			for(var i=0;i<TempData.length;i++){
				if(value != ""){
					if(TempData[i].text.indexOf(value)!=-1){
						newTemp.push(TempData[i]);
					}
				}else if(value == ""){
					newTemp.push(TempData[i]);
				}
			}
			$("#listtemplate").datagrid("loadData",newTemp).show();
			var newGrid = [];
			for(var i=0;i<GridData.length;i++){
				if(value != ""){
					if(GridData[i].text.indexOf(value)!=-1){
						newGrid.push(GridData[i]);
					}
				}else if(value == ""){
					newGrid.push(GridData[i]);
				}
			}
			$("#gridshow").datagrid("loadData",newGrid).show();
		}
	}
}

///鼠标动作
var objA = null,intrval = null;
var tip =
{
	mousePos:function(e)
	{
		var x,y;
		var e = e||window.event;
		return{x:e.clientX+document.body.scrollLeft+document.documentElement.scrollLeft,y:e.clientY+document.body.scrollTop+document.documentElement.scrollTop};
	},
	show:function(obj)
	{
		if(!obj)obj = objA;
   		else objA = obj;
   		if(intrval)
   		{
	   		window.clearTimeout(intrval);
    		intrval = null;
   		} 
   		var self = this; 
   		var t = document.getElementById("messagetip"); 
   		obj.onmousemove = function(e)
   		{ 
   			var mouse = self.mousePos(e);
   			t.style.left = mouse.x - 150 + 'px';
   			t.style.top = mouse.y - 220 + 'px';
   			var str = obj.innerText;
   			str = str.substr(2);
   			t.innerHTML = str;
  	 		t.style.overflow = "auto";
   			t.style.backgroundColor = '#EFF8FE';
   			t.style.display = "block";
  		}
  	},
	hide:function()
	{	
		intrval = window.setTimeout(function(){document.getElementById("messagetip").style.display="none";},80);
   	}
}