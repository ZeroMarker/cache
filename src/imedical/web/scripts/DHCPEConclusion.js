/// DHCPEConclusion.js
/// 体检人员分类
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
	var PEType=GetValue("VIPLevel",1);
	if (""==Code) {
		obj=document.getElementById("Code")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("编码不能为空");
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
	
		if (""==PEType) {
		obj=document.getElementById("VIPLevel")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("VIP等级不能为空");
		return false;
	}

	
	var ExpInfo=GetValue("ExpInfo",1);
	var Remark=GetValue("Remark",1);
	var Severity=GetValue("Severity",1);
	var re = /^[0-9]+[0-9]*]*$/;
	if (!re.test(Severity))
	 {
		 alert("请输入相应数字");
		return false;
	}

	var ID=GetValue("RowId",1);
	var encmeth=GetValue("UpdateMethod",1);
	var Active="N";
	var obj=document.getElementById("Active");
	if (obj&&obj.checked) Active="Y";
	var Str=Code+"^"+Desc+"^"+Active+"^"+PEType+"^"+ExpInfo+"^"+Severity+"^"+Remark;
	var rtn=cspRunServerMethod(encmeth,ID,Str);
	var Arr=rtn.split("^");
	if (Arr[0]>0){
		location.reload();
	}else{
		alert(Arr[1]);	
	} 

	/*if (rtn.split("^")[0]=="-1"){
		alert("更新失败"+rtn.split("^")[1])
	}else{
		window.location.reload();
	}*/
}
function BClear_click()
{
    SetValue("RowId","",1);
	SetValue("Code","",1);
	SetValue("Desc","",1);
	SetValue("VIPLevel","",1);
	SetValue("ExpInfo","",1);
	SetValue("Severity","",1);
	SetValue("Remark","",1);
	var obj=document.getElementById("Active");
	if (obj) obj.checked=false;
}
function BDelete_click()
{
	var RowId=GetValue("RowId",1);
	if (RowId=="")
	{
		alert(t["03"]);
		return false;
	}
	var encmeth=GetValue("DeleteMethod",1);
	var rtn=cspRunServerMethod(encmeth,RowId);
	if (rtn.split("^")[0]=="-1"){
		alert("删除失败"+rtn.split("^")[1])
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
//浠ヤ究鏈〉闈㈢殑瀛愰〉闈㈡湁姝ｇ‘鐨勪紶鍏ュ弬鏁?
function ShowCurRecord(selectrow) {
	var RowId=GetValue('TRowId'+'z'+selectrow,1);
	SetValue("RowId",RowId,1);
	var encmeth=GetValue("GetOneMethod",1);
	var OneStr=cspRunServerMethod(encmeth,RowId);
	var StrArr=OneStr.split("^");
	SetValue("Code",StrArr[0],1);
	SetValue("Desc",StrArr[1],1);
	SetValue("VIPLevel",StrArr[3],1);
	SetValue("ExpInfo",StrArr[4],1);
	SetValue("Severity",StrArr[5],1);
	SetValue("Remark",StrArr[6],1);
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
	
	var objtbl=GetObj('tDHCPEConclusion');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;
