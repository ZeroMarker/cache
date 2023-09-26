﻿$(function(){
	loadOperations();
	getNoLinkDocument();
});

///增加手术索引
function appendOperations()
{
	var Values = window.showModalDialog("emr.record.library.navoperation.addoperation.csp?PatientID="+patientID+"&EpisodeID="+episodeID,"","dialogHeight:765px;dialogWidth:1360px;resizable:yes;center:yes;minimize:yes;maximize:yes;");
	if (Values != "")
	{
		var returnValues = eval("("+Values+")");
		if ((returnValues == "")||(returnValues == undefined)) return;
		var panels =  $("#operations").accordion("panels");
		var i = panels.length;
		var title = returnValues.OperDateTime+" | "+returnValues.OperDesc+" | "+returnValues.OperDoc+" | "+returnValues.OperAssistFirst+" | "+returnValues.OperAssistSecond;
		var content = '<div id="display'+i+'" style="width:100%;height:100%;overflow-y:scroll"><ul class="display" id ="'+returnValues.ID+'"></ul></div>';
	
		addAccordion(title,content,true,returnValues.ID);
		loadTemplate(i,returnValues.ID,categoryID);
	}
}

//加载病历
function loadRecord(categoryId)
{
	categoryID = categoryId;
	var p = $('#operations').accordion('getSelected');
	if (p){
		var index = $('#operations').accordion('getPanelIndex', p);
		var id = p[0].id;
		loadTemplate(index,id,categoryID);
	}
}

///加载手术信息
function loadOperations()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.Event.BLEvents",
			"Method":"GetData",
			"p1":"Operation",
			"p2":episodeID
		},
		success: function(d) {
			d = eval("["+d+"]");
			if (d == "") return;
			var defaultload = "";
			var count = 0;
			for (i=0;i<d.length;i++)
			{
				var OperPAStatus = "";
				if ((d[i].OperPAStatus == "拒绝")||(d[i].OperPAStatus == "撤销")){
					OperPAStatus = "<span id='pastatus"+i+"' style='padding-left:10px;color:red;'>"+d[i].OperPAStatus+"</span>";
				}else{
					OperPAStatus = "<span id='pastatus"+i+"' style='padding-left:10px;color:#000000;'>"+d[i].OperPAStatus+"</span>";
					if (count == 0)
					{
						defaultload = i ;
					}
					count = count + 1;
				}
				var title =d[i].OperDate+" "+d[i].OperTime+" | "+d[i].OperDesc+" | "+d[i].OperDocName+" | "+d[i].OperAssistFirstDesc+" | "+d[i].OperAssistSecondDesc+OperPAStatus;
				var content = '<div id="display'+i+'" style="width:100%;height:100%;overflow-y:scroll"><ul class="display" id ="'+d[i].ID+'"></ul></div>';
				addAccordion(title,content,false,d[i].ID);
			}
			if (defaultload == "")
			{
				defaultload = 0;
			}
			$("#operations").accordion('select',defaultload);
		},
		error : function(d) { alert("查数据出错");}
	});	
}

//添加手术记录选项卡
function addAccordion(title,content,select,id)
{
	$('#operations').accordion(
	'add',{
		id: id,
		title: title,
		content: content,
		selected: select
	});	
}

//选择手术项目，加载要写的模板及写过的病历
$(function(){
	$('#operations').accordion({
		onSelect:function(title,index){
			var panel = $("#operations").accordion('getPanel',index);
			var id = panel[0].id;
			if (id != undefined && id != "")
			{
				//加载模板
				loadTemplate(index,id,categoryID);
			}
		}
	}); 
});

///Desc:加载模板
function loadTemplate(index,opereventId,categoryId)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"GetTempCateJsonByCategoryID",
			"p1":categoryId,
			"p2":episodeID,
			"p3":userID,
			"p4":"",
			"p5":"Operation",
			"p6":opereventId
		},
		success: function(d) {
			$('#display'+index+' .display').empty();
			if ($('#pastatus'+index).text() != "拒绝" && $('#pastatus'+index).text() != "撤销"){
				setTemplate(index,eval("["+d+"]"),categoryId);
			}
			//加载病历
			if ((opereventId != "")&&(opereventId != undefined))
			{
				getRecord(index,opereventId,categoryId);
			}
		},
		error : function(d) { 
			alert("Template error");
		}
	});
}

//加载模板
function setTemplate(index,data,categoryId)
{
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li onClick="createDocument(this)"></li>');
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
		$('#display'+index+' .display').append(link);	
	}
}

//加载实例
function getRecord(index,opereventId,categoryId)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"GetInstanceByCategoryEvent",
			"p1":categoryId,
			"p2":episodeID,
			"p3":"Operation",
			"p4":opereventId,
			"p5":recordSequence.NavRecord
		},
		success: function(d) {
			setRecord(index,eval("["+d+"]"),categoryId);
		},
		error : function(d) { 
			alert("getRecord error");
		}
	});	
}

//加载文档
function setRecord(index,data,categoryId)
{
	for (var i=0;i<data.length;i++)
	{
		var link = $('<li onClick="openDocument(this)"></li>');
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
		$(div).append('<a href="#"> <div class="content">' +data[i].summary+ '</div></a>');
		var tag = $('<div class="tag"></div>');
		$(tag).append('<div class="title">' +data[i].text+ '</div>');
		if(data[i].summary!="")
		{
			$(tag).append('<div class="time">' +data[i].happendate+" "+data[i].happentime+" "+'<img class="instancedimg" src="../scripts/emr/image/icon/happendtime.png"/>'+" "+'<span onmouseover="tip.show(this)" onmouseout="tip.hide()">'+"详细"+'<span class="description" style="display:none">'+data[i].summary+'</span>'+'</span>'+'</div>');
		}
		else
		{
			$(tag).append('<div class="time">' +data[i].happendate+" "+data[i].happentime+" "+'<img class="instancedimg" src="../scripts/emr/image/icon/happendtime.png"/></div>');
		}
		$(tag).append('<div class="janespell" style="display:none;">' +data[i].JaneSpell+ '</div>');
		$(tag).append('<div class="fullfight" style="display:none;">' +data[i].FullFight+ '</div>');
		$('#display'+index+' .display').append($(link).append($(div).append(tag)));
	}
}
///无关联病历
function getNoLinkDocument()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"GetInstanceNoLinkEvent",
			"p1":categoryID,
			"p2":episodeID,
			"p3":"Operation"
		},
		success: function(d) {
			if (d != "")
			{
				var title ="无关联病历";
				var content = $('<div id="display" style="width:100%;height:100%;overflow-y:scroll"></div>');
				var text = $('<ul class="display"></ul>');
				var data = eval("["+d+"]");
				for (var i=0;i<data.length;i++)
				{
					var link = $('<li onClick="openDocument(this)"></li>');
					$(link).attr({"id":data[i].id,"text":data[i].text,"isLeadframe":data[i].isLeadframe});
					$(link).attr({"chartItemType":data[i].chartItemType,"documentType":data[i].documentType});		
					$(link).attr({"emrDocId":data[i].emrDocId,"isMutex":data[i].isMutex,"categoryId":categoryID});
					$(link).attr({"templateId":data[i].templateId,"characteristic":data[i].characteristic});
		
					var div = $('<div class="instance"></div>');
					if (data[i].hasSign == "0") $(div).append('<div class="pic">待签</div>');
					$(div).append('<a href="#"> <div class="content">' +data[i].summary+ '</div></a>');
					var tag = $('<div class="tag"></div>');
					$(tag).append('<div class="title">' +data[i].text+ '</div>');
					if(data[i].summary!="")
					{
						$(tag).append('<div class="time">' +data[i].happendate+" "+data[i].happentime+" "+'<img class="instancedimg" src="../scripts/emr/image/icon/happendtime.png"/>'+" "+'<span onmouseover="tip.show(this)" onmouseout="tip.hide()">'+"详细"+'<span class="description" style="display:none">'+data[i].summary+'</span>'+'</span>'+'</div>');
					}
					else
					{
						$(tag).append('<div class="time">' +data[i].happendate+" "+data[i].happentime+" "+'<img class="instancedimg" src="../scripts/emr/image/icon/happendtime.png"/></div>');
					}
					$(text).append($(link).append($(div).append(tag)));
				}
				$(content).append(text);
				addAccordion(title,content,false,0);
			}
		},
		error : function(d) { 
			alert("getRecord error");
		}
	});		
}


//从模板新建
function createDocument(obj){
	var eventId = $(obj).parent().attr("id");
	var obj = $(obj).closest("li");
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
		"closable":true,
		"args":{
			"event":{
				"EventType":"Operation",
				"EventID":eventId
			}
		}
	 };
	  
	///创建病历 	
	parent.parent.parent.operateRecord(tabParam);	
	
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
	parent.parent.parent.operateRecord(tabParam);
	
	//自动记录病例操作日志
	openDocumentLog(tabParam,"EMR.Nav.RecordNav.Open");
}

//刷新
function refresh()
{
    window.location.reload();
}

///过滤页面卡片
function selectRecord(value)
{
	if(!(/^[\u4e00-\u9fa5]+$/i).test(value)){
		 value = value.toUpperCase();
	}
	var selectOperation = $('#operations').accordion('getSelected');
	if (selectOperation)
	{
		var index = $('#operations').accordion('getPanelIndex',selectOperation);
		$('#display'+index+' .display li').hide();
		var $instance = $('#display'+index+' .display li .instance .tag').filter(":contains('"+$.trim(value)+"')");
		$instance.parent().parent().show();
		var $template = $('#display'+index+' .display li .template').filter(":contains('"+$.trim(value)+"')");
		$template.parent().show();	
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