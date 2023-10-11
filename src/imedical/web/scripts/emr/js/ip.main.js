var navPage = document.getElementById("frameNav").contentWindow; //window.frames["frameNav"];
var editPage = document.getElementById("framRecord").contentWindow; //window.frames["framRecord"];

$(function(){
    initNavPage();
    initEditor();
});

///切换目录/////////////////////////////////////////////////
function xhrRefresh(tempParam)
{
    var flag = false;
    if (typeof tempParam.TabParam != "undefined"){
        tempParam.TabParam = JSON.parse(unescape(utf8to16(base64decode(tempParam.TabParam))));
        if (tempParam.actionType == "LOAD"){
            if (setting.tabParam.id != tempParam.TabParam.id){
                flag = true;
            }
        }else{
            flag = true;
        }
    }
    
    if (setting.categoryId != tempParam.CategoryID || setting.episodeId != tempParam.adm || flag)
	{
		if (editPage)
		{
			if (typeof editPage.savePrompt !== "function") return;
			var editFlag = editPage.savePrompt("");
			if (editFlag == "cancel") 
			{
				return; 
			}
			else if (editFlag == "unsave")
			{
				resetModifyState();
			} 
			var breakState = editPage.canBreake();
			if (breakState == "false") return;
			editPage.unLockDocumnet();
		}
		//$("#nav").css("display","block");
		$("#editor").css("display","block");
		setting.patientId = tempParam.papmi;
		setting.episodeId = tempParam.adm;
		setting.categoryId = tempParam.CategoryID;
		setting.tabParam = tempParam.TabParam || "";
		if (setting.tabParam != "")
		{
			$("#nav").css("display","none");
			if (editPage.switchRecord)
			{
				editPage.switchRecord();
			}else{
				initEditor();
			}
			navPage.xhrRefresh(tempParam.papmi,tempParam.adm,tempParam.CategoryID);
		}else{
			$("#nav").css("display","block");
			navPage.xhrRefresh(tempParam.papmi,tempParam.adm,tempParam.CategoryID);
			initEditor();
		}
		//$("#editor").css("display","none");
	}
}

function resetModifyState()
{
	var flag = false;
	var modifyStatus = editPage.getModifyStatus();
	if ((typeof(modifyStatus.Modified) != "undefined")&&(modifyStatus.Modified == "True"))
	{
		if ((typeof(modifyStatus.InstanceID) != "undefined")&&(modifyStatus.InstanceID.length>0))
		{
			for (i=0;i<modifyStatus.InstanceID.length;i++ )
			{
				editPage.resetModifyState(modifyStatus.InstanceID[i],"false");
				flag = true;
			}
		}
	}	
	
	if (!flag)
		editPage.resetModifyState("","false");
}

function initNavPage()
{
	$("#frameNav").attr("src","emr.ip.navigation.csp?EpisodeID="+setting.episodeId +"&CategoryID="+setting.categoryId +"&MWToken="+getMWToken());	
}

///编辑器///////////////////////////////////////////////////
function initEditor()
{
	var url = "";
	var rtn = getNavParam();
	if (rtn != "") url = rtn.ItemURL;
	if (url == "emr.ip.navigation.templategroup.csp") 
	{
		$("#framRecord").attr("src","emr.ip.group.edit.csp?EpisodeID="+setting.episodeId+"&MWToken="+getMWToken());
	}
	else
	{
		$("#framRecord").attr("src","emr.ip.edit.csp?EpisodeID="+setting.episodeId +"&CTlocID="+setting.userLocId +"&UserID="+setting.userId+"&MWToken="+getMWToken());
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
	{
		editPage.InitDocument(param);
	}
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
			var result = editPage.IsSavePrompt("");
			if (result != "") {
				return;
			}
		}
		var breakState = editPage.canBreake();
		if (breakState == "false") return;
	}
    showNav();
}
function showNav(){
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
		navPage.initToolbar();
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
	editPage.setOtherButtonPrivilege();
}

///关闭时有修改提示是否保存
/*
window.onbeforeunload = function()
{
    if ((editPage)&&(editPage.savePrompt("") == "cancel"))
	{
		return '';
	}

	editPage.unLockDocumnet();
	window.onbeforeunload=null;
}
*/

///关闭时设置用户习惯
window.onunload = function()
{
	//优先完成解锁操作
	editPage.unLockDocumnet();
	
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
    //记录资源区宽度
	var resouceWidth = editPage.getResourceWidth();
	if ((resouceWidth != undefined)&&(resouceWidth != ""))
	{
		addUserConfigData(setting.userId,setting.userLocId,"RESOURCEWIDTH",resouceWidth);
	}
}

///修改标题名称
function changeCurrentTitle(title,categoryId)
{
	parent.setCurrentTitle(title);
    //修改病历Tab签的valueExp值，否则会出现如下问题
    //住院病历病历导航目录，打开病历时若切换到非同一Categoryid下的病历，点击HIS诊断界面再切换回病历界面时会跳到第一次打开病历所对应的导航界面。
    setCurrentValue(categoryId);
	setting.categoryId = categoryId;
}

///修改Tab签valueExp值，注意不要用update，平台会重画tab
function setCurrentValue(newValue){
	var curTab = parent.$('#tabsReg').tabs('getSelected');
	var oldValue = curTab.panel("options").valueExp||"";
	if (oldValue.split("=")[1] == newValue)
    {
		return;
	}
	if ((oldValue).indexOf('CategoryID') >= "0")
	{
		value = oldValue.split("=")[0]+"="+newValue;
        curTab.panel("options").valueExp = value;
	}
	return;
}

//关闭病历页签(若阻止关闭，则return false)
function onBeforeCloseTab()
{
	//平台组关闭 页签方法存在
	if(parent&&parent.closeCurrentChart){	
		if ((editPage)&&(typeof editPage.closeTabSavePrompt == "function"))
		{
			var text = editPage.closeTabSavePrompt("");
			if(text!==false){
	            var dialogID = "SavePromptTab";
	            var tempFrame = "<iframe id='iframeSavePrompt' scrolling='auto' frameborder='0' src='emr.ip.prompt.csp?DialogID="+dialogID+"&PromptText="+text+"&MWToken="+getMWToken()+"' style='width:100%;height:100%;display:block;'></iframe>"
	            createModalDialog(dialogID,"保存提示","350","150","iframeSavePrompt",tempFrame,doPrompt);	
				return false;
				}else{
					//切换成侧菜单形态
					if (parent.EPRCATE85.isEprCategory()){
						parent.switchToolHandler();
					}
					return true;	
				}	
		}
	}else{	
		if ((editPage)&&(typeof editPage.savePrompt == "function"))
		{
			var editFlag = editPage.savePrompt("");
			if (editFlag == "cancel")
			{
				return false;
			}
			else if (editFlag == "unsave")
			{
				editPage.resetModifyState("","false");
			}
		}	
	}
	//切换成侧菜单形态
	if (parent.EPRCATE85.isEprCategory()){
		parent.switchToolHandler();
	}
	return true;
	/*
	if ((editPage)&&(typeof editPage.savePrompt == "function"))
	{
		var editFlag = editPage.savePrompt("");
		if (editFlag == "cancel")
		{
			return false;
		}
		else if (editFlag == "unsave")
		{
			editPage.resetModifyState("","false");
		}
	}
	return true;
	*/
}
function doPrompt(result){
    if (result == "save")
    {
	    setSysMenuDoingSth("");
        editPage.saveDocument();
        parent.closeCurrentChart();
		//切换成侧菜单形态
		if (parent.EPRCATE85.isEprCategory()){
			parent.switchToolHandler();
		}
    }else if(result == "unsave")
    {
	    setSysMenuDoingSth("");
        editPage.resetModifyState("","false");
        parent.closeCurrentChart();
		//切换成侧菜单形态
		if (parent.EPRCATE85.isEprCategory()){
			parent.switchToolHandler();
		}
    }else
    {
	    setSysMenuDoingSth(emrTrans('请先保存病历！'));
        return;
    }
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
		top.$.messager.progress({
			title: "提示",
			msg: '正在打印病历',
			text: '打印中....'
		});
	}
	else
	{
		top.$.messager.progress("close");
	}
}

//平台使用 如果返回false,不切换Chart页签
function chartOnBlur(){
    return true;
    /*8.5以后切换页签不再提示病历是否保存
    if (editPage && editPage.length >0)
    {
		if (typeof editPage.savePrompt !== "function") return;
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
    }*/
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
            setDisplay();
	    });
	} else {
	    iframe.onload = function(){
            setDisplay();
	    };
	}
})
//设置页面隐藏属性
function setDisplay(){
    if (setting.tabParam != "")
    {
        $("#nav").css("display","none");
    }else{
        $("#editor").css("display","none");
    }
}

//质控调用，切换病历
function switchRecordByID(instanceID)
{
    if (instanceID == "") return;
    if (editPage && editPage.length >0)
    {
		if (typeof editPage.loadInstanceByID !== "function") return;
        editPage.loadInstanceByID(instanceID);
    }
}
