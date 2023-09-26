function cmdQueryOnClick()
{
	var startDate=getElementValue("startDate");
	var endDate=getElementValue("endDate");
	var cLocDesc=getElementValue("cLocDesc");
	var cWardDesc=getElementValue("cWardDesc");

  var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.DelayDischarge.List" + "&startDate=" +startDate + "&endDate=" +endDate + "&loc=" +cLocDesc + "&ward=" +cWardDesc;
  parent.RPbottom.location.href=lnk;
}

function InitForm()
{
	document.getElementById("find").onclick = cmdQueryOnClick;
}
InitForm();
