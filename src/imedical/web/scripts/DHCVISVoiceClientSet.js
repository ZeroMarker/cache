
function BodyLoadHandler() {
	var obj=document.getElementById("btnAdd")
	if (obj) obj.onclick=AddHandler;
	var obj=document.getElementById("btnUpdate")
	if (obj) obj.onclick=UpdateHandler;
	var obj=document.getElementById("btnDelete")
	if (obj) obj.onclick=DeleteHandler;
	var obj=document.getElementById("btnSearch")
	if (obj) obj.onclick=SearchHandler;
	var obj=document.getElementById("btnClear")
	if (obj) obj.onclick=ClearHandler;
	
}

function SearchHandler()
{
	btnSearch_click();
}

function ClearHandler()
{	
	var obj=document.getElementById('txtClientId');
	obj.value="";

	var obj=document.getElementById('txtClientIP');
	obj.value="";
	
	var obj=document.getElementById('txtClientName');
	obj.value="";

	var obj=document.getElementById('txtServerName');
	obj.value="";
	
	var obj=document.getElementById('txtServerId');
	obj.value="";

	var obj=document.getElementById('txtClientPortNo');
	obj.value="";

	var obj=document.getElementById('txtClientScreenNo');
	obj.value="";

	var obj=document.getElementById('txtClientScreenColorNo');
	obj.value="";

	var obj=document.getElementById('txtClientShowMode');
	obj.value="";

	var obj=document.getElementById('txtClientShowSpeed');
	obj.value="";

	var obj=document.getElementById('txtClientShowTime');
	obj.value="";
	
	var obj=document.getElementById('txtClientLinkRoom');
	obj.value="";
	
	var obj=document.getElementById('txtClientLinkRoomId');
	obj.value="";

	var obj=document.getElementById('txtClientLinkDoc');
	obj.value="";
	
	var obj=document.getElementById('txtClientLinkDocId');
	obj.value="";
	
	var obj=document.getElementById('txtClientNote');
	obj.value="";
	
	var obj=document.getElementById('UserId');
	obj.value="";

	var obj=document.getElementById('txtClientTopIP');
	obj.value="";
	
	var obj=document.getElementById('txtClientTopDesc');
	obj.value="";

	var obj=document.getElementById('txtLocTopIP');
	obj.value="";
	
	var obj=document.getElementById('txtLocTopDesc');
	obj.value="";

	var obj=document.getElementById('txtClientVoiceTopIP');
	obj.value="";
}

function AddHandler()
{
	var obj=document.getElementById('txtClientIP');
	var ClientIP=obj.value;
	if(ClientIP==""){
		alert("请填写IP地址");
		return;
		}
	
	var obj=document.getElementById('txtClientName');
	var ClientName=obj.value;
	if(ClientName==""){
		alert("请填写名称");
		return;
		}

	var obj=document.getElementById('txtServerName');
	var ServerName=obj.value;
	
	var obj=document.getElementById('txtServerId');
	var ServerId=obj.value;
	if(ServerName=="") ServerId="";
	if(ServerId==""){
		alert("请选择关联服务器");
		return;
		}
	
	var obj=document.getElementById('txtClientPortNo');
	var ClientPortNo=obj.value;
	if(ClientPortNo==" ") ClientPortNo="";
	//if(ClientPortNo=="") return;

	var obj=document.getElementById('txtClientScreenNo');
	var ClientScreentNo=obj.value;
	if(ClientScreentNo==" ") ClientScreentNo="";
	//if(ClientScreentNo=="") return;
	
	var obj=document.getElementById('txtClientScreenColorNo');
	var ClientScreenColorNo=obj.value;
	if(ClientScreenColorNo==" ") ClientScreenColorNo="";
	//if(ClientScreenColorNo=="") return;
	
	var obj=document.getElementById('txtClientShowMode');
	var ClientShowMode=obj.value;
	if(ClientShowMode==" ") ClientShowMode="";
	//if(ClientShowMode=="") return;

	var obj=document.getElementById('txtClientShowSpeed');
	var ClientShowSpeed=obj.value;
	if(ClientShowSpeed==" ") ClientShowSpeed="";
	//if(ClientShowSpeed=="") return;

	var obj=document.getElementById('txtClientShowTime');
	var ClientShowTime=obj.value;
	if(ClientShowTime==" ") ClientShowTime="";
	//if(ClientShowTime=="") return;
	
	var obj=document.getElementById('txtClientLinkRoom');
	var ClientLinkRoom=obj.value;
	if(ClientLinkRoom==" ") ClientLinkRoom="";
	
	var obj=document.getElementById('txtClientLinkRoomId');
	var ClientLinkRoomId=obj.value;
	if(ClientLinkRoom=="") ClientLinkRoomId="";

	var obj=document.getElementById('txtClientLinkDoc');
	var ClientLinkDoc=obj.value;
	
	var obj=document.getElementById('txtClientLinkDocId');
	var ClientLinkDocId=obj.value;
	if(ClientLinkDoc=="") ClientLinkDocId="";
	
	
	var obj=document.getElementById('txtClientNote');
	if(obj)
	{
		var ClientNote=obj.value;
		if((obj.value=="")||(obj.value==" ")) ClientNote="";
	}
	else ClientNote=""

	//var obj=document.getElementById('txtClientNote');
	//if(obj)
	//{
	//	if((obj.value=="")||(obj.value==" ")) ClientNote="";
	//}
	
	var obj=document.getElementById('UserId');
	if(obj) UserId=obj.value;
	else UserId="";

	var obj=document.getElementById('txtClientTopIP');
	if(obj)
	{
		var ClientTopIP=obj.value;
		if(ClientTopIP==" ") ClientTopIP="";
	}
	else ClientTopIP=""

	var obj=document.getElementById('txtClientTopDesc');
	if(obj)
	{
		var ClientTopDesc=obj.value;
		if(ClientTopDesc==" ") ClientTopDesc="";
	}
	else ClientTopDesc=""

	var obj=document.getElementById('txtLocTopIP');
	if(obj)
	{
		var LocTopIP=obj.value;
		if(LocTopIP==" ") LocTopIP="";
	}
	else LocTopIP=""

	var obj=document.getElementById('txtLocTopDesc');
	if(obj)
	{
		var LocTopDesc=obj.value;
		if(LocTopDesc==" ") LocTopDesc="";
	}
	else LocTopDesc=""

	var obj=document.getElementById('txtClientVoiceTopIP');
	if(obj)
	{
		var ClientVoiceTopIP=obj.value;
		if(ClientVoiceTopIP==" ") ClientVoiceTopIP="";
	}
	else ClientVoiceTopIP=""
		
	var obj=document.getElementById('MethodInsert');
	if(obj)
	{
		var objInsert=obj.value;
		var retStr=cspRunServerMethod(objInsert,ClientIP,ClientName,ServerId,ClientPortNo,ClientScreentNo,ClientScreenColorNo,ClientShowMode,ClientShowSpeed,ClientShowTime,ClientLinkRoomId,ClientLinkDocId,ClientNote,UserId,ClientTopIP,ClientTopDesc,LocTopIP,LocTopDesc,ClientVoiceTopIP);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnAdd_click();
	}
	
}

function UpdateHandler()
{
	var obj=document.getElementById('txtClientId');
	var ClientId=obj.value;
	if(ClientId=="") return;

	var obj=document.getElementById('txtClientIP');
	var ClientIP=obj.value;
	if(ClientIP=="") return;
	
	var obj=document.getElementById('txtClientName');
	var ClientName=obj.value;
	if(ClientName=="") return;

	var obj=document.getElementById('txtServerName');
	var ServerName=obj.value;
	
	var obj=document.getElementById('txtServerId');
	var ServerId=obj.value;
	if(ServerName=="") ServerId="";
	if(ServerId=="") return;

	var obj=document.getElementById('txtClientPortNo');
	var ClientPortNo=obj.value;
	if(ClientPortNo==" ") ClientPortNo="";
	//if(ClientPortNo=="") return;

	var obj=document.getElementById('txtClientScreenNo');
	var ClientScreentNo=obj.value;
	if(ClientScreentNo==" ") ClientScreentNo="";
	//if(ClientScreentNo=="") return;

	var obj=document.getElementById('txtClientScreenColorNo');
	var ClientScreenColorNo=obj.value;
	if(ClientScreenColorNo==" ") ClientScreenColorNo="";
	//if(ClientScreenColorNo=="") return;

	var obj=document.getElementById('txtClientShowMode');
	var ClientShowMode=obj.value;
	if(ClientShowMode==" ") ClientShowMode="";
	//if(ClientShowMode=="") return;

	var obj=document.getElementById('txtClientShowSpeed');
	var ClientShowSpeed=obj.value;
	if(ClientShowSpeed==" ") ClientShowSpeed="";
	//if(ClientShowSpeed=="") return;

	var obj=document.getElementById('txtClientShowTime');
	var ClientShowTime=obj.value;
	if(ClientShowTime==" ") ClientShowTime="";
	//if(ClientShowTime=="") return;
	
	var obj=document.getElementById('txtClientLinkRoom');
	var ClientLinkRoom=obj.value;
	if(ClientLinkRoom==" ") ClientLinkRoom="";
	
	var obj=document.getElementById('txtClientLinkRoomId');
	var ClientLinkRoomId=obj.value;
	if(ClientLinkRoom=="") ClientLinkRoomId="";

	var obj=document.getElementById('txtClientLinkDoc');
	var ClientLinkDoc=obj.value;
	
	var obj=document.getElementById('txtClientLinkDocId');
	var ClientLinkDocId=obj.value;
	if(ClientLinkDoc=="") ClientLinkDocId="";
	//ClientLinkDocId=ClientLinkDoc
	
	// txtClientNoteId 非此元素，应为 txtClientNote
	//var obj=document.getElementById('txtClientNoteId');
	//if(obj)
	//{
		//var ClientNote=obj.value;
		//if(ClientNote==" ") ClientNote="";
	//}
	//else ClientNote=""

	var obj=document.getElementById('txtClientNote');
	if(obj)
	{
		var ClientNote=obj.value;
		if((obj.value=="")||(obj.value==" ")) ClientNote="";
	}
	else ClientNote=""
	
	var obj=document.getElementById('UserId');
	if(obj) UserId=obj.value;
	else UserId="";

	var obj=document.getElementById('txtClientTopIP');
	if(obj)
	{
		var ClientTopIP=obj.value;
		if(ClientTopIP==" ") ClientTopIP="";
	}
	else ClientTopIP=""
	
	var obj=document.getElementById('txtClientTopDesc');
	if(obj)
	{
		var ClientTopDesc=obj.value;
		if(ClientTopDesc==" ") ClientTopDesc="";
	}
	else ClientTopDesc=""

	var obj=document.getElementById('txtLocTopIP');
	if(obj)
	{
		var LocTopIP=obj.value;
		if(LocTopIP==" ") LocTopIP="";
	}
	else LocTopIP=""
	
	var obj=document.getElementById('txtLocTopDesc');
	if(obj)
	{
		var LocTopDesc=obj.value;
		if(LocTopDesc==" ") LocTopDesc="";
	}
	else LocTopDesc=""

	var obj=document.getElementById('txtClientVoiceTopIP');
	if(obj)
	{
		var ClientVoiceTopIP=obj.value;
		if(ClientVoiceTopIP==" ") ClientVoiceTopIP="";
	}
	else ClientVoiceTopIP=""
	
	var obj=document.getElementById('MethodUpdate');
	if(obj)
	{
		var objUpdate=obj.value;
		var retStr=cspRunServerMethod(objUpdate,ClientId,ClientIP,ClientName,ServerId,ClientPortNo,ClientScreentNo,ClientScreenColorNo,ClientShowMode,ClientShowSpeed,ClientShowTime,ClientLinkRoomId,ClientLinkDocId,ClientNote,UserId,ClientTopIP,ClientTopDesc,LocTopIP,LocTopDesc,ClientVoiceTopIP);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnAdd_click();
	}
}

function DeleteHandler()
{
	var obj=document.getElementById('txtClientId');
	var ClientId=obj.value;
	if(ClientId=="") return;
	var obj=document.getElementById('MethodDelete');
	if(obj)
	{
		var objDelete=obj.value;
		var retStr=cspRunServerMethod(objDelete,ClientId);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnDelete_click();
	}
}

function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCVISVoiceClientSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('txtClientId');
	var SelRowObj=document.getElementById('ClientIdz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.value;
	
	var obj=document.getElementById('txtClientIP');
	var SelRowObj=document.getElementById('ClientIPz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText;
	
	var obj=document.getElementById('txtClientName');
	var SelRowObj=document.getElementById('ClientNamez'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText;

	var obj=document.getElementById('txtServerName');
	var SelRowObj=document.getElementById('ServerNamez'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText.replace(" ","");
	
	var obj=document.getElementById('txtServerId');
	var SelRowObj=document.getElementById('ServerIdz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.value;
	
	var obj=document.getElementById('txtClientLinkRoom');
	var SelRowObj=document.getElementById('ClientLinkRoomz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText.replace(" ","");
	
	var obj=document.getElementById('txtClientLinkRoomId');
	var SelRowObj=document.getElementById('ClientLinkRoomIdz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.value;

	var obj=document.getElementById('txtClientLinkDoc');
	var SelRowObj=document.getElementById('ClientLinkDocz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText.replace(" ","");

	var obj=document.getElementById('txtClientLinkDocId');
	var SelRowObj=document.getElementById('ClientLinkDocIdz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.value;
	
	var obj=document.getElementById('txtClientPortNo');
	var SelRowObj=document.getElementById('ClientPortNoz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText.replace(" ","");

	var obj=document.getElementById('txtClientNote');
	//alert(obj.value);
	var SelRowObj=document.getElementById('ClientNotez'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText.replace(" ","");

	//var obj=document.getElementById('txtClientNoteId');
	//var SelRowObj=document.getElementById('ClientNoteIdz'+selectrow);
	//if(obj&&SelRowObj) obj.value=SelRowObj.value;

	var obj=document.getElementById('txtClientScreenNo');
	var SelRowObj=document.getElementById('ClientScreenNoz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText.replace(" ","");

	var obj=document.getElementById('txtClientScreenColorNo');
	var SelRowObj=document.getElementById('ClientScreenColorNoz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText.replace(" ","");

	var obj=document.getElementById('txtClientShowMode');
	var SelRowObj=document.getElementById('ClientShowModez'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText.replace(" ","");

	var obj=document.getElementById('txtClientShowSpeed');
	var SelRowObj=document.getElementById('ClientShowSpeedz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText.replace(" ","");

	var obj=document.getElementById('txtClientShowTime');
	var SelRowObj=document.getElementById('ClientShowTimez'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText.replace(" ","");

	var obj=document.getElementById('txtExaBoroughId');
	var SelRowObj=document.getElementById('ExaBoroughIdz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.value;

	var obj=document.getElementById('txtClientTopIP');
	var SelRowObj=document.getElementById('ClientTopIPz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText.replace(" ","");

	var obj=document.getElementById('txtClientTopDesc');
	var SelRowObj=document.getElementById('ClientTopDescz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText;	

	var obj=document.getElementById('txtLocTopIP');
	var SelRowObj=document.getElementById('LocTopIPz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText.replace(" ","");	

	var obj=document.getElementById('txtLocTopDesc');
	var SelRowObj=document.getElementById('LocTopDescz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText;

	var obj=document.getElementById('txtClientVoiceTopIP');	
	var SelRowObj=document.getElementById('ClientVoiceTopIPz'+selectrow);
	if(obj&&SelRowObj) obj.value=SelRowObj.innerText.replace(" ","");	
}
function ServerSelect(str){
	//alert(str);
	var ret=str.split("^");
	var obj=document.getElementById('txtServerName');
	if (obj) obj.value=ret[2]
	var obj=document.getElementById('txtServerId');
	if (obj) obj.value=ret[0]
	var obj=document.getElementById('txtExaBoroughId');
	if (obj) obj.value=ret[4]
}
function ExaRoomSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtClientLinkRoom');
	if (obj) obj.value=ret[1]
	var obj=document.getElementById('txtClientLinkRoomId');
	if (obj) obj.value=ret[0]
}
function WindowSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtClientLinkRoom');
	if (obj) obj.value=ret[2]
	var obj=document.getElementById('txtClientLinkRoomId');
	if (obj) obj.value=ret[3]
}
function LocSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtClientLinkDoc');
	if (obj) obj.value=ret[1]
	var obj=document.getElementById('txtClientLinkDocId');
	if (obj) obj.value=ret[0]
}
function QueueTypeSelect(str){
	//alert(str);
	var ret=str.split("^");
	var obj=document.getElementById('txtClientNote');
	if (obj) obj.value=ret[2]
	var obj=document.getElementById('txtClientNoteId');
	if (obj) obj.value=ret[0]
}

window.document.body.onload=BodyLoadHandler;