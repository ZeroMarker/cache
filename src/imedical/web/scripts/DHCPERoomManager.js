document.body.onload = BodyLoadHandler;
function BodyLoadHandler() {
	var obj=GetObj("BReload");
	if (obj) obj.onclick=BReload_click;
	var obj=GetObj("RegNo");
	if (obj) obj.onkeydown=RegNo_keydown;;
	var obj=GetObj("Name");
	if (obj) obj.onkeydown=FindDetail;
	var obj=GetObj("IDCard");
	if (obj) obj.onkeydown=FindDetail;
	var Info=GetValue("WaitInfo");
	var obj=GetObj("cNextRoomInfo");
	if (obj) obj.innerHTML=Info;
	var obj=GetObj("VIPLevel");
	if (obj) obj.onchange=BReload_click;
	var obj=GetObj("NoActive");
	if (obj) obj.onchange=BReload_click;
	
	websys_setfocus("RegNo")
	
}
function FindDetail(e)
{
	var Key=websys_getKey(e);
	if (Key=="13")
	{
		var Name=GetValue("Name");
		var IDCard=GetValue("IDCard");
		var url='websys.lookup.csp';
		url += "?ID=&CONTEXT=K"+"web.DHCPE.RoomManagerEx:SearchRoomDetail";
		url += "&P1="+websys_escape(Name);
		url += "&P2="+websys_escape(IDCard);
		websys_lu(url,1,'');
		return websys_cancel();
	}
}
function BReload_click()
{
	var VIPLevel=GetValue("VIPLevel")
	if (VIPLevel==""){
		//alert("请选择体检类型");
		alert("请选择诊室位置");
		return false;
	}
	var NoActive="";
	var obj=GetObj("NoActive");
	if (obj&&obj.checked) NoActive="1";
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPERoomManager"
			+"&VIPLevel="+VIPLevel
			+"&NoActive="+NoActive;
	location.href=lnk;
	//window.location.reload();
}
function ActiveRoom()
{
	Active("Y");
}
function UnActiveRoom()
{
	Active("N");
}
function UpdateRoomMinute(e)
{
	var RoomID=e.id
	var Minute=GetValue(RoomID+"M");
	var encmeth=GetValue("UpdateMinuteClass");
	var rtn=cspRunServerMethod(encmeth,RoomID,Minute);
	var Arr=rtn.split("^");
	if (Arr[0]=="-1"){
		alert(Arr[1]);
	}
	window.location.reload();
}
function Active(ActiveFlag)
{
	var eSrc=window.event.srcElement;
	var ID=eSrc.id;
	
	if (ID==""){
		alert("诊室不存在,不能操作");
		return false;
	}
	var encmeth=GetValue("ActiveRoomClass");
	var rtn=cspRunServerMethod(encmeth,ID,ActiveFlag);
	var Arr=rtn.split("^");
	if (Arr[0]=="-1"){
		alert(Arr[1]);
	}
	window.location.reload();
}
function RegNo_keydown(e)
{
	var Key=websys_getKey(e);
	if ((9==Key)||(13==Key)) {
		var obj=window.event.srcElement;
		var RegNo=obj.value;
		if (RegNo=="") return false;
		//是否存在未到达记录，选择到达操作
		var RegisterRecord=tkMakeServerCall("web.DHCPE.PreIADMEx","GetRegisterRecord",RegNo)
		if (RegisterRecord!="")
		{
			var ArriveRecord="";
			var RecordArr=RegisterRecord.split("^");
			if (RecordArr.length>1){
				var url="dhcpearrived.csp?RegisterRecord="+RegisterRecord;   
  				var  iWidth=600; //模态窗口宽度
  				var  iHeight=330;//模态窗口高度
  				var  iTop=(window.screen.height-iHeight)/2;
  				var  iLeft=(window.screen.width-iWidth)/2;
  				var ArriveRecord=window.showModalDialog(url, RegisterRecord, "dialogwidth:600px;dialogheight:330px;center:1"); 
			}else{
				
				ArriveRecord=RegisterRecord;
			}
			if (ArriveRecord!=""){
				//判断是否未付费、是否存在另外未总检的记录
				var ret=tkMakeServerCall("web.DHCPE.DHCPEIAdm","HadNoGenRecord",ArriveRecord);
				if (ret!=""){
					alert(ret);
				}else{
					var ret=tkMakeServerCall("web.DHCPE.DHCPEIAdm","IAdmArrived",ArriveRecord);
				}
			}
		}
		//End
		var encmeth=GetValue("RoomClass");
		if (encmeth=="") return false;
		var ret=cspRunServerMethod(encmeth,RegNo);
		var ret=ret.split("^");
		var Flag=ret[0];
		//alert(ret[1]);
		var lnk=window.location.href.split("&WaitInfo")[0];
		window.location.href=lnk+"&WaitInfo="+ret[1];
	}
}
function GetObj(Name)
{
	var obj=document.getElementById(Name);
	return obj;	
}
function GetValue(ElementName)
{
	var obj=GetObj(ElementName)
	if (obj){
		return obj.value;
	}else{
		return "";
	}
}
function SetValue(ElementName,value)
{
	var obj=GetObj(ElementName)
	if (obj){
		obj.value=value;
	}
}