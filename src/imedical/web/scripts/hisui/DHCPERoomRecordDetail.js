
document.body.onload = BodyLoadHandler;
function BodyLoadHandler()
{
	var obj=GetObj("BClose");
	if (obj) obj.onclick=BClose_click;
	
	var WaitInfo=GetValue("WaitInfo");
	
	var obj=GetObj("cRoomDesc");
	if (obj) obj.innerHTML=WaitInfo;
	
	//刷新
	var obj=GetObj("BReload");
	if (obj) obj.onclick=BReload_click;
	
	//setTimeout("reflesh()",5000);
}


function BReload_click()
{
	var RoomID=getValueById("RoomID")
	
	var WaitInfo=getValueById("WaitInfo")
	
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPERoomRecordDetail"
			+"&RoomID="+RoomID
			+"&WaitInfo="+WaitInfo;
			//messageShow("","","",lnk)
	location.href=lnk;
	
}

function reflesh(){
	document.location.reload();
	//"&RoomID="_%request.Get("RoomID")_"&WaitInfo="_%request.Get("WaitInfo")
}

//科室确认
function CompleteRoom()
{
	var eSrc=window.event.srcElement;
	var ID=eSrc.id;
	
}
//叫号  调用接口  ARR_StatusDetail更新为C
function CallCurRoom()
{
	var eSrc=window.event.srcElement;
	var ID=eSrc.id;
	var Arr=ID.split("^");
	var RegNo=Arr[1];
	var RecordID=Arr[0];
	if (RecordID==""){
		alert("原诊室不存在,不能调整");
		return false;
	}
	if (opener){
		var OldRecord="";
		if (opener.document.getElementById("SpecNo"))
		{
			OldRecord=opener.vRoomRecordID;
			
			//opener.websys_setfocus("SpecNo");
		}else{
			OldRecord=opener.parent.vRoomRecordID;
			//opener.websys_setfocus("RegNo");
		}
		if ((OldRecord!=RecordID)&&(OldRecord!=""))
		{
			if (!confirm("当前体检者,还没有完成,是否开始下一个?")){
				return false;
			}
		}
	}
	var encmeth=GetValue("CallRoomClass",1);
	var UserID=session['LOGON.USERID'];
	var rtn=cspRunServerMethod(encmeth,RecordID);
	var Arr=rtn.split("^");
	if (Arr[0]!="0"){
		messageShow("","","",Arr[1]);
	}
	
	if (opener){
		if (opener.document.getElementById("SpecNo"))
		{
			opener.vRoomRecordID=RecordID;
			opener.websys_setfocus("SpecNo");
		}else{
			opener.parent.vRoomRecordID=RecordID;
			opener.websys_setfocus("RegNo");
		}
	}
	//调用叫号接口
}
//到达  开始体检ARR_StatusDetail更新为E
function ArriveCurRoom()
{
	var eSrc=window.event.srcElement;
	var ID=eSrc.id;
	var Arr=ID.split("^");
	var RegNo=Arr[1];
	var RecordID=Arr[0];
	if (RecordID==""){
		alert("原诊室不存在,不能调整");
		return false;
	}
	var encmeth=GetValue("ArriveRoomClass",1);
	var UserID=session['LOGON.USERID'];
	var rtn=cspRunServerMethod(encmeth,RecordID,UserID);
	var Arr=rtn.split("^");
	if (Arr[0]!="0"){
		messageShow("","","",Arr[1]);
	}
	if (opener){
		var obj=opener.document.getElementById("RegNo");
		if (obj) obj.value=RegNo;
		if (opener.document.getElementById("tDHCPESaveCollectSpec")){ //标本采集界面
			opener.vRoomRecordID=RecordID;
			opener.Find();
		}else{
			opener.RegNo_onchange();
			opener.parent.vRoomRecordID=RecordID;
		}
		
		BClose_click();
	}
}
//顺延  三位
function DelayCurRoom()
{
	DealMethod("DelayRoomClass");
	if (opener){
		if (opener.document.getElementById("SpecNo"))
		{
			opener.vRoomRecordID="";
			
			//opener.websys_setfocus("SpecNo");
		}else{
			opener.parent.vRoomRecordID="";
			//opener.websys_setfocus("RegNo");
		}
	}
}

//过号  设置为过号状态
function PassCurRoom()
{
	DealMethod("PassRoomClass");
	if (opener){
		if (opener.document.getElementById("SpecNo"))
		{
			opener.vRoomRecordID="";
			
			//opener.websys_setfocus("SpecNo");
		}else{
			opener.parent.vRoomRecordID="";
			//opener.websys_setfocus("RegNo");
		}
	}
}
//重新排队
function NewCurRoom()
{
	DealMethod("NewRoomClass");
	
}
//过号启用
function ReStartCurRoom()
{
	DealMethod("ReStartRoomInfo");
	
}
//取消排队
function StopCurRoom()
{
	DealMethod("StopRoomClass");
	if (opener){
		if (opener.document.getElementById("SpecNo"))
		{
			opener.vRoomRecordID="";
			
			//opener.websys_setfocus("SpecNo");
		}else{
			opener.parent.vRoomRecordID="";
			//opener.websys_setfocus("RegNo");
		}
	}
}
function DealMethod(ElementName)
{
	var eSrc=window.event.srcElement;
	var ID=eSrc.id;
	DealMethodApp(ID,ElementName);
}
function DealMethodApp(ID,ElementName)
{
	if (ID==""){
		alert("原诊室不存在,不能调整");
		return false;
	}
	var encmeth=GetValue(ElementName,1);
	var rtn=cspRunServerMethod(encmeth,ID);
	var Arr=rtn.split("^");
	if (Arr[0]!="0"){
		messageShow("","","",Arr[1]);
	}
	window.location.reload();
}
function BClose_click()
{
	window.close();
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
function GetObj(Name)
{
	var obj=document.getElementById(Name);
	return obj;	
}