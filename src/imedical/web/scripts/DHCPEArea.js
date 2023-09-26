var CurrentSel=0;
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_click;
	obj=document.getElementById("BRoomPlace");
	if (obj) obj.onclick=BRoomPlace_click;

}
function BRoomPlace_click()
{
	var width=screen.width-300;
	var height=screen.height-200;
	var nwin='toolbar=no,alwaysLowered=yes,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=no,width='+width+',height='+height+',left=30,top=5';
 	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPERoomPlace";
	open(lnk,"_blank",nwin);

	//lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPERoomPlace";
	//location.href=lnk;
}

function BUpdate_click()
{
	var Code=GetValue("Code",1);
	var Desc=GetValue("Desc",1);
	var Sort=GetValue("Sort",1);
	var PEType=GetValue("VIPLevel",1);
	var ID=GetValue("ID",1);
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
	
	if (""==Sort) {
		obj=document.getElementById("Sort")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("序号不能为空");
		return false;
	}

	var encmeth=GetValue("UpdateMethod",1);
	var LocID=session['LOGON.CTLOCID']
	var AreaFlag="0";
	var obj=document.getElementById("AreaFlag");
	if (obj&&obj.checked) AreaFlag="1";
	var Str=Code+"^"+Desc+"^"+Sort+"^"+LocID+"^"+PEType+"^"+AreaFlag;
	var rtn=cspRunServerMethod(encmeth,ID,Str);
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
	SetValue("Sort",StrArr[2],1);
	SetValue("VIPLevel",StrArr[5],1);
	var AreaFlag=StrArr[7];
	var obj=document.getElementById("AreaFlag");
	if (obj){
		if (AreaFlag=="1"){
			obj.checked=true;
		}else{
			obj.checked=false;
		}
	}
	
	
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPERoom&Parref="+ID;
	parent.frames["DHCPERoom"].location.href=lnk; 
}
			
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var objtbl=GetObj('tDHCPEArea');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;