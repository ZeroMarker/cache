var objLogUser   ///=new clsLogUser("");

function BodyLoadHandler() {
	iniForm();
	var obj=document.getElementById("bQuery");
	if (obj){ obj.onclick=Query_click;}
	var obj=document.getElementById("cDep");
	if (obj){ obj.onclick=AddCtLoc;}
	GetUser();
	//alert(objLogUser.CDep.Code);
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
	var obj=document.getElementById("cPlace");
	if (obj){
	  obj.size=5; 
	  }
	AddDep();
	AddStatus();
	AddPlace();
	}
function Query_click() {
    var cDateFrom=gGetObjValue("cDateFrom");
    var cDateTo=gGetObjValue("cDateTo");
    var cDep=gGetListData("cDep");
    var cLoc=gGetListData("cDep");
    var cStatus=gGetListCodes("cStatus")
    var cPlace=gGetListCodes("cPlace")
    if (cStatus==""||cPlace=="") return;
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedEpdReportList" + "&DateFrom=" + cDateFrom + "&DateTo=" +cDateTo+ "&Dep=" +cDep+ "&Loc=" +cLoc+ "&Status=" +cStatus+ "&Place=" +cPlace;
    parent.frames[1].location.href=lnk;

	}
function AddDep(){
	gClearAllList("cDep");
	s=gGetObjValue("tmpcDep");
	var objDic=BASE_GetDep(s);
	if (objDic.Count>0){
		gSetListValue("cDep","全院","");
		gSetListValue("cLoc","全科","");
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
	gSetListValue("cLoc","全科","");
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
	var objDic=BASE_GetDictionary(s,"EpidemicReportStatus","Y");
	//alert(objDic.Count);
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("cStatus",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Code)
	    gSetListIndex("cStatus",i);
	    }
	}
function AddPlace(){
	gClearAllList("cPlace");
	s=gGetObjValue("tmpDictionary");
	var objDic=BASE_GetDictionary(s,"RepPlace","Y");
	var a=(new VBArray(objDic.Keys()));
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("cPlace",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Code)
	    gSetListIndex("cPlace",i);
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
	        obj.disabled=true;
			break;
			}
		}
	}

function GetUser() {
	objLogUser=BASE_GetLogUser(gGetObjValue("txtLogUserInfo"),gGetObjValue("userid"));
    }

document.body.onload = BodyLoadHandler;