///DHCPERoomPlace.js
var CurrentSel=0;
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_click;
	obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_click;
}
function BSave_click()
{
	var Code=GetValue("Code",1);
	if(Code==""){
		alert("代码不能为空");
		websys_setfocus("Code");
		return false;
	}

	var Desc=GetValue("Desc",1);
	if(Desc==""){
		alert("描述不能为空");
		websys_setfocus("Desc");
		return false;
	}

	var PEType=GetValue("VIPLevel",1);
	var GIType=GetValue("GIType",1);
	var ID=GetValue("ID",1);
	var encmeth=GetValue("SaveClass",1);
	var Str=Code+"^"+Desc+"^"+PEType+"^"+GIType;
	var obj=GetObj("NoPrintBlood");
	var NoPrintBlood=0;
	if (obj&&obj.checked) NoPrintBlood=1;
	var ExpStr=NoPrintBlood;
	var rtn=cspRunServerMethod(encmeth,ID,Str,ExpStr);
	if (rtn.split("^")[0]=="-1"){
		alert("更新失败"+rtn.split("^")[1])
	}else{
		parent.location.reload();
	}
}
function BClear_click()
{
	SetValue("ID","",1);
	SetValue("Code","",1);
	SetValue("Desc","",1);
	SetValue("Sort","",1);
	SetValue("VIPLevel","",1);
	var obj=GetObj("NoPrintBlood");
	if (obj) obj.checked=false;
	var obj=document.getElementById("AreaFlag");
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
//以便本页面的子页面有正确的传入参数
function ShowCurRecord(selectrow) {
	var ID=GetValue('TID'+'z'+selectrow,1);
	SetValue("ID",ID,1);
	var encmeth=GetValue("GetOneMethod",1);
	var OneStr=cspRunServerMethod(encmeth,ID);
	var StrArr=OneStr.split("^");
	SetValue("Code",StrArr[0],1);
	SetValue("Desc",StrArr[1],1);
	SetValue("GIType",StrArr[3],1);
	SetValue("VIPLevel",StrArr[2],1);
	var obj=GetObj("NoPrintBlood");
	if (obj) {
		if (1==StrArr[5]){
			obj.checked=true;
		}else{
			obj.checked=false;
		}
	}
}
			
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var objtbl=GetObj('tDHCPERoomPlace');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	
	if (selectrow==CurrentSel)
	{ 
	    BClear_click();
	    CurrentSel=0;
	    return;
	} 

	    
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;