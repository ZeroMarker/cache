/// Mozy	2019-9-22	DHCEQCBarInfoList.js
var SelectedRow = -1;
function BodyLoadHandler() 
{
	document.body.scroll="no";
}

function SelectRowHandler(index,rowdata)
{
	if (index==SelectedRow)
	{
		SelectedRow=0;
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCBarInfo";
		parent.DHCEQCBarInfo.location.href=lnk;
	}
	else
	{
		if (rowdata.TRowID=="") return;
    	SelectedRow = index;
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCBarInfo&BarInfoDR="+rowdata.TRowID;
		parent.DHCEQCBarInfo.location.href=lnk;
	}
}

document.body.onload = BodyLoadHandler;