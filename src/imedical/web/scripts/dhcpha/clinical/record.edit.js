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

//����west�������
function resizeWset()
{
	$('#layout').layout('panel','west').panel('resize',{width:westWidth});
	$('#layout').layout('resize');	
}

//�ر�ҩ��ҳ���¼�
function savePrompt(instanceID)
{
	var returnValues = "";
	///�˳�������
	if (plugin())
	{
		if (getModifyStatus(instanceID).Modified == "True")
		{
			var documentContext = getDocumentContext(instanceID);
			
			//�����ж�����ޱ���Ȩ�ޣ����˳�������
			if (documentContext.privelege.canSave != "1") return returnValues;

			var text = 'ҩ�� "' +documentContext.Title.DisplayName + '" ���޸��Ƿ񱣴�';
			//returnValues = window.showModalDialog("emr.ip.prompt.csp",text,"dialogHeight:150px;dialogWidth:350px;resizable:no;status:no;scroll:yes;");
			returnValues = window.confirm(text);
			if (returnValues)
			{
				returnValues = "save"
				saveDocument();
				alert("ҩ���ѱ���");
				
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

///�ű�Ȩ��
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

///������ҩ��Ȩ��
function checkLoadPrivilege(tempParam,sendflag)
{
	var flag = false;
	var id = (tempParam.id == "undefined")? "":tempParam.id;
	var templateId = (tempParam.templateId == "undefined")? "":tempParam.templateId;
	var emrDocId = (tempParam.emrDocId == "undefined")? "":tempParam.emrDocId; 
	var loadPrivilege = getPrivilege("LoadPrivilege",id,templateId,emrDocId);
	//Ȩ���ж�
	if (loadPrivilege.canView == "0")
	{
		if (sendflag) setMessage('��û��Ȩ�޲鿴 "'+tempParam.text+'"','forbid');
		flag = true;
		return flag;
	}
}

///����½�ҩ��Ȩ��
function checkCreatePrivilege(tempParam,sendflag)
{
	var flag = false;
	var id = (tempParam.id == undefined)? "":tempParam.id;
	var templateId = (tempParam.templateId == undefined)? "":tempParam.templateId;
	var emrDocId = (tempParam.emrDocId == undefined)? "":tempParam.emrDocId;	
	var loadPrivilege = getPrivilege("CreatePrivilege",id,templateId,emrDocId);
	//Ȩ���ж�
	if (loadPrivilege.canNew == "0")
	{
		if (sendflag) setMessage('��û��Ȩ�޴��� "' +tempParam.text+ '"','forbid');
		flag = true;
		return flag;
	}
}

//����ʾ��Ϣ���͵���Ϣ��ʾ��
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

//�Ƴ���ʾ��Ϣ
function removeMessage()
{
	$("#messageInfo").empty();
	$('#record').layout('panel','south').panel('resize',{height:"0"});
	$('#record').layout('resize');
}

//�������淢��Ϣ
function setlockdocument(message)
{
	var messages = message.split("|");
	var span = $("<span></span>");
	if (messages.length>1)
	{
	   	$(span).html("���ĵ������༭:("+messages[1]+"|"+messages[3]+"|"+messages[2]+")");
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

//�л�ҩ����ʼ��״̬
function initStatus()
{
	//��ʼ����Ϣ��
	removeMessage();
	
	//��ʼ��������״̬
	parent.initToolbarStatus();
}

//����
function lockDocument(groupParam)
{
	if (groupParam == "") groupParam = param;
	lockinfo = lock(groupParam.actionType,groupParam.categoryId,groupParam.emrDocId,groupParam.id,groupParam.templateId); 	
}

//����
function unLockDocumnet()
{
	if (lockinfo != "" && typeof(lockinfo.LockID) != "undefined")
	{
		unLock(lockinfo.LockID);
		if (lockinfo.LockID == "") parent.$("#lock").empty(); 
	}
}