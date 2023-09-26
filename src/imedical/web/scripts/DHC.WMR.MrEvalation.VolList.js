//Event process for DHC.WMR.MrEvalation.VolList
//2007-9-6 by LiYang Microsoft
//
//
//


function btnSelectOnClick()
{
	var objApplet = window.opener.document.getElementById("JSCaller");
	var strSourceID = window.event.srcElement.id.replace("btnSelectz", "");
	objApplet.addArg(getElementValue("VolRowIDz" + strSourceID));
	objApplet.Call("DisplayPatientBaseInfo");
	window.close();
}

function btnCloseOnClick()
{
	window.close();
}


function initForm()
{
}

function initEvent()
{
	document.getElementById("btnClose").onclick = btnCloseOnClick;
	var objTable = document.getElementById("tDHC_WMR_MrEvalation_VolList");
	for(var i = 1; i < objTable.rows.length; i ++)
	{
		document.getElementById("btnSelectz" + i).onclick = btnSelectOnClick;
	}
}

initForm();
initEvent();