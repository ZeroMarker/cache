///确认病历全部完成/////////////////////////////////////////////////////////////
//初始化送病案室状态
function initConfirmMRecord()
{
	$("#confirmMRecordCompleted").attr("flag",true);
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmMRecordStatus",
					"Method":"GetAdmRecordStatus",			
					"p1":episodeID
				},
			success: function (data){
				if (data == "1")
				{ 
					$("#confirmMRecordCompleted").attr("flag",false);
					if (isEnableRevokeComplete == "N")
					{
						$("#confirmMRecordCompleted").attr("title","首页已提交");
						$("#confirmMRecordCompleted span .l-btn-text").text(emrTrans("首页已提交"));
						$("#confirmMRecordCompleted").css("width","105px");
					}
					else
					{
						$("#confirmMRecordCompleted").attr("title","撤销预提交");
						$("#confirmMRecordCompleted span .l-btn-text").text(emrTrans("撤销预提交"));
						$("#confirmMRecordCompleted").css("width","125px");
					}
					$("#confirmMRecordCompleted").css("line-height","2");
					$("#confirmMRecordCompleted").css("text-align","center");
				}else {
					$("#confirmMRecordCompleted").attr("title","确认病案首页完成");
					$("#confirmMRecordCompleted span .l-btn-text").text(emrTrans("预提交"));
					$("#confirmMRecordCompleted").css("width","90px");
					$("#confirmMRecordCompleted").css("line-height","2");
					$("#confirmMRecordCompleted").css("text-align","center");
				}
			}
		});	
}

//送病案室点击事件
function changeMRecordFinishedStatus()
{
	if ($("#confirmMRecordCompleted").attr("flag") && $("#confirmMRecordCompleted").attr("flag")=="false")	
	{
		if (isEnableRevokeComplete == "N") return;
		var tipMsg = "是否确认撤销病案首页提交?";
		parent.$.messager.confirm("提示",tipMsg, function (r) {
			if (!r) return;
			revokeConfirmMRecord();
		});
	}
	else
	{
		confirmMRecordFinished();
	}	
}

//确认病历全部完成
function confirmMRecordFinished()
{
	//var param= parent.param;
	if ((param==null )||(param=="" )) {
	   parent.$.messager.alert("提示信息", "请先打开病案首页，再提交！","info");
	   return;
	}
	if ((confirmMRecordDocID==null )||(confirmMRecordDocID=="" )||(confirmMRecordDocID==undefined )) {
	  parent.$.messager.alert("提示信息", "请先在维护程序中维护系统参数'confirmMRecordDocID'，在提交！","info");
	  return;
	}	
	if ((param.emrDocId!=confirmMRecordDocID)) {
	  parent.$.messager.alert("提示信息", "请先打开病案首页或在维护程序中维护的系统参数不正确，请检查后再提交！","info");
	  return;
	}
	///华西医院提供的医疗组长参数///
/* 	if (userName!=ImedicalGMDesc) {
	  parent.$.messager.alert("提示信息", "只能医疗组长提交首页！");
	  return;
	} */
	
	//有修改必须保存后，才可确认病历全部完成
    var result = savePrompt("");
	if ((result != "")&&(result != "save")) return;
	
	var qualityResult = qualityConfirmMDocument();
	if (qualityResult) return; 
    //获得需要打印范围内的所有InstanceID
	//var allInstanceID = getInstanceID();
    //质控
	//var qualityResult = qualityPrintDocument(param.id);
	//if (qualityResult) return; 
	
	var tipMsg = "确认提交病案首页后将无法修改病案首页，是否确认提交?";
	parent.$.messager.confirm("提示",tipMsg, function (r) {
		if (!r) return;
		//submitRemarks();
		//获取确认病历全部完成是否成功
		var completeResult = getCompleteMResult();
		if (completeResult == true)
		{
			parent.$.messager.alert("提示信息", "提交病案首页成功", 'info');
		}
		else 
		{
			parent.$.messager.alert("提示信息", "提交病案首页失败");
			return;
		}
		//parent.window.location.reload();
		parent.updatePrivilege();
		var documentContext = parent.getDocumentContext(param.id);
		parent.setPrivelege(documentContext);
	});
}

//确认病历全部完成
function getCompleteMResult()
{
	var result = false;
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmMRecordStatus",
					"Method":"ConfirmRecordFinished",			
					"p1":episodeID,
					"p2":userID
				},
			success: function (data){
				//alert(data);
				if (data == "1") 
				{
					result = true;
					$("#confirmMRecordCompleted").attr("flag",false);
					if (isEnableRevokeComplete == "N")
					{
						$("#confirmMRecordCompleted").attr("title","已送病案室");
						$("#confirmMRecordCompleted span .l-btn-text").text(emrTrans("已送病案室"));
						$("#confirmMRecordCompleted").css("width","105px");
					}
					else
					{
						$("#confirmMRecordCompleted").attr("title","撤销预提交");
						$("#confirmMRecordCompleted span .l-btn-text").text(emrTrans("撤销预提交"));
						$("#confirmMRecordCompleted").css("width","115px");
					}
					$("#confirmMRecordCompleted").css("line-height","2");
					$("#confirmMRecordCompleted").css("text-align","center");
					
				}
			}
		});	
	return result;
}

function setConfirmMRecordCompletedStatus()
{
	$("#confirmMRecordCompleted").attr("flag",true);
	$("#confirmMRecordCompleted").attr("title","确认病案首页完成");
	$("#confirmMRecordCompleted span .l-btn-text").text(emrTrans("提交首页"));
	$("#confirmMRecordCompleted").css("width","90px");
	$("#confirmMRecordCompleted").css("line-height","2");
	$("#confirmMRecordCompleted").css("text-align","center");
}
//撤销病历送病案室状态
function revokeConfirmMRecord()
{
	//parent.$.messager.alert("提示信息", "您无权限撤销病历预提交!请联系病案室撤销提交")
	//return;
	jQuery.ajax({
			type : "GET", 
			dataType : "text",
			url : "../EMRservice.Ajax.common.cls",
			async : false,
			data : {
					"OutputType":"String",
					"Class":"EMRservice.BL.BLAdmMRecordStatus",
					"Method":"RevokeConfirmRecord",			
					"p1":episodeID,
					"p2":userID
				},
			success: function (data){
				var result = data;
				if (result == "1") 
				{
					$("#confirmMRecordCompleted").attr("flag",true);
					$("#confirmMRecordCompleted").attr("title","确认病案首页完成");
					$("#confirmMRecordCompleted span .l-btn-text").text(emrTrans("预提交"));
					$("#confirmMRecordCompleted").css("width","90px");
					$("#confirmMRecordCompleted").css("line-height","2");
					$("#confirmMRecordCompleted").css("text-align","center");
					parent.$.messager.alert("提示信息", "撤销病案首页提交成功", 'info');
					//parent.window.location.reload();
				}
				else
				{
					if (result.substring(2)!= "")
					{
						parent.$.messager.alert("提示信息", emrTrans(result.substring(2)));	
					}
					else
					{
						parent.$.messager.alert("提示信息", "撤销病案首页提交失败");
					}
				}
			}
		});	
}

function qualityConfirmMDocument()
{
	var result =  false;
	//病历质控
	var eventType = "ConfirmRecord^" + ssgroupID + "^" + userLocID; 
	var qualityData = qualityMCheck(episodeID,"","",eventType)
	if (qualityData.total > 0)
	{
		var controlType = qualityData.ControlType;
		var quality = "<iframe id='framclipboard' src='dhc.epr.quality.runtimequalitylist.csp?EpisodeID="+episodeID+"&EventType="+eventType+"&TemplateID=&key="+qualityData.key+"' style='width:98%; height:98%;border:0;margin:0px;padding:5px;overflow:hidden;' scrolling=no></iframe>"			
		addTabs("quality","质控提示",quality,true); 
		if (controlType == "0") 
		{
			result = true;
			parent.$("#nav").css("display","none");
			parent.$("#editor").css("display","block");
			return result;
		}
	}
	return result;
}

//质控
function qualityMCheck(episodeId,instanceId,templateId,eventType)
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
			error : function(d) { alert("GetSummery error");}
		});	
	return result;	
}
function emrTrans(txt) {
   return txt;
}