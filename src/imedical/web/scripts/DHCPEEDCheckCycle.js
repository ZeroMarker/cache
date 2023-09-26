///DHCPEEDCheckCycle.js
///Σ�����ؼ������ά��

var CurrentSel=0;
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
	obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_click;
}
function BUpdate_click()
{
	var Code=GetValue("Code",1);
	var Desc=GetValue("Desc",1);
	
	if (""==Code) {
		obj=document.getElementById("Code")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("���벻��Ϊ��");
		return false;
	}
	
	if (""==Desc) {
		obj=document.getElementById("Desc")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("��������Ϊ��");
		return false;
	}
	
	var OMETypeDR=GetValue("OMETypeDR",1);
	var OMETypeID=GetValue("OMETypeID",1);
	//var OMETypeDR=GetValue("OMETypeID",1);
	var ExpInfo=GetValue("ExpInfo",1);
	var Remark=GetValue("Remark",1);
	var ID=GetValue("ID",1);
	var Parref=GetValue("Parref",1);
	var encmeth=GetValue("SaveClass",1);
	var Active="N";
	var obj=document.getElementById("Active");
	if (obj&&obj.checked) Active="Y";
	var Str=Parref+"^"+Code+"^"+Desc+"^"+OMETypeID+"^"+Active+"^"+ExpInfo+"^"+Remark;
	var rtn=cspRunServerMethod(encmeth,ID,Str);
	if (rtn.split("^")[0]=="-1"){
		alert("����ʧ��"+rtn.split("^")[1])
	}else{
		window.location.reload();
	}
}
function BClear_click()
{
	SetValue("ID","",1);
	SetValue("Code","",1);
	SetValue("Desc","",1);
	SetValue("OMETypeDR","",1);
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
		alert("����ѡ��Ҫɾ���ļ�¼");
		return false;
	}
	var encmeth=GetValue("DeleteClass",1);
	var rtn=cspRunServerMethod(encmeth,ID);
	if (rtn.split("^")[0]=="-1"){
		alert("ɾ��ʧ��"+rtn.split("^")[1])
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
//以便本页面的子页面有正确的传入参�?
function ShowCurRecord(selectrow) {
	var ID=GetValue('TID'+'z'+selectrow,1);
	SetValue("ID",ID,1);
	var encmeth=GetValue("GetOneMethod",1);
	var OneStr=cspRunServerMethod(encmeth,ID);
	var StrArr=OneStr.split("^");
	SetValue("Code",StrArr[0],1);
	SetValue("Desc",StrArr[1],1);
	SetValue("OMETypeDR",StrArr[2],1);
	SetValue("OMETypeID",StrArr[6],1);
	SetValue("ExpInfo",StrArr[4],1);
	SetValue("Remark",StrArr[5],1);
	var Active=StrArr[3];
	var obj=document.getElementById("Active");
	if (obj){
		if (Active=="Y"){
			obj.checked=true;
		}else{
			obj.checked=false;
		}
	}
}
function OMETypeAfter(value)
{
	if (value=="") return flase;
	var StrArr=value.split("^");
	SetValue("OMETypeID",StrArr[0],1);
	SetValue("OMETypeDR",StrArr[2],1);
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