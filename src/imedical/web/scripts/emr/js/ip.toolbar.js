var mainpage = parent.parent;
var framRecord = mainpage.editPage;
var frameNav = mainpage.navPage;
var framResource = parent.frames["framResource"];
//屏蔽工具栏的右键(右键刷新会导致按钮状态不对)
document.oncontextmenu = function(){
	return false;
}

$(function(){
	///显示隐藏工具栏///////////////////////
	$('#toolbar').tabs({
		onSelect:function(title,index){
			if ($("#toolbar").height() <=36)
			{
				$("#toolbar").height("auto");
				parent.hideToolbar("show");
			}
		}
	});
	$(".fold").click(function(){
		if ($("#toolbar").height() <=35)
		{
			$("#toolbar").height("auto");
			parent.hideToolbar("show");
			$("#toolbar .fold").removeClass("down");
			$("#toolbar .fold").addClass("up");
		}
		else
		{
			$("#toolbar").height("35px");
			parent.hideToolbar("hide");
			$("#toolbar .fold").removeClass("up");
			$("#toolbar .fold").addClass("down");
		}
	});		
	
	//控制工具栏字体段落格式等按钮的显示和隐藏
	setToolBarFontView();

	setOtherButtonPrivilege();
	if (isOpenEvent == "Y")
	{
		getEvent();
		window.setInterval("getEvent()",600000);
	}
});

//设置病历无关按钮状态
function setOtherButtonPrivilege()
{
	var toolbarPrivilege = getPrivilege("","ToolbarPrivilege",episodeID,patientID);
	if (toolbarPrivilege.canCommit == "0")
	{
		setCommitStatus('disable');
		$('#confirmRecordCompleted').attr('reason',toolbarPrivilege.cantCommitReason);
	}
	else
	{
		setCommitStatus('enable');
		$('#confirmRecordCompleted').attr('reason','');
	}
	initConfirmRecord();
	if (toolbarPrivilege.canTransfer == "0")
	{
		setTransferStatus('disable');
		$('#recordtransfer').attr('reason',toolbarPrivilege.cantTransferReason);
	}
	else
	{
		setTransferStatus('enable');
		$('#recordtransfer').attr('reason','');
	}
}

///Desc:是否可送病案室
function setCommitStatus(flag)
{
	$('#confirmRecordCompleted').linkbutton(flag);
}

//设置病历转移状态(原来在代码中的只有主管医师可用放到脚本中处理)
function setTransferStatus(flag)
{
	$('#recordtransfer').linkbutton(flag);
}

//添加收藏
document.getElementById("favoritesPlus").onclick = function(){
	//病历操作记录需要数据 start
	var categoryId = "";
	var templateId = "";
	if (framRecord.param != "")
	{
		categoryId = framRecord.param.categoryId;
		templateId = framRecord.param.templateId;
	}
	//病历操作记录需要数据 end
	//记录用户(收藏病历)行为
    AddActionLog(userID,userLocID,"FavoritesAdd",""); 
    var arr = {"userId":userID,"userLocId":userLocID};
	var tempFrame = "<iframe id='iframeFavAdd' scrolling='auto' frameborder='0' src='emr.fav.add.csp?EpisodeID="+episodeID+"&InstanceID="+ framRecord.param.id+"&categoryId="+categoryId+"&templateId="+templateId+ "&MWToken="+getMWToken()+"' style='width:450px; height:450px; display:block;'></iframe>";
	parent.createModalDialog("dialogFavAdd","添加收藏","454","490","iframeFavAdd",tempFrame,favAddCallback,arr);
};
//添加收藏回调记录日志
function favAddCallback(returnValue,arr)
{
	var UserID = arr.userId;
	var UserLocID = arr.userLocId;
    //记录用户(收藏病历.取消)行为
    if (returnValue == "FavoritesAdd.Cancel")
    AddActionLog(UserID,UserLocID,"FavoritesAdd.Cancel",""); 
    else if (returnValue == "FavoritesAdd.Commit")
    AddActionLog(UserID,UserLocID,"FavoritesAdd.Commit","");
}

//病历收藏夹
document.getElementById("favorites").onclick = function(){
	
	//记录用户(整理收藏)行为
    AddActionLog(userID,userLocID,"FavoritesView",""); 
	setFavoritesLog();
	var xpwidth=window.screen.width-300;
	var xpheight=window.screen.height-340;
	var arr = {"userId":userID,"userLocId":userLocID};
	//window.showModalDialog("emr.fav.favorite.csp","","dialogHeight:"+xpheight+"px ;dialogWidth:"+xpwidth+"px ;resizable:yes;center:yes;status:no");
	var tempFrame = "<iframe id='iframeFavorite' scrolling='auto' frameborder='0' src='emr.fav.favorite.csp?MWToken="+getMWToken()+"' style='width:100%; height:100%; display:block;'></iframe>";
	parent.createModalDialog("dialogFavorite","收藏夹",xpwidth+4,xpheight+40,"iframeFavorite",tempFrame,favoriteCallback,arr,true,false);
};
//收藏夹回调记录日志
function favoriteCallback(returnValue,arr)
{
	var userId = arr.userId;
	var userLocId = arr.userLocId;
    //记录用户(整理收藏.页面关闭)行为
    AddActionLog(userId,userLocId,"FavoritesView.Page.Close","");
}

//打开病历转移窗口
function doRecordTransfer()
{
	var tempFrame = "<iframe id='iframeRecordTransfer' scrolling='auto' frameborder='0' src='emr.ip.recordtransfer.csp?EpisodeID="+episodeID+ "&MWToken="+getMWToken()+"' style='width:352px; height:470px; display:block;'></iframe>";
	parent.createModalDialog("dialogRecordTransfer","病历转移","354","510","iframeRecordTransfer",tempFrame,"","");
}

//执行命令
function doExecute(strJson)
{
	if (!framRecord) return;						
	framRecord.cmdDoExecute(strJson); 	
}

//控制工具栏字体段落格式等按钮的显示和隐藏
function setToolBarFontView()
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSysOption",
			"Method":"GetOptionValueByName2",
			"p1":"DisableFont",
			"p2":""
		},
		success: function(d){
			if (d == "") return;
			strs = d.split(","); //字符分割
			for (i=0;i<strs.length;i++ )
			{
				if (document.getElementById(strs[i]) != null)
				{
					if (strs[i] == "font")
					{
						document.getElementById("fontSpan").style.display="none";
					}
					else
					{
						document.getElementById(strs[i]).style.display="none";
					}
				}	
			} 	
		},
		error: function(d){alert("error");}
	});
}

///提交病历/////////////////////////////////////////////////////////////
//初始化提交病历状态
function initConfirmRecord()
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmRecordStatus",
					"Method":"GetAdmRecordStatus",			
					"p1":episodeID
				},
			success: function (data){
				if (data == "1")
				{ 
					$("#confirmRecordCompleted span .l-btn-icon").removeClass("icon-big-book-arrow-rt");
					$("#confirmRecordCompleted span .l-btn-icon").addClass("icon-big-book-arrow-ok");
				}
				else
				{
					$("#confirmRecordCompleted span .l-btn-icon").removeClass("icon-big-book-arrow-ok");
					$("#confirmRecordCompleted span .l-btn-icon").addClass("icon-big-book-arrow-rt");
				}
			}
		});	
}

//送病案室点击事件
function changeRecordFinishedStatus()
{
	var xpwidth = 1000;
	var xpheight = 340;
	var tempFrame = "<iframe id='iframeConfirm' scrolling='auto' frameborder='0' src='emr.ip.confirmadmrecord.csp?EpisodeID="+episodeID+"&MWToken="+getMWToken()+"' style='width:"+xpwidth+"px; height:"+xpheight+"px; display:block;'></iframe>";
	parent.createModalDialog("ConfirmDialog","提交病历",xpwidth+4,xpheight+40,"iframeConfirm",tempFrame,confirmRecordCallBack,"");
}

//提交病历回调
function confirmRecordCallBack(returnValue,arr)
{
	if (returnValue == "confirm")
	{
		confirmRecordFinished();
	}
	else if(returnValue == "revoke")
	{
		revokeConfirmRecord();
	}
}

//提交病历
function confirmRecordFinished()
{
	//有修改必须保存后，才可确认病历全部完成
	if (framRecord && framRecord.length >0)
	{
		var result = framRecord.savePrompt("");
		if ((result != "")&&(result != "save")) return;
	}
	
	var qualityResult = qualityConfirmDocument();
	if (qualityResult) return; 
	
	var tipMsg = "提交病历后将无法修改病历，是否确认提交?";
	mainpage.$.messager.confirm("提示",tipMsg, function (r) {
		if (!r) return;
		submitRemarks();
		//获取提交病历是否成功
		getCompleteResult();
	});
}

//提交病历
function getCompleteResult()
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmRecordStatus",
					"Method":"ConfirmRecordFinished",			
					"p1":episodeID,
					"p2":userID,
					"p3":getIpAddress(),
					"p4":"EMR",
					"p5":""
				},
			success: function (data){
				
				var result = data;
				if (result == "1") 
				{
					parent.$.messager.alert("提示信息", "提交病历成功", 'info');
					window.location.reload();				
				}
				else
				{
					if (result.substring(2)!= "")
					{
						parent.$.messager.alert("提示信息", emrTrans(result.substring(2)));	
					}
					else
					{
						parent.$.messager.alert("提示信息", "提交病历失败");
					}
				}
				
			}
		});	
}


//撤销提交病历
function revokeConfirmRecord()
{
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmRecordStatus",
					"Method":"RevokeConfirmRecord",			
					"p1":episodeID,
					"p2":userID,
					"p3":getIpAddress(),
					"p4":"EMR",
					"p5":"",
					"p6":"Revoke"
				},
			success: function (data){
				var result = data;
				if (result == "1") 
				{
					parent.$.messager.alert("提示信息", "撤销提交成功", 'info');
					window.location.reload();
				}
				else
				{
					if (result.substring(2)!= "")
					{
						parent.$.messager.alert("提示信息", emrTrans(result.substring(2)));	
					}
					else
					{
						parent.$.messager.alert("提示信息", "撤销提交失败");
					}
				}
			}
		});	
}

function qualityConfirmDocument()
{
	var result =  false;
	
	if ((confirmAlertType == "2")||(confirmAlertType == "3"))
	{
		var hasData = HasQualityOrWaitSignData();
		if (hasData == "1")
		{
			result = true;
			var quality = "<iframe id='framquality' src='finishdocumentunsignlist.csp?EpisodeID="+episodeID+"&MWToken="+getMWToken()+"' style='width:98%; height:98%;border:0;margin:0px;padding:5px;overflow:hidden;' scrolling=no></iframe>"			
			framRecord.addTabs("quality","质控提示",quality,true);
			mainpage.$("#nav").css("display","none");
			mainpage.$("#editor").css("display","block");
		}
	}
	else
	{
		//病历质控
		var eventType = "ConfirmRecord^" + ssgroupID + "^" + userLocID; 
		var qualityData = qualityCheck(episodeID,"","",eventType)
		if (qualityData.total > 0)
		{
			var controlType = qualityData.ControlType;
			var quality = "<iframe id='framquality' src='dhc.emr.quality.runtimequalitylist.csp?EpisodeID="+episodeID+"&EventType="+eventType+"&TemplateID=&key="+qualityData.key+"&MWToken="+getMWToken()+"' style='width:98%; height:98%;border:0;margin:0px;padding:5px;overflow:hidden;' scrolling=no></iframe>"			
			framRecord.addTabs("quality","质控提示",quality,true); 
			if (controlType == "0") 
			{
				result = true;
				mainpage.$("#nav").css("display","none");
				mainpage.$("#editor").css("display","block");
				return result;
			}
		}
	}
	if ((qualityData != "")&&(typeof(qualityData) == "string"))
	{
		result = true;
	}
	return result;
}

//质控
function qualityCheck(episodeId,instanceId,templateId,eventType)
{
	var result = "";
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"Stream",
					"Class":"EMRservice.HISInterface.QualityInterface",
					"Method":"QualityInterfaceCheck",			
					"p1":episodeId,
					"p2":eventType,
					"p3":templateId,
					"p4":instanceId
				},
			success: function(d) {
					if (d != "")
					{
						result = jQuery.parseJSON(d);
					}
			},
			error : function(d) { 
					result = "调用质控方法出错，请重新操作！";
					alert(result);
			}
		});	
	return result;	
}

///事件助手消息
function getEvent()
{
	jQuery.ajax({
		type: "Post",
		dataType: "text",
		url: "../EMRservice.Ajax.eventData.cls",
		async: true,
		data: {
			"EpisodeID": episodeID,
			"Action": "GetMessage"
		},
		success: function(d) {
			if (d != "")
			{
				if(moveText == "Y")
				{
					var d = eval(d);
					var text = '<marquee onmouseover="this.stop()" onmouseout="this.start()" scrollamount="2">';
					for (var i=0;i<d.length;i++)
					{
						text = text + '<div class="eventList"  id='+d[i].EventType+'><img src="../scripts/emr/image/icon/'+d[i].EventType+'.png"/>';	
						text = text + '<span class="helper">'+emrTrans(d[i].PromptMessage)+'</span></div>';
						
					}
					text = text + '</marquee>';
					$("#event").html(text);		
				}
				else
				{
					var d = eval(d);
					var text = '<div id="wrap">';
					for (var i=0;i<d.length;i++)
					{
						text = text + '<a class="eventList hisui-linkbutton" href="#" title="'+emrTrans(d[i].PromptMessage)+'" onmouseenter="topCenter(this)" onmouseleave="topDel(this)" id="'+d[i].EventType+'"><img src="../scripts/emr/image/icon/'+d[i].EventType+'.png"/>';	
					}
					text = text + '</a>';
					$("#event").html(text);	
				}
			}
		},
		error : function(d) { alert(" error");}
	});
}

$("#event").on('click',".eventList",function(){
	var eventType = $(this)[0].id;

	var returnValues = "";
	if (eventType!="")
	{
		var tempFrame = "<iframe id='iframeEvent' scrolling='auto' frameborder='0' src='emr.ip.event.csp?EpisodeID="+episodeID+"&EventType="+eventType+"&MWToken="+getMWToken()+"' style='width:100%; height:100%; display:block;'></iframe>";
		parent.createModalDialog("dialogEvent","事件弹窗","614","520","iframeEvent",tempFrame,eventCallBack,"");
	}
});
//事件回调函数
function eventCallBack(returnValue,arr)
{
	if (typeof(returnValue) != "undefined" && returnValue != "")
	{
		var values = eval("("+returnValue+")");
		if (values.length <=0) return;
		mainpage.operateRecord(values);
	}
	getEvent();
}

///回到病历
function getEdit()
{
	mainpage.gotoEdit();
}

//打开申请权限窗口
document.getElementById("authRequest").onclick = function(){
	var tempFrame = "<iframe id='iframeRequest' scrolling='auto' frameborder='0' src='emr.auth.request.csp?EpisodeID="+ episodeID + "&PatientID=" + patientID + "&MWToken="+getMWToken()+"' style='width:100%; height:100%; display:block;'></iframe>";
	parent.createModalDialog("dialogAuthRequest","申请授权","1104","615","iframeRequest",tempFrame,"","");
}

function showDiaglog(title,width,height,content)
{
	mainpage.showDiaglog(title,width,height,content);
}
var messageObj="";
var titleText ="";
function topCenter(obj){
	if (!framRecord) return;
	if ((typeof($('#'+ obj.id).attr('reason')) == "undefined")||($('#'+ obj.id).attr('reason')== "")) return;
	if (typeof(obj) == "undefined") return;
	if (messageObj!=""){
		window.document.body.removeChild(messageObj);
		messageObj="";
	}
	var pos = obj.getBoundingClientRect();
	var right = pos.right
	var top = pos.top
	titleText = $('#'+ obj.id).attr('title');
	$('#'+ obj.id).attr('title',"");
	var message = $('#'+ obj.id).attr('reason');
	messageObj=document.createElement("DIV")
	messageObj.innerText=message;
	messageObj.id="messageText";
	messageObj.style.top=top+"px";
	messageObj.style.left=right+"px";
	window.document.body.appendChild(messageObj);
}
function topDel(obj){
	if (typeof(obj) == "undefined") return;
	if(titleText!=""){
		$('#'+ obj.id).attr('title',titleText);
		titleText="";
	}
	if(messageObj!=""){
		window.document.body.removeChild(messageObj);
		messageObj="";
	}
}
//调用归档统计扫描项目数目页面
function submitRemarks()
{
	if (isSubmitRemarks != "Y") return;
	var tempFrame = "<iframe id='iframeSubmitRemarks' scrolling='auto' frameborder='0' src='../csp/dhc.epr.fs.submitremarks.csp?EpisodeID=" + episodeID+ "&MWToken="+getMWToken() + "' style='width:460px; height:540px; display:block;'></iframe>";
	parent.createModalDialog("dialogSubmitRemarks","","464","580","iframeSubmitRemarks",tempFrame,"","");
}

//设置病种
document.getElementById("setDiseases").onclick = function(){
 	setPatDiseases();
 	
};
function setPatDiseases()
{
	
	var tempFrame = "<iframe id='iframeAdmPatType' scrolling='auto' frameborder='0' src='emr.ip.admpattype.csp?LocID="+userLocID+"&EpisodeID="+episodeID + "&MWToken="+getMWToken()+"' style='width:100%; height:100%; display:block;'></iframe>";
	parent.createModalDialog("admPatType","设置患者病种","320","300","iframeAdmPatType",tempFrame,"","",true,false);

}

//判断该次就诊送病案室时有没有触犯质控条目和待签数据
function HasQualityOrWaitSignData()
{
	var result = "0"
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.InterfaceService.WaitSign",
					"Method":"HasQualityOrWaitSignData",			
					"p1":episodeID
				},
			success: function (data){
				if (data == "1") 
				{
					result = "1";
				}
			}
		});
			
	return result;
}