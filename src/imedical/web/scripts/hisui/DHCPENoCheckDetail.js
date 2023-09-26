//名称	DHCPENoCheckDetail.js
//功能	体检已检未检查询
//组件	DHCPENoCheckDetail	
//创建	2008.08.14
//创建人  xy

document.body.onload = BodyLoadHandler;
function BodyLoadHandler(){
	
	var obj=GetObj("ArcimDesc");
	if (obj) {
		obj.onkeydown=Arcimkeydown;
		obj.onchange=Arcim_Change;
	}
	
	var obj=GetObj("OrdStatus");
	if (obj) {
		obj.onkeydown=Statuskeydown;
		obj.onchange=Status_Change;
	}
	
	var obj=GetObj("StationDesc");
	if (obj) obj.onchange=StationDesc_change;
	
	var obj=GetObj("RoomDesc");
	if (obj) obj.onchange=RoomDesc_change;
	
	var obj=document.getElementById("BFind");
	if (obj) {obj.onclick=BFind_Click;}
	
}


function BFind_Click()
{   
   var iBeginDate="",iEndDate="",iStationID="",iRoomID="",iRoomDesc="",iChcekStatus="",iVIPLevel="",iAuditStatus="",iAddItem="",iAdmStr="";
   var iArcimDR="",iArcimDesc="",iOrdStatusDR="",iOrdStatus="";
  
    iBeginDate=getValueById("BeginDate");
     
    iEndDate=getValueById("EndDate");
    
	iStationID=getValueById("StationID");
     
    iRoomID=getValueById("RoomID");
    
    iRoomDesc=getValueById("RoomDesc");
    
    iChcekStatus=getValueById("ChcekStatus");
    
	iVIPLevel=getValueById("VIPLevel");
     
    iAuditStatus=getValueById("AuditStatus");
    
    iAdmStr=getValueById("AdmStr");
    
    iAddItem=getValueById("AddItem");
    
    iArcimDR=getValueById("ArcimDR");
    
    iArcimDesc=getValueById("ArcimDesc");
    
    iOrdStatusDR=getValueById("OrdStatusDR");
    
    iOrdStatus=getValueById("OrdStatus");
    
	 
  var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT="+"DHCPENoCheckDetail"
			+"&BeginDate="+iBeginDate
			+"&EndDate="+iEndDate
			+"&StationID="+iStationID
			+"&RoomID="+iRoomID
			+"&RoomDesc="+iRoomDesc
			+"&ChcekStatus="+iChcekStatus
			+"&VIPLevel="+iVIPLevel
            +"&AuditStatus="+iAuditStatus
            +"&AddItem="+iAddItem
            +"&AdmStr="+iAdmStr
			+"&ArcimDR="+iArcimDR
			+"&ArcimDesc="+iArcimDesc
			+"&OrdStatusDR="+iOrdStatusDR
			+"&OrdStatus="+iOrdStatus
            ;
            //messageShow("","","",lnk)
    location.href=lnk; 

}


function Arcim_Change()
{
		SetValue("ArcimDR","");	
}

function Status_Change() 
{
	SetValue("OrdStatusDR","");	
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