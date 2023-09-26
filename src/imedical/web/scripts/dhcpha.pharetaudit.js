var RetNo;
var UserCode;
var UserPass;

function BodyLoadHandler()
{
	var obj=document.getElementById("OK")
	if (obj) obj.onclick=Audit;
	
	var obj=document.getElementById("Cancel")
	if (obj) obj.onclick=exitwin;
	
	var obj=document.getElementById("")
	var obj=document.getElementById("")
	var obj=document.getElementById("")
	var obj=document.getElementById("")	
}

function Audit()
{
	var obj=document.getElementById("RetNo")
	if (obj) RetNo=obj.value;
	if (RetNo=="") return ;
	var obj=document.getElementById("UserCode")
	if (obj) UserCode=obj.value;
	var obj=document.getElementById("UserPass")
	if (obj) UserPass=obj.value;
	if ((UserCode=="")||(UserPass==""))	
	{
		alert(t['INPUT_USERANDPASS'])
		return ;
	}
	
	var exe;
	var obj=document.getElementById("mAuditPhaRet")
	if (obj) exe=obj.value;
	else exe=""
	 
	var ret=cspRunServerMethod(exe,RetNo,UserCode,UserPass)
	if (ret==-10)
	{
		alert(t['INVALID_USER'])
		return ;
	}
	if (ret==-30)
	{
		alert(t['AUDIT_DENIED']) ;
		return ;
	}
	if (ret==0)
	{
		alert(t['AUDIT_SUCCEED'])
		window.close()	
	}
	else
	{
		alert(t['AUDIT_FAILED'])
		return;
	}
}

function exitwin()
{window.close();
	}

document.body.onload=BodyLoadHandler;
