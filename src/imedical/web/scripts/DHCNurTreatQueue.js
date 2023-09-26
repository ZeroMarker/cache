//DHCNurTreatQueue.js
var selrow=0;
function BodyLoadHandler()
{
	var objtbl=document.getElementById('tDHCNurTreatQueue');
	var i=0;
    for (i=1;i<objtbl.rows.length;i++)
	{
		var eSrc=objtbl.rows[i];
		var RowObj=getRow(eSrc);
		if (RowObj) {
			var QueueState=document.getElementById("QueueStatez"+i);
			//等候(Wait)\呼叫(Call)\过号(Skip)
			//if(QueueState.innerText=="等候")  {alert(1);RowObj.className="SkinTest";}
			if(QueueState.innerText=="呼叫")  RowObj.className="Immediate";
			if(QueueState.innerText=="过号")  RowObj.className="Discontinue";
		}
	}
	var btnCallNext=document.getElementById("btnCallNext");
	if (btnCallNext) {btnCallNext.onclick=btnCallNextFn;}
	var btnSkipNum=document.getElementById("btnSkipNum");
	if (btnSkipNum) {btnSkipNum.onclick=btnSkipNumFn;}
	var btnPrior=document.getElementById("btnPrior");
	if (btnPrior) {btnPrior.onclick=btnPriorFn;}
	if (objtbl){
		objtbl.ondblclick=tbDbClick;
	}
	var Obj=document.getElementById("ClientList");
	if(Obj) LoadClientList();
	var Obj=document.getElementById("serverIP")
	if(Obj)
	{
		if(Obj.value=="")
		{
			Obj.value=GetComputerIp();
			btnSearch_click();
		}
		else
		{
			var serverIP=GetComputerIp();
			var QueueInfomation=tkMakeServerCall("web.DHCVISTreatQueue","GetQueueInfomation","",serverIP);
			var Obj=document.getElementById("QueueInfomation");
			//if(Obj) Obj.innerText=QueueInfomation
		}
	}
	ButtonDisable();


	var objIfSYCall=document.getElementById('ifSYCall');
	if(objIfSYCall){
		var btnCall=document.getElementById('btnCall');
		var btnCall=document.getElementById('btnCall');
		if(btnCall){
			btnCall.onclick=btnCallClick;
		}
		if((objIfSYCall.value!=1)&&(btnCall)){
			btnCall.style.display='none';

		}
	}
}
function btnCallClick()
{
    call(selrow);
}

function call(selrow)
{					
	var IPAddress=GetComputerIp()
	if((IPAddress!="Exception")&&(IPAddress!=""))
	{
		var IPFlag=tkMakeServerCall("web.DHCVISQueueManage","GetActiveFlag",IPAddress);
	}
	else
	{
		var IPFlag=tkMakeServerCall("web.DHCVISQueueManage","GetActiveFlag");
	}
	if (IPFlag!=0) return;
	if (selrow<1) return;
	try
	{
		var PatName=document.getElementById('PatNamez'+selrow).innerText;
		var QueNo=document.getElementById('QueueNoz'+selrow).innerText;
		if(QueNo==""){
			alert("该病人没有排队")
			return;
		}
		if((QueNo!="")||(PatName!=""))
		{

			if((IPAddress!="Exception")&&(IPAddress!=""))
			{
				var RetStr=tkMakeServerCall("web.DHCVISQueueManage","SendVoiceCallTreatQueue",QueNo,PatName,"","",IPAddress)
			}
			else
			{
				var RetStr=tkMakeServerCall("web.DHCVISQueueManage","SendVoiceCallTreatQueue",QueNo,PatName,"","")
			}
			if(RetStr!="0")
			{
				alert(RetStr)
			}
		}
	}
	catch(e)
	{
		window.location.href=window.location.href
	}
}
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	selrow=rowObj.rowIndex;
	if ((!selrow)||(selrow<1)) return;
	//Call a patient
	var PatNameLink='PatNamez'+selrow;
	if (eSrc.id==PatNameLink)	{
		var PatName=document.getElementById('PatNamez'+selrow).innerText;
		var RegNo=document.getElementById('RegNoz'+selrow).innerText;
		var TreatId=document.getElementById('TreatIdz'+selrow).innerText;
		//alert("呼叫: "+RegNo+" "+PatName+"......");
		//btnCallFn(TreatId);
		DHCAMSCall(selrow);
	}
	return false;
}
function tbDbClick()
{
    selrow=DHCWeb_GetRowIdx(window);
    if ((!selrow)||(selrow<1)) return;
	var EpisodeID=document.getElementById("EpisodeIDz"+selrow).innerText;
    if (EpisodeID=="") return;
    var admType=document.getElementById("admType").value;
    var flowFlag=document.getElementById("flowFlag").value;
    var lnk;
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPExecTitle&EpisodeID="+EpisodeID+"&admType="+admType+"&flowFlag="+flowFlag;
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
function btnCallNextFn()
{
	var objtbl=document.getElementById('tDHCNurTreatQueue');
	if (objtbl.rows.length>1) {
		for(var i=1;i<objtbl.rows.length;i++)
		{
			var Obj=document.getElementById('QueueStatez'+i);
			if(Obj)
			{
				var QueueState=Obj.innerText
				if(QueueState!="呼叫")
				{
					DHCAMSCall(i);
					i=objtbl.rows.length
				}
			}
		}
		/*
		var selectRow=1;
	   	var PatName=document.getElementById('PatNamez'+selectRow).innerText;
		var RegNo=document.getElementById('RegNoz'+selectRow).innerText;
		var TreatId=document.getElementById('TreatIdz'+selectRow).innerText;
		//alert("呼叫: "+RegNo+" "+PatName+"......");
		//btnCallFn(TreatId);
		DHCAMSCall(selectRow);*/
	}
}
function btnArriveFn()
{
	var TreatId=GetSelTreatId();
	if (TreatId=="") return;
	var objTreatSave=document.getElementById("TreatSave");
 	if (objTreatSave) {
		var userId=session['LOGON.USERID'];
		var parr="^TreatRecUser|"+userId+"^TreatQueState|Finish^TreatQuePrior|2";
		var resStr=cspRunServerMethod(objTreatSave.value,TreatId,parr);
    	if (resStr!=0) {
	    	alert(resStr);
	    	return;
    	}
    	else {
	    	RefreshFn();
    	}
 	}
}
function UpdateTreatState(TreatId,State)
{
	var objTreatSave=document.getElementById("TreatSave");
 	if (objTreatSave) {
		var userId=session['LOGON.USERID'];
		var parr="^TreatRecUser|"+userId+"^TreatQueState|"+State;
		var retStr=cspRunServerMethod(objTreatSave.value,TreatId,parr);
    	if (retStr!=0) {
	    	alert(retStr);
    	}
 	}
}
function GetSelTreatId(){	
	var ret="";
	if ((!selrow)||(selrow<1)) {
	    alert(t['alert:selectpat']);
	    return "";
    }
	var TreatId=document.getElementById("TreatIdz"+selrow).innerText;
    if (TreatId=="") {
		alert(t['alert:selectpat']);
	    return "";    
	}
	return TreatId;
}
function btnSkipNumFn()
{
	var TreatId=GetSelTreatId();
	if (TreatId=="") return;
	var truthConfirm = window.confirm("请再次确认是否将病人过号?");
	if(!truthConfirm){return;}
	var objTreatSave=document.getElementById("TreatSave");
 	if (objTreatSave) {
		var userId=session['LOGON.USERID'];
		var parr="^TreatRecUser|"+userId+"^TreatQueState|Skip^TreatQuePrior|3";
		var resStr=cspRunServerMethod(objTreatSave.value,TreatId,parr);
    	if (resStr!=0) {
	    	alert(resStr);
	    	return;
    	}
    	else {
	    	RefreshFn();
    	}
 	}
}
function btnPriorFn()
{
    var TreatId=GetSelTreatId();
    if (TreatId=="") return;
	var truthConfirm = window.confirm("请再次确认是否将病人优先?");
	if(!truthConfirm){return;}
	var objTreatSave=document.getElementById("TreatSave");
 	if (objTreatSave) {
		var userId=session['LOGON.USERID'];
		var parr="^TreatRecUser|"+userId+"^TreatQuePrior|1";
		var resStr=cspRunServerMethod(objTreatSave.value,TreatId,parr);
    	if (resStr!=0) {
	    	alert(resStr);
	    	return;
    	}
    	else {
			RefreshFn();
    	}
 	}
}
function btnCallFn(TreatId)
{
	var objTreatSave=document.getElementById("TreatSave");
 	if (objTreatSave) {
		var userId=session['LOGON.USERID'];
		var parr="^TreatRecUser|"+userId+"^TreatQueState|Call";
		var resStr=cspRunServerMethod(objTreatSave.value,TreatId,parr);
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
}
function DHCAMSCall(selrow)
{
	var IPAddress=GetComputerIp()
	if((IPAddress!="Exception")&&(IPAddress!=""))
	{
		var IPFlag=tkMakeServerCall("web.DHCVISQueueManage","GetActiveFlag",IPAddress);
	}
	else
	{
		var IPFlag=tkMakeServerCall("web.DHCVISQueueManage","GetActiveFlag");
	}
	if (IPFlag != 0) {
		alert(IPFlag);
		return;
	}
	if (selrow<1) return;
	try
	{
		var PatName=document.getElementById('PatNamez'+selrow).innerText;
		var QueNo=document.getElementById('QueueNoz'+selrow).innerText;
		var TreatId=document.getElementById('TreatIdz'+selrow).innerText;
		
		if((QueNo!="")||(PatName!=""))
		{
			var waitPatStr=GetWaitPat(selrow)
			var readyPatStr=""
			if(waitPatStr.split("^").length>1)
			{
				readyPatStr=waitPatStr.split("^")[1]
				waitPatStr=waitPatStr.split("^")[0]	
			}
			var IPAddress=GetComputerIp()
			if((IPAddress!="Exception")&&(IPAddress!=""))
			{
				var RetStr=tkMakeServerCall("web.DHCVISQueueManage","SendVoiceCallTreatQueue",QueNo,PatName,waitPatStr,readyPatStr,IPAddress)
			}
			else
			{
				var RetStr=tkMakeServerCall("web.DHCVISQueueManage","SendVoiceCallTreatQueue",QueNo,PatName,waitPatStr,readyPatStr)
			}
			if(RetStr!="0")
			{
				alert(RetStr)
			}
			else
			{
				btnCallFn(TreatId);
			}
		}
	}
	catch(e)
	{
		RefreshFn();
	}
}
function GetWaitPat(selrow)
{
	var IPAddress=GetComputerIp();
	if((IPAddress!="Exception")&&(IPAddress!=""))
	{
		var QueType=tkMakeServerCall("web.DHCVISVoiceSet","GetServerQueType",IPAddress)
		if(QueType=="0") return "^"
	}
	var WaitPat="",ReadyPat=""
	try
	{
		if (selrow<1) return;
		var startIndex=selrow+1
		//if (selrow>1) startIndex=1
		var waitNum=2
		for(var i=startIndex;i<startIndex+waitNum;i++)
		{
			var Obj=document.getElementById('QueueStatez'+i);
			if(Obj)
			{
				var QueueState=Obj.innerText
				if((QueueState!="完成")&&(QueueState!="呼叫"))
				{
					var PatName="",QueNo="",TreatId=""
					var TreatId=document.getElementById('TreatIdz'+i).innerText;
					Obj=document.getElementById('PatNamez'+i);
					Obj=document.getElementById('PatNamez'+i);
					if(Obj)	PatName=Obj.innerText;
					Obj=document.getElementById('QueueNoz'+i);
					if(Obj)	QueNo=Obj.innerText;
					if(QueNo!="")
					{
						var State="Ready"
						if(QueueState=="等候")
						{
							var retStr=UpdateTreatState(TreatId,State)
							if(ReadyPat=="") ReadyPat=QueNo+"号,"+PatName	
							else  ReadyPat=ReadyPat+"!"+QueNo+"号,"+PatName
						}
						if(WaitPat=="") WaitPat=QueNo+"号,"+PatName	
						else  WaitPat=WaitPat+"!"+QueNo+"号,"+PatName	
					}
				}
				else
				{
					waitNum=waitNum+1
				}
			}
			else
			{
				i=startIndex+waitNum
			}
		}
	}
	catch(e)
	{
		return "^"
	}
	return WaitPat+"^"+ReadyPat;
}
function LoadClientList()
{
	var ClientStr=""
	var IPAddress=GetComputerIp()
	if((IPAddress!="Exception")&&(IPAddress!=""))
	{
		var ClientStr=tkMakeServerCall("web.DHCVISTreatQueue","GetClientStr",IPAddress)
	}
	else
	{
		var ClientStr=tkMakeServerCall("web.DHCVISTreatQueue","GetClientStr");
	}
	if(ClientStr!="")
	{
		combo_ClientList=dhtmlXComboFromStr("ClientList",ClientStr);
		combo_ClientList.enableFilteringMode(true);
		combo_ClientList.selectHandle=combo_ClientListKeydownhandler;
		combo_ClientList.keyenterHandle=combo_ClientListKeyenterhandler;
		combo_ClientList.attachEvent("onKeyPressed",combo_ClientListKeyenterhandler)
	}
	else
	{
		var Obj=document.getElementById("ClientList");
		if (Obj) Obj.style.display="none";
		var Obj=document.getElementById("cClientList");
		if (Obj) Obj.style.display="none";
	}
}
function combo_ClientListKeydownhandler(){
  var obj=combo_ClientList;
  var ClientId=obj.getActualValue();
  var ClientDesc=obj.getSelectedText();
  DHCC_SetElementData('ClientId',ClientId);
}
function combo_ClientListKeyenterhandler(e){
  try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
  if (keycode==13) {
    combo_ClientListKeydownhandler();
  }
}
function DHCC_GetElementData(ElementName){
  var obj=document.getElementById(ElementName);
  if (obj){
    if (obj.tagName=='LABEL'){
      return obj.innerText;
    }else{
      if (obj.type=='checkbox') return obj.checked;
      return obj.value;
    }
  }
  return "";
}
function DHCC_SetElementData(ElementName,value){
  var obj=document.getElementById(ElementName);
  if (obj){
    obj.value=value;
  }
  return "";
}
function GetComputerIp()
{
	var ip=tkMakeServerCall("web.DHCNurTreatQueue","getComputerIp")
	return ip;
	// var ipAddr;
	// try
	// {
	//    var obj = new ActiveXObject("rcbdyctl.Setting");
	//    ipAddr=obj.GetIPAddress;
	//    obj = null;
	// }
	// catch(e)
	// {
	//    ipAddr="Exception";
	// }
	// return ipAddr;
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
function ButtonDisable()
{
	var Obj1=document.getElementById("btnCallNext");
	var Obj2=document.getElementById("btnArrive");
	var Obj3=document.getElementById("btnPrior");
	var Obj4=document.getElementById("btnSkipNum");
	if (Obj1) Obj1.style.display="none";
	if (Obj2) Obj2.style.display="none";
	if (Obj3) Obj3.style.display="none";
	if (Obj4) Obj4.style.display="none";
	var IPAddress=GetComputerIp()
	var IPFlag=tkMakeServerCall("web.DHCVISQueueManage","GetActiveFlag",IPAddress);
	if (IPFlag==0){
		if (Obj1)
		{
			Obj1.style.display="block";
			Obj1.onclick=btnCallNextFn;
		}
		if (Obj2)
		{
			Obj2.style.display="block";
			Obj2.onclick=btnArriveFn;
		}
		if (Obj3)
		{
			Obj3.style.display="block";
			Obj3.onclick=btnPriorFn;
		}
		if (Obj4)
		{
			Obj4.style.display="block";
			Obj4.onclick=btnSkipNumFn;
		}
	}
}

document.body.onload = BodyLoadHandler;
