function Query_click() {
    var cDateFrom=gGetObjValue("cDateFrom");
    var cDateTo=gGetObjValue("cDateTo");
    var cInjReason=gGetListData("InjReason");
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedInjReportList" + "&DateFrom=" + cDateFrom + "&DateTo=" +cDateTo+ "&InjReason=" +cInjReason;
    parent.frames[1].location.href=lnk;
	}
	
function AddInjReason(){
	gClearAllList("InjReason");
	s=gGetObjValue("txtGetInjReason");
	var objDic=BASE_GetDictionary(s,"InjReason","Y");
	if (objDic.Count>0){
		gSetListValue("InjReason","","all");
		} 
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("InjReason",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Rowid)
	    }
	gSetListIndex("InjReason",0);
	}
	
function iniForm() {
	
	var obj=document.getElementById("InjReason");
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;
	  }
	AddInjReason();
	}
function BodyLoadHandler() {
	iniForm();
	var obj=document.getElementById("bQuery");
	if (obj){ obj.onclick=Query_click;}
	}
document.body.onload = BodyLoadHandler;