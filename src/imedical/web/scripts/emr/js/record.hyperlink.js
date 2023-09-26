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
	
	var operationsStr = base64encode(utf16to8(escape(JSON.stringify(operations))));
	var xpwidth = window.screen.width-240;
	var xpheight = window.screen.height-300;
    if (name == "diagnosesRow" || name == "diagnosesLayer")   //电子病历诊断
    {
	    /* var returnValues = window.showModalDialog(link,operations,"dialogWidth=1200px;dialogheight=700px;status:no;center:yes;minimize:yes;");
	    if (returnValues != "" )
	    {
	    	updateInstanceData(operations.WriteBack,"",operations.Path,returnValues);
	    } */
	    var arr={"writeBack":operations.WriteBack,"path":operations.Path,"name":name};
	    var tempFrame = "<iframe id='iframeLink' scrolling='auto' frameborder='0' src='"+link+"&operationsStr="+operationsStr+"' style='width:"+xpwidth+"px; height:"+xpwidth+"px; display:block;'></iframe>";
		createModalDialog("dialogLink","诊断录入",xpwidth+4,xpheight+40,"iframeLink",tempFrame,linkCallBack,arr);
    }
    else if( name == "diagnosesRowV8"|| name == "diagnosesLayerV8")  //医生站诊断
    {
		/* var returnObj = window.showModalDialog(link+"&DiagnosTypeStr="+operations.Url.type,operations,"dialogWidth="+(screen.availWidth-100)+"px;dialogheight="+(screen.availHeight-200)+"px;status:no;center:yes;minimize:yes;");
	    if (typeof returnObj == "object" && returnObj.DiaDataList != "")
	    {
	    	updateInstanceData(operations.WriteBack,"",operations.Path,returnObj.DiaDataList);
	    }  */
 	   	var arr={"writeBack":operations.WriteBack,"path":operations.Path,"name":name};
	    var tempFrame = "<iframe id='iframeLinkV8' scrolling='auto' frameborder='0' src='"+link+"&DiagnosTypeStr="+operations.Url.type+"&operationsStr="+operationsStr+"' style='width:"+xpwidth+"px; height:"+xpwidth+"px; display:block;'></iframe>";
		createModalDialog("dialogLinkV8","诊断录入",xpwidth+18,xpheight+40,"iframeLinkV8",tempFrame,linkCallBack,arr); 
	}
    else if (name == "appointment")
    {
		 //window.showModalDialog("emr.record.hishyperlink.window.csp",operations,"dialogWidth="+width+"px;dialogheight="+height+"px;status:no;center:yes;minimize:yes;");   
		 var tempFrame = "<iframe id='iframeLinkWindow' scrolling='auto' frameborder='0' src='emr.record.hishyperlink.window.csp?operationsStr="+operationsStr+"' style='width:"+xpwidth+"px; height:"+xpwidth+"px; display:block;'></iframe>";
		 createModalDialog("dialogLinkWindow","诊断录入",xpwidth+4,xpheight+40,"iframeLinkWindow",tempFrame,"",""); 
		 if (operations.WriteBack != "" && operations.WriteBack != "None")
		 {
			 setHisWriteBackData(operations);
		 }
	}
}
//回调
function linkCallBack(returnValue,arr)
{
	var name = arr.name;
	var writeBack = arr.writeBack;
	var path = arr.path;
	if (name == "diagnosesRow" || name == "diagnosesLayer"){
		updateInstanceData(writeBack,"",path,returnValue);
	}else if( name == "diagnosesRowV8"|| name == "diagnosesLayerV8"){
		updateInstanceData(writeBack,"",path,returnValue);
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


