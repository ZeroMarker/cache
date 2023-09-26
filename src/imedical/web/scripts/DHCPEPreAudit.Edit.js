function BodyLoadHandler(){
	var cobj=document.getElementById("privilegeMode");
	if (cobj) {
		cobj.multiple=false;
		cobj.size=1
		var NewIndex=cobj.length;
		cobj.options[0] = new Option("无优惠","NP");
		//cobj.options[1] = new Option("总价优惠","TP");
		cobj.options[1] = new Option("折扣","OR");
		cobj.options[2] = new Option("项目优惠","OP");
		cobj.options[3] = new Option("销售金额","OS");
	}
	
	var cobj=document.getElementById("Type");
	if (cobj) {
		cobj.multiple=false;
		cobj.size=1
		//var NewIndex=cobj.length;
		cobj.options[0] = new Option("预约","PRE");
		cobj.options[1] = new Option("加项","ADD");
	}
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_clicked;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_clicked;
	SetButtonDisabl("","","");
	var obj=document.getElementById("privilegeMode");
	if (obj) obj.onchange=PrivilegeMode_change;
	var obj=document.getElementById("BAsCharged");
	if (obj) obj.onclick=BAsCharged_click;
	var obj=document.getElementById("BUnAsCharged");
	if (obj) obj.onclick=BUnAsCharged_click;
	
	
	//fillData("2")
}
function BAsCharged_click()
{
	var userId="",RowID="",obj,encmeth="",ChargedType="",ChargedRemark="";
	userId=session['LOGON.USERID'];
	obj=document.getElementById("RowID");
	if (obj){RowID=obj.value;}
	if (RowID=="") return false;
	obj=document.getElementById("AsChargedClass");
	if (obj) encmeth=obj.value;
	obj=document.getElementById("ChargedType");
	if (obj) ChargedType=obj.value;
	obj=document.getElementById("ChargedRemark");
	if (obj) ChargedRemark=obj.value;
	RowID=RowID+"^"+ChargedType+"^"+ChargedRemark;
	var ret=cspRunServerMethod(encmeth,RowID,userId);
	var Arr=ret.split("^");
	if (Arr[0]=="-1"){
		alert(Arr[1]);
		return false;
	}
	alert("更新成功")
}
function BUnAsCharged_click()
{
	var userId="",RowID="",obj,encmeth="";
	userId=session['LOGON.USERID'];
	obj=document.getElementById("RowID");
	if (obj){RowID=obj.value;}
	if (RowID=="") return false;
	obj=document.getElementById("UnAsChargedClass");
	if (obj) encmeth=obj.value;
	var ret=cspRunServerMethod(encmeth,RowID);
	var Arr=ret.split("^");
	if (Arr[0]=="-1"){
		alert(Arr[1]);
		return false;
	}
	alert("更新成功")
}
function PrivilegeMode_change()
{
	var PrivilegeMode="";
	var obj=document.getElementById("privilegeMode");
	if (obj) PrivilegeMode=obj.value;
	var obj=document.getElementById("Rebate");
	//if (obj){obj.disabled=true;}
	if(obj) {websys_disable(obj);}
	
	var obj=document.getElementById("SaleAmount");
	if(obj) websys_disable(obj);
	if(PrivilegeMode=="OS")
	{
		var obj=document.getElementById("SaleAmount");
		if (obj) websys_enable(obj,emptyFun);
	}
	else
	{
		var obj=document.getElementById("SaleAmount");
		if (obj){
			websys_disable(obj);
			obj.value="";
		}
	}
	if (PrivilegeMode=="OR")
	{
		var obj=document.getElementById("Rebate");
		//if (obj) obj.disabled=false;
		if (obj) websys_enable(obj,emptyFun);
	}
	else
	{
		var obj=document.getElementById("Rebate");
		if (obj){
			//obj.disabled=true;
			websys_disable(obj);
			obj.value="";
		}
	}
	var obj=document.getElementById("FactAmount");
	//if (obj){obj.disabled=true;}
	if(obj) {websys_disable(obj);}
	if (PrivilegeMode=="TP")
	{
		//if (obj) obj.disabled=false;
		if (obj) websys_enable(obj,emptyFun);
	}
	else
	{
		if (obj){//obj.disabled=true;
			websys_disable(obj);
			obj.value="";
		}
	}
}



function BUpdate_clicked()
{
	var InfoStr="";
	var FactAmount,Rebate,PrivilegeMode
	InfoStr=GetValue("ContractNo");
	Rebate=GetValue("Rebate");
    
    PrivilegeMode=GetValue("privilegeMode");
    var AccountAmount=GetValue("AccountAmount");
	var yikoujia=GetValue("SaleAmount");
	  if (PrivilegeMode=="OS"){
		
		if (yikoujia=="") {
			
			alert("销售金额不能为空")
			return false;
		}
        
		var Rebate=(yikoujia/AccountAmount)*100
		Rebate= Rebate.toFixed(4)
	
		}
		else{
			var obj=document.getElementById("SaleAmount");
			if(obj){obj.value="";}
			}

	InfoStr=InfoStr+"^"+Rebate;
	InfoStr=InfoStr+"^"+GetValue("SaleAmount");
	FactAmount=GetValue("FactAmount");
	InfoStr=InfoStr+"^"+FactAmount;
	InfoStr=InfoStr+"^"+GetValue("Remark");
	//PrivilegeMode=GetValue("privilegeMode");
	InfoStr=InfoStr+"^"+PrivilegeMode;
	if (PrivilegeMode=="OR")
	{
		if (Rebate=="")
		{
			alert(t["02"]);
			websys_setfocus('FactAmount');
			return;
		}
	var userId=session['LOGON.USERID'];
	var encmethobj=document.getElementById("DFLimitBox");
	if (encmethobj) var encmeth=encmethobj.value;	
	var ReturnStr=cspRunServerMethod(encmeth,userId);
	var DFLimit=ReturnStr;
	if (DFLimit==0){
		alert("没有打折权限");
	     return;}
      if(+DFLimit>+Rebate)
	{alert("权限不足,您的折扣权限为:"+DFLimit+"%");
	return;}
	}
	if (PrivilegeMode=="TP")
	{
		if (FactAmount=="")
		{
			alert(t["03"]);
			websys_setfocus('FactAmount');
			return;
		}
	}
	AuditUpdate("Update",InfoStr);
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
function BAudit_clicked()
{
	var Type="CancelAudited";
	var obj=document.getElementById("BAudit");
	if (obj.innerHTML=="审核") {Type="Audited"}
	AuditUpdate(Type,"");
}
function AuditUpdate(Type,DataStr)
{
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false; }
	var obj=document.getElementById("upd");
	if (obj){var encmeth=obj.value;}
	else{return;}
	var RowID="";
	var obj=document.getElementById("RowID");
	if (obj){RowID=obj.value;}
	if (RowID=="") return;
	var Flag=cspRunServerMethod(encmeth,Type,RowID,DataStr);
	if (Flag!=0){
		alert(t["01"]+Flag);
		return;}
	var myFrame=parent.frames['PreAudit.List'];
	myFrame.location.reload();
	fillData(RowID);
	
}
function fillData(RowID)
{
	var obj;
	var Data,encmeth;
	if (RowID!="")
	{
		obj=document.getElementById("fillData");
		if (obj) encmeth=obj.value;
		Data=cspRunServerMethod(encmeth,RowID);
		Data=RowID+"^"+Data;
	}
	else
	{
		Data="^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^";
	}
	fill(Data);
}
///根据表结构生成一个数组
function fill(Data)
{
	var Data=Data.split("^");
	var Name="RowID^ADMType^CRMADM^GIADM^ContractNo^Rebate^AccountAmount^DiscountedAmount^SaleAmount^FactAmount^AuditedStatus"
	Name=Name+"^AuditUser_DR^AuditDate^AuditTime^ChargedStatus^CancelUser_DR^CancelDate^CancelTime^Remark^privilegeMode^Type^^^^ContractNo"
	Name=Name.split("^");
	var i,j;
	j=Name.length;
	for (i=0;i<j;i++)
	{
		SetValue(Name[i],Data[i]);
	}
	//PrivilegeMode_change();
	SetButtonDisabl(Data[0],Data[10],Data[14]);
}
function SetButtonDisabl(RowID,Audit,Charged)
{
	var Uobj,Aobj,obj;
	
	obj=document.getElementById("SaleAmount");
	if(obj) websys_disable(obj);
	
	obj=document.getElementById("Rebate");
	if(obj) websys_disable(obj);
	
	Uobj=document.getElementById("BUpdate");
	Aobj=document.getElementById("BAudit");
	Aobj.innerHTML="审核"; //"<img SRC='../images/websys/update.gif' BORDER='0'>预约(<u>U</u>)";
	
	if (RowID=="")
	{
		//if (Uobj) Uobj.disabled=true;
		//if (Aobj) Aobj.disabled=true;
		if (Uobj) websys_disable(Uobj);
		if (Aobj) websys_disable(Aobj);
		return;
	}
	else
	{
		if (Charged=="CHARGED")
		{
			//if (Uobj) Uobj.disabled=true;
			//if (Aobj) Aobj.disabled=true;
			if (Uobj) websys_disable(Uobj);
			if (Aobj) websys_disable(Aobj);
			return;
		}
		if (Audit=="Audited")
		{
			Aobj.innerHTML="取消审核"
			//if (Uobj) Uobj.disabled=true;
			//if (Aobj) Aobj.disabled=false;
			if (Uobj) websys_disable(Uobj);
			if (Aobj) websys_enable(Aobj,BAudit_clicked);
			return;
		}
		//if (Uobj) Uobj.disabled=false;
		//if (Aobj) Aobj.disabled=false;
		if (Uobj) websys_enable(Uobj,BUpdate_clicked);
		if (Aobj) websys_enable(Aobj,BAudit_clicked);
		return;
	}
}
function SetValue(Name,Value)
{
	var obj;
	obj=document.getElementById(Name);
	if (obj) obj.value=Value;
}
function GetValue(Name)
{
	var value="";
	obj=document.getElementById(Name);
	if (obj) value=obj.value;
	return trim(value);
}
document.body.onload = BodyLoadHandler;