
//Choose Request  by liyang 2008-3-4
function ShowChooseRequest(MainID, AimDateFrom, AimDateTo, IsActive)
{
	var strUrl = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.ChooseRequest" +
			"&MainID=" + MainID +
			"&AimDateFrom=" + AimDateFrom +
			"&AimDateTo=" + AimDateTo +
			"&IsActive=" + IsActive;
	var objRequest = window.showModalDialog(strUrl, "dialogWidth=300,dialogHeight=500");
	return objRequest;
}
