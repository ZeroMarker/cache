$(function(){
	initToolbar();
	initNavPage();
	initEditor();
	initResource();
});
//切换目录
function xhrRefresh(tempParam)
{
	if (setting.categoryId != tempParam.CategoryID)
	{
		$("#nav").css("display","block");
		$("#editor").css("display","none");
		setting.patientId = tempParam.papmi;
		setting.episodeId = tempParam.adm;
		setting.categoryId = tempParam.CategoryID;
		var param = getNavParam();
		if (param.ItemURL == navSrc)
		{
			if (window.frames["framnav"]) window.frames["framnav"].xhrRefresh(setting.patientId,setting.episodeId,setting.categoryId );
		}
		else
		{
			navSrc = param.ItemURL;
			setNavPage(param.Sequence.NavRecord,param.DisplayType);
		}
		if (window.frames["framToolbar"]) window.frames["framToolbar"].initToolbarStatus();
	}
}

function getNavParam()
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLClientCategory",
			"Method":"GetNavParam",
			"p1":setting.categoryId,
			"p2":setting.userId,
			"p3":setting.userLocId
		},
		success: function(d) {
			result = d;
		},
		error : function(d) { 
			alert("initNavPage error");
		}
	});
	return result;	
}

function initToolbar()
{
	var toolbar = '<iframe id="framToolbar" src="emr.ip.toolbar.csp?EpisodeID='+setting.episodeId+'&UserLocID='+setting.userLocId+'&SSGroupID='+setting.ssgroupId+'&UserID='+setting.userId+'" style="width:100%; height:100%;margin:0;padding:0;"></iframe>';
	$("#toolbar").append(toolbar);
}
var navSrc = "";
//加载导航页签
function setNavPage(sequence,type)
{
	var src = navSrc;
	if (navSrc == "emr.ip.navigation.operation.csp") 
	{
		$("#displayType").css("display","none");
	}
	else
	{
		$("#displayType").css("display","block");
	}
	if (navSrc == "")
	{
		src = (type == "LIST")?"emr.ip.navigation.list.csp":"emr.ip.navigation.csp"
	}
	$("#framnav").attr("src",src +'?EpisodeID='+setting.episodeId+'&CategoryID='+setting.categoryId+'&UserID='+setting.userId+'&LocID='+setting.userLocId+'&Sequence='+sequence);
}

//加载导航页签
function initNavPage()
{
	var nav = '<iframe id = "framnav" frameborder="0" src="emr.ip.navigation.csp?EpisodeID='+setting.episodeId+'&CategoryID='+setting.categoryId+'&UserID='+setting.userId+'&LocID='+setting.userLocId+'" style=" width:100%; height:100%;scrolling:no;"></iframe>';
	$("#nav").append(nav);

}
function initEditor()
{
	var editor = '<iframe id = "framRecord" scrolling="no" frameborder="0" src="emr.ip.edit.csp" style="width:100%;height:100%;scrolling:no;"></iframe>';
	$("#editor").append(editor);
}

function initResource()
{
	if (window.frames["framResource"]) $("#framResource").attr("src",'emr.ip.resource.csp?EpisodeID='+setting.episodeId+"&UserID="+setting.userId+'&SSGroupID='+setting.ssgroupId+'&UserLocID='+setting.userLocId);
}

function operateRecord(param)
{
	$("#nav").css("display","none");
	$("#editor").css("display","block");
	if (window.frames["framRecord"])
	window.frames["framRecord"].InitDocument(param);
}

function resourceResize(width)
{
	$('#main').layout('panel', 'east').panel('resize',{width:width});
	$('#main').layout('resize');
}

function foldtoolbar(height)
{
	$("#main").layout('panel','north').panel('resize',{height:height}); //设置north panel 新高度
	$('#main').layout('resize');
}

//关闭病历页签(若阻止关闭，则return false)
function onBeforeCloseTab()
{
	if (window.frames["framRecord"].savePrompt() == "cancel")
	{
		return false;
	}
	return true;
}

function changeCurrentTitle(title,acategoryId)
{
	parent.setCurrentTitle(title);
	categoryId = acategoryId;
	window.frames["framnav"].changeCategoryId(acategoryId);
}

///关闭时设置用户习惯
window.onunload = function()
{
	var recordTypeValue = window.frames["framRecord"].GetRecordTypeValue();
	if ((recordTypeValue != undefined)&&(recordTypeValue != ""))
	{
		//病历导航显示样式[List 列表显示,Tree 树分类显示]
		addUserConfigData(setting.userId,setting.userLocId,"RecordType",recordTypeValue);
	}
}