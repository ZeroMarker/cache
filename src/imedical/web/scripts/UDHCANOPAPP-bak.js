var opaId=document.getElementById("opaId").value;
var EpisodeID=document.getElementById("EpisodeID").value;
var tformName=document.getElementById("TFORM").value; //ypz 070404
var getComponentIdByName=document.getElementById("GetComponentIdByName").value; //ypz 070404
var componentId=cspRunServerMethod(getComponentIdByName,tformName); //070404
var operSetAnaMode=true;
var bodySiteId=""
var appType=document.getElementById("appType").value;
var appLocId="",opId="",anmthId="",docanmthId="",appDocId=""; //070806
var preDiagId="",ASARowId="",ANCOPLRowId="",BloodRowId="",instrumentId="",operPositionId="",anaNurseId="",anaopLevelId="",opBladeTypeId="",postdiagId="",anaopPostDiagMem="",digId="",digmem="",operRoomId="";
var docIdList=new Array(),docDescList=new Array();
var assNum=3,ifEditDoc="N";
var firstScrubNurseId="";
var opSttDate=document.getElementById("opSttDate");
var opSttTime=document.getElementById("opSttTime");
var opEndDate=document.getElementById("opEndDate");
var opEndTime=document.getElementById("opEndTime");
//Lab info
var LabBloodType=document.getElementById("bloodType");
var LabRHBloodType=document.getElementById("RHBloodType");
var LabHBSAG=document.getElementById("HBSAG");
var LabHCVAB=document.getElementById("HCVAB");
var LabHIVAB=document.getElementById("HIVAB");
var Labchmd=document.getElementById("chmd");
var LabALT=document.getElementById("ALT");
var transferMeansCode="",admType=""

function SetCombo(cmstr)
{
	var obj=document.getElementById(cmstr);
	if (obj)
	{
		obj.size=1; 
		obj.multiple=false;
		obj.options[1].selected=true;
		if (cmstr=="RHBloodType"){
	    	obj.options[2].selected=true;
		}
    }
}
function BodyLoadHandler() {
    var objGetCtcpSet=document.getElementById("GetCtcpSet");
    if (objGetCtcpSet)
    {
	    var ctcpSet=cspRunServerMethod(objGetCtcpSet.value);
	    ctctSetList=ctcpSet.split("^");
	    if (ctctSetList.length>1)
	    {
		    assNum=parseInt(ctctSetList[0]);
		    ifEditDoc=ctctSetList[1];
	    }
	    for (i=0;i<assNum+1;i++) //initial
	    {
		    docIdList[i]="";
		    docDescList[i]="";
	    }
    }
	var obj=document.getElementById("surgeon");
	if (obj){
		obj.onkeydown=LookUpSurgeon;
		obj.onblur=Surgeon_onblur;
	} 
	var obj=document.getElementById("assistDoc1");
	if (obj){
		obj.onkeydown=LookAssistDoc1;
		obj.onblur=AssistDoc1_onblur;
	}
	var obj=document.getElementById("assistDoc2");
	if (obj){
		obj.onkeydown=LookAssistDoc2;
		obj.onblur=AssistDoc2_onblur;
	}
	var obj=document.getElementById("assistDoc3");
	if (obj){
		obj.onkeydown=LookAssistDoc3;
		obj.onblur=AssistDoc3_onblur;
	}
	var obj=document.getElementById("assistDoc4");
	if (obj){
		obj.onkeydown=LookAssistDoc4;
		obj.onblur=AssistDoc4_onblur;
	}
	var obj=document.getElementById("assistDoc5");
	if (obj){
		obj.onkeydown=LookAssistDoc5;
		obj.onblur=AssistDoc5_onblur;
	}
	var obj=document.getElementById("seloptyp");
    if(obj){
    obj.onclick=IfOutTimeCheck_Click;
    }
	var obj=document.getElementById("assistDocO");
	if (obj) obj.onkeydown=LookUpAssistDocO; 
	var obj=document.getElementById("assistDocList");
    if (obj) {obj.ondblclick=assistDoc_Dublclick};
	var obj=document.getElementById("anaSupervisor");
	if (obj) obj.onkeydown=LookUpAnaSupervisor;
	var obj=document.getElementById("anaDoc");
	if (obj) obj.onkeydown=LookUpAnaDoc;
	var obj=document.getElementById("anaDoc1");
    if(obj){
	    obj.onkeydown=LookUpAnaDoc1;
	    HideElement("anaDocList")
	    HideElement("anaDocO")
    }
	var obj=document.getElementById("anaDocO");
	if (obj) obj.onkeydown=LookUpAnaDoc2;
	var obj=document.getElementById("anaDocList");
    if (obj) {obj.ondblclick=anaDoc_Dublclick}
	var obj=document.getElementById("sAnaDoc");
	if (obj) obj.onkeydown=LookUpSAnaDoc;
    var obj=document.getElementById("sAnaDoc1")
    if(obj){
	    obj.onkeydown=LookUpSAnaDoc1;
	    HideElement("sAnaDocList")
	    HideElement("sAnaDocO")
    }
	var obj=document.getElementById("sAnaDocO");
	if (obj) obj.onkeydown=LookUpSAnaDocO; 
	var obj=document.getElementById("sAnaDocList");
    if (obj) obj.ondblclick=sAnaDoc_Dublclick
	var obj=document.getElementById("anaNurse");
	if (obj) obj.onkeydown=LookUpAnaNurse;
    var obj=document.getElementById("scrubNurse")
    if(obj){
	    obj.onkeydown=LookUpScrubNurse;
	    HideElement("scrubNurseList")
	    HideElement("scrubNurseO")
    }
	var obj=document.getElementById("scrubNurse1");
	if (obj) obj.onkeydown=LookUpScrubNurse1; 
	var obj=document.getElementById("scrubNurseO");
	if (obj) obj.onkeydown=LookUpScrubNurseO; 	
	var obj=document.getElementById("scrubNurseList");
    if (obj) {obj.ondblclick=ScrubNurse_Dublclick}
    var obj=document.getElementById("sScrubNurse")
    if(obj){
	    obj.onkeydown=LookUpSScrubNurse;
	    HideElement("sScrubNurseList")
	    HideElement("sScrubNurseO")
    }
	var obj=document.getElementById("sScrubNurse1");
	if (obj) obj.onkeydown=LookUpSScrubNurse1;
	var obj=document.getElementById("sScrubNurseO");
	if (obj) obj.onkeydown=LookUpSScrubNurseO;
	var obj=document.getElementById("sScrubNurseList");
    if (obj) {obj.ondblclick=SScrubNurseList_Dublclick}
    var obj=document.getElementById("circulNurse")
    if(obj){
	    obj.onkeydown=LookUpCirculNurse;
	    HideElement("circulNurseList")
	    HideElement("circulNurseO")
    }
	var obj=document.getElementById("circulNurse1");
	if (obj) obj.onkeydown=LookUpCirculNurse1;
	var obj=document.getElementById("circulNurseO");
	if (obj) obj.onkeydown=LookUpCirculNurseO;
    var obj=document.getElementById("circulNurseList");
    if (obj) {obj.ondblclick=CirculNurse_Dublclick}
    var obj=document.getElementById("sCirculNurse")
    if(obj){
	    obj.onkeydown=LookUpSCirculNurse;
	    HideElement("sCirculNurseList")
	    HideElement("sCirculNurseO")
    }
	var obj=document.getElementById("sCirculNurse1");
	if (obj) obj.onkeydown=LookUpSCirculNurse1;
	var obj=document.getElementById("sCirculNurseO");
	if (obj) obj.onkeydown=LookUpSCirculNurseO;
	var obj=document.getElementById("sCirculNurseList");
    if (obj) {obj.ondblclick=SCirculNurse_Dublclick}
	var obj=document.getElementById("appDoc");
	if (obj) obj.onkeydown=LookUpAppdoc;
	var obj=document.getElementById("operLocation");
	if (obj) obj.onkeydown=LookUpOperLocation;
	var obj=document.getElementById("anaopPreDiagnosis");
	if (obj) obj.onkeydown=LookUpPreDiag;
	var obj=document.getElementById("anaopPreDiagMem");
	if (obj) obj.onkeydown=LookUpPreDiagMem;
	var obj=document.getElementById("anaopPostDiagnosis");
	if (obj) obj.onkeydown=LookUpPostDiag;
	var obj=document.getElementById("anaopPostDiagMem");
	if (obj) obj.onkeydown=LookUpPostDiagMem;
	var obj=document.getElementById("opName");
	if (obj){
		obj.onkeydown=LookUpOpName;
   		obj.onblur=OpName_Blur;
	}
	var obj=document.getElementById("selop");
	if (obj) obj.onkeydown=LookUpSelop;
	var obj=document.getElementById("operList");
    if (obj) {
	    obj.onchange=OperList_Change;
		//if (obj) {obj.ondblclick=operList_Dublclick; //temp rem  doublclick delete operation
	} 
	var obj=document.getElementById("docAnMethod")
	if(obj)obj.onkeydown=LookUpDocAnMethod;
   	var obj=document.getElementById("add");
   	if (obj) obj.onclick=AddClick;	
   	var obj=document.getElementById("update");
   	if (obj) obj.onclick=UpdateClick;
   	var obj=document.getElementById("delete");
   	if (obj) obj.onclick=DeleteClick;
	var obj=document.getElementById("RHBloodType");
	if (obj) {obj.onclick=RHBloodType_Click;}
	var obj=document.getElementById("HBSAG");
	if (obj) {obj.onclick=AssayReslut_Click;}
	var obj=document.getElementById("HCVAB");
	if (obj) {obj.onclick=AssayReslut_Click;}
	var obj=document.getElementById("HIVAB");
	if (obj) {obj.onclick=AssayReslut_Click;}
	var obj=document.getElementById("chmd");
	if (obj) {obj.onclick=AssayReslut_Click;}
	var obj=document.getElementById("btsave");
	if (obj) {obj.onclick=Save_Click;}
	obj=document.getElementById("btclose");
	if (obj) {obj.onclick=Close_Click;}
	var obj=document.getElementById("instrument");
	if (obj) obj.onkeydown=LookUpInstrument;
	var obj=document.getElementById("operPosition");
	if (obj) obj.onkeydown=LookUpOperPosition;
	var obj=document.getElementById("bodySite");
	if (obj) obj.onkeydown=LookUpBodySite;
   	var obj=document.getElementById("bodySiteList");
    if (obj) obj.ondblclick=bodySiteList_Dublclick;	
	var obj=document.getElementById("bloodType");
	if (obj) obj.onkeydown=LookUpBloodType;
	var obj=document.getElementById("anaLevel");
	if (obj) obj.onkeydown=LookUpAnaLevel; 
	var obj=document.getElementById("anaopLevel");
	if (obj) obj.onkeydown=LookUpAnaopLevel;
	var obj=document.getElementById("allAnComp");
    if (obj) {obj.ondblclick=AllAnComp_Dublclick}
	var obj=document.getElementById("anaMethod");
	if (obj) obj.onkeydown=LookUpAnaMethod;
    var obj=document.getElementById("anaMethodList");
    if (obj) {obj.ondblclick=AnaMethodList_Dublclick}
    var docAnMethodList=document.getElementById("docAnMethodList");
    if (docAnMethodList) {docAnMethodList.ondblclick=docAnMethodList_Dublclick} //2011 zhang
	var obj=document.getElementById("operRoom");
	if (obj) obj.onkeydown=LookUpOperRoom;
    var obj=document.getElementById("GetAdmType")  //2011.7.8 
    if((obj)&&(opaId==""))
    {
      GetAdmType=obj.value;
      admType=cspRunServerMethod(GetAdmType,EpisodeID)
    }                                                             //2011.7.8
	var IfOutTime=document.getElementById("IfOutTime")
	if(IfOutTime) 
	{
		var ifDisbled=IfOutTime.value;
		if((ifDisbled==1)&(appType=="ward")&(opaId=="")&(admType!="E"))
		{
			var obj=document.getElementById("btsave");
			if (obj) {
				obj.style.visibility="hidden";
				alert(t['alert:OutTime']);
				//obj.disabled = true
			}
		}
		if((ifDisbled==2)&(appType=="ward")&(opaId=="")&(admType!="E")) alert(t['alert:OutTime']);
	}
	var objCheckAppData=document.getElementById('CheckAppData')
	if ((objCheckAppData)&&(opaId==""))
	{  
	  var CheckAppData=objCheckAppData.value
	  var retStr=cspRunServerMethod(CheckAppData,EpisodeID)
	  var n=retStr.split("!").length
	  var itmStr=retStr.split("!")
	  //alert(itmStr)
	  for(i=0;i<n;i++)
	  { 
	    var itm=itmStr[i].split("^")[0];
	    var itmCtr=itmStr[i].split("^")[1];
	    if((itmCtr==1)&(appType=="ward")&(opaId==""))
	    {
	       var obj=document.getElementById("btsave");
			if (obj) {
				//obj.style.visibility="hidden";
				alert(itm+t['alert:unfinished']);
				//obj.disabled = true
	    }
	    }
			if((itmCtr==2)&(appType=="ward")&(opaId=="")) alert(itm+t['alert:unfinished']);
			if((itmCtr==3)&(appType=="ward")&(opaId=="")) alert(itm+"危急值");
      } 
	  }
	SetCombo("HBSAG");
	SetCombo("HCVAB");
	SetCombo("HIVAB");
	SetCombo("chmd");
	SetCombo("RHBloodType");
	var objCMainTitle=document.getElementById("cmainTitle");
	var objCOpName=document.getElementById("copName");
    var objCAppDate=document.getElementById("cappdate");
    var objCAppTime=document.getElementById("capptime");
	if ((appType=="RegOp")||(appType=="RegNotApp"))
	{
		if (objCMainTitle) objCMainTitle.innerText=t['val:operReg'];
		objCOpName.innerText=t['val:operation'];
		objCAppDate.innerText=t['val:operDate'];
		objCAppTime.innerText=t['val:operTime'];
	}
	else if ((appType=="op")||(appType=="anaes")) {
		if(objCMainTitle) objCMainTitle.innerText=t['val:operArrange'];
  	}
	else{if(objCMainTitle) objCMainTitle.innerText=t['val:operApply'];}
  	if(objCMainTitle) objCMainTitle.readOnly=true; 	  
	var operLocation=document.getElementById("operLocation");
	if ((appType=="ward")&&(operLocation)&&(operLocation.value=="")){DefOpLocRoom();}
	switch(appType)
	{
		case "RegOp":   //operatioen register
		case "RegNotApp":
			DisableDiag();
			DisableById(componentId,"docAnMethod");
			DisableById(componentId,"docAnMethodList");
			break;
		case "ward":
			DisableOP();
			DisableAna();
			DisableById(componentId,"anaopPostDiagnosis");
			DisableById(componentId,"anaopPostDiagMem");
			DisableById(componentId,"operRoom");//手术间不能修改 whl 20120515
			break;
		case "anaes":
			DisableWard();
			DisableOP();
			var NeedAnaesthetistFlag=document.getElementById("NeedAnaesthetist"); //+ wxl 090316
			if ((NeedAnaesthetistFlag)&&(NeedAnaesthetistFlag.checked==false)) DisableAna();  // +
			SetEleFocus("anaDoc");
			break;
		case "op":
			DisableWard();
			DisableAna();
			DisableById(componentId,"opSttDate");
			DisableById(componentId,"opSttTime");
			DisableById(componentId,"opEndDate");
			DisableById(componentId,"opEndTime");
	 		if (operSetAnaMode) {
		 		 DisableById(componentId,"anaMethod");
		 		 DisableById(componentId,"anaMethodList");
		 		 DisableById(componentId,"anaLevel");
		 	}
		 	SetEleFocus("operRoom");	 
		default:
	}
   	if ((opaId!="")||(EpisodeID!=""))
	{
		var GetAnSingle=document.getElementById("GetAnSingle").value;
		var userId=session['LOGON.USERID']
		var ret=cspRunServerMethod(GetAnSingle,"ListAddOnOperation","",opaId, EpisodeID, userId);
		var appList=ret.split("^");
		LoadData(appList);
		if (opaId==""){
		    //Main diag or first diag
		    var mrdiag=document.getElementById("MDiagnos").value;
		    var temdia=cspRunServerMethod(mrdiag,EpisodeID,"M");
		    var diag=temdia.split("^");
		    var prediag=document.getElementById("anaopPreDiagnosis");
		    prediag.value=diag[1];
		    preDiagId=diag[0];
			//put all diag in ana_note
			var GetAllMDiagnos=document.getElementById("GetAllMDiagnos");
		    if (GetAllMDiagnos){
			    var anaopPreDiagMem=document.getElementById("anaopPreDiagMem");
			    var temDiagMem=cspRunServerMethod(GetAllMDiagnos.value,EpisodeID);
			    //alert(temdiagMem)
			    anaopPreDiagMem.value=temDiagMem;
		    }
		    //get latest Lab result
		    var IfInsertLabInfo=document.getElementById("IfInsertLabInfo");
			if ((IfInsertLabInfo)&&(IfInsertLabInfo.value=="Y")) {
	   	    	GetLabInfo(EpisodeID);
		    }
		    var medInfect=document.getElementById("medInfect");
		    if(medInfect)
		    {
			    var infect=appList[45]
			    medInfect.value=infect
			    medInfect.disabled=true;
		    }
		}
    }
	
	if (opaId=="") return;
	var GetQTData=document.getElementById("GetQTData").value;
	ret=cspRunServerMethod(GetQTData,opaId);
    var appOtherList=ret.split("$");
    LoadQtData(appOtherList);
    var RHBloodType=document.getElementById("RHBloodType");
	if(RHBloodType)
	{
		var RHBloodType=GetComboData(RHBloodType);
		if(RHBloodType==t['val:negative'])
		{
			document.getElementById("RHBloodType").style.color ="red" ;
		}
	}   
	var HBSAG=document.getElementById("HBSAG");
	if(HBSAG)
	{
		var HBSAG=GetComboData(HBSAG);
		if(HBSAG==t['val:positive'])
		{
			document.getElementById("HBSAG").style.color ="red" ;
		}
	}   
    var HCVAB=document.getElementById("HCVAB");
	if(HCVAB)
	{
		var HCVAB=GetComboData(HCVAB);
		if(HCVAB==t['val:positive'])
		{
			document.getElementById("HCVAB").style.color ="red" ;
		}
	}   
    var HIVAB=document.getElementById("HIVAB");
	if(HIVAB)
	{
		var HIVAB=GetComboData(HIVAB);
		if(HIVAB==t['val:positive'])
		{
			document.getElementById("HIVAB").style.color ="red" ;
		}
	}
	var CHMD=document.getElementById("chmd");
	if(CHMD)
	{
		var CHMD=GetComboData(CHMD);
		if(CHMD==t['val:positive'])
		{
			document.getElementById("chmd").style.color ="red" ;
		}
	}
}
function OperList_Dublclick()
{
	var operList=document.getElementById("operList");
	var a=operList.selectedIndex;
	operList.remove(a) ;
	var obj=document.getElementById("addOpCategory"); //+ wxl 090320
	if (obj) obj.remove(a) ;
	var obj=document.getElementById("addOpStatName"); //+ wxl 090819
	if (obj) obj.remove(a) ;
}
function AllAnComp_Dublclick()
{
	var allAnComp=document.getElementById("allAnComp");
	var a=allAnComp.selectedIndex;
	allAnComp.remove(a) ;
}
function LookUpAppdoc()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	appDoc_lookuphandler();
	}
} 
function LookUpOperLocation()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	operLocation_lookuphandler();
	}
} 
function LookUpPreDiag()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	anaopPreDiagnosis_lookuphandler();
	}
} 
function LookUpPreDiagMem()
{
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	anaopPreDiagMem_lookuphandler();
	}
}
function LookUpPostDiag()
{
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	anaopPostDiagnosis_lookuphandler();
	}
}
function LookUpPostDiagMem()
{
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	anaopPostDiagMem_lookuphandler();
	}
}
function LookUpOpName()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	opName_lookuphandler();
	}
} 
function LookUpSelop()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	selop_lookuphandler();
	}
}
function LookUpSurgeon()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	surgeon_lookuphandler();
	}
} 
function LookAssistDoc1()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	assistDoc1_lookuphandler();
	}
} 
function LookAssistDoc2()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	assistDoc2_lookuphandler();
	}
} 
function LookAssistDoc3()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	assistDoc3_lookuphandler();
	}
} 
function LookAssistDoc4()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	assistDoc4_lookuphandler();
	}
}
function LookAssistDoc5()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	assistDoc5_lookuphandler();
	}
}
function LookUpAssistDocO()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	assistDocO_lookuphandler();
	}
} 
function LookUpBloodType()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	bloodType_lookuphandler();
	}
} 
function LookUpBodySite()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	bodySite_lookuphandler();
	}
} 
function LookUpOperPosition()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	operPosition_lookuphandler();
	}
} 
function LookUpAnaLevel()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	anaLevel_lookuphandler();
	}
} 
function LookUpAnaDoc()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	anaDoc_lookuphandler();
	}
} 
function LookUpAnaDoc1()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	anaDoc1_lookuphandler();
	}
} 
function LookUpAnaDoc2()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	anaDocO_lookuphandler();
	}
} 
function LookUpSAnaDoc()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	sAnaDoc_lookuphandler();
	}
} 
function LookUpSAnaDoc1()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	sAnaDoc1_lookuphandler();
	}
} 
function LookUpSAnaDocO()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	sAnaDocO_lookuphandler();
	}
} 
function LookUpAnaNurse()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	anaNurse_lookuphandler();
	}
} 
function LookUpAnaMethod()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	anaMethod_lookuphandler();
	}
} 
function LookUpInstrument()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	instrument_lookuphandler();
	}
} 
function LookUpScrubNurse()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	scrubNurse_lookuphandler();
	}
}
function LookUpScrubNurse1()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	scrubNurse1_lookuphandler();
	}
}
function LookUpScrubNurseO()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	scrubNurseO_lookuphandler();
	}
} 
function LookUpOperRoom()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	operRoom_lookuphandler();
	}
} 
function LookUpCirculNurse()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	circulnurse_lookuphandler();
	}
}
function LookUpCirculNurse1()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	circulnurse1_lookuphandler();
	}
} 
function LookUpSCirculNurse()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	sCirculNurse_lookuphandler();
	}
} 
function LookUpSCirculNurse1()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	sCirculNurse1_lookuphandler();
	}
}
function LookUpSCirculNurseO()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	sCirculNurseO_lookuphandler();
	}
}

function LookUpCirculNurseO()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	circulNurseO_lookuphandler();
	}
}
function LookUpSScrubNurse()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	sScrubNurse_lookuphandler();
	}
}
function LookUpSScrubNurse1()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	sScrubNurse1_lookuphandler();
	}
}
function LookUpSScrubNurseO()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	sScrubNurseO_lookuphandler();
	}
}
function LookUpAnaopLevel()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	anaopLevel_lookuphandler();
	}
}
function LookUpAnaSupervisor()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	anaSupervisor_lookuphandler();
	}
}
function LookUpDocAnMethod()
{	
	if (window.event.keyCode==13) 
	{  
		window.event.keyCode=117;
	   	docanMethod_lookuphandler();
	}
} 
function anaDoc_Dublclick()
{
	List_DublClick("anaDocList");
}
function assistDoc_Dublclick()
{
	List_DublClick("assistDocList");
}
function CirculNurse_Dublclick()
{
	List_DublClick("circulNurseList");
}
function sAnaDoc_Dublclick()
{
	List_DublClick("sAnaDocList");
}
function SScrubNurseList_Dublclick()
{
	List_DublClick("sScrubNurseList");
}
function SCirculNurse_Dublclick()
{
	List_DublClick("sCirculNurseList");
}
function ScrubNurse_Dublclick()
{
	List_DublClick("scrubNurseList");
}
function ListAddOnOperation(anaId)
{
	var GetOpList=document.getElementById("GetOpList").value;
	var ret=cspRunServerMethod(GetOpList,anaId);
	var datop=ret.split("^");
	//alert(datop)
	var operList=document.getElementById("operList");
	var objAddOPCat=document.getElementById("addOpCategory");
	for (var i=0;i<datop.length;i++)
   	{
		if (datop[i]!="")
		{
			var op=datop[i].split("!");
			//operID|oplevelID|opbladeTypeID
			var opDescId=op[2]+"|"+op[7]+"|"+op[10]+"|"+op[12];
			//operDesc|opLevel|operblade type|operation note
			var opDesc=t['val:opName']+op[3]+"  "+t['val:oplevel']+op[8]+"  "+t['val:bladetype']+op[11]+"  "+t['val:opNote']+op[9];
			var sel=new Option(opDesc,opDescId);
			operList.options[operList.options.length]=sel;
			var AddOPCat=new Option(op[6],op[2]);
			if (objAddOPCat) objAddOPCat.options[objAddOPCat.options.length]=AddOPCat;
		}
	}
	var GetAnaestCompList=document.getElementById("GetAnaestCompList").value;
	var ret=cspRunServerMethod(GetAnaestCompList,anaId);
	var AnaestCompList=ret.split("^");
	var allAnComp=document.getElementById("allAnComp");
	for (var i=0;i<AnaestCompList.length;i++)
   	{
		if (AnaestCompList[i]!="")
		{
			var AnaestComp=AnaestCompList[i].split("!");
			var sel=new Option(AnaestComp[1],AnaestComp[0]);
			if(allAnComp) allAnComp.options[allAnComp.options.length]=sel;
		}
	}
}

function LoadQtData(appOtherList)
{
	var strck=appOtherList[0].split("^");
	ListCombo(strck[0],"HBSAG")
	ListCombo(strck[1],"HCVAB")
	ListCombo(strck[2],"HIVAB")
	ListCombo(strck[3],"chmd")
	ListCombo(strck[6],"RHBloodType")
	var seloptyp=document.getElementById("seloptyp");
	if (strck[4]=="1") seloptyp.checked=true;
	else seloptyp.checked=false;
	var isolated=document.getElementById("isolated");
	if (strck[7]=="Y") 
	   if (isolated) isolated.checked=true;
	else
	   if (isolated) isolated.checked=false;
	var isPrepareBlood=document.getElementById("isPrepareBlood");
	if (isPrepareBlood)
	{
		if (strck[8]=="Y") isPrepareBlood.checked=true;
	 	else  isPrepareBlood.checked=false;
	}
	 var isUseSelfBlood=document.getElementById("isUseSelfBlood");
	if (isUseSelfBlood)
	{
		if (strck[9]=="Y") isUseSelfBlood.checked=true;
	 	else  isUseSelfBlood.checked=false;
	}
	 var isExCirculation=document.getElementById("isExCirculation");
	if (isExCirculation)
	{
		if (strck[10]=="Y") isExCirculation.checked=true;
	 	else  isExCirculation.checked=false;
	}
	var obj=document.getElementById('ifMiniInvasive')
	if(obj)
	{
		if (strck[12]=="Y") obj.checked=true;
	 	else  obj.checked=false;
	}
	var obj=document.getElementById('NeedNavigation')  //2010.8.6 zhangtao 
	if(obj)
	{
		if (strck[13]=="Y") obj.checked=true;
	 	else  obj.checked=false;
	}
	obj=document.getElementById("qt");
	if(obj)obj.value=strck[5];
	
	var opreq=document.getElementById("opreq");
	if(opreq) opreq.value=appOtherList[2];
	var note=document.getElementById("note");
	if(note) note.value=appOtherList[1];
	
	var tmpSScrubNurseList=appOtherList[3].split(" ");
	var sScrubNurse=document.getElementById("sScrubNurse");
	var sScrubNurseId=document.getElementById("sScrubNurseId");
	if (tmpSScrubNurseList[0])sScrubNurse.value=tmpSScrubNurseList[0];
	if (tmpSScrubNurseList[1])sScrubNurseId.value=tmpSScrubNurseList[1];
	
	var tmpSCirculNurseList=appOtherList[4].split(" ");
	var sCirculNurse=document.getElementById("sCirculNurse");
	var sCirculNurseId=document.getElementById("sCirculNurseId");
	if (tmpSCirculNurseList[0])sCirculNurse.value=tmpSCirculNurseList[0];
	if (tmpSCirculNurseList[1])sCirculNurseId.value=tmpSCirculNurseList[1];
	
	var tmpSAnaDocList=appOtherList[6].split(" ");
	var sAnaDoc=document.getElementById("sAnaDoc");
	var sAnaDocId=document.getElementById("sAnaDocId");
	if (tmpSAnaDocList[0])sAnaDoc.value=tmpSAnaDocList[0];
	if (tmpSAnaDocList[1])sAnaDocId.value=tmpSAnaDocList[1];
	ifShift=document.getElementById("ifShift");
	if(ifShift)
	{
	   if (appOtherList[5]=="1")
	     ifShift.checked=true;
	   else
	     ifShift.checked=false; 
	}
}
function Packid(s1,s2,dat,del)
{
   var obj=document.getElementById(s1);
   var obj1=document.getElementById(s2);
   var tem=dat.split(del);
   if (tem[0]) obj.value=tem[0];
   if (tem[1]) obj1.value=tem[1];
}
function ListCombo(ch,cmstr)
{  
	var obj=document.getElementById(cmstr);
	switch(ch)
	{
	    case t['val:unknow']:
	    case t['val:uncheck']:
	    	if (obj) obj.options[0].selected=true;
	    break;
	    case t['val:negative']:
	    	if (obj) obj.options[1].selected=true;
	    break;
	    case t['val:positive']:
	    	if (obj) obj.options[2].selected=true;
	    break;
	    case t['val:incheck']:
	    	if (obj) obj.options[3].selected=true;
	    break;
	    default:
	}
}
function LoadData(appList)
{
	if (appList[25]){
		EpisodeID=appList[25];
		document.getElementById("EpisodeID").value=appList[25];
	}
	var obj=document.getElementById("patname");
	obj.value=appList[3];	
	obj=document.getElementById("regno");
	obj.value=appList[2];
	obj=document.getElementById("sex");
	obj.value=appList[4];
	obj=document.getElementById("age");
	obj.value=appList[5];
    obj=document.getElementById("patbedno");
    obj.value=appList[15];
	obj=document.getElementById("patfeityp");
    obj.value=appList[17];
	obj=document.getElementById("patloc");
    obj.value=appList[7];
	obj=document.getElementById("patward");
    obj.value=appList[16];
    obj=document.getElementById("appLoc");
	obj.value=appList[7];
	var appdt=appList[0].split(" ")
	obj=document.getElementById("appDate");
	obj.value=appdt[0];
	obj=document.getElementById("appTime");
	obj.value=appdt[1];
	if (appType=="RegOp"){
		if (opSttDate) opSttDate.value=appdt[7];
		if (opSttTime) opSttTime.value=appdt[8];
	    if (opEndDate) opEndDate.value=appdt[9];
		if (opEndTime) opEndTime.value=appdt[10];
	}
	var obj=document.getElementById("preDiscussDate");
	if(obj) obj.value=appdt[5];
	var obj=document.getElementById("estiOperDuration");
	if(obj) obj.value=appdt[6];
	var obj=document.getElementById("arrTime");
	if (obj) obj.value=appdt[2];
    var obj=document.getElementById("transferMeans") //zhangtao 2010.8.5
	if (obj)
		{
			transferMeansCode=appList[46]
			obj.value=appList[47];
		}
	var op=appList[6].split(" ");
	obj=document.getElementById("opName");
	opId=op[1];
	obj=document.getElementById("opCategory"); // +wxl 090320
	if (obj) obj.value=appList[38];	
	obj=document.getElementById("opStatName"); // +wxl 090919
	if (obj) obj.value=appList[39];	
	obj=document.getElementById("anaSupervisorId"); //ck 091203
	if (obj) obj.value=appList[40];	
	obj=document.getElementById("anaSupervisor"); 
	if (obj) obj.value=appList[41];	    		//ck091203
	obj=document.getElementById("anaDocNote"); 
	if (obj) obj.value=appList[42];
	var opDoc=appList[8].split(" ")
	obj=document.getElementById("surgeon");
	//alert(appList)
	obj.value=opDoc[0];
	docIdList[0]=opDoc[1];
	docDescList[0]=opDoc[0];
	setOpDocId(opDoc[1]) //liangq 20101116
	obj=document.getElementById("appDoc");
	if (obj) obj.value=opDoc[2]
	appDocId=opDoc[3];
	//alert("/"+appList[19]+"/"+appList[8]+"/"+appList[36])
	if (appList[19])
	{
		var ass=appList[19].split(" ")
		for (i=0;i<assNum;i++)
		{
			obj=document.getElementById("assistDoc"+(i+1));
			if (ass[i] && obj)
			{
				var assDoc=ass[i].split("!")
				docIdList[i+1]=assDoc[1];
				docDescList[i+1]=assDoc[0];
				obj.value=assDoc[0];
			}
		}
		var dataValue
		dataValue=""
		for(var i=assNum;i<ass.length;i++){
			if(dataValue==""){
				dataValue=ass[i]
			}else
			{
				dataValue=dataValue+"^"+ass[i]
			}
		}
		InitListRow("assistDocList",dataValue);
		var obj=document.getElementById("opDocNote");
		if(obj)
		{
			if(ass[5])
			{
				var ass7=ass[5].split("!")
				obj.value=ass7[0];
			}
		}
	}
	/*if (appList[10])
	{
		var objMethodList=document.getElementById('anaMethodList');
		var amthList=appList[10].split("!");
		for (var i=0;i<amthList.length;i++){
			anmth=amthList[i].split("|");
			var objSelected = new Option(anmth[1], anmth[0]);
			if (objMethodList) objMethodList.options[objMethodList.options.length]=objSelected;
		}
	}*/
	if (appList[10])
	{   
      var anMethod=appList[10].split(" ")
     if (anMethod[1])
	  {
		var objDocMethodList=document.getElementById('docAnMethodList');
		if (objDocMethodList)
		{
			var docamthList=anMethod[1].split("!");
			for (var i=0;i<docamthList.length;i++){
				docanmth=docamthList[i].split("|");
				var objAddList = new Option(docanmth[1], docanmth[0]);
				if (objDocMethodList) objDocMethodList.options[objDocMethodList.options.length]=objAddList;
			}
		}
		var objMethodList=document.getElementById('anaMethodList');
		for (var i=0;i<docamthList.length;i++){
			anmth=docamthList[i].split("|");
			var objSelected = new Option(anmth[1], anmth[0]);
			if (objMethodList) objMethodList.options[objMethodList.options.length]=objSelected;
	  }
	}
	if (anMethod[0])                      //2011
	{   
		var objMethodList=document.getElementById('anaMethodList');
		objMethodList.options.length=0
		var amthList=anMethod[0].split("!");
		for (var i=0;i<amthList.length;i++){
			anmth=amthList[i].split("|");
			var objSelected = new Option(anmth[1], anmth[0]);
			if (objMethodList) objMethodList.options[objMethodList.options.length]=objSelected;
	}
	}	
	}    
	if (appList[11])
	{
		var scru=appList[11].split("*");
		if (scru[0]){
			SetCpcp("scrubNurse","scrubNurseId",scru[0].split(" ")[0])
			if (scru[0].split(" ")[1]) SetCpcp("scrubNurse1","scrubNurseId1",scru[0].split(" ")[1])
			var dataValue=""
			for(var i=0;i<scru[0].split(" ").length;i++){
				if(dataValue=="") dataValue=scru[0].split(" ")[i]
				else dataValue=dataValue+"^"+scru[0].split(" ")[i]
			}
			InitListRow("scrubNurseList",dataValue);
		} 
		if (scru[1]){
			SetCpcp("sScrubNurse","sScrubNurseId",scru[1].split(" ")[0])
			if (scru[1].split(" ")[1]) SetCpcp("sScrubNurse1","sScrubNurseId1",scru[1].split(" ")[1])
			var dataValue=""
			for(var i=0;i<scru[1].split(" ").length;i++){
				if(dataValue=="") dataValue=scru[1].split(" ")[i]
				else dataValue=dataValue+"^"+scru[1].split(" ")[i]
			}
			InitListRow("sScrubNurseList",dataValue);
		}
	}
	if (appList[12])
	{
		var cir=appList[12].split("*");
		if (cir[0]){
			SetCpcp("circulNurse","circulNurseId",cir[0].split(" ")[0])
			if (cir[0].split(" ")[1]) SetCpcp("circulNurse1","circulNurseId1",cir[0].split(" ")[1])
			var dataValue=""
			for(var i=0;i<cir[0].split(" ").length;i++){
				if(dataValue=="") dataValue=cir[0].split(" ")[i]
				else dataValue=dataValue+"^"+cir[0].split(" ")[i]
			}
			InitListRow("circulNurseList",dataValue);
		} 
		if (cir[1]){
			SetCpcp("sCirculNurse","sCirculNurseId",cir[1].split(" ")[0])
			if (cir[1].split(" ")[1]) SetCpcp("sCirculNurse1","sCirculNurseId1",cir[1].split(" ")[1])
			var dataValue=""
			for(var i=0;i<cir[1].split(" ").length;i++){
				if(dataValue=="") dataValue=cir[1].split(" ")[i]
				else dataValue=dataValue+"^"+cir[1].split(" ")[i]
			}
			InitListRow("sCirculNurseList",dataValue);
		}
	}
	var operRoom=appList[1].split(" ")
	obj=document.getElementById("operRoom");
	if(obj) if (operRoom[0]) obj.value=operRoom[0];
	operRoomId=operRoom[1];
	obj=document.getElementById("ordno");
	if(obj) if (operRoom[2]) obj.value=operRoom[2];
	obj=document.getElementById("isAddInstrument");
	if(obj)
	{
		if (operRoom[4]=="Y")
		{
			obj.checked=true;
		}
	}
	if (operRoom[5])  instrumentId=operRoom[5]
	obj=document.getElementById("instrument");
	if (obj) 
	{
		if(operRoom[6]) obj.value=operRoom[6];
	}
	obj=document.getElementById("operLocation");
	if ((obj)&&(operRoom.length>3)) obj.value=operRoom[3];

    if (appList[9]){
		var andoc=appList[9].split("*");
		if (andoc[0]) SetCpcp("anaDoc","anaDocId",andoc[0])
		if (andoc[1])
		{
			var obj=document.getElementById("anaNurse");
			if(obj) obj.value=andoc[1].split("!")[0]
			anaNurseId=andoc[1].split("!")[1]
		}
		if (andoc[2]) {
			SetCpcp("anaDoc1","anaDocId1",andoc[1].split(" ")[0])
			var dataValue=""
			for(var i=0;i<andoc[2].split(" ").length;i++){
				if(dataValue=="") dataValue=andoc[2].split(" ")[i]
				else dataValue=dataValue+"^"+andoc[2].split(" ")[i]
			}
			InitListRow("anaDocList",dataValue);
		}
		if (andoc[3]){
			SetCpcp("sAnaDoc","sAnaDocId",andoc[3].split(" ")[0])
			if (andoc[3].split(" ")[1]) SetCpcp("sAnaDoc1","sAnaDocId1",andoc[3].split(" ")[1])
			var dataValue=""
			for(var i=0;i<andoc[3].split(" ").length;i++){
				if(dataValue=="") dataValue=andoc[3].split(" ")[i]
				else dataValue=dataValue+"^"+andoc[3].split(" ")[i]
			}
			InitListRow("sAnaDocList",dataValue);
		}
    }
	if (appList[20])
	{
		var diag=appList[20].split(" ")
		obj=document.getElementById("anaopPreDiagnosis");
		obj.value=diag[0];
		preDiagId=diag[1];
		if(digId.length==2)
		{
			postdiagId=digId[1];
		}
		else
		{
			postdiagId="";
		}
	}
	//var arrdate=appList[21].split(" ");
	//obj=document.getElementById("opdate");
	//obj.value=arrdate[0];
	//obj=document.getElementById("optime");
	//obj.value=arrdate[1];
	obj=document.getElementById("opmem");
	if (appList[22]) obj.value=appList[22];
	obj=document.getElementById("anaopPreDiagMem");
	if (appList[23]) obj.value=appList[23].split("/")[0];
	//display multi-bodysites 
	var objBodySiteList=document.getElementById('bodySiteList');
    if ((appList[26])&&(objBodySiteList))
	{
		var bodyList=appList[26].split("!");
		for (var i=0;i<bodyList.length;i++){
			var body=bodyList[i].split("|");
			var objSelected = new Option(body[1], body[0]);
			if (objBodySiteList) objBodySiteList.options[objBodySiteList.options.length]=objSelected;
		}
	} 
	var objOperPosition=document.getElementById("operPosition");
	if ((appList[35])&&(objOperPosition))
	{
		var tmpStr=appList[35].split(" ")
		objOperPosition.value=tmpStr[1];
    	operPositionId=tmpStr[0];
	}
	var obj=document.getElementById("patHeight");
	if (obj) {
		if (appList[27]) obj.value=appList[27];
	}
	var obj=document.getElementById("patWeight");
	if(obj) {
		if (appList[28]) obj.value=appList[28];
	}
	if (appList[29])ANCOPLRowId=appList[29];
	var objAnaLevel=document.getElementById("anaLevel");
	if (appList[30]){if (objAnaLevel)objAnaLevel.value=appList[30];}
	if (appList[31])ASARowId=appList[31];
	var objASA=document.getElementById("ASA");
	if ((appList[32])&&(objASA))objASA.value=appList[32];	                       
	if (appList[33]){
		var objOperLocId=document.getElementById("operLocId")
		objOperLocId.value=appList[33]
	}
	var obj=document.getElementById("bloodType");
		if(appList[34]=="") appList[34]=t['val:unknow']
	if (appList[34]) obj.value=appList[34];
	if (appList[24]) BloodRowId=appList[24];
	var obj=document.getElementById("opDocNote");
	if(obj)
	{
		if(appList[36]) obj.value=appList[36]
	}
	var obj=document.getElementById("opSeqNote");
	if(obj)
	{
		if(appList[37]) obj.value=appList[37]
	}
	var obj=document.getElementById("scrubNurseNote");
	if(obj)
	{
		if(appList[43]) obj.value=appList[43]
	}
		var obj=document.getElementById("circulNurseNote");
	if(obj)
	{
		if(appList[44]) obj.value=appList[44]
	}
}
function SetCpcp(s1,s2,dat)
{
   var obj=document.getElementById(s1);
   var obj1=document.getElementById(s2);
   var tem=dat.split("!");
   if(obj){
	   if (tem[0]) obj.value=tem[0];
   }
   if(obj1){
	   if (tem[1]) obj1.value=tem[1];
   }
}
function DisableById(componentId,id)
{
	var obj=document.getElementById(id);
	if (obj) obj.disabled=true;
	if (componentId>0)
	{
		obj=document.getElementById("ld"+componentId+"i"+id);
		if (obj) obj.style.display ="none";
	}
}
function DisableWard()
{
	DisableById(componentId,"appLoc");
	DisableById(componentId,"appDoc");
	DisableById(componentId,"appDate");
	DisableById(componentId,"appTime");
	DisableById(componentId,"preDiscussDate");
	DisableById(componentId,"estiOperDuration");
	DisableById(componentId,"operLocation");
	DisableById(componentId,"opName");
	DisableById(componentId,"surgeon");
	DisableById(componentId,"assistDoc1");
	DisableById(componentId,"assistDoc2");
	DisableById(componentId,"assistDoc3");
	DisableById(componentId,"assistDoc4");
	DisableById(componentId,"assistDoc5");
	DisableById(componentId,"anaopPreDiagnosis");
	DisableById(componentId,"selop");
	DisableById(componentId,"operList");
	DisableById(componentId,"opmem");
	DisableById(componentId,"anaopPreDiagMem");
	DisableById(componentId,"seloptyp");
	DisableById(componentId,"bodySite");
	DisableById(componentId,"bodySiteList");
	DisableById(componentId,"operPosition");
	DisableById(componentId,"patWeight");
	DisableById(componentId,"patHeight");
	//DisableById(componentId,"anaLevel")
	DisableById(componentId,"bloodType")
	DisableById(componentId,"assistDocO");
	DisableById(componentId,"assistDocList");
	DisableById(componentId,"isolated");
	DisableById(componentId,"isPrepareBlood");
	DisableById(componentId,"isUseSelfBlood");
	DisableById(componentId,"isExCirculation");
	DisableById(componentId,"opDocNote");
	DisableById(componentId,"opSeqNote");
	DisableById(componentId,"NeedAnaesthetist"); // + wxl 090316
	//if (operSetAnaMode) DisableById(componentId,"anaMethod");
	DisableById(componentId,"docGroup");
	//DisableById(componentId,"ordno");
	//DisableById(componentId,"anaopPostDiagnosis");
	//DisableById(componentId,"anaopPostDiagMem");
	DisableById(componentId,"anaopLevel");
	DisableById(componentId,"opBladeType");
	DisableById(componentId,"opNote");
	DisableById(componentId,"transferMeans");
	DisableById(componentId,"NeedNavigation");
	DisableById(componentId,"docAnMethod");
	DisableById(componentId,"docAnMethodList");
  DisableCombo();
}
function DisableCombo()
{
	var obj=document.getElementById("HBSAG");
	obj.disabled=true;
	obj=document.getElementById("HCVAB");
	obj.disabled=true;
	obj=document.getElementById("HIVAB");
	obj.disabled=true;
	obj=document.getElementById("chmd");
	obj.disabled=true;
	obj=document.getElementById("qt");
	obj.disabled=true;
	//obj=document.getElementById("bloodType");
	//obj.disabled=true;
	obj=document.getElementById("RHBloodType");
	if (obj) obj.disabled=true; 
}
function DisableDiag()
{
	DisableById(componentId,"operLocation");
	//DisableById(componentId,"opdate");
	DisableById(componentId,"appTime");
	DisableById(componentId,"appLoc");
	DisableById(componentId,"appDoc");
	DisableById(componentId,"estiOperDuration");
	DisableById(componentId,"bloodType");
	DisableById(componentId,"appDate");
	DisableById(componentId,"anaopPreDiagnosis");
	DisableById(componentId,"anaopPreDiagMem");
}
function DisableAna()
{
	//if (! operSetAnaMode) DisableById(componentId,"anaMethod");
	DisableById(componentId,"anaDoc");
	DisableById(componentId,"anaSupervisor");    //ck091203
	DisableById(componentId,"anaNurse");
	DisableById(componentId,"anaDoc1");
	DisableById(componentId,"sAnaDoc");
	DisableById(componentId,"sAnaDoc1");
    //DisableById(componentId,"anaMethod");
	DisableById(componentId,"ASA");	
    DisableById(componentId,"sAnaDocO");
	DisableById(componentId,"sAnaDocList");	
    DisableById(componentId,"anaDocO");
	DisableById(componentId,"anaDocList");	
	DisableById(componentId,"anaDocNote");	
}
function DisableOP()
{
	DisableById(componentId,"scrubNurse");
	DisableById(componentId,"scrubNurse1");
	DisableById(componentId,"scrubNurseO");
	DisableById(componentId,"scrubNurseList");
	DisableById(componentId,"circulNurse");
	DisableById(componentId,"circulNurse1");
	DisableById(componentId,"circulNurseO");
	DisableById(componentId,"circulNurseList");
	//DisableById(componentId,"operRoom");
	DisableById(componentId,"sScrubNurse");
	DisableById(componentId,"sScrubNurse1");
	DisableById(componentId,"sScrubNurseO");
	DisableById(componentId,"sScrubNurseList");
	DisableById(componentId,"sCirculNurse");
	DisableById(componentId,"sCirculNurse1");
	DisableById(componentId,"sCirculNurseO");
	DisableById(componentId,"sCirculNurseList");
	DisableById(componentId,"opreq");
	DisableById(componentId,"note");
	DisableById(componentId,"ifShift");
	//DisableById(componentId,"isAddInstrument");//sjq?2009/2/26?operation apply must fill in ?
	//DisableById(componentId,"instrument");//sjq?2009/2/26?operation apply must fill in ?
	DisableById(componentId,"mainPack");
	DisableById(componentId,"secPack");
	DisableById(componentId,"thrPack");
	//DisableById(componentId,"ordno");
	DisableById(componentId,"arrTime");
	DisableById(componentId,"opSttDate");
	DisableById(componentId,"opSttTime");
	DisableById(componentId,"opEndDate");
	DisableById(componentId,"opEndTime");
	DisableById(componentId,"scrubNurseNote");
	DisableById(componentId,"circulNurseNote");
}
function GetComboData(comb)
{ //selectedIndex
	var indx=comb.selectedIndex;
	var chdata;
	if (indx!=-1)
	{
		chdata=comb.options[indx].text;
	}
	else
	{
	    chdata="";
	}
	return chdata;
}
function CheckData()
{
    if (EpisodeID==""){
		alert(t['alert:selPat']);
		return false;
    } 
    var obj=document.getElementById("operLocation")
    if (obj) {
	    if (obj.value==""){
		    alert(t['alert:selOperLoc']);
		    obj.focus();
		    return false;
		}
	}
    var obj=document.getElementById("appDate");
    if (obj.value==""){
	    alert(t['alert:selOperDate']);
	    obj.focus();
	    return false
	}
    var obj=document.getElementById("appTime");
    if (obj.value==""){
	    alert(t['alert:selOperTime']);
	    obj.focus();
	    return false
	}
    var obj=document.getElementById("bloodType");
    if (obj.value==""){
			alert(t['alert:selBldTyp']);
			obj.focus();
			return false
	}
    var obj=document.getElementById("preDiscussDate");
	if ((obj)&&(preDiscussDate.value=="")){
	    alert(t['alert:preDiscussDate']);
	    obj.focus();
	    return false
	}
    var obj=document.getElementById("estiOperDuration");
    //if (obj.value==""){
    /*if ((obj)&&(estiOperDuration.value=="")){
	    alert(t['alert:estiOperDuration']);
	    obj.focus();
	    return false
	}*/
    var objOpName=document.getElementById("opName");
    //for jst AnOpMoni temp//if (opId=="")
    var operList=document.getElementById("operList");
  	if(operList.length<1)
    {
	    alert(t['alert:selOper']);
	    objOpName.focus();
	    return false
	}
    var obj=document.getElementById("anaopPreDiagnosis");
    if (preDiagId=="")
    {
	    alert(t['alert:selDiag']);
	    if ((appType=="ward")||(appType=="")) obj.focus();
	    return false
	}
    var obj=document.getElementById("surgeon");
    if ((ifEditDoc!="Y" && docIdList[0]=="")||(ifEditDoc=="Y" && docDescList[0]==""))
    {
	    alert(t['alert:selOperDoc']);
	    obj.focus();
	    return false
	}
    var obj=document.getElementById("anaDoc");
	if ((appType!="op")&&(appType!="ward")&&(obj)&&(obj.value=="")) { //for JST
		alert(t['alert:selAnaDoc']);
		obj.focus();
		return false;
	}
    var anaMethod=document.getElementById("anaMethod");
    var anaMethodList=document.getElementById("anaMethodList");
	if ((appType!="op")&&(appType!="ward")&&(anaMethodList)&&(anaMethodList.length<1)) { //for JST
		alert(t['alert:selAnaMethod']);
		anaMethod.focus();
		return false;
	}
    var obj=document.getElementById("arrTime");
    if ((obj)&&(appType=="op"))
    {
	    if(obj.value=="")
	    {
		    //alert(t['alert:selOperArrTime']);
	    	//obj.focus();
	    	//return false;
	    }
	}
	var obj=document.getElementById("ordno");
    if ((obj)&&(appType=="op"))
    {
	    if(obj.value=="")
	    {
		    alert(t['alert:selOrdNo']);
	    	obj.focus();
	    	return false;
	    }
	}
	if ((appType=="RegOp")&&(opSttDate)&&(opSttDate.value=="")) {alert(t['alert:selOperSttDate']);return false;}
	if ((appType=="RegOp")&&(opSttTime)&&(opSttTime.value=="")) {alert(t['alert:selOperSttTime']);return false;}
    if ((appType=="RegOp")&&(opEndDate)&&(opEndDate.value=="")) {alert(t['alert:selOperEndDate']);return false;}
    if ((appType=="RegOp")&&(opEndTime)&&(opEndTime.value=="")) {alert(t['alert:selOperEndTime']);return false;}

	return true;	
}
function Save_Click()
{
    var checkRes=CheckData();    
    if (checkRes==false){ return; }
    var obj=document.getElementById("preDiscussDate");
    var preDiscussDate=""
    if(obj) var preDiscussDate=obj.value;
    obj=document.getElementById("estiOperDuration");
    var estiOperDuration=""
    if(obj) var estiOperDuration=obj.value;
    var startDate=document.getElementById("appDate").value;
    obj=document.getElementById("appTime");
    if((obj)&&(obj.value!="")) var startTime=obj.value;
    else var startTime=""
    obj=document.getElementById("arrTime")
    if(obj) var arrTime=obj.value;
    else var arrTime=""

    var opmem=document.getElementById("opmem").value;
    var appUser=session['LOGON.USERID'];
    var bloodType=document.getElementById("bloodType").value;
    if (BloodRowId=="") BloodRowId=bloodType;
    obj=document.getElementById("patHeight")
    if (obj) {var patHeight=obj.value; }
    else {var patHeight="";}
    obj=document.getElementById("patWeight")
    if(obj) {var patWeight=obj.value;}
    else {var patWeight="";}
    obj=document.getElementById("opDocNote")
    if(obj) {var opDocNote=obj.value;}
    else {var opDocNote="";}
    var assDocDescStr=docDescList[1];
    for (i=2;i<assNum+1;i++) 
    {
	    assDocDescStr=assDocDescStr+"|"+docDescList[i];
    }
    var docNote=opDocNote+"|"+docDescList[0]+"|"+assDocDescStr;
    obj=document.getElementById("anaDocNote")
    if(obj) {var anaDocNote=obj.value;}
    else {var anaDocNote="";}
    obj=document.getElementById("opSeqNote")
    if(obj) {var opSeqNote=obj.value;}
    else {var opSeqNote="";}
	obj=document.getElementById("anaLevel")
	if ((obj)&&(obj.value=="")) ANCOPLRowId="";
    var str1=appLocId+"^"+appDocId+"^"+startDate+"^"+startTime+"^"+appUser+"^"+EpisodeID+"^"+operRoomId+"^"+opmem+"^"+BloodRowId+"^"+arrTime+"^"+ANCOPLRowId+"^"+patHeight+"^"+patWeight+"^"+preDiscussDate+"^"+estiOperDuration+"^"+opDocNote+"^"+opSeqNote
     //alert(str1)
    //multiply anaMethod
    obj=document.getElementById('anaMethodList');
	if (obj.length>0)
	{
		for(var i=0;i<obj.length;i++) anmthId=anmthId+obj.options[i].value+"|";
	}
	var obj=document.getElementById('docAnMethodList');
	if (obj)
	{
		if (obj.length>0)
		{
			for(var i=0;i<obj.length;i++) docanmthId=docanmthId+obj.options[i].value+"|";
		}
	}
    var anaDocId=document.getElementById("anaDocId").value;
    //first item in listbox is main operation
    obj=document.getElementById('operList');
	if (obj.length>0)
	{
		var tmpOPDescId=obj.options[0].value.split("|");
		var mainOPId=tmpOPDescId[0];
		var mainOPLevelId=tmpOPDescId[1];
		var mainBladeTypeId=tmpOPDescId[2];
		var tmpOPDesc=obj.options[0].text.split(t['val:opNote']);
		var mainOPNote=tmpOPDesc[1].replace(" ","");
		//operID|oplevelID|oper note|opbladeTypeID
		opId=mainOPId+"|"+mainOPLevelId+"|"+mainOPNote+"|"+mainBladeTypeId; 	
	}
	obj=document.getElementById("anaopPreDiagMem");
    if(obj) var anaopPreDiagMem=obj.value;
    else var anaopPreDiagMem=""
    obj=document.getElementById("anaopPostDiagMem");
    if(obj) var anaopPostDiagMem=obj.value;
    else var anaopPostDiagMem="";
    var anaopPreDiagnosisStr="",anaopPostDiagnosisStr="";  //2010.11.05   anaopPostDiagStr
    obj=document.getElementById("anaopPreDiagnosis");
    if(obj) var anaopPreDiagnosisStr=obj.value;
    else var anaopPreDiagnosisStr="";
    if(anaopPreDiagnosisStr!="")          //zhangtao 20101105
    {
    var obj=document.getElementById("ifUserDef")
	if(obj){ifUserDef=obj.value}
	var ret=cspRunServerMethod(ifUserDef,"preDiagDef",preDiagId)
    var ifPreDiagDef=ret.split("!")[0];
    var tmpPreDiagId=ret.split("!")[1];
    var tmpPreDiagDesc=ret.split("!")[2]
    if((ifPreDiagDef=="Y")&&(tmpPreDiagId==""))
    {preDiagId=anaopPreDiagnosisStr} 
    if((ifPreDiagDef=="Y")&&(tmpPreDiagId!="")&&(tmpPreDiagDesc!=anaopPreDiagnosisStr))
    {preDiagId=anaopPreDiagnosisStr}
    if((ifPreDiagDef=="N")&&(tmpPreDiagId==""))
    {alert(t['val:noUserDef']);
     return;}
    if((ifPreDiagDef=="N")&&(tmpPreDiagId!="")&&(tmpPreDiagDesc!=anaopPreDiagnosisStr))
    {alert(t['val:noUserDef']);
     return;}
    }
    obj=document.getElementById("anaopPostDiagnosis");
    if(obj) var anaopPostDiagnosisStr=obj.value;
    else var anaopPostDiagnosisStr="";
    if(anaopPostDiagnosisStr!="")
    {var obj=document.getElementById("ifUserDef")
   if(obj){ifUserDef=obj.value}
	var ret=cspRunServerMethod(ifUserDef,"postDiagDef",postdiagId)
    var ifPostDiagDef=ret.split("!")[0];
    var tmpPostDiagId=ret.split("!")[1];
    var tmpPostDiagDesc=ret.split("!")[2]
    if((ifPostDiagDef=="Y")&&(tmpPostDiagId==""))
    {postdiagId=anaopPostDiagnosisStr} 
    if((ifPostDiagDef=="Y")&&(tmpPostDiagId!="")&&(tmpPostDiagDesc!=anaopPostDiagnosisStr))
    {postdiagId=anaopPostDiagnosisStr}
    if((ifPostDiagDef=="N")&&(tmpPostDiagId==""))
    {alert(t['val:noUserDef']);
     return;}
    if((ifPostDiagDef=="N")&&(tmpPostDiagId!="")&&(tmpPostDiagDesc!=anaopPostDiagnosisStr))
    {alert(t['val:noUserDef']);
     return;} 
     }
    var diag=""
	if(anaopPostDiagnosisStr=="")   //preDiagId and postDiagId
	{
		var digId=preDiagId;
	}
    else
    {
	    var digId=preDiagId+"/"+postdiagId;
	}
	if(anaopPostDiagMem!="") //preDiagMem and postDiagMem
	{
		var digmem=anaopPreDiagMem+"/"+anaopPostDiagMem;
	}
	else
	{
		var digmem=anaopPreDiagMem;
	}
    diag=digId+"|"+digmem;
    //var op=opId+"^"+preDiagId+"^"+opDocId;
    var op=opId+"^"+diag+"^"+docIdList[0];
    var ass=docIdList[1];
    for (i=2;i<assNum+1;i++) 
    {
	    ass=ass+"^"+docIdList[i];
    }
    var assO=GetListData("assistDocList")
    if(assO!="") ass=ass+"^"+assO

    var scrubNurseId=document.getElementById("scrubNurseId").value;
    var scrubNurseId1=document.getElementById("scrubNurseId1").value;
    var circulNurseId=document.getElementById("circulNurseId").value;
    var circulNurseId1=document.getElementById("circulNurseId1").value;
    
    var insertAnRecord=document.getElementById("insertAnRecord").value;
    var HBSAG=document.getElementById("HBSAG");
    var HCVAB=document.getElementById("HCVAB");
    var HIVAB=document.getElementById("HIVAB");
    var chmd=document.getElementById("chmd");
    var RHBloodType=document.getElementById("RHBloodType");    
    var qt=document.getElementById("qt").value;
    var chbsag=GetComboData(HBSAG);
    var chcvab=GetComboData(HCVAB);
    var chivab=GetComboData(HIVAB);
    var chmd=GetComboData(chmd);
    var RHBloodType=GetComboData(RHBloodType); 
    var seloptyp=document.getElementById("seloptyp");
    var seljz
    if (seloptyp.checked==true)	seljz=1
    else seljz=0
    var isolatedFlag=document.getElementById("isolated");
    var isolated
    if (isolatedFlag.checked==true) isolated="Y"
    else  isolated="N"
    var isPrepareBloodFlag=document.getElementById("isPrepareBlood");
    var isPrepareBlood
    if (isPrepareBloodFlag.checked==true) isPrepareBlood="Y"
    else  isPrepareBlood="N"
    var isUseSelfBloodFlag=document.getElementById("isUseSelfBlood");
    var isUseSelfBlood
    if (isUseSelfBloodFlag.checked==true) isUseSelfBlood="Y"
    else  isUseSelfBlood="N"
    var isExCirculationFlag=document.getElementById("isExCirculation");
    var isExCirculation
    if (isExCirculationFlag.checked==true) isExCirculation="Y"
    else  isExCirculation="N"
    obj=document.getElementById("NeedAnaesthetist"); // +wxl 090316
    var NeedAnaesthetist    
    if (obj.checked==true) NeedAnaesthetist="Y";
    else  NeedAnaesthetist="N";
    obj=document.getElementById("ifMiniInvasive");
    var ifMiniInvasive="";
    if (obj)
    {
    	if (obj.checked==true) ifMiniInvasive="Y";
    	else  ifMiniInvasive="N";
    }
    obj=document.getElementById("NeedNavigation")
    var NeedNavigation=""
    if (obj)
    {
	    if(obj.checked==true) var NeedNavigation="Y";
	    else NeedNavigation="N";
    }
    var strcheck=chbsag+"^"+chcvab+"^"+chivab+"^"+chmd+"^"+seljz+"^"+qt+"^"+RHBloodType+"^"+isolated+"^"+isPrepareBlood+"^"+isUseSelfBlood+"^"+isExCirculation+"^"+NeedAnaesthetist+"^"+ifMiniInvasive+"^"+NeedNavigation
    //alert(strcheck)
    obj=document.getElementById("opreq");
    if(obj) var opreq=obj.value;
    else var opreq=""
    obj=document.getElementById("note")
    if(obj) var note=obj.value;
    else var note=""
    obj=document.getElementById("ifShift");
    var ifShift;
    if(obj)
    {
	    if (obj.checked==true) var ifShift="1"
	    else var ifShift="0"
	 }
    else var ifShift="0"
    obj=document.getElementById("anaDocId1");
    if(obj) var anaDocId1=obj.value;
    else var anaDocId1=""
    obj=document.getElementById("anaSupervisorId");   ///ck091203
    if(obj) var anaSupervisor=obj.value;
    else var anaSupervisor=""    ///ck091203
    obj=document.getElementById("sAnaDocId");
    if(obj) var sAnaDocId=obj.value;
    else var sAnaDocId=""
    obj=document.getElementById("sAnaDocId1");
    if(obj) var sAnaDocId1=obj.value;
    else var sAnaDocId1=""
    obj=document.getElementById("sCirculNurseId");
    if(obj) var sCirculNurseId=obj.value;
    else var sCirculNurseId=""
    obj=document.getElementById("sScrubNurseId");
    if(obj) var sScrubNurseId=obj.value;
    else var sScrubNurseId=""
    obj=document.getElementById("sCirculNurseId1");
    if(obj) var sCirculNurseId1=obj.value;
    else var sCirculNurseId1=""
    obj=document.getElementById("sScrubNurseId1");
    if(obj) var sScrubNurseId1=obj.value;
    else var sScrubNurseId1=""
    obj=document.getElementById("ordno");
    if(obj) var ordno=obj.value;
    else var ordno=""
    str1=str1+"^"+ordno+"^^";//seqno^appDate^appTime
    obj=document.getElementById("medInfect")
    if(obj) var opaMedInfect=obj.value;
    else var opaMedInfect=""
    str1=str1+"^"+opaMedInfect+"^"+transferMeansCode; 
    //alert(str1)
    var anaDocStr=anaDocId1
    var anaDocStr1=GetListData("anaDocList")
    if (document.getElementById("anaDocList")) anaDocStr=anaDocStr1
    var sAnaDocStr=sAnaDocId+"^"+sAnaDocId1
    var sAnaDocStr1=GetListData("sAnaDocList")
    if (document.getElementById("sAnaDocList")) sAnaDocStr=sAnaDocStr1
    var ancpt=anaDocStr+"!"+sAnaDocStr+"!"+ASARowId
    
    var scrubNurStr=scrubNurseId+"^"+scrubNurseId1
    var scrubNurStr1=GetListData("scrubNurseList")
    if (document.getElementById("scrubNurseList")) scrubNurStr=scrubNurStr1
    var sScrubNurseIdStr=sScrubNurseId+"^"+sScrubNurseId1
    var sScrubNurseIdList=GetListData("sScrubNurseList")
    if (document.getElementById("sScrubNurseList")) sScrubNurseIdStr=sScrubNurseIdList
    var scr=scrubNurStr+"!"+sScrubNurseIdStr
    var scrubNurseNote="";
    obj=document.getElementById("scrubNurseNote");
    if (obj) scrubNurseNote=obj.value;
    var scr=scr+"!"+scrubNurseNote;
    
    var circulNurseIdStr=circulNurseId+"^"+circulNurseId1
    var circulNurseIdList=GetListData("circulNurseList")
    if (document.getElementById("circulNurseList")) circulNurseIdStr=circulNurseIdList
    var sCirculNurseIdStr=sCirculNurseId+"^"+sCirculNurseId1
    var sCirculNurseIdList=GetListData("sCirculNurseList")
    if (document.getElementById("sCirculNurseList")) sCirculNurseIdStr=sCirculNurseIdList
    var cir=circulNurseIdStr+"!"+sCirculNurseIdStr
    var circulNurseNote="";
    obj=document.getElementById("circulNurseNote");
    if (obj) circulNurseNote=obj.value;
    var cir=cir+"!"+circulNurseNote;
    
    var opdate="" ; 
    var optime="" ;
    if (appType=="RegOp"){
	    var optime=opSttDate.value+"|"+opSttTime.value+"|"+opEndDate.value+"|"+opEndTime.value;
    }     
    obj=document.getElementById("anaopPreDiagMem");
    if(obj) var anaopPreDiagMem=obj.value;
    else var anaopPreDiagMem=""
    
    obj=document.getElementById("mainPack");
    var mainPack="";if (obj) mainPack=obj.value;
    obj=document.getElementById("secPack");
    var secPack=""; if (obj) secPack=obj.value;
    obj=document.getElementById("thrPack")
    var thrPack="";if (obj) thrPack=obj.value;
    obj=document.getElementById("mainPackId");
    if(obj) var mainPackId=obj.value;
    else var mainPackId=""
    obj=document.getElementById("secPackId");
    if(obj) var secPackId=obj.value;
    else var secPackId=""
    obj=document.getElementById("thrPackId");
    if(obj) var thrPackId=obj.value;
    else var thrPackId=""
    var OpPack=mainPack+"|"+mainPackId+"!"+secPack+"|"+secPackId+"!"+thrPack+"|"+thrPackId
    obj=document.getElementById("isAddInstrument");
    var isAddInstrument="N";
    if((obj)&&(obj.checked==true)) isAddInstrument="Y";
    var strward=appUser+"^"+opreq+"^"+note+"^"+ifShift+"^"+ordno+"^"+isAddInstrument+"|"+instrumentId+"^"+optime;
    obj=document.getElementById("operLocation");
    var operLocation=""; 
    if (obj) operLocation=obj.value;
    //save multi-bodySiteList
    obj=document.getElementById('bodySiteList');
	if (obj.length>0)
	{
		for(var i=0;i<obj.length;i++) bodySiteId=bodySiteId+obj.options[i].value+"|";
	}
	//alert(opaId+"/"+op+"/"+ass+"/"+docIdList+"/"+docDescList)
	var obj=document.getElementById("operPosition");
	if ((obj)&&(obj.value=="")) operPositionId="";
	op=op+"^"+anaopPreDiagMem+"^"+operLocation+"^"+bodySiteId+"^"+operPositionId;
    var ret;
    switch(appType)
    {
		case "RegOp":
		case "RegNotApp": 
			var updatewardRecord=document.getElementById("updatewardRecord").value;
			if (opaId!="") 
			{
				ret=cspRunServerMethod(updatewardRecord,"InsertAddOnOperation","",opaId,str1,op,ass,strcheck,anmthId);
				if (ret!=0){alert(ret);return}
			}
			else {
				ret=cspRunServerMethod(insertAnRecord,"InsertAddOnOperation","",str1,op,ass,strcheck,anmthId);
				if (ret.split("^")[0]<0) {alert(ret);return;}
				else opaId=ret;
			}
			var updateopRecord=document.getElementById("updateopRecord").value;
			var ret=cspRunServerMethod(updateopRecord,opaId ,str1, scr, cir,strward,appType);
			if (ret!=0){alert(ret);return}
			var updateanRecord=document.getElementById("updateanRecord").value;
			//var ret=cspRunServerMethod(updateanRecord,opaId,anmthId,anaDocId,anaNurseId,ancpt);
			var ret=cspRunServerMethod(updateanRecord,opaId,anmthId,anaDocId,anaNurseId,ancpt,anaSupervisor,anaDocNote);
			if (ret!=0){alert(ret);return}
		break;
		case "ward":  //doctor apply: new and update
		   anmthId=docanmthId
		   var obj=document.getElementById('seloptyp');
           if(obj)selOpType=obj.checked;
			var IfOutTime=document.getElementById("IfOutTime")
			if(IfOutTime)
			{
				var ifDisbled=IfOutTime.value;
				if((ifDisbled==1)&(opaId=="")&(selOpType==false)&(admType!="E"))
				{
					alert(t['alert:OutTime'])
					return ;
				}
			}
			var updatewardRecord=document.getElementById("updatewardRecord").value;
			if (opaId!="")
			{
				var ret=cspRunServerMethod(updatewardRecord,"InsertAddOnOperation","",opaId,str1,op,ass,strcheck,anmthId); //ypz 070405
				if (ret!=0){alert(ret);return}
			}
			else
			{
				var now=new Date(); 
				var Time=0
				var objTime=document.getElementById('Time')
					if (objTime){
					var time=objTime.value;
					Time=cspRunServerMethod(time);
				}
				var seloptyp=document.getElementById("seloptyp");
				var Lseloptyp=""
				if (seloptyp.checked){Lseloptyp="1"}
				else{Lseloptyp="0"}
				if ((Time=="1")&&(Lseloptyp=="0")){
					alert(t['alert:changeToEmergy']);
					return;
				}
				else{
					var ret=cspRunServerMethod(insertAnRecord,"InsertAddOnOperation","",str1,op,ass,strcheck,anmthId,"",appType);  //ypz 070405
						if (ret.split("^")[0]<0) {alert(ret);return;}
				}
			}
		break;
		case "op":  //operation arrange
			var updateopRecord=document.getElementById("updateopRecord").value;
			var ret=cspRunServerMethod(updateopRecord,opaId ,str1, scr, cir,strward);
			if (ret!=0){alert(ret);return}
		break;
		case "anaes":  //anaesthesia arrange
			var updateanRecord=document.getElementById("updateanRecord").value;
			var ret=cspRunServerMethod(updateanRecord,opaId,anmthId,anaDocId,anaNurseId,ancpt,anaSupervisor,anaDocNote,ANCOPLRowId);
			if (ret!=0){alert(ret);return}
		break;
		default:
		break
	}
	//UpdateANArr(); //rem for user can use room arrange to update all room care provider
	if (appType=="ward")
	{
		btsave_click();
	}
	//opener.parent.frames["anopbottom"].location.reload();
	window.close();
	opener.location.reload();
}

function InsertAddOnOperation(curOpaId)
{
	var opstr="";
	var obj=document.getElementById('operList');
    var AnCompStr="";  // + wxl 090326
    var objAllAnComp=document.getElementById("allAnComp"); //+
	if ((obj.length==0)&&(objAllAnComp)&&(objAllAnComp.length==0)) return;
	//addtional operation from second items in listbox on
	if (obj.length>0)
	{
		for(var i=1;i<obj.length;i++)
		{
			var tmpOPDescId=obj.options[i].value.split("|");
			var subOPId=tmpOPDescId[0];
			var subOPLevelId=tmpOPDescId[1];
			var subBladeTypeId=tmpOPDescId[2];
			var tmpOPDesc=obj.options[i].text.split(t['val:opNote']);
			var subOPNote=tmpOPDesc[1].replace(" ","");
			//operID|oplevelID|oper note|opbladeTypeID
			opstr=opstr+subOPId+"|"+subOPLevelId+"|"+subOPNote+"|"+subBladeTypeId+"|"+tmpOPDescId[3]+"^";
		}
   		var insertchlop=document.getElementById('insertchlop').value;
   		//alert(curOpaId+"/"+opstr);return
   		var ret=cspRunServerMethod(insertchlop,"","",curOpaId,opstr,appType);
   		if (ret!=0) alert(ret)
	}	
    if ((objAllAnComp)&&(objAllAnComp.length>0)) // + wxl 090326
    {    
    	var i;
    	anCompId="";
		for (var i=0;i<objAllAnComp.length;i++)
    	{
			AnCompStr=AnCompStr+objAllAnComp.options[i].value+"^";
		}
		var insertAnaestComp=document.getElementById('insertAnaestComp').value;
   		var ret=cspRunServerMethod(insertAnaestComp,"","",curOpaId,AnCompStr);
    }
}

function Close_Click()
{
	window.close();
}
function NewAnopapp(lnk,nwin)	{
	/// if (EpisodeID==""||BillNo=="") {{alert(t['01']);return;}}
	//lnk+="&EpisodeID="+EpisodeID+"&BillNo="+BillNo;
	window.open(lnk,'_blank',nwin)	
}
function GetAppLoc(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("appLoc")
	if (obj){obj.value=loc[1]}
	appLocId=loc[0];
}
function GetDoc(str,i)
{
	var doc=str.split("^");
	if (i>0)
	{
		var obj=document.getElementById("assistDoc"+i)
	}
	else
	{
		var obj=document.getElementById("surgeon")
	}
	if (obj){obj.value=doc[1]}
	docIdList[i]=doc[0];
	docDescList[i]=doc[1];
	if(i==0) //liangq 20101116
	{
        setOpDocId(doc[0]);
    }
}
function GetSurgeon(str)
{
	GetDoc(str,0);
}
function GetAssistDoc1(str)
{
	GetDoc(str,1);
}
function GetAssistDoc2(str)
{
	GetDoc(str,2);
}
function GetAssistDoc3(str)
{
	GetDoc(str,3);
}
function GetAssistDoc4(str)
{
	GetDoc(str,4);
}
function GetAssistDoc5(str)
{
	GetDoc(str,5);
}
function GetAssistDocO(value)
{
	var obj=document.getElementById("assistDocO");
	if(obj){
		obj.value=""
		AddListRow("assistDocList",value);
	}
}
function GetAppDoc(str)
{
	var doc=str.split("^");
	var obj=document.getElementById("appDoc")
	if (obj) obj.value=doc[1]
	appDocId=doc[0];
}
function GetPreDiagnosis(str)
{
	var dia=str.split("^");
	preDiagId=dia[1];
}
function GetPostDiagnosis(str)
{
	var postdia=str.split("^");
	postdiagId=postdia[1];
}
function GetOperation(str)
{
	var op=str.split("^");
	opId=op[1];
	var obj=document.getElementById("opCategory"); // + wxl 090320
	if (obj) obj.value=op[2];
	var obj=document.getElementById("opStatName"); // + wxl 090819
	if (obj) obj.value=op[3];
	var obj=document.getElementById('GetOperRelated');
	if (obj)
	{
		var retStr=cspRunServerMethod(obj.value,opId);
		if (retStr=="") return;
		operRelatedList=retStr.split("^");
		if (operRelatedList.length<8) return;
		GetAnaopLevel(operRelatedList[0]+"^"+operRelatedList[1]);
		GetOpBladeType(operRelatedList[2]+"^"+operRelatedList[3])
		if ((operRelatedList[4]!="")&&(operRelatedList[5]!=""))
		{
			GetBodySite(operRelatedList[4]+"^"+operRelatedList[5]);
		}
		GetOperPosition(operRelatedList[6]+"^"+operRelatedList[7])
	}
}
function GetScrubNurse(value)
{
	SetElementFromListByName('scrubNurseId',"V",'scrubNurse',"V",value,"^",0,1)
}
function GetScrubNurse1(value)
{
	SetElementFromListByName('scrubNurseId1',"V",'srubNurse1',"V",value,"^",0,1)
}
function GetScrubNurseO(value)
{
	var obj=document.getElementById("scrubNurseO");
	if(obj){
		AddListRow("scrubNurseList",value);
		obj.value=""
	}
}
function GetCirculNurse(value)
{
	SetElementFromListByName('circulNurseId',"V",'circulNurse',"V",value,"^",0,1)
}
function GetCirculNurse1(value)
{
	SetElementFromListByName('circulNurseId1',"V",'circulNurse1',"V",value,"^",0,1)
}
function GetCirculNurseO(value)
{
	var obj=document.getElementById("circulNurseO");
	if(obj){
		AddListRow("circulNurseList",value);
		obj.value=""
	}
}
function GetAnaDoc(value)
{
	SetElementFromListByName('anaDocId',"V",'anaDoc',"V",value,"^",0,1)
}
function GetAnaDoc1(value)
{
	SetElementFromListByName('anaDocId1',"V",'anaDoc1',"V",value,"^",0,1)
}
function GetAnaDocO(value)
{
	var obj=document.getElementById("anaDocO");
	if(obj){
		AddListRow("anaDocList",value);
		obj.value=""
	}
}
function GetAnaMethod(str)
{
	var anmth=str.split("^");
	var anaMethod=document.getElementById('anaMethod');
	anaMethod.value="";
    var objSelected = new Option(anmth[0], anmth[1]);
	var obj=document.getElementById('anaMethodList');
	if (obj) obj.options[obj.options.length]=objSelected;		
}
function GetDocAnaMethod(str)                                 //2011
{  
	var anmth=str.split("^");
	var docanmethod=document.getElementById('docAnMethod');
	docanmethod.value="";
       var objAddList = new Option(anmth[0], anmth[1]);
	var docanMethodObj=document.getElementById('docAnMethodList');
	if (docanMethodObj) docanMethodObj.options[docanMethodObj.options.length]=objAddList;
	var anmethod=document.getElementById('anaMethod');
	anmethod.value="";
	var anMethodObj=document.getElementById('anaMethodList');
    var objSelected = new Option(anmth[0], anmth[1])
	if (anMethodObj) anMethodObj.options[anMethodObj.options.length]=objSelected;
    		
}
function GetOperRoom(str)
{
	var room=str.split("^");
	operRoomId=room[0];
	var obj=document.getElementById('operRoom');
	if (obj) obj.value=room[1];
	var objGetAnArr=document.getElementById("GetANArr")
	if(objGetAnArr)
	{
		var getAnArr=objGetAnArr.value;
		//var retStr=cspRunServerMethod(getAnArr,roomId);
		//if(retStr!="") alert(retStr)
	}
}
function GetSAnaDoc(value)	{
	SetElementFromListByName('sAnaDocId',"V",'sAnaDoc',"V",value,"^",0,1)
}
function GetSAnaDoc1(value)	{
	SetElementFromListByName('sAnaDocId1',"V",'sAnaDoc1',"V",value,"^",0,1)
}
function GetSAnaDocO(value)	{
	var obj=document.getElementById("sAnaDocO");
	if(obj){
		AddListRow("sAnaDocList",value);
		obj.value=""
	}
}
function GetSScrubNurse(value)	{
	SetElementFromListByName('sScrubNurseId',"V",'sScrubNurse',"V",value,"^",0,1)
}
function GetSScrubNurse1(value)	{
	SetElementFromListByName('sScrubNurseId1',"V",'sScrubNurse1',"V",value,"^",0,1)
}
function GetSScrubNurseO(value)	{
	var obj=document.getElementById("sScrubNurseO");
	if(obj){
		AddListRow("sScrubNurseList",value);
		obj.value=""
	}
}
function GetSCirculNurse(value)
{
	SetElementFromListByName('sCirculNurseId',"V",'sCirculNurse',"V",value,"^",0,1)
}
function GetSCirculNurse1(value)
{
	SetElementFromListByName('sCirculNurseId1',"V",'sCirculNurse1',"V",value,"^",0,1)
}
function GetSCirculNurseO(value)
{
	var obj=document.getElementById("sCirculNurseO");
	if(obj){
		AddListRow("sCirculNurseList",value);
		obj.value=""
	}
}
function GetAddOnOperation(value)
{
	var user=value.split("^");
	var selop=document.getElementById('selop');
	selop.value="";
    var objSelected = new Option(user[0], user[1]);
	var obj=document.getElementById('operList');
	obj.options[obj.options.length]=objSelected;
	var addOPCat = new Option(user[2], user[1]);// + wxl 090320
	var obj=document.getElementById("addOpCategory"); 
	if (obj) obj.options[obj.options.length]=addOPCat;//+
	var addOpStatName = new Option(user[3], user[1]);// + wxl 090819
	var obj=document.getElementById("addOpStatName"); 
	if (obj) obj.options[obj.options.length]=addOpStatName;//+
}
function GetMainPack(value)
{
	var user=value.split("^");
	var obj=document.getElementById('mainPackId');
	if (obj) obj.value=user[1];
}
function GetSecondPack(value)
{
	var user=value.split("^");
	var obj=document.getElementById('secPackId');
	if (obj) obj.value=user[1];
}
function GetThirdPack(value)
{
	var user=value.split("^");
	var obj=document.getElementById('thrPackId');
	if (obj) obj.value=user[1];
}
function GetBodySite(str)
{
	var body=str.split("^");
	var bodySite=document.getElementById('bodySite');
	if(bodySite) bodySite.value="";
    var objSelected = new Option(body[1], body[0]);
	var obj=document.getElementById('bodySiteList');
	if (obj) obj.options[obj.options.length]=objSelected;
}
function GetASA(str)
{
	var ret=str.split("^");
	ASARowId=ret[0];
	var obj=document.getElementById("ASA")
	obj.value=ret[1];
}
function GetAnaLevel(str)
{
	var ret=str.split("^");
	ANCOPLRowId=ret[0];
	var obj=document.getElementById("anaLevel")
	obj.value=ret[1];
}
function GetBlood(str)
{
	var ret=str.split("^");
	BloodRowId=ret[0];
	var obj=document.getElementById("bloodType")
	obj.value=ret[1];
}
function RHBloodType_Click()
{
    var RHBloodType=document.getElementById("RHBloodType");
	if(RHBloodType)
	{
		var RHBloodType=GetComboData(RHBloodType);
		if(RHBloodType==t['val:negative'])
		{
			document.getElementById("RHBloodType").style.color ="red" ;
		}
		else
		{
			document.getElementById("RHBloodType").style.color=""
		}
	}
}
function OpName_Blur()
{
	var objOpName=document.getElementById("opName");
	if (objOpName){
		if (objOpName.value=="") opId="";
	}
}
function List_DublClick(elementName)
{
	var objList=document.getElementById(elementName);
	var objSelected=objList.selectedIndex;
	objList.remove(objSelected) ;
}
function AddListRow(elementName,dataValue)
{
	var valueList=dataValue.split("^");
	var objList=document.getElementById(elementName);
	if ((objList)&&(valueList.length>1))
	{
    	var objSelected = new Option(valueList[1], valueList[0]);
		objList.options[objList.options.length]=objSelected;
	}
}
function InitListRow(elementName,dataValue)
{
	var listData=dataValue.split("^");
	var objList=document.getElementById(elementName);
	if(objList){
		for (var i=0;i<listData.length;i++)
			{
			if (listData[i]!="")
			{
				var listRowItem=listData[i].split("!");
				var sel=new Option(listRowItem[0],listRowItem[1]);
				objList.options[objList.options.length]=sel;
			}
		}
	}
}
function GetListData(elementName)
{
	var retString
	retString=""
	var objList=document.getElementById(elementName);
	if(objList){
		for (var i=0;i<objList.options.length;i++)
	   	{
		   if (objList.options[i].value!="")
		   {
			   if(retString==""){
				   retString=objList.options[i].value
			   }
			   else{
				   retString=retString+"^"+objList.options[i].value
			   }
		   }
		}
	}
	return retString
}
function HideElement(elementName)
{
	var obj=document.getElementById(elementName);
	if(obj){
		obj.style.display ="none";
	}
	var obj=document.getElementById("c"+elementName);
	if(obj){
		obj.style.display ="none";
	}
	DisableById(componentId,elementName);
}
function GetInstrument(str)
{
	var ret=str.split("^");
	instrumentId=ret[0];
	var obj=document.getElementById("instrument")
	obj.value=ret[1];
}
function GetOperPosition(str)
{
	var ret=str.split("^");
	operPositionId=ret[0];
	var obj=document.getElementById("operPosition")
	obj.value=ret[1];
}
function GetAnaNurse(str)
{
	var ret=str.split("^");
	anaNurseId=ret[0];
	var obj=document.getElementById("anaNurse")
	obj.value=ret[1];
}
function getAnaestComp(str)
{
	var ret=str.split("^");
	var objAnCompDesc=document.getElementById("anCompDesc");
	objAnCompDesc.value="";
	var objSelected = new Option(ret[0], ret[1]);
	var obj=document.getElementById('allAnComp');
	obj.options[obj.options.length]=objSelected;
}
function GetDocGroup(value){
	var str=value.split("^")
	var str0=str[0].split(":")
	var str1=str[1].split(":")
	var docGroupDesc=str0[1].split(",")
	var docGroupId=str1[1].split(",")
	var obj=document.getElementById("surgeon")
		obj.value=docGroupDesc[0]
		docIdList[0]=docGroupId[0]
	for (var i=1;i<6;i++)
	{
		var obj=document.getElementById("assistDoc"+i);
		if (obj){
			obj.value=docGroupDesc[i];
			docIdList[i]=docGroupId[i];
		}
	}
}
function GetAnaSupervisor(value)
{
	SetElementFromListByName('anaSupervisorId',"V",'anaSupervisor',"V",value,"^",0,1)
}
function AssayReslut_Click()
{
    var eSrc=window.event.srcElement;
	var objOp=document.getElementById(eSrc.name);
	if(objOp)
	{
		var objOpValue=GetComboData(objOp);
		if(objOpValue==t['val:positive'])
		{
			objOp.style.color ="red" ;
		}
		else
		{
			objOp.style.color=""
		}
	}
}
function GetAnaopLevel(str)//main operation level
{
	var ret=str.split("^");
	anaopLevelId=ret[0];
	var obj=document.getElementById("anaopLevel");
	obj.value=ret[1];
}
function GetOpBladeType(str)//main operation blade type 
{
	var ret=str.split("^");
	opBladeTypeId=ret[0];
	var obj=document.getElementById("opBladeType");
	obj.value=ret[1];
}
function AddClick()//add operation name ect. 
{
	var opName="",opCategory="",opStatName="",anaopLevel="",opBladeType="",opNote="";
	var objOpName=document.getElementById("opName");
	if (objOpName) var opName=objOpName.value;
	var obj=document.getElementById("ifUserDef")       //zhangtao 20101029
    if(obj){ifUserDef=obj.value}
    var ret=cspRunServerMethod(ifUserDef,"opNameDef",opId)
    var ifOpNameDef=ret.split("!")[0];
    var tmpOpId=ret.split("!")[1];
    var tmpOpName=ret.split("!")[2]
    if((ifOpNameDef=="Y")&&(tmpOpId==""))
    {opId=opName} 
    if((ifOpNameDef=="Y")&&(tmpOpId!="")&&(tmpOpName!=opName))
    {opId=opName}
    if((ifOpNameDef=="N")&&(tmpOpId==""))
    {alert(t['val:noUserDef']);
     return;}
    if((ifOpNameDef=="N")&&(tmpOpId!="")&&(tmpOpName!=opName))
    {alert(t['val:noUserDef']);
     return;}
	var objAnaopLevel=document.getElementById("anaopLevel");
	if (objAnaopLevel) var anaopLevel=objAnaopLevel.value;
	var objOpBladeType=document.getElementById("opBladeType");
	if (objOpBladeType) var opBladeType=objOpBladeType.value;	
	var objOpNote=document.getElementById("opNote");
	if (objOpNote) var opNote=objOpNote.value;
	if (((opName!="")||(opNote!=""))&&(anaopLevel!="")){
		var opDescId=opId+"|"+anaopLevelId+"|"+opBladeTypeId+"|";
		var opDesc=t['val:opName']+opName+"  "+t['val:oplevel']+anaopLevel+"  "+t['val:bladetype']+opBladeType+"  "+t['val:opNote']+opNote;
    	var objSelected = new Option(opDesc,opDescId);
		var obj=document.getElementById('operList');
		obj.options[obj.options.length]=objSelected;
		opId="";
		anaopLevelId="";
		opBladeTypeId="";
		if (objOpName) objOpName.value="";
		if (objAnaopLevel) objAnaopLevel.value="";
		if (objOpBladeType) objOpBladeType.value="";	
		if (objOpNote) objOpNote.value="";
	}
	else {
		alert(t['alert:selnameorlevel']);
		return;
	}
}
function UpdateClick()//update operation name ect.
{
	var opName="",opCategory="",opStatName="",anaopLevel="",opBladeType="",opNote="";
	var objOperList=document.getElementById("operList");
  	if (!objOperList) return;
  	var Index=objOperList.selectedIndex;
  	if (Index<0){
  		alert(t['alert:selOper']);
  		return;
  	}
  	var opDescId=objOperList.options[Index].value;
  	var tmpOpDescId=opDescId.split("|");
  	var anaopSub="";
  	if (tmpOpDescId[3]) anaopSub=tmpOpDescId[3];
	var objOpName=document.getElementById("opName");
	if (objOpName) var opName=objOpName.value;
	var obj=document.getElementById("ifUserDef")        //zhangtao 20101029
    if(obj){ifUserDef=obj.value}
    var ret=cspRunServerMethod(ifUserDef,"opNameDef",opId)
    var ifOpNameDef=ret.split("!")[0];
    var tmpOpId=ret.split("!")[1];
    var tmpOpName=ret.split("!")[2]
    if((ifOpNameDef=="Y")&&(tmpOpId==""))
    {opId=opName} 
    if((ifOpNameDef=="Y")&&(tmpOpId!="")&&(tmpOpName!=opName))
    {opId=opName}
    if((ifOpNameDef=="N")&&(tmpOpId==""))
    {alert(t['val:noUserDef']);
     return;}
	var objAnaopLevel=document.getElementById("anaopLevel");
	if (objAnaopLevel) var anaopLevel=objAnaopLevel.value;
	var objOpBladeType=document.getElementById("opBladeType");
	if (objOpBladeType) var opBladeType=objOpBladeType.value;	
	var objOpNote=document.getElementById("opNote");
	if (objOpNote) var opNote=objOpNote.value;
	if (((opName!="")||(opNote!=""))&&(anaopLevel!="")){
		opDescId=opId+"|"+anaopLevelId+"|"+opBladeTypeId+"|"+anaopSub;
		var opDesc=t['val:opName']+opName+"  "+t['val:oplevel']+anaopLevel+"  "+t['val:bladetype']+opBladeType+"  "+t['val:opNote']+opNote;
    	objOperList.options[Index].value=opDescId;
		objOperList.options[Index].text=opDesc;
		opId="";
		anaopLevelId="";
		opBladeTypeId="";
		if (objOpName) objOpName.value="";
		if (objAnaopLevel) objAnaopLevel.value="";
		if (objOpBladeType) objOpBladeType.value="";	
		if (objOpNote) objOpNote.value="";
		objOperList.selectedIndex=-1;
	}
	else {
		alert(t['alert:selnameorlevel']);
		return;
	}
}
function DeleteClick()//delete operation name ect.
{
	var operList=document.getElementById("operList");
  	var a=operList.selectedIndex;
  	if (a<0)
  	{
	  	alert(t['alert:selOper']);
  		return;
  	}
  	operList.remove(a) ;
  	var obj=document.getElementById("opName");
	if (obj) obj.value="";
	var obj=document.getElementById("anaopLevel");
	if (obj) obj.value="";
	var obj=document.getElementById("opBladeType");
	if (obj) obj.value="";	
	var obj=document.getElementById("opNote");
	if (obj) obj.value="";
	opId="";
	anaopLevelId="";
	opBladeTypeId="";
}
function OperList_Change()//select one operation name ect.
{
  	var objOperList=document.getElementById("operList");
  	if (!objOperList) return;
  	var Index=objOperList.selectedIndex;
  	if (Index<0) return;
	var opDesc=objOperList.options[Index].text
	var opDescId=objOperList.options[Index].value;
	var tmpOPDescId=opDescId.split("|");
	opId=tmpOPDescId[0];
	anaopLevelId=tmpOPDescId[1];
	opBladeTypeId=tmpOPDescId[2];
	var tmpOPDesc=opDesc.split(t['val:opName']);
	var tmpOPDesc1=tmpOPDesc[1].split(t['val:oplevel']);
	var tmpOPDesc2=tmpOPDesc1[1].split(t['val:bladetype']);
	var tmpOPDesc3=tmpOPDesc2[1].split(t['val:opNote']);
	var objOpName=document.getElementById("opName");
	if (objOpName) objOpName.value=tmpOPDesc1[0].replace(/ /g,"");
	var objAnaopLevel=document.getElementById("anaopLevel");
	if (objAnaopLevel) objAnaopLevel.value=tmpOPDesc2[0].replace(/ /g,"");
	var objOpBladeType=document.getElementById("opBladeType");
	if (objOpBladeType) objOpBladeType.value=tmpOPDesc3[0].replace(/ /g,"");
	var objOpNote=document.getElementById("opNote");
	if (objOpNote) objOpNote.value=tmpOPDesc3[1];
}
function AnaMethodList_Dublclick()//delete anaMethod
{
	var obj=document.getElementById("anaMethodList");
	var a=obj.selectedIndex;
	obj.remove(a) ;
}
function docAnMethodList_Dublclick()                    //2011
{
  var obj1=document.getElementById("docAnMethodList");
  var a=obj1.selectedIndex;
  obj1.remove(a) ;
  var obj2=document.getElementById("anaMethodList");
  obj2.remove(a) ;
}
//get default operation and room
function DefOpLocRoom(){
	var obj=document.getElementById("GetOPLocRoom")
	if (obj) {
		var GetOPLocRoom=obj.value;
		var operLocation=document.getElementById("operLocation");
		if (appLocId=="") appLocId=session['LOGON.CTLOCID'];
		var RetOPLocRoom=cspRunServerMethod(GetOPLocRoom,appLocId,"");
		if (RetOPLocRoom=="") return; 
		var StrOPLocRoom=RetOPLocRoom.split("^");
		if (operLocation) operLocation.value=StrOPLocRoom[0].split("|")[1];
		operRoomId=StrOPLocRoom[1].split("|")[0];
		var obj=document.getElementById("operRoom");
		if (obj) obj.value=StrOPLocRoom[1].split("|")[1];
	}
}
function SetEleFocus(elementName)
{
    var obj=document.getElementById(elementName);
    if (obj) {
		obj.focus();
		return false;
	}
}
//get latest lab result
function GetLabInfo(EpisodeID){
	//alert(EpisodeID)
	var obj=document.getElementById("getLabInfo");
	if (obj) {var encmeth=obj.value} else {var encmeth='';return;};
	var myExpStr="";
	var LabInfoStr=cspRunServerMethod(encmeth,"^"+EpisodeID);
	var LabInfo=LabInfoStr.split("^");
	if(LabInfo[0].length>0){
		LabBloodType.value=LabInfo[0];
	}
	else{LabBloodType.value=t['val:unknow']}

	var RHBloodTypeFlag=0;
	if(LabInfo[1].length>0){
		for (i=0;i<LabRHBloodType.length;i++) {
	    	if (LabRHBloodType.options[i].text==LabInfo[1].substr(LabInfo[1].length-2)){
	      		LabRHBloodType.options[i].selected=true;
	      		RHBloodTypeFlag=1;
	    	}	
		}
	}
	else if(RHBloodTypeFlag==0){
	LabRHBloodType.options[0].selected=true;}

	if(LabInfo[6].length>0){
		if(LabALT) LabALT.value=LabInfo[6];
	}	
	else{
		if(LabALT) LabALT.value=""
	}

	var HBSAGFlag=0;
	if(LabInfo[8].length>0){
		for (i=0;i<LabHBSAG.length;i++) {
	    	//if (LabHBSAG.options[i].text==LabInfo[8].substr(LabInfo[8].length-2))
	    	if (LabHBSAG.options[i].text==LabInfo[8].substr(0,2))
	    	{   alert(LabInfo[8].substr(0,2))
	      		LabHBSAG.options[i].selected=true;
	      		HBSAGFlag=1;
	    	}	
		}
	}
	else if(HBSAGFlag==0){
	LabHBSAG.options[0].selected=true;}

	var HCVABFlag=0;
	if(LabInfo[12].length>0){
		for (i=0;i<LabHCVAB.length;i++) {
	    	//if (LabHCVAB.options[i].text==LabInfo[12].substr(LabInfo[12].length-2)){
		    	if (LabHCVAB.options[i].text==LabInfo[12].substr(0,2)){
	      		LabHCVAB.options[i].selected=true;
	      		HCVABFlag=1;
	    	}	
		}
	}
	else if(HCVABFlag==0){
	LabHCVAB.options[0].selected=true;}
	
	var HIVABFlag=0;
	if(LabInfo[13].length>0){
		for (i=0;i<LabHIVAB.length;i++) {
	    	//if (LabHIVAB.options[i].text==LabInfo[13].substr(LabInfo[13].length-2)){
		    	if (LabHIVAB.options[i].text==LabInfo[13].substr(0,2)){
	      		LabHIVAB.options[i].selected=true;
	      		HIVABFlag=1;
	    	}	
		}
	}
	else if(HIVABFlag==0){
	LabHIVAB.options[0].selected=true;}	
	
	var chmdFlag=0;
	if(LabInfo[14].length>0){
		for (i=0;i<Labchmd.length;i++) {
	    	//if (Labchmd.options[i].text==LabInfo[14].substr(LabInfo[14].length-2)){
		    	if (Labchmd.options[i].text==LabInfo[14].substr(0,2)){
	      		Labchmd.options[i].selected=true;
	      		chmdFlag=1;
	      		//alert(2)
			}	
		}
	}
	else if(chmdFlag==0){
	Labchmd.options[0].selected=true;}
}
function bodySiteList_Dublclick()
{
	var obj=document.getElementById("bodySiteList");
	if (obj){
		var a=obj.selectedIndex;
		if (a>=0) obj.remove(a);
	}
}
function Doc_onblur(elementName,i)
{
	if (ifEditDoc=="Y")
	{
		var obj=document.getElementById(elementName);
		if (obj)
		{
			if(docDescList[i]!=obj.value)
			{
				docIdList[i]="";
				docDescList[i]=obj.value;
				setOpDocId(""); //liangq 20101116
			}
		}
	}
}
function Surgeon_onblur()
{
	Doc_onblur("surgeon",0)
}
function AssistDoc1_onblur()
{
	Doc_onblur("assistDoc1",1)
}
function AssistDoc2_onblur()
{
	Doc_onblur("assistDoc2",2)
}
function AssistDoc3_onblur()
{
	Doc_onblur("assistDoc3",3)
}
function AssistDoc4_onblur()
{
	Doc_onblur("assistDoc4",4)
}
function AssistDoc5_onblur()
{
	Doc_onblur("assistDoc5",5)
}
function GetOperLocation(value)
{
	obj=document.getElementById("operLocation");
	if (obj) obj.value=value.split("^")[1];
}
function SaveTransferMeans(str)  
{
	var transferMeans=str.split("^");
	var obj=document.getElementById("transferMeans")
	if(obj)
	{obj.value=transferMeans[1];
	 transferMeansCode=transferMeans[0]
	 }	
}
function GetOperRelated()
{
}

function setOpDocId(docId)
{
 	var opDocId = document.getElementById("OpDocId");
	if(opDocId)
		opDocId.value=docId;
}
function IfOutTimeCheck_Click()
{
	var obj=document.getElementById("seloptyp");
	var btSaveObj=document.getElementById("btsave");
	if(obj.checked==true)
	{
		if (btSaveObj) btSaveObj.style.visibility="visible";
	}
	else
	{
		//btSaveObj.style.visibility="hidden";
	}
}
document.body.onload = BodyLoadHandler;
