$(function(){
	init();
});

function init()
{
	initCombobox();
}

function initCombobox()
{
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLEMRTemplateGroup",
			"Method":"GetEMRTemplateGroup",
			"p1":locID
		},
		success: function(d) {
			if(d != "") setEMRTemplateGroup(eval("["+d+"]"));
		},
		error : function(d) { 
			alert("GetTemplateSet error");
		}
	});
}

function setEMRTemplateGroup(data)
{
	$('#templateRecord').combobox({
		valueField:'TemplateGroupCode',                        
		textField:'TemplateGroupName',
		width:200,
		height:22,
		panelHeight:'auto',
		data:data,
		onLoadSuccess:function()
		{
			if ($('#templateRecord').combobox('getValue') === "")
			{
				$('#templateRecord').combobox('select',data[0]["TemplateGroupCode"]);
			}
		},
		onSelect:function(record)
		{
			loadTemplate(record.TemplateGroupCode);
		}
	});
}

function loadRecord(categoryId)
{
	var groupCode = $('#templateRecord').combobox('getValue');
	loadTemplate(groupCode);
}

function loadTemplate(groupCode)
{
	var templateData = getTemplateData(groupCode);
	var recordData = getRecordData(groupCode);
	$('.display').empty();
	if (templateData != "") setTemplate(templateData);
	if (recordData != "") setRecord(recordData);
}
//获得模板
function getTemplateData(groupCode)
{
	var data = "";
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLEMRTemplateGroup",
			"Method":"GetTempCateJsonByGroupCode",
			"p1":episodeID,
			"p2":groupCode
		},
		success: function(d) {
			if(d != "") data = eval("["+d+"]");
		},
		error : function(d) { 
			alert("GetTempCateJsonByGroupCode error");
		}
	});
	return data;
}

//获得实例数据
function getRecordData(groupCode)
{
	var data = "";
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLEMRTemplateGroup",
			"Method":"GetInstanceJsonByGroupCodeSingle",
			"p1":episodeID,
			"p2":groupCode,
			"p3":"Save"
		},
		success: function(d) {
			if(d != ""){
				data = eval("["+d+"]");
			}
		},
		error : function(d) { 
			alert("GetInstanceJsonByGroupCode error");
		}
	});
	return data;
}

//加载卡片模板数据
function setTemplate(data)
{
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li onClick="createDocument(this)"></li>');
		$(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].isLeadframe});
		$(link).attr({"chartItemType":data[i].chartItemType,"documentType":data[i].documentType});
		$(link).attr({"isMutex":data[i].isMutex,"categoryId":data[i].categoryId,"groupCode":data[i].groupCode});
		$(link).attr({"templateId":data[i].templateId});
		
		var div = $('<div class="template"></div>');
		$(div).append('<a href="#"><div class="title">' +data[i].text+ '</div></a>');
		$(div).append('<div class="janespell" style="display:none;">' +data[i].JaneSpell+ '</div>');
		$(div).append('<div class="fullfight" style="display:none;">' +data[i].FullFight+ '</div>');
		$(link).append(div);
		
		$('.display').append(link);
	}
}
//加载卡片实例数据
function setRecord(data)
{
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li onClick="openDocument(this)"></li>');
		$(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].isLeadframe});
		$(link).attr({"chartItemType":data[i].chartItemType,"documentType":data[i].documentType});		
		$(link).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":data[i].categoryId});
		$(link).attr({"templateId":data[i].templateId,"characteristic":data[i].characteristic,"groupCode":data[i].groupCode});
		
		var div = $('<div class="instance"></div>');
		if (data[i].hasSign == "0") $(div).addClass("pic");
		$(div).append('<a href="#"><div class="content">' +data[i].summary+ '</div></a>');
		var tag = $('<div class="tag" onmouseover="tip.show(this)" onmouseout="tip.hide()"></div>');
		$(tag).append('<div title="'+data[i].text+ '" class="title">' +data[i].text+ '</div>');
		$(tag).append('<div class="time">' +data[i].happendate+" "+data[i].happentime+" "+'</div>');
		$(tag).append('<div class="janespell" style="display:none;">' +data[i].JaneSpell+ '</div>');
		$(tag).append('<div class="fullfight" style="display:none;">' +data[i].FullFight+ '</div>');
		$('.display').append($(link).append($(div).append(tag)));
	}
}

///过滤页面卡片
function searchSelect(value)
{
	if(!(/^[\u4e00-\u9fa5]+$/i).test(value)){
		 value = value.toUpperCase();
	}
	$('#corddisplay .display li').hide();
	var $instance = $('#corddisplay .display li .instance .tag').filter(":contains('"+$.trim(value)+"')");
	$instance.parent().parent().show();
	var $template = $('#corddisplay .display li .template').filter(":contains('"+$.trim(value)+"')");
	$template.parent().show();
}

//从模板新建
function createDocument(obj)
{
	var obj = $(obj).closest("li");
    var tabParam = {
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
 
	///创建病历 	
	operateRecord(tabParam);			
	
	//自动记录病例操作日志
	CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");
}

//打开文档
function openDocument(obj)
{ 
	var obj = $(obj).closest("li");
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
	operateRecord(tabParam);
	
	//自动记录病例操作日志
	openDocumentLog(tabParam,"EMR.Nav.RecordNav.Open");
}

