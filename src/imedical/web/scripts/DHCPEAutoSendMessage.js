
var t;
function BodyLoadHandler() {
	
	var obj;
	obj=document.getElementById("BSend");
	if (obj) obj.onclick=BSendMessage_click;
	obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_click;
	
	obj=document.getElementById("RegNo");
	if (obj) {obj.onkeydown=RegNo_KeyDown;}

	obj=document.getElementById("AutoSend");
	if (obj&&obj.checked){
		//t=setInterval("BSendMessage_click()",1000*30);
		t=setTimeout("BSendMessage_click()",1000*10);
	}
}

function RegNo_KeyDown(e){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		BFind_click();
	}
}

function BFind_click()
{
	var obj,StartDate="",EndDate="",Type="",NoSend="0",AutoSend="0",RegNo="",Name="",LocID="",Type="";
	obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	obj=document.getElementById("NoSend");
	if (obj) NoSend=obj.value;
	obj=document.getElementById("AutoSend");
	if (obj&&obj.checked) AutoSend=1;
	obj=document.getElementById("RegNo");
	if (obj) {
		RegNo=obj.value;
		if (RegNo.length<8&&RegNo.length>0) {RegNo=RegNoMask(RegNo);}
		}

	obj=document.getElementById("Name");
	if (obj) Name=obj.value;
	LocID=session['LOGON.CTLOCID'];
	obj=document.getElementById("Type");
	if (obj) Type=obj.value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEAutoSendMessage&StartDate="+StartDate+"&EndDate="+EndDate+"&AutoSend="+AutoSend+"&NoSend="+NoSend+"&RegNo="+RegNo+"&Name="+Name+"&LocID="+LocID+"&Type="+Type;
	//alert(lnk)
	window.location.href=lnk;
}
function BodyUnLoadHandler() {

	objGSM.CloseGSM();
	objGSM=null;
}
function BSendMessage_click()
{
	if (t){
		//clearInterval(t);
		clearTimeout(t)
	}
	//var objGSM;
	try {
    	objGSM=new ActiveXObject("DHCPEGSM.GSM");
	}catch (e) {
		alert("创建短信对象失败");
		return null;
	}
	if (objGSM) {
		var ret=objGSM.OpenGSM("Send");
		if (0!=ret) {
			alert("打开设备失败时发生错误:\n"+ret);

	  	}else{
			obj=document.getElementById("btnSendMessage")
			if (obj) { obj.disabled=false; }
	  	}
	}
	var Mobile="",iMessage="",encmeth="";
	var obj;
	var UserID=session['LOGON.USERID'];
	obj=document.getElementById("SendClass");
	if (obj) encmeth=obj.value;
	var objtbl=document.getElementById('tDHCPEAutoSendMessage');	//取表格元素?名称
	var rows=objtbl.rows.length;
	var ErrRows="";
	for (var i=1;i<rows;i++){
		var obj=document.getElementById("TSendz"+i);
		if (obj&&obj.checked){
			obj=document.getElementById("TTelz"+i);
			if (obj) var TelNo=obj.innerText;
			obj=document.getElementById("TContentz"+i);
			if (obj) var Content=obj.value;
			obj=document.getElementById("TIDz"+i);
			if (obj) var ID=obj.value;
			var ret=objGSM.SendMessage(TelNo,Content,"Send","+8613800100500"); //+8613010171500
			if ('0'==ret) {
				var Status=2;
			}else{
				var Status=3; 
			}
			var ret=cspRunServerMethod(encmeth,ID,Status,UserID);
		}
	}
	objGSM.CloseGSM();
	objGSM=null;
	window.location.reload();
}
document.body.onload = BodyLoadHandler;
//document.body.onunload = BodyUnLoadHandler;