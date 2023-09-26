// DHCST.MBCPARASTATEADD
function BodyLoadHandler()
{
	var obj=document.getElementById("BOK");
	if (obj) obj.onclick=InsMS;
	var obj=document.getElementById("BCancel");
	if (obj) obj.onclick=Cancel;
	//var obj=document.getElementById("TMSSysFlag");
	//if (obj) obj.onclick=SysFlagClick;
	//var obj=document.getElementById("TMSFlag");
	//if (obj) obj.onclick=FlagClick;	

  	combo_MBCType=dhtmlXComboFromStr("CMBCType","");
	combo_MBCType.enableFilteringMode(true);
	
	var encmeth=document.getElementById("getinouttype").value;

	var DeptStr=cspRunServerMethod(encmeth)
	var Arr=DHCC_StrToArray(DeptStr);
	combo_MBCType.addOption(Arr);

}

function Cancel()
{
	window.close();
}
//系统流程必须激活
//function SysFlagClick()
//{
//	var sysflag=false;
//	var obj=document.getElementById("TMSSysFlag");
//	if (obj) sysflag=obj.checked;
//	if (sysflag==true){
//		var obj=document.getElementById("TMSFlag");
//		if (obj) obj.checked=true;
//	}
//}
//不激活就不能是系统流程
//function FlagClick()
//{
//	var flag=false;
//	var obj=document.getElementById("TMSFlag");
//	if (obj) flag=obj.checked;
//	if (flag==false){
//		var obj=document.getElementById("TMSSysFlag");
//		if (obj) obj.checked=false;
//	}
//}

function InsMS()
{
	
	var obj;
	var msnumber;
	var msname;
	var msflag;
	var ret;
	var msretflag;
	obj=document.getElementById("TMSNumber");
	if (obj) msnumber =obj.value;
	if (trim(msnumber)=="")	//合法性判断
	{
		alert(t['mNumberEmpty']);
		obj.focus();
		obj.select();
		return;
	}
	
	if (IsNumeric(msnumber)=="")
	{
		alert(t['mNumberIsNotNum']);
		obj.focus();
		obj.select();
		return;
	}
	obj=document.getElementById("TMSName");
	if (obj) msname =obj.value;
	if (trim(msname)=="")
	{
		alert(t['mNameEmpty']);
		obj.focus();
		obj.select();
		return;
	}
	
	obj=document.getElementById("TMSFlag");
	if (obj) msflag =obj.checked;
	if (msflag==true) msflag="Y";
	else msflag="N";
	
	//obj=document.getElementById("TMSSysFlag");
	//if (obj) mssysflag =obj.checked;
	//if (mssysflag==true) mssysflag="Y";
	//else mssysflag="N";
	
	//obj=document.getElementById("TMSRetFlag");
	//if (obj) msretflag =obj.checked;
	//if (msretflag==true) msretflag="Y";
	//else msretflag="N";
	//判断类型是否选择
	var mbctype= combo_MBCType.getSelectedValue()
	obj=document.getElementById("CMBCType");
	if (trim(obj.value)=="")	//合法性判断
	{	
	    alert(t['mTypeEmpty'])
	    obj.focus();
		obj.select();
		return;
		
	}
	///var msdispflag="N"
	if (mbctype=="1") {mbctype="I"}
	if (mbctype=="2") {mbctype="O"}
	//判断是否已经存在标识号或状态描述
	ret=cspRunExisTMS(msnumber,msname,mbctype);
	if (ret==1)
	{
		alert(t['mNumberExist']);
		obj=document.getElementById("TMSNumber");
		obj.focus();
		obj.select();
	    return;
	}
	if (ret==2)
	{
		alert(t['mNameExist']);
		obj=document.getElementById("TMSName");
		obj.focus();
		obj.select();
	    return;
	}

	//插入数据
	ret=cspRunInsMS(msnumber,msname,msflag,mbctype);
	if (ret=="-99995")
	{
		alert(t['mNameExist']);
		obj=document.getElementById("TMSName");
		obj.focus();
		obj.select();
	    return;
	}
	if (ret<0) 
	{
		alert(t['mInsMSErr']+ret);
	    return;
	}
	document.getElementById("TMSNumber").value="";
	document.getElementById("TMSName").value="";
	document.getElementById("TMSFlag").checked=false;
	obj=document.getElementById("CMBCType").value="";
	document.getElementById("TMSNumber").focus();
	opener.location.reload();
  	//window.close();
}
function cspRunInsMS(msnumber,msname,msflag,mstype)
{
	var obj=document.getElementById("mInsMs");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,msnumber,msname,msflag,mstype);
	return result;
}
function cspRunExisTMS(msnumber,msname,mbctype)
{
	var obj=document.getElementById("mExist");
	if (obj) {var encmeth=obj.value;}	else {var encmeth='';}
	var result=cspRunServerMethod(encmeth,msnumber,msname,mbctype);
	return result;
}
document.body.onload=BodyLoadHandler
