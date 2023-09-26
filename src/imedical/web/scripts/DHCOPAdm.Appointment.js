// DHCOPAdm.Appointment.js
document.body.onload = BodyLoadHandler;
document.body.onunload = DocumentUnloadHandler;
var SelectedRow=0;
var m_CCMRowID="";
var combo_TimeRange;
function DocumentUnloadHandler(e){
}
function BodyLoadHandler() {
	var vRBASID="";
	var obj=document.getElementById('vRBASID');
	if (obj) vRBASID=obj.value;
	//得到挂号条打印的参数
	DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAdmRegPrint");
	
	//读卡
	var obj=document.getElementById('ReadCard');
	if (obj) obj.onclick=ReadCardClickHandler;

	var obj=document.getElementById('CardNo');
	if (obj) obj.onkeydown = CardNoKeydownHandler;
	
	var	obj=document.getElementById('AdmDep');
	if (obj) obj.onkeydown = AdmDepLookupHandler;
	var	obj=document.getElementById('AdmDoc');
	if (obj) obj.onkeydown = AdmDocLookupHandler;

	var obj=document.getElementById('Clear');
	if (obj) obj.onclick=Clear_Click;

	var obj=document.getElementById('Find');
	if (obj) obj.onclick=FindClickHandler;
	var obj=document.getElementById('Cancel');
    if (vRBASID!=""){
	    obj.style.display='none';
	}else{		
	    if (obj) obj.onclick=CancelClickHandler;
	}    
	var obj=document.getElementById('Update');
	if (obj) obj.onclick=UpdateClickHandler;

	var obj=document.getElementById('NoArrive');
	if (obj) obj.onchange=NoArriveChangeHandler;

	var obj=document.getElementById('ChangeAppoint');
	if (obj) obj.onclick = ChangeAppointClickHandler;
	
	var obj=document.getElementById('ChangeCardNo');
	if (obj) obj.onkeydown = ChangeCardNoKeydownHandler;
	
	var obj=document.getElementById('RePrintApp');
	if (obj) obj.onclick = RePrintAppClickHandler;
	
	var AppStatus=DHCC_GetElementData('AppStatus');
	if (AppStatus=='A'){
		DHCC_SetElementData('NoArrive',false);
	}else{
		if (vRBASID!=""){
			DHCC_SetElementData('NoArrive',false);
		}else{
			DHCC_SetElementData('NoArrive',true);
		}
	}

	ReadCardType();
	var obj=document.getElementById('CardType');
	//因为dhtmlXComboFromSelect要判断isDefualt属性,
	if (obj) obj.setAttribute("isDefualt","true");
	combo_CardType=dhtmlXComboFromSelect("CardType");
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle=combo_CardTypeKeydownHandler;
	}
	combo_CardTypeKeydownHandler();
	if (vRBASID!=""){
		var obj=document.getElementById('ReceiptNo');
	    obj.style.display='none';
	    var obj=document.getElementById('cReceiptNo');
	    obj.style.display='none';
	}else{		
	    GetReceiptNo();
	} 
	appobjtbl=document.getElementById('tDHCOPAdm_Appointment');
	if (appobjtbl) {
		appobjtbl.onkeydown = TableKeydownHandler;
	}
	
	//时段
	var TimeRangeStr=DHCC_GetElementData('TimeRangeStr');
	combo_TimeRange=dhtmlXComboFromStr("TimeRange",TimeRangeStr);
	combo_TimeRange.enableFilteringMode(true);
	combo_TimeRange.selectHandle=combo_TimeRangeKeydownhandler;
	combo_TimeRange.attachEvent("onKeyPressed",combo_TimeRangeKeyenterhandler)
	

	return websys_cancel();
}

function combo_TimeRangeKeydownhandler(){
		var TRRowId=combo_TimeRange.getSelectedValue();
		DHCC_SetElementData('TimeRangeRowID',TRRowId);
		return websys_cancel();
}
function combo_TimeRangeKeyenterhandler(e){
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	if (keycode==13) {
		combo_TimeRange.DOMelem_input.focus();
		return false;
	}
}

function NoArriveChangeHandler(e){
	var ret=DHCC_GetElementData('NoArrive');
	if (ret){
		DHCC_SetElementData('AppStatus',"");
	}else{
		DHCC_SetElementData('AppStatus',"A");
	}
}

document.onkeydown=documentkeydown;
function documentkeydown(e) { 
	var keycode;
	try {keycode=websys_getKey(e);} catch(e) {keycode=websys_getKey();}
	//F9
	if (keycode==120){
		var obj=document.getElementById('Update');
		if (obj) UpdateClickHandler();
	}else if (keycode==119) {
		ReadCardClickHandler();
	}else if(keycode==118) {
		FindClickHandler();
	}else if(keycode==121) {
		CancelClickHandler();
	}else{
		websys_sckey(e)
	}
}
/* 不使用定义的方法
function Find_click(){
	DHCC_ClearTable('tDHCOPAdm_Appointment');

	var encmeth=DHCC_GetElementData('GetAppointmentMethod')
	if (encmeth!=''){
		var AdmDepRowId="",AdmDocRowId="",StartDate='',EndDate='',PatientNo=''
		var PatientID=DHCC_GetElementData('PatientID');
		var AppStatus=DHCC_GetElementData('AppStatus');
		var AdmDepRowId=DHCC_GetElementData('AdmDepRowId');
	    var AdmDocRowId=DHCC_GetElementData('AdmDocRowId');
	    var StartDate=DHCC_GetElementData('StartDate');
	    var EndDate=DHCC_GetElementData('EndDate');		
		//alert(PatientID+"^"+AppStatus);
		var retDetail=cspRunServerMethod(encmeth,"AddDataToTable",AdmDepRowId,AdmDocRowId,StartDate,EndDate,PatientNo,PatientID,AppStatus);
		if (retDetail>0) {
			if (appobjtbl.rows.length>1){
				var objrow=appobjtbl.rows[1];
				appobjtbl.focus();
				objrow.click();
			}
		}else{
			websys_setfocus('CardNo');
		}				
		return true;
	}
}
*/
function AddDataToTable(val){
	//alert(val);
	try{
		if (appobjtbl.rows.length==2) {
			var TabRowId=DHCC_GetColumnData("TabRowId",1)
			if (TabRowId!=''){DHCC_InsertRowToTable(appobjtbl);}
		}else{
			DHCC_InsertRowToTable(appobjtbl);
		}

		var Row=appobjtbl.rows.length-1;
  	
		//RowId,AppDate,AppTime,DepDesc,DocDesc,PatientID,PatientNo,PatientName,StatusCode,StatusDesc,MethodDesc
		//QueueNo,Sum,RBASStatusDesc,TRDoc,RBASStatusReason,TransDate,TransTime,TransUserName,StatusChangeDate,
		//StatusChangeTime,StatusChangeUserName,SystemSession,RBASStatusCode 	
		var Split_Value=val.split("^");
		var TabRowId=Split_Value[0];
		var TabAppDate=Split_Value[1];
		var TabChangeDate=Split_Value[19];
		var TabChangeTime=Split_Value[20];
		var TabChangeUserName=Split_Value[21];
		var TabDepDeDesc=Split_Value[3];
		var TabDocDesc=Split_Value[4];
		var TabMethodDesc=Split_Value[10];
		var TabPatientName=Split_Value[7];
		var TabPatientNo=Split_Value[6];
		var TabQueueNo=Split_Value[11];
		var TabReason=Split_Value[15];
		var TabShceduleStatus=Split_Value[13];
		var TabStatus=Split_Value[9];
		var TabStatusCode=Split_Value[8];
		var TabSum=Split_Value[12];
		var TabTRDoc=Split_Value[14];
		var TabShceduleStatusCode=Split_Value[23];
		var TabCardCommonAppInfo=Split_Value[24];
		DHCC_SetColumnData("TabAppDate",Row,TabAppDate);

		DHCC_SetColumnData("TabChangeDate",Row,TabChangeDate);
		DHCC_SetColumnData("TabChangeTime",Row,TabChangeTime);
		DHCC_SetColumnData("TabChangeUserName",Row,TabChangeUserName);
		DHCC_SetColumnData("TabDepDeDesc",Row,TabDepDeDesc);

		DHCC_SetColumnData("TabDocDesc",Row,TabDocDesc);
		DHCC_SetColumnData("TabMethodDesc",Row,TabMethodDesc);
		DHCC_SetColumnData("TabPatientName",Row,TabPatientName);
		DHCC_SetColumnData("TabPatientNo",Row,TabPatientNo);
		DHCC_SetColumnData("TabQueueNo",Row,TabQueueNo);

		DHCC_SetColumnData("TabReason",Row,TabReason);
		DHCC_SetColumnData("TabRowId",Row,TabRowId);
		DHCC_SetColumnData("TabShceduleStatus",Row,TabShceduleStatus);
		DHCC_SetColumnData("TabStatus",Row,TabStatus);
		DHCC_SetColumnData("TabStatusCode",Row,TabStatusCode);
		DHCC_SetColumnData("TabSum",Row,TabSum);
		DHCC_SetColumnData("TabTRDoc",Row,TabTRDoc);

		switch(TabShceduleStatusCode)	{
			case 'S':
			 	appobjtbl.rows[Row].className='ScheduleStop';
			 	break;
			case 'TR':
				appobjtbl.rows[Row].className='SqueezedIn';
				break;
			case 'R':
				appobjtbl.rows[Row].className='ScheduleReplace';
				break;
		}
		DHCC_SetColumnData("CardCommonAppInfo",Row,TabCardCommonAppInfo);
       
	}catch(e){
		alert(e.message);
	}
}

function UpdateClickHandler(e){
	var selectrow=SelectedRow;
	if (!selectrow){alert("请选择预约记录");return;}
	if (selectrow !=0) {
		if (APPTRowId==''){return}
		var APPTRowId=DHCC_GetColumnData("TabRowId",selectrow);
		var StatusCode=DHCC_GetColumnData("TabStatusCode",selectrow);
		var BillAmount=DHCC_GetColumnData("TabSum",selectrow);
		if (StatusCode=='S'){
			alert(t['DoctorIsStop']);
			return;
		}
		var UserRowId=session['LOGON.USERID']
		var GroupRowId=session['LOGON.GROUPID'];
		var LocID=session['LOGON.CTLOCID'];	
		//帐户相关参数
		var CardTypeRowID=GetCardTypeRowId();
		var PayMode=DHCC_GetElementData('PayMode');
		var CardNo=DHCC_GetElementData('CardNo');
		m_CCMRowID=GetCardEqRowId();
		if (PayMode=="CPP") {
 	  var ren=DHCACC_CheckMCFPay(BillAmount,CardNo,"",CardTypeRowID);
	  var myary=ren.split("^");
		if (myary[0]!='0'){
			if (myary[0]='-204'){alert(t['AccountLocked'])}
			if (myary[0]='-205'){alert(t['AccAmountNotEnough'])}
			if (myary[0]='-206'){alert(t['NotSameCard'])}
			return;
		}else{
			var AccRowId=myary[1];
		}
		}
		//end		
		var BLNo=0;     //是否传病历号标志?0不传病历号?1传病历号	
		var encmeth=DHCC_GetElementData("UpdateAppStatusEncrypt");  //web.DHCOPAdmReg.OPAppArriveBroker
		var ret=cspRunServerMethod(encmeth,"","",APPTRowId,UserRowId,GroupRowId,PayMode,AccRowId)
		var retarr=ret.split("$");
		if (retarr[0]=="0"){
		//调病案接口函数,地坛医院只判断门诊病历号
				var PrintArr=retarr[1].split("^");
				var EpisodeID=PrintArr[0];
				var TabASRowId=PrintArr[22];
				//var PatientID=DHCC_GetElementData('PatientID');
	
				var encrype=DHCC_GetElementData("GetPatMedCode");
				if (encrype!="")
				{
				var MedCodeArr=cspRunServerMethod(encrype,EpisodeID);
				var MedCodeStr=MedCodeArr.split("^");
				var DYOPMRN=MedCodeStr[0];
				var DYIPMRN=MedCodeStr[1];
				var SGMedicareCode1=MedCodeStr[2];
				var SGMedicareCode2=MedCodeStr[3];
				var PatientID=MedCodeStr[4];
					 
				//alert(PatientID+"^"+TabASRowId+"^"+EpisodeID+"^"+UserRowId+","+LocID+","+DYOPMRN+","+DYIPMRN+","+SGMedicareCode1+","+SGMedicareCode2);		
				//var BLNo=cspRunServerMethod(enc,TabASRowId,UserRowId,LocID,DYOPMRN,DYIPMRN,SGMedicareCode1,SGMedicareCode2,EpisodeID);
				}
				
				if(DYOPMRN!="")BLNo=1;
				if(BLNo==1){
					var BLFlag=confirm('有病历号,是否传病历号?');
					if(BLFlag==true)
					{
						var OMrType=DHCC_GetElementData('OMrType');
						var IMrType=DHCC_GetElementData('IMrType');
						var sWorkItem=DHCC_GetElementData('sWorkItem');
						var sReqType=DHCC_GetElementData('sReqType');
						//alert(PatientID+"^"+EpisodeID+"^"+OMrType+"^"+IMrType+"^"+sWorkItem+"^"+sReqType)
						WMR_NewRequest(PatientID,EpisodeID,OMrType,IMrType,sWorkItem,sReqType);
					}
					else{}
			 }
		    
			PrintOut(retarr[1]);
			GetReceiptNo();

			Find_click();
		}else{
			var errmsg="";
			if (retarr[0]=="-201")  errmsg=t['ADMInsertFail'];
			if (retarr[0]=="-202")  errmsg=t['FailGetQueueNo'];
			if (retarr[0]=="-2121")  errmsg=t['UpdateAppStatusFail'];
			if (retarr[0]=="-206")  errmsg=t['PriceArcOrderInsertFail'];
			if (retarr[0]=="-207")  errmsg=t['chrhfeeOrderInsertFail'];
			if (retarr[0]=="-208")  errmsg=t['holiOrderInsertFail'];
			if (retarr[0]=="-209")  errmsg=t['AppOrderInsertFail'];
			if (retarr[0]=="-210")  errmsg=t['FailCharge'];
			if (retarr[0]=="-211")  errmsg=t['RegFeeInsertFail'];
			if (retarr[0]=="-212")  errmsg=t['QueueInsertFail'];
			if (retarr[0]=="-220")  errmsg=t['StatusIsCancel'];
			if (retarr[0]=="-221")  errmsg=t['StatusIsArrival'];
			if (retarr[0]=="-222")  errmsg=t['UpdateStatusFail'];
			if (retarr[0]=="-223")  errmsg=t['AppNotExist'];
			if (retarr[0]=="-230")  errmsg=t['UpdateFile'];

			alert(t['RegFail']+"ErrCode:"+retarr[0]+":"+errmsg);
			return false;
		}
	}
}
function CancelClickHandler(e){
	var selectrow=SelectedRow;
	if (!selectrow){alert("请选择预约记录");return websys_cancel();} 
	if (selectrow !=0) {
		var APPTRowId=DHCC_GetColumnData("TabRowId",selectrow)
		if (APPTRowId==''){return websys_cancel();}
		var UserRowId=session['LOGON.USERID']
		var GroupRowId=session['LOGON.GROUPID'];	
		var encmeth=DHCC_GetElementData("CancelMethod");
		if (encmeth!=""){
			var ret=cspRunServerMethod(encmeth,APPTRowId,UserRowId)
			if (ret=="0"){
				alert(t['CancelOk']);
				GetReceiptNo();
			}else{
				if (ret=="-201") {alert(t['StatusIsArrival']);return websys_cancel();}
				if (ret=="-202") {alert(t['StatusIsCancel']);return websys_cancel();}
				alert(t['CanelFail']+"ErrCode:"+ret);
				return websys_cancel();
			}
		}
	}
	Find_click();	
	return websys_cancel();
}
function ChangeAppointClickHandler(e){
	var selectrow=SelectedRow;
	if (!selectrow) {alert("请选择预约记录");return websys_cancel();} 
	var NewCardNo=DHCC_GetElementData('ChangeCardNo');
	if (NewCardNo==""){alert(t['NewCardNoIsNull']);return;}
	
	if (selectrow !=0) {
		var APPTRowId=DHCC_GetColumnData("TabRowId",selectrow);
		var BillAmount=DHCC_GetColumnData("TabSum",selectrow);
		if (APPTRowId==''){return}
		var encmeth=DHCC_GetElementData("ChangeAppointMethod");
		if (encmeth!=""){
			var UserRowId=session['LOGON.USERID']
			var GroupRowId=session['LOGON.GROUPID'];
			//帐户相关参数
		var CardTypeRowID=GetCardTypeRowId();
		var PayMode=DHCC_GetElementData('PayMode');
		var CardNo=DHCC_GetElementData('CardNo');
		m_CCMRowID=GetCardEqRowId();
		if (PayMode=="CPP") {
 	  var ren=DHCACC_CheckMCFPay(BillAmount,CardNo,"",CardTypeRowID);
	  var myary=ren.split("^");
		if (myary[0]!='0'){
			if (myary[0]='-204'){alert(t['AccountLocked'])}
			if (myary[0]='-205'){alert(t['AccAmountNotEnough'])}
			if (myary[0]='-206'){alert(t['NotSameCard'])}
			return;
		}else{
			var AccRowId=myary[1];
		}
		}
		//end	
		  var BLNo=0;     //是否传病历号标志?0不传病历号?1传病历号			
			//alert(APPTRowId+"^"+NewCardNo+"^"+UserRowId+"^"+GroupRowId)
			var ret=cspRunServerMethod(encmeth,"","",APPTRowId,NewCardNo,UserRowId,GroupRowId,PayMode,AccRowId)
			var retarr=ret.split("$");	
			if (retarr[0]=="0"){
			//调病案接口函数,地坛医院只判断门诊病历号
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
				//alert(PatientID+"^"+TabASRowId+"^"+EpisodeID+","+DYOPMRN+","+DYIPMRN+","+SGMedicareCode1+","+SGMedicareCode2);		
				//var BLNo=cspRunServerMethod(enc,TabASRowId,UserRowId,LocID,DYOPMRN,DYIPMRN,SGMedicareCode1,SGMedicareCode2,EpisodeID);
				if(DYOPMRN!="")BLNo=1;
				if(BLNo==1){
					var BLFlag=confirm('有病历号,是否传病历号?');
					if(BLFlag==true)
					{
						var OMrType=DHCC_GetElementData('OMrType');
						var IMrType=DHCC_GetElementData('IMrType');
						var sWorkItem=DHCC_GetElementData('sWorkItem');
						var sReqType=DHCC_GetElementData('sReqType');
						//alert(PatientID+"^"+EpisodeID+"^"+OMrType+"^"+IMrType+"^"+sWorkItem+"^"+sReqType)
						WMR_NewRequest(PatientID,EpisodeID,OMrType,IMrType,sWorkItem,sReqType);
					}
					else{}
			 }
				PrintOut(retarr[1]);
				alert(t['ChangeOk']);
				GetReceiptNo();
				Find_click();	
			}else{
				if (ret=="-201") {alert(t['InvaildNewCard'])}
				else {alert(t['ChangeAppointFail'])}
				websys_setfocus('ChangeCardNo');
				return false;
			}
		}
	}else{
		alert(t['NotSelectChangeRow']);	
	}	
}

function combo_CardTypeKeydownHandler(){
	if (combo_CardType) websys_nexttab(combo_CardType.tabIndex);
}

function GetTableSelectRow(e){
	if (selectedRowObj.rowIndex==""){return "";}
	var selectrow=selectedRowObj.rowIndex;
	return selectrow
}

function TableKeydownHandler(e){
	var key=websys_getKey(e);

	var selectrow=GetTableSelectRow();
	var objtbl=window.document.getElementById('tDHCOPAdm_Appointment');
	if (selectrow=="") return
	if (key==38){
		if (selectrow==1) return;
		var objrow=objtbl.rows[selectrow-1];
		objrow.click();
		//window.event.cancelBubble=true
	}
	if (key==40){
		if (selectrow==(objtbl.rows.length-1)) return;
		var objrow=objtbl.rows[selectrow+1];
		objrow.click();
			//window.event.cancelBubble=true
	}
}


function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow){return;};
	if (SelectedRow!=selectrow){
		SelectedRow=selectrow
	}else{
		SelectedRow=0
		}
}
function PrintOut(PrintData) {
	try {
		//alert(PrintData);
		var PrintArr=PrintData.split("^");
		var AdmNo=PrintArr[0];
		var PatName=PrintArr[1];
		var RegDep=PrintArr[2];
		
		var DocDesc=PrintArr[3];
		var SessionType=PrintArr[4];
		var MarkDesc=DocDesc;
		
		var AdmDateStr=PrintArr[5];
		var TimeRange=PrintArr[6];
		var AdmDateStr=AdmDateStr+TimeRange;
		var TimeD=TimeRange.substring(0,2);
		
		var SeqNo=PrintArr[7];
		var RoomNo=PrintArr[8];
		var RoomFloor=PrintArr[9];
		var UserCode=PrintArr[11];
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
		var cardnoprint=PrintArr[31];           //打印转号后的卡号
		var PatNo=PrintArr[36];
		RegTime=RegDateYear+"-"+RegDateMonth+"-"+RegDateDay+" "+RegTime
		var ExabMemo=PrintArr[23];
		//var ObjCard=document.getElementById('CardNo'); 
		//var cardnoprint=ObjCard.value;
		if (AppFee!=0){AppFee="预约费:"+AppFee+"元"}else{AppFee=""}
		if (OtherFee!=0) {OtherFee="治疗费:"+OtherFee+"元"}else{OtherFee=""}
		if (RegFee!=0){RegFee=RegFee+"元"}else{RegFee=""}
		if (Total!=0){Total=Total}else{Total=""}

		var PDlime=String.fromCharCode(2);
		var MyPara="AdmNo"+PDlime+AdmNo+"^"+"PatName"+PDlime+PatName+"^"+"TransactionNo"+PDlime+TransactionNo;
		var MyPara=MyPara+"^"+"MarkDesc"+PDlime+MarkDesc+"^"+"AdmDate"+PDlime+AdmDateStr+"^"+"SeqNo"+PDlime+SeqNo+"^RegDep"+PDlime+RegDep;
		var MyPara=MyPara+"^"+"RoomFloor"+PDlime+RoomFloor+"^"+"UserCode"+PDlime+UserCode;
		var MyPara=MyPara+"^"+"RegDateYear"+PDlime+RegDateYear+"^RegDateMonth"+PDlime+RegDateMonth+"^RegDateDay"+PDlime+RegDateDay;
		var MyPara=MyPara+"^"+"Total"+PDlime+Total+"^RegFee"+PDlime+RegFee+"^AppFee"+PDlime+AppFee+"^OtherFee"+PDlime+OtherFee;
		var MyPara=MyPara+"^"+"RoomNo"+PDlime+RoomNo+"^"+"ClinicGroup"+PDlime+ClinicGroup+"^"+"SessionType"+PDlime+SessionType+"^"+"TimeD"+PDlime+TimeD+"^"+"RegTime"+PDlime+RegTime+"^"+"cardnoprint"+PDlime+cardnoprint+"^"+"PatNo"+PDlime+PatNo;
		var MyPara=MyPara+"^"+"ExabMemo"+PDlime+ExabMemo;
		var myobj=document.getElementById("ClsBillPrint");
		PrintFun(myobj,MyPara,"");	
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
		var docobj=new ActiveXObject("MSXML2.DOMDocument.4.0");
		docobj.async = false;    //close
		var rtn=docobj.loadXML(mystr);
		if ((rtn)){
			////ToPrintDoc(ByVal inputdata As String, ByVal ListData As String, InDoc As MSXML2.DOMDocument40)			
			var rtn=PObj.ToPrintDocNew(inpara,inlist,docobj);
			////var rtn=PObj.ToPrintDoc(myinstr,myList,docobj);
		}
	}catch(e){
		alert(e.message);
		return;
	}
}

function GetReceiptNo(){
	var encmeth=DHCC_GetElementData('GetreceipNO');
	var p1=session['LOGON.USERID']+"^"+"^"+session['LOGON.GROUPID']
	if (encmeth!=""){
		if (cspRunServerMethod(encmeth,'SetReceipNO','',p1)!='0') {
			alert(t['InvalidReceiptNo']);
			return
		}
	}
}

function SetReceipNO(value) {
	var myary=value.split("^");
	var ls_ReceipNo=myary[0];
	DHCC_SetElementData('ReceiptNo',ls_ReceipNo);
	
	//DHCWebD_SetObjValueA("INVLeftNum",myary[2]);
	///如果张数小于最小提示额change the Txt Color
	if (myary[1]!="0"){	obj.className='clsInvalid';}
}

function FindClickHandler(e){
	event.keyCode=13;
	CardNoKeydownHandler(e);
	var CardNo=DHCC_GetElementData('CardNo');
	if (CardNo!="") return;
	else {Find_click();}
	return;
	var AdmDep=DHCC_GetElementData("AdmDep");
	if (AdmDep==""){DHCC_SetElementData("AdmDepRowId","")}
	var AdmDoc=DHCC_GetElementData("AdmDoc");
	if (AdmDoc==""){DHCC_SetElementData("AdmDocRowId","")}
	var CardNo=DHCC_GetElementData('CardNo');
	var StartDate=DHCC_GetElementData('StartDate');
	var EndDate=DHCC_GetElementData('EndDate');
	/*
	if (CardNo==''){
		websys_setfocus('CardNo');
		 alert(t['NoCondition']);
		return;
	}
	*/	
	Find_click();
	return websys_cancel();
}

function Clear_Click(e){
	DHCC_SetElementData("StartDate","")
	DHCC_SetElementData("EndDate","")
	DHCC_SetElementData("PatientNo","")
	DHCC_SetElementData("PatientID","")
	DHCC_SetElementData("CardNo","")
	DHCC_SetElementData("AdmDep","")
	DHCC_SetElementData("AdmDoc","")	
	DHCC_SetElementData("AdmDocRowId","")	
	DHCC_SetElementData("AdmDepRowId","")
}

function AdmDepLookupHandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);

	var obj=websys_getSrcElement(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))){
			var url='websys.lookup.csp';
		url += "?ID=AdmDep";
		url += "&CONTEXT=Kweb.DHCOPAdmReg:OPDept";
		url += "&TLUJSF=AdmDepLookupSelect";
		var obj=document.getElementById('AdmDep');
		if (obj) url += "&P1=" + websys_escape(obj.value);

		websys_lu(url,1,'');
		return websys_cancel();
	}
}
function AdmDepLookupSelect(value) {
	var Split_Value=value.split("^");
	try {
		DHCC_SetElementData("AdmDep",Split_Value[0]);
		DHCC_SetElementData("AdmDepRowId",Split_Value[1]);
	} catch(e) {alert(e.message)};
}
function AdmDocLookupHandler(e) {
	var type=websys_getType(e);
	var key=websys_getKey(e);

	var obj=websys_getSrcElement(e);
	if ((type=='click')||((type=='keydown')&&(key==117))||((type=='keydown')&&(key==13))){
			var url='websys.lookup.csp';
		url += "?ID=AdmDoc";
		url += "&CONTEXT=Kweb.DHCOPAdmReg:OPResDoc";
		url += "&TLUJSF=AdmDocLookupSelect";
		url += "&P1=" + websys_escape(DHCC_GetElementData('AdmDepRowId'));
		url += "&P2=" + websys_escape(DHCC_GetElementData('AdmDoc'));

		websys_lu(url,1,'');
		return websys_cancel();
	}
}
function AdmDocLookupSelect(value) {
	var Split_Value=value.split("^");
	try {
		DHCC_SetElementData("AdmDoc",Split_Value[0]);
		DHCC_SetElementData("AdmDocRowId",Split_Value[1]);
	} catch(e) {alert(e.message)};
}

function GetCardTypeRowId(){
	var CardTypeRowId="";
	//var CardTypeValue=DHCC_GetElementData("CardType");
	//var CardTypeValue=combo_CardType.getActualValue();   //默认卡类型得不到rowid
	var CardTypeValue=combo_CardType.getSelectedValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId
}

function GetCardNoLength(){
	var CardNoLength="";
	//var CardTypeValue=DHCC_GetElementData("CardType");
	//var CardTypeValue=combo_CardType.getActualValue();
	var CardTypeValue=combo_CardType.getSelectedValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	//return 15
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


function ReadCardClickHandler(){
	var CardTypeRowId=GetCardTypeRowId();
	//var myoptval=combo_CardType.getActualValue();
	var myoptval=combo_CardType.getSelectedValue();
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	AccAmount=myary[3];
	
	if ((rtn=="0")||(rtn=="-201")){
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			var NewCardTypeRowId=myary[8];
			if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
			if(rtn=="0")DHCC_SetElementData("PayMode","CPP");
			if(rtn=="201")DHCC_SetElementData("PayMode","CASH");
			SetPatientInfo(PatientNo,CardNo);
	}else if (rtn=="-200"){
			alert(t['InvaildCard']);
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
		var CardNo=FormatCardNo();
		if (CardNo==""){
			return false;
		}
		//alert(CardTypeRowId+"^"+CardNo);
		var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardNo,"","PatInfo");
		var myary=myrtn.split("^");
		var rtn=myary[0];
		AccAmount=myary[3];

		if ((rtn=="0")||(rtn=="-201")){
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				var NewCardTypeRowId=myary[8];
				if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
				if(rtn=="0")DHCC_SetElementData("PayMode","CPP");
				if(rtn=="201")DHCC_SetElementData("PayMode","CASH");
				SetPatientInfo(PatientNo,CardNo);
		}else if (rtn=="-200"){
				alert(t['InvaildCard']);
				DHCC_SetElementData("CardNo","");
				websys_setfocus('CardNo');
		}
	}
}

function SetPatientInfo(PatientNo,CardNo){
	if (PatientNo!='') {
		DHCC_SetElementData("PatientNo","");
		DHCC_SetElementData("PatientID","");
		DHCC_SetElementData("CardNo",CardNo);
		//因为在ClearPatInfo()时会把PatientNo的值清空,所以要重新赋值
	
		var encmeth=DHCC_GetElementData('GetPatDetailEncrypt');
		if (encmeth!=""){
			if (cspRunServerMethod(encmeth,'SetPatient_Sel','',PatientNo)=='0') {
				var obj=document.getElementById('CardNo');
				obj.className='clsInvalid';
				websys_setfocus('CardNo');
				return websys_cancel();
			}else{
				var obj=document.getElementById('CardNo');
				obj.className='';
				//websys_setfocus('CardNo');
				return websys_cancel();				
			}
		}
	} else {
		websys_setfocus('CardNo');
		return websys_cancel();
	}
}

function SetPatient_Sel(value) {
	try {
		var Patdetail=value.split("^");	
		DHCC_SetElementData("PatientID",Patdetail[6]);
		DHCC_SetElementData("PatientNo",Patdetail[9]);
		DHCC_SetElementData("PoliticalLevel",Patdetail[19]);
		DHCC_SetElementData("SecretLevel",Patdetail[20]);
		var PatYBCode=Patdetail[11]; //医保号
		var YBType=Patdetail[12]; //医保类型
		//if((YBType=="医保")||(YBType=="医保特病")){
		if(YBType.indexOf("医保")!=-1){
		    if((PatYBCode=="")||(PatYBCode=="99999999999S")||(PatYBCode=="99999999999s"))alert("此为医保病人,但医保号为空或不正确!");
	    }else{
		  if(PatYBCode!=""){
			  alert("病人类型与医保号不符!");
		  }
	    }
		Find_click();
		
	} catch(e) {
		alert(e.message)
	}
}

function ReadCardType(){
	DHCC_ClearList("CardType");
	var encmeth=DHCC_GetElementData("CardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCWeb_AddToListA","CardType");
	}
}
function GetCardEqRowId(){
	var CardEqRowId="";
	//var CardTypeValue=DHCC_GetElementData("CardType");
	var CardTypeValue=combo_CardType.getActualValue();

	
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardEqRowId=CardTypeArr[14];
	}
	return CardEqRowId;
}
function ChangeCardNoKeydownHandler(e) {
	if (evtName=='ChangeCardNo') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var key=websys_getKey(e);
	if (key==13) {
		var ChangeCardNo=FormatChangeCardNo();
		DHCC_SetElementData("ChangeCardNo",ChangeCardNo);
	}
}
function FormatChangeCardNo(){
	var CardNo=DHCC_GetElementData("ChangeCardNo");
	if (CardNo!='') {
		var CardNoLength=GetCardNoLength();
		if ((CardNo.length<CardNoLength)&&(CardNoLength!=0)) {
			for (var i=(CardNoLength-CardNo.length-1); i>=0; i--) {
				CardNo="0"+CardNo;
			}
		}
	}
	return CardNo;
}
//补打预约凭证
function RePrintAppClickHandler(){
	try{
		var selectrow=SelectedRow;
		if (!selectrow){alert("请选择预约记录");return;}
		var APPTRowId="";
		if (selectrow !=0) {
			var APPTRowId=DHCC_GetColumnData("TabRowId",selectrow);
		}
		if(APPTRowId==""){
			alert("请选择一条预约记录");
			return;
		}
		var AppPrintData="";
		var AppPrinte=DHCC_GetElementData('GetAppPrint');
		if(AppPrinte!=""){
			var AppPrintData=cspRunServerMethod(AppPrinte,APPTRowId);
		}
		if (AppPrintData=="") return;
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAppRegPrint");
		var AppPrintArr=AppPrintData.split("^");
		var CardNo=AppPrintArr[0];
		var PapmiDr=AppPrintArr[1];
		var PapmiName=AppPrintArr[2];
		var PapmiNo=AppPrintArr[13];
		//var PapmiDOB=AppPrintArr[3];
		var PamiSex=AppPrintArr[3];
		var QueueNo=AppPrintArr[4];
		var Locdesc=AppPrintArr[6];
		var Docdesc=AppPrintArr[7];
		var AppDate=AppPrintArr[8];
		var AppTime=AppPrintArr[9];
		AppTime=AppDate+" "+AppTime
		var AdmDate=AppPrintArr[10];
		var TimeRangeInfo=AppPrintArr[14];
		var UserSS=AppPrintArr[15];
		var Price=AppPrintArr[17];
		var SessionTypeDesc=AppPrintArr[18];
		var ASDateWeek=AppPrintArr[19];
		var PDlime=String.fromCharCode(2);
		var MyPara="CardNo"+PDlime+CardNo+"^"+"PatNo"+PDlime+PapmiNo+"^"+"PatName"+PDlime+PapmiName+"^"+"AppDep"+PDlime+Locdesc;
		var MyPara=MyPara+"^"+"MarkDesc"+PDlime+Docdesc+"^"+"PatSex"+PDlime+PamiSex+"^"+"SeqNo"+PDlime+QueueNo+"^"+"AppDate"+PDlime+AppDate;
		var MyPara=MyPara+"^"+"AdmDate"+PDlime+AdmDate+"^"+"UserCode"+PDlime+UserSS;
		var MyPara=MyPara+"^"+"APPCompDate"+PDlime+AppTime+"^"+"SessionType"+PDlime+SessionTypeDesc+"^Total"+PDlime+Price;
		var myobj=document.getElementById("ClsBillPrint");
		PrintFun(myobj,MyPara,"");	
	}
	catch(e){alert(e.message);}	
}