///DHCPEChangeRoomPlace.js
var CurrentSel=0;
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_click;
	obj=document.getElementById("RegNo");
	if (obj) obj.onkeydown=RegNo_keydown;
}
function RegNo_keydown(e)
{
	var key=websys_getKey(e);
	if ( 13==key) {
		var RegNo=GetValue("RegNo",1);
		if (RegNo=="") return false;
		if(RegNo!="") var RegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",RegNo)
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEChangeRoomPlace"
			+"&RegNo="+RegNo;
		window.location.href=lnk;
	}
}
function BSave_click()
{
	var PreIADM=GetValue("PreIADM",1);
	if (PreIADM==""){
		alert("请先选择调整记录");
		return false;
	}
	var RoomPlace=GetValue("RoomPlace",1);
	var encmeth=GetValue("SaveClass",1);
	var rtn=cspRunServerMethod(encmeth,"I",PreIADM,RoomPlace);
	if (rtn.split("^")[0]=="-1"){
		alert("更新失败"+rtn.split("^")[1])
	}else{
		var DeleteOldRoom=tkMakeServerCall("web.DHCPE.RoomManager","NeedDeleteOldRoom",PreIADM);
		if (DeleteOldRoom==1){
			if (confirm("是否需要把原来诊室，进行重新分配新诊室")){
				var ret=tkMakeServerCall("web.DHCPE.RoomManager","DeleteOldRoom",PreIADM);
				alert(ret)
			}
		}
		window.location.reload();
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
	var ID=GetValue('PIADM_RowId'+'z'+selectrow,1);
	SetValue("PreIADM",ID,1);
	var encmeth=GetValue("GetOneMethod",1);
	var OneStr=cspRunServerMethod(encmeth,ID);
	var StrArr=OneStr.split("^");
	SetValue("RegNo",StrArr[7],1);
	SetValue("Name",StrArr[8],1);
	SetValue("Sex",StrArr[9],1);
	SetValue("IDCard",StrArr[11],1);
	
	SetValue("GDesc",StrArr[1],1);
	SetValue("TeamDesc",StrArr[2],1);
	SetValue("VIPLevel",StrArr[3],1);
	SetValue("HPNo",StrArr[4],1);
	
	SetValue("OldRoomPlace",StrArr[5],1);
	
	
}
			
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var objtbl=GetObj('tDHCPERoomPlace');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;