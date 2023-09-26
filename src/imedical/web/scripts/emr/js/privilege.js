///脚本权限
function getPrivilegeFromDb(type,instanceId,templateId,docId,episodeId,patientId,titleName)
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
			"Type":       type,
			"TitleName":  titleName
		},
		success: function(d) {
			if (d != "") result = eval("("+d+")");
		},
		error : function(d) { alert(action + " error");}
	});
	return result;	
}

///检查操作病历权限
function getPrivilege(tempParam,action,episodeId,patientId)
{
	var id = "",templateId = "",emrDocId = "",titleName = "";
	if (typeof(tempParam) == "object")
	{
        //跑创建病历的脚本时，后台入参id应为空
        if (action !== "CreatePrivilege")
        {
            if (tempParam.id != undefined) id = tempParam.id;
        }
		if (tempParam.templateId != undefined) templateId = tempParam.templateId;
		if (tempParam.emrDocId != undefined) emrDocId = tempParam.emrDocId;
		if (tempParam.titleName != undefined) titleName = tempParam.titleName
	}	
	var actionPrivilege = getPrivilegeFromDb(action,id,templateId,emrDocId,episodeId,patientId,titleName);
	return actionPrivilege;
}

