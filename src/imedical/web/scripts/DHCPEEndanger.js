/// DHCPEEndanger.js
/// 危害因素检查周期维护
var CurrentSel=0;
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_click;
	
	
}


function BUpdate_click()
{
    var ID=GetValue("ID",1);
	var Code=GetValue("Code",1);
	var Desc=GetValue("Desc",1);
	 if (""==Code) {
		obj=document.getElementById("Code")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("代码不能为空");
		return false;
	 }
	 
      if (""==Desc) {
		obj=document.getElementById("Desc")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("描述不能为空");
		return false;
	 }

	var Active="N";
	var obj=GetObj("Active");
	if (obj&&obj.checked) Active="Y";
	var ExpInfo=GetValue("ExpInfo",1);
	var Remark=GetValue("Remark",1);
	var EDTypeDR=GetValue("EDEDTypeDR",1);
	var encmeth=GetValue("UpdateMethod",1);
	var Str=Code+"^"+Desc+"^"+Active+"^"+EDTypeDR+"^"+ExpInfo+"^"+Remark;
	var rtn=cspRunServerMethod(encmeth,ID,Str);
	if (rtn.split("^")[0]=="-1"){
		//alert("更新失败"+rtn.split("^")[1])
		if(rtn.split("^")[1].indexOf("Code")>0){
			alert("代码不唯一");
		}
		if(rtn.split("^")[1].indexOf("Desc")>0){
			alert("描述不唯一")
		}	
	}else{
		window.location.reload();
	}
}
function BClear_click()
{
	SetValue("ID","",1);
	SetValue("Code","",1);
	SetValue("Desc","",1);
	SetValue("ExpInfo","",1);
	SetValue("Remark","",1);
	var obj=GetObj("Active");
	if (obj) obj.checked=false;
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

function ShowCurRecord(selectrow) {
	var ID=GetValue('TID'+'z'+selectrow,1);
	SetValue("ID",ID,1);
	var encmeth=GetValue("GetOneMethod",1);
	var OneStr=cspRunServerMethod(encmeth,ID);
	//Code_"^"_Desc_"^"_Active_"^"_ExpInfo_"^"_Remark
	var StrArr=OneStr.split("^");
	SetValue("Code",StrArr[0],1);
	SetValue("Desc",StrArr[1],1);
	SetValue("ExpInfo",StrArr[3],1);
	SetValue("Remark",StrArr[4],1);
	var obj=GetObj("Active");
	if (obj){
		if (StrArr[2]=="Y"){
			obj.checked=true;
		}else{
			obj.checked=false;
		}
	}
	
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEEDIllness&Parref="+ID;
	parent.frames["DHCPEEDIllness"].location.href=lnk; 
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEEDCheckCycle&Parref="+ID;
	parent.frames["DHCPEEDCheckCycle"].location.href=lnk; 
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEEDItem&Parref="+ID;
	parent.frames["DHCPEEDItem"].location.href=lnk;
}
			
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var objtbl=GetObj('tDHCPEEndanger');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}
document.body.onload = BodyLoadHandler;