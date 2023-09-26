function BodyLoadHandler() {
	var obj=document.getElementById("btnSearch")
	if (obj) obj.onclick=SearchHandler;
	var obj=document.getElementById("btnAdd")
	if (obj) obj.onclick=AddHandler;
	var obj=document.getElementById("btnUpdate")
	if (obj) obj.onclick=UpdateHandler;
	var obj=document.getElementById("btnDelete")
	if (obj) obj.onclick=DeleteHandler;
	var obj=document.getElementById("btnPrtSC")
	if (obj) obj.onclick=PrtSCHandler;
	var obj=document.getElementById("btnUploadLog")
	if (obj) obj.onclick=UploadLogHandler;
	var obj=document.getElementById("btnVerify")
	if (obj) obj.onclick=VerifyHandler;
	var obj=document.getElementById("btnClear")
	if (obj) obj.onclick=ClearHandler;
	
	var objdiv = document.createElement("DIV");
	var objname="Layer"
	objdiv.id = objname;
	//objdiv.style.top =100;
	//objdiv.style.left =100;
	//objdiv.style.background = '#FFFF00';
	objdiv.style.visibility ='visible'; //'hidden' //'visible';
	objdiv.style.display = 'none';
	objdiv.style.width = 400;
	objdiv.style.height = 300;
	//objdiv.style.border = "5 groove black";
	objdiv.innerHTML="<img src='' name='picshow' width='400' height='300' id='picshow'/>";
	document.body.appendChild(objdiv);
}
function ClearHandler()
{
	var obj=document.getElementById('txtServerId');
	obj.value="";
	
	var obj=document.getElementById('txtServerIP');
	obj.value="";
	
	var obj=document.getElementById('txtServerName');
	obj.value="";

	var obj=document.getElementById('txtServerLinkLoc');
	obj.value="";
	
	var obj=document.getElementById('txtServerLinkLocId');
	obj.value="";
	
	var obj=document.getElementById('txtServerLinkOtherLoc');
	obj.value="";
	
	var obj=document.getElementById('txtServerLinkOtherLocId');
	obj.value="";
	
	var obj=document.getElementById('txtServerNote');
	obj.value="";
	
	var obj=document.getElementById('chkServerActive');
	obj.value="N";
	
	var obj=document.getElementById('UserId');
	obj.value="";

	var obj=document.getElementById('txtServerPortNo');
	obj.value="";

	var obj=document.getElementById('txtServerScreenNo');
	obj.value="";

	var obj=document.getElementById('txtServerScreenColorNo');
	obj.value="";

	var obj=document.getElementById('txtServerTopIP');
	obj.value="";

	var obj=document.getElementById('txtServerTopDesc');
	obj.value="";

	var obj=document.getElementById('txtServerVoiceTopIP');
	obj.value="";
	
	var WaitPaitList="N";
	
	var obj=document.getElementById('txtNotification');
	obj.value="";
	
	var obj=document.getElementById('chkServerSuper');
	obj.checked=false;
	
	var obj=document.getElementById('chkServerAutoUpdate');
	obj.checked=false;
	
	var obj=document.getElementById('chkServerActive');
	obj.checked=false;
}


function VerifyHandler()
{
	var RemoteIP=""
	var SendExecLine="VerifyVersion"     //验证更新程序
	var obj=document.getElementById("txtServerIP");
	if(obj) RemoteIP=obj.value;
	if((RemoteIP!="")&&(RemoteIP!=" "))
	{
		var element=document.getElementById("Layer");
		var Obj= new ActiveXObject("SockActive.ClsSock")
		Obj.RemotePort=5257
		Obj.RemoteHost=RemoteIP;
		Obj.SendData=SendExecLine
		Obj.Send()
		Obj=null
		alert("指令发送成功,程序的更新将在30秒内完成!")
	}
	else
	{
		alert("请选择服务地址!")
	}
}
function UploadLogHandler()
{
	var RemoteIP=""
	var SendExecLine="UploadLog"         //上传日志
	var obj=document.getElementById("txtServerIP");
	if(obj) RemoteIP=obj.value;
	if((RemoteIP!="")&&(RemoteIP!=" "))
	{
		var element=document.getElementById("Layer");
		var Obj= new ActiveXObject("SockActive.ClsSock")
		Obj.RemotePort=5257
		Obj.RemoteHost=RemoteIP;
		Obj.SendData=SendExecLine
		Obj.Send()
		Obj=null
		alert("请等候五秒到服务器指定目录查看!")
	}
	else
	{
		alert("请选择服务地址!")
	}
}
function PrtSCHandler()
{
	var RemoteIP=""
	var SendExecLine="PrtSc"               //抓屏
	//var SendExecLine="VerifyVersion"     //验证更新程序
	//var SendExecLine="UploadLog"         //上传日志
	var obj=document.getElementById("txtServerIP");
	if(obj) RemoteIP=obj.value;
	if((RemoteIP!="")&&(RemoteIP!=" "))
	{
		var element=document.getElementById("Layer");
		var Obj= new ActiveXObject("SockActive.ClsSock")
		Obj.RemotePort=5257
		Obj.RemoteHost=RemoteIP;
		Obj.SendData=SendExecLine
		Obj.Send()
		Obj=null
	}
	else
	{
		alert("请选择要抓图的服务地址!")
	}
	setTimeout("ShowPic()",1000)
}
function ShowPic()
{
	setTimeout("ShowPic()",1000)
	var obj=document.getElementById("txtServerIP");
	if(obj) RemoteIP=obj.value;
	var element=document.getElementById("Layer");
	if(element)
	{
		element.style.display ='inline';
		element.style.top =100;
		element.style.left =100;
		element=document.getElementById("picshow");
		element.src="/vis/wget/PrtSc/"+RemoteIP+".bmp"
	}
}
function AddHandler()
{
	var obj=document.getElementById('txtServerIP');
	var ServerIP=obj.value;
	if(ServerIP==""){
		alert("服务器IP地址不能为空");
		return;
	}
	
	var obj=document.getElementById('txtServerName');
	var ServerName=obj.value;
	if(ServerName==""){
		alert("服务器名称不能为空");
		return;
	}

	var obj=document.getElementById('txtServerLinkLoc');
	var ServerLinkLoc=obj.value;
	if(ServerLinkLoc==" ") ServerLinkLoc="";
	
	var obj=document.getElementById('txtServerLinkLocId');
	var ServerLinkLocId=obj.value;
	if(ServerLinkLoc=="") ServerLinkLocId="";

	var obj=document.getElementById('txtServerLinkOtherLocId');
	var ServerLinkOtherLoc=obj.value;
	if(ServerLinkOtherLoc==" ") ServerLinkOtherLoc="";
	
	var obj=document.getElementById('txtServerNote');
	var ServerNote=obj.value;
	if(ServerNote==" ") ServerNote="";
	
	var ServerActive="N";
	var obj=document.getElementById('chkServerActive');
	if(obj.checked) ServerActive="Y";
	
	var obj=document.getElementById('UserId');
	if(obj) UserId=obj.value;
	else UserId="";

	var obj=document.getElementById('txtServerPortNo');
	var ServerPortNo=obj.value;
	if(ServerPortNo==" ") ServerPortNo="";

	var obj=document.getElementById('txtServerScreenNo');
	var ServerScreenNo=obj.value;
	if(ServerScreenNo==" ") ServerScreenNo="";

	var obj=document.getElementById('txtServerScreenColorNo');
	var ServerScreenColorNo=obj.value;
	if(ServerScreenColorNo==" ") ServerScreenColorNo="";

	var obj=document.getElementById('txtServerTopIP');
	var ServerTopIP=obj.value;
	if(ServerTopIP==" ") ServerTopIP="";

	var obj=document.getElementById('txtServerTopDesc');
	var ServerTopDesc=obj.value;
	if(ServerTopDesc==" ") ServerTopDesc="";
		
	var obj=document.getElementById('txtServerVoiceTopIP');
	var ServerVoiceTopIP=obj.value;
	if(ServerVoiceTopIP==" ") ServerVoiceTopIP="";		

	var ServerSuper="N";
	var obj=document.getElementById('chkServerSuper');
	if(obj.checked) ServerSuper="Y";
	
	var ServerAutoUpdate="N";
	var obj=document.getElementById('chkServerAutoUpdate');
	if(obj.checked) ServerAutoUpdate="Y";
	
	var WaitPaitList="N";
	//var obj=document.getElementById('chkWaitPaitList');
	//if(obj.checked) WaitPaitList="Y";
	
	var obj=document.getElementById('txtNotification');
	var Notification=obj.value;
	
	var obj=document.getElementById('MethodInsert');
	if(obj)
	{
		var objInsert=obj.value;
		var retStr=cspRunServerMethod(objInsert,ServerIP,ServerName,ServerActive,ServerPortNo,ServerScreenNo,ServerScreenColorNo,ServerLinkLocId,ServerLinkOtherLoc,ServerNote,UserId,ServerTopIP,ServerTopDesc,ServerVoiceTopIP,ServerSuper,ServerAutoUpdate,WaitPaitList,Notification);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnAdd_click();
	}
	
}
function SearchHandler()
{
	btnAdd_click();
}
function UpdateHandler()
{
	var obj=document.getElementById('txtServerId');
	var ServerId=obj.value;
	if(ServerId=="") return;
	
	var obj=document.getElementById('txtServerIP');
	var ServerIP=obj.value;
	if(ServerIP=="") return;
	
	var obj=document.getElementById('txtServerName');
	var ServerName=obj.value;
	if(ServerName=="") return;

	var obj=document.getElementById('txtServerLinkLoc');
	var ServerLinkLoc=obj.value;
	if(ServerLinkLoc==" ") ServerLinkLoc="";
	
	var obj=document.getElementById('txtServerLinkLocId');
	var ServerLinkLocId=obj.value;
	if(ServerLinkLoc=="") ServerLinkLocId="";

	var obj=document.getElementById('txtServerLinkOtherLoc');
	var LinkOtherLoc=obj.value;
	if(LinkOtherLoc==" ") LinkOtherLoc="";
	var obj=document.getElementById('txtServerLinkOtherLocId');
	var ServerLinkOtherLoc=obj.value;
	if(LinkOtherLoc=="") ServerLinkOtherLoc="";
	
	var obj=document.getElementById('txtServerNote');
	var ServerNote=obj.value;
	if(ServerNote==" ") ServerNote="";
	
	var ServerActive="N";
	var obj=document.getElementById('chkServerActive');
	if(obj.checked) ServerActive="Y";
	
	var obj=document.getElementById('UserId');
	if(obj) UserId=obj.value;
	else UserId="";

	var obj=document.getElementById('txtServerPortNo');
	var ServerPortNo=obj.value;
	if(ServerPortNo==" ") ServerPortNo="";

	var obj=document.getElementById('txtServerScreenNo');
	var ServerScreenNo=obj.value;
	if(ServerScreenNo==" ") ServerScreenNo="";

	var obj=document.getElementById('txtServerScreenColorNo');
	var ServerScreenColorNo=obj.value;
	if(ServerScreenColorNo==" ") ServerScreenColorNo="";

	var obj=document.getElementById('txtServerTopIP');
	var ServerTopIP=obj.value;
	if(ServerTopIP==" ") ServerTopIP="";

	var obj=document.getElementById('txtServerTopDesc');
	var ServerTopDesc=obj.value;
	if(ServerTopDesc==" ") ServerTopDesc="";

	var obj=document.getElementById('txtServerVoiceTopIP');
	var ServerVoiceTopIP=obj.value;
	if(ServerVoiceTopIP==" ") ServerVoiceTopIP="";

	var ServerSuper="N";
	var obj=document.getElementById('chkServerSuper');
	if(obj.checked) ServerSuper="Y";

	var ServerAutoUpdate="N";
	var obj=document.getElementById('chkServerAutoUpdate');
	if(obj.checked) ServerAutoUpdate="Y";
	
	var WaitPaitList="N";
	//var obj=document.getElementById('chkWaitPaitList');
	//if(obj.checked) WaitPaitList="Y";
	
	var obj=document.getElementById('txtNotification');
	var Notification=obj.value;
	
	var obj=document.getElementById('MethodUpdate');
	if(obj)
	{
		var objUpdate=obj.value;
		var retStr=cspRunServerMethod(objUpdate,ServerId,ServerIP,ServerName,ServerActive,ServerPortNo,ServerScreenNo,ServerScreenColorNo,ServerLinkLocId,ServerLinkOtherLoc,ServerNote,UserId,ServerTopIP,ServerTopDesc,ServerVoiceTopIP,ServerSuper,ServerAutoUpdate,WaitPaitList,Notification);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnUpdate_click();
	}
	
}

function DeleteHandler()
{
	var obj=document.getElementById('txtServerId');
	var ServerId=obj.value;
	if(ServerId==""){
		alert("请选择要删除的服务器!")
		return;
	}
	var obj=document.getElementById('MethodDelete');
	if(obj)
	{
		var objDelete=obj.value;
		var retStr=cspRunServerMethod(objDelete,ServerId);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnDelete_click();
	}
}

function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCVISVoiceServerSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('txtServerId');
	var obj1=document.getElementById('txtServerIP');
	var obj2=document.getElementById('txtServerName');
	var obj3=document.getElementById('txtServerLinkLoc');
	var obj4=document.getElementById('txtServerLinkLocId');
	var obj5=document.getElementById('txtServerLinkOtherLoc');
	var obj6=document.getElementById('txtServerNote');
	var obj7=document.getElementById('chkServerActive');
	var obj8=document.getElementById('txtServerPortNo');
	var obj9=document.getElementById('txtServerScreenNo');
	var obj10=document.getElementById('txtServerScreenColorNo');
	var obj11=document.getElementById('txtServerTopIP');
	var obj12=document.getElementById('txtServerTopDesc');
	var obj13=document.getElementById('txtServerVoiceTopIP');
	var obj14=document.getElementById('txtServerLinkOtherLocId');
	var obj15=document.getElementById('chkServerSuper');
	var obj16=document.getElementById('chkServerAutoUpdate');
	//var obj17=document.getElementById('chkWaitPaitList');
	var obj18=document.getElementById('txtNotification');	

	var SelRowObj=document.getElementById('ServerIdz'+selectrow);
	var SelRowObj1=document.getElementById('ServerIPz'+selectrow);
	var SelRowObj2=document.getElementById('ServerNamez'+selectrow);
	var SelRowObj3=document.getElementById('ServerLinkLocz'+selectrow);
	var SelRowObj4=document.getElementById('ServerLinkLocIdz'+selectrow);
	var SelRowObj5=document.getElementById('ServerLinkOtherLocz'+selectrow);
	var SelRowObj6=document.getElementById('ServerNotez'+selectrow);
	var SelRowObj7=document.getElementById('ServerActivez'+selectrow);
	var SelRowObj8=document.getElementById('ServerPortNoz'+selectrow);
	var SelRowObj9=document.getElementById('ServerScreenNoz'+selectrow);
	var SelRowObj10=document.getElementById('ServerScreenColorNoz'+selectrow);
	var SelRowObj11=document.getElementById('ServerTopIPz'+selectrow);
	var SelRowObj12=document.getElementById('ServerTopDescz'+selectrow);
	var SelRowObj13=document.getElementById('ServerVoiceTopIPz'+selectrow);
	var SelRowObj14=document.getElementById('ServerLinkOtherLocIdz'+selectrow);
	var SelRowObj15=document.getElementById('ServerSuperz'+selectrow);
	var SelRowObj16=document.getElementById('ServerAutoUpdatez'+selectrow);
	//var SelRowObj17=document.getElementById('WaitPatListz'+selectrow);
	var SelRowObj18=document.getElementById('Notificationz'+selectrow);

	if(obj&&SelRowObj) obj.value=SelRowObj.innerText;
	if(obj1&&SelRowObj1) obj1.value=SelRowObj1.innerText.replace(" ","");
	if(obj2&&SelRowObj2) obj2.value=SelRowObj2.innerText;
	if(obj3&&SelRowObj3) obj3.value=SelRowObj3.innerText;
	if(obj4&&SelRowObj4) obj4.value=SelRowObj4.innerText;
	if(obj5&&SelRowObj5) obj5.value=SelRowObj5.innerText;
	if(obj6&&SelRowObj6) obj6.value=SelRowObj6.innerText;
	if(obj7&&SelRowObj7)
	{
		if(SelRowObj7.innerText=="Y") obj7.checked=true;
		else obj7.checked=false;
	}
	if(obj8&&SelRowObj8) obj8.value=SelRowObj8.innerText.replace(" ","");
	if(obj9&&SelRowObj9) obj9.value=SelRowObj9.innerText.replace(" ","");
	if(obj10&&SelRowObj10) obj10.value=SelRowObj10.innerText.replace(" ","");
	if(obj11&&SelRowObj11) obj11.value=SelRowObj11.innerText.replace(" ","");
	if(obj12&&SelRowObj12) obj12.value=SelRowObj12.innerText;
	if(obj13&&SelRowObj13) obj13.value=SelRowObj13.innerText.replace(" ","");
	//if(obj13&&SelRowObj14) obj14.value=SelRowObj14.innerText;
	if(obj14&&SelRowObj14) obj14.value=SelRowObj14.innerText;
	if(obj15&&SelRowObj15)
	{
		if(SelRowObj15.innerText=="Y") obj15.checked=true;
		else obj15.checked=false;
	}
	if(obj16&&SelRowObj16)
	{
		if(SelRowObj16.innerText=="Y") obj16.checked=true;
		else obj16.checked=false;
	}
	//if(obj17&&SelRowObj17)
	//{
		//if(SelRowObj17.innerText=="Y") obj17.checked=true;
		//else obj17.checked=false;
	//}
	if(obj18&&SelRowObj18) obj18.value=SelRowObj18.innerText;
	return;
}
function BoroughSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtServerLinkLoc');
	if (obj) obj.value=ret[1]
	var obj=document.getElementById('txtServerLinkLocId');
	if (obj) obj.value=ret[3]
}
function LocSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtServerLinkOtherLoc');
	if (obj) obj.value=ret[1]
	var obj=document.getElementById('txtServerLinkOtherLocId');
	if (obj) obj.value=ret[0]
}
window.document.body.onload=BodyLoadHandler;