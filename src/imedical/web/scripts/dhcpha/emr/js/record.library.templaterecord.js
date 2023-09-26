var TempData = "";
var GridData = "";
$(function(){
	if($.browser.version == '11.0')
	{
		document.documentElement.className ='ie11';
	}
	$("#listdisplay").hide();
	loadRecord(categoryID);
	//模板跨科检索
	searchAcrossDepartDocID = getSearchAcrossDepartDocID();
});﻿

//获取哪个病历展现结构目录需要跨科检索
function getSearchAcrossDepartDocID()
{
	var searchDocID = new Array();
	if (searchAcrossDepartment != "")
	{
		var strXml = convertToXml(searchAcrossDepartment);
	    $(strXml).find("item").each(function(){
		    var code = $(this).find("code").text();
		    searchDocID.push(code);
	    });
	}
    return searchDocID;
}


//视图显示方式
function loadRecord(categoryId)
{
	if(parent.parent.$("#ChangeShowMethod").combobox('getValue') == "ListShow")
	{
		//显示表格视图
		loadListRecrod(categoryId);
	}
	else
	{
		if(parent.parent.$("#ChangeShowMethod").combobox('getValue') == "MedPicShow")
		{
			$('#selectcss').attr("href","../scripts/emr/css/templaterecord-Med.css");
		}
		else if(parent.parent.$("#ChangeShowMethod").combobox('getValue') == "SmallPicShow")
		{
			$('#selectcss').attr("href","../scripts/emr/css/templaterecord-Small.css");
		}
		else
		{
			$('#selectcss').attr("href","../scripts/emr/css/templaterecord.css");
		}
		//显示卡片视图
		loadTemplateRecrod(categoryId);
	}
}

//表格视图显示
function loadListRecrod(categoryId)
{
	$('.display').empty();
	$("#corddisplay").hide();
	$("#listdisplay").show();
	$("#listdisplay").layout('expand','north');
	getListTemplate("EMRservice.BL.BLClientCategory","GetTempCateJsonByCategoryID",categoryId,episodeID,false,"List");
   	getListRecord("EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",categoryId,episodeID,false,"List",recordSequence.NavRecord);
	debugger;
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
		parent.parent.parent.operateRecord(tabParam);
		
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
		parent.parent.parent.operateRecord(tabParam);
		
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
			{field:'summary',title:'备注',width:642,resizable:true},
			{field:'action',title:'操作',width:200,formatter: Action},
			{field:'documentType',hidden:true},{field:'chartItemType',hidden:true},
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
			parent.parent.parent.operateRecord(tabParam);
			
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
var instanceId = "";
$(function(){
	//编辑备注
	$('#memo').window({
		title: "编辑备注",
		width: 400,  
		height: 300,  
		modal: true,
		minimizable: false,
		maximizable: false,
		collapsible: false,
		closed: true	 
	});
	$('#memo').css("display","block");
	
	//保存备注信息
	$('#memoSure').click(function(){
		var memoText = $('#memoText').val();
		if (memoText.length > 1000)
		{
			alert("备注内容超出1000字数限制");
		}else{
			save(instanceId,memoText);
		}		
	});
	
	//取消或关闭编辑备注
	$("#memoCancel").click(function(){
		$('#memo').window('close');	
	});
});
//保存备注信息
function save(id,memoText){
	$.ajax({ 
		type: "post", 
		url: "../EMRservice.Ajax.common.cls", 
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLInstanceData",
			"Method":"SetDocumentMemo",
			"p1":id,
			"p2":stringTJson(memoText)
		},
		error: function (XMLHttpRequest, textStatus, errorThrown) { 
			alert(textStatus); 
		}, 
		success: function (data) { 
			if (data == "1")
			{
				$('#memo').window('close');
				if(parent.parent.$("#ChangeShowMethod").combobox('getValue') == "ListShow"){
					var ind = $('#gridshow').datagrid('getRowIndex',id);
					$('#gridshow').datagrid('updateRow',{index:ind,row:{summary:memoText}});
				}else{
					$('li[id="'+instanceId+'"] div.content').html(memoText);
					$('li[id="'+instanceId+'"] span.description').html(memoText);
				}
			}
			else
			{
				alert("备注修改失败!");
			}
		} 
	});
}

//卡片视图显示
function loadTemplateRecrod(categoryId)
{
	$("#listdisplay").hide();
	$("#corddisplay").show();
	$('.display').empty();
   	getTemplate("EMRservice.BL.BLClientCategory","GetTempCateJsonByCategoryID",categoryId,episodeID,false);
    getRecord("EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",categoryId,episodeID,false,"List",recordSequence.NavRecord);	
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
		$(div).append('<div class="janespell" style="display:none;">' +data[i].attributes.JaneSpell+ '</div>');
		$(div).append('<div class="fullfight" style="display:none;">' +data[i].attributes.FullFight+ '</div>');
		$(link).append(div);
		if (cardClassificationDisplay == "Y")
		{
			$('#templatecontent').append(link);
		}
		else
		{
			$('.display').append(link);
		}		
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
		$(div).append('<div class="janespell" style="display:none;">' +data[i].attributes.JaneSpell+ '</div>');
		$(div).append('<div class="fullfight" style="display:none;">' +data[i].attributes.FullFight+ '</div>');
		$(link).append(div);
		if (cardClassificationDisplay == "Y")
		{
			$('#templatecontent').append(link);
		}
		else
		{
			$('.display').append(link);
		}		
	}
}

//加载实例
function getRecord(className,methodName,parentID,episodeID,async,resultType,sequence)
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
			"p3":resultType,
			"p4":sequence
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
		$(link).attr({"templateId":data[i].templateId,"characteristic":data[i].characteristic});
		
		var div = $('<div class="instance"></div>');
		if (data[i].hasSign == "0")
		{
			if($.browser.version == '11.0')
			{
				$(div).append('<div class="pic" style="width:26px">待签</div>');
			}else{
				$(div).append('<div class="pic">待签</div>');
			}
		}
		$(div).append('<a href="#"><div class="content">' +data[i].summary+ '</div></a>');
		var tag = $('<div class="tag"></div>');
		$(tag).append('<div title="'+data[i].text+ '" class="title">' +data[i].text+ '</div>');
		if(data[i].summary!=""){
			$(tag).append('<div class="time">' +data[i].happendate+" "+data[i].happentime+" "+'<img class="instancedimg" src="../scripts/emr/image/icon/happendtime.png"/>'+" "+'<span onmouseover="tip.show(this)" onmouseout="tip.hide()">'+"详细"+'<span class="description" style="display:none">'+data[i].summary+'</span>'+'</span>'+'</div>');
		}else
		{
			$(tag).append('<div class="time">' +data[i].happendate+" "+data[i].happentime+" "+'<img class="instancedimg" src="../scripts/emr/image/icon/happendtime.png"/></div>');
		}
		$(tag).append('<div class="janespell" style="display:none;">' +data[i].JaneSpell+ '</div>');
		$(tag).append('<div class="fullfight" style="display:none;">' +data[i].FullFight+ '</div>');
		if (cardClassificationDisplay == "Y")
		{
			$('#recordcontent').append($(link).append($(div).append(tag)));
		}
		else
		{
			$('.display').append($(link).append($(div).append(tag)));
		}
	}
}
//编辑备注
$(".instance .tag .instancedimg").live('click',function(){
	var obj = $(this).closest("li");
	instanceId = obj.attr("id");
	var memo = $(this).next().children().html();
	$('#memo').window('open');
	$('#memoText').html(memo);
});

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



///检索当前病历
function selectRecord(value)
{
	var categoryId = parent.parent.$("#sortName").attr("categoryId")
	if(!(/^[\u4e00-\u9fa5]+$/i).test(value)){
		 value = value.toUpperCase();
	}
	if(parent.parent.$("#ChangeShowMethod").combobox('getValue') == "ListShow")
	{
		if ($.inArray(categoryId,searchAcrossDepartDocID)>-1)
		{
			$('.display').empty();
			searchListTemplate("EMRservice.BL.BLClientCategory","GetInformConsentTempCateJson",value,categoryId,episodeID,false,"List");
   			getListRecord("EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",categoryId,episodeID,false,"List",recordSequence.NavRecord);
			TempData = $("#listtemplate").datagrid("getData").rows;
			GridData = $("#gridshow").datagrid("getData").rows;
			$("#gridshow").hide();
			var newGrid = [];
			for(var i=0;i<GridData.length;i++){
				if(value != ""){
					if((GridData[i].text.indexOf(value)!=-1)||(GridData[i].JaneSpell.indexOf(value)!=-1)||(GridData[i].FullFight.indexOf(value)!=-1))
					{
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
					if((TempData[i].text.indexOf(value)!=-1)||(TempData[i].JaneSpell.indexOf(value)!=-1)||(TempData[i].FullFight.indexOf(value)!=-1))
					{
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
					if((GridData[i].text.indexOf(value)!=-1)||(GridData[i].JaneSpell.indexOf(value)!=-1)||(GridData[i].FullFight.indexOf(value)!=-1))
					{
						newGrid.push(GridData[i]);
					}
				}else if(value == ""){
					newGrid.push(GridData[i]);
				}
			}
			$("#gridshow").datagrid("loadData",newGrid).show();
		}
	}else
	{
		//是否支持跨科检索模板
		if ($.inArray(categoryId,searchAcrossDepartDocID)>-1)
		{
			if (value != "")
			{
				$('.display').empty();
   				searchTemplate("EMRservice.BL.BLClientCategory","GetInformConsentTempCateJson",value,categoryId,episodeID,false);
    			getRecord("EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",categoryId,episodeID,false,"List",recordSequence.NavRecord)	
    			$("#corddisplay .display li .instance").parent().hide();
    			var $instance = $("#corddisplay .display li .instance .tag").filter(":contains('"+$.trim(value)+"')");
				$instance.parent().parent().show();
			}
			else
			{
				$('.display').empty();
   				getTemplate("EMRservice.BL.BLClientCategory","GetTempCateJsonByCategoryID",categoryId,episodeID,false);
    			getRecord("EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",categoryId,episodeID,false,"List",recordSequence.NavRecord)	
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