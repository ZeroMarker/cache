//DHCOPAdm.Reg.Alloc.js
//记录前个登记号,以便检查前个挂号未完成时复原卡号
var PreCardNo="";
//帐户余额 
var AccAmount=0.00;
var CommonCardNo="";
var NeedReceiptNoMsg;
var HospitalCode="";
var m_CCMRowID="";
var EncryptObj=new Object();
var DefaultDepFlag=""
var SelectedRow = 0;
function GetCardTypeRowId(){
	var CardTypeRowId="";
	var CardTypeValue=combo_CardType.getSelectedValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId;
}

function GetCardEqRowId(){
	var CardEqRowId="";
	var CardTypeValue=combo_CardType.getSelectedValue();
	
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardEqRowId=CardTypeArr[14];
	}
	return CardEqRowId;
}

function GetCardTypeRegType(){
	var RegType="";
	var CardTypeValue=combo_CardType.getSelectedValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		RegType=CardTypeArr[0];
	}
	return CardTypeValue;
}

function GetCardNoLength(){
	var CardNoLength="";
	var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=combo_CardType.getSelectedValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	if (HospitalCode=='HXYY')	return 15;
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
	}

	return CardNo
}

function combo_CardTypeKeydownHandler(){
	var myoptval=combo_CardType.getSelectedValue();
	var myary=myoptval.split("^");
	var myCardTypeDR=myary[0];
	if (myCardTypeDR=="")	{	return;	}
	///Read Card Mode
	if (myary[16]=="Handle"){
		var myobj=document.getElementById("CardNo");
		if (myobj){myobj.readOnly = false;}
		DHCWeb_DisBtnA("ReadCard");
		DHCWeb_setfocus("CardNo");
	}	else{
		
		m_CCMRowID=GetCardEqRowId();
		var myobj=document.getElementById("CardNo");
		if (myobj){myobj.readOnly = true;}
		//if (myobj){myobj.readOnly = false;}     //郭荣勇 支持手输卡号功能
		var obj=document.getElementById("ReadCard");
		if (obj){
			obj.disabled=false;
			DHCC_AvailabilityBtn(obj)
			obj.onclick=ReadCardClickHandler;
		}
		DHCWeb_setfocus("ReadCard");
	}
	
	if (myary[16]=="Handle"){
		
		DHCWeb_setfocus("CardNo");
	}else{
		DHCWeb_setfocus("ReadCard");
	}
	
	if (combo_CardType) websys_nexttab(combo_CardType.tabIndex);
}

function combo_PayModeKeydownHandler()
{
	if (combo_PayMode) websys_nexttab(combo_PayMode.tabIndex);
}

function GetAccAmount(){
	var CardTypeRowId=GetCardTypeRowId();
	var myoptval=combo_CardType.getSelectedValue();
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
	var myary=myrtn.split("^");
	AccAmount=myary[3];
  return AccAmount;  
}

function ReadCardClickHandler(){
	var CardTypeRowId=GetCardTypeRowId();
	var CardEqRowId=GetCardEqRowId();
	var myoptval=combo_CardType.getSelectedValue();
	//通过读卡按钮时调用函数需要这个
	m_CCMRowID=GetCardEqRowId();
	//alert(CardTypeRowId+"&&"+m_CCMRowID+"&&"+myoptval)
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	AccAmount=myary[3];
    DHCC_SetElementData("AccAmount",AccAmount);
    //alert(myrtn);
	switch (rtn){
		case "0": //卡有效
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				var NewCardTypeRowId=myary[8];
				//说明先选择卡类型再读卡,华西通过读卡得到卡类型ID
				//if (NewCardTypeRowId!=CardTypeRowId) SetComboValue(combo_CardType,NewCardTypeRowId);
				//combo_CardType.setComboValue(NewCardTypeRowId);
				var RegType=GetCardTypeRegType();
				if (CardTypeRowId!=NewCardTypeRowId){
					alert(t['CardNoTypeNotMatch']);
					return;
				}
				var AppFlag=DHCC_GetElementData("AppFlag");
				if ((AppFlag==1)&&(RegType=="REG")){
					alert(t['CardOnlyForReg']);
					return;
				}
				DHCC_SelectOptionByCode("PayMode","CPP");
				SetPatientInfo(PatientNo,CardNo);
				
			break;
		case "-200": //卡无效
			alert(t['InvaildCard']);
			//websys_setfocus('RegNo');
			break;
		case "-201": //现金
			//alert(t['21']);
   		return;
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				
				var NewCardTypeRowId=myary[8];
				//if (NewCardTypeRowId!=CardTypeRowId) SetComboValue(combo_CardType,NewCardTypeRowId);
				//combo_CardType.setComboValue(NewCardTypeRowId);
				var RegType=GetCardTypeRegType();
				if (CardTypeRowId!=NewCardTypeRowId){
					alert(t['CardNoTypeNotMatch']);
					return;
				}
				var AppFlag=DHCC_GetElementData("AppFlag");
				if ((AppFlag==1)&&(RegType=="REG")){
					alert(t['CardOnlyForReg']);
					return;
				}
				//DHCC_SelectOptionByCode("PayMode","CASH")
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
		DHCC_SetElementData("CardLeaving",DHCC_GetElementData("AccAmount"));
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
				var parobj=parent.frames["DHCOPReturn"];
				if(parobj)
				{  
				    
				    parobj.document.getElementById("CardNo").value=CardNo;
				    parobj.document.getElementById("PatientID").value=DHCC_GetElementData("PatientID");
					parobj.SetPatientInfo(PatientNo,CardNo,DHCC_GetElementData("PatientID"));
					var CardTypeRowId=GetCardTypeRowId();
					parobj.combo_CardType.setComboValue(CardTypeRowId);
					//alert(parobj.document.getElementById("CardNo").value)
					parobj.Find_click();	
				}
				return websys_cancel();				
			}
		}
	} else {
		websys_setfocus('CardNo');
		return websys_cancel();
	}
}
function SetPassCardNo(CardNo,CardType){
	DHCC_SetElementData("CardNo",CardNo);
	CheckCardNo();
}
function CheckCardNo(){
		var AppFlag=DHCC_GetElementData('AppFlag');
		var CardNo=DHCC_GetElementData("CardNo");
		var CardTypeRowId=GetCardTypeRowId();

		CardNo=FormatCardNo();
		if (CardNo=="") return;
		
		var myoptval=combo_CardType.getSelectedValue();
		var myary=myoptval.split("^");
		var myCardTypeDR=myary[0];
		if (myCardTypeDR=="")	{	return;	}
	
		if (myary[16]=="Handle"){
			//var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardNo,"","PatInfo");
			var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardNo,"","");
		}else{
			var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
		}
		//alert(CardTypeRowId+"!"+CardNo+"!"+myrtn)
		var myary=myrtn.split("^");
		var rtn=myary[0];
		AccAmount=myary[3];
		DHCC_SetElementData("AccAmount",AccAmount);
		switch (rtn){
			case "0": //卡有效有帐户
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1];
				var NewCardTypeRowId=myary[8];
				//通过卡号去找卡找到卡类型,如果采用这种方式1?卡类型的串会丢失?2?多种卡类型的同一个卡号无法找到多个  NewCardTypeRowId==""说明卡有多种卡类型gry
				//if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
				var RegType=GetCardTypeRegType();
				if (CardTypeRowId!=NewCardTypeRowId){
					alert(t['CardNoTypeNotMatch']);
					return;
				}
				var AppFlag=DHCC_GetElementData("AppFlag");
				if ((AppFlag==1)&&(RegType=="REG")){
					alert(t['CardOnlyForReg']);
					return;
				}
				//分诊区挂号，只允许预交金支付
				/*if(AccAmount<=0){
					alert(t['Accountbalanceinsufficient']);
					DHCC_SelectOptionByCode("PayMode","CASH");
				}
				else{
					DHCC_SelectOptionByCode("PayMode","CPP");
				}*/
				SetPatientInfo(PatientNo,CardNo);
				break;
			case "-200": //卡无效
				alert(t['InvaildCard']);
				websys_setfocus('CardNo');
				break;
			case "-201": //卡有效无帐户
				//alert(t['21']);
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1];
				var NewCardTypeRowId=myary[8];
				//通过卡号去找卡找到卡类型
				//if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
				var RegType=GetCardTypeRegType();
				if (CardTypeRowId!=NewCardTypeRowId){
					alert(t['CardNoTypeNotMatch']);
					return;
				}
				if ((AppFlag==1)&&(RegType=="临时医疗卡")){
					alert(t['CardOnlyForReg']);
					return;
				}
				
				//DHCC_SetElementData("PayMode","CASH");
				DHCC_SelectOptionByCode("PayMode","CASH");
				var obj=document.getElementById("PayMode");
				SetPatientInfo(PatientNo,CardNo);
        		YBTypeCheck();
				break;
			default:
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
		CheckCardNo();
	}
	
}

function SetComboValue(obj,val){
	if (obj) {
		var ind=obj.getIndexByValue(val);
		if (ind==-1){obj.setComboText("");return;}
		obj.selectOption(ind)
	}
}

function SetPatient_Sel(value) {
	try {  
		var Patdetail=value.split("^");
		DHCC_SetElementData("Name",Patdetail[0]);
		DHCC_SetElementData("Age",Patdetail[1]);
		DHCC_SetElementData("Sex",Patdetail[2]);
		/*   //潍坊
		DHCC_SetElementData("ParDr",Patdetail[5]);
		DHCC_SetElementData("OldMan",Patdetail[11]);
		DHCC_SetElementData("Mentality",Patdetail[12]);
	  CodeId=Patdetail[9];
	  */
		//门诊病历号和住院病历号
		DHCC_SetElementData("OPMRN",Patdetail[3]);
		DHCC_SetElementData("IPMRN",Patdetail[4]);
		//医保号
		DHCC_SetElementData("PatYBCode",Patdetail[11]);
		//医保类型
		DHCC_SetElementData("YBType",Patdetail[12]);
		//西院门诊病历号和住院病历号
		
		var PAPERSGMedicareCode1=Patdetail[13];
		var PAPERSGMedicareCode2=Patdetail[14];
		DHCC_SetElementData("SGMedicareCode1",PAPERSGMedicareCode1);
		DHCC_SetElementData("SGMedicareCode2",PAPERSGMedicareCode2);
		
		var PatCat=Patdetail[5];
		DHCC_SetElementData("PatCat",PatCat);	
		if (PatCat==""){
			alert(t["PatCatIsNull"])
			var CardNo=DHCC_GetElementData("CardNo");
			var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCPatient&CardNo="+CardNo;
			Clear_click();
			if(typeof websys_writeMWToken=='function') lnk=websys_writeMWToken(lnk);
			win=open(lnk,"ModPat","status=1,top=80,left=50,width=900,height=490,scrollbars=Yes");
			websys_setfocus('CardNo');
			return websys_cancel();
		}
		
		DHCC_SetElementData("PatientID",Patdetail[6]);
		DHCC_SetElementData("IDCardNo",Patdetail[7]);
		DHCC_SetElementData("Company",Patdetail[8]);
		DHCC_SetElementData("PatientNo",Patdetail[9]);
		DHCC_SetElementData("AppBreakCount",Patdetail[10]);

		var PatientID=Patdetail[6];
		var encmeth=DHCWebD_GetObjValue("getadmrecord");
	 /*
    if (encmeth!=""){
      if(cspRunServerMethod(encmeth,PatientID)==0){
    		 DHCC_SetElementData("MedicalBook",true);
	       DHCC_SetElementData("NeedCardFee",true);
	       MedicalBookCheck();
	  		 NeedCardFeeCheck();
			   //document.getElementById('MRRecord').value='F'
	  	}else{ */
	  	   DHCC_SetElementData("MedicalBook",false);
	  	   DHCC_SetElementData("NeedCardFee",false);
	  	   //document.getElementById('MRRecord').value='R';	
	  	//}
    //}
		DHCC_ClearList("BillType");
    var encmeth=DHCC_GetElementData("GetBillTypeMethod");
    if (encmeth!=""){
			var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","BillType",PatientID);
    }
    	
    SetBillTypeLabel();	
		if (PreCardNo==""){PreCardNo=DHCC_GetElementData("CardNo");}
	} catch(e) {alert(e.message)}
}

//潍坊显示费别label
function SetBillTypeLabel()
{
	//通过医院代码判断
	if (HospitalCode!="WFRMYY") return
	if (document.getElementById('BillType')){
		document.getElementById('ShowAdmType').className='';
		var obj = document.getElementById("BillType");
    var strsel = obj.options[obj.selectedIndex].text
			
		DHCC_SetElementData("ShowAdmType",strsel);
		if (strsel=='省企离休'){
			var encmeth=DHCC_GetElementData("GetGYFristMethod");
			if (encmeth!=''){
				var rtn=cspRunServerMethod(encmeth,PatientID);
			  if (rtn=='0')	DHCC_SetElementData("DeptList","YZS");
			}
	
		}
		document.getElementById('ShowAdmType').className='dhx_l';
	}
}
function Clear_click()	{
	ClearPatInfo();
	DHCC_SetElementData('FindDept',"");
	DHCReg_ClearTable(parent.frames["DHCOPAdm.Reg.MarkList"],"tDHCOPAdm_Reg_MarkList");
	DHCReg_ClearTable(parent.frames["DHCOPReturn"],"tDHCOPReturn");
	if (parent.frames["DHCOPReturn"]){parent.frames["DHCOPReturn"].ClearNormal();}
	websys_setfocus('CardNo');
	PreCareNo="";
	//GetReceiptNo();
	//ReadPayMode();
	SetDefultCardType();
	var obj=document.getElementById('DeptList');
		if(obj&&(obj.options.length>0))
		{
			obj.selectedIndex=-1;
		}
	}
function SetDefultCardType(){
	
	var DefType=tkMakeServerCall('web.UDHCOPOtherLB','getDefaultCardType');
	var DefTypeArr=DefType.split('^');
	var DefTypeId=DefTypeArr[0];
	var DefTypeDesc=DefTypeArr[2];
	combo_CardType.setComboValue(DefType);

}
function ClearPatInfo(){
	DHCC_SetElementData("CardNo","");
	//通过配置来决定是否显示公共卡 090312
	//DHCC_SetElementData("CardNo",CommonCardNo);
	DHCC_SetElementData("PatientID","");
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
	DHCC_SetElementData("SeqNo","");
	DHCC_SetElementData("Time","")
	DHCC_SetElementData("YBType","");
	DHCC_SetElementData("PatYBCode","");
	DHCC_SetElementData("SGMedicareCode1","");
	DHCC_SetElementData("SGMedicareCode2","");
	DHCC_SetElementData("BLFlag","");
	DHCC_SetElementData("CardLeaving","");
	DHCC_SetElementData("MedicalBook","");
	DHCC_SetElementData("NeedCardFee","");
	DHCC_SetElementData("PatCatDr","");
  	DHCC_SetElementData("DiagnosCat","");
  	DHCC_SetElementData("ShowAdmType","");
  	DHCC_SetElementData("OldMan","");
  	DHCC_SetElementData("ParDr","");
	DHCC_SetElementData('DepRowId','');
	DHCC_SetElementData('DocRowId','');
	//DHCC_SetElementData("MarkCode","")
	DHCC_SetElementData("RoomCode","")
	//应收,实收,找零
	DHCC_SetElementData("BillAmount","0.00");
	DHCC_SetElementData("GetAmount","0.00");
	DHCC_SetElementData("ReturnAmount","0.00");
	var obj=document.getElementById('ReturnAmount');
	if (obj) obj.className='';
	SetDefaultAppDate();
	AccAmount=0;
	//window.setTimeout("CollectGarbage()",1);

}


function QueryClickHandler(e){
	if (combo_MarkCode){var obj=combo_MarkCode;}else{var obj=combo_DeptList;}
	DeptListDblClickHandler(obj);
}
function DeptListDblClickHandler() {
	var AppFlag=DHCC_GetElementData("AppFlag");
	var PatientID=DHCC_GetElementData('PatientID');
	/*
	if ((PatientID=="")&&(AppFlag!="1")) {
		alert(t['NotSelectPatient']);
		websys_setfocus('CardNo');
		return false;
	}
	*/
	AppDate=GetAppDate();
	if (AppFlag=="0") {AppDate="";}
	if (AppFlag=="1"){
		if (AppDate=="") {
			AppDate="0";
		}else{
			var DefaultAppDate=DHCC_GetElementData("DefaultAppDate")
			var ret=CheckOrderStartDate(AppDate,DefaultAppDate);
			//alert(ret);
			if (!ret){
				alert(t['WrongAppDate']);
				SetDefaultAppDate();
				websys_setfocus('AppDate');
				return
			}
		}
	}
  var TimeRangeRowId=combo_TimeRange.getSelectedValue();
  /*
  if (TimeRangeRowId==""){
  	var len=combo_TimeRange.optionsArr.length;
		for(var i=0;i<len;i++)	{
			var TRRowId=combo_TimeRange.optionsArr[i].value;
			if (TimeRangeRowId=="") {TimeRangeRowId=TRRowId}else{TimeRangeRowId=TimeRangeRowId+"!"+TRRowId}
		}
  }
  */
 	var DepRowId=DHCC_GetElementData('DepRowId');
	//var DocRowId=DHCC_GetElementData('DocRowId');
	//var DepRowId=combo_DeptList.getSelectedValue();
	var DocRowId="";
	//如果没有选择医生或科室则不做查询,因为这样是没能意义的
	//alert(DepRowId+"^"+DocRowId+"^"+TimeRangeRowId+"^"+AppDate)
	//if (((DepRowId!="")&&(DocRowId=='')&&(AppDate=="0"))||((DepRowId=="")&&(DocRowId==''))) {
	DHCReg_ClearTable(parent.frames["DHCOPAdm.Reg.MarkList"],"tDHCOPAdm_Reg_MarkList");
	selectedRowObj=new Object();
	selectedRowObj.rowIndex="";
    var tblobj=parent.frames["DHCOPAdm.Reg.MarkList"].document.getElementById('tDHCOPAdm_Reg_MarkList');
	var p1=DepRowId+"^"+session['LOGON.USERID']+"^"+AppDate+"^"+PatientID+"^"+TimeRangeRowId+"^"+DocRowId+"^"+session['LOGON.GROUPID'];
	var encmeth=DHCC_GetElementData("GetDocMethod")
	if (encmeth!=""){
		if (cspRunServerMethod(encmeth,'AddMarkToTable','',p1)=='0') {
			obj.className='clsInvalid';
			return websys_cancel();
		}
	}

	return true
}


function AddMarkToTable(val) {
	try {//alert(val)
		var objtbl=parent.frames["DHCOPAdm.Reg.MarkList"].document.getElementById('tDHCOPAdm_Reg_MarkList');
		var Arr=val.split("!");
		for (var i=0; i<Arr.length; i++) {
			var valueAry=Arr[i].split("^");
			var ASRowId=valueAry[0];
			var MarkDesc=valueAry[1];
			var RegLoad=valueAry[2];
			var AppLoad=valueAry[3];
			var AddLoad=valueAry[4];
			var AvailSeqNoStr=valueAry[5];
			var AvailAddSeqNoStr=valueAry[6];
			var RoomDesc=valueAry[7];
			var ClinicGroupDesc=valueAry[8];
			var SessionTypeDesc=valueAry[9];
			var RegFee=valueAry[10];
			var RegFeeDr=valueAry[11];
			var ExamFee=valueAry[12];
			var ReCheckFee=valueAry[13];
			var HoliFee=valueAry[14];
			var HoliFeeDr=valueAry[15];
			var AppFee=valueAry[16];
			var OtherFee=valueAry[17];
			var RoomCode=valueAry[18];
			var DepDesc=valueAry[19];
			var RegedCount=valueAry[20];
			var AppedCount=valueAry[21];
			var AddedCount=valueAry[22];
			
			var AvailNorSeqNoStr=valueAry[23];
			var ScheduleStatus=valueAry[24];
			var ScheduleDate=valueAry[25];
			var ScheduleDateWeek=valueAry[26];
			var TimeRange=valueAry[27];
			var ToAdmCount=valueAry[28];
			if (RegFee=="") RegFee=0;
			if (ExamFee=="") ExamFee=0;
			if (HoliFee=="") HoliFee=0;
			if (AppFee=="") AppFee=0;
			if (OtherFee=="") OtherFee=0;
			if (ToAdmCount=="") ToAdmCount=0;
			//var Row=AddRows(objtbl);alert("ddd")
			if (i>0){AddRow(objtbl);}
			var Row=objtbl.rows.length-1;
			SetColumnData("MarkDesc",Row,MarkDesc);
			SetColumnData("Load",Row,RegLoad);
			SetColumnData("AppLoad",Row,AppLoad);
			SetColumnData("AddLoad",Row,AddLoad);
			SetColumnData("AvailSeqNoStr",Row,AvailSeqNoStr);
			SetColumnData("AvailAddSeqNoStr",Row,AvailAddSeqNoStr);
			SetColumnData("RoomDesc",Row,RoomDesc);
			SetColumnData("ClinicGroupDesc",Row,ClinicGroupDesc);
			SetColumnData("SessionTypeDesc",Row,SessionTypeDesc);
			SetColumnData("RegFee",Row,RegFee);
			SetColumnData("ExamFee",Row,ExamFee);
			SetColumnData("HoliFee",Row,HoliFee);
			SetColumnData("AppFee",Row,AppFee);
			SetColumnData("OtherFee",Row,OtherFee);
			SetColumnData("ReCheckFee",Row,ReCheckFee);
			//SetColumnData("AppFeeDr",Row,AppFeeDr);
			//SetColumnData("HoliFeeDr",Row,HoliFeeDr);
			//SetColumnData("ExamFeeDr",Row,ExamFeeDr);
			//SetColumnData("RegFeeDr",Row,RegFeeDr);
			SetColumnData("ASRowId",Row,ASRowId);
			SetColumnData("RoomCode",Row,RoomCode);
			SetColumnData("DepDesc",Row,DepDesc);
			SetColumnData("RegedCount",Row,RegedCount);
			SetColumnData("AppedCount",Row,AppedCount);
			SetColumnData("AddedCount",Row,AddedCount);
			SetColumnData("AvailNorSeqNoStr",Row,AvailNorSeqNoStr);
			SetColumnData("ScheduleStatus",Row,ScheduleStatus);
			SetColumnData("ScheduleDate",Row,ScheduleDate);
			SetColumnData("ScheduleDateWeek",Row,ScheduleDateWeek);
			SetColumnData("TimeRange",Row,TimeRange);
			SetColumnData("ToAdmCount",Row,ToAdmCount);
			SetColumnData("selectID",Row,false);
			if (ASRowId!=""){
				var SeqNoMode=DHCC_GetElementData('SeqNoMode');
				if ((AvailSeqNoStr=="")&&(AvailAddSeqNoStr=="")&&(SeqNoMode=='')){
					//alert(AvailSeqNoStr+"^"+AvailAddSeqNoStr+"^"+SeqNoMode)
					//objtbl.rows[Row].className='SqueezedIn';
					objtbl.rows[Row].className='ScheduleFull';
				}
				if ((AvailNorSeqNoStr=="")&&(SeqNoMode=='1')){
					objtbl.rows[Row].className='ScheduleFull';
				}
			}
		}
	} catch(e) {alert(e.message)};
}
function GetTableSelectRow(e){
	if (selectedRowObj.rowIndex==""){return "";}
	var selectrow=selectedRowObj.rowIndex;
	return selectrow;
}



function GetSelectRowPrice(selectrow){
	var RegFee=GetColumnData("RegFee",selectrow);
	var ExamFee=GetColumnData("ExamFee",selectrow);
	var HoliFee=GetColumnData("HoliFee",selectrow);
	var AppFee=GetColumnData("AppFee",selectrow);
	var OtherFee=GetColumnData("OtherFee",selectrow);
 
 	var AppDate=GetColumnData("ScheduleDate",selectrow);
 	var CurrentDate=DHCC_GetElementData('CurrentDate');
 	var AppFlag=DHCC_GetElementData('AppFlag');
 
	if ((CurrentDate==AppDate)&&(AppDate!="")){AppDate="";}
	if (AppDate==""){AppFee=0;}
	var TotalFee=parseFloat(HoliFee)+parseFloat(ExamFee)+parseFloat(RegFee)+parseFloat(AppFee)+parseFloat(OtherFee);
 	
 	var MedicalBookVal=DHCC_GetElementData('MedicalBook');
 	if (MedicalBookVal==true){
 		var MRNoteFee=DHCC_GetElementData('MRNoteFee');
 		TotalFee=TotalFee+parseFloat(MRNoteFee);
 	}
 	var NeedCardFee=DHCC_GetElementData('NeedCardFee');
 	if (NeedCardFee==true){
 		var CardFee=DHCC_GetElementData('CardFee');
 		TotalFee=TotalFee+parseFloat(CardFee);
 	}
 	DHCC_SetElementData("BillAmount",TotalFee);
	return TotalFee
}

function GetPayModeCode(){
	var obj=document.getElementById("PayMode");
	if (obj){
	  var PayModeValue=obj.value;
	  var pmod=PayModeValue.split("^");	
		return pmod[2];
	}
	return "";
}
function AppointNormalClickHandler(e){
	var ret=AddBeforeUpdate();
	if (ret==false){return false}
	
	var objtbl=document.getElementById('tDHCOPAdm_Reg');
	var rows=objtbl.rows.length;
	if (rows==2) {
		var ASRowId=GetColumnData('TabASRowId',1);
		if (ASRowId==''){
			alert(t['NoRegRow']);
			return false;
		}
	}

	//办理预约是否要预先分配号,取号的处理在同一界面吗
	var AppFlag=DHCC_GetElementData('AppFlag');
	var PatientID=DHCC_GetElementData('PatientID');
	var AdmReason="";
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];
	
	try {
		for (var j=1;j<rows;j++) {
			var TabASRowId=GetColumnData("TabASRowId",j);
			var TabQueueNo=GetColumnData("TabSeqNo",j);
			var encmeth=DHCC_GetElementData('OPRAppNormalEncrypt');
			if (encmeth!=''){
				var ret=cspRunServerMethod(encmeth,'','',PatientID,TabASRowId,TabQueueNo,UserID);
				if (ret=="0"){
					alert(t["AppOK"]);
					Clear_click();
				}else{
					alert(t['AppFail']+ret);
					RemoveOPAdmRegDblRow(j);
					websys_setfocus('CardNo');
					return;
				}
			}
		}
	}catch(e){alert(e.message)}			
}

function AppointClickHandler(){
	
	var objtbl=document.getElementById('tDHCOPAdm_Reg');
	var rows=objtbl.rows.length;
	if (rows==2) {
		var ASRowId=GetColumnData('TabASRowId',1);
		if (ASRowId==''){
			alert(t['NoRegRow']);
			return false;
		}
	}

	//办理预约是否要预先分配号,取号的处理在同一界面吗
	var AppFlag=DHCC_GetElementData('AppFlag');
	var PatientID=DHCC_GetElementData('PatientID');
	var AdmReason="";
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];

	try {
		for (var j=1;j<rows;j++) {
			var TabASRowId=GetColumnData("TabASRowId",j);
			var TabQueueNo=GetColumnData("TabSeqNo",j);
			
			var encmeth=DHCC_GetElementData('OPRAppEncrypt');
			if (encmeth!=''){
				var retstr=cspRunServerMethod(encmeth,'','',PatientID,TabASRowId,TabQueueNo,UserID);
				retArr=retstr.split("^")
				ret=retArr[0]
				var AppARowid=retArr[1]
				if (ret=="0"){
					alert(t["AppOK"]);  
					Clear_click();
					//配置 决定是否打印预约条?做单独一个函数   090312
					var AppPrinte=DHCC_GetElementData('AppPrint');
					if(AppPrinte!=""){
						//var AppPrintData=cspRunServerMethod(encmeth,AppARowid);
						
					//AppPrintOut(AppPrintData)//此处调用打印程序
					}
				}else{
					alert(t['AppFail']+ret);
					RemoveOPAdmRegDblRow(j);
					websys_setfocus('CardNo');
					return;
				}
			}
		}
	}catch(e){alert(e.message)}			
	
}
function AppointTelClickHandler(){
	var objtbl=document.getElementById('tDHCOPAdm_Reg');
	var rows=objtbl.rows.length;
	if (rows==2) {
		var ASRowId=GetColumnData('TabASRowId',1);
		if (ASRowId==''){
			alert(t['NoRegRow']);
			return false;
		}
	}

	//办理预约是否要预先分配号,取号的处理在同一界面吗
	var AppFlag=DHCC_GetElementData('AppFlag');
	var PatientID=DHCC_GetElementData('PatientID');
	var AdmReason="";
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];

	try {
		for (var j=1;j<rows;j++) {
			var TabASRowId=GetColumnData("TabASRowId",j);
			var TabQueueNo=GetColumnData("TabSeqNo",j);
			
			var encmeth=DHCC_GetElementData('OPAppTelEncrypt');
			if (encmeth!=''){
				var retstr=cspRunServerMethod(encmeth,'','',PatientID,TabASRowId,TabQueueNo,UserID);
				retArr=retstr.split("^")
				ret=retArr[0]
				var AppARowid=retArr[1]
				if (ret=="0"){
					alert(t["AppOK"]);  
					Clear_click();
					//配置 决定是否打印预约条?做单独一个函数   090312
					var AppPrinte=DHCC_GetElementData('AppPrint');
					if(AppPrinte!=""){
						//var AppPrintData=cspRunServerMethod(encmeth,AppARowid);
						//AppPrintOut(AppPrintData)//此处调用打印程序
					}
				}else{
					alert(t['AppFail']+ret);
					RemoveOPAdmRegDblRow(j);
					websys_setfocus('CardNo');
					return;
				}
			}
		}
	}catch(e){alert(e.message)}			
	
}
function AddBeforeUpdate(selectrow){
	var ASRowId=GetColumnData("ASRowId",selectrow);
	var AvailSeqNoStr=GetColumnData("AvailSeqNoStr",selectrow);
	var AvailAddSeqNoStr=GetColumnData("AvailAddSeqNoStr",selectrow);
	var AvailNorSeqNoStr=GetColumnData("AvailNorSeqNoStr",selectrow);
	if (ASRowId=="") return false;
	//号别已挂完
	var AppFlag=DHCC_GetElementData('AppFlag');
	if (AppFlag==0){
			if ((AvailSeqNoStr=="")&&(AvailAddSeqNoStr=="")){
				alert(t['ConfirmAddMark']);                        
				return false;
			}
		}else{
			var SeqNoMode=DHCC_GetElementData('SeqNoMode');
			var AdmType=DHCC_GetElementData('AdmType');
			if (AdmType!='E') {
				if ((AvailSeqNoStr=="")&&(AvailAddSeqNoStr=="")&&(SeqNoMode=='')){
					alert(t['MarkIsFull']);
					return false;
				}
				if ((AvailNorSeqNoStr=="")&&(SeqNoMode=='1')){
					alert(t['MarkIsFull']);
					return false;
				}
			}
		}
	return true;
}
function SetDefaultTimeRange(){
	var encmeth=DHCC_GetElementData('GetDefaultTRMethod');
	if (encmeth!=''){
		var TRRowId=cspRunServerMethod(encmeth);
		if (TRRowId!=""){
			combo_TimeRange.setComboValue(TRRowId);
		}else{
			combo_TimeRange.setComboText('');
		}
	}
}
function UpdateClickHandler(){
	var PatientID=DHCC_GetElementData('PatientID');
	if (PatientID=="") {
		alert(t['NotSelectPatient']);	
		websys_setfocus('CardNo');
		return false;
	}
	var objtbl=parent.frames["DHCOPAdm.Reg.MarkList"].document.getElementById('tDHCOPAdm_Reg_MarkList');
	var rows=objtbl.rows.length;
	var IsHaveRegFlag="";
	for (var j=1;j<objtbl.rows.length; j++) {
			var selectID=GetColumnData("selectID",j);
			var ASRowId=GetColumnData('ASRowId',j);
		  if ((selectID)&&(ASRowId!=''))
		  IsHaveRegFlag="Y"
	}
	if (IsHaveRegFlag!="Y")
	{
		 alert(t['NoRegRow']);
			return false;
	}
	var TabMRFee="0";var TabCardFee="0"
	if (DHCC_GetElementData('MedicalBook')==true){TabMRFee="1"}
	if (DHCC_GetElementData('NeedCardFee')==true){TabCardFee="1"}
	var SumPrice=0;
	var Len=objtbl.rows.length
	var objtbl=parent.frames["DHCOPAdm.Reg.MarkList"];
		for (var j=1;j<Len; j++) {
			var AddItemObj=objtbl.document.getElementById("selectIDz"+j);
			if (AddItemObj.checked) {
				var TabRegFee=GetColumnData("RegFee",j);
				var TabExamFee=GetColumnData("ExamFee",j);
				var TabHoliFee=GetColumnData("HoliFee",j);
				var TabAppFee=GetColumnData("AppFee",j);
				var TabOtherFee=GetColumnData("OtherFee",j);
				if(TabRegFee=="")TabRegFee=0;
				if(TabExamFee=="")TabExamFee=0;
				if(TabHoliFee=="")TabHoliFee=0;
				if(TabAppFee=="")TabAppFee=0;
				if(TabOtherFee=="")TabOtherFee=0;
				//alert(TabRegFee+"^"+TabExamFee+"^"+TabHoliFee+"^"+TabAppFee+"^"+TabOtherFee)
				var TabPrice=parseFloat(TabHoliFee)+parseFloat(TabExamFee)+parseFloat(TabRegFee)+parseFloat(TabAppFee)+parseFloat(TabOtherFee);
				SumPrice=parseFloat(SumPrice)+parseFloat(TabPrice);	
			}
		}
	SumPrice=parseFloat(SumPrice)+parseFloat(TabMRFee)+parseFloat(TabCardFee);
	var CardNo=DHCC_GetElementData('CardNo'); 
	//帐户RowId
	var AccRowId=""; 
	var PayModeCode="CPP"; //GetPayModeCode();
	if (PayModeCode=="CPP") {
		var myoptval=combo_CardType.getSelectedValue();
		var myary=myoptval.split("^");
		var CardTypeRowID=myary[0];
 		var ren=DHCACC_CheckMCFPay(SumPrice,CardNo,"",CardTypeRowID);
	  var myary=ren.split("^");
		if (myary[0]!='0'){
			if (myary[0]=='-204'){alert(t['AccountLocked'])}
			if (myary[0]=='-205'){alert(t['AccAmountNotEnough'])}
			if (myary[0]=='-206'){alert(t['NotSameCard'])}
			return;
		}else{
			var AccRowId=myary[1];
		}
	}	
 	//办理预约是否要预先分配号,取号的处理在同一界面吗
	var AppFlag=DHCC_GetElementData('AppFlag');
	var PatientID=DHCC_GetElementData('PatientID');
	var AdmReason="";
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];
	var LocID=session['LOGON.CTLOCID'];
	var AdmReason=DHCC_GetElementData('BillType');
	var MedicalBookVal=DHCC_GetElementData('MedicalBook');
	var AdmType=DHCC_GetElementData('AdmType');
	var DiagnosCatRowId="";
	//需要对照后台的差异   090312
	//if (combo_DiagnosCat) {DiagnosCatRowId=combo_DiagnosCat.getSelectedValue();DiagnosCatRowId=DiagnosCatRowId.split('!')[0];}
	try {
		 for (var j=1;j<Len; j++) {
			//var selectID=GetColumnData("selectID",j);
			//if (selectID) {
			var AddItemObj=objtbl.document.getElementById("selectIDz"+j);
			if (AddItemObj.checked) {
			var TabASRowId=GetColumnData("ASRowId",j);
			var TabRegFee=GetColumnData("RegFee",j);
			var TabExamFee=GetColumnData("ExamFee",j);
			var TabHoliFee=GetColumnData("HoliFee",j);
			var TabAppFee=GetColumnData("AppFee",j);
			var TabOtherFee=GetColumnData("OtherFee",j);
			if(TabRegFee=="")TabRegFee=0;
			if(TabExamFee=="")TabExamFee=0;
			if(TabHoliFee=="")TabHoliFee=0;
			if(TabAppFee=="")TabAppFee=0;
			if(TabOtherFee=="")TabOtherFee=0;
			var TabQueueNo="";
		    var TabReCheckFee=0;
		  	var TabPrice=parseFloat(TabHoliFee)+parseFloat(TabExamFee)+parseFloat(TabRegFee)+parseFloat(TabAppFee)+parseFloat(TabOtherFee);
		  	var BLNo=0;     //是否传病历号标志?0不传病历号?1传病历号
		  	var FeeStr=TabPrice+"||"+TabExamFee+"||"+TabHoliFee+"||"+TabAppFee+"||"+TabMRFee+"||"+TabReCheckFee+"||"+TabCardFee;
      	  	//alert(FeeStr)
		  	var PAADMMethod=document.getElementById('OPRegistEncrypt');
		  	if (PAADMMethod) {var encmeth=PAADMMethod.value;} else {var encmeth=''}
		  //alert(PatientID+","+TabASRowId+","+AdmReason+","+TabQueueNo+","+FeeStr+","+PayModeCode+","+AccRowId+","+UserID+","+GroupID+","+AdmType+","+DiagnosCatRowId)
		  var ret=cspRunServerMethod(encmeth,PatientID,TabASRowId,AdmReason,TabQueueNo,FeeStr,PayModeCode,AccRowId,UserID,GroupID,AdmType,DiagnosCatRowId,"","");
		  var retarr=ret.split("$");	
		  if (retarr[0]=="0"){
				var PrintArr=retarr[1].split("^");
				var EpisodeID=PrintArr[0];
				var TabASRowId=PrintArr[22];
				//var PatientID=DHCC_GetElementData('PatientID');
				var encrype=DHCC_GetElementData("GetPatMedCode");
				var MedCodeArr=cspRunServerMethod(encrype,EpisodeID);
				var MedCodeStr=MedCodeArr.split("^");
				var DYOPMRN=MedCodeStr[0];
				var DYIPMRN=MedCodeStr[1];
				var SGMedicareCode1=MedCodeStr[2];
				var SGMedicareCode2=MedCodeStr[3];
				var PatientID=MedCodeStr[4];
			    var obj=document.getElementById('AppFlag');
				if (obj.value==0){
					DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAdmRegPrint");
				} 
				if (obj.value==1){
					DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAppRegPrint");
				}
				PrintOut(j,retarr[1]);
			}else{
			  //潍坊医保外接接口 退费   090312
				//if (CType!=''){InsuOPRegFlag=(InsuOPRegDestroyInsuAdmID("10",Ybrowid,UserID,YBStr,AdmReason))}
				var errmsg="";
				if (retarr[0]=="-201")  errmsg=t['ADMInsertFail'];
				if (retarr[0]=="-202")  errmsg=t['FailGetQueueNo'];
				if (retarr[0]=="-2121")  errmsg=t['UpdateAppStatusFail'];
				if (retarr[0]=="-2122")  errmsg=t['SystemBusy'];
				if (retarr[0]=="-206")  errmsg=t['PriceArcOrderInsertFail'];
				if (retarr[0]=="-207")  errmsg=t['chrhfeeOrderInsertFail'];
				if (retarr[0]=="-208")  errmsg=t['holiOrderInsertFail'];
				if (retarr[0]=="-209")  errmsg=t['AppOrderInsertFail'];
				if (retarr[0]=="-210")  errmsg=t['FailCharge'];
				if (retarr[0]=="-211")  errmsg=t['RegFeeInsertFail'];
				if (retarr[0]=="-212")  errmsg=t['QueueInsertFail'];
				if (retarr[0]=="-301")  errmsg=t['ExceedDayRegCountLimit'];
				if (retarr[0]=="-302")  errmsg=t['ExceedDayDocRegCountLimit'];
				if (retarr[0]=="-303")  errmsg=t['ExceedDayLocRegCountLimit'];
				if (retarr[0]=="-401")  errmsg=t['LessRegStartTime'];
				if (retarr[0]=="-402")  errmsg=t['LessAppStartTime'];
				if (retarr[0]=="-403")  errmsg=t['LessAddStartTime'];
				if (retarr[0]=="-404")  errmsg=t['ExceedTREndTime'];
				if (retarr[0]=="-2010") errmsg=t['UpdateINSUAdmInfoFail'];
				alert(t['RegFail']+","+errmsg);
				return;
			}
		 
		}
	}
	alert(t["RegOK"]);	
		Clear_click();
	
	}catch(e){alert(e.message+","+e.name)}	

}
//挂号打印和预约打印在调用此打印函数的地方通过医院代码来区分   090312
function AppPrintOut(AppPrintData)
{
	try{
		if (AppPrintData="") return;
		var AppPrintArr=AppPrintData.split("^");
		var PapmiDr=AppPrintArr[0];
		var PapmiName=AppPrintArr[1];
		var PapmiNo=AppPrintArr[2];
		var PapmiDOB=AppPrintArr[3];
		var PamiSex=AppPrintArr[4];
		var QueueNo=AppPrintArr[5];
		var AppDate=AppPrintArr[6];
		var AppTime=AppPrintArr[7];
		var UserSS=AppPrintArr[8];
		var AppType=AppPrintArr[9];
		var ASDate=AppPrintArr[10];
		var objtbl=document.getElementById('tDHCOPAdm_Reg_MarkList');
	var rows=objtbl.rows.length;
	if (rows==2) {
		var ASRowId=GetColumnData('ASRowId',1);
		
		if (ASRowId==''){
			alert(t['NoAppRow']);
			return false;
		}
	}
	var PDlime=String.fromCharCode(2);
		var MyPara="PapmiDr"+PDlime+PapmiDr+"^"+"PapmiName"+PDlime+PapmiName+"^"+"PapmiNo"+PDlime+PapmiNo;
		var MyPara=MyPara+"^"+"PapmiDOB"+PDlime+PapmiDOB+"^"+"PamiSex"+PDlime+PamiSex+"^"+"QueueNo"+PDlime+QueueNo+"AppDate"+PDlime+AppDate;
		var MyPara=MyPara+"^"+"AppTime"+PDlime+AppTime+"^"+"UserSS"+PDlime+UserSS+"^"+"AppType"+PDlime+AppType+"ASDate"+PDlime+ASDate;
		var myobj=document.getElementById("ClsBillPrint");
		PrintFun(myobj,MyPara,"");	
	}
	catch(e){alert(e.message);}
}
function PrintOut(RegTblRow,PrintData) {
	try {
		if (PrintData=="") return;
		var PrintArr=PrintData.split("^");
		var AdmNo=PrintArr[0];
		var PatName=PrintArr[1];
		var RegDep=PrintArr[2];
		var DocDesc=PrintArr[3];
		var SessionType=PrintArr[4];
		var MarkDesc=DocDesc
		
		var AdmDateStr=PrintArr[5];
		var TimeRange=PrintArr[6];
		var AdmDateStr=AdmDateStr+" "+TimeRange;
		
		var SeqNo=PrintArr[7];
		var RoomNo=PrintArr[8];
		var RoomFloor=PrintArr[9];
		var UserCode=PrintArr[10];
		var RegDateYear=PrintArr[12];
		var RegDateMonth=PrintArr[13];
		var RegDateDay=PrintArr[14];
		var TransactionNo=PrintArr[15];
		
		var Total=PrintArr[16];
		var RegFee=PrintArr[17];
		var AppFee=PrintArr[18];
		var OtherFee=PrintArr[19];
		var ClinicGroup=PrintArr[20];
		var RegTime=PrintArr[21];
		var ExabMemo=PrintArr[23];
		var InsuPayCash=PrintArr[24];
		var InsuPayCount=PrintArr[25];
		var InsuPayFund=PrintArr[26];
		var InsuPayOverallPlanning=PrintArr[27];
		var InsuPayOther=PrintArr[28];
		var TotalRMBDX=PrintArr[29];
		var INVPRTNo=PrintArr[30];
		var CardNo=PrintArr[31];
		var Room=PrintArr[32];
		var AdmReason=PrintArr[33];
		var Regitems=PrintArr[34];
		var AccBalance=PrintArr[35];
		var OnlyRegFee=""; //PrintArr[36];
		var PatNo=PrintArr[36];
		var CheckFee=PrintArr[37];
		var HospName=PrintArr[38];
		var MyList="";
		for (var i=0;i<Regitems.split("!").length-1;i++){
			var tempBillStr=Regitems.split("!")[i];
			if (tempBillStr=="") continue;
			var tempBillDesc=tempBillStr.split("[")[0];
			var tempBillAmount=tempBillStr.split("[")[1];
			if (MyList=="") MyList=tempBillDesc+"   "+tempBillAmount;
			else  MyList = MyList + String.fromCharCode(2)+tempBillDesc+"   "+tempBillAmount;
		}
		if (HospitalCode=="SCSFY"){
			Room=Room+"就诊";
		}
		//病人自负比例的备注
		var ProportionNote="";
		var ProportionNote1="";
		var ProportionNote2="";
		if ((HospitalCode=="SHSDFYY")&&((InsuCardType=='0')||(InsuCardType=='1'))){
			InsuPayCash="现金支付:"+InsuPayCash;
			InsuPayCount="帐户支付:"+InsuPayCount;
			InsuPayOverallPlanning="统筹支付:"+InsuPayOverallPlanning;
			InsuPayOther="附加支付:"+InsuPayOther;
			ProportionNote="(现金支付中,"+RegFee+"元"+"不属于医保报销范围)";
			ProportionNote1="医疗记录册";
			ProportionNote2="当年帐户余额:  "+ThisYearAmt+"      历年帐户余额:  "+CalendarAmt;
			
		}else{
			InsuPayCash="";
			InsuPayCount="";
			InsuPayOverallPlanning="";
			InsuPayOther="";
			ProportionNote="本收据中,"+RegFee+"元"+"不属于医保报销范围";
			ProportionNote1="";
			ProportionNote2="";
		}
		
		var NeedCardFee=DHCC_GetElementData('NeedCardFee');
		var CardFee=DHCC_GetElementData('CardFee');
 		if (NeedCardFee==true){
 			var CardFee="工本费 "+parseFloat(CardFee)+"元";
 		}else{
 			var CardFee="";
 		}
 		
		RegTime=RegDateYear+"-"+RegDateMonth+"-"+RegDateDay+" "+RegTime
		var RegDate=RegDateYear+"-"+RegDateMonth+"-"+RegDateDay;
		AccAmount=DHCC_GetElementData('AccAmount');
		AccAmount=SaveNumbleFaxed(AccAmount);
		Total=SaveNumbleFaxed(Total);
		//if (GetPayModeCode()=="CPP"){
			var AccTotal=parseFloat(AccAmount)-parseFloat(Total);
		//}else {
    //  var AccTotal=parseFloat(AccAmount);
    //}

        //将AccTotal保留两位小数
    	//var AccTotal=GetAccAmount()
		AccTotal=SaveNumbleFaxed(AccTotal);
    //AccAmount=SaveNumbleFaxed(AccAmount);
	
		var DYOPMRN=DHCC_GetElementData('OPMRN'); //门诊病案号
		var DYIPMRN=DHCC_GetElementData('IPMRN'); //住院病案号

		var ObjCard=document.getElementById('CardNo'); 
		var cardnoprint=ObjCard.value;
		var objR=document.getElementById('TRRowId');
		var TRrowid=objR.value;
	
		var OBJ=document.getElementById('TimeRange');
		var TimeD=OBJ.value   
    //var Arrtime=GetArrTime()   取当前时间   
    var MRFee="",CRegFee="",CCheckFee=""
		if (AppFee!=0){AppFee="预约费:"+AppFee+"元"}else{AppFee=""}
		if (OtherFee!=0) {OtherFee=OtherFee+"元";MRFee="病历本费";}else{OtherFee=""}
		if (RegFee!=0){RegFee=RegFee+"元"}else{RegFee=""}
		if (Total!=0){Total=Total}else{Total=""}
    if (OnlyRegFee!=0){OnlyRegFee=OnlyRegFee+"元";CRegFee="挂号费";}else{OnlyRegFee=""}
    if (CheckFee!=0){CheckFee=CheckFee+"元";CCheckFee="诊查费";}else{CheckFee="";}	
		var PDlime=String.fromCharCode(2);
		var MyPara="AdmNo"+PDlime+AdmNo+"^"+"PatName"+PDlime+PatName+"^"+"TransactionNo"+PDlime+TransactionNo+"^"+"AccTotal"+PDlime+AccTotal+"^"+"AccAmount"+PDlime+AccAmount+"^"+"DYOPMRN"+PDlime+DYOPMRN+"^DYIPMRN"+PDlime+DYIPMRN;
		var MyPara=MyPara+"^"+"MarkDesc"+PDlime+MarkDesc+"^"+"AdmDate"+PDlime+AdmDateStr+"^"+"SeqNo"+PDlime+SeqNo+"^RegDep"+PDlime+RegDep;
		var MyPara=MyPara+"^"+"RoomFloor"+PDlime+RoomFloor+"^"+"UserCode"+PDlime+UserCode;
		var MyPara=MyPara+"^"+"RegDateYear"+PDlime+RegDateYear+"^RegDateMonth"+PDlime+RegDateMonth+"^RegDateDay"+PDlime+RegDateDay;
		var MyPara=MyPara+"^"+"Total"+PDlime+Total+"^RegFee"+PDlime+RegFee+"^AppFee"+PDlime+AppFee+"^OtherFee"+PDlime+OtherFee+"^CardFee"+PDlime+CardFee;
		var MyPara=MyPara+"^"+"RoomNo"+PDlime+RoomNo+"^"+"ClinicGroup"+PDlime+ClinicGroup+"^"+"SessionType"+PDlime+SessionType+"^"+"TimeD"+PDlime+TimeD+"^"+"RegTime"+PDlime+RegTime+"^"+"cardnoprint"+PDlime+cardnoprint;
		var MyPara=MyPara+"^"+"ExabMemo"+PDlime+ExabMemo;
		var MyPara=MyPara+"^"+"InsuPayCash"+PDlime+InsuPayCash+"^"+"InsuPayCount"+PDlime+InsuPayCount+"^"+"InsuPayFund"+PDlime+InsuPayFund+"^"+"InsuPayOverallPlanning"+PDlime+InsuPayOverallPlanning+"^"+"InsuPayOther"+PDlime+InsuPayOther;
		var MyPara=MyPara+"^"+"ProportionNote1"+PDlime+ProportionNote1+"^"+"ProportionNote2"+PDlime+ProportionNote2;
		var MyPara=MyPara+"^"+"TotalRMBDX"+PDlime+TotalRMBDX+"^"+"INVPRTNo"+PDlime+INVPRTNo+"^"+"CardNo"+PDlime+CardNo+"^"+"Room"+PDlime+Room;
		var MyPara=MyPara+"^"+"AdmReason"+PDlime+AdmReason+"^"+"RegDate"+PDlime+RegDate+"^"+"CRegFee"+PDlime+CRegFee+"^"+"OnlyRegFee"+PDlime+OnlyRegFee+"^"+"CCheckFee"+PDlime+CCheckFee+"^"+"CheckFee"+PDlime+CheckFee+"^"+"MRFee"+PDlime+MRFee;
		var MyPara=MyPara+"^"+"PatNo"+PDlime+PatNo;       //打印登记号
		var MyPara=MyPara+"^"+"HospName"+PDlime+HospName;
		//alert(MyPara)
		var myobj=document.getElementById("ClsBillPrint");
		PrintFun(myobj,MyPara,"");
		//打印收费项目明细列表MyList
		//PrintFun(myobj,MyPara,MyList);
		
		DHCC_SetElementData('AccAmount',AccTotal);	
	} catch(e) {alert(e.message)};
}
function PrintFun(PObj,inpara,inlist){
	////DHCPrtComm.js
	try{
		var mystr="";
		for (var i= 0; i<PrtAryData.length;i++){
			mystr=mystr + PrtAryData[i];
		}
		inpara=DHCP_TextEncoder(inpara)
		inlist=DHCP_TextEncoder(inlist)
		var docobj=new ActiveXObject("MSXML2.DOMdocument.4.0");
		docobj.async = false;    //close
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMdocument40)			
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}
}
function SaveNumbleFaxed(str)
{
	var len,StrTemp;	
	if((str=="")||(!str)) return 0;
	if(parseInt(str)==str){
		str=str+".00";
		}else{
		StrTemp=str.toString().split(".")[1];
		len=StrTemp.length;
		if(len==1){
			str=str+"0";
			}
		else{}
	}
	
	return str;
}

function AppFlagChangeHandler(e){
	var ret=DHCC_GetElementData('AppFlag');
	if (ret){
		var DefaultAppDate=DHCC_GetElementData('DefaultAppDate');
		DHCC_SetElementData("AppDate",DefaultAppDate);
	}else{
		DHCC_SetElementData('AppDate','');
	}
	var PatientID=DHCC_GetElementData('PatientID');
	if (PatientID!="") {
		var obj=document.getElementById('AppFlag')
		//DeptListDblClickHandler(obj);;
	}	

}



 document.body.onload = BodyLoadHandler;
 document.body.onunload = documentUnloadHandler;
function documentUnloadHandler(e){
	
}
function GetArrTime()
{
	var Dateprint=new Date();
	var s="";
	s=s+Dateprint.getYear()+"-";
	s=s+Dateprint.getMonth()+"-";
	s=s+Dateprint.getDate()+" ";
	s=s+Dateprint.getHours()+":";
	s=s+Dateprint.getMinutes() +":";
	s=s+Dateprint.getSeconds();
	return(s); 
}
function BodyLoadHandler() {

	//得到挂号条打印的参数
	
	//读卡
	var obj=document.getElementById('ReadCard');
	if (obj) obj.onclick=ReadCardClickHandler;
 
	var obj=document.getElementById('CardNo');
	if (obj) obj.onkeydown = CardNoKeydownHandler;
	
	//var	obj=document.getElementById('DeptList');
	//if (obj) obj.ondblclick = DeptListDblClickHandler;
	//if (obj) obj.onclick = DeptListClickHandler;
	//if (obj) obj.onchange = DeptListDblClickHandler;
	
	if (document.getElementById("Name")){document.getElementById("Name").readOnly = true;}
	document.getElementById("Sex").readOnly = true;
	document.getElementById("Age").readOnly = true;
	if (document.getElementById("ReceiptNo")){document.getElementById("ReceiptNo").readOnly = true;}
	
	if (document.getElementById("BillAmount")){document.getElementById("BillAmount").readOnly = true;}
	if (document.getElementById("ReturnAmount")){document.getElementById("ReturnAmount").readOnly = true;}
	
	//guorongyong 2008-03-03
	var obj=document.getElementById('RegExp');
	if (obj) obj.onclick=RegExp_Click;
	var obj=document.getElementById('tDHCOPAdm_Reg_MarkList');	
	if (obj&&(obj.rows.length==2))
	{
	obj.ondblclick = MarkTableDblClickHandler;

	}

	var obj=document.getElementById('Sex');
	if (obj) obj.onkeydown = DHCC_Nextfoucs;
	var obj=document.getElementById('Age');
	if (obj) obj.onkeydown = DHCC_Nextfoucs;
	var obj=document.getElementById('Name');
	if (obj) obj.onkeydown = DHCC_Nextfoucs;

	var obj=document.getElementById("GetAmount");
	if (obj) {
		obj.onkeydown = GetAmountChangeHandler;
		obj.onkeypress=GetAmountkeypresshandler;
		obj.onblur=ReCalculateAmount;
	}

	var obj=document.getElementById('Update');
	if (obj) obj.onclick=UpdateClickHandler;

	var obj=document.getElementById('Appoint');
	if (obj) obj.onclick=AppointClickHandler;

	var obj=document.getElementById('AppointNormal');
	if (obj) obj.onclick=AppointNormalClickHandler;

  var obj=document.getElementById('OPAppTel');
	if (obj) obj.onclick=AppointTelClickHandler;
	
	var obj=document.getElementById('Clear');
	if (obj) obj.onclick=Clear_click;

	var obj=document.getElementById('Query');
	if (obj) obj.onclick=QueryClickHandler;

	var obj=document.getElementById('RegQuery');
	if (obj) obj.onclick=RegQuery_click;

	var obj=document.getElementById('PatInfo');
	if (obj) obj.onclick=PatInfo_Click;

	var obj=document.getElementById('FindPat');
	if (obj) obj.onclick=FindPat_click;
	var obj=document.getElementById('AppFlag');
	var AppFlag=DHCC_GetElementData('AppFlag');

	if (obj.value==0){
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAdmRegPrint");
	} 
	if (obj.value==1){
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAppRegPrint");
	}
	
  EncryptObj=new DHCBodyLoadInitEncrypt();
	EncryptObj.GetAllEncrypt("web.DHCBodyLoadInitEncrypt.GetAllEncryptStr");
	
	var obj=document.getElementById('AppDate');
	if (obj) obj.onchange=AppDateChangeHandler;
	if (obj) obj.onkeydown=DHCC_Nextfoucs;
	//if (obj) obj.onblur=AppDate_OnBlur;
	if (obj) obj.onfocus=AppDate_OnFocus;
	
	var obj=document.getElementById('SeqNo');
	if (obj) obj.onkeydown=SeqNoKeydownHandler;
  
  var obj=document.getElementById('MedicalBook');
	if (obj) obj.onclick=MedicalBookCheck;
	var obj=document.getElementById("NeedCardFee");
	if (obj) obj.onclick=NeedCardFeeCheck;
	
	var obj=document.getElementById('RoomCode');
	if (obj) obj.onkeydown=RoomCodeKeydownHandler;
	
	/*  //对病历本是否收取的处理
	var ObjtblMark=document.getElementById("tDHCOPAdm_Reg_MarkList");
	if (ObjtblMark) ObjtblMark.onkeydown=ObjtblMarkKeydownHandler;
	*/
	var ReceiptStr=DHCC_GetElementData('ReceiptStr');
	var arr=ReceiptStr.split('^');
	DHCC_SetElementData('ReceiptCount',arr[0]);
	DHCC_SetElementData('ReceiptSum',arr[1]);
	
	NeedReceiptNoMsg=CheckNeedReceiptNoMsg();

	GetReceiptNo();

	ReadPayMode();
	ReadCardType();
	
	//DHCC_SetListStyle("CardType",false);
	//卡类型
	var obj=document.getElementById('CardType');
	//因为dhtmlXComboFromSelect要判断isDefualt属性,
	if (obj) obj.setAttribute("isDefualt","true");
	combo_CardType=dhtmlXComboFromSelect("CardType");
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle=combo_CardTypeKeydownHandler;
	}
	
	combo_CardTypeKeydownHandler();
	
	
	//支付方式
	var obj=document.getElementById('PayMode');
	//因为dhtmlXComboFromSelect要判断isDefualt属性,
	if (obj) obj.setAttribute("isDefualt","true");
	
	combo_PayMode=dhtmlXComboFromSelect("PayMode");
	if (combo_PayMode) {
		combo_PayMode.enableFilteringMode(true);
		combo_PayMode.selectHandle=combo_PayModeKeydownHandler;
	}
	/*
	var obj=document.getElementById('PayMode');
	if(obj){
		obj.multiple=false;;
		obj.size=1;
		//obj.onclick=combo_PayModeKeydownHandler;
	}
	*/
	/*
	var encmeth=DHCC_GetElementData('GetResDocEncrypt');
	AllDocStr=cspRunServerMethod(encmeth,"");
	if (AllDocStr!=""){
		var Arr=DHCC_StrToArray(AllDocStr);
		if (combo_MarkCode) combo_MarkCode.addOption(Arr);
	}
*/
	//时段
	var TimeRangeStr=DHCC_GetElementData('TimeRangeStr');
	combo_TimeRange=dhtmlXComboFromStr("TimeRange",TimeRangeStr);
	combo_TimeRange.enableFilteringMode(true);
	combo_TimeRange.selectHandle=combo_TimeRangeKeydownhandler;
	combo_TimeRange.attachEvent("onKeyPressed",combo_TimeRangeKeyenterhandler)
	//combo_TimeRange.keyenterHandle=combo_TimeRangeKeyenterhandler;
	if (AppFlag==0){
		//combo_TimeRange.selectOption(0,true);
		//combo_TimeRange.setComboText(combo_TimeRange.optionsArr[0].text);
		SetDefaultTimeRange();
	}
	var TRRowId=combo_TimeRange.getSelectedValue();
	DHCC_SetElementData('TRRowId',TRRowId);
	//websys_setfocus('TabDepDesc');


	
	//科室	
	var DeptStr=DHCC_GetElementData('DeptStr');
	if(DeptStr!="") 
	{   var DepArr=DeptStr.split("^");
		for (var i=0; i<DepArr.length; i++){
		  var DepID=DepArr[i].split(String.fromCharCode(1))[0];
		  var DepDesc=DepArr[i].split(String.fromCharCode(1))[1];
		  var Obj=document.getElementById('DeptList');
			if (Obj){AddItemSingle(Obj,DepID,DepDesc);}
		}
	}
	var Obj=document.getElementById('DeptList');
	if (Obj){
	  Obj.onchange =DeptListChange;}
	  
	 var Obj=document.getElementById('FindDept');
	if (Obj){
	  //Obj.onchange =FindDeptChange;
	  Obj.onkeyup =FindDeptChange;
	 }
	 
	/*
	combo_DeptList=dhtmlXComboFromStr("DeptList",DeptStr);
	combo_DeptList.enableFilteringMode(true);
	combo_DeptList.selectHandle=combo_DeptListKeydownhandler;
	//combo_DeptList.keyenterHandle=combo_DeptListKeyenterhandler;
	combo_DeptList.attachEvent("onKeyPressed",combo_DeptListKeyenterhandler);
	
  if(DefaultDepFlag=="Y") 
  {	
  	combo_DeptList.setComboValue(session['LOGON.CTLOCID']);
  	combo_DeptListKeydownhandler();
  }*/
  
	SetDefaultAppDate();
	
	HospitalCode=DHCC_GetElementData('HospitalCode');
	if (HospitalCode=="HXYY"){CommonCardNo="000000088888888";}
	
	DHCC_SetElementData('CardNo',CommonCardNo)

	//websys_setfocus('CardNo');
	//费别
	DHCC_SetListStyle("BillType",false);

	//特病类别
	if (document.getElementById('DiagnosCat')){
		var DiagnosCatStr=DHCC_GetElementData('DiagnosCatStr');
		combo_DiagnosCat=dhtmlXComboFromStr("DiagnosCat",DiagnosCatStr);
		combo_DiagnosCat.enableFilteringMode(true);
	}

	//guorongyong 2008-03-12
	if (document.all.DeptList){
		document.all.DeptList.style.imeMode = "disabled";
	}
	if (document.all.MarkCode){
		document.all.MarkCode.style.imeMode = "disabled";
	}
	var obj=document.getElementById('ReadCard');
	if (obj){ if(!obj.disabled) obj.focus();}
	
	//特殊处理,修改表格描述,因为这里和挂号界面不一样,是使用一个表格展示信息,所以不需要在描述上带上午和下午
	if (parent && parent.frames["DHCOPAdm.Reg.MarkList"]) {
		var tdTagAry=parent.frames["DHCOPAdm.Reg.MarkList"].document.getElementsByTagName("td");
		for (var j=0;j<tdTagAry.length;j++) {
			//console.log(tdTagAry[j].innerText)
			if ((tdTagAry[j].innerText+'').indexOf("排班列表")!=-1) {
				tdTagAry[j].innerText="排班列表";
			}
		}
	}
	document.onkeydown=Doc_OnKeyDown;
}
combo_DiagnosCat=null;

//by guorongyong 2008-03-03
function YBTypeCheck()
{
	//add by zhouzq 2010.09.08
	if (HospitalCode!='BJDTYY') return;

	var AppFlag=DHCC_GetElementData("AppFlag");
	if(AppFlag==1)return;
	
	var obj=document.getElementById('YBType');
	if(obj)var YBtypeV=obj.value;
	var obj=document.getElementById('PatYBCode');
	if(obj)var PatybV=obj.value;
	
	if((YBtypeV=="医保")||(YBtypeV=="医保特病")){
		if((PatybV=="")||(PatybV=="99999999999S")||(PatybV=="99999999999s"))alert("此为医保病人,但医保号为空或不正确!");
	}else{
		if(PatybV!="")alert("病人类型与医保号不符!");
	}

}


function RegExp_Click()
{
	
	//Clear_click();
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCCardPatInfoRegExp";
	if(typeof websys_writeMWToken=='function') lnk=websys_writeMWToken(lnk);
	win=open(lnk,"SwithOPReg","status=1,top=150,left=150,width=1200,height=650")
}
function CheckNeedReceiptNoMsg(){
	var obj=document.getElementById('Update');
	if (obj) {return true}else{return false}
}
function SetDefaultAppDate(){
	var AppFlag=DHCC_GetElementData("AppFlag");
	var DefaultAppDate=DHCC_GetElementData("DefaultAppDate");
	if ((DefaultAppDate!="")&&(AppFlag==1)){
		var AppDate=DefaultAppDate.substring(0,8);
		DHCC_SetElementData('AppDate',AppDate)
	}	
}
function AppDate_OnFocus(e){
	var obj=document.getElementById('AppDate');
	var rng = obj.createTextRange(); 
	rng.moveStart("character",8);     
	rng.collapse(true);      
	rng.select();   	
	//obj.select(0);
}

function AppDate_OnBlur(){
	var obj=document.getElementById("AppDate");
	var AppDate=DHCC_GetElementData("AppDate");

	var myrtn=DHCC_IsValidDate(obj)
	if (myrtn==0){
		obj.className='clsInvalid';
		var rng = obj.createTextRange(); 
		rng.moveStart("character",8);     
		rng.collapse(true);
		rng.select();  
		return websys_cancel();
	}else{
		obj.className='clsvalid';
	}
}

function GetAppDate() {
	var obj=document.getElementById('AppDate');
	if (obj){
		if ((obj)&&(obj.className=="clsInvalid")){
			//alert(t['WrongDateFormat']);
			//return false
			return 0;
		}
		var AppDate=DHCC_GetElementData('AppDate');
		if ((String(AppDate).length==8)&&(AppDate.indexOf('-')!=-1)){
			return 0
		}
		if ((String(AppDate).length==4)&&(AppDate.indexOf('-')==-1)){
			return 0
		}
		return AppDate;
	}
	return ""
}
function AppDateChangeHandler(e){
	var obj=window.event.srcElement;
	var myrtn=DHCC_IsValidDate(obj);
	if (myrtn==0){
		obj.className='clsInvalid';
		//websys_setfocus("AppDate");
		//return websys_cancel();
	}else{
		obj.className='clsValid';
		var encmeth=DHCC_GetElementData('ConvertToWeekMethod');
		if (encmeth!=""){
			var WeekStr=cspRunServerMethod(encmeth,obj.value);
			DHCC_SetElementData('WeekDesc',WeekStr);
		}		
	}
	var PatientID=DHCC_GetElementData('PatientID');
	//if (PatientID!="") DeptListDblClickHandler(obj);;

}


function combo_TimeRangeKeydownhandler(){
		var TRRowId=combo_TimeRange.getSelectedValue();
		//var TRDesc=combo_TimeRange.getSelectedText();
		DHCC_SetElementData('TRRowId',TRRowId);
		//websys_nexttab(combo_TimeRange.tabIndex);
		//websys_setfocus('DeptList');
		//if (combo_DeptList) combo_DeptList.DOMelem_input.focus();
		if (DHCC_GetElementData('DepRowId')!="") DeptListDblClickHandler();
		
		return false;
}
function combo_TimeRangeKeyenterhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==13) {
		//websys_nexttab(combo_TimeRange.tabIndex);
		
		combo_TimeRange.DOMelem_input.focus();
		//combo_TimeRange.setfouce('DeptList');
		return false;
	}
}
function DeptListChange(){
	var tmp=document.getElementById('DeptList');
	var selItem=tmp.options[tmp.selectedIndex];	
		if (selItem) 
		{	DHCC_SetElementData('DepRowId',selItem.value);
			DeptListDblClickHandler();
		}
	}
var TimeOutDept;
function FindDeptChange(){
	var DeptStr=DHCC_GetElementData('FindDept');
	var tmp=document.getElementById('DeptList');
	if(DeptStr==""){
		DHCReg_ClearTable(parent.frames["DHCOPAdm.Reg.MarkList"],"tDHCOPAdm_Reg_MarkList");
		tmp.selectedIndex=-1
		return 	
	}
	if(TimeOutDept){
		clearTimeout(TimeOutDept)    
	}
	TimeOutName=setTimeout("FindDept()",500)
  
}	
function FindDept(){
	var DeptStr=DHCC_GetElementData('FindDept');	
	DeptStr=DeptStr.toUpperCase()
	//alert(DeptStr)
	var tmp=document.getElementById('DeptList');
	var len=tmp.length
	var DepId=""
	for(var i=0;i<len;i++){
		var selItem=tmp.options[i];		
		var selText=selItem.text
		var selTextArr=selText.split("-")
		var selText=selTextArr[1].toUpperCase()
		if(selText.indexOf(DeptStr)==0){
			tmp.selectedIndex=i
			DHCC_SetElementData('DepRowId',selItem.value);
			DeptListDblClickHandler();	
			DepId=selItem.value
			break;
		}
	}
	if(DepId==""){
		tmp.selectedIndex=-1
		DHCReg_ClearTable(parent.frames["DHCOPAdm.Reg.MarkList"],"tDHCOPAdm_Reg_MarkList");
	}
}	

function combo_DeptListKeydownhandler(){
	DHCC_SetElementData('DepRowId',DepRowId);
	
         
		var ret=DeptListDblClickHandler();
		//if (ret){websys_nexttab(obj.tabIndex);}
	    //websys_setfocus('tDHCOPAdm_Reg_MarkList');
		//websys_setfocus('SeqNo');
		//return websys_cancel();
	
	}
	//var ret=DeptListDblClickHandler(obj);
	//if (ret){websys_nexttab(obj.tabIndex);}


function combo_DeptListKeyenterhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==13) {
		combo_DeptListKeydownhandler();
	}
}
function TimeRangeKeyPressHandler(e){
	DHCC_Nextfoucs();
}
function GetReceiptNo(){
	var ReceiptNoObj=document.getElementById("ReceiptNo");
	if ((NeedReceiptNoMsg==true)&&ReceiptNoObj) {
		var encmeth=DHCC_GetElementData('GetreceipNO');
		var p1=session['LOGON.USERID']+"^"+"^"+session['LOGON.GROUPID']+"^"+"R"
		if (encmeth!=""){
			var rtn=cspRunServerMethod(encmeth,'SetReceipNO','',p1)
			if (rtn!='0') {
				alert(t['InvalidReceiptNo']);
				return
			}
		}
	}
}
function isNumber(objStr){
 strRef = "+1234567890";
 for (i=0;i<objStr.length;i++) {
  tempChar= objStr.substring(i,i+1);
  if (strRef.indexOf(tempChar,0)==-1) {return false;}
 }
 return true;
}



function SetReceipNO(value) {
	var myary=value.split("^");
	var ls_ReceipNo=myary[0];
	var Sur_ReceipNo=myary[2];   //票据剩余张数
	DHCC_SetElementData('SurplusReceiptNo',Sur_ReceipNo);
	DHCC_SetElementData('ReceiptNo',ls_ReceipNo);
	
	//DHCWebD_SetObjValueA("INVLeftNum",myary[2]);
	///如果张数小于最小提示额change the Txt Color
	if (myary[1]!="0"){	obj.className='clsInvalid';}
}

function FindPat_click(){
  Clear_click();
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCCardSearch";
	if(typeof websys_writeMWToken=='function') lnk=websys_writeMWToken(lnk);
	win=open(lnk,"FindPatReg","top=150,left=150,width=1000,height=600,status=yes,scrollbars=yes")
}

function CacelReg_click(){
	Clear_click();
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPReturn";
	win=websys_createWindow(lnk,"CacelReg","top=150,left=50,width=1500,height=500,status=yes,scrollbars=yes")
	}
function RegQuery_click(){

	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPDro";
	if(typeof websys_writeMWToken=='function') lnk=websys_writeMWToken(lnk);
	win=open(lnk,"RegQueryy","top=10,left=50,width=900,height=500");
}

function SwitchReg_Click(){
	Clear_click();
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPReturn";
	if(typeof websys_writeMWToken=='function') lnk=websys_writeMWToken(lnk);
	win=open(lnk,"SwitchReg","top=150,left=150,width=700,height=400")
}

function PatInfo_Click(){
	Clear_click();
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCPatient";
	if(typeof websys_writeMWToken=='function') lnk=websys_writeMWToken(lnk);
	win=open(lnk,"QueryReg","top=50,left=150,width=1000,height=700,status=yes,scrollbars=yes")
}

function ReadPayMode(){
	DHCC_ClearList("PayMode");
	var encmeth=DHCWebD_GetObjValue("PayModeEncrypt");
	var mygLoc=session['LOGON.GROUPID'];
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","PayMode",mygLoc);
	}
}

function ReadCardType(){
	DHCC_ClearList("CardType");
	var encmeth=DHCC_GetElementData("CardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardType");
	}
}
//ALT-* PGUP PGDN
function documentkeydown(e) {
	var keycode;
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	//alert(keycode)
	if (keycode==115){
		var obj=document.getElementById('ReadCard');
		if (obj){
			ReadCardClickHandler();
		}
	}else if (keycode==120) {
		var obj=document.getElementById('Update');
		if (obj) {
			UpdateClickHandler();
		}else{
			var obj=document.getElementById('Appoint');
			if (obj) {
				AppointClickHandler();
			}else{
				var obj=document.getElementById('AppointNormal');
				if (obj) {
					AppointNormalClickHandler()
				}else{
					AppointTelClickHandler();
				}
			}
		}
	}else if(keycode==118) {
		Clear_click();
	}else if(keycode==121) {
		CacelReg_click();
	}else if(keycode==119) {
		//QueryClickHandler();
		FindPat_click();
	}else if(keycode==117){
		PatInfo_Click();
  }else if(keycode==123){
		RegExp_Click();
	}else{
		websys_sckey(e)
	}
}
///默认为取消,重载DOM里的confirm   
///window.confirm=function(str)
function DHCC_Confirm(str){
	//execScript('s   =   msgbox("'+str+'",257,"标题")','vbscript')   
	str=str.replace(/\'/g, "'&chr(39)&'").replace(/\r\n|\n|\r/g,"'&VBCrLf&'");
	execScript("n   =   msgbox('"+str+"',257,'确认')","vbscript");
	return(n==1);
}
function PrintMedicalBook(AdmNo){
	//alert(AdmNo);
  MyPara="";
  var myobj=document.getElementById("ClsBillPrint");
	DHCP_GetXMLConfig("InvPrintEncrypt","MedicalBook");
	var PrintMedicalbencmeth=document.getElementById('PrintMedicalBookMethod').value;
	      if (PrintMedicalbencmeth!=""){
		        rtn=cspRunServerMethod(PrintMedicalbencmeth,AdmNo);
					  }
	if (rtn!=''){
		//alert(rtn)
		rtnarry=rtn.split('^');
		PatientName=rtnarry[2];
		PatientSex=rtnarry[3];
		AgeDesc=rtnarry[4];
		PatientNo=rtnarry[1];
		PatientBirthday=rtnarry[5];
		PatientYear=PatientBirthday.split('-')[0];
		Patientmonth=PatientBirthday.split('-')[1];
		ALLERGY=rtnarry[25];
		PatientMarital=rtnarry[16];
		Tel=rtnarry[24];
		PatientComAdd=rtnarry[10];
		MyPara=MyPara+"PatientName"+String.fromCharCode(2)+PatientName;
		MyPara=MyPara+"^PatientSex"+String.fromCharCode(2)+PatientSex;
		MyPara=MyPara+"^AgeDesc"+String.fromCharCode(2)+AgeDesc;
		MyPara=MyPara+"^PatientYear"+String.fromCharCode(2)+PatientYear;
		MyPara=MyPara+"^Patientmonth"+String.fromCharCode(2)+Patientmonth;
		MyPara=MyPara+"^ALLERGY"+String.fromCharCode(2)+ALLERGY;
		MyPara=MyPara+"^PatientMarital"+String.fromCharCode(2)+PatientMarital;
		MyPara=MyPara+"^Tel"+String.fromCharCode(2)+Tel;
		MyPara=MyPara+"^PatientComAdd"+String.fromCharCode(2)+PatientComAdd;
		//PrintFun(myobj,MyPara,"")
   	    //WKZ 080225
   	    var DHCOPPrint=new ActiveXObject("DHCOP.DHCPrint");
        //DHCPrint.OutStr="430$970$医大一院^430$630$女^430$350$1975       03^500$580$未婚^500$300$62662348^580$950$沈阳市和平区"
        DHCOPPrint.OutStr="430$970$"+PatientName+"^430$630$"+PatientSex+"^430$350$"+PatientYear+"        "+Patientmonth+"^500$580$"+PatientMarital+"^500$940$"+ALLERGY+"^500$300$"+Tel+"^580$950$"+PatientComAdd+"^350$500$"+'登记号:'+PatientNo       
        DHCOPPrint.PrintStr()
		
		}
}
function validate(sDouble){
  var re = /^\d+(?=\.{0,1}\d+$|$)/
  return re.test(sDouble)
}

function isDigit()
{
  if(((event.keyCode >= 48) && (event.keyCode <= 57))==false){return}
  //return ((event.keyCode >= 48) && (event.keyCode <= 57));
}
function MedicalBookCheck(){
  var MRFee=DHCC_GetElementData('MRNoteFee');
	objvalue=DHCC_GetElementData('MedicalBook');
	if (objvalue==true){
		var MedicalBookVal=DHCC_GetElementData('MedicalBook');
		var BillAmount=DHCC_GetElementData('BillAmount');
		if (BillAmount==""){BillAmount=0}
 	  BillAmount=parseFloat(BillAmount)+parseFloat(MRFee);
 	  DHCC_SetElementData("BillAmount",BillAmount,"0.00");
	}else if (objvalue==false){
		var MedicalBookVal=DHCC_GetElementData('MedicalBook');
		var BillAmount=DHCC_GetElementData('BillAmount');
		if (BillAmount==""){BillAmount=0}
 	  BillAmount=parseFloat(BillAmount)-parseFloat(MRFee);
 	  DHCC_SetElementData("BillAmount",BillAmount,"0.00");
		
	}
}
function NeedCardFeeCheck(){
  var CardFee=DHCC_GetElementData('CardFee');
	objvalue=DHCC_GetElementData('NeedCardFee');
	if (objvalue==true){
		var MedicalBookVal=DHCC_GetElementData('NeedCardFee');
		var BillAmount=DHCC_GetElementData('BillAmount');
		if (BillAmount==""){BillAmount=0}
 	  BillAmount=parseFloat(BillAmount)+parseFloat(CardFee);
 	  DHCC_SetElementData("BillAmount",BillAmount,"0.00");
	}else if (objvalue==false){
		var MedicalBookVal=DHCC_GetElementData('NeedCardFee');
		var BillAmount=DHCC_GetElementData('BillAmount');
		if (BillAmount==""){BillAmount=0}
 	  BillAmount=parseFloat(BillAmount)-parseFloat(CardFee);
 	  DHCC_SetElementData("BillAmount",BillAmount,"0.00");
		
	}
}
function PrintAppoint(RBARowId)
{
	try{
		var CardNo=DHCC_GetElementData("CardNo");
		var GetAppPrintDataMethod=DHCC_GetElementData('GetAppPrintData');
		if (GetAppPrintDataMethod=="") return;
		var PrintDataStr=cspRunServerMethod(GetAppPrintDataMethod,RBARowId,CardNo);
		if (PrintDataStr=="") return;
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAppointPrint");
		var myobj=document.getElementById("ClsBillPrint");
		PrintFun(myobj,PrintDataStr,"");
	}catch(e){
		alert(e.message);
	}
}

function ReturnRecp_click(){
	Clear_click();
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPReturn";
	win=websys_createWindow(lnk,"ReturnRecp","top=150,left=50,width=900,height=500,status=yes,scrollbars=yes")
}
function AddRowNew(objtbl) {
	//原来用的增加行的函数有问题?槿绻?表格中有多行?凵境?前面一行后?墼傩录尤胍恍楔墼蛐录拥囊恍械?D会跟别的行有重复
	var row=objtbl.rows.length;
	var objlastrow=objtbl.rows[row-1];
	//make sure objtbl is the tbody element
	objtbl=tk_getTBody(objlastrow);
	var objnewrow=objlastrow.cloneNode(true);
	var rowitems=objnewrow.all; //IE only
	if (!rowitems) rowitems=objnewrow.getElementsByTagName("*"); //N6
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			//arrId[arrId.length-1]=row;
			arrId[arrId.length-1]=parseInt(arrId[arrId.length-1])+1;
			rowitems[j].id=arrId.join("z");
			rowitems[j].name=arrId.join("z");
			rowitems[j].value="";
		}
	}
	objnewrow=objtbl.appendChild(objnewrow);
	{if ((objnewrow.rowIndex)%2==0) {objnewrow.className="RowEven";} else {objnewrow.className="RowOdd";}}
}
function GetRow(Rowindex){
	var objtbl=document.getElementById('tDHCOPAdm_Reg');
	var RowObj=objtbl.rows[Rowindex];

	var rowitems=RowObj.all;
	if (!rowitems) rowitems=RowObj.getElementsByTagName("LABEL");
	for (var j=0;j<rowitems.length;j++) {
		if (rowitems[j].id) {
			var Id=rowitems[j].id;
			var arrId=Id.split("z");
			var Row=arrId[arrId.length-1];
		}
	}
	return Row;
}
function Trim(str)
{
	return str.replace(/[\t\n\r ]/g, "");
}
function DHCReg_ClearTable(obj,TableName){
	if(obj)
	{
	var objtbl=obj.document.getElementById(TableName);
	if (objtbl){
		var rows=objtbl.rows.length;
		var lastrowindex=rows-1;
		
		for (var j=1;j<lastrowindex;j++) {objtbl.deleteRow(1);}
		var objtbody=tk_getTBody(objtbl.rows[1]);
		DHCC_ClearTableRow(objtbl.rows[1]);
		tk_ResetRowItems(objtbody);
	//alert(objtbl.innerHTML)
	}
}
}
function SetColumnData(ColName,Row,Val){
	var obj=parent.frames["DHCOPAdm.Reg.MarkList"];
	if(obj)
	{
	var CellObj=obj.document.getElementById(ColName+"z"+Row);
	if (CellObj){
	  //alert(CellObj.id+"^"+CellObj.tagName);
	  if (CellObj.tagName=='LABEL'){
	  	CellObj.innerText=Val;
	  }else{
			if (CellObj.type=="checkbox"){
				CellObj.checked=Val;
			}else{
				CellObj.value=Val;
			}
		}
	}
  }
}
function GetColumnData(ColName,Row){
	var obj=parent.frames["DHCOPAdm.Reg.MarkList"];
	if(obj)
	{
	  var CellObj=obj.document.getElementById(ColName+"z"+Row);
	  //alert(CellObj.id+"^"+CellObj.tagName+"^"+CellObj.value);
	 if (CellObj){ 
		if (CellObj.tagName=='LABEL'){
			return CellObj.innerText;
		}else if (CellObj.type=="checkbox"){
			return CellObj.checked;
		}else
		{return CellObj.value;}
	 }
	}
	return "";
}
function Doc_OnKeyDown() {
	var eSrc=websys_getSrcElement(event);
	var key=websys_getKey(eSrc);
	///115 F4 
	///118 F7
	///120 F9
	//alert(event.keyCode);
	if (event.keyCode==115){
		document.getElementById("ReadCard").click()
	}
	
	if (event.keyCode==118){
		document.getElementById("Clear").click()
	}
	if (event.keyCode==120){
		document.getElementById("Update").click()
	}
	DHCWeb_EStopSpaceKey();
}