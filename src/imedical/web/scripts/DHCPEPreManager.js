
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BReplace");
	if (obj) obj.onclick=BReplace_click;
	obj=document.getElementById("BCreate");
	if (obj) obj.onclick=BCreate_click;
}
function BUpdate_click()
{
	var eSrc=window.event.srcElement;
	var objtbl=GetObj('tDHCPEPreManager');
	if (objtbl) { var rows=objtbl.rows.length; }
	var encmeth=GetValue("UpdateMethod",1);
	for (var i=1;i<rows;i++)
	{
		var Type=GetValue("TTypez"+i,1);
		var ID=GetValue("TIDz"+i,1);
		var Num=GetValue("TNumz"+i,1);
		var GADMDesc = GetValue("TGADMDescz"+i,2);
		ID=ID+"^"+Type;
		var ret=cspRunServerMethod(encmeth,ID,Num,GADMDesc);
	}
	window.location.reload();
	
}
function BCreate_click()
{
	var obj,OldDate="",NewDate="",encmeth="",UserID="";
	OldDate=GetValue("DateStr",1);
	NewDate=GetValue("NewDate",1);
	if (NewDate==""){
		$.messager.alert("提示","替换日期不能为空","info");
		return false;
	}
	encmeth=GetValue("CreateClass",1);
	UserID=session['LOGON.USERID'];
	ret=cspRunServerMethod(encmeth,OldDate,NewDate,UserID);
	if(ret=="0"){
		$.messager.alert("提示","复制成功","success");
	}
	window.location.reload();
}
function BReplace_click()
{
	var obj,OldDate="",NewDate="",encmeth="";
	OldDate=GetValue("DateStr",1);
	NewDate=GetValue("NewDate",1);
	if (NewDate==""){
		$.messager.alert("提示","替换日期不能为空","info");
		return false;
	}
	encmeth=GetValue("ReplaceClass",1);
	ret=cspRunServerMethod(encmeth,OldDate,NewDate);
	if(ret=="0"){
		$.messager.alert("提示","替换成功","success");
	}
	window.location.reload();
}


function GetObj(Name)
{
	var obj=document.getElementById(Name);
	return obj;	
}
function GetValue(Name,Type)
{
	var Value="";
	var obj=GetObj(Name);
	if (obj){
		if (Type=="2"){
			Value=obj.innerText;
		}else{
			Value=obj.value;
		}
	}
	return Value;
}
function SetValue(Name,Value,Type)
{
	var obj=GetObj(Name);
	if (obj){
		if (Type=="2"){
			obj.innerText=Value;
		}else{
			obj.value=Value;
		}
	}
}

document.body.onload = BodyLoadHandler;