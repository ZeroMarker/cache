var mainpage = parent.parent;
///切换目录/////////////////////////////////////////
function xhrRefresh(patientId,episodeId,categoryId)
{
	gl.patientId = patientId;
	gl.episodeId = episodeId;
	gl.categoryId = categoryId;
	init();
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
	var hasTemplate = GetHasUserTemplate(tabParam.emrDocId);
    if (hasTemplate)
    {   
	    //userTemplate = window.showModalDialog("emr.ip.navigation.template.csp?DocID="+tabParam.emrDocId+"&LocID="+gl.userLocId+"&EpisodeID="+gl.episodeId,"","dialogHeight:500px;dialogWidth:400px;status:no");
	    //showTempTitleDialog("模板选择","420","570","<iframe id='iframeTempTitle' scrolling='auto' frameborder='0' src='emr.ip.navigation.template.csp?DocID="+tabParam.emrDocId+"&LocID="+gl.userLocId+"&EpisodeID="+gl.episodeId + "' style='width:420px; height:570px; display:block;'></iframe>",tabParam)
		var iframeContent = "<iframe id='iframeTempTitle' scrolling='auto' frameborder='0' src='emr.ip.navigation.template.csp?DocID="+tabParam.emrDocId+"&LocID="+gl.userLocId+"&EpisodeID="+gl.episodeId + "' style='width:100%; height:100%; display:block;'></iframe>";	
		mainpage.$("#editor").css("display","none");
		parent.createModalDialog("temptitleDialog","模板选择","420","570","iframeTempTitle",iframeContent,SelectTempTitle,tabParam)
	}
	else
	{
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
		tabParam.userTemplateCode = returnValue.code;
	}
	operateRecord(tabParam);
		//自动记录病例操作日志
	CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create"); 
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
		t.style.left = left -17+ 'px';
		t.style.top = top-189 + "px";
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
	parent.parent.operateRecord(tabParam);
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