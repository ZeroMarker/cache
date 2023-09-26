$(function(){
	init();
});

//模板跨科检索
var searchAcrossDepartDocID = getSearchAcrossDepartDocID();

//加载
function init()
{
	$('.display').empty();
   	var flag = checkCategoryIdInLocId(gl.episodeId,gl.userLocId,gl.categoryId,gl.groupId);
	if (flag == 1) getTemplate("EMRservice.BL.BLClientCategory","GetTempCateJsonByCategoryID",false);
    getRecord("EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",false,"List",gl.sequence);
}

//获得模板
function getTemplate(className,methodName,async)
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
			"p1":gl.categoryId,
			"p2":gl.episodeId,
			"p3":gl.userId,
			"p4":"",
			"p5":"",
			"p6":"",
			"p7":"",
			"p8":gl.docID
		},
		success: function(d) {
			setTemplate(eval("["+d+"]"));
		},
		error : function(d) { 
			alert("getTemplate error");
		}
	});
}
//加载模板
function setTemplate(data)
{
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li></li>');
		$(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].attributes.isLeadframe});
		$(link).attr({"chartItemType":data[i].attributes.chartItemType,"documentType":data[i].attributes.documentType});
		$(link).attr({"isMutex":data[i].attributes.isMutex,"categoryId":gl.categoryId});
		$(link).attr({"templateId":data[i].attributes.templateId});
		
		var div = $('<div class="template"></div>');
		if (data[i].attributes.quotation == "1")
		{
			//2020-6-19 by yejian 名称显示修改docid名称
			$(div).append('<a href="#" title=' +emrTrans("新建") +'><div class="new" ><div class="title">' +data[i].attributes.DocIDText+ '</div></div></a>');
			$(div).append('<a href="#" title=' +emrTrans("引用") +'><div class="quote"></div></a>');	
		}
		else
		{
			//2020-6-19 by yejian 名称显示修改docid名称
			$(div).append('<a href="#" title=' +emrTrans("新建") +'><div class="title">' +data[i].attributes.DocIDText+ '</div></a>');
		}
		$(div).append('<div class="janespell" style="display:none;">' +data[i].attributes.JaneSpell+ '</div>');
		$(div).append('<div class="fullfight" style="display:none;">' +data[i].attributes.FullFight+ '</div>');
		$(link).append(div);
		$('.display').append(link);
	}
}

//加载实例
function getRecord(className,methodName,async,resultType,sequence)
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
			"p1":gl.categoryId,
			"p2":gl.episodeId,
			"p3":resultType,
			"p4":sequence,
			"p5":gl.docID
		},
		success: function(d) {
			setRecord(eval("["+d+"]"),gl.categoryId);
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
		var contentclass = "class = 'content'";
		if ((data[i].doctorwait != "")&&(data[i].patientwait != ""))
		{
			var contentclass = getContentClass(data[i].doctorwait,data[i].patientwait);
		}
		$(div).append('<a href="#"><div ' +contentclass+ '>' +data[i].summary+ '</div></a>');
		var tag = $('<div class="tag" onmouseover="tip.show(this)" onmouseout="tip.hide()"></div>');
		$(tag).append('<div title="'+data[i].text+ '" class="title">' +data[i].text+ '</div>');
		$(tag).append('<div class="time">' +data[i].happendate+" "+data[i].happentime+'<a class="addMemo" title="单击修改备注">注</a>'+'</div>');
		$(tag).append('<div class="janespell" style="display:none;">' +data[i].JaneSpell+ '</div>');
		$(tag).append('<div class="fullfight" style="display:none;">' +data[i].FullFight+ '</div>');
		$('.display').append($(link).append($(div).append(tag)));
	}
}
///编辑备注///////////////////////////////////////////////////////////////////////////////////////////////////////////
var instanceId = "";
$(function(){
	//编辑备注
	$('#memo').css("display","block");
	$('#memo').window('close');
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
				$('li[id="'+instanceId+'"] div.content').html(memoText);
				$('li[id="'+instanceId+'"] span.description').html(memoText);
			}
			else
			{
				alert("备注修改失败!");
			}
		}
	});
}

$(document).on("click",".instance .tag .addMemo",function(){
	var obj = $(this).closest("li");
	instanceId = obj.attr("id");
	var memo = $(this).parent().parent().prev().children().html();
	$('#memo').window('open');
	$('#memoText').html(memo);
});

///新建病历/////////////////////////////////////////////////////////////////////////////////////////////////////////
//从卡片新建
$(document).on("click",".template .title",function(){
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
	 
	tabParam = getParamByUserTemplate(tabParam);
	if (tabParam == "") return;
	/*operateRecord(tabParam);
	//自动记录病例操作日志
	CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");*/

});

//从既往病历新建
$(document).on("click",".template .quote",function(){
	var obj = $(this).closest("li");
	var docId = obj.attr("id")
	//showQuotationDialog("病历引用","<iframe id='iframeQuotation' scrolling='auto' frameborder='0' src='emr.ip.quotation.csp?EpisodeID="+episodeID+"&PatientID="+patientID+"&DocID="+docId+"' style='width:100%; height:100%; display:block;overflow:hidden'></iframe>","quotationCardCallBack()");
	var iframeContent = "<iframe id='iframeQuotation' scrolling='auto' frameborder='0' src='emr.ip.quotation.csp?EpisodeID="+episodeID+"&PatientID="+patientID+"&DocID="+docId+"' style='width:100%; height:100%; display:block;overflow:hidden'></iframe>"
	parent.createModalDialog("quotationDialog","病历引用",window.screen.width-300,window.screen.height-300,"iframeQuotation",iframeContent,quotationCardCallBack,obj,true,false)
});



function quotationCardCallBack(returnValue,obj)
{
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
	 operateRecord(tabParam);
	//自动记录病例操作日志
	CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.CreateInOld");
}



///打开病历///////////////////////////////////////////////////////////////////////////////////////////////////////////
//点击病历打开
$(document).on("click",".instance .content",function(){
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
	parent.parent.changeCurrentTitle(tabParam.text,tabParam.categoryId);
	operateRecord(tabParam)
	//自动记录病例操作日志
	openDocumentLog(tabParam,"EMR.Nav.RecordNav.Open");
});


///查询卡片///////////////////////////////////////////////////////////////
function searchSelect(value)
{
	var categoryId = gl.categoryId;
	if(!(/^[\u4e00-\u9fa5]+$/i).test(value)){
		value = value.toUpperCase();
	}
	//是否支持跨科检索模板
	if ($.inArray(categoryId,searchAcrossDepartDocID)>-1)
	{
		if (value != "")
		{
			$('.display').empty();
			searchTemplate("EMRservice.BL.BLClientCategory","GetInformConsentTempCateJson",value,categoryId,episodeID,false);
			getRecord("EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",false,"List",gl.sequence);
			$(".display li .instance").parent().hide();
			var $instance = $(".display li .instance .tag").filter(":contains('"+$.trim(value)+"')");
			$instance.parent().parent().show();
		}
		else
		{
			init();
		}
	}
	else
	{
		$(".display li").hide();
		var $instance = $(".display li .instance .tag").filter(":contains('"+$.trim(value)+"')");
		$instance.parent().parent().show();
		var $template = $(".display li .template").filter(":contains('"+$.trim(value)+"')");
		$template.parent().show();
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
				$(div).append('<a href="#" title=' +emrTrans("新建") +'><div class="new" ><div class="title" style="height:70px;">' +data[i].text+ '</div></div></a>');
				$(div).append('<a href="#" title=' +emrTrans("引用") +'><div class="quote" style="height:95px;"></div></a>');	
			}
			else
			{
				$(div).append('<a href="#" title=' +emrTrans("新建") +'><div class="title" style="height:190px;">' +data[i].text+ '</div></a>');
			}
			$(div).append('<a id="search" class="groupName" href="#" class="easyui-tooltip" title='+data[i].attributes.disCurDocGropName+ '>' +data[i].attributes.disCurDocGropName+ '</a>');
		}
		else
		{
			if (data[i].attributes.quotation == "1")
			{
				$(div).append('<a href="#" title=' +emrTrans("新建") +'><div class="new" ><div class="title">' +data[i].text+ '</div></div></a>');
				$(div).append('<a href="#" title=' +emrTrans("引用") +'><div class="quote"></div></a>');	
			}
			else
			{
				$(div).append('<a href="#" title=' +emrTrans("新建") +'><div class="title" >' +data[i].text+ '</div></a>');
			}
		}
		$(div).append('<div class="janespell" style="display:none;">' +data[i].attributes.JaneSpell+ '</div>');
		$(div).append('<div class="fullfight" style="display:none;">' +data[i].attributes.FullFight+ '</div>');
		$(link).append(div);
		$('.display').append(link);	
	}
}

function getContentClass(doctorwait,patientwait)
{
	var contentclass = "class = 'content'";
	if ((doctorwait == "1")&&(patientwait == "1"))
	{
		contentclass = "class = 'content doctorwait patientwait' title="+emrTrans("需要医生和患者签名");
	}
	else if(doctorwait == "1")
	{
		contentclass = "class = 'content doctorwait' title="+emrTrans("需要医生签名");
	}
	else if(patientwait == "1")
	{
		var contentclass = "class = 'content patientwait' title="+emrTrans("需要患者签名");
	}
	return contentclass;
}

