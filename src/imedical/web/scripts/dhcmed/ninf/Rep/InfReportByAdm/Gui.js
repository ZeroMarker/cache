//页面初始化
function InitForm()
{
	//var lnk="dhcmed.ninf.clinrepview.csp?1=1&EpisodeID=" + GetParam(window,"EpisodeID") + "&2=2";
	var lnk="dhcmed.ss.clinreptoadm.csp?1=1&EpisodeID=" + GetParam(window,"EpisodeID") + "&2=2";
	location.href=lnk;
}

//获取参数
function GetParam(obj, key)
{
	var url = obj.location.href;
	var strParams = "";
	var pos = url.indexOf("?");
	var tmpArry = null;
	var strValue = "";
	var tmp = "";
	if( pos < 0) {
		return "";
	} else {
		strParams = url.substring(pos + 1, url.length);
		tmpArry = strParams.split("&");
		for(var i = 0; i < tmpArry.length; i++)
		{
			tmp = tmpArry[i];
			if(tmp.indexOf("=") < 0) continue;
			if(tmp.substring(0, tmp.indexOf("=")) == key)
			{
				strValue = tmp.substring(tmp.indexOf("=") + 1, tmp.length);
			}
		}
		return strValue;
	}
}

InitForm();