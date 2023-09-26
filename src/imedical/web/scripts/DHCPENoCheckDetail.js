document.body.onload = BodyLoadHandler;
function BodyLoadHandler(){
	var obj=GetObj("ArcimDesc");
	if (obj) obj.onkeydown=Arcimkeydown;
	var obj=GetObj("OrdStatus");
	if (obj) obj.onkeydown=Statuskeydown;
	var obj=GetObj("StationDesc");
	if (obj) obj.onchange=StationDesc_change;
	var obj=GetObj("RoomDesc");
	if (obj) obj.onchange=RoomDesc_change;
	var AdmStr=GetValue("AdmStr");
	if (AdmStr!=""){
		var TableObj=document.getElementsByTagName("Table")[0];
		TableObj.deleteRow(0);
		TableObj.deleteRow(0);
		TableObj.deleteRow(0);
	}
	//getElementsByTagName
}
function StationDesc_change()
{
	SetValue("StationID","");
}

function RoomDesc_change()
{
	SetValue("RoomID","");
}

function ArcimAfterSelect(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	SetValue("ArcimDR",Arr[1]);
}
function OrdStatusAfterSelect(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	SetValue("OrdStatusDR",Arr[2]);
}
function Statuskeydown(e)
{
	var Key=websys_getKey(e);
		if(currKey==8||currKey==46)
		{
		
		SetValue("OrdStatusDR","");
	
		SetValue("OrdStatus","");
	}
}
function Arcimkeydown(e)
{
	var Key=websys_getKey(e);
		if(currKey==8||currKey==46)
		{
		SetValue("ArcimDR","");
		
		SetValue("ArcimDesc","");
		
	}
}
function StationSelectAfter(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	SetValue("StationID",Arr[0]);
	SetValue("StationDesc",Arr[2]);
}
function SelectRoomAfter(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	SetValue("RoomID",Arr[0]);
	SetValue("RoomDesc",Arr[2]);
	
}

function GetObj(ID)
{
	return document.getElementById(ID);
}
function SetValue(ID,Value)
{
	var obj=GetObj(ID);
	if (obj) obj.value=Value;
}
function GetValue(ID)
{
	var Value="";
	var obj=GetObj(ID);
	if (obj) Value=obj.value;
	return Value;
}