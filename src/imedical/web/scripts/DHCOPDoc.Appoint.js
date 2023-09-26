var m_CardNoLength=0;
var SelectedRow = 0;
var m_RowIndex=-1;
var m_DefaultCardLength=0;

document.body.onload = BodyLoadHandler;
function BodyLoadHandler() {
	//var WshNetwork = new ActiveXObject("WScript.NetWork");
	//var computername=WshNetwork.ComputerName;
	//init();
	document.onkeydown=DocumentOnKeyDownHandler;
	var obj=document.getElementById('BAppoint');
	if (obj) obj.onclick=AppointClickHandler;
	quickK.f9=AppointClickHandler; 
    quickK.addMethod();
	var obj=document.getElementById('BAddUpdate');
	if (obj) obj.onclick=AddUpdateClickHandler;
	var BtnReadCardObj=document.getElementById('BtnReadCard');
	if (BtnReadCardObj){
		BtnReadCardObj.onclick=BtnReadCardHandler;		
	}   
	ReadCardType();
	var obj=document.getElementById('CardType');
	//��ΪdhtmlXComboFromSelectҪ�ж�isDefualt����,
	if (obj) obj.setAttribute("isDefualt","true");
	combo_CardType=dhtmlXComboFromSelect("CardType");
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.selectHandle=combo_CardTypeKeydownHandler;
	}
	combo_CardTypeKeydownHandler;
	var obj=document.getElementById("PatientNo");
	if (obj) {
		obj.onkeydown=PatientNoKeyDownHandler
		}
	//�����patientid���ʼ�����˻�����Ϣ
	var patientRowid=DHCC_GetElementData("patientRowid");
	if(patientRowid){
		SetCardNo(patientRowid);
	}	
	var obj = document.getElementById("ALL");
	if (obj){
		obj.onclick =ALLClick ;
	}
}
function ALLClick()
{
    var patientRowid=DHCC_GetElementData("patientRowid");
	var obj=document.getElementById("ALL")
	if(obj.checked){var ALL="on"}
	else {var ALL=""}
	var StartDate=DHCC_GetElementData("StartDate");
	var EndDate=DHCC_GetElementData("EndDate");
	var DocMarkDr=DHCC_GetElementData("DocMarkDr");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPDoc.Appoint&PatientID="+patientRowid+"&ALL="+ALL+"&StartDate="+StartDate+"&EndDate="+EndDate+"&DocMarkDr="+DocMarkDr; //url+"&ALL="+ALL;
	//window.location.reload();
}
function PatientNoKeyDownHandler(e) {
	var key=websys_getKey(e);
	if(key==13){
	var RegNo=document.getElementById('PatientNo').value;
	if (RegNo!='') {
		var RegNoLength=10;
		if ((RegNo.length<RegNoLength)&&(RegNoLength!=0)) {
			for (var i=(RegNoLength-RegNo.length-1); i>=0; i--) {
				RegNo="0"+RegNo;
			}
		}
	}
	document.getElementById('PatientNo').value=RegNo;
	var encmeth=DHCC_GetElementData('GetDetail');
		if (encmeth!=""){
			
			if (cspRunServerMethod(encmeth,'SetPatient_Sel','',RegNo)=='0') {
				var obj=document.getElementById('CardNo');
				obj.className='clsInvalid';
				websys_setfocus('BAppoint');
				return websys_cancel();
			}else{
				var obj=document.getElementById('CardNo');
				obj.className='';
				websys_setfocus('BAppoint');
				return websys_cancel();				
			}
		}
	
	}
}
function ReadCardType(){
	DHCC_ClearList("CardType");
	var encmeth=DHCC_GetElementData("CardTypeEncrypt");
	if (encmeth!=""){
		var rtn=cspRunServerMethod(encmeth,"DHCC_AddToListA","CardType");
	}
}
function combo_CardTypeKeydownHandler(){
	if (combo_CardType) websys_nexttab(combo_CardType.tabIndex);
}


function BtnReadCardHandler(){
	var CardTypeRowId=GetCardTypeRowId();
	var myoptval=combo_CardType.getSelectedValue();
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,myoptval);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	//AccAmount=myary[3];
	switch (rtn){
		case "0": //����Ч
				var PatientID=myary[4];
				var PatientNo=myary[5];
				var CardNo=myary[1]
				var NewCardTypeRowId=myary[8];
				if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);
				SetPatientInfo(PatientNo,CardNo,PatientID);				
			break;
		case "-200": //����Ч
			alert(t['InvaildCard']);
			websys_setfocus('RegNo');
			break;
		case "-201": //�ֽ�
			//alert(t['21']);
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1]
			var NewCardTypeRowId=myary[8];
			if (NewCardTypeRowId!=CardTypeRowId) combo_CardType.setComboValue(NewCardTypeRowId);

			SetPatientInfo(PatientNo,CardNo,PatientID);				
			//DHCC_SelectOptionByCode("PayMode","CASH")
			break;
		default:
	}
	return websys_cancel();
}

function SetPatientInfo(PatientNo,CardNo,PatientID){
	if (PatientNo!='') {
		DHCC_SetElementData("PatientNo",PatientNo);
		DHCC_SetElementData("CardNo",CardNo);
		DHCC_SetElementData("PatientID",PatientID);
	}
}

function init(){
	//������
	loadXComboData("CardType","ReadCardTypeEncrypt");
	combo_CardType=dhtmlXComboFromSelect("CardType");
	if (combo_CardType) {
		combo_CardType.enableFilteringMode(true);
		combo_CardType.disable(true);
		combo_CardType.setComboText("");
	}
	websys_setfocus('CardNo');
}
//ͨ��rowid�õ�����
function SetCardNo(patientRowid){
	var encmeth=DHCC_GetElementData('GetDetailById');
	if (encmeth!=""){
		if (cspRunServerMethod(encmeth,'SetPatient_Card','',patientRowid)=='0') {
			var obj=document.getElementById('CardNo');
			obj.className='clsInvalid';
			websys_setfocus('BAppoint');
			return websys_cancel();
		}else{
			var obj=document.getElementById('CardNo');
			obj.className='';
			//websys_setfocus('BAppoint');
			return websys_cancel();				
		}
	} else {
		websys_setfocus('CardNo');
		return websys_cancel();
	}
}
//Ϊ���Ÿ�ֵ
function SetPatient_Card(value){
	try {
		var Patdetail=value.split("^");	
		DHCC_SetElementData("CardNo",Patdetail[11]);
		var NewCardTypeRowId=Patdetail[12]
		var CardTypeRowId=GetCardTypeRowId();
		if(CardTypeRowId!=NewCardTypeRowId){
			combo_CardType.setComboValue(NewCardTypeRowId);
		}
		CheckCardNo();//ͨ�����ŵõ����˻�����Ϣ
	} catch(e) {
		alert(e.message)
	};
}

function DocumentOnKeyDownHandler() {	
	var eSrc=window.event.srcElement;	
	var key=websys_getKey(eSrc);	
	if (key==13) {
		if (eSrc.name=='CardNo'){
			SetCardNoLength();
			CheckCardNo();
		}
		websys_nexttab(eSrc.tabIndex);
	}
	if (key==115){
		BtnReadCardHandler();
	}
}

function SetCardNoLength(){
	m_CardNoLength=GetCardNoLength();
	var obj=document.getElementById('CardNo');
	var objValue=obj.value;
	objValue=objValue.replace(/(^\s*)|(\s*$)/g,"");
	if (objValue!='') {
		if ((objValue.length<m_CardNoLength)&&(m_CardNoLength!=0)) {
			for (var i=(m_CardNoLength-objValue.length-1); i>=0; i--) {
				objValue="0"+objValue
			}
		}
		var myCardobj=document.getElementById('CardNo');
		if (myCardobj){
			myCardobj.value=objValue;
		}
	}
	ChangeCardTypeByCardNo('CardNo',combo_CardType,'getcardtypeclassbycardno');
} 

function GetCardNoLength(){
	var CardNoLength=0;
	var CardTypeValue=combo_CardType.getSelectedValue();
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^");
		CardNoLength=CardTypeArr[17];
	}
	if (CardNoLength>0){
		return CardNoLength;
	}else{
		return m_DefaultCardLength;
	}
}

function GetCardTypeRowId(){
	var CardTypeRowId="";
	var CardTypeValue=combo_CardType.getSelectedValue();
	
	if (CardTypeValue!=""){
		var CardTypeArr=CardTypeValue.split("^")
		CardTypeRowId=CardTypeArr[0];
	}
	return CardTypeRowId;
}

function GetCardTypeRegType(){
	var RegType="";
	var CardTypeValue=DHCC_GetElementData("CardType");
	return CardTypeValue;
}

//��鿨�Ƿ���Ч�B�����Ч��õ����Ŷ�Ӧ�Ĳ��˻�����Ϣ
function CheckCardNo() {
	//���Ҫ�뿨����һ��
	var CardNo=DHCC_GetElementData("CardNo");
	var CardTypeRowId=GetCardTypeRowId();
	if (CardNo=="") return;
	var myrtn=DHCACC_GetAccInfo(CardTypeRowId,CardNo,"","PatInfo");
	//alert(myrtn);
	var myary=myrtn.split("^");
	var rtn=myary[0];
	AccAmount=myary[3];
	switch (rtn){
		case "0": //����Ч���ʻ�
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			var NewCardTypeRowId=myary[8];
			combo_CardType.setComboValue(NewCardTypeRowId);

			var RegType=GetCardTypeRegType();
			if (RegType=="REG"){
				alert(t['CardOnlyForReg']);
				return;
			}
				
			SetPatientInfo(PatientNo,CardNo);
			break;
		case "-200": //����Ч
			alert(t['InvaildCard']);
			websys_setfocus('CardNo');
			ClearPatInfo();
			break;
		case "-201": //����Ч���ʻ�
			//alert(t['21']);
			var PatientID=myary[4];
			var PatientNo=myary[5];
			var CardNo=myary[1];
			var NewCardTypeRowId=myary[8];
			combo_CardType.setComboValue(NewCardTypeRowId);
			var RegType=GetCardTypeRegType();
			if (RegType=="��ʱҽ�ƿ�"){
				alert(t['CardOnlyForReg']);
				return;
			}
			DHCC_SelectOptionByCode("PayMode","CASH")
			SetPatientInfo(PatientNo,CardNo);
			break;
		default:
	}
}
//�õ������ò��˻�����Ϣ
function SetPatientInfo(PatientNo,CardNo){
	DHCC_SelectOptionByCode("PayMode","CPP");
	if (PatientNo!='') {
		ClearPatInfo();
		DHCC_SetElementData("PatientNo",PatientNo);
		DHCC_SetElementData("CardNo",CardNo);
		var encmeth=DHCC_GetElementData('GetDetail');
		if (encmeth!=""){
			
			if (cspRunServerMethod(encmeth,'SetPatient_Sel','',PatientNo)=='0') {
				var obj=document.getElementById('CardNo');
				obj.className='clsInvalid';
				websys_setfocus('BAppoint');
				return websys_cancel();
			}else{
				var obj=document.getElementById('CardNo');
				obj.className='';
				websys_setfocus('BAppoint');
				return websys_cancel();				
			}
		}
		} else {
			websys_setfocus('CardNo');
			return websys_cancel();
		}
}
//���
function ClearPatInfo(){
	DHCC_SetElementData("CardNo","");
	DHCC_SetElementData("PatientNo","");
	DHCC_SetElementData("PatientId","");
	DHCC_SetElementData("Name","");
	DHCC_SetElementData("Age","");
	DHCC_SetElementData("Sex","");
	DHCC_SetElementData("AppBreakCount","");
	//DHCC_SetElementData("CardType","");
}
//���ò��˻�����Ϣ
function SetPatient_Sel(value) {
	try {
		var Patdetail=value.split("^");	
		DHCC_SetElementData("Name",Patdetail[0]);
		DHCC_SetElementData("Age",Patdetail[1]);
		DHCC_SetElementData("Sex",Patdetail[2]);
    	DHCC_SetElementData("AppBreakCount",Patdetail[10]);
		DHCC_SetElementData("PatientID",Patdetail[6]);
	} catch(e) {
		alert(e.message)
	};
}
//ԤԼ
function AppointClickHandler() {
	var AppType="DOC";
	var ret=CheckBeforeAppoint(AppType);
	if (ret==false){return websys_cancel();}
	var PatientID=DHCC_GetElementData('PatientID');
	var AdmReason="";
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];	
	//�ж��Ƿ������Ч�ĺ�������¼��FalgΪ1��Ч��������ԤԼ
    var BlackFlag=tkMakeServerCall("web.DHCRBAppointment","GetLimitAppFlag",PatientID,"")
    var BlackFlag=BlackFlag.split("^")[0] //BlackFlag.split("^")[1]Ϊ��Ч���� ����ά����Ч���� ���ڴ�������ʾ��Ϣ
    if (BlackFlag==1){
	      alert("������Ч��������¼,������ԤԼ")
	      return false
	 }
	try {
		var ASRowId=DHCC_GetColumnData("TId",SelectedRow);
		var QueueNo="";
		if(TimeRangeAppExt.SeqNo1){
			QueueNo=TimeRangeAppExt.SeqNo1	
		}
		var encmeth=DHCC_GetElementData('OPRAppEncrypt');
		if (encmeth!=''){
			var ret=cspRunServerMethod(encmeth,'','',PatientID,ASRowId,QueueNo,UserID,"",AppType);
			var retArr=ret.split("^");
			if(retArr.length>1){
				alert(t["AppOK"]);
				ClearPatInfo();
				var AppID=retArr[1]
				if (AppID!=""){
					PrintAPPMesag(AppID)
				}
				//window.location.reload();
	            location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPDoc.Appoint";
	            //window.location.reload();
				if (window.parent.parent.frames["TRAK_main"]) {
					window.parent.parent.frames["TRAK_main"].location.reload();
				}
	      }else{
	      	//-201 û��ԤԼ��Դ
      		var rettip="";
      		if (retArr[0]==-203)rettip="��ͣ�������İ������ԤԼ��";
      		if (retArr[0]==-301)rettip="������ÿ��ԤԼ�޶";
      		if (retArr[0]==-302)rettip="������ÿ��ԤԼ��ͬҽ�����޶";
      		if (retArr[0]==-201)rettip="��û��ԤԼ��Դ��";
      		if (retArr[0]==-223)rettip="����ԤԼ�����ѽ�������,��ʱ�޷�ԤԼ."
      		if (retArr[0]==-303)rettip="���˲��˳���ÿ��ÿ�����ͬ�����޶�"	
			alert(t['AppFail']+","+rettip);
			ClearPatInfo();
			websys_setfocus('CardNo');
			return;
	      }
		}		
	}catch(e){alert(e.message)}	
	return websys_cancel();
}
//�Ӻ�
function AddUpdateClickHandler() {
	var AppType="DOCADD";
	var ret=CheckBeforeAppoint(AppType);
	if (ret==false){return websys_cancel();}
	var PatientID=DHCC_GetElementData('PatientID');
	var AdmReason="";
	var UserID=session['LOGON.USERID'];
	var GroupID=session['LOGON.GROUPID'];	
	try {
		var ASRowId=DHCC_GetColumnData("TId",SelectedRow);
		var QueueNo="";
		var encmeth=DHCC_GetElementData('OPRAppEncrypt');
		if (encmeth!=''){
			var ret=cspRunServerMethod(encmeth,'','',PatientID,ASRowId,QueueNo,UserID,AppType);
			var retArr=ret.split("^");
			if(retArr.length>1){
				alert("�Ӻųɹ�");
				ClearPatInfo();
				var AppID=retArr[1]
				if (AppID!=""){
					PrintAPPMesag(AppID)
				}
				//window.location.reload();
	            location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCOPDoc.Appoint";
	           // window.location.reload();
				if (window.parent.parent.frames["TRAK_main"]) {
					window.parent.parent.frames["TRAK_main"].location.reload();
				}
			  }else{
				//-201 û��ԤԼ��Դ
				var rettip="";
	      		if (retArr[0]==-203)rettip="��ͣ�������İ������ԤԼ��";
	      		if (retArr[0]==-301)rettip="������ÿ��ԤԼ�޶";
	      		if (retArr[0]==-302)rettip="������ÿ��ԤԼ��ͬҽ�����޶";
	      		if (retArr[0]==-201)rettip="��û��ԤԼ��Դ��";
	      		if (retArr[0]==-223)rettip="����ԤԼ�����ѽ�������,��ʱ�޷�ԤԼ."
	      		if (retArr[0]==-303)rettip="���˲��˳���ÿ��ÿ�����ͬ�����޶�"	
				
				alert(t['AddUpdateFail']+","+rettip);
				ClearPatInfo();
				websys_setfocus('CardNo');
				return;
			  }
		}		
	}catch(e){alert(e.message)}	
	return websys_cancel();
}
//ԤԼ֮ǰ��֤
function CheckBeforeAppoint(Type){
	//��֤���˿����ǼǺ�
	var PatientID=DHCC_GetElementData('PatientID');
	if (PatientID=="") {
		alert(t['NotSelectPatient']);	
		websys_setfocus('CardNo');
		return false;
	}
	//��֤�Ű���Ϣ
	var ASRowId=DHCC_GetColumnData("TId",SelectedRow);
	if (ASRowId==""){
		alert(t['NotSelectSchedule']);
		return false;
	}
	//ԤԼ��������
	var Today=DHCC_GetElementData("Today");
	var ScheduleDate=DHCC_GetColumnData("TScheduleDate",SelectedRow);
	if (Type=="DOCADD") {
		if (ScheduleDate!=Today){
			alert(t['NotTodayAddUpdate']);
			return false;
		}
	}else{
		if (ScheduleDate==Today){
			alert(t['NotAppToday']);
			return false;
		}
	}
	return true;
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCOPDoc_Appoint');
	if(!objtbl)	{
	   objtbl=document.getElementById('tDHCOPDoc_Appoint0');
	}
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;
	m_RowIndex=selectrow;
	if (SelectedRow==selectrow) {
		SelectedRow=0;
	}else{
		SelectedRow = selectrow;
		var Today=DHCC_GetElementData("Today");
		var ScheduleDate=DHCC_GetColumnData("TScheduleDate",SelectedRow);
		if (ScheduleDate==Today) {
			var obj=document.getElementById("BAppoint");
			if (obj) obj.style.display="none";
			var obj=document.getElementById("BAddUpdate");
			if (obj) obj.style.display="";
		}else{
			var obj=document.getElementById("BAppoint");
			if (obj) obj.style.display="";
			var obj=document.getElementById("BAddUpdate");
			if (obj) obj.style.display="none";
		}
	}
	var ASRowId=DHCC_GetColumnData("TId",selectrow);
	var date=DHCC_GetColumnData("TScheduleDate",SelectedRow);
	var Docdesc=DHCC_GetColumnData("TDocdesc",SelectedRow);
	TimeRangeAppExt.mainpanel.setTitle(date+"  "+Docdesc)

	var posElementObj=document.getElementById("TDocdesc"+'z'+SelectedRow);
	var posLeft=DHCC_getElementLeft(posElementObj);
	var posTop=DHCC_getElementTop(posElementObj)+20;
	var posStyle="" //"left:"+ posLeft + "px; top : "+ posTop + "px"+"; position : absolute" + "; overflow : auto;";
	// alert(posStyle)
	ShowTimeRange(ASRowId,objtbl.id,"DOC",posStyle);
}

//ԤԼ��ӡ�¼��뷽�� ������ԤԼ�Ĳ�ѯ����һ��
function PrintAPPMesag(AppID)
{
	DHCP_GetXMLConfig("XMLObject","DHCOPAppointPrint");
	var Rtn=tkMakeServerCall('web.DHCOPAdmReg','GetAppPrintData',AppID)
	var RtnArry=Rtn.split("^")
	var PDlime=String.fromCharCode(2);
	var MyPara="CardNo"+PDlime+RtnArry[0]+"^"+"PatNo"+PDlime+RtnArry[13]+"^"+"PatName"+PDlime+RtnArry[2]+"^"+"RegDep"+PDlime+RtnArry[6]
	var MyPara=MyPara+"^"+"SessionType"+PDlime+RtnArry[18]+"^"+"MarkDesc"+PDlime+RtnArry[7]+"^"+"Total"+PDlime+RtnArry[17];
	var MyPara=MyPara+"^"+"AdmDate"+PDlime+RtnArry[10]+"^"+"APPDate"+PDlime+RtnArry[8]+" "+RtnArry[9]+"^"+"SeqNo"+PDlime+RtnArry[4]
	var MyPara=MyPara+"^"+"UserCode"+PDlime+RtnArry[15];
	var MyPara=MyPara+"^"+"MethType"+PDlime+"["+RtnArry[16]+"]"
	var MyPara=MyPara+"^"+"AdmTimeRange"+PDlime+RtnArry[14] //�������ʱ��
	var myobj=document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj,MyPara,"")
}