//DHCPAPregDelBabyScreen.JS
var EpisodeID=document.getElementById("EpisodeID").value;
var BabyID=document.getElementById("BabyID").value;
function BodyLoadHandler() {
    //alert("EpisodeID="+EpisodeID+"BabyID="+BabyID); 
	var objScreenDate=document.getElementById("ScreenDate");
	var objScreenTime=document.getElementById("ScreenTime");
	var CurDate=document.getElementById("curDate").value;
	var CurTime=document.getElementById("curTime").value;	
	var objBinauralFlag=document.getElementById("BinauralFlag");
	var objLeftEarFlag=document.getElementById("LeftEarFlag");
	var objRightEarFlag=document.getElementById("RightEarFlag");

    var objGetBabySreen=document.getElementById("GetBabySreen");
    if ((objGetBabySreen)&&(objGetBabySreen.value!="")){
	    var retStr=cspRunServerMethod(objGetBabySreen.value,EpisodeID,BabyID);
	    var retArray=retStr.split("^");
	    if(retArray.length>4) {
		    if (objScreenDate){
			    if (retArray[0]!="") objScreenDate.value=retArray[0];
			    else objScreenDate.value=CurDate;
		    }
		    if (objScreenTime){
			    if (retArray[1]!="") objScreenTime.value=retArray[1];
			    else  objScreenTime.value=CurTime;
		    }
		    if ((objBinauralFlag)&&(retArray[2]!="N")) objBinauralFlag.checked=true;
		    if ((objLeftEarFlag)&&(retArray[3]!="N")) objLeftEarFlag.checked=true;
		    if ((objRightEarFlag)&&(retArray[4]!="N")) objRightEarFlag.checked=true;    
	    }
	}
    var obj=document.getElementById("btnSave");
	if (obj) {obj.onclick=btnSave_Click;}	
	var obj=document.getElementById("BinauralFlag");
	if (obj) {obj.onclick=BinauralFlag_Click;}	
	var obj=document.getElementById("LeftEarFlag");
	if (obj) {obj.onclick=LeftEarFlag_Click;}	
	var obj=document.getElementById("RightEarFlag");
	if (obj) {obj.onclick=RightEarFlag_Click;}
}
function BinauralFlag_Click() {
	var objBinauralFlag=document.getElementById("BinauralFlag");
	var objLeftEarFlag=document.getElementById("LeftEarFlag");
	var objRightEarFlag=document.getElementById("RightEarFlag");
	var flag=objBinauralFlag.checked;
	objLeftEarFlag.checked=flag;
	objRightEarFlag.checked=flag;
}
function LeftEarFlag_Click() {
	var objBinauralFlag=document.getElementById("BinauralFlag");
	var objLeftEarFlag=document.getElementById("LeftEarFlag");
	var objRightEarFlag=document.getElementById("RightEarFlag");
	if (objLeftEarFlag.checked==false) objBinauralFlag.checked=false;
	else {
		if (objRightEarFlag.checked==true) 	objBinauralFlag.checked=true;
	}
}
function RightEarFlag_Click() {
	var objBinauralFlag=document.getElementById("BinauralFlag");
	var objLeftEarFlag=document.getElementById("LeftEarFlag");
	var objRightEarFlag=document.getElementById("RightEarFlag");
	if (objRightEarFlag.checked==false) objBinauralFlag.checked=false;
	else {
		if (objLeftEarFlag.checked==true) 	objBinauralFlag.checked=true;
	}
}
function btnSave_Click() {
    //alert("EpisodeID="+EpisodeID+"BabyID="+BabyID); 
    var ScreenDate="",ScreenTime="",BinauralFlag="Y",LeftEarFlag="Y",RightEarFlag="Y";
    var objScreenDate=document.getElementById("ScreenDate");
    if (objScreenDate) ScreenDate=objScreenDate.value;
	var objScreenTime=document.getElementById("ScreenTime");
    if (objScreenTime) ScreenTime=objScreenTime.value;
	if (!IsValidTime(document.getElementById('ScreenTime'))){
		alert("请输入正确的时间")
		return;
	}
	var objBinauralFlag=document.getElementById("BinauralFlag");
	if ((objBinauralFlag)&&(objBinauralFlag.checked==false)) var BinauralFlag="N";
	var objLeftEarFlag=document.getElementById("LeftEarFlag");
	if ((objLeftEarFlag)&&(objLeftEarFlag.checked==false)) var LeftEarFlag="N";
	var objRightEarFlag=document.getElementById("RightEarFlag");
	if ((objRightEarFlag)&&(objRightEarFlag.checked==false)) var RightEarFlag="N";
    var Para=ScreenDate+"^"+ScreenTime+"^"+BinauralFlag+"^"+LeftEarFlag+"^"+RightEarFlag;
    var objSaveBabySreen=document.getElementById("SaveBabySreen");
    //alert(EpisodeID+"@"+BabyID+"@"+Para);
    if ((objSaveBabySreen)&&(objSaveBabySreen.value!="")){
	    var retStr=cspRunServerMethod(objSaveBabySreen.value,EpisodeID,BabyID,Para);
	    if(retStr!="0") {
		    alert(retStr);
		    return;
	    }
	    else {
			alert(t['val:success']);
			//return;
			//var lnk="websys.close.csp";
			//window.location=lnk;
			window.close();			    
		}
    }
    if(window.opener){
    	window.opener.location.reload()
    }
    
    
}	
document.body.onload = BodyLoadHandler;