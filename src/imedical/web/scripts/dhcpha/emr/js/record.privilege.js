///
var privilege = {
    //是否调用签名失效
	getPrivilege:function(type,patientID,episodeID,instanceId,templateId,docId){
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
	},
    getLoadPrivilege: function (tempParam,sendflag,pInfo){
		var flag = false;
		var id = (tempParam.id == "undefined")? "":tempParam.id;
		var templateId = (tempParam.templateId == "undefined")? "":tempParam.templateId;
		var emrDocId = (tempParam.emrDocId == "undefined")? "":tempParam.emrDocId; 
		var loadPrivilege = this.getPrivilege("LoadPrivilege",pInfo.patientID,pInfo.episodeID,id,templateId,emrDocId);
		//权限判断
		if (loadPrivilege.canView == "0")
		{
			if (sendflag) setMessage('您没有权限查看 "'+tempParam.text+'"','forbid');
			flag = true;
		}
		return flag;
    },
	getCreatePrivilege: function (tempParam,sendflag,pInfo){
		var flag = false;
		var id = (tempParam.id == undefined)? "":tempParam.id;
		var templateId = (tempParam.templateId == undefined)? "":tempParam.templateId;
		var emrDocId = (tempParam.emrDocId == undefined)? "":tempParam.emrDocId;	
		var loadPrivilege = this.getPrivilege("CreatePrivilege",pInfo.patientID,pInfo.episodeID,id,templateId,emrDocId);
		//权限判断
		if (loadPrivilege.canNew == "0")
		{
			if (sendflag) setMessage('您没有权限创建 "' +tempParam.text+ '"','forbid');
			flag = true;
		}
		return flag;
	}

};
