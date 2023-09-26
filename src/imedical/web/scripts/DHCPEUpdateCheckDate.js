document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
}
function BUpdate_click()
{
	var obj,NewDate="",encmeth="",PreIADM="",NewTime="";
	obj=document.getElementById("NewDate");
	if (obj) NewDate=obj.value;
	if (NewDate==""){
		alert("请输入新日期");
		return false;
	}
	obj=document.getElementById("NewTime");
	if (obj) NewTime=obj.value;
	
	
	obj=document.getElementById("OtherInfo");
	OtherInfo=obj.value;
	var Arr=OtherInfo.split("^");
	var GIType=Arr[1];
	if (GIType=="I")
	{
		var Level=Arr[0];
		//
		var obj=document.getElementById('IsCanPreClass');
		if (obj){
			var IsClass=obj.value;
			var LocID=session['LOGON.CTLOCID'];
			var flag=cspRunServerMethod(IsClass,NewDate,LocID,Level,"I",NewTime);
			var Arr=flag.split("^");
			if (Arr[0]=="0"){
				if (!confirm(Arr[1])) return false;
			}
		}
	}
	
	NewDate=NewDate+"^"+NewTime;
	
	obj=document.getElementById("PreIADM");
	if (obj) PreIADM=obj.value;
	obj=document.getElementById("UpdateClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,PreIADM,NewDate);
	if (ret=="0"){ 
	    alert("修改成功");
	    window.close();
	    window.parent.parent.opener.location.reload();
	    }
}
function SetPreDate(NewDateStr)
{
	var obj=document.getElementById("NewDate");
	if (obj) obj.value=NewDateStr;
}