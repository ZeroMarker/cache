// DHCST.PIVA.PARASTATEADD
function BodyLoadHandler()
{
	var obj=document.getElementById("BOK");
	if (obj) obj.onclick=InsPS;
	var obj=document.getElementById("BCancel");
	if (obj) obj.onclick=Cancel;
	var obj=document.getElementById("TPSSysFlag");
	if (obj) obj.onclick=SysFlagClick;
	var obj=document.getElementById("TPSFlag");
	if (obj) obj.onclick=FlagClick;	
}

function Cancel()
{
	window.close();
}
//系统流程必须激活
function SysFlagClick()
{
	var sysflag=false;
	var obj=document.getElementById("TPSSysFlag");
	if (obj) sysflag=obj.checked;
	if (sysflag==true){
		var obj=document.getElementById("TPSFlag");
		if (obj) obj.checked=true;
	}
}
//不激活就不能是系统流程
function FlagClick()
{
	var flag=false;
	var obj=document.getElementById("TPSFlag");
	if (obj) flag=obj.checked;
	if (flag==false){
		var obj=document.getElementById("TPSSysFlag");
		if (obj) obj.checked=false;
	}
}

function InsPS()
{
	var obj;
	var psnumber;
	var psname;
	var psflag;
	var ret;
	var psretflag;
	obj=document.getElementById("TPSNumber");
	if (obj) psnumber =obj.value;
	if (trim(psnumber)=="")	//合法性判断
	{
		alert(t['mNumberEmpty']);
		obj.focus();
		obj.select();
		return;
	}
	
	if (IsNumeric(psnumber)=="")
	{
		alert(t['mNumberIsNotNum']);
		obj.focus();
		obj.select();
		return;
	}
	
	obj=document.getElementById("TPSName");
	if (obj) psname =obj.value;
	if (trim(psname)=="")
	{
		alert(t['mNameEmpty']);
		obj.focus();
		obj.select();
		return;
	}
	
	obj=document.getElementById("TPSFlag");
	if (obj) psflag =obj.checked;
	if (psflag==true) psflag="Y";
	else psflag="N";
	
	obj=document.getElementById("TPSSysFlag");
	if (obj) pssysflag =obj.checked;
	if (pssysflag==true) pssysflag="Y";
	else pssysflag="N";
	
	obj=document.getElementById("TPSRetFlag");
	if (obj) psretflag =obj.checked;
	if (psretflag==true) psretflag="Y";
	else psretflag="N";
	
	//判断是否已经存在标识号或状态描述
	ret=cspRunExistPS(psnumber,psname);
	if (ret==1)
	{
		alert(t['mNumberExist']);
		obj=document.getElementById("TPSNumber");
		obj.focus();
		obj.select();
	    return;
	}
	if (ret==2)
	{
		alert(t['mNameExist']);
		obj=document.getElementById("TPSName");
		obj.focus();
		obj.select();
	    return;
	}
	
	var psdispflag="N"
	
	//插入数据
	ret=cspRunInsPS(psnumber,psname,psflag,pssysflag,psretflag,psdispflag);
	if (ret<0) 
	{
		alert(t['mInsPSErr']+ret);
	    return;
	}
	document.getElementById("TPSNumber").value="";
	document.getElementById("TPSName").value="";
	document.getElementById("TPSFlag").checked=false;
	document.getElementById("TPSSysFlag").checked=false;
	document.getElementById("TPSRetFlag").checked=false;
	document.getElementById("TPSNumber").focus();
	opener.location.reload();
  	//window.close();
}
function cspRunInsPS(psnumber,psname,psflag,pssysflag,psretflag)
{
	var obj=document.getElementById("mInsPs");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,psnumber,psname,psflag,pssysflag,psretflag);
	return result;
}
function cspRunExistPS(psnumber,psname)
{
	var obj=document.getElementById("mExist");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,psnumber,psname);
	return result;
}
document.body.onload=BodyLoadHandler
