
function SetPreDate(e)
{
	var Info=e.id;
	var Arr=Info.split("^");
	if (Arr[0]==0){
		var lnk="dhcpecheckpassword.csp";
		var ret=window.showModalDialog(lnk, "", "dialogwidth:300px;dialogheight:100px;center:1"); 

		if (ret!=1) return false;
	}
	if (opener) opener.SetPreDate(Arr[1]);
	window.close();
}

