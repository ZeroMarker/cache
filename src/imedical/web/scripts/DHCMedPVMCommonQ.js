//DHCMedPVMCommonQ.js
function BodyLoadHandler()
{
	initForm();
	var obj=document.getElementById("bQuery");
	if (obj){ obj.onclick=Query_click;}	
}
function initForm()
{
	var obj=document.getElementById("cLoc");
	if (obj){
	  obj.size=1; 
	  obj.multiple=false;
	  }
	var obj=document.getElementById("cStatus");
	if (obj){
	  obj.size=2; 
	  }	
	  
	  AddStatus();
}
function Query_click()
{
	var cDateFrom=gGetObjValue("cDateFrom");
    var cDateTo=gGetObjValue("cDateTo");
    var cLoc=gGetListData("cLoc");
    var cStatus=gGetListCodes("cStatus")
    var cKey=gGetObjValue("txtKey");
    var cINCItm=gGetObjValue("INCItmID");
    var Opinion=gGetListData("Opinion");
    //gSetObjValue("INCItmID","");
    var cReportType=gGetListData("ReportType");
    if (cStatus=="") return;
    //alert(cLoc+","+cStatus+","+cReportType);return;   
    //alert(parent.parent.frames.length)
		lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedPVMCommonA" + "&DateFrom=" + cDateFrom + "&DateTo=" +cDateTo+ "&CtLoc=" +cLoc+ "&Status=" +cStatus+ "&INCItm=" +cINCItm+"&Key=" + cKey + "&ReportType=" + cReportType+"&Opinion="+ Opinion;
    	parent.frames[2].location.href=lnk;

	    lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCMedPVMCommonB" + "&DateFrom=" + cDateFrom + "&DateTo=" +cDateTo+ "&CtLoc=" +cLoc+ "&Status=" +cStatus+ "&INCItm=" +cINCItm+"&Key=" + cKey + "&ReportType=" + cReportType+"&Opinion="+ Opinion;
    	parent.frames[1].location.href=lnk;
}
function SetINCItmName(value){
	var TempPlist=value.split(CHR_Up);
	gSetObjValue("INCItmName",TempPlist[2]);
	gSetObjValue("INCItmID",TempPlist[0]);
	}		
	
function AddStatus(){
	gClearAllList("cStatus");
	s=gGetObjValue("tmpDictionary");
	var objDic=BASE_GetDictionary(s,"PVMReportStatus","Y");
	//alert(objDic.Count);
	var a=(new VBArray(objDic.Keys()));   
    for (i=0;i<objDic.Count;i++){
	    gSetListValue("cStatus",objDic(a.getItem(i)).Desc,objDic(a.getItem(i)).Code)
	    if((objDic(a.getItem(i)).Desc==t['Audit'])||(objDic(a.getItem(i)).Desc==t['NotReport']))
	      gSetListIndex("cStatus",i);
	    //gSetListIndex("cStatus",i);
	    }
	}	
document.body.onload=BodyLoadHandler;