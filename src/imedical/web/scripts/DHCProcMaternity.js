var preRegNo="",tableRows=1,curAdmId,curPapmiId;
var EpisodeID=document.getElementById("EpisodeID").value; //ypz 060726
var procId="",curAdmId="",procStat="",ctcpType="";
var bloodTypeId=""
function BodyLoadHandler()
{
	 //xuqy
	 loadCardType();

    CardTypeDefine_OnChange();
    var myobj=document.getElementById('CardTypeDefine');
    if (myobj){
	myobj.onchange=CardTypeDefine_OnChange;
	myobj.size=1;
	myobj.multiple=false; 
    }
    
	var obj=document.getElementById("RCardNo");
	if (obj){
		if (obj.type!="Hiden"){
			obj.onkeydown=RCardNo_KeyDown;
		}
	}
	//xuqy end

	var EpisodeIDStr="";
	var objRegNo=document.getElementById("regNo");
	if (objRegNo) {
	    objRegNo.onkeydown=RegNoKeyDown;//objRegNo.onblur=RegNoBlur;
		if (EpisodeID!=""){   
			var getRegNoFromAdm=document.getElementById("getRegNoFromAdm").value;
			var retStr=cspRunServerMethod(getRegNoFromAdm,EpisodeID);
			//alert(1+"/"+retStr);
			if (retStr!="")	{objRegNo.value=retStr;preRegNo=retStr;}
			else {document.getElementById("EpisodeID").value="";EpisodeID="";}
		}
		var getProcInfo=document.getElementById("getProcInfo").value;
		var retStr=cspRunServerMethod(getProcInfo,objRegNo.value,EpisodeID,"Maternity");
		//alert(retStr+"//"+EpisodeID)
		var tmpList=retStr.split("^");
		procId=tmpList[0];
		//var objProcId=document.getElementById("procId");
		//if (objProcId) objProcId.value=procId;
		if (tmpList[1]) EpisodeIDStr=tmpList[1];
		if (tmpList[2]) procStat=tmpList[2];
		var objProcLnmp=document.getElementById("procLnmp");
		if ((objProcLnmp)&&(tmpList[3])) objProcLnmp.value=tmpList[3];
		var objPrePregWeight=document.getElementById("prePregWeight");
		if ((objPrePregWeight)&&(tmpList[4])) objPrePregWeight.value=tmpList[4];
		var objHighRisk=document.getElementById("highRisk");
		if ((objHighRisk)&&(tmpList[5])) objHighRisk.checked=(tmpList[5]=="Y");
		var objHBVDNA=document.getElementById("HBVDNA");
		if ((objHBVDNA)&&(tmpList[6])) objHBVDNA.value=tmpList[6];
		var objHCG=document.getElementById("HCG");
		if ((objHCG)&&(tmpList[7])) objHCG.value=tmpList[7];
		var objBloodType=document.getElementById("bloodType");
		if ((objBloodType)&&(tmpList[8])) 
		{
			bloodTypeId=tmpList[8];
			if(bloodTypeId!="")
			{
				var getBloodObj=document.getElementById("getBloodType")
				if(getBloodObj)
				{
					objBloodType.value=cspRunServerMethod(getBloodObj.value,bloodTypeId);
				}
			}
		}
		var objResearch=document.getElementById("isResearch");
		if ((objResearch)&&(tmpList[9])) objResearch.checked=(tmpList[9]=="Y");
	}
	var objQuery=document.getElementById("find");
	if (objQuery) {objQuery.onclick=QueryClick;}
	var today=document.getElementById("getToday").value;  //ypz 061123
	var stdate=document.getElementById("startDate");
	if (stdate) {
		if (stdate.value=="") {stdate.value=today;} //ypz 061123
	    stdate.onblur=Adjust_EDate;stdate.onchange=Adjust_EDate;
	}
    var edate=document.getElementById("endDate");
	if (edate) {
		if (edate.value=="") {edate.value=today;} //ypz 061123
		edate.onblur=Adjust_SDate;edate.onchange=Adjust_SDate;
	}
	var objBtnInsertProc=document.getElementById("btnInsertProc");
	var objBtnCloseProc=document.getElementById("btnCloseProc");
	var objBtnAddProcAdm=document.getElementById("btnAddProcAdm");
	var objBtnDeleteProcAdm=document.getElementById("btnDeleteProcAdm");
	var objBtnSaveRecord=document.getElementById("btnSaveProcPreg");
	var objBtnDeleteRecord=document.getElementById("btnDeleteProcPreg");
	var objBtnPrint=document.getElementById("btnPrint");
	if (objBtnInsertProc) {
		if (procId>0) {
			if (procStat=="O"){
				objBtnInsertProc.disabled=false; objBtnInsertProc.onclick=InsertProcessClick;
				objBtnCloseProc.disabled=false; objBtnCloseProc.onclick=CloseProcClick;
				objBtnSaveRecord.disabled=false; objBtnSaveRecord.onclick=SaveProcPregClick;
				objBtnPrint.disabled=false; objBtnPrint.onclick=PrintClick;
				if (EpisodeIDStr.indexOf("!"+EpisodeID+"!")<0){
					if (objBtnAddProcAdm){objBtnAddProcAdm.disabled=false; objBtnAddProcAdm.onclick=InsertProcAdmClick;	}
					if (objBtnDeleteProcAdm){objBtnDeleteProcAdm.disabled=true;	objBtnDeleteProcAdm.onclick=function(){return false;}}
					//objBtnSaveRecord.disabled=true;	objBtnSaveRecord.onclick=function(){return false;}
					objBtnDeleteRecord.disabled=true; objBtnDeleteRecord.onclick=function(){return false;}
				}
				else{
					if (objBtnAddProcAdm){objBtnAddProcAdm.disabled=true; objBtnAddProcAdm.onclick=function(){return false;}}
					if (objBtnDeleteProcAdm) {objBtnDeleteProcAdm.disabled=false; objBtnDeleteProcAdm.onclick=DeleteProcAdmClick;}
					objBtnDeleteRecord.disabled=false; objBtnDeleteRecord.onclick=DeleteProcPregClick;
				}
			}
			else{
				objBtnInsertProc.disabled=true; objBtnInsertProc.onclick=function(){return false;}
				objBtnCloseProc.disabled=true;	objBtnCloseProc.onclick=function(){return false;}
				objBtnSaveRecord.disabled=true;	objBtnSaveRecord.onclick=function(){return false;}
				objBtnDeleteRecord.disabled=true; objBtnDeleteRecord.onclick=function(){return false;}
				objBtnPrint.disabled=true; objBtnPrint.onclick=function(){return false;}
			}
		}
		else {
			objBtnInsertProc.disabled=false; objBtnInsertProc.onclick=InsertProcessClick;
			objBtnCloseProc.disabled=true;	objBtnCloseProc.onclick=function(){return false;}
			//objBtnAddProcAdm.disabled=true;	objBtnAddProcAdm.onclick=function(){return false;}
			//objBtnDeleteProcAdm.disabled=true;	objBtnDeleteProcAdm.onclick=function(){return false;}
			objBtnSaveRecord.disabled=true;	objBtnSaveRecord.onclick=function(){return false;}
			objBtnDeleteRecord.disabled=true; objBtnDeleteRecord.onclick=function(){return false;}
			objBtnPrint.disabled=true; objBtnPrint.onclick=function(){return false;}
		}
	}
	getCtcpType=document.getElementById("getCtcpType").value;
	ctcpType=cspRunServerMethod(getCtcpType,"",session['LOGON.USERID'],"");
	if (ctcpType=="NURSE")
	{
		/*DisableById(0,"weight");
		DisableById(0,"bpDiastolic");
		DisableById(0,"bpSystolic");
		*/
		
		DisableById(0,"chiefComplaint");
		DisableById(0,"urineProtein");
		DisableById(0,"hemoglobin");
		DisableById(0,"edema");
		DisableById(0,"uterineHeight");
		DisableById(0,"abdomenCircum");
		DisableById(0,"babyPosition");
		DisableById(0,"fetalHeart");
		DisableById(0,"quickening");
		DisableById(0,"presentation");
		DisableById(0,"amnioticFluidVol");
		DisableById(0,"urineEstriol");
		DisableById(0,"biparictalDis");
		DisableById(0,"amnioticFluidThick");
		DisableById(0,"disposal");
		DisableById(0,"treat");
	}
	var objtbl=document.getElementById('tDHCProcMaternity');
    if (objtbl.rows.length>0) GetTableVal(objtbl.rows.length-1);
    //add by WKZ
    var WeekObj=document.getElementById('gestatWeek')
    if(WeekObj)
    {
	    var procLnmpObj=document.getElementById('procLnmp').value
	    var GetWeekobj=document.getElementById('GetWeek');
	    if(GetWeekobj)
	    {
		    if(procLnmpObj!="")
		    {
			    var Ret=cspRunServerMethod(GetWeekobj.value,procLnmpObj);
			    WeekObj.value=Ret
		    }
	    }
    }
	//if (EpisodeID!="") {Find_click();/*Search(true);*/}
	
}
function QueryClick()
{
	//RegNoBlur(true);
	//Search(true);
	Find_click();
}

function Search(searchFlag)
{
    var regNo=document.getElementById("regNo").value;
    if (regNo!="") BasPatinfo(regNo);
	if (EpisodeID!="") regNo=regNo+"^"+EpisodeID //ypz 060728
    //var reportType=document.getElementById("ReportList").value;
    var stdate=document.getElementById("startDate").value;
    var edate=document.getElementById("endDate").value;
	//self.location.reload();
}
function ExecuteClick()
{
}
function getloc(str)
{
		var loc=str.split("^");
		var obj=document.getElementById("locId");
		obj.value=loc[1];
}

function getwardid(str)
{
	var obj=document.getElementById('wardId');
	var tem=str.split("^");
	obj.value=tem[1];
	var obj=document.getElementById('PacWard');
	obj.value=tem[0];
	return;
}
function savetyp(str)
{
	var obj=document.getElementById('queryTypeCode');
	var tem=str.split("^");
	obj.value=tem[1];
	changeDisplay();
	Search(false);
}
function RegNoKeyDown()
{    
	if ((event.keyCode==13)||(event.keyCode==9)) { RegNoBlur(false) };
}
function RegNoBlur(queryFlag)
{   
	var i;
    var objRegNo=document.getElementById("regNo");
    //websys_setfocus("Dept");  //startDate
    if ((objRegNo.value==preRegNo)&&(queryFlag==false)) return;  //ypz 061112
    var obj=document.getElementById("patMainInfo");
    obj.value=""
	var isEmpty=(objRegNo.value=="");
    var oldLen=objRegNo.value.length;
    
	if (!isEmpty) {  //add 0 before regno
	    for (i=0;i<10-oldLen;i++)
	    {
	    	objRegNo.value="0"+objRegNo.value  
	    }
	}
	
    preRegNo=objRegNo.value;
   
   	//BasPatinfo(objRegNo.value);
    //document.getElementById("EpisodeID").value="";EpisodeID="";
   	Search(true);
	//GetListOrd()
}

function BasPatinfo(regNo)
{//    s str=regno_"^"_$P(ctloc,"-",2)_"^"_$G(room)_"^"_$G(sex)_"^"_$G(patName)_"^"_$G(Bah)_"^"_$G(bedCode)_"^"_$G(age)_"^"_$G(WardDes)_"^"_homeaddres_"^"_hometel_"  "_worktel_"  "_handtel
   
	if (regNo=="") return;
 	var patinfo=document.getElementById("patinfo").value;
 	var str=cspRunServerMethod(patinfo,regNo);
   	if (str=="") return;
    var tem=str.split("^");

	var obj=document.getElementById("patInfo");
	obj.value=tem[4]+","+tem[3]+","+tem[7]+","+tem[13];
	//obj=document.getElementById("PatLoc"); //ypz rem
	//obj.value=tem[1];
}
function GetDate(dateStr)
{
	var tmpList=dateStr.split("/");
	if (tmpList<3) return 0;
	return tmpList[2]*1000+tmpList[1]*50+tmpList[0];
}
function Adjust_EDate()
{
	var stdate=document.getElementById("startDate");
    var edate=document.getElementById("endDate");
	//alert(stdate.value+" "+edate.value)
	if (GetDate(stdate.value)>GetDate(edate.value)) edate.value=stdate.value ;
}
function Adjust_SDate()
{
	var stdate=document.getElementById("startDate");
    var edate=document.getElementById("endDate");
	if (GetDate(stdate.value)>GetDate(edate.value)) stdate.value=edate.value ;
}
function ClearScreen()
{
	document.getElementById("regNo").value="";
	document.getElementById("CardNo").value="";
	document.getElementById("patMainInfo").value="";
	document.getElementById("RCardNo").value="";
	preRegNo="";
	Search(false);
	//websys_setfocus("regNo");
	websys_setfocus("RCardNo");

}
function InsertProcessClick()
{
    var regNo=document.getElementById("regNo").value;
    if (regNo!="") {
 		var insertProcess=document.getElementById("insertProcess").value;
	    var userId=session['LOGON.USERID'];
	    var procLnmp="";
	    var objProcLnmp=document.getElementById("ProcLnmp");
	    if (objProcLnmp) procLnmp=objProcLnmp.value;
	    if (procLnmp==""){alert(t['alert:inputLnmp']);return;}
	    var prePregWeight=""
	    var objPrePregWeight=document.getElementById("prePregWeight");
	    if (objPrePregWeight) prePregWeight=objPrePregWeight.value;
	    var highRisk=""
	    var objHighRisk=document.getElementById("highRisk");
	    if (objHighRisk) {
		    if (objHighRisk.checked) highRisk="Y";
		    else highRisk="N";
	    }
	    var HBVDNA=""
	    var objHBVDNA=document.getElementById("HBVDNA");
	    if (objHBVDNA) HBVDNA=objHBVDNA.value;
	    var HCG=""
	    var objHCG=document.getElementById("HCG");
	    if (objHCG) HCG=objHCG.value;
	    var bloodType=""
	    var objBloodType=document.getElementById("bloodType");
	    if (objBloodType) bloodType=objBloodType.value;
	    bloodType=bloodTypeId; 
	    var isResearchk=""
	    var objResearchk=document.getElementById("isResearch");
	    if (objResearchk) {
		    if (objResearchk.checked) isResearchk="Y";
		    else isResearchk="N";
	    }
	    //alert(highRisk);
 		//var retStr=cspRunServerMethod(insertProcess,regNo,"Maternity",userId,procLnmp);
 		var retStr=cspRunServerMethod(insertProcess,EpisodeID,"Maternity",userId,procLnmp,prePregWeight,highRisk,HBVDNA,HCG,bloodType,isResearchk);
 		if (retStr>0) {alert(t['alert:success']);procId=retStr;}
 		else alert(retStr);
    }
    else{alert(t['alert:regNoNull']);}
}
function CloseProcClick()
{
    if (procId!="") {
 		var setProcessStatus=document.getElementById("setProcessStatus").value;
 		var retStr=cspRunServerMethod(setProcessStatus,procId,"C");
 	    alert(retStr);
		self.location.reload();
    }
    else{alert(t['alert:procIdNull']);}
}
function InsertProcAdmClick()
{
    if (procId=="") {alert(t['alert:procIdNull']);return;}
    if (EpisodeID=="") {alert(t['alert:EpisodeNull']);return;}
 	var addProcAdm=document.getElementById("addProcAdm").value;
	var userId=session['LOGON.USERID'];
 	var retStr=cspRunServerMethod(addProcAdm,procId,EpisodeID,userId);
 	alert(retStr);
	self.location.reload();
}
function DeleteProcAdmClick()
{
    if (procId=="") {alert(t['alert:procIdNull']);return;}
    if (EpisodeID=="") {alert(t['alert:EpisodeNull']);return;}
 	var deleteProcAdm=document.getElementById("deleteProcAdm").value;
 	var retStr=cspRunServerMethod(deleteProcAdm,procId,EpisodeID);
 	alert(retStr);
	self.location.reload();
}
function SaveProcPregClick()
{
    if (procId=="") {alert(t['alert:procIdNull']);return;}
    if (EpisodeID=="") {alert(t['']);return;}
	//alert(EpisodeID)
	//procprId
	//admId
	var bookingDate=document.getElementById("bookingDate").value;
	var date=document.getElementById("date").value;
	var time=document.getElementById("time").value;
	if (! CheckNumber("gestatWeek")) return;
	if (! CheckNumber("weight")) return;
	if (! CheckNumber("bpDiastolic")) return;
	if (! CheckNumber("bpSystolic")) return;
	if (! CheckNumber("hemoglobin")) return;
	if (! CheckNumber("uterineHeight")) return;
	if (! CheckNumber("abdomenCircum")) return;
	if (! CheckNumber("biparictalDis")) return;
	if (! CheckNumber("amnioticFluidThick")) return;
	var gestatWeek=document.getElementById("gestatWeek").value;
	var chiefComplaint=document.getElementById("chiefComplaint").value;
	var weight=document.getElementById("weight").value;
	var bpDiastolic=document.getElementById("bpDiastolic").value;
	var bpSystolic=document.getElementById("bpSystolic").value;
	var urineProtein=document.getElementById("urineProtein").value;
	var hemoglobin=document.getElementById("hemoglobin").value;
	var edema=document.getElementById("edema").value;
	var uterineHeight=document.getElementById("uterineHeight").value;
	var abdomenCircum=document.getElementById("abdomenCircum").value;
	var babyPosition=document.getElementById("babyPosition").value;
	var fetalHeart=document.getElementById("fetalHeart").value;
	var quickening=document.getElementById("quickening").value;
	var presentation=document.getElementById("presentation").value;
	var amnioticFluidVol=document.getElementById("amnioticFluidVol").value;
	var objUrineEstriol=document.getElementById("urineEstriol");
	var urineEstriol="";
	if (objUrineEstriol) urineEstriol=objUrineEstriol.value;
	var biparictalDis=document.getElementById("biparictalDis").value;
	var amnioticFluidThick=document.getElementById("amnioticFluidThick").value;
	var disposal=document.getElementById("disposal").value;
	var ctcpDesc=""; //document.getElementById("ctcpDesc").value;
	var treat=document.getElementById("treat").value;
	var note="" //document.getElementById("note").value;
	var updateDate="";//document.getElementById("updateDate").value;
	var updateTime="";//document.getElementById("updateTime").value;
	var userId=session['LOGON.USERID'];
	var procprStr=bookingDate+"^"+date+"^"+time+"^"+gestatWeek+"^"+chiefComplaint+"^"+weight+"^"+
	              bpDiastolic+"^"+bpSystolic+"^"+urineProtein+"^"+hemoglobin+"^"+edema+"^"+
	              uterineHeight+"^"+abdomenCircum+"^"+babyPosition+"^"+fetalHeart+"^"+
	              quickening+"^"+presentation+"^"+amnioticFluidVol+"^"+urineEstriol+"^"+
	              biparictalDis+"^"+amnioticFluidThick+"^"+disposal+"^"+
	              ctcpDesc+"^"+treat+"^"+note+"^^^"+userId
	var saveProcPreg=document.getElementById("saveProcPreg").value;
	var userId=session['LOGON.USERID'];
	//alert(procId);
 	var retStr=cspRunServerMethod(saveProcPreg,procId,EpisodeID,userId,procprStr);
 	alert(retStr);
	self.location.reload();
}
function DeleteProcPregClick()
{
    if (procId=="") {alert(t['alert:procIdNull']);return;}
    if (EpisodeID=="") {alert(t['alert:EpisodeNull']);return;}
 	var deleteProcPreg=document.getElementById("deleteProcPreg").value;
 	var retStr=cspRunServerMethod(deleteProcPreg,procId,EpisodeID);
 	alert(retStr);
	self.location.reload();
}
function GetElement(elementIdz,elementId)
{
	var retVal=""
	var obj=document.getElementById(elementIdz)
	if (obj) retVal=obj.innerText;
	if (retVal==" ") retVal="";
	obj=document.getElementById(elementId);
	if (obj) obj.value=retVal;
	return retVal
}

function GetTableVal(row)
{
	if (row<1) return;
    GetElement("procprBookingDatez"+row,"bookingDate");
    GetElement("procprDatez"+row,"date");
    GetElement("procprTimez"+row,"time");
    GetElement("procprGestatWeekz"+row,"gestatWeek")
    GetElement("procprChiefComplaintz"+row,"chiefComplaint")
    GetElement("procprWeightz"+row,"weight");
    GetElement("procprBPDiastolicz"+row,"bpDiastolic");
    GetElement("procprBPSystolicz"+row,"bpSystolic");
    GetElement("procprUrineProteinz"+row,"urineProtein");
    GetElement("procprHemoglobinz"+row,"hemoglobin");
    GetElement("procprEdemaz"+row,"edema");
    GetElement("procprUterineHeightz"+row,"uterineHeight");
    GetElement("procprAbdomenCircumz"+row,"abdomenCircum");
    GetElement("procprBabyPositionz"+row,"babyPosition");
    GetElement("procprFetalHeartz"+row,"fetalHeart");
    GetElement("procprQuickeningz"+row,"quickening");
    GetElement("procprPresentationz"+row,"presentation");
    GetElement("procprAmnioticFluidVolz"+row,"amnioticFluidVol");
    GetElement("procprUrineEstriolz"+row,"urineEstriol");
    GetElement("procprBiparictalDisz"+row,"biparictalDis");
    GetElement("procprAmnioticFluidThickz"+row,"amnioticFluidThick");
    GetElement("procprDisposalz"+row,"disposal");
    GetElement("procprCtcpDescz"+row,"ctcpDesc");
    GetElement("procprTreatz"+row,"treat");
    

	}
function SelectRowHandler()
{
    var objtbl=document.getElementById('tDHCProcMaternity');
    selrow=DHCWeb_GetRowIdx(window);
    //var adm=document.getElementById("admIdz"+selrow).innerText;

    //var objEpisodeID=document.getElementById("EpisodeID");
    //objEpisodeID.value=adm;
	//procprNote
	//procprUpdateDate
	//procprUpdateTime
	//procprUpdateUserName
 	var objBtnSaveRecord=document.getElementById("btnSaveProcPreg");
	var objBtnDeleteRecord=document.getElementById("btnDeleteProcPreg");
	curAdmId=GetElement("admIdz"+selrow,"admId");//document.getElementById("admIdz"+selrow).innerText;
	GetTableVal(selrow);
	
	if (procStat=="O"){
		if (curAdmId!=EpisodeID){
			if (ctcpType=="NURSE") {objBtnSaveRecord.disabled=true;	objBtnSaveRecord.onclick=function(){return false;}}
			objBtnDeleteRecord.disabled=true; objBtnDeleteRecord.onclick=function(){return false;}
		}
		else {
			if (ctcpType=="NURSE") {objBtnSaveRecord.disabled=false; objBtnSaveRecord.onclick=SaveProcPregClick;}
			objBtnDeleteRecord.disabled=false; objBtnDeleteRecord.onclick=DeleteProcPregClick;
		}
	}
	else{
		objBtnSaveRecord.disabled=true;	objBtnSaveRecord.onclick=function(){return false;}
		objBtnDeleteRecord.disabled=true; objBtnDeleteRecord.onclick=function(){return false;}
	}
    var win=top.frames['eprmenu'];
    if (win)
    {
   		var frm = win.document.forms['fEPRMENU'];
    	if (frm) {
	        var objEpisodeID=frm.EpisodeID;
			if (objEpisodeID) objEpisodeID.value=EpisodeID;
    	}
    }
 }
function DHCWeb_GetRowIdx(wobj)
{
	try{
		var eSrc=wobj.event.srcElement;
		//alert(wobj.name);
		if (eSrc.tagName=="IMG") eSrc=wobj.event.srcElement.parentElement;
		var rowObj=getRow(eSrc);
		var selectrow=rowObj.rowIndex;
		return 	selectrow
	}catch (e)
	{
		alert(e.toString());
		return -1;
	}
}
function IsNumberic(str){
    strRef = "-1234567890.";
    for (i=0;i<str.length;i++) {
        tempChar= str.substring(i,i+1);
        if (strRef.indexOf(tempChar,0)==-1) {return false;}
        if ((i>0)&&(strRef.indexOf(tempChar,0)==0)) {return false;}
    }
    return true;
}
function CheckNumber(elementName)
{
	var obj=document.getElementById(elementName);
	if (! obj) return true;
	if (IsNumberic(obj.value)) return true;
	alert(t['alert:inputNumber']);
	websys_setfocus(elementName);
	return false;	
}
function SavePresentation(str)
{
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

//xuqy begin
function loadCardType(){
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth=DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardTypeDefine");
	}
}
var m_CardNoLength=0;
var m_SelectCardTypeDR="";
var m_CCMRowID=""
function CardTypeDefine_OnChange()
{   
	var myoptval=DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary=myoptval.split("^");
	
	var myCardTypeDR=myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	m_CCMRowID=myary[14];
	if (myCardTypeDR=="")
	{
		return;
	}
	///Read Card Mode
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = false;
		}
		//DHCWeb_DisBtnA("ReadCard");
	}
	else
	{
		var myobj=document.getElementById("CardNo");
		if (myobj)
		{
			myobj.readOnly = true;
		}
		//var obj=document.getElementById("ReadCard");
		//if (obj){
		//	obj.disabled=false;
		//	obj.onclick=ReadCard_Click;
		//}
	}
	
	//Set Focus
	if (myary[16]=="Handle"){
		DHCWeb_setfocus("CardNo");
	}else{
		//DHCWeb_setfocus("ReadCard");
	}
	
	m_CardNoLength=myary[17];
	
}
function SetCardNOLength(){
	var obj=document.getElementById('RCardNo');
		if (obj.value!='') {
			if ((obj.value.length<m_CardNoLength)&&(m_CardNoLength!=0)) {
				for (var i=(m_CardNoLength-obj.value.length-1); i>=0; i--) {
					obj.value="0"+obj.value
				}
			}
			var myCardobj=document.getElementById('CardNo');
			if (myCardobj){
				myCardobj.value=obj.value;
			}
		}
}
function RCardNo_KeyDown(){
	var key = websys_getKey(e);
	if ((key==13)){
		///Set Card No Length;
		SetCardNOLength();
		var myCardNo=DHCWebD_GetObjValue("CardNo");
		var mySecurityNo="";
		
		///var myrtn=DHCACC_GetAccInfo();
		var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardNo, mySecurityNo,"PatInfo")
		var myary=myrtn.split("^");
		var rtn=myary[0];
		switch (rtn){
			case "0":
				///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
				var obj=document.getElementById("regNo");
				obj.value=myary[5];
				var obj=document.getElementById("CardNo");
				DHCWebD_SetObjValueB("CardNo",myary[1]);
				//DHCWebD_SetObjValueB("AccRowID",myary[7]);
				break;
			case "-200":            //¿¨ÎÞÐ§
				alert(t['alert:cardinvalid'])
				break;
			case "-201":
				var obj=document.getElementById("regNo");
				obj.value = myary[5];
				break;
			default:
				///alert("");
		}
		
		return;
	}
}
function GetBlood(str)
{
	var ret=str.split("^");
	bloodTypeId=ret[0];
	var objBldTyp=document.getElementById("bloodType")
	objBldTyp.value=ret[1];
}
function PrintClick()
{
	    var xlsExcel,xlsSheet,xlsBook;
      var  path = GetFilePath();
      var fileName="DHCPaProc.xls" ;
      fileName=path+ fileName;
	    xlsExcel = new ActiveXObject("Excel.Application");
	    xlsBook = xlsExcel.Workbooks.Add(fileName)
	    xlsSheet = xlsBook.ActiveSheet ;
	    var EpisodeID=document.getElementById("EpisodeID").value;
      var BaseInfor=document.getElementById("GetBaseInfor").value;
 	    var RetStr=cspRunServerMethod(BaseInfor,EpisodeID);
   	  if (RetStr=="") return;
      var tem=RetStr.split("^");
      xlsSheet.cells(1,2)=tem[5];
      if(tem[7]=="Y")
      {
      	xlsSheet.cells(1,4)="ÊÇ";
      }
    else
    	{
    		xlsSheet.cells(1,4)="·ñ";
    	}
      xlsSheet.cells(1,6)=tem[6];
      xlsSheet.cells(1,9)=tem[4];
      xlsSheet.cells(2,2)=tem[0]; 
      xlsSheet.cells(2,6)=tem[1];
      if(tem[2]=="I")
      {
      	xlsSheet.cells(2,12)=tem[3];
      }
    else
    	{
    		xlsSheet.cells(1,12)=tem[3];
    	}
			var objtbl=document.getElementById('tDHCProcMaternity');
			for (var i=1;i<objtbl.rows.length;i++)
			{
				xlsSheet.cells(3+i,1)=document.getElementById("procprDatez"+i).innerText;
				xlsSheet.cells(3+i,2)=document.getElementById("procprGestatWeekz"+i).innerText;
				xlsSheet.cells(3+i,3)=document.getElementById("procprWeightz"+i).innerText;
				xlsSheet.cells(3+i,4)=document.getElementById("procprBPSystolicz"+i).innerText+"/"+document.getElementById("procprBPDiastolicz"+i).innerText;
				xlsSheet.cells(3+i,5)=document.getElementById("procprHemoglobinz"+i).innerText;
				xlsSheet.cells(3+i,6)=document.getElementById("procprEdemaz"+i).innerText;
				xlsSheet.cells(3+i,7)=document.getElementById("procprAbdomenCircumz"+i).innerText;
				xlsSheet.cells(3+i,8)=document.getElementById("procprUterineHeightz"+i).innerText;
				xlsSheet.cells(3+i,9)=document.getElementById("procprBabyPositionz"+i).innerText;
				xlsSheet.cells(3+i,10)=document.getElementById("procprFetalHeartz"+i).innerText;
				xlsSheet.cells(3+i,11)=document.getElementById("procprPresentationz"+i).innerText;
				xlsSheet.cells(3+i,12)=document.getElementById("procprAmnioticFluidVolz"+i).innerText;
				xlsSheet.cells(3+i,13)=document.getElementById("procprCtcpDescz"+i).innerText;
			}
			var ii=1
			for (var i=1;i<objtbl.rows.length;i++)
			{
				if(i==1) var j =3
			else var j=1
				var tempStr=i+"."+document.getElementById("procprDisposalz"+i).innerText;
				if(tempStr.length<33)
				{
					xlsSheet.cells(18+ii,j)=tempStr;
				}
				else 
				{
					xlsSheet.cells(18+ii,j)=tempStr.substring(0,35)
					ii=ii+1
					if(ii>1)  var j=1
					xlsSheet.cells(18+ii,j)=tempStr.substring(35,tempStr.length)
				}
				ii=ii+1
			}
		  //xlsExcel.Visible = true;
      //xlsSheet.PrintPreview() ;
      xlsSheet.PrintOut;

      xlsSheet = null;
      xlsBook.Close(savechanges=false);
      xlsBook = null;
      xlsExcel.Quit();
      xlsExcel = null;
      window.setInterval("Cleanup();",1); 
}
var idTmr=""
function Cleanup() 
{   
    window.clearInterval(idTmr);   
    CollectGarbage();   
}
function GetFilePath()
  {   var GetPath=document.getElementById("GetPath").value;
      var path=cspRunServerMethod(GetPath);
      return path;
  }
document.body.onload = BodyLoadHandler;