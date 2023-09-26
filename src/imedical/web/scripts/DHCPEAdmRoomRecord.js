var CurrentSel=0;
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BStopRoom");
	if (obj) obj.onclick=BStopRoom_click;
	obj=document.getElementById("BPauseRoom");
	if (obj) obj.onclick=BPauseRoom_click;
	var obj=GetObj("Name");
	if (obj) obj.onkeydown=FindDetail;
	obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_click;
	obj=document.getElementById("RegNo");
	if (obj){
		obj.onchange=RegNo_change;
		obj.onkeydown=RegNo_keydown;
	}
	obj=document.getElementById("AreaDesc");
	if (obj) obj.onchange=AreaDesc_change;
}
function FindDetail()
{
	var Key=websys_getKey(e);
	if (Key=="13")
	{
		var Name=GetValue("Name");
		var IDCard=GetValue("IDCard");
		var url='websys.lookup.csp';
		url += "?ID=&CONTEXT=K"+"web.DHCPE.RoomManagerEx:SearchRoomDetail";
		url += "&TLUJSF=SelectByName";
		url += "&P1="+websys_escape(Name);
		url += "&P2="+websys_escape(IDCard);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
function SelectByName(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var RegNo=Arr[0];
	obj=document.getElementById("RegNo");
	if (obj){
		obj.value=RegNo;
		RegNo_change();
	}
}
function BPauseRoom_click()
{
	var ID=GetValue("RoomRecordID",1);
	if (ID!=""){
		if (confirm("当前诊室是否需要取消?"))
		{
			var encmeth=GetValue("StopRoomClass",1);
			var rtn=cspRunServerMethod(encmeth,ID);
		}
	}
	var PAADM=GetValue("PAADM",1);
	if (PAADM==""){
		alert("请选输入暂停排队的人员");
		return false;
	}
	var encmeth=GetValue("PauseRoomClass",1);
	var rtn=cspRunServerMethod(encmeth,PAADM);
	alert(rtn)
	window.location.reload();
}
function BStopRoom_click()
{
	var ID=GetValue("RoomRecordID",1);
	if (ID==""){
		alert("原诊室不存在,不能调整");
		return false;
	}
	var encmeth=GetValue("StopRoomClass",1);
	var rtn=cspRunServerMethod(encmeth,ID);
	alert(rtn)
	window.location.reload();
	
}
function BUpdate_click()
{
	var ID=GetValue("RoomRecordID",1);
	var RoomID=GetValue("RoomID",1);
	if (ID==""){
		alert("原诊室不存在,不能调整");
		return false;
	}
	if (RoomID==""){
		alert("调整为诊室不存在,不能调整");
		return false;
	}
	var encmeth=GetValue("UpdateMethod",1);
	
	var rtn=cspRunServerMethod(encmeth,ID,RoomID);
	if (rtn.split("^")[0]=="-1"){
		alert("更新失败"+rtn.split("^")[1])
	}else{
		window.location.reload();
	}
}
function BClose_click()
{
	window.close();
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
	//Code_"^"_Desc_"^"_Sort_"^"_Sex_"^"_SexDesc_"^"_DietFlag_"^"_DietDesc_"^"_EmictionFlag_"^"_EmictionDesc_"^"_StationDR_"^"_StationDesc_"^"_Remark
	var StrArr=OneStr.split("^");
	SetValue("Code",StrArr[0],1);
	SetValue("Desc",StrArr[1],1);
	SetValue("Sort",StrArr[2],1);
	SetValue("Sex",StrArr[3],1);
	SetValue("Diet",StrArr[5],1);
	SetValue("Emiction",StrArr[7],1);
	SetValue("Station",StrArr[9],1);
	SetValue("Remark",StrArr[11],1);
	SetValue("Minute",StrArr[12],1);
	SetValue("DoctorDR",StrArr[13],1);
	SetValue("DoctorDesc",StrArr[14],1);
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPERoomSpecimen&Parref="+ID;
	parent.frames["DHCPERoomSpecimen"].location.href=lnk+"&Type=SP"; 
	parent.frames["DHCPERoomIP"].location.href=lnk+"&Type=IP"; 
	
}
			
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var objtbl=GetObj('tDHCPEPreManager');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}
function SetAreaInfo(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	SetValue("AreaDesc",Arr[2],1);
	SetValue("AreaID",Arr[0],1);
}
function SetRoomInfo(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	SetValue("RoomDesc",Arr[2],1);
	SetValue("RoomID",Arr[0],1);
}

function AreaDesc_change()
{
	SetValue("AreaID","",1);
	SetValue("RoomDesc","",1);
	SetValue("RoomID","",1);
}
function RoomDesc_change()
{
	SetValue("RoomID","",1);
}
function RegNo_keydown(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		RegNo_change();
	}
}
function RegNo_change()
{
	var RegNo=GetValue("RegNo");
	if (RegNo==""){
		var Info="0^^^^^^^^^^^^";
	}else{
		var encmeth=GetValue("GetInfoMethod");
		var Info=cspRunServerMethod(encmeth,RegNo);
	}
	var Char_1=String.fromCharCode(1);
	var Arr=Info.split(Char_1);
	var BaseInfo=Arr[0];
	var BaseArr=BaseInfo.split("^");
	var PAADM="";
	var PauseFlag=0;
	if (BaseArr[0]=="0"){
		var RoomInfo=Arr[1];
		var RoomArr=RoomInfo.split("^");
		SetValue("Name",BaseArr[1],1)
		SetValue("Sex",BaseArr[2],1)
		SetValue("Dob",BaseArr[3],1)
		SetValue("IDCard",BaseArr[4],1)
		SetValue("RegNo",BaseArr[5],1)
		SetValue("PAADM",BaseArr[9],1)
		SetValue("RoomRecordID",RoomArr[0],1)
		SetValue("CurRoomInfo",RoomArr[1],1)
		PAADM=BaseArr[9];
		PauseFlag=BaseArr[10];
	}else{
		alert(BaseArr[1])
		SetValue("Name","",1)
		SetValue("Sex","",1)
		SetValue("Dob","",1)
		SetValue("IDCard","",1)
		SetValue("RoomRecordID","",1)
		SetValue("CurRoomInfo","",1)
		SetValue("PAADM","",1)
	}
	if (PauseFlag!="0"){
		var obj=GetObj("BPauseRoom");
		if (obj) obj.innerText="恢复排队";
	}else{
		var obj=GetObj("BPauseRoom");
		if (obj) obj.innerText="暂停排队";
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEAdmRoomRecordList&PAADM="+PAADM;
	parent.frames["RecordList"].location.href=lnk;
}
document.body.onload = BodyLoadHandler;