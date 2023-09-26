//信息科需求分配人员
//2015-1-26
//shenbo
var userId=session['LOGON.USERID'];
var username=session['LOGON.USERNAME']
var locid=session['LOGON.CTLOCID']
var admdepobj=document.getElementById('User');
if (admdepobj) admdepobj.onkeydown=getadmdep1; 
function BodyLoadHandler(){
	var obj=document.getElementById('QUEREN');
	if (obj){ obj.onclick=QUEREN_click;}
	var obj=document.getElementById('QUXIAO');
	if (obj){ obj.onclick=QUXIAO_click;}
	}
function QUEREN_click(){
	var objUserId=document.getElementById("UserId").value;
	var objUserId1=document.getElementById("UserId1").value;
	var objBEIZU=document.getElementById("BEIZU").value;
	alert(userId)
	var objRowid=tkMakeServerCall("web.PMP.ImproventFindShenhe","Huoqushujv",userId);
	alert(objUserId+"-"+objUserId1+"-"+objRowid+"-"+userId+"-"+objBEIZU)
	var VerStr=tkMakeServerCall("web.PMP.ImproventFindShenhe","FenPeiBks",objUserId,objUserId1,objRowid,userId,objBEIZU);
	alert(t[VerStr]);
	window.opener.location.href="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementFindByHospital";
	window.close();
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementFindByHospital";
    location.href=lnk;
	}
function QUXIAO_click(){
	window.opener.location.href="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementFindByHospital";
	window.close();
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementFindByHospital";
    location.href=lnk;
	}
function SelectUser(str){
	var inci=str.split("^");
	var obj=document.getElementById("User");
	if (obj)
	{  
	   obj.value=inci[0];	
	 }
	 var obj=document.getElementById("UserId");
	 if(obj){obj.value=inci[1]}
	}
function SelectUser1(str){
	var inci=str.split("^");
	var obj=document.getElementById("User1");
	if (obj)
	{  
	   obj.value=inci[0];	
	 }
	 var obj=document.getElementById("UserId1");
	 if(obj){obj.value=inci[1]}
	}
function getadmdep1(){
	if (window.event.keyCode==13) 
	   {  
	window.event.keyCode=117;
	   User_lookuphandler();
		}
}
document.body.onload = BodyLoadHandler;