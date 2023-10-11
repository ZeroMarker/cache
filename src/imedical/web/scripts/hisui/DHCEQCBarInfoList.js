/// Mozy	2019-9-22	DHCEQCBarInfoList.js
var SelectedRow = -1;
function BodyLoadHandler() 
{
	document.body.scroll="no";
	initPanelHeaderStyle();
}

function SelectRowHandler(index,rowdata)
{
	if (index==SelectedRow)
	{
		SelectedRow=0;
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCBarInfo";
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			lnk += "&MWToken="+websys_getMWToken()
		}
		parent.DHCEQCBarInfo.location.href=lnk;
	}
	else
	{
		if (rowdata.TRowID=="") return;
    	SelectedRow = index;
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCBarInfo&BarInfoDR="+rowdata.TRowID;
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			lnk += "&MWToken="+websys_getMWToken()
		}
		parent.DHCEQCBarInfo.location.href=lnk;
	}
}

document.body.onload = BodyLoadHandler;