//By    ljw20081230
//document.write("<object ID='ClsAlert' CLASSID='CLSID:B080649D-D704-49F0-BBC1-B5B7A9A351E2' CODEBASE='../addins/client/OrdAlert.CAB#version=1,0,0,0'>");
//document.write("</object>");
var OrdAlert;//alert new order object
//var Ico;
//OrdAlert= new ActiveXObject("Ico.clsnot");//TestAx.CLSMAIN

var EpisodeID=document.getElementById("EpisodeID").value;

var SelectedRow = 0;
var preRowInd=0;
function BodyLoadHandler(){
	var obj=document.getElementById('BADD')
	if(obj) obj.onclick=BADD_click;
}

function BADD_click(){
	var obj=document.getElementById('EpisodeID')
	if(obj) var AdmDR=obj.value;
	if(AdmDR==""){
		alert(t['01']) 
		return;
		}
	var Status='L';
	if(Status==""){
		alert(t['02']) 
		return;
		}
	var obj=document.getElementById('LaborDate')
	if(obj) var LaborDate=obj.value;
	if(LaborDate==""){
		alert(t['03']) 
		return;
		}
	if(IsValidDate(obj)!=1){
		alert("日期不对,请输入有效日期!")
		return;
	}
	var obj=document.getElementById('LaborTime')
	if(obj) var LaborTime=obj.value;
	if(LaborTime==""){
		alert(t['04']) 
		return;
		}
	if(IsValidTime(obj)!=1){
		alert("时间不对,请输入有效时间!")
		return;
	}
	var obj=document.getElementById('InsertProcDelivery')
	if(obj) var encmeth=obj.value;
	var rtn=cspRunServerMethod(encmeth,AdmDR,Status,LaborDate,LaborTime,session['LOGON.USERID'])
    //if (cspRunServerMethod(encmeth,AdmDR,Status,LaborDate,LaborTime)!='0')
	//	{alert(t['baulk']);
	//	return;}
	if (rtn!=0){	
		alert(rtn);
		return;
	 }
	 
	if (rtn==0){
		 alert(t['succeed']);	
	}
	
	/*
	if (rtn!=0)	
		alert(rtn);
		return;
     			
	try {	
	    alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
		*/
}
     
document.body.onload=BodyLoadHandler;