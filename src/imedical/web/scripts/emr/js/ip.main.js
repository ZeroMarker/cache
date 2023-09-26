var navPage = document.getElementById("frameNav").contentWindow; //window.frames["frameNav"];
var editPage = document.getElementById("framRecord").contentWindow; //window.frames["framRecord"];

$(function(){
	initNavPage();
	initEditor();
});

///切换目录/////////////////////////////////////////////////
function xhrRefresh(tempParam)
{
	if (setting.categoryId != tempParam.CategoryID || setting.episodeId != tempParam.adm)
	{
		if (editPage)
		{
			var editFlag = editPage.savePrompt("");
			if (editFlag == "cancel") 
			{
				return; 
			}
			else if (editFlag == "unsave")
			{
				editPage.resetModifyState("","false");
			} 
			var breakState = editPage.canBreake();
			if (breakState == "false") return;
		}
		//$("#nav").css("display","block");
		$("#editor").css("display","block");
		setting.patientId = tempParam.papmi;
		setting.episodeId = tempParam.adm;
		setting.categoryId = tempParam.CategoryID;
		navPage.xhrRefresh(tempParam.papmi,tempParam.adm,tempParam.CategoryID);
		initEditor();
		$("#nav").css("display","block");
		//$("#editor").css("display","none");
	}
}

function initNavPage()
{
	$("#frameNav").attr("src","emr.ip.navigation.csp?EpisodeID="+setting.episodeId +"&CategoryID="+setting.categoryId);	
}

///编辑器///////////////////////////////////////////////////
function initEditor()
{
	var url = "";
	var rtn = getNavParam();
	if (rtn != "") url = rtn.ItemURL;
	if (url == "emr.ip.navigation.templategroup.csp") 
	{
		$("#framRecord").attr("src","emr.ip.group.edit.csp?EpisodeID="+setting.episodeId);
	}
	else
	{
		$("#framRecord").attr("src","emr.ip.edit.csp?EpisodeID="+setting.episodeId +"&CTlocID="+setting.userLocId +"&UserID="+setting.userId);
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
			alert("GetNavParam error");
		}
	});
	return result;
}

///打开病历
function operateRecord(param)
{
	$("#nav").css("display","none");
	$("#editor").css("display","block");
	if (editPage)
	editPage.InitDocument(param);
}


///批量创建
function openGroupRecord(tabParam)
{
	$("#nav").css("display","none");
	$("#editor").css("display","block");
	if (!editPage) return;
	if (tabParam[0].actionType != "LOAD")
	{
		editPage.g_groupTempParam = tabParam.slice();
	}
	editPage.operateDocument(tabParam[0]);
}

function gotoNav()
{
	//返回导航前先判断是否修改
	if (editPage && editPage.length >0)
	{
		if (editPage.param != "") {
			var result = editPage.savePrompt("");
			if (result == "cancel") {
				return;
			}
			else if(result == "unsave")
			{
				editPage.resetModifyState(editPage.param.id,"false");
			}
		}
		var breakState = editPage.canBreake();
		if (breakState == "false") return;
	}
	$("#nav").css("display","block");
	$("#editor").css("display","none");
	navPage.setButtonStatus();
	editPage.unLockDocumnet();
	editPage.clearDocument();
	if (setting.categoryId != navPage.gl.categoryId)
	{
		navPage.xhrRefresh(setting.patientId,setting.episodeId,setting.categoryId);
	}
	else
	{
		navPage.init();
		var searchKey = navPage.$('#searchRecord').searchbox('getValue');
		if (searchKey != "")
		{
			navPage.search(searchKey); 
		}
	}
}


function gotoEdit()
{
	$("#nav").css("display","none");
	$("#editor").css("display","block");
	editPage.toolbar.setOtherButtonPrivilege();
}

///关闭时有修改提示是否保存
window.onbeforeunload = function()
{
    if ((editPage)&&(editPage.savePrompt("") == "cancel"))
	{
		return '';
	}

	editPage.unLockDocumnet();
	window.onbeforeunload=null;
}

///关闭时设置用户习惯
window.onunload = function()
{
	//设置卡片视图或者列表视图
	var type = navPage.getNavType();
	if ((type != undefined)&&(type != ""))
	{
		addUserConfigData(setting.userId,setting.userLocId,"DISPLAYTYPE",type);
	}
	//设置卡片视图或者列表视图的排序[DESC 降序显示,ASC 升序显示]
	var sequence = navPage.getNavSequence();
	if ((sequence != undefined)&&(sequence != ""))
	{
		addUserConfigData(setting.userId,setting.userLocId,"NAVRECORDSEQ",sequence);
	}
	var recordTypeValue = editPage.GetRecordTypeValue();
	if ((recordTypeValue != undefined)&&(recordTypeValue != ""))
	{
		//病历导航显示样式[List 列表显示,Tree 树分类显示]
		addUserConfigData(setting.userId,setting.userLocId,"RecordType",recordTypeValue);
	}
    //记录资源区宽度
	var resouceWidth = editPage.getResourceWidth();
	if ((resouceWidth != undefined)&&(resouceWidth != ""))
	{
		addUserConfigData(setting.userId,setting.userLocId,"RESOURCEWIDTH",resouceWidth);
	}
		editPage.unLockDocumnet();
}

///修改标题名称
function changeCurrentTitle(title,categoryId)
{
	parent.setCurrentTitle(title);
	setting.categoryId = categoryId;
}
//关闭病历页签(若阻止关闭，则return false)
function onBeforeCloseTab()
{
	if ((editPage)&&(editPage.savePrompt("") == "cancel"))
	{
		return false;
	}
	return true;
}

function showDiaglog(title,width,height,content)
{
	$HUI.dialog('#dialog',{  
	    title: title,  
	    width: width,  
	    height: height,
	    content: content,  
	    closed: true,  
	    cache: false, 
	    isTopZindex:true, 
	    modal: true
	});
	$HUI.dialog('#dialog').open();	
}

function setPrintInfo(flag)
{
	if (flag == "true")
	{
		$.messager.progress({
			title: "提示",
			msg: '正在打印病历',
			text: '打印中....'
		});
	}
	else
	{
		$.messager.progress("close");
	}
}

//平台使用 如果返回false,不切换Chart页签
function chartOnBlur(){
    if (editPage && editPage.length >0)
    {
        var editFlag = editPage.savePrompt("");
        if (editFlag == "cancel") 
        {
            return false;
        }else if (editFlag == "unsave") 
        {
            editPage.resetModifyState("","false");
        }
        return true;
    }
    else
    {
        return false;
    }
}

function setSysMenuDoingSth(sthmsg) {
    if ('undefined' != typeof dhcsys_getmenuform) {
        if ('undefined' != typeof dhcsys_getmenuform()) {
            var DoingSth = dhcsys_getmenuform().DoingSth || '';
            if ('' != DoingSth)
                DoingSth.value = sthmsg || '';
        }
    }
}

//初始化mian页面时，当编辑页面（edit）的iframe加载完成之后，设置隐藏属性；
$(document).ready(function(e){ 
	var iframe = document.getElementById("framRecord");
	if (iframe.attachEvent){
	    iframe.attachEvent("onload", function(){
	        $("#editor").css("display","none");
	    });
	} else {
	    iframe.onload = function(){
	        $("#editor").css("display","none");
	    };
	}
})

