// 文件名 DHCPEOPChargeLimit.js
/// 创建时间		2010.12
/// 创建人		yupeng
/// 主要功能		操作员打折限制


var CurrentSel=0;

function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	obj=document.getElementById("Clear");
	if (obj){ obj.onclick=Clear_click; }
	
	obj=document.getElementById("Query");
	if (obj){ obj.onclick=Query_click; }
	
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }

	
	Clear_click();
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

//验证是否为浮点数
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) { 
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}

function getOPName(value) {
	var aiList=value.split("^");
	if (""==value){ return false; }
	else{
		var obj;

		obj=document.getElementById("OPName");
		if (obj) { obj.value=aiList[0]; }


		obj=document.getElementById("UserId");
		if (obj) { obj.value=aiList[1]; }

	}

}

function Query_click(){
	var obj;
	var iUserId="";
	obj=document.getElementById("UserId");
	if (obj) iUserId=obj.value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEOPChargeLimit"
			+"&UserId="+iUserId
			;
	location.href=lnk;

}


function Update_click() {
	var iUser="";
	var iDFLimit="";  
	var obj=document.getElementById("UserId");
	if (obj){iUser=obj.value; } 

	var obj=document.getElementById("DFLimit");
	if (obj)
	{
		iDFLimit=obj.value; 
		if (IsFloat(iDFLimit)){}
		else 
		{
			alert("请输入数字!!!");
			websys_setfocus("iDFLimit");
			return false;
		}
	}

    var iOPFlag="N";
	var obj=document.getElementById("OPFlag");
	if (obj&&obj.checked){iOPFlag="Y"; } 

	var iASChargedFlag="N";
	var obj=document.getElementById("ASChargedFlag");
	if (obj&&obj.checked){iASChargedFlag="Y"; } 

	var iRoundingFeeMode="0";
    var obj=document.getElementById("RoundingFeeMode");
    if(obj){iRoundingFeeMode=obj.value} 


	var Instring=trim(iUser)	
				+"^"+trim(iDFLimit)
				+"^"+iOPFlag
				+"^"+iASChargedFlag
				+"^"+iRoundingFeeMode
				; 

	var Ins=document.getElementById('UpdateBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; }
	var flag=cspRunServerMethod(encmeth,Instring)
    if (flag==0)
	{location.reload();  }
	if (flag=="NoUser")
	{alert("没有选定操作员!");}
}

function Delete_click(){
	
	
	var obj=document.getElementById("UserId");
	if(obj){var UserId=obj.value;}
	if(UserId==""){
		alert("请选择待删除的记录");
		return false;
	}
	else{
		var flag=tkMakeServerCall("web.DHCPE.ChargeLimit","DeleteOPChargeLimit",UserId);
		if(flag=="0"){
			alert("删除成功");
			location.reload();
		}
		else{
			alert("删除失败")
		}
	}
	
	
}


function FromTableToItem(Dobj,Sobj,selectrow) {

	var SelRowObj;
	var obj;
	var LabelValue="";

	SelRowObj=document.getElementById(Sobj+'z'+selectrow);
	if (!(SelRowObj)) { return null; }
	LabelValue=SelRowObj.tagName.toUpperCase();
   	obj=document.getElementById(Dobj);
   	if (!(obj)) { return null; }
   	
   	if ("LABEL"==LabelValue) {		
		obj.value=trim(SelRowObj.innerText);
		return obj;
	}
	
	if ("INPUT"==LabelValue) {
		LabelValue=SelRowObj.type.toUpperCase();
		
		if ("CHECKBOX"==LabelValue) {
			obj.checked=SelRowObj.checked;
			return obj;
		}
		
		if ("HIDDEN"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}
		
		if ("TEXT"==LabelValue) {
			obj.value=trim(SelRowObj.value);
			return obj;
		}

		obj.value=SelRowObj.type+trim(SelRowObj.value);
		return obj;
	}

}

function ShowCurRecord(CurRecord) {
	
	var selectrow=CurRecord;

	FromTableToItem("UserId","TUserId",selectrow);  

	FromTableToItem("OPName","TName",selectrow);
	
	var obj=document.getElementById("TDFLimitz"+selectrow);
	if(obj){var IDFLimit=obj.innerText;}
	var obj=document.getElementById("DFLimit")
	if (obj) obj.value=IDFLimit.split("%")[0];

	var SelRowObj=document.getElementById("TOPFlagz"+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("OPFlag");
		obj.checked=SelRowObj.checked;
	} 
	
	var SelRowObj=document.getElementById("TASChargedFlagz"+selectrow);
	if (SelRowObj) {
		obj=document.getElementById("ASChargedFlag");
		obj.checked=SelRowObj.checked;
	} 

}

function Clear_click() {
	var obj;
	
	obj=document.getElementById("UserId");
	if(obj){obj.value="";}

	obj=document.getElementById("OPName");
	if(obj){obj.value="";}

	obj=document.getElementById("OPFlag");
	if(obj){obj.checked=false;}
	
	obj=document.getElementById("ASChargedFlag");
	if(obj){obj.checked=false;}
}


function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	if (selectrow==CurrentSel)
	{	    
	    Clear_click();
	    CurrentSel=0;
	    return;
	}

	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;
