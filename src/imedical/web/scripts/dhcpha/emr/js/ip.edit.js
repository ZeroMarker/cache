$(function()
{
	getRecord();
	getDeleteRecord();
	if (autoSave["switch"] == "on")
	{
		window.setInterval("eventSave()",autoSave.interval);
	}
},0);

//重置west导航宽度
function resizeWset()
{
	$('#layout').layout('panel','west').panel('resize',{width:westWidth});
	$('#layout').layout('resize');	
}

//关闭病历页面事件
function savePrompt()
{
	var returnValues = "";
	///退出保存检查
	if (plugin())
	{
		if (getModifyStatus().Modified == "True")
		{
			///如果该文档是只读状态，则退出保存检查
			var readOnly = getReadOnlyStatus().ReadOnly;
			if (readOnly == "True") return returnValues;
			var documentContext = getDocumentContext();
			var text = '病历 "' +documentContext.Title.DisplayName + '" 有修改是否保存';
			//判断客户端浏览器IE及其版本
			if ($.browser.msie && $.browser.version == '6.0')
			{
				returnValues = window.showModalDialog("emr.prompt.csp",text,"dialogHeight:180px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
			}else
			{
				returnValues = window.showModalDialog("emr.prompt.csp",text,"dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
			}
			if (returnValues == "save")
			{
				saveDocument();
				alert("已保存");
			}
			else if (returnValues == "cancel")
			{
				return returnValues;
			}
		} 
	} 	
	return returnValues;
}

///脚本权限
function getPrivilege(type,instanceId,templateId,docId)
{
	var result = "0";
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.privilege.cls",
		async: false,
		data: {
			"EpisodeID":  episodeID,
			"PatientID":  patientID,
			"InstanceID": instanceId,
			"TemplateID": templateId,
			"DocID":	  docId,
			"Type":       type
		},
		success: function(d) {
			if (d != "") result = eval("("+d+")");
		},
		error : function(d) { alert(action + " error");}
	});
	return result;	
}

///检查加载病历权限
function checkLoadPrivilege(tempParam,sendflag)
{
	var flag = false;
	var id = (tempParam.id == "undefined")? "":tempParam.id;
	var templateId = (tempParam.templateId == "undefined")? "":tempParam.templateId;
	var emrDocId = (tempParam.emrDocId == "undefined")? "":tempParam.emrDocId; 
	var loadPrivilege = getPrivilege("LoadPrivilege",id,templateId,emrDocId);
	//权限判断
	if (loadPrivilege.canView == "0")
	{
		if (sendflag) setMessage('您没有权限查看 "'+tempParam.text+'"','forbid');
		flag = true;
		return flag;
	}
}

///检查新建病历权限
function checkCreatePrivilege(tempParam,sendflag)
{
	var flag = false;
	var id = (tempParam.id == undefined)? "":tempParam.id;
	var templateId = (tempParam.templateId == undefined)? "":tempParam.templateId;
	var emrDocId = (tempParam.emrDocId == undefined)? "":tempParam.emrDocId;	
	var loadPrivilege = getPrivilege("CreatePrivilege",id,templateId,emrDocId);
	//权限判断
	if (loadPrivilege.canNew == "0")
	{
		if (sendflag) setMessage('您没有权限创建 "' +tempParam.text+ '"','forbid');
		flag = true;
		return flag;
	}
}

///检查操作病历权限
function checkActionPrivilege(tempParam)
{
	var id = (tempParam.id == undefined)? "":tempParam.id;
	var templateId = (tempParam.templateId == undefined)? "":tempParam.templateId;
	var emrDocId = (tempParam.emrDocId == undefined)? "":tempParam.emrDocId;	
	var actionPrivilege = getPrivilege("ActionPrivilege",id,templateId,emrDocId);
	return actionPrivilege;
}

///检查工具栏权限
function checkToolbarPrivilege()
{
	var actionPrivilege = checkActionPrivilege(param);
	var privelegeJson = {"action":"setToolbar","status":actionPrivilege};
	toolbar.setToolbarStatus(privelegeJson);
	if (actionPrivilege.canSave == "0")
	{
		setReadOnly(true,"");
	}
}

//将提示消息发送到消息提示区
function setMessage(message,type)
{
	var Height = "",Fontsize = "";
	if (messageScheme['fontsize'] != undefined)
	{
		Fontsize = messageScheme['fontsize'];
	}else{
		Fontsize = 14;
	}
	if (messageScheme['height'] != undefined)
	{
		Height = messageScheme['height'];
	}
	message = '<div class="'+type+'" style="height:'+Height+'px;line-height:'+Height+'px;font-size:'+Fontsize+'px;">'+message+'</div>';
	$("#messageInfo").css("height",Height);
	$("#messageInfo").html(message);
	$("#messageInfo").show();
	window.setTimeout("removeMessage()",messageScheme[type]);
}

//移除提示消息
function removeMessage()
{
	$("#messageInfo").hide();
}

//向主界面发信息
function setlockdocument(message)
{
	var messages = message.split("|");
	var span = $("<span></span>");
	if (messages.length>1)
	{
	   	$(span).html("该病历正被编辑:("+messages[1]+"|"+messages[5]+"|"+messages[3]+"|"+messages[2]+")");
	   	$(span).attr({"userCode":messages[0],"userName":messages[1],"ip":messages[3],"lockId":messages[4]});
		$("#lock").html(span);
		$("#lock").show();
	}
}

function getConfig()
{
	jQuery.ajax({
		type: "post",
		dataType: "text",
		url: '../EMRservice.Ajax.eventData.cls',
		async: true,
		data: {
			"Action": "CriticalValueConfig",
			"EpisodeID": episodeId
		},
		success: function(d) {
			if (d != "")
			{
				var data = eval("("+d+")");
				$("#title").attr({"DocID":data.DocID,"CategoryID":data.CategoryID,"TemplateId":data.TemplateId});
				$("#title").attr({"IsLeadframe":data.IsLeadframe,"IsMutex":data.IsMutex});
				$("#title").attr({"ChartItemType":data.ChartItemType,"PluginType":data.PluginType});
				for (var i=0;i<data.TitleCodes.length;i++)
				{
					$("#title").append('<option value ="'+data.TitleCodes[i].TitleCode+'">'+data.TitleCodes[i].TitleDesc+'</option>');
				}
			}
		},
		error : function(d) { alert(" error");}
	});
}

//切换病历初始化状态
function initStatus()
{
	//初始化消息框
	removeMessage();
}

//加锁
function lockDocument(groupParam)
{
	if (groupParam == "") groupParam = param;
	lockinfo = lock(groupParam.actionType,groupParam.categoryId,groupParam.emrDocId,groupParam.id,groupParam.templateId); 	
}

//解锁
function unLockDocumnet()
{
	if (lockinfo != "" && typeof(lockinfo.LockID) != "undefined")
	{
		unLock(lockinfo.LockID);
		if (lockinfo.LockID == "")
		{ 
			$("#lock").hide(); 
		}
	}
}

function btnUnLock()
{
	var lockcode = $("#lock span").attr("userCode");
	var lockname = $("#lock span").attr("userName");
	var lockId = $("#lock span").attr("lockId");
	if (lockcode != undefined )
	{
		if (!confirm("确定解锁吗?")) return;
		if (lockcode != userCode)
		{
			var result = window.showModalDialog("emr.userverification.csp?UserID="+lockcode+"&UserName="+lockname,"","dialogHeight:160px;dialogWidth:100px;resizable:no;status:no");
			if (result == "") 
			{
				return;
			}
			else if(result == "0")
			{
				alert("密码验证失败");
				return;
			}
		}
		if (unLock(lockId)=="1")
		{
			setReadOnly(false,"");
			lockDocument("");
			$("#lock").hide();
		}
		else
		{
			alert("解锁失败");
		}	
	}
}

window.onunload = function(){  
	unLockDocumnet();
	//savePrompt(); 
}  
