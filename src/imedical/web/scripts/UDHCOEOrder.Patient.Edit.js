var CommonCardNo="000000088888888"


document.body.onload = BodyLoadHandler;
document.body.onunload = DocumentUnloadHandler;
function DocumentUnloadHandler(e){
}
function BodyLoadHandler() {

	//读卡
	var obj=document.getElementById('ReadCard');
	if (obj) obj.onclick=ReadCardClickHandler;

	var obj=document.getElementById('CardNo');
	if (obj) obj.onkeydown = CardNoKeydownHandler;

	var obj=document.getElementById('Sex');
	if (obj) obj.onkeydown = DHCC_Nextfoucs;
	var obj=document.getElementById('Age');
	if (obj) obj.onkeydown = DHCC_Nextfoucs;
	var obj=document.getElementById('Name');
	if (obj) obj.onkeydown = DHCC_Nextfoucs;
	
	var obj=document.getElementById('RapidUpdate');
	if (obj) obj.onclick=RapidUpdateClickHandler;

	var obj=document.getElementById('NewRapidRegist');
	if (obj) obj.onclick=NewRapidRegistClickHandler;

	var obj=document.getElementById('UpdatePat');
	if (obj) obj.onclick=UpdatePatClickHandler;

	var obj=document.getElementById('Clear');
	if (obj) obj.onclick=Clear_click;

	ReadCardType();

	//DHCC_SetListStyle("CardType",false);
	//卡类型
	combo_CardType=dhtmlXComboFromSelect("CardType");
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle=combo_CardTypeKeydownHandler;
	}
	
	var SexStr=DHCC_GetElementData('SexStr');
	combo_Sex=dhtmlXComboFromStr("Sex",SexStr);
	combo_Sex.enableFilteringMode(true);
	
	DHCC_SetElementData('CardNo',CommonCardNo)	
	websys_setfocus('CardNo');
}


function ReadCardType(){
	DHCC_ClearList("CardType");
	var encmeth=DHCC_GetElementData("CardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardType");
	}
}
function combo_CardTypeKeydownHandler(){
	if (combo_CardType) websys_nexttab(combo_CardType.tabIndex);
}

function UpdatePatClickHandler(){
	var PatientID=DHCC_GetElementData('PatientID');
	if (PatientID=="") {
		alert(t['NotSelectPatient']);	
		websys_setfocus('CardNo');
		return;
	}

	var Name=DHCC_GetElementData('Name');
	if (Name=="") {
		alert(t['NameIsNull']);	
		websys_setfocus('Name');
		return;
	}	
	var Age=DHCC_GetElementData('Age');
	if (Age=="") {
		alert(t['AgeIsNull']);	
		websys_setfocus('Age');
		return;
	}	
	var SexRowId=combo_Sex.getSelectedValue();
	if (SexRowId==''){
		alert(t['SexIsNull']);
		combo_Sex.DOMelem_input.focus();
		return;
	}
	var encmeth=DHCC_GetElementData('UpdatePatMethod');
	var PatInfo=PatientID+"^"+Name+"^"+SexRowId+"^"+Age;
	var ret=cspRunServerMethod(encmeth,PatInfo);
	if (ret!=0){
		alert(t['SavePatInfoFail']);
	}	
}

function NewRapidRegistClickHandler(){
	var PatientID=DHCC_GetElementData('PatientID');
	if (PatientID!=''){
		alert(t['PatientExist']);
		websys_setfocus('CardNo');
		return;
	}
	
	var RapidASRowId=DHCC_GetElementData('RapidASRowId');
	if (RapidASRowId==""){
		alert(t['NoRapidAS']);
		websys_setfocus('CardNo');
		return
	}
	
	var Name=DHCC_GetElementData('Name');
	if (Name=="") {
		alert(t['NameIsNull']);	
		websys_setfocus('Name');
		return;
	}	
	var Age=DHCC_GetElementData('Age');
	if (Age=="") {
		alert(t['AgeIsNull']);	
		websys_setfocus('Age');
		return;
	}	
	var SexRowId=combo_Sex.getSelectedValue();
	if (SexRowId==''){
		alert(t['SexIsNull']);
		combo_Sex.DOMelem_input.focus();
		return;
	}
	
	var PatInfo=Name+"^"+SexRowId+"^"+Age;
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];
	var AdmReason="";
	
	var encmeth=DHCC_GetElementData('NewRapidRegistMethod');
	var ret=cspRunServerMethod(encmeth,PatInfo,RapidASRowId,AdmReason,UserID,GroupID);
	var retarr=ret.split("^");
	if (retarr[0]=="0"){
		var PatientID=retarr[1];
		var EpisodeID=retarr[2];
		var mradm=retarr[3];
		var CardNo=retarr[4];
		
		DHCC_SetElementData('PatientID',PatientID);
		DHCC_SetElementData('EpisodeID',EpisodeID);
		DHCC_SetElementData('mradm',mradm);
		DHCC_SetElementData('CardNo',CardNo);
		ChangPaadm();
	}else{
		var errmsg="";
		if (retarr[0]=="-201")  errmsg=t['ADMInsertFail'];
		if (retarr[0]=="-206")  errmsg=t['PriceArcOrderInsertFail'];
		if (retarr[0]=="-207")  errmsg=t['chrhfeeOrderInsertFail'];
		if (retarr[0]=="-208")  errmsg=t['holiOrderInsertFail'];
		if (retarr[0]=="-209")  errmsg=t['AppOrderInsertFail'];
		if (retarr[0]=="-211")  errmsg=t['RegFeeInsertFail'];
		if (retarr[0]=="-212")  errmsg=t['QueueInsertFail'];
		if (retarr[0]=="-301")  errmsg=t['ExceedDayRegCountLimit'];
		if (retarr[0]=="-302")  errmsg=t['ExceedDayDocRegCountLimit'];
		if (retarr[0]=="-404")  errmsg=t['AdmIsExist'];
		if (retarr[0]=="-405")  errmsg=t['NotAvalidCardNo'];
		if (retarr[0]=="-405")  errmsg=t['SavePatInfoFail'];
		
		//alert(t['RegFail']+","+errmsg+","+"ErrCode:"+retarr[0]);
		alert(t['RegFail']+","+errmsg);
		websys_setfocus('CardNo');
		return;
	}
}

function RapidUpdateClickHandler(){
	var RapidASRowId=DHCC_GetElementData('RapidASRowId');
	if (RapidASRowId==""){
		alert(t['NoRapidAS']);
		websys_setfocus('CardNo');
		return
	}
	var PatientID=DHCC_GetElementData('PatientID');
	if (PatientID=="") {
		alert(t['NotSelectPatient']);	
		websys_setfocus('CardNo');
		return;
	}
	
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];
	var AdmReason="";
	
	var encmeth=DHCC_GetElementData('RapidRegistMethod');
	var ret=cspRunServerMethod(encmeth,PatientID,RapidASRowId,AdmReason,UserID,GroupID);
	var retarr=ret.split("^");
	if (retarr[0]=="0"){
		var EpisodeID=retarr[1];
		var mradm=retarr[2];
		DHCC_SetElementData('EpisodeID',EpisodeID);
		DHCC_SetElementData('mradm',mradm);
		ChangPaadm();
	}else{
		var errmsg="";
		if (retarr[0]=="-201")  errmsg=t['ADMInsertFail'];
		if (retarr[0]=="-206")  errmsg=t['PriceArcOrderInsertFail'];
		if (retarr[0]=="-207")  errmsg=t['chrhfeeOrderInsertFail'];
		if (retarr[0]=="-208")  errmsg=t['holiOrderInsertFail'];
		if (retarr[0]=="-209")  errmsg=t['AppOrderInsertFail'];
		if (retarr[0]=="-211")  errmsg=t['RegFeeInsertFail'];
		if (retarr[0]=="-212")  errmsg=t['QueueInsertFail'];
		if (retarr[0]=="-301")  errmsg=t['ExceedDayRegCountLimit'];
		if (retarr[0]=="-302")  errmsg=t['ExceedDayDocRegCountLimit'];
		if (retarr[0]=="-404")  errmsg=t['AdmIsExist'];
		if (retarr[0]=="-405")  errmsg=t['NotAvalidCardNo'];
		if (retarr[0]=="-405")  errmsg=t['SavePatInfoFail'];
		
		//alert(t['RegFail']+","+errmsg+","+"ErrCode:"+retarr[0]);
		alert(t['RegFail']+","+errmsg);
		websys_setfocus('CardNo');
		return;
	}
}

function ChangPaadm(){
  var PatientID=DHCC_GetElementData('PatientID');
  var EpisodeID=DHCC_GetElementData('EpisodeID');
  var mradm=DHCC_GetElementData('mradm');

  var TWKFL=parent.DefaultTWKFL;
  var TWKFLI=parent.DefaultTWKFLI;
  var XCONTEXT=parent.DefaultXCONTEXT;
  var ChartID="";
  var RepeatOrders="";
  var EPRChartName="";
  var MultiEpisodeID="";
  var AllowUpdateWithNoOrders="";
  var MultiEpisodeID="";
  var EpisLoc=""
  var AllowUpdateWithNoOrders="";
	var ordentrydetails="&SUMMFlag=";
	
	var win=top.frames['eprmenu'];
	if (win) {
		var frm = win.document.forms['fEPRMENU'];
		if (frm) {
			frm.PatientID.value = PatientID;
			frm.EpisodeID.value = EpisodeID;
			frm.EpisodeID.value = mradm;
		}
	}

	parent.urlEPRDefault=parent.urlEPRdefaultWL+"&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&mradm="+mradm;
	OrderEntryFrame=parent.frames["oeorder_entry"];
	if (OrderEntryFrame){
		var lur="oeorder.oplistcustom.csp?PatientBannerExclude=1&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&NeedDiagnosFlag=0"+"&mradm="+mradm;
		///+"&MultiEpisodeID="+MultiEpisodeID+"&EpisLoc="+EpisLoc+"&CONTEXT="+XCONTEXT+ordentrydetails+"&RepeatOrders="+RepeatOrders+"&AllowUpdateWithNoOrders="+AllowUpdateWithNoOrders+"&BillTypeID="+BillTypeID+"&mradm="+MRADMID;
		//alert(lur);
		OrderEntryFrame.location=lur;
	}
}

function GetCardTypeRowId(){
	var CardTypeRowId="";
	//var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=combo_CardType.getActualValue();
	
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId;
}

function GetCardTypeRegType(){
	var RegType="";
	var CardTypeValue=DHCC_GetElementData("CardType");
	/*var CardTypeValue=combo_CardType.getActualValue();
	//alert(CardTypeValue);
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		RegType=CardTypeArr[35];
		//alert(RegType);
	}*/
	return CardTypeValue;
}

function GetCardNoLength(){
	var CardNoLength="";
	//var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=combo_CardType.getActualValue();

	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	return 15
	return CardNoLength;
}

function FormatCardNo(){
	var CardNo=DHCC_GetElementData("CardNo");
	if (CardNo!='') {
		var CardNoLength=GetCardNoLength();
		if ((CardNo.length<CardNoLength)&&(CardNoLength!=0)) {
			for (var i=(CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
			}
		}
		if ((CardNo.length>CardNoLength)&&(CardNoLength!=0)){
			CardNo=CardNo.substring(0,CardNoLength);
		}
	}
	return CardNo
}

function ReadCardClickHandler(){
	var CardTypeRowId=GetCardTypeRowId();
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	AccAmount=myary[3];

	switch (rtn){
		case "0": //卡有效
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				var NewCardTypeRowId=myary[8];
				combo_CardType.SetComboValue(NewCardTypeRowId);
				SetPatientInfo(PatientNo,CardNo);
			break;
		case "-200": //卡无效
			alert(t['InvaildCard']);
			websys_setfocus('RegNo');
			break;
		case "-201": //现金
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				
				var NewCardTypeRowId=myary[8];
				//if (NewCardTypeRowId!=CardTypeRowId) SetComboValue(combo_CardType,NewCardTypeRowId);
				combo_CardType.setComboValue(NewCardTypeRowId);

				SetPatientInfo(PatientNo,CardNo);
			break;
		default:
	}
}
function SetPatientInfo(PatientNo,CardNo){
	if (PatientNo!='') {
		ClearPatInfo();
		//因为在ClearPatInfo()时会把PatientNo的值清空,所以要重新赋值
		DHCC_SetElementData("PatientNo",PatientNo);
		DHCC_SetElementData("CardNo",CardNo);
		var encmeth=DHCC_GetElementData('GetDetail');
		if (encmeth!=""){
			if (cspRunServerMethod(encmeth,'SetPatient_Sel','',PatientNo)=='0') {
				var obj=document.getElementById('CardNo');
				obj.className='clsInvalid';
				websys_setfocus('CardNo');
				return websys_cancel();
			}else{
				var obj=document.getElementById('CardNo');
				obj.className='';
				DHCC_Nextfoucs();
				return websys_cancel();				
			}
		}
	} else {
		websys_setfocus('CardNo');
		return websys_cancel();
	}
}


function CardNoKeydownHandler(e) {
	//这边要与卡处理一致
	if (evtName=='CardNo') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
		var CardNo=DHCC_GetElementData("CardNo");
		var CardTypeRowId=GetCardTypeRowId();
		//if (CardTypeRowId!="") CardNo=FormatCardNo();
		CardNo=FormatCardNo();
		//alert(CardNo);
		if (CardNo=="") return;
		var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardNo,"","PatInfo");
		//alert(myrtn)
		var myary=myrtn.split("^");
		var rtn=myary[0];
		AccAmount=myary[3];
		switch (rtn){
			case "0": //卡有效有帐户
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1];
				var NewCardTypeRowId=myary[8];

				combo_CardType.setComboValue(NewCardTypeRowId);
				SetPatientInfo(PatientNo,CardNo);
				break;
			case "-200": //卡无效
				alert(t['InvaildCard']);
				websys_setfocus('CardNo');
				break;
			case "-201": //卡有效无帐户
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1];
				var NewCardTypeRowId=myary[8];
				combo_CardType.setComboValue(NewCardTypeRowId);
				SetPatientInfo(PatientNo,CardNo);
				break;
			default:
		}
	}
}

function SetPatient_Sel(value) {
	try {
		var Patdetail=value.split("^");	
		DHCC_SetElementData("Name",Patdetail[0]);
		DHCC_SetElementData("Age",Patdetail[1]);
		DHCC_SetElementData("Sex",Patdetail[2]);
		//门诊病历号和住院病历号
		DHCC_SetElementData("OPMRN",Patdetail[3]);
		DHCC_SetElementData("IPMRN",Patdetail[4]);
		var PatCat=Patdetail[5];
		DHCC_SetElementData("PatCat",PatCat);
			
		if (PatCat==""){
			alert(t["PatCatIsNull"])
			ClearPatInfo();
			return;
		}
		DHCC_SetElementData("PatientID",Patdetail[6]);
		DHCC_SetElementData("IDCardNo",Patdetail[7]);
		DHCC_SetElementData("Company",Patdetail[8]);
		DHCC_SetElementData("PatientNo",Patdetail[9]);

	} catch(e) {
		alert(e.message)
	};
}
function Clear_click()	{
	ClearPatInfo();
	websys_setfocus('CardNo');
	combo_CardType.setComboText("");
}

function ClearPatInfo(){
	//DHCC_SetElementData("CardNo","");
	DHCC_SetElementData("CardNo",CommonCardNo);
	DHCC_SetElementData("PatientID","");
	DHCC_SetElementData("EpisodeID","");
	DHCC_SetElementData("mradm","");
	DHCC_SetElementData("PatientNo","");
	DHCC_SetElementData("Name","");
	DHCC_SetElementData("Age","");
	DHCC_SetElementData("Sex","");
	DHCC_SetElementData("IDCardNo","");
	DHCC_SetElementData("IPMRN","");
	DHCC_SetElementData("OPMRN","");
	DHCC_SetElementData("PatCat","");
	DHCC_SetElementData("BillType","");
	DHCC_SetElementData("Company","");
	DHCC_SetElementData("Address","");


}