//需求分配js
//2014-11-11
//zzp
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
	//alert("完成");
	var objUserId=document.getElementById("UserId").value;
	//alert(objUserId);
	var objBEIZU=document.getElementById("BEIZU").value;
	//alert(objBEIZU);
	var objRowid=tkMakeServerCall("web.PMP.ImproventFindShenhe","Huoqushujv",userId);
	//alert(objRowid);
	var VerStr=tkMakeServerCall("web.PMP.ImproventFindShenhe","FenPei",objUserId,objRowid,userId,objBEIZU);
	alert(t[VerStr]);
	window.close();
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementFindByHospital";
    location.href=lnk;
	}
function QUXIAO_click(){
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
function getadmdep1(){
	if (window.event.keyCode==13) 
	   {  
	window.event.keyCode=117;
	   User_lookuphandler();
		}
}
document.body.onload = BodyLoadHandler;