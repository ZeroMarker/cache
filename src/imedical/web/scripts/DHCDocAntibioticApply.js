document.body.onload = BodyLoadHandler;

var ComboOrderInster;
var ComboAntUseReason;
var ComboExecuteCTLOC;
var ComboDocByCTLOC;
var trAntReason=null;
var trConsultation=null;
var OrderAntibApplyRowid="";
var OrderAntibApplyInfo=""

function BodyLoadHandler()
{
	var obj=document.getElementById("Save");
	if (obj) obj.onclick=SaveClickHandler;
	var obj=document.getElementById("Exit");
	if (obj) obj.onclick=ExitClickHandler;
	var obj=document.getElementById("Consultation");
	if (obj) obj.onclick=ConsClickHandler;
	
	initList();
	initOther();
	
	GetPatDetail();
	GetEPARCIMDetail();
	
	
}
function GetPatDetail()
{
	var EpisodeID=DHCC_GetElementData("EpisodeID");
	var GetPatDetail=DHCC_GetElementData("GetPatDetail");
	if (GetPatDetail!=""){
		var PatDetail=cspRunServerMethod(GetPatDetail,EpisodeID);
		//PatientName_"^"_PatientSex_"^"_AgeDesc_"^"_Medcare_"^"_AdmDep_"^"_AdmDoc_"^"_Bed_"^"_AdmDepID_"^"_AdmDocID
		var PatDetailArr=PatDetail.split("^");
		var PatientName=PatDetailArr[0];
		var PatientSex=PatDetailArr[1];
		var AgeDesc=PatDetailArr[2];
		var Medcare=PatDetailArr[3];
		var AdmDep=PatDetailArr[4];
		var AdmDoc=PatDetailArr[5];
		var Bed=PatDetailArr[6];
		var AdmDepID=PatDetailArr[7];
		var AdmDocID=PatDetailArr[8];
		DHCC_SetElementData("PatName",PatientName);
		DHCC_SetElementData("PatSex",PatientSex);
		DHCC_SetElementData("PatAge",AgeDesc);
		DHCC_SetElementData("PatMedNo",Medcare);
		DHCC_SetElementData("ApplyDep",AdmDep);
		DHCC_SetElementData("PatBedNo",Bed);
	}
}
function GetEPARCIMDetail()
{
	var EpisodeID=DHCC_GetElementData("EpisodeID");
	var ArcimRowid=DHCC_GetElementData("ArcimRowid");
	var GetEPARCIMDetail=DHCC_GetElementData("GetEPARCIMDetail");
	
	if (GetEPARCIMDetail=="") return false;
	var EPARCIMDetail=cspRunServerMethod(GetEPARCIMDetail,EpisodeID,ArcimRowid);
	var TempArr=EPARCIMDetail.split("^");
	//ArcimDesc_"^"_DrgformRowid_"^"_FormDesc_"^"_FormInstrRowid_"^"_FormInstrDesc
	var ArcimDesc=TempArr[0];
	var DrgformRowid=TempArr[1];
	var FormDesc=TempArr[2];
	var FormInstrRowid=TempArr[3];
	var FormInstrDesc=TempArr[4];
	DHCC_SetElementData("DrugDesc",ArcimDesc);
	DHCC_SetElementData("DosageForm",FormDesc);
}
function initList()
{
	//初始化用法
  	var InsterStr="";
	var InsterStr=DHCC_GetElementData('InsterStr');
	ComboOrderInster=dhtmlXComboFromStr("OrderInster",InsterStr);
	ComboOrderInster.enableFilteringMode(true);
	ComboOrderInster.selectHandle=ComboOrderInsterselectHandle;
	
	//初始化用药原因
	var AntUseReasonStr="";
	var AntUseReasonStr=DHCC_GetElementData('AntUseReasonStr');
	ComboAntUseReason=dhtmlXComboFromStr("UseReason",AntUseReasonStr);
	ComboAntUseReason.enableFilteringMode(true);
	ComboAntUseReason.selectHandle=ComboAntUseReasonselectHandle;
	//初始科室
	var ExecuteCTLOCStr="";
	var ExecuteCTLOCStr=DHCC_GetElementData('GetExecuteCTLOCStr');
	ComboExecuteCTLOC=dhtmlXComboFromStr("ConsultationDep",ExecuteCTLOCStr);
	ComboExecuteCTLOC.enableFilteringMode(true);
	ComboExecuteCTLOC.selectHandle=ComboExecuteCTLOCselectHandle;
	
	//初始医师
	var GetDocByCTLOCStr="";
	ComboDocByCTLOC=dhtmlXComboFromStr("ConsultationDoc","");
	ComboDocByCTLOC.enableFilteringMode(true);
	ComboDocByCTLOC.selectHandle=ComboDocByCTLOCselectHandle;
	
	//初始化申请日期,停止日期
	ApplyDate = new dhtmlxCalendarObject('ApplyDate');
  	StopDate = new dhtmlxCalendarObject('StopDate');
  	var GetDefaultDate=DHCC_GetElementData("GetDefaultDate");
  	if (GetDefaultDate!=""){
  		var EpisodeID=DHCC_GetElementData("EpisodeID");
  		var DefaultDate=cspRunServerMethod(GetDefaultDate,EpisodeID);
  		DHCC_SetElementData('ApplyDate',DefaultDate.split('^')[0]);
  	}
  	
}
function initOther()
{
	var tables = document.getElementsByTagName("table");
	if (tables.length > 0){
		trAntReason = tables[4];
		trConsultation = tables[6];
		
		if (trAntReason) trAntReason.style.display = 'none';
		if (trConsultation) trConsultation.style.display = 'none';
	}
}
function CheckBeforeUpdate()
{
	var ApplyDate=DHCC_GetElementData("ApplyDate");
	if (ApplyDate==""){
		alert("申请日期不能为空.");
		return false;
	}
	var OrderInsterRowID=ComboOrderInster.getSelectedValue();
	if (OrderInsterRowID==""){
		alert("用法不能为空.");
		return false;
	}
	return true;
}
function SaveClickHandler()
{
	var BeforeUpdate=CheckBeforeUpdate();
	if (BeforeUpdate==false) return;
	
	var EpisodeID=DHCC_GetElementData("EpisodeID");
	var ArcimRowid=DHCC_GetElementData("ArcimRowid");
	var OrderPriorRowid=DHCC_GetElementData("OrderPrior");
	var DoseQty=DHCC_GetElementData("DoseQty");
	var OrderDoseUomRowid=DHCC_GetElementData("OrderDoseUom");
	var OrderFreqRowid=DHCC_GetElementData("OrderFreq");
	var OrderDurRowid=DHCC_GetElementData("OrderDur");
	var ApplyUserID=session['LOGON.USERID'];
	var ApplyDate=DHCC_GetElementData("ApplyDate");
	var ApplyTime=DHCC_GetElementData("ApplyTime");
	var StopDate=DHCC_GetElementData("StopDate");
	var StopTime=DHCC_GetElementData("StopTime");
	
	var MicrobeSpec=DHCC_GetElementData("MicrobeSpec");
	if (MicrobeSpec==true){MicrobeSpec="Y";}else{MicrobeSpec="N"}
	var DrugTest=DHCC_GetElementData("DrugTest");
	if (DrugTest==true){DrugTest="Y";}else{DrugTest="N"}
	var Consultation=DHCC_GetElementData("Consultation");
	if (Consultation==true){Consultation="Y";}else{Consultation="N"}
	var ApplyRemark=DHCC_GetElementData("ApplyRemark");
	var UserAdd=session['LOGON.USERID'];
	var ApplyTypeControl=DHCC_GetElementData("TypeControl");

	var UseReasonID=ComboAntUseReason.getSelectedValue();
	var ConsultationDepRowID=ComboExecuteCTLOC.getSelectedValue();
	var ConsultationDocRowID=ComboDocByCTLOC.getSelectedValue();
	var OrderInsterRowID=ComboOrderInster.getSelectedValue();
	var OrderInster=ComboOrderInster.getSelectedText();
	
	var Para=EpisodeID+"^"+ArcimRowid+"^"+OrderPriorRowid+"^"+DoseQty+"^"+OrderDoseUomRowid+"^"+OrderFreqRowid;
	Para=Para+"^"+OrderDurRowid+"^"+OrderInsterRowID+"^"+ApplyUserID+"^"+ApplyDate+"^"+ApplyTime+"^"+ApplyRemark;
	Para=Para+"^"+StopDate+"^"+StopTime+"^"+UseReasonID+"^"+MicrobeSpec+"^"+DrugTest+"^"+ConsultationDepRowID;
	Para=Para+"^"+ConsultationDocRowID+"^"+UserAdd+"^"+ApplyTypeControl;
	
	var Insert=DHCC_GetElementData("Insert");
	
	var ret=cspRunServerMethod(Insert,Para);
	var retArr=ret.split("^");
	OrderAntibApplyRowid=retArr[1];
	if (retArr[0]=="0"){
		OrderAntibApplyInfo=OrderAntibApplyRowid+"^"+UseReasonID+"^"+OrderInsterRowID+"^"+OrderInster;
		alert("保存成功!")
		//SaveAntibioticRowid();
	}else{
		
	}
	
}
function ConsClickHandler()
{
	var obj=document.getElementById("Consultation");
	if (obj.checked) {
		trConsultation.style.display='';
	}else{
		trConsultation.style.display='none';
	}
}

function ComboOrderInsterselectHandle()
{
	websys_nexttab(ComboExecuteCTLOC.tabIndex);
}
function ComboAntUseReasonselectHandle()
{
	var AntUseReasonDesc=ComboAntUseReason.getSelectedText();
	if (AntUseReasonDesc=="治疗"){
		trAntReason.style.display='';
	}else{
		trAntReason.style.display='none';
	}
	
}
function ComboExecuteCTLOCselectHandle()
{
	var DepRowId=ComboExecuteCTLOC.getSelectedValue();
	var DepDesc=ComboExecuteCTLOC.getSelectedText();
	if (ComboDocByCTLOC){
		ComboDocByCTLOC.clearAll();
		ComboDocByCTLOC.setComboText("");
		var encmeth=DHCC_GetElementData('GetDocByCTLOCStr');
		if ((encmeth!="")&&(DepRowId!="")){
			ComboDocByCTLOC.addOption('');
			var DocStr=cspRunServerMethod(encmeth,DepRowId);
			if (DocStr!=""){
				var Arr=DHCC_StrToArray(DocStr);
				ComboDocByCTLOC.addOption(Arr);
			}
		}
		
		DHCC_SetElementData('ConsultationDepRowID',DepRowId)
	}

	websys_nexttab(ComboExecuteCTLOC.tabIndex);
}
function ComboDocByCTLOCselectHandle()
{
	websys_nexttab(ComboExecuteCTLOC.tabIndex);
}
function ExitClickHandler()
{
	//SaveAntibioticRowid();
	window.returnValue=OrderAntibApplyInfo;
	self.close();
}

function SaveAntibioticRowid()
{
	//var par_win = window.dialogArguments;
	var par_win = window.opener;
	par_win.SetAntibioticRowid(OrderAntibApplyRowid);
	
}

