
//DHCPENewRoomRecordList.js
var vRoomRecordID="";
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
function SetRoomInfo()
{
	var Info=GetComputeInfo("IP");  //计算机名称  DHCPECommon.js
	
	var encmeth=GetValue("GetRoomIDClass",1);
	var RoomID=cspRunServerMethod(encmeth,Info);
	
	if (RoomID=="") return false;
	var Obj=GetObj("RoomID");
	if (Obj) Obj.value=RoomID.split("$")[0];
}

function CreateRoomRecordList()
{	//alert('b')
	var RoomID=GetValue("RoomID",1);
	if (RoomID=="") return false;
	var encmeth=GetValue("GetMinFlagClass",1);
	var PAADM=GetValue("EpisodeID",1);
	if (PAADM=="") PAADM=GetValue("TAdmIdz1",1);
	var  rows= $('#SaveCollectSpecGrid').datagrid("getRows");
	if (rows!="") PAADM=$('#SaveCollectSpecGrid').datagrid("getRows")[0].TAdmId;
	var MinInfo=cspRunServerMethod(encmeth,RoomID);
	var FlagArr=MinInfo.split("^");
	var Flag=FlagArr[0];
	var DivTop=FlagArr[1];
	var Divleft=FlagArr[2];
	//alert('1')
	var OldDiv=document.getElementById("RoomRecord");
	if (OldDiv){
		document.body.removeChild(OldDiv);
	}
	div = document.createElement("div");   
    div.id="RoomRecord";  
    div.style.position='absolute';  
    div.style.top=DivTop;  
    div.style.left=Divleft;  
    //alert('id')
	if (Flag!=1) div.style.height=200;
	div.style.overflowy='auto';
    div.style.zIndex =100;  
    div.style.backgroundColor='white';  
    div.style.border="1px solid #666";  
    var encmeth="";
    //s val=##Class(%CSP.Page).Encrypt($lb("web.DHCPE.RoomManagerEx.OutRoomPersonDiv"))
	var obj=document.getElementById("GetRoomRecordListClass");
	if (obj) encmeth=obj.value;
	var innerText=cspRunServerMethod(encmeth,RoomID,PAADM);
	//alert('1')
	div.innerHTML=innerText;
    //alert('2')
    document.body.appendChild(div);
	//alert('3')
	rDrag.init(div);
	setTimeout("CreateRoomRecordList()",10000);
	//alert('e')
	
}
function BComplete()
{
	//alert('s')
	
	//var RecordID=vRoomRecordID;
	var RecordID="";
	var PAADM=GetValue("EpisodeID",1);
	if (PAADM=="") PAADM=GetValue("TAdmIdz1",1);
	if (PAADM=="") PAADM=GetValue("PAADM",1);
	var RoomID=GetValue("RoomID",1);
	if (RoomID=="") return false;
	var encmeth=GetValue("CompleteClass");
	if (PAADM==""){
		 $.messager.alert("提示","没有就诊患者","info");;
		return false;
	}
	//alert(encmeth+"^^^"+RecordID+"^^^"+PAADM+"^^^"+RoomID)
	if(encmeth!=""){
		var ret=cspRunServerMethod(encmeth,RecordID,PAADM,RoomID);
	}else{
		var ret=tkMakeServerCall("web.DHCPE.RoomManager","CompleteCurRoom",RecordID,PAADM,RoomID)
	}
	var Arr=ret.split("^");
	
	vRoomRecordID="";
	obj=GetObj("SpecNo");
	if (!obj){
		
		parent.frames["query"].SetCheckInfo();
		
		parent.vRoomRecordID="";
	}
	vRoomInfo=Arr[1];
	CreateRoomRecordList();
	if (parent.frames["query"]){
		parent.frames["query"].websys_setfocus("RegNo");
	}
}
function GetNextInfo()
{
	var RoomID=GetValue("RoomID",1);
	if (RoomID=="") return false;
	var encmeth=GetValue("GetNextInfo",1);
	var Info=cspRunServerMethod(encmeth,RoomID);
	var Info=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetNextInfo",RoomID)
	return Info;
}
function Call()
{
	var Info=GetNextInfo();
	var Arr=Info.split("^");
	var RecordID=Arr[0];
	var CallName=Arr[1];
	if (RecordID==""){
		 $.messager.alert("提示","没有排队记录！","info");;
		return false;
	}
	CallApp(RecordID,CallName);
}
function CallCurRoom(e)
{
	//var eSrc=window.event.srcElement;
	//var ID=eSrc.id;
	var ID=e.id;
	var Arr=ID.split("^");
	var RegNo=Arr[1];
	var RecordID=Arr[0];
	if (RecordID==""){
		$.messager.alert("提示","原诊室不存在,不能叫号","info");
		return false;
	}
	var CallName="";
	var NameObj=GetObj(RecordID+"Name");
	if (NameObj) CallName=NameObj.innerText;
	CallApp(RecordID,CallName);
	//调用叫号接口
}
function CallApp(RecordID,CallName)
{
	var OldRecord=vRoomRecordID;
	if ((OldRecord!=RecordID)&&(OldRecord!=""))
	{
		var encmeth=GetValue("GetRecordStatusClass",1);
		var Status=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetRecordStatus",OldRecord)  //cspRunServerMethod(encmeth,OldRecord);
		var StatusArr=Status.split("^");
		var DetailStatus=StatusArr[1];
		var Status=StatusArr[0];
		if (Status=="N"){
			if (!confirm("当前体检者,还没有完成,是否开始下一个?")){
				return false;
			}
		}
	}
	var encmeth=GetValue("CallRoomClass",1);
	var UserID=session['LOGON.USERID'];
	var rtn=cspRunServerMethod(encmeth,RecordID);
	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","CallCurRoom",RecordID)
	var Arr=rtn.split("^");
	if (Arr[0]!="0"){
		alert(Arr[1]);
	}
	var Obj=GetObj("cWaitInfo");
	if (Obj) Obj.innerHTML="<font color=red>"+CallName+"</font>";
	vRoomRecordID=RecordID;
	obj=GetObj("SpecNo");
	if (obj){
		websys_setfocus("SpecNo");
		return false;
	}
	if ((parent)&&(parent.frames("query"))){
		parent.vRoomRecordID=RecordID;
		parent.frames("query").SetCheckInfo();
		parent.frames("query").websys_setfocus("RegNo");
	}else{
		websys_setfocus("SpecNo");
	}
}
function Delay()
{
	
	$.messager.confirm("提示", "确认要顺延吗?", function (r) {
	if (r) {
	
	var Info=GetNextInfo();
	var Arr=Info.split("^");
	var RecordID=Arr[0];
	if (RecordID==""){
	   $.messager.alert("提示","没有排队记录！","info");;
		return false;
	}
	
	var CallName=Arr[1];
	var encmeth=GetValue("DelayRoomClass",1);
	var rtn=cspRunServerMethod(encmeth,RecordID);
	var Arr=rtn.split("^");
	if (Arr[0]!="0"){
		alert(Arr[1]);
	}
	CreateRoomRecordList();
	}
	
	});	
	
}
function DelayCurRoom(e)
{
	var RecordID=e.id;
	 if (RecordID==""){
			$.messager.alert("提示","没有排队记录！","info");
			return false;
		}
	$.messager.confirm("提示", "确认要顺延吗?", function (r) {
	if (r) {
		var rtn=tkMakeServerCall("web.DHCPE.RoomManager","DelayCurRoomInfo",RecordID);
		var Arr=rtn.split("^");
		if (Arr[0]!="0"){
			$.messager.alert("提示",Arr[1],"info")
		}else{
			$.messager.alert("提示",Arr[1],"success")
			
		}
		CreateRoomRecordList()
			if (parent){
				parent.vRoomRecordID="";
			}
			else{
				vRoomRecordID="";
			}

	}
	
	});
		
    
}
function Pass()
{
	$.messager.confirm("提示", "确认要过号吗?", function (r) {
	if (r) {
			
		var Info=GetNextInfo();
	var Arr=Info.split("^");
	var RecordID=Arr[0];
	if (RecordID==""){
		$.messager.alert("提示","没有排队记录！","info");
		return false;
	}
	
	var CallName=Arr[1];
	var encmeth=GetValue("PassRoomClass",1);
	var rtn=cspRunServerMethod(encmeth,RecordID);
	var Arr=rtn.split("^");
	if (Arr[0]!="0"){
		alert(Arr[1]);
	}
	if (parent){
		parent.vRoomRecordID="";
	}
	else{
		vRoomRecordID="";
	}
	}
	
	})
	
}
//过号  设置为过号状态
function PassCurRoom(e)
{
	var RecordID=e.id;
	 if (RecordID==""){
			$.messager.alert("提示","没有排队记录！","info");
			return false;
		}
	$.messager.confirm("提示", "确认要过号吗?", function (r) {
	if (r) {
		
		var rtn=tkMakeServerCall("web.DHCPE.RoomManager","PassCurRoomInfo",RecordID);
		var Arr=rtn.split("^");
		if (Arr[0]!="0"){
			$.messager.alert("提示",Arr[1],"info")
		}
		CreateRoomRecordList();
		if (parent){
				parent.vRoomRecordID="";
			}
			else{
				vRoomRecordID="";
			}
		}
	
	})
}

//过号启用
function ReStartCurRoom(e)
{
	 var RecordID=e.id;
	if (RecordID==""){
		$.messager.alert("提示","没有排队记录！","info");
		return false;
		}
	
	$.messager.confirm("提示", "确认要过号启用吗?", function (r) {
	if (r) {
        var rtn=tkMakeServerCall("web.DHCPE.RoomManager","ReStartCurRoomInfo",RecordID);
		var Arr=rtn.split("^");
		if (Arr[0]!="0"){
			$.messager.alert("提示",Arr[1],"info")	
		}
		CreateRoomRecordList();
		}
	
	})
}
/*
function ReStartCurRoom()
{
	DealMethod("ReStartRoomInfo");
}
*/
function DealMethod(ElementName)
{
	var eSrc=window.event.srcElement;
	var ID=eSrc.id;
	
	DealMethodApp(ID,ElementName);
}
function DealMethodApp(ID,ElementName)
{
	if (ID==""){
		$.messager.alert("提示","原诊室不存在,不能调整","info");;
		return false;
	}
	
	var encmeth=GetValue(ElementName,1);
	var rtn=cspRunServerMethod(encmeth,ID);
	alert(rtn)
	var Arr=rtn.split("^");
	if (Arr[0]!="0"){
		alert(Arr[1]);
	}
	CreateRoomRecordList();
}
function RoomInfoModify(e)
{
	var RoomID=e.id;
	
	var lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPERoomModify&RoomID="+RoomID;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,titlebar=yes,resizable=no,'
			+'height='+300+',width='+420+',left='+260+',top=0'
			;
	//var ALertWin=window.open(lnk,"AlertWin",nwin);
	websys_lu(lnk,false,'iconCls=icon-w-edit,width=385,height=280,hisui=true,title=诊室信息')

	return false;
}
function DivMainShow(e)
{
	var Info=e.id;
	var encmeth=GetValue("UpdateMinFlagClass",1);
	var Arr=Info.split("^");
	var RoomID=Arr[0];
	var Flag=Arr[1];
	var top="",left="";
	var OldDiv=document.getElementById("RoomRecord");
	top=OldDiv.style.top;
	left=OldDiv.style.left;
	Info=Info+"^"+top+"^"+left;
	
	var ret=cspRunServerMethod(encmeth,Info);
	CreateRoomRecordList();
	if (parent.frames("query"))
	{
		parent.frames("query").websys_setfocus("RegNo");
	}
}
function UpdateDivPosition()
{
	var RoomID=GetValue("RoomID",1)
	var OldDiv=document.getElementById("RoomRecord");
	var top=OldDiv.style.top;
	var left=OldDiv.style.left;
	var Info=RoomID+"^"+"^"+top+"^"+left;
	var encmeth=GetValue("UpdateMinFlagClass",1);
	var ret=cspRunServerMethod(encmeth,Info);
}
////拖动DIV
var rDrag = {
 
 o:null,
 
 init:function(o){
  o.onmousedown = this.start;
 },
 start:function(e){
  var o;
  e = rDrag.fixEvent(e);
               e.preventDefault && e.preventDefault();
               rDrag.o = o = this;
  o.x = e.clientX - rDrag.o.offsetLeft;
                o.y = e.clientY - rDrag.o.offsetTop;
  document.onmousemove = rDrag.move;
  document.onmouseup = rDrag.end;
 },
 move:function(e){
  e = rDrag.fixEvent(e);
  var oLeft,oTop;
  oLeft = e.clientX - rDrag.o.x;
  oTop = e.clientY - rDrag.o.y;
  rDrag.o.style.left = oLeft + 'px';
  rDrag.o.style.top = oTop + 'px';
 },
 end:function(e){
  e = rDrag.fixEvent(e);
  if (rDrag.o.id=="RoomRecord")
  {
	UpdateDivPosition();
  }
  rDrag.o = document.onmousemove = document.onmouseup = null;
 },
    fixEvent: function(e){
        if (!e) {
            e = window.event;
            e.target = e.srcElement;
            e.layerX = e.offsetX;
			e.layerY = e.offsetY;
			
        }
        return e;
    }
}