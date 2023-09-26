/// DHCPEOMEIllness.js
/// Ä¿±ê¼²²¡
var CurrentSel=0;
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
	obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_click;
	obj=document.getElementById("ConclusionDR");
	if (obj) obj.onchange=Conclusion_change;
	
}
function BUpdate_click()
{
	var Code=GetValue("Code",1);
	var Desc=GetValue("Desc",1);
	var Conclusion=GetValue("ConclusionID",1);
	//var Conclusion=GetValue("ConclusionDR",1);
	var ExpInfo=GetValue("ExpInfo",1);
	var Remark=GetValue("Remark",1);
	var ID=GetValue("ID",1);
	if (""==Code) {

		obj=document.getElementById("Code")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert(t["01"]);
		return false;
	}
	if (""==Desc) {

		obj=document.getElementById("Desc")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert(t["02"]);
		return false;
	}
	if (""==Conclusion) {

		obj=document.getElementById("ConclusionDR")
		
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert(t["03"]);
		return false;
	}
	var encmeth=GetValue("UpdateMethod",1);
	var Active="N";
	var obj=document.getElementById("Active");
	if (obj&&obj.checked) Active="Y";
	var Str=Code+"^"+Desc+"^"+Active+"^"+Conclusion+"^"+ExpInfo+"^"+Remark;
	var rtn=cspRunServerMethod(encmeth,ID,Str);
    var Arr=rtn.split("^");
	if (Arr[0]>0){
		location.reload();
	}else{
		alert(Arr[1]);
		
	} 

	/*if (rtn.split("^")[0]=="-1"){
		alert("¸üÐÂÊ§°Ü"+rtn.split("^")[1])
	}else{
		window.location.reload();
	}*/

}
function BClear_click()
{
	SetValue("ID","",1);
	SetValue("Code","",1);
	SetValue("Desc","",1);
	SetValue("ConclusionDR","",1);
	SetValue("ExpInfo","",1);
	SetValue("Remark","",1);
	var obj=document.getElementById("Active");
	if (obj) obj.checked=false;
}
function BDelete_click()
{
	var ID=GetValue("ID",1);
	if (ID=="")
	{
		alert("ÇëÑ¡Ôñ´ýÉ¾³ýµÄ¼ÇÂ¼");
		return false;
	}
	var encmeth=GetValue("DeleteMethod",1);
	var rtn=cspRunServerMethod(encmeth,ID);
	if (rtn.split("^")[0]=="-1"){
		alert("É¾³ýÊ§°Ü"+rtn.split("^")[1])
	}else{
		window.location.reload();
	}
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
function ConclusionAfter(value)
{
	if (value=="") return flase;
	var StrArr=value.split("^");
	SetValue("ConclusionID",StrArr[0],1);
	SetValue("ConclusionDR",StrArr[2],1);
	//SetValue("ConclusionDR",StrArr[0],1);
}
function Conclusion_change()
{
	SetValue("ConclusionID","",1);
}

function ShowCurRecord(selectrow) {
	var ID=GetValue('TID'+'z'+selectrow,1);
	SetValue("ID",ID,1);
	var encmeth=GetValue("GetOneMethod",1);
	var OneStr=cspRunServerMethod(encmeth,ID);
	var StrArr=OneStr.split("^");
	SetValue("Code",StrArr[0],1);
	SetValue("Desc",StrArr[1],1);
	SetValue("ConclusionDR",StrArr[3],1);
	SetValue("ExpInfo",StrArr[4],1);
	SetValue("Remark",StrArr[5],1);
	SetValue("ConclusionID",StrArr[6],1);
	var Active=StrArr[2];
	var obj=document.getElementById("Active");
	if (obj){
		if (Active=="Y"){
			obj.checked=true;
		}else{
			obj.checked=false;
		}
	}
	
}
			
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var objtbl=GetObj('tDHCPEOMEIllness');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;