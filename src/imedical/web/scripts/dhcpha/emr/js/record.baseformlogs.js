//�򿪲�����־
var SecCode = "";
jQuery.ajax({
	type: "get",
	dataType: "text",
	url: "../EMRservice.Ajax.common.cls",
	async: false,
	data: {
		"OutputType":"String",
		"Class":"EMRservice.Ajax.patientInfo",
		"Method":"GetPatEncryptLevel",
		"p1":patientID
	},
	success: function(d){
		if (d != "") SecCode = d.split('^')[2];
	},
	error: function(d){alert("error");}
});

var IsSetToLog = "N";
jQuery.ajax({
	type: "get",
	dataType: "text",
	url: "../EMRservice.Ajax.common.cls",
	async: false,
	data: {
		"OutputType":"String",
		"Class":"EMRservice.BL.BLSysOption",
		"Method":"GetOptionValueByName2",
		"p1":"IsSetToLog",
		"p2":"N"
	},
	success: function(d){
		IsSetToLog = d;
	},
	error: function(d){alert("error");}
});
function openDocumentLog(obj,ModelName)
{
	if (IsSetToLog == "Y")
	{
		var ipAddress = getIpAddress();
		var Condition = "";
		Condition = Condition + '{"patientID":"' + patientID + '",';
		Condition = Condition + '"episodeID":"' + episodeID + '",';
		Condition = Condition + '"userName":"' + userName + '",';
		Condition = Condition + '"userID":"' + userID + '",';
		Condition = Condition + '"ipAddress":"' + ipAddress + '",';
		Condition = Condition + '"id":"' + obj.id + '",';
		Condition = Condition + '"pluginType":"' + obj.pluginType + '",';
		Condition = Condition + '"chartItemType":"' + obj.chartItemType + '",';
		Condition = Condition + '"emrDocId":"' + obj.emrDocId + '",';
		Condition = Condition + '"templateId":"' + obj.templateId + '",';
		Condition = Condition + '"categoryId":"' + obj.categoryId + '",';
		Condition = Condition + '"isLeadframe":"' + obj.isLeadframe + '",';
		Condition = Condition + '"isMutex":"' + obj.isMutex + '",';
		Condition = Condition + '"actionType":"' + obj.actionType + '",';
		Condition = Condition + '"status":"' + obj.status + '",';
		Condition = Condition + '"text":"' + obj.text + '"}';
		var ConditionAndContent = Condition;
		$.ajax({ 
			type: "POST", 
			url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
			data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + SecCode
		});
	}
}

//����������־ 
function CreateDocumentLog(obj,ModelName)
{
	if (IsSetToLog == "Y")
	{
		var ipAddress = getIpAddress();
		var Condition = "";
		Condition = Condition + '{"patientID":"' + patientID + '",';
		Condition = Condition + '"episodeID":"' + episodeID + '",';
		Condition = Condition + '"userName":"' + userName + '",';
		Condition = Condition + '"userID":"' + userID + '",';
		Condition = Condition + '"ipAddress":"' + ipAddress + '",';
		Condition = Condition + '"id":"' + "" + '",';
		Condition = Condition + '"pluginType":"' + obj.pluginType + '",';
		Condition = Condition + '"chartItemType":"' + obj.chartItemType + '",';
		Condition = Condition + '"emrDocId":"' + obj.emrDocId + '",';
		Condition = Condition + '"templateId":"' + obj.templateId + '",';
		Condition = Condition + '"categoryId":"' + obj.categoryId + '",';
		Condition = Condition + '"isLeadframe":"' + obj.isLeadframe + '",';
		Condition = Condition + '"isMutex":"' + obj.isMutex + '",';
		Condition = Condition + '"actionType":"' + obj.actionType + '",';
		Condition = Condition + '"status":"' + obj.status + '",';
		if (ModelName == "EMR.Nav.RecordNav.CreateInOld")
		{
			Condition = Condition + '"pInstanceId":"' + obj.pInstanceId + '",';
		}
		Condition = Condition + '"text":"' + obj.text + '"}';
		var ConditionAndContent = Condition;
		$.ajax({ 
			type: "POST", 
			url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
			data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + SecCode
		});
	}	
}

//����������־ 
function CreateGroupDocumentLog(obj,ModelName)
{
	if (IsSetToLog == "Y")
	{
		var ipAddress = getIpAddress();
		var Condition = "";
			Condition = Condition + '{"patientID":"' + patientID + '",';
			Condition = Condition + '"episodeID":"' + episodeID + '",';
			Condition = Condition + '"userName":"' + userName + '",';
			Condition = Condition + '"userID":"' + userID + '",';
			Condition = Condition + '"ipAddress":"' + ipAddress + '",';
			Condition = Condition + '"id":"' + "" + '",';		
			Condition = Condition + '"content:"'+JSON.stringify(obj);
			Condtion =  Condition + '}'
		var ConditionAndContent = Condition;
		$.ajax({ 
			type: "POST", 
			url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
			data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + SecCode
		});
	}	
}

//������־(����ƽ̨��)
function setOperationLog(params,ModelName)
{
	if (IsSetToLog == "Y")
	{
		var Condition = "";
		Condition = Condition + '{"patientID":"' + patientID + '",';
		Condition = Condition + '"episodeID":"' + episodeID + '",';
		Condition = Condition + '"userName":"' + userName + '",';
		Condition = Condition + '"userID":"' + userID + '",';
		Condition = Condition + '"ipAddress":"' + ipAddress + '",';
		Condition = Condition + '"id":"' + params["id"] + '",';
		Condition = Condition + '"pluginType":"' + params["pluginType"] + '",';
		Condition = Condition + '"chartItemType":"' + params["chartItemType"] + '",';
		Condition = Condition + '"emrDocId":"' + params["emrDocId"] + '",';
		Condition = Condition + '"templateId":"' + params["templateId"] + '",';
		Condition = Condition + '"categoryId":"' + params["categoryId"] + '",';
		Condition = Condition + '"isLeadframe":"' + params["isLeadframe"] + '",';
		Condition = Condition + '"isMutex":"' + params["isMutex"] + '",';
		Condition = Condition + '"actionType":"' + params["actionType"] + '",';
		Condition = Condition + '"status":"' + params["status"] + '",';
		Condition = Condition + '"text":"' + params["text"] + '"}';
		var ConditionAndContent = Condition;
		$.ajax({ 
			type: "POST", 
			url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
			data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + SecCode
		});
	}	
}


///�����
function setLockToLog(id,docId,ModelName)
{
	
	var Condition = "";
	Condition = Condition + '{"LockID":"' + id + '",';
	Condition = Condition + '"episodeID":"' + episodeID + '",';
	Condition = Condition + '"LockDocID":"' + docId + '",';
	Condition = Condition + '"userName":"' + userName + '",';
	Condition = Condition + '"userID":"' + userID + '",';
	Condition = Condition + '"ipAddress":"' + ipAddress + '"}';
	$.ajax({ 
		type: "POST", 
		url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
		data: "ModelName="+ ModelName + "&ConditionAndContent=" + Condition + "&SecCode=" + SecCode
	});	
}

///����ղؼ�
function setFavoritesLog()
{
	if (IsSetToLog == "Y")
	{
		var ipAddress = getIpAddress();
		var ModelName = "EMR.Favorites.Login";
		var Condition = "";
		Condition = Condition + '{"patientID":"' + patientID + '",';
		Condition = Condition + '"episodeID":"' + episodeID + '",';
		Condition = Condition + '"userName":"' + userName + '",';
		Condition = Condition + '"userID":"' + userID + '",';
		Condition = Condition + '"ipAddress":"' + ipAddress + '"}';
		var ConditionAndContent = Condition;
		$.ajax({ 
			type: "POST", 
			url: "../EMRservice.Ajax.SetDataToEventLog.cls", 
			data: "ModelName="+ ModelName + "&ConditionAndContent=" + ConditionAndContent + "&SecCode=" + SecCode
		});
	}	
}