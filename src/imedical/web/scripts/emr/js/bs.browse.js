$(function(){	
	//获取patientID
	initFrameURL();		
});

function xhrRefresh(tempParam)
{
	var refreshFlag = "0";
	if (episodeID != tempParam.adm)
	{
		refreshFlag = "1";
	}
	patientID = tempParam.papmi;
	episodeID = tempParam.adm;
	if (refreshFlag == "1")
	{
		initFrameURL();	
	}
}

function initFrameURL()
{
	var status = GetBrowseStatus(episodeID);
	if (+status !== 2)
	{
		//非2版病历处理
		var url = "emr.bs.browse.emr.csp?EpisodeID="+episodeID+"&Action="+action+"&ViewType=EditorHtml&InstanceID="+instanceID+"&categorydir="+categorydir+"&MWToken="+getMWToken();
		$('#frameBrowseEPRorEMR').attr("src",url);
		
	}
	else
	{
		var url = "epr.newfw.episodelistuvpanel.csp?patientID=" + patientID + "&episodeID=" + episodeID + "&admType=" + admType+"&MWToken="+getMWToken();
		$('#frameBrowseEPRorEMR').attr("src",url);
	}	
}

/**
 * 获取当前就诊的病历版本
 * @param {*} 就诊号：episodeID 
 * @returns 病历版本信息
 */
function GetBrowseStatus(episodeID)
{
	var result = "";
	ajaxGETCommon({
		data:{
			action: "GET_VERSIONID",
        	params:{
            	episodeID: episodeID
        	},
        	product: product,
        	module:module
        	},
		isAsync:false,
		onSuccess:function(d){
			result = d;
		}
	})
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
    if (status !== "2")
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

//医务管理组调用关闭病历页签
function onBeforeCloseTab()
{
    if (document.getElementById("frameBrowseEPRorEMR").contentWindow){
        if (document.getElementById("frameBrowseEPRorEMR").contentWindow.onBeforeCloseTab){
            document.getElementById("frameBrowseEPRorEMR").contentWindow.onBeforeCloseTab();
        }
    }
}
