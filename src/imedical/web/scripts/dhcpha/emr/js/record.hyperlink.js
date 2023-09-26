function getUnitLink(commandJson) 
{
	var name = ""
	if (commandJson.args.Url.indexOf("{")>=0)
	{
		commandJson.args.Url = $.parseJSON(commandJson.args.Url);
		name = commandJson.args.Url.name;
	}
	else
	{
		name = commandJson.args.Url;
	}
	jQuery.ajax({
		type: "get",
		dataType: "json",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.HyperLink",
			"Method":"GetUnitLink",
			"p1":name
		},
		success: function(d) {
			if (d == "") return;
			openUnitLink(d,commandJson.args);
		},
		error : function(d) {alert(" error");}
	});	
}
///替换参数
function replaceLinkParams(lnk) 
{
    var result = lnk.replace('@episodeID', episodeID);
    result = result.replace('@patientID',patientID);
    result = result.replace('@locID', userLocID);
    result = result.replace('@userID', userID);
    result = result.replace('@mradm', mradm);
	result = result.replace('@cardNo', cardNo);
    return result;
}
//打开连接
function openUnitLink(unitLink,operations) 
{
    link = replaceLinkParams(unitLink.Link);
    unitLink.Link = link;
    operations.unitLink = unitLink;
  
	var width = screen.availWidth - 10;
	var height = screen.availHeight - 50;
	var name = "";
	if (operations.Url.name)
	{
		name = operations.Url.name;
	}
	else
	{
		name = operations.Url;
	}
	
    if (name == "diagnosesRow" || name == "diagnosesLayer")   //电子病历诊断
    {
	    var returnValues = window.showModalDialog(link,operations,"dialogWidth=1200px;dialogheight=700px;status:no;center:yes;minimize:yes;");
	    if (returnValues != "" )
	    {
	    	updateInstanceData(operations.WriteBack,"",operations.Path,returnValues);
	    }
    }
    else if( name == "diagnosesRowV8"|| name == "diagnosesLayerV8")  //医生站诊断
    {
		var returnObj = window.showModalDialog(link+"&DiagnosTypeStr="+operations.Url.type,operations,"dialogWidth="+(screen.availWidth-100)+"px;dialogheight="+(screen.availHeight-200)+"px;status:no;center:yes;minimize:yes;");
	    if (typeof returnObj == "object")
	    {
	    	updateInstanceData(operations.WriteBack,"",operations.Path,returnObj.DiaDataList);
	    }   
	    hyLinkeOpenFlag = 0 ; 
	}
    else if (name == "appointment")
    {
		 window.showModalDialog("emr.record.hishyperlink.window.csp",operations,"dialogWidth="+width+"px;dialogheight="+height+"px;status:no;center:yes;minimize:yes;");   
		 if (operations.WriteBack != "" && operations.WriteBack != "None")
		 {
			 setHisWriteBackData(operations);
		 }
	}
}

///回写his数据到界面
function setHisWriteBackData(operations)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.HyperLink",
			"Method":"GetHisLinkData",
			"p1":episodeID,
			"p2":operations.Url
		},
		success: function(d) {
			if (d == "") return;
		    updateInstanceData(operations.WriteBack,"",operations.Path,d);		
		},
		error : function(d) {alert(" error");}
	});	
}


