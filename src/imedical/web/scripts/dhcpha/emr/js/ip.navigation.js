$(function(){
	//模板跨科检索
	searchAcrossDepartDocID = getSearchAcrossDepartDocID();
	initconfig();
	init();
});

function initconfig()
{
	var config = getUserConfigData(userID,locID,"DISPLAYTYPE");
	if (config != "")
	{
		displayConfig = config;
	}
	selectDisplayType();
	if (displaySeq == "DESC")
	{
		$("#displayseq").text("倒序");
	}
	else
	{
		$("#displayseq").text("正序");
	}
}

///卡片或者列表视图选中
function selectDisplayType()
{
	if(displayConfig == "LIST")
	{
		$("#cordDisplay").removeClass("selectFlag");
		$("#listDisplay").addClass("selectFlag"); 
	}
	else
	{
		$("#listDisplay").removeClass("selectFlag");
		$("#cordDisplay").addClass("selectFlag"); 
	}	
}

function changeDisplaySeq()
{
	if (displaySeq == "DESC")
	{
		displaySeq = "";
		$("#displayseq").text("正序");
	}
	else
	{
		displaySeq = "DESC";
		$("#displayseq").text("倒序");
	}
	init();
}

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

///加载卡片///////////////////////////////////////////////////////////////////////////////////////////////////////////
function xhrRefresh(patientId,episodeId,categoryId)
{
	patientID = patientId;
	episodeID = episodeId;
	categoryID = categoryId;
	init();
}
//加载
function init()
{
	if(displayConfig == "LIST")
	{
		loadListRecrod(); 
	}
	else
	{
		loadTemplateRecrod();
	}	
}
//卡片视图显示
function loadTemplateRecrod()
{
	$('.display').empty();
	$("#listdisplay").hide();
	$("#corddisplay").show();
   	getTemplate("EMRservice.BL.BLClientCategory","GetTempCateJsonByCategoryID",false);
    getRecord("EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",false,"List",displaySeq);
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
			"p1":categoryID,
			"p2":episodeID,
			"p3":userID
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
		$(link).attr({"isMutex":data[i].attributes.isMutex,"categoryId":categoryID});
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
			"p1":categoryID,
			"p2":episodeID,
			"p3":resultType,
			"p4":sequence
		},
		success: function(d) {
			setRecord(eval("["+d+"]"));
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
		$(link).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":categoryID});
		$(link).attr({"templateId":data[i].templateId,"characteristic":data[i].characteristic});
		
		var div = $('<div class="instance"></div>');
		if (data[i].hasSign == "0")
		{
			$(div).append('<a href="#"><div class="content pic">' +data[i].summary+ '</div></a>');
		}
		else
		{
			$(div).append('<a href="#"><div class="content">' +data[i].summary+ '</div></a>');
		}
		var tag = $('<div class="tag"></div>');
		$(tag).append('<div title="'+data[i].text+ '" class="title">' +data[i].text+ '</div>');
		if(data[i].summary!=""){
			$(tag).append('<div class="time">' +data[i].happendate+" "+data[i].happentime+" "+" "+'<span onmouseover="tip.show(this)" onmouseout="tip.hide()">'+"详细"+'<span class="description" style="display:none">'+data[i].summary+'</span>'+'</span>'+'</div>');
		}else
		{
			$(tag).append('<div class="time">' +data[i].happendate+" "+data[i].happentime+" "+'</div>');
		}
		$(tag).append('<div class="janespell" style="display:none;">' +data[i].JaneSpell+ '</div>');
		$(tag).append('<div class="fullfight" style="display:none;">' +data[i].FullFight+ '</div>');
		$('.display').append($(link).append($(div).append(tag)));
	}
}
///编辑备注///////////////////////////////////////////////////////////////////////////////////////////////////////////
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

$(document).on("click",".instance .tag .instancedimg",function(){
	var obj = $(this).closest("li");
	instanceId = obj.attr("id");
	var memo = $(this).next().children().html();
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
	parent.operateRecord(tabParam);
	//自动记录病例操作日志
	CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");

});

///取用户模板信息
function getParamByUserTemplate(tabParam)
{
	var hasTemplate = GetHasUserTemplate(tabParam.emrDocId);
    if (hasTemplate)
    {
	    userTemplate = window.showModalDialog("emr.ip.navigation.template.csp?DocID="+tabParam.emrDocId+"&LocID="+locID+"&EpisodeID="+episodeID,"","dialogHeight:600px;dialogWidth:500px;status:no");
		if (userTemplate == undefined) return "";
		if (userTemplate.titleCode != "") 
		{
			tabParam.titleCode = userTemplate.titleCode;
			tabParam.actionType = "CREATEBYTITLE";
			tabParam.titleName = userTemplate.titleName;
			tabParam.dateTime = userTemplate.dateTime;
		}
		tabParam.userTemplateCode = userTemplate.code;
	}
	return tabParam;
}

//从既往病历新建
$(document).on("click",".template .quote",function(){
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
	 parent.operateRecord(tabParam);
	//自动记录病例操作日志
	CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.CreateInOld");

});
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
	parent.operateRecord(tabParam)
	//parent.parent.parent.operateRecord(tabParam);
	//自动记录病例操作日志
	openDocumentLog(tabParam,"EMR.Nav.RecordNav.Open");
});

function GetHasUserTemplate(docId)
{
	var result = false;
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLUserTemplate",
			"Method":"HasUserTemplate",
			"p1":locID,
			"p2":docId
		},
		success: function(d) {
			if (d == "1") result = true;
		},
		error : function(d) { 
			alert("GetHasUserTemplate error");
		}
	});
	return result;
}

///查询卡片///////////////////////////////////////////////////////////////
//

var search = {
	my_click:function(obj, myid)
	{
		if (document.getElementById(myid).value == document.getElementById(myid).defaultValue)
		{
			document.getElementById(myid).value = '';
			obj.style.color='#000';
		}
	},
	my_blur:function (obj, myid)
	{
		if (document.getElementById(myid).value == '')
		{
			document.getElementById(myid).value = document.getElementById(myid).defaultValue;
			obj.style.color='#999'
		}
	},
	my_keyDown:function (myid)
	{
		if(event.keyCode==13)
		{
			var selectValue = document.getElementById(myid).value;
			var defaultValue = document.getElementById(myid).defaultValue;
			if (selectValue == defaultValue) selectValue = "";
			searchSelect(selectValue);
		}
	}
};

$("#searchRecord").click(function()
{
	var selectValue = $("#searchInput").val();
	var defaultValue = $("#searchInput")[0].defaultValue;
	if (selectValue == defaultValue) selectValue = "";
	searchSelect(selectValue);
});

function searchSelect(value)
{
	var categoryId = categoryID;
	if(!(/^[\u4e00-\u9fa5]+$/i).test(value)){
		value = value.toUpperCase();
	}
	if(displayConfig == "LIST")
	{
		if ($.inArray(categoryId,searchAcrossDepartDocID)>-1)
		{
			$('.display').empty();
			searchListTemplate("EMRservice.BL.BLClientCategory","GetInformConsentTempCateJson",value,categoryId,episodeID,false,"List");
			getListRecord("EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",categoryId,episodeID,false,"List",displaySeq);
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
	}
	else
	{
		//是否支持跨科检索模板
		if ($.inArray(categoryId,searchAcrossDepartDocID)>-1)
		{
			if (value != "")
			{
				$('.display').empty();
				searchTemplate("EMRservice.BL.BLClientCategory","GetInformConsentTempCateJson",value,categoryId,episodeID,false);
				getRecord("EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",categoryId,episodeID,false,"List",displaySeq)	
				$("#corddisplay .display li .instance").parent().hide();
				var $instance = $("#corddisplay .display li .instance .tag").filter(":contains('"+$.trim(value)+"')");
				$instance.parent().parent().show();
			}
			else
			{
				$('.display').empty();
				getTemplate("EMRservice.BL.BLClientCategory","GetTempCateJsonByCategoryID",categoryId,episodeID,false);
				getRecord("EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",categoryId,episodeID,false,"List",displaySeq)	
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
		$('.display').append(link);	
	}
}

///其他///////////////////////////////////////////////////////////////////
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
   			t.style.top = mouse.y - 220 + 'px';
   			var str = obj.innerText;
   			str = str.substr(2);
   			t.innerHTML = str;
  	 		t.style.overflow = "auto";
   			t.style.backgroundColor = '#EFF8FE';
   			t.style.display = "block";
			t.style.fontFamily= "Microsoft Yahei";
  		}
  	},
	hide:function()
	{	
		intrval = window.setTimeout(function(){document.getElementById("messagetip").style.display="none";},80);
   	}
}

function changeCategoryId(acategoryId)
{
	categoryID = acategoryId;
}

window.onunload = function(){  
	saveDisplayUserConfig(); 
}