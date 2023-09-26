document.body.onload=LoadHandler1;
function LoadHandler1()
{
	var tbl=document.getElementById("tDHCPEAdmRoomRecordList");
	if(tbl) tbl.ondblclick=DHC_SelectPat;
	var obj=document.getElementById("BRefuseSelect");
	if (obj) obj.onclick=BRefuseSelect_click;
	var obj=document.getElementById("BAllSeletct");
	if (obj) obj.onclick=BAllSeletct_click;
}
function BAllSeletct_click()
{
	var objArr=document.getElementsByName("TSelect");
	var ArrLength=objArr.length;
	for (var i=0;i<ArrLength;i++)
	{
		objArr[i].checked=!objArr[i].checked;
	}
}
function BRefuseSelect_click()
{
	var objArr=document.getElementsByName("TSelect");
	var ArrLength=objArr.length;
	for (var i=0;i<ArrLength;i++)
	{
		if (objArr[i].checked){
			var Info=objArr[i].id;
			var Arr=Info.split("^");
			var PAADM=Arr[0];
			var RoomID=Arr[1];
			//var encmeth=GetValue("RefuseClass",1)
			var ret=RefuseRoomApp(PAADM,RoomID)
			//alert(ret);
			
		}
	}
	window.location.reload();
}
function DHC_SelectPat()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj,AreaDesc="",RoomDesc="",RoomID="";
	obj=document.getElementById("TAreaDescz"+selectrow);
	if (obj) AreaDesc=obj.innerText;
	obj=document.getElementById("TRoomDescz"+selectrow);
	if (obj) RoomDesc=obj.innerText;
	obj=document.getElementById("TRoomIDz"+selectrow);
	if (obj) RoomID=obj.value;
	obj=parent.frames["Record"].document.getElementById("RoomID");
	if (obj) obj.value=RoomID;
	obj=parent.frames["Record"].document.getElementById("RoomDesc");
	if (obj) obj.value=RoomDesc;
	obj=parent.frames["Record"].document.getElementById("AreaDesc");
	if (obj) obj.value=AreaDesc;
	obj=parent.frames["Record"].document.getElementById("AreaID");
	if (obj) obj.value=RoomID.split("||")[0];	
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
function RefuseRoom()
{
	var eSrc=window.event.srcElement;
	var Info=eSrc.id
	var Arr=Info.split("^");
	var PAADM=Arr[0];
	var RoomID=Arr[1];
	//var encmeth=GetValue("RefuseClass",1)
	var ret=RefuseRoomApp(PAADM,RoomID)
	alert(ret);
	window.location.reload();
}
function RefuseRoomApp(PAADM,RoomID)
{
	var encmeth=GetValue("RefuseClass",1)
	var ret=cspRunServerMethod(encmeth,PAADM,RoomID);
	return ret
}
function ResumeRoom()
{
	var eSrc=window.event.srcElement;
	var RSID=eSrc.id
	var encmeth=GetValue("ResumeClass",1)
	var ret=cspRunServerMethod(encmeth,RSID);
	alert(ret);
	window.location.reload();
}