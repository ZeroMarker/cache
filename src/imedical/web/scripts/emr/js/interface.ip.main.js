var navPage = document.getElementById("frameNav").contentWindow; //window.frames["frameNav"];
var editPage = document.getElementById("framRecord").contentWindow; //window.frames["framRecord"];
$(function(){
	navPage = document.getElementById("frameNav").contentWindow; 
	editPage = document.getElementById("framRecord").contentWindow; 
	if ((fromType != "")&&(fromCode != ""))
	{
		var eventInfo = getEventInfo();
		if (eventInfo == "")
		{
			$.messager.alert("提示","未获取到待关联数据，请联系工作人员调用推送事件数据接口!",'info');
			return;
		}
		setEventInfo(eventInfo);
	}
	initEditor();
	initNavPage();
	if ((docID=="")&&(modeType!="Browse"))
	{
		arr = recordParam;
		var categoryIDs = "1,3,4,6,5,2";
		//var tempFrame = "<iframe id='iframeCreateRecord' scrolling='auto' frameborder='0' src='emr.interface.ip.navigation.list.template.csp?EpisodeID="+setting.episodeId+"&CategoryIDs="+categoryIDs+"&PatientID="+setting.patientId+" style='width:1050px; height:500px; display:block;'></iframe>";
		var url = "emr.interface.ip.navigation.list.template.csp?CategoryIDs=1,3,4,6,5,2&EpisodeID="+setting.episodeId+"&PatientID="+setting.patientId+"&MWToken="+getMWToken();
		var tempFrame =   '<iframe id="iframeCreateRecord" src='+url+' width="100%" height="100%" scrolling="auto" marginwidth=0 marginheight=0 frameborder="no" framespacing=0></iframe>'
		createModalDialog("dialogCreateRecord","创建病历",1080,520,"iframeCreateRecord",tempFrame,createRecordCallback,arr,true,false);
	}
	else
	{
		if (displayType != "Nav")
		{
			initDocument();
		}
		else
		{
		/* 	$("#editor").css("display","none");
			$("#nav").css("display","block"); */
		}
	}
});

//获取事件信息
function getEventInfo()
{
	var result = "";
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.Event.BLEvents",
			"Method":"GetEventIDByFromInfo",
			"p1":fromType,
			"p2":fromCode
		},
		success : function(d) {
			result = d;
		},
		error : function(d) { alert("getEventInfo error");}
	});
	return result;
}

//设置事件信息
function setEventInfo(eventInfo)
{
	var eventType = eventInfo.split("^")[0];
	var eventID = eventInfo.split("^")[1];
	var argJson = {"event":{"EventID":eventID,"EventType":eventType}};
	recordParam.args = argJson;
}

function initNavPage()
{
	var tempDocID = docID;
	if (navShowType == "Category") {tempDocID = "";}
	var url = "emr.ip.navigation.csp?EpisodeID="+setting.episodeId +"&CategoryID="+setting.categoryId +"&DocID="+tempDocID+"&MWToken="+getMWToken();
	$("#frameNav").attr("src",url);	
}

///编辑器///////////////////////////////////////////////////
function initEditor()
{
	var url = "emr.ip.edit.csp?EpisodeID="+setting.episodeId +"&CTlocID="+setting.userLocId +"&UserID="+setting.userId +"&DocID="+docID +"&RecordShowType="+recordShowType +"&ProductSourceType="+fromType +"&ProductSourceCode="+fromCode+"&ShowNav="+showNav+"&OpenWay=Interface"+"&MWToken="+getMWToken();
	$("#framRecord").attr("src",url);
}
///打开病历
function operateRecord(param)
{
	$("#nav").css("display","none");
	$("#editor").css("display","block");
	if (editPage)
	if (fromType != "")
    {
	  param.productSource={};		  
	  param.productSource.fromCode = fromCode;
	  param.productSource.fromType = fromType;
    } 
	editPage.InitDocument(param);
}
//初始化打开病历
function initDocument()
{
	var iframeRecord = document.getElementById("framRecord");
	if (iframeRecord.attachEvent){ // 兼容IE写法
		iframeRecord.attachEvent("onload", function(){
			// iframe framRecord加载完成后要进行的操作
			if (!window.frames["framRecord"]) return;
			operateRecord(recordParam);
		})
	} else {
		iframeRecord.onload = function(){
			// iframe framRecord加载完成后要进行的操作
			if (!editPage) return;
			operateRecord(recordParam);
		}
	}
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
	navPage.init();
	editPage.unLockDocumnet();
	editPage.clearDocument();
}

function gotoEdit()
{
	$("#nav").css("display","none");
	$("#editor").css("display","block");
	editPage.setOtherButtonPrivilege();
}

///关闭时有修改提示是否保存
window.onunload = function()
{
	//因接口页中onbeforeunload，返回false无法阻止外部窗口关闭接口页。
	//导致病历未解锁、菜单锁定未清除。
	//优化逻辑清锁、清菜单。
	if (editPage)
	{
		editPage.unLockDocumnet();
		setSysMenuDoingSth();
		/* 医为浏览器不支持，暂时注释
		if (editPage.savePrompt("") == "cancel")
		{
			return false;
		}
		*/
	}
}

///关闭页面时清掉头菜单标志量及锁信息
window.onbeforeunload = function()
{
	if (editPage)
	{
		editPage.unLockDocumnet();
		setSysMenuDoingSth();
	}
}

///修改标题名称
function changeCurrentTitle(title,categoryId)
{
	setting.categoryId = categoryId;
	navPage.changeCategoryId(categoryId);
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
    if (editPage) {
        var editFlag = editPage.savePrompt("");
        if (editFlag == "cancel") {
            return false;
        }else if (editFlag == "unsave") {
            editPage.resetModifyState("","false");
        }
    }
    return true;
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
function createRecordCallback(returnValue)
{
	//返回创建病历的docId;
	if (returnValue =="Create")
	{
		if (!editPage) return;
		operateRecord(recordParam);
	}
	else if (returnValue =="closeWithOutCreate")
	{
		//initDocument();
		operateRecord(recordParam);
	}
	;
}