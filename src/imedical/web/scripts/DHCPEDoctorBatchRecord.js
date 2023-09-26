
document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	var obj=document.getElementById("BBatchResult");
	if (obj) obj.onclick=BBatchResult_click;
}
function BBatchResult_click()
{
	var encmeth="",ArrivedDate="",CheckDate="",DocID="",LocID="",GroupID="";
	var obj=document.getElementById("BatchClass");
	if (obj) encmeth=obj.value;
	var obj=document.getElementById("ArrivedDate");
	if (obj) ArrivedDate=obj.value;
	var obj=document.getElementById("CheckDate");
	if (obj) CheckDate=obj.value;
	//ArrivedDate As %String = "", CheckDate As %String = "", DocID As %String = "", GroupID As %String = "", LocID As %String = ""
	DocID=session['LOGON.USERID'];
	LocID=session['LOGON.CTLOCID'];
	GroupID=session['LOGON.GROUPID'];
	var ret=cspRunServerMethod(encmeth,ArrivedDate,CheckDate,DocID,GroupID,LocID);
	var obj=document.getElementById("BFind");
	if (obj) obj.click();
}