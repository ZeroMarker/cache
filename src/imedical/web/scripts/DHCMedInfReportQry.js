function GetChinese(MethodName,Ind){
	var strMethod = document.getElementById(MethodName).value;
	var ret = cspRunServerMethod(strMethod,Ind);
	var tmp=ret.split("^");
	return tmp;
}
var tmpList=GetChinese("MethodGetChinese","DHCMedEpdReportQry");

var objLogUser   ///=new clsLogUser("");

function BodyLoadHandler() {
	iniForm();
	var obj=document.getElementById("bQuery");
	if (obj){ obj.onclick=Query_click;}
	var obj=document.getElementById("cDep");
	if (obj){ obj.onchange=AddCtLoc;}
	GetUser();
	SetDefaultDep();
	}
function iniForm() {
	
	var obj=document.getElementById("cDep");
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;
	  }
	var obj=document.getElementById("cLoc");
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;
	  }
	var obj=document.getElementById("cStatus");
	if (obj){
	  obj.size=4; 
	  }
	AddDep();
	AddStatus();
	}
	
function Query_click() {
    var cDateFrom=gGetObjValue("cDateFrom");
    var cDateTo=gGetObjValue("cDateTo");
    var cDep=gGetListData("cDep");
    var cLoc=gGetListData("cLoc");
    var cStatus=gGetListCodes("cStatus")
    if (cStatus=="") return;
    lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedInfReportList" + "&DateFrom=" + cDateFrom + "&DateTo=" +cDateTo+ "&Dep=" +cDep+ "&Loc=" +cLoc+ "&Status=" +cStatus;
    parent.frames[1].location.href=lnk;

	}

function AddDep(){
	gClearAllList("cDep");
	s=gGetObjValue("tmpcDep");
	var objDic=BASE_GetDep(s);
	if (objDic.Count>0){
		gSetListValue("cDep",tmpList[0],"");
		gSetListValue("cLoc",tmpList[1],"");
		} 
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("cDep",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Rowid)
	    }
	gSetListIndex("cDep",0);
	gSetListIndex("cLoc",0);
	}
function AddCtLoc(){
	gClearAllList("cLoc");
	s=gGetObjValue("tmpcLoc");
	var depRowid=gGetListData("cDep")
	gSetListValue("cLoc",tmpList[1],"");
	gSetListIndex("cLoc",0);
	if (depRowid=="") return;
	var objDic=BASE_GetLoc(s,depRowid);
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("cLoc",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Rowid)
	    }
	}
function AddStatus(){
	gClearAllList("cStatus");
	s=gGetObjValue("tmpDictionary");
	var objDic=BASE_GetDictionary(s,"InfectionReportStatus","Y");
	//alert(objDic.Count);
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("cStatus",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Code)
	    gSetListIndex("cStatus",i);
	    }
	}
	
function SetDefaultDep(){
	
	var obj=document.getElementById("cDep");
	//alert(obj.options.length);
	//alert(obj.options[1].text);
	//if (obj.options.length==0) break;
	for (i=0;i<obj.options.length-1;i++){
		if (obj.options[i].value==objLogUser.CDep.Rowid){
			obj.options[i].selected=true;
			
			//update by zf 2008-08-11
			//obj.disabled=true;
			var tmpPower=GetUserPower();
		        switch (tmpPower){
		        	case "Super":{
		        		obj.disabled=false;
		        		break;
		        	}
		        	case "ReportEpidemic":{
		        		obj.disabled=true;
		        		break;
		        	}
		        	case "AuditEpidemicReport":{
		        		obj.disabled=false;
		        		break;
		        	}
		        	default:{
		        		obj.disabled=true;
		        		break;
		        	}
		        }
			break;
		}
	}
}

function GetUser() {
	//update by zf 2008-08-11
	//objLogUser=BASE_GetLogUser(gGetObjValue("txtLogUserInfo"),gGetObjValue("userid"),session['LOGON.GROUPID'],session['LOGON.CTLOCID']);
	objLogUser=BASE_GetLogUser(gGetObjValue("txtLogUserInfo"),session['LOGON.USERID'],session['LOGON.GROUPID'],session['LOGON.CTLOCID']);
}
    
    
//add by zf 2008-08-11
function GetUserPower(){
	var encmeth=gGetObjValue("MethodUserFunction");
	var sModule="DHCMedInfection";
	var SuperCode=BASE_UserFunction(encmeth,objLogUser.SGroup.Rowid,sModule,"Super");
	var RepCode=BASE_UserFunction(encmeth,objLogUser.SGroup.Rowid,sModule,"ReportEpidemic");
	var EditCode=BASE_UserFunction(encmeth,objLogUser.SGroup.Rowid,sModule,"AuditEpidemicReport");
	if (SuperCode=="0") return "Super";
	if (RepCode=="0") return "ReportEpidemic";
	if (EditCode=="0") return "AuditEpidemicReport";
	return "";
}

document.body.onload = BodyLoadHandler;