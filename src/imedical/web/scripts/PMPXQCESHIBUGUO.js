//测试需求不通过处理
//2014-11-11
//张枕平
var userId=session['LOGON.USERID'];
var username=session['LOGON.USERNAME']
var locid=session['LOGON.CTLOCID']
function BodyLoadHandler(){
	var obj=document.getElementById('QUEDING');
	if (obj){ obj.onclick=QUEDING_click;}
	var obj=document.getElementById('QUXIAO');
	if (obj){ obj.onclick=QUXIAO_click;}
	}
function QUEDING_click(){
	var QXYY=document.getElementById('QXYY').value;
	if(QXYY=="")
	{
		alert(t["tishi"]);
		return;
		}
	var objRowid=tkMakeServerCall("web.PMP.ImproventFindShenhe","Huoqushujv",userId);
	var VerStr=tkMakeServerCall("web.PMP.ImproventFindShenhe","CESHIBUTONGGUOCHULI",objRowid,userId,QXYY);
	alert(t[VerStr]);
	window.close();
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=PMPImprovementListNew";
    location.href=lnk;
	}
function QUXIAO_click(){
	window.close();
	}
document.body.onload = BodyLoadHandler;