

//名称	DHCPEPreAudit.Edit.js
//功能   费用
//组件	DHCPEPreAudit.Edit  	
//创建	2018.09.24
//创建人  xy
document.body.style.padding="10px 10px 0px 10px"
function BodyLoadHandler(){
	
	
	//更新
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_clicked;
	
	//审核
	$("#BAudit").click(function() {
			
			BAudit_clicked();	
			
        });
	SetButtonDisabl("","","");
	
	//优惠形式
	$("#privilegeMode").combobox({
       onSelect:function(){
			PrivilegeMode_change();
	}
	});

	
	//定额卡支付 
	var obj=document.getElementById("BAsCharged");
	if (obj) obj.onclick=BAsCharged_click;
	
	//撤销定额卡
	var obj=document.getElementById("BUnAsCharged");
	if (obj) obj.onclick=BUnAsCharged_click;
	
}

function BAsCharged_click()
{
	var userId="",RowID="",obj,encmeth="",ChargedType="",ChargedRemark="";
	userId=session['LOGON.USERID'];
	obj=document.getElementById("RowID");
	if (obj){RowID=obj.value;}
	if (RowID=="") {
		top.$.messager.alert("提示","请先选择记录","info");
		return false;
	}
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
		top.$.messager.alert("提示",Arr[1],"info");
		return false;
	}else{
		top.$.messager.alert("提示","更新成功","success");
	}
	
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
		top.$.messager.alert("提示",Arr[1],"info");
		return false;
	}else{
		top.$.messager.alert("提示","更新成功","success");
	}
}
function PrivilegeMode_change()
{

	var PrivilegeMode="";
	var PrivilegeMode=getValueById("privilegeMode")
	
	var obj=document.getElementById("Rebate");
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
		if (obj) websys_enable(obj,emptyFun);
	}
	else
	{
		var obj=document.getElementById("Rebate");
		if (obj){
			websys_disable(obj);
			obj.value="";
		}
	}
	var obj=document.getElementById("FactAmount");
	if(obj) {websys_disable(obj);}
	if (PrivilegeMode=="TP")
	{
		if (obj) websys_enable(obj,emptyFun);
	}
	else
	{
		if (obj){
			websys_disable(obj);
			obj.value="";
		}
	}
}



function BUpdate_clicked()
{
	var InfoStr="";
	var FactAmount,Rebate,PrivilegeMode
	InfoStr=getValueById("ContractNo");
	Rebate=getValueById("Rebate");
    
    PrivilegeMode=getValueById("privilegeMode");
   // alert(PrivilegeMode+"^"+Rebate)
    
    var AccountAmount=getValueById("AccountAmount");
	var yikoujia=getValueById("SaleAmount");
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
	InfoStr=InfoStr+"^"+getValueById("SaleAmount");
	FactAmount=getValueById("FactAmount");
	InfoStr=InfoStr+"^"+FactAmount;
	InfoStr=InfoStr+"^"+getValueById("Remark");
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
	if(trim($("#BAudit").text())=="审核"){
		
		Type="Audited";
		}
	///if (obj.innerHTML.indexOf("审核")>-1) {Type="Audited"}
	
	AuditUpdate(Type,"");
}
function AuditUpdate(Type,DataStr)
{
	var eSrc=window.event.srcElement;
	if (eSrc.disabled) { return false; }
	//s val=##Class(%CSP.Page).Encrypt($lb("web.DHCPE.PreAudit.UpdatePreAudit"))
	var obj=document.getElementById("upd");
	if (obj){var encmeth=obj.value;}
	else{return;}
	var RowID="";
	var RowID=getValueById("RowID");
	if (RowID=="") {
		top.$.messager.alert("提示","请先选择记录","info");
		return;
		}
	var Flag=cspRunServerMethod(encmeth,Type,RowID,DataStr);
	if (Flag!=0){
		//$.msager.alert("提示",t["01"]+Flag);
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
		 //alert(Name[i]+"^"+Data[i])
		  setValueById(Name[i],Data[i]);
		//SetValue(Name[i],Data[i]);
	}

 
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
   if(Aobj){SetCElement("BAudit","审核");}
	if (RowID=="")
	{
	    if (Uobj) DisableBElement("BUpdate",true);
	    if (Aobj) DisableBElement("BAudit",true);
		//if (Aobj) websys_disable(Aobj);
		return;
	}
	else
	{
		
		if (Charged=="CHARGED")
		{
			if (Uobj) DisableBElement("BUpdate",true);
			if (Aobj) DisableBElement("BAudit",true);
			return;
		}
		
		if (Audit=="Audited")
		{
			SetCElement("BAudit","取消审核");
			$("#BUpdate").css({"width":"115px"});
			if (Uobj) DisableBElement("BUpdate",true);
			if (Aobj) DisableBElement("BAudit",false);
			return;
		}
		$("#BUpdate").css({"width":"88px"});
 		if (Uobj) DisableBElement("BUpdate",false);
		if (Aobj) DisableBElement("BAudit",false);
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