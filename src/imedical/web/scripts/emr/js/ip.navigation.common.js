var mainpage = parent.parent;
///切换目录/////////////////////////////////////////
function xhrRefresh(patientId,episodeId,categoryId)
{
	gl.patientId = patientId;
	gl.episodeId = episodeId;
	gl.categoryId = categoryId;
	init();
}
function filterOftenIdx(patientId,episodeId,categoryId){
	gl.patientId = patientId;
	gl.episodeId = episodeId;
	gl.categoryId = categoryId;
	filterOften();
	}
///改变目录
function changeCategoryId(acategoryId)
{
	gl.categoryId = acategoryId;
}

//获取哪个病历展现结构目录需要跨科检索
function getSearchAcrossDepartDocID()
{
	var searchDocID = new Array();
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSysOption",
			"Method":"GetOptionValueByName",
			"p1":"SearchAcrossDepartment"
		},
		success: function(d) {
			if (d != "") 
			{
				var strXml = convertToXml(d);
			    $(strXml).find("item").each(function(){
				    var code = $(this).find("code").text();
				    searchDocID.push(code);
			    });		
			}
		},
		error : function(d) { 
			alert("SearchAcrossDepartment error");
		}
	});
	
    return searchDocID;
}

///取用户模板信息
function getParamByUserTemplate(tabParam)
{
	//获取多文档加载未创建时默认加载的titleCode
	var defaultLoadId = getDefaultLoadId(tabParam.emrDocId,gl.userLocId,tabParam.templateId);
	//移除入院记录的自动创建（导致不显示模板选择框）
	defaultLoadId = defaultLoadId == "EMR090001"?"":defaultLoadId;
	var hasTemplate = GetHasUserTemplate(tabParam.emrDocId);
	if (defaultLoadId == "")
	{
		if (hasTemplate)
    {   
	    //userTemplate = window.showModalDialog("emr.ip.navigation.template.csp?DocID="+tabParam.emrDocId+"&LocID="+gl.userLocId+"&EpisodeID="+gl.episodeId,"","dialogHeight:500px;dialogWidth:400px;status:no");
	    //showTempTitleDialog("模板选择","420","570","<iframe id='iframeTempTitle' scrolling='auto' frameborder='0' src='emr.ip.navigation.template.csp?DocID="+tabParam.emrDocId+"&LocID="+gl.userLocId+"&EpisodeID="+gl.episodeId + "' style='width:420px; height:570px; display:block;'></iframe>",tabParam)
		var iframeContent = "<iframe id='iframeTempTitle' scrolling='auto' frameborder='0' src='emr.ip.navigation.template.csp?DocID="+tabParam.emrDocId+"&LocID="+gl.userLocId+"&EpisodeID="+gl.episodeId + "' style='width:100%; height:100%; display:block;'></iframe>";	
		mainpage.$("#editor").css("display","none");
		parent.createModalDialog("temptitleDialog","模板选择","525","660","iframeTempTitle",iframeContent,SelectTempTitle,tabParam)
	}
	else if(GetPersonalUserTemplate(tabParam.emrDocId))
	{
		var iframeContent = "<iframe id='iframeTempTitle' scrolling='auto' frameborder='0' src='emr.ip.navigation.template.csp?DocID="+tabParam.emrDocId+"&LocID="+gl.userLocId+"&EpisodeID="+gl.episodeId + "&openWay=personal' style='width:100%; height:100%; display:block;'></iframe>";	
		mainpage.$("#editor").css("display","none");
			parent.createModalDialog("temptitleDialog","模板选择","525","660","iframeTempTitle",iframeContent,SelectTempTitle,tabParam)
	}
	else
	{
			operateRecord(tabParam);
		}
	}
	else
	{
		var personalTemplateInfo = GetFirstPersonalTemplateInfo(tabParam.emrDocId,defaultLoadId);
		if ((personalTemplateInfo != "")&&(personalTemplateInfo.exampleId != ""))
		{
			tabParam.actionType = "CREATEBYPERSONAL";
			tabParam.exampleId = personalTemplateInfo.exampleId;
			tabParam.titleCode = defaultLoadId;
			tabParam.titleName = personalTemplateInfo.titleName;
			tabParam.dateTime = personalTemplateInfo.dateTime;
			tabParam.titlePrefix = "";
			tabParam.doctorID = "";
		}
		else
		{
			var userTemplateInfo = GetFirstUserTemplateInfo(tabParam.emrDocId,defaultLoadId);
			if ((userTemplateInfo != "")&&(userTemplateInfo.code != ""))
			{
				tabParam.titleCode = defaultLoadId;
				tabParam.actionType = "CREATEBYTITLE";
				tabParam.titleName = userTemplateInfo.titleName;
				tabParam.dateTime = userTemplateInfo.dateTime;
				tabParam.titlePrefix = "";
				tabParam.doctorID = "";
				tabParam.userTemplateCode = userTemplateInfo.code;
			}
		}
		
		//自动记录病例操作日志
		CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");
        operateRecord(tabParam);
	}
	return "";
}
function SelectTempTitle(returnValue,tabParam){
	if (returnValue !== undefined)
	{
    	if (returnValue.titleCode != "") 
		{
			tabParam.titleCode = returnValue.titleCode;
			tabParam.actionType = "CREATEBYTITLE";
			tabParam.titleName = returnValue.titleName;
			tabParam.dateTime = returnValue.dateTime;
			tabParam.titlePrefix = returnValue.titlePrefix;
			tabParam.doctorID = returnValue.doctorID;
		}
		
		if ((returnValue.eventID != undefined)&&(returnValue.eventType != undefined)&&(returnValue.eventID != "")&&(returnValue.eventType != ""))
		{
			
			var argJson = {"event":{"EventID":returnValue.eventID,"EventType":returnValue.eventType}};
			tabParam.args = argJson;
		}
		if ((tabParam.exampleId != undefined)&&(tabParam.exampleId != "")) 
		{
			tabParam.actionType = "CREATEBYPERSONAL";
			//tabParam.exampleId = returnValue.exampleId;
		}
		else if((returnValue.exampleId != undefined)&&(returnValue.exampleId != ""))
		{
			tabParam.actionType = "CREATEBYPERSONAL";
			tabParam.exampleId = returnValue.exampleId;
		}
		if (!tabParam.userTemplateCode){
			tabParam.userTemplateCode = returnValue.code;
		}
	}
	//自动记录病例操作日志
	CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create"); 
    operateRecord(tabParam); 
}


//是否有用户模板
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
			"p1":gl.userLocId,
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

//是否有个人模板
function GetPersonalUserTemplate(docId)
{
	var result = false;
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.PersonalTemplate",
			"Method":"HasPersonalTemplate",
			"p1":gl.userId,
			"p2":docId
		},
		success: function(d) {
			if (d == "1") result = true;
		},
		error : function(d) { 
			alert("GetPersonalUserTemplate error");
		}
	});
	return result;
}

//获取默认加载的科室模板信息
function GetFirstUserTemplateInfo(docId,titleCode)
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLUserTemplate",
			"Method":"GetFirstUserTemplateInfoByTitle",
			"p1":titleCode,
			"p2":gl.userLocId,
			"p3":docId,
			"p4":gl.episodeId
		},
		success: function(d) {
			if (d != "") result = eval("["+d+"]")[0];
		},
		error : function(d) { 
			alert("GetFirstUserTemplateInfo error");
		}
	});
	return result;
}

//获取默认加载的个人模板信息
function GetFirstPersonalTemplateInfo(docId,titleCode)
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.PersonalTemplate",
			"Method":"GetFirstPersonalByTitle",
			"p1":titleCode,
			"p2":gl.userId,
			"p3":docId
		},
		success: function(d) {
			if (d != "") result = eval("["+d+"]")[0];
		},
		error : function(d) { 
			alert("GetFirstPersonalTemplateInfo error");
		}
	});
	return result;
}

///引用病历
function getQuation(docId)
{
	var iWidth=window.screen.width-100;
	var iHeight=window.screen.height-100;
	var iTop = (window.screen.availHeight - 20 - iHeight) / 2;  
    var iLeft = (window.screen.availWidth - 10 - iWidth) / 2; 
	var returnValue = window.showModalDialog("emr.ip.quotation.csp?EpisodeID="+episodeID+"&PatientID="+patientID+"&DocID="+docId,"","dialogHeight:"+iHeight+"px;dialogWidth:"+iWidth+"px;dialogTop:"+iTop+"px;dialogLeft:"+iLeft+"px;status:no;");
	return returnValue;
}

///其他///////////////////////////////////////////////////////////////////
///鼠标动作
var objA = null,intrval = null;
var tip =
{
	show:function(obj)
	{
		if(!obj)obj = objA; else objA = obj;
   		var objs = $(obj).parent().find('.content');
   		var str = objs[0].innerText ;
   		if (str == "") return;
 
   		var t = document.getElementById("messagetip"); 
   		var left = obj.getBoundingClientRect().left;
   		var top = obj.getBoundingClientRect().top;
		t.style.left = left+14 + 'px';
		t.style.top = top-122 + "px";
		$(t).find('div')[0].innerHTML = str;
		t.style.display = "block";
  	},
	hide:function()
	{	
		document.getElementById("messagetip").style.display="none";
   	}
}

///打开病历
function operateRecord(tabParam)
{
    if (gl.type && (gl.type=="Template")){
        parent.operateRecord(tabParam);
    }else{
        parent.parent.operateRecord(tabParam);
    }
}

//检查当前categoryId是否对应当前科室病历文书下的目录
function checkCategoryIdInLocId(episodeId,locId,categoryId,groupId)
{
	var result="";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"CheckCategoryIdInLocId",
			"p1":episodeId,
			"p2":locId,
			"p3":categoryId,
			"p4":groupId
		},
		success: function(d) {
			result = d;
		},
		error : function(d) { 
			alert("error");
		}
	});
	return result;
}

//获取多文档加载未创建时默认加载的titleCode
function getDefaultLoadId(templateCategoryId,locID,templateID)
{
	var defaultLoadId = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLTitleConfig",
					"Method":"GetDefaultLoadTitleCode",			
					"p1":templateCategoryId,
					"p2":locID,
					"p3":gl.episodeId,
					"p4":templateID
				},
			success : function(d) {
	           		defaultLoadId = d;
			},
			error : function(d) { alert("GetDefaultLoadTitleCode error");}
		});	
	return defaultLoadId;
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

var objtemp = null;
var temp =
{
	show:function(obj)
	{
		if(!obj)obj = objtemp; else objtemp = obj;
		var objs = $(obj).find('.cardImage');
		objs[0].style.background = "url(../scripts/emr/image/record-card-png/png/23.png) no-repeat"
  	},
	hide:function(obj)
	{	
		if(!obj)obj = objtemp; else objtemp = obj;
		var objs = $(obj).find('.cardImage');
		objs[0].style.background = "url(../scripts/emr/image/record-card-png/png/10.png) no-repeat"	
   	}
}

var objrecord = null;
var record =
{
	show:function(obj)
	{
		if(!obj)obj = objrecord; else objrecord = obj;
		var objs = $(obj).find('.recordimage');
		objs[0].style.background = "url(../scripts/emr/image/record-card-png/png/23.png) no-repeat"
		var objA = $(obj).find('.tag');
		objA[0].style.backgroundColor = "rgba(51, 158, 255, 1)";
		objA[0].style.width = "128px";
		objA[0].style.height = "46px";
		objA[0].style.color = "rgba(246, 249, 255, 1)"
		objA[0].style.margin="-45px 0px 0px 0px";
		var objB = $(obj).find('.tag .time');
		objB[0].style.color = "rgba(246, 249, 255, 1)"
		var objC = $(obj).find('.tag .addMemo');
		if(objC.length>0)
		{
			objC[0].style.color = "rgba(246, 249, 255, 1)";
		}
  	},
	hide:function(obj)
	{	
		if(!obj)obj = objrecord; else objrecord = obj;
		var objs = $(obj).find('.recordimage');
		objs[0].style.background = "url(../scripts/emr/image/record-card-png/png/10.png) no-repeat"	
		var objA = $(obj).find('.tag');
		objA[0].style.backgroundColor = "rgba(246, 246, 246, 1)"
		objA[0].style.width = "128px";
		objA[0].style.height = "46px";
		objA[0].style.color = "rgba(60, 60, 60, 1)"
		objA[0].style.margin="-45px 0px 0px 0px";
		var objB = $(obj).find('.tag .time');
		objB[0].style.color = "rgba(153, 153, 153, 1)"
		var objC = $(obj).find('.tag .addMemo');
		if(objC.length>0)
		{
			objC[0].style.color = "rgba(153, 153, 153, 1)";
		}	
   	}
}
