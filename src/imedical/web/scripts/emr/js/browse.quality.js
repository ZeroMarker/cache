$(function(){	
	initFrameURL();		
});

function xhrRefresh(tempParam)
{
	patientID = tempParam.papmi;
	episodeID = tempParam.adm;
	initFrameURL();
}

function initFrameURL()
{
	var status = GetBrowseStatus(episodeID);
	if (status.IsEMR == 1)
	{
		if(status.IsPDF == 0)
		{
			var url = "emr.browse.quality.emr.csp?EpisodeID="+episodeID+"&Action="+action+"&ViewType=Editor&InstanceID="+instanceID+"&Path="+path;
			if('undefined' != typeof websys_getMWToken)
			{
				url += "&MWToken="+websys_getMWToken()
			}
			$('#frameBrowseEPRorEMR').attr("src",url);
		}
	}
	else if ((status.IsEMR == 0)&&(status.IsEMR == 0))
	{
		if(status.IsPDF == 0)
		{
			var url = "emr.browse.emr.csp?EpisodeID="+episodeID+"&Action="+action+"&ViewType=Editor&InstanceID="+instanceID+"&Path="+path;
			if('undefined' != typeof websys_getMWToken)
			{
				url += "&MWToken="+websys_getMWToken()
			}
			$('#frameBrowseEPRorEMR').attr("src",url);
		}
	}
	else
	{
		var url = "epr.newfw.episodelistuvpanel.csp?patientID=" + patientID + "&episodeID=" + episodeID + "&admType=" + admType;
		if('undefined' != typeof websys_getMWToken)
		{
			url += "&MWToken="+websys_getMWToken()
		}
		$('#frameBrowseEPRorEMR').attr("src",url);
	}
}


function GetBrowseStatus(episodeID)
{
	var result = "";
	jQuery.ajax({
		type: "GET",
		dataType: "text",
		url: "../EMRservice.Ajax.browse.cls",
		async: false,
		data: {"Action":"GetBrowseStatus","EpisodeID":episodeID},
		success: function(d) { result = eval("("+d+")");},
		error : function(d) { alert(action+" error");}
	});
	return result;
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
    if (!window.frames["frameBrowseEPRorEMR"]) return rtn;
    var status = GetBrowseStatus(episodeID);
    var insID = "";
    if (status.IsEMR == 1)
    {
        if (status.IsPDF == 0)
        {
            insID = document.getElementById("frameBrowseEPRorEMR").contentWindow.getRefInsID();
        }
    }
    
    if (insID !== "")
    {
        rtn["data"] = insID;
        rtn["msg"] = "";
        rtn["success"] = true;
    }
    return rtn;
}
