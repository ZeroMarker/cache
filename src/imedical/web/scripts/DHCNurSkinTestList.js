//DHCNurSksinTestList.js
var selrow=0;
function BodyLoadHandler()
{
	var objtbl=document.getElementById('tDHCNurSkinTestList');
	var i=0;
    for (i=1;i<objtbl.rows.length;i++)
	{
		var eSrc=objtbl.rows[i];
		var RowObj=getRow(eSrc);
		if (RowObj) {
			var CurStat=document.getElementById("CurStatz"+i);
			//等待(Wait)\过20分钟查看皮试结果(Ready)\呼叫(Call)\已做皮试(Already)
			if(CurStat.value=="Ready")  RowObj.className="SkinTest";
			if(CurStat.value=="Call")  RowObj.className="TempTest";//Immediate
			if(CurStat.value=="Already")  RowObj.className="Exec";
		}
	}
	var btnCall=document.getElementById("btnCall");
	if (btnCall) {btnCall.onclick=btnCallFn;}
	var btnCancel=document.getElementById("btnCancel");
	if (btnCancel) {btnCancel.onclick=btnCancelFn;}
	if (objtbl){
		objtbl.ondblclick=tbDbClick;
	}
}
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	selrow=rowObj.rowIndex;
	if (rowObj.className=="RowOdd") selrow=null;
	if ((!selrow)||(selrow<1)) return;
	//Call a patient
	var PatNameLink='PatNamez'+selrow;
	if (eSrc.id==PatNameLink)	{
		btnCallFn();
	}
	return false;
}
function tbDbClick()
{
    selrow=DHCWeb_GetRowIdx(window);
    if ((!selrow)||(selrow<1)) return;
	var EpisodeID=document.getElementById("EpisodeIDz"+selrow).value;
    if (EpisodeID=="") return;
    var admType=document.getElementById("admType").value;
    var lnk;
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurSkinTestTitle&EpisodeID="+EpisodeID+"&admType="+admType;
    parent.frames[1].frames[0].location.href=lnk;
}
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		//alert(wobj.name);
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}
function btnCallFn() {
	if ((!selrow) || (selrow < 1)) {
		alert(t['alert:selectpat']);
		return;
	}
	var ID = document.getElementById("IDz" + selrow).value;
	if (ID == "") {
		alert(t['alert:selectpat']);
		return;
	}
	var objSave = document.getElementById("Save");
	if (objSave) {
		var PatName = document.getElementById("PatNamez" + selrow).innerText;
		var RegNo = document.getElementById("RegNoz" + selrow).innerText;
		var truthBeTold = window.confirm("呼叫: " + RegNo + " " + PatName + "......");
		if (truthBeTold) {
			var userId = session['LOGON.USERID'];
			var parr = "TestCallFlag|Y" + "^RecUser|" + userId;
			var resStr = cspRunServerMethod(objSave.value, ID, parr);
			if (resStr != 0) {
				alert(resStr);
				return;
			}
			DHCAMSCall(selrow);
			RefreshFn();

		} 
		/*else {
			var CurStat = document.getElementById("CurStatz" + selrow);
			var objtbl = document.getElementById('tDHCNurSkinTestList');
			var eSrc = objtbl.rows[selrow];
			var RowObj = getRow(eSrc);
			var ToObserveTime = CurStat = document.getElementById("ToObserveTimez" + selrow);
			if (ToObserveTime == "") {
				RowObj.className = "SkinTest";
			} else {
				RowObj.className = "RowOdd";
			}
		}*/
		//alert("请患者 "+PatName+" 到前台查看皮试结果!")
		//RefreshFn();
		////self.location.reload();

	}
}
function btnCancelFn()
{
    if ((!selrow)||(selrow<1)) {
	    alert(t['alert:selectpat']);
	    return;
    }
	var ID=document.getElementById("IDz"+selrow).value;
    if (ID=="") {
		alert(t['alert:selectpat']);
	    return;    
	}
	var truthConfirm = window.confirm("请再次确认是否撤销记录?");
	if(!truthConfirm){return;}
	var objDelete=document.getElementById("Delete");
 	if (objDelete) {
		var resStr=cspRunServerMethod(objDelete.value,ID);
    	if (resStr!=0) {
	    	alert(resStr);
	    	return;
    	}
    	else {
	    	RefreshFn();
    	}
 	}
}
function RefreshFn()
{
	btnSearch_click();
	//SkinTestMessageFn(); //DHCNurSkinTestMessage.js
}
function DHCAMSCall(selrow)
{
	if (selrow<1) return;
	try
	{
		var PatName=document.getElementById('PatNamez'+selrow).innerText;
		var QueNo=""
		if((QueNo!="")||(PatName!=""))
		{
			var waitPatStr=""
			var IPAddress=GetComputerIp()
			if((IPAddress!="Exception")&&(IPAddress!=""))
			{
				var RetStr=tkMakeServerCall("web.DHCVISQueueManage","SendVoiceTestSkinQueue",PatName,waitPatStr,IPAddress)
			}
			else
			{
				var RetStr=tkMakeServerCall("web.DHCVISQueueManage","SendVoiceTestSkinQueue",PatName,waitPatStr)
			}
		}
	}
	catch(e)
	{
	}
}

function GetComputerIp()
{
	var ipAddr;
	try
	{
	   var obj = new ActiveXObject("rcbdyctl.Setting");
	   ipAddr=obj.GetIPAddress;
	   obj = null;
	}
	catch(e)
	{
	   ipAddr="Exception";
	}
	return ipAddr;
}
function GetComputerName()
{
	var computerName;
	try
	{
	   var WshNetwork=new ActiveXObject("WScript.Network"); 
	   computerName=WshNetwork.ComputerName;
	   WshNetwork = null;
	}
	catch(e)
	{
	   computerName="Exception";
	}
	return computerName;
}
setTimeout(RefreshFn,60000);		//1000=1秒
document.body.onload = BodyLoadHandler;
