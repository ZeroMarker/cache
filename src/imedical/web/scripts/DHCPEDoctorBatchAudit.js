
document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	var obj=document.getElementById("BBatchAudit");
	if (obj) obj.onclick=BBatchAudit_click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
}
function BFind_click()
{
	var ArrivedDate="",MainDoctor="N",ShowErr="0";
	var obj=document.getElementById("ArrivedDate");
	if (obj) ArrivedDate=obj.value;
	var obj=document.getElementById("MainDoctor");
	if (obj&&obj.checked) MainDoctor="Y";
	var obj=document.getElementById("ShowErr");
	if (obj&&obj.checked) ShowErr="1";
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEDoctorBatchAudit&ArrivedDate="+ArrivedDate+"&ShowErr="+ShowErr+"&MainDoctor="+MainDoctor;
	//alert(lnk)
	window.location.href=lnk;
}
function BBatchAudit_click()
{
	var encmeth="",ArrivedDate="",AuditDate="",DocID="",MainDoctor="N",NoResultFlag="0";
	var obj=document.getElementById("BatchClass");
	if (obj) encmeth=obj.value;
	var obj=document.getElementById("ArrivedDate");
	if (obj) ArrivedDate=obj.value;
	var obj=document.getElementById("AuditDate");
	if (obj) AuditDate=obj.value;
	DocID=session['LOGON.USERID'];
	var obj=document.getElementById("MainDoctor");
	if (obj&&obj.checked) MainDoctor="Y";
	var obj=document.getElementById("NoResultFlag");
	if (obj&&obj.checked) NoResultFlag="1";
	var ret=cspRunServerMethod(encmeth,ArrivedDate,AuditDate,DocID,MainDoctor,NoResultFlag);
	var obj=document.getElementById("BFind");
	if (obj) obj.click();
}