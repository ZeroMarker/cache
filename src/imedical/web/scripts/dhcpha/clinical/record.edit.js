$(function()
{
	resizeWset();
	getNewMenu();
	getRecord();
	getDeleteRecord();
	if (parent.recordParam != undefined && parent.recordParam != "")
	{
		InitDocument(parent.recordParam);
	}
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

//关闭药历页面事件
function savePrompt(instanceID)
{
	var returnValues = "";
	///退出保存检查
	if (plugin())
	{
		if (getModifyStatus(instanceID).Modified == "True")
		{
			var documentContext = getDocumentContext(instanceID);
			
			//增加判定如果无保存权限，则退出保存检查
			if (documentContext.privelege.canSave != "1") return returnValues;

			var text = '药历 "' +documentContext.Title.DisplayName + '" 有修改是否保存';
			//returnValues = window.showModalDialog("emr.ip.prompt.csp",text,"dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
			returnValues = window.confirm(text);
			if (returnValues)
			{
				returnValues = "save"
				saveDocument();
				alert("药历已保存");
				
			}
			else
			{
				returnValues = "unsave"
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

///检查加载药历权限
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

///检查新建药历权限
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

//将提示消息发送到消息提示区
function setMessage(message,type)
{
	var Height = messageScheme['height'];
	var Fontsize = messageScheme['fontsize'];
	if ($('#record').layout('panel', 'south').panel('options').height <=0)
	{
		$('#record').layout('panel', 'south').panel('resize',{height:Height});
		$('#record').layout('resize');
	}
	message = '<img src="../scripts/dhcpha/emr/image/icon/'+type+'.png" style="height:'+Height+'px"/><div class="'+type+'" style="height:'+Height+'px;font-size:'+Fontsize+'px">'+message+'</div>';
	$("#messageInfo").html(message);
	window.setTimeout("removeMessage()",messageScheme[type]);
}

//移除提示消息
function removeMessage()
{
	$("#messageInfo").empty();
	$('#record').layout('panel','south').panel('resize',{height:"0"});
	$('#record').layout('resize');
}

//向主界面发信息
function setlockdocument(message)
{
	var messages = message.split("|");
	var span = $("<span></span>");
	if (messages.length>1)
	{
	   	$(span).html("该文档正被编辑:("+messages[1]+"|"+messages[3]+"|"+messages[2]+")");
	   	$(span).attr({"userCode":messages[0],"userName":messages[1],"ip":messages[3],"lockId":messages[4]});
	}
	parent.$("#lock").html(span);

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

//切换药历初始化状态
function initStatus()
{
	//初始化消息框
	removeMessage();
	
	//初始化工具栏状态
	parent.initToolbarStatus();
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
		if (lockinfo.LockID == "") parent.$("#lock").empty(); 
	}
}