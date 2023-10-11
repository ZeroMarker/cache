$(function(){	
	initFrameURL();	
	$("#manageLayout .panel-body-noborder").css("overflow","hidden");
	initToolbar();
});

function xhrRefresh(tempParam)
{
	patientID = tempParam.papmi;
	episodeID = tempParam.adm;
	initFrameURL();
}

function initFrameURL()
{
	var url = "emr.browse.csp?EpisodeID="+episodeID+"&Action="+action+"&InstanceID="+instanceID+"&MWToken="+getMWToken();
	$('#frameBrowseManage').attr("src",url);
}

//导出病历
document.getElementById("export").onclick = function(){
	
	if (!judgeIsIE())
	{
		if (!window.frames["frameBrowseManage"]) return;
		if (!window.frames["frameBrowseManage"].contentWindow.frames["frameBrowseEPRorEMR"]) return;
		if (!window.frames["frameBrowseManage"].contentWindow.frames["frameBrowseEPRorEMR"].contentWindow.frames["frameBrowseContent"]) return;
		if (typeof(window.frames["frameBrowseManage"].contentWindow.frames["frameBrowseEPRorEMR"].contentWindow.frames["frameBrowseContent"].contentWindow.exportDocument) == "function")
		{
			window.frames["frameBrowseManage"].contentWindow.frames["frameBrowseEPRorEMR"].contentWindow.frames["frameBrowseContent"].contentWindow.exportDocument();
		}
	}
	else
	{
		if (!window.frames["frameBrowseManage"]) return;
		if (!window.frames["frameBrowseManage"].window.frames["frameBrowseEPRorEMR"]) return;
		if (!window.frames["frameBrowseManage"].window.frames["frameBrowseEPRorEMR"].window.frames["frameBrowseContent"]) return;
		if (typeof(window.frames["frameBrowseManage"].window.frames["frameBrowseEPRorEMR"].window.frames["frameBrowseContent"].exportDocument) == "function")
		{
			window.frames["frameBrowseManage"].window.frames["frameBrowseEPRorEMR"].window.frames["frameBrowseContent"].exportDocument();
		}
	} 
}

//打印病历
document.getElementById("print").onclick = function(){
	
	if (!judgeIsIE())
	{
		if (!window.frames["frameBrowseManage"]) return;
		if (!window.frames["frameBrowseManage"].contentWindow.frames["frameBrowseEPRorEMR"]) return;
		if (!window.frames["frameBrowseManage"].contentWindow.frames["frameBrowseEPRorEMR"].contentWindow.frames["frameBrowseContent"]) return;
		if (typeof(window.frames["frameBrowseManage"].contentWindow.frames["frameBrowseEPRorEMR"].contentWindow.frames["frameBrowseContent"].contentWindow.printDocument) == "function")
		{
			window.frames["frameBrowseManage"].contentWindow.frames["frameBrowseEPRorEMR"].contentWindow.frames["frameBrowseContent"].contentWindow.printDocument();
		}
	}
	else
	{
		if (!window.frames["frameBrowseManage"]) return;
		if (!window.frames["frameBrowseManage"].window.frames["frameBrowseEPRorEMR"]) return;
		if (!window.frames["frameBrowseManage"].window.frames["frameBrowseEPRorEMR"].window.frames["frameBrowseContent"]) return;
		if (typeof(window.frames["frameBrowseManage"].window.frames["frameBrowseEPRorEMR"].window.frames["frameBrowseContent"].printDocument) == "function")
		{
			window.frames["frameBrowseManage"].window.frames["frameBrowseEPRorEMR"].window.frames["frameBrowseContent"].printDocument();
		}
	} 
}

function initToolbar()
{ 
	if (scheme == "") return;
	var strXml = convertToXml(scheme);
    $(strXml).find("item").each(function(){
	    var toolID = $(this).find("id").text();
	    if (!document.getElementById(toolID)) return; 
	    
	    $(this).find("ssgroupID").each(function(){
		    var tmpssgroupID = $(this).text();
		    if (tmpssgroupID == ssgroupID)
		    {
			   document.getElementById(toolID).style.display="block"; 
			   document.getElementById("toolbar").style.display="block"; 
			   document.getElementById("toolbar").style.height="100px"; 
			   return;
		    }
	    });
    });
    $('body').layout('resize');
}

//平台调用-将HISUI病历浏览页面浏览的门诊病历引用到门诊书写界面
function getRefData()
{
    var rtn = {"data":"","toTitle":"门诊病历","msg":"没有获取到复制的数据","success":false};
    if (admType != "O")
    {
        rtn["msg"] = "当前所浏览病历不是门诊的就诊类型，所以病历不能引用";
        return rtn;
    }
    if (!window.frames["frameBrowseManage"]) rtn;
    return document.getElementById("frameBrowseManage").contentWindow.getRefData();
}
