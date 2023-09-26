/// DHCOPBillStayCharge.js

///Lid
///2012-06-14
///�������۽���
var m_SelectedRow = "-1";
var m_FocusRowIndex = "";
var m_CardNoLength = 0;
var m_SelectCardTypeDR = "";
var m_ReadCardFlag = 0;
var m_YBStr = ""; //���ҽ�����㷵��ֵ
//+2017-04-21 ZhYW ����ҽ����ʶ
var m_YBConFlag = "0";

var m_DELIMITER = { //����ָ��
	CH2: String.fromCharCode(2),
	CH3: String.fromCharCode(3),
	CH4: String.fromCharCode(4)
};

function BodyLoadHandler() {
	IntDocument();
}

function BodyunLoadHandler() {
	//top.close();
	//top.opener.location.reload();
}

function IntDocument() {
	var myobj = document.getElementById("CardTypeDefine");
	if (myobj) {
		myobj.size = 1;
		myobj.multiple = false;
	}
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "CardTypeDefine");
	}
	var myobj = websys_$("CardTypeDefine");
	if (myobj) {
		myobj.onchange = CardTypeDefine_OnChange;
	}
	CardTypeDefine_OnChange();
	SetItemReadOnly("PatName", true);
	SetItemReadOnly("PatSex", true);
	SetItemReadOnly("AdmReason", true);
	SetItemReadOnly("AdmCTLoc", true);
	SetItemReadOnly("AdmBedNO", true);
	SetItemReadOnly("PatTotalAmt", true);
	SetItemReadOnly("StayDeposit", true);
	SetItemReadOnly("AmountToPay", true);
	SetItemReadOnly("Balance", true);

	var obj = websys_$('ReadInsuCard');
	if (obj) {
		obj.onclick = ReadInsuCard_OnClick;
	}
	var obj = websys_$('PatientID');
	if (obj) {
		obj.onkeydown = PatientID_KeyDown;
	}
	var obj = websys_$('BtnTest');
	if (obj) {
		obj.onclick = BtnTest_OnClick;
	}
	var obj = websys_$('BtnInsuPayM');
	if (obj) {
		obj.onclick = BtnInsuPayM_OnClick;
	}
	var obj = websys_$('BtnAddPayM');
	if (obj) {
		obj.onclick = BtnAddPayM_OnClick;
	}
	var obj = websys_$('PatInsuExport');
	if (obj) {
		obj.onclick = PatInsuExport_OnClick;
	}
	var obj = websys_$('BtnStayCharge');
	if (obj) {
		obj.onclick = BtnStayCharge_OnClick;
	}
	/*
	if (obj) {
		obj.onclick = BtnChargeHandler; //2017-03-08 Lid ��׼�����۽����ȸ�Ϊ����ʵʱ����Ľӿ�.
	}
	*/
	var obj = websys_$('BtnDelPayM');
	if (obj) {
		obj.onclick = DelPayMHandler;
	}
	var obj = document.getElementById("BtnBill");
	if (obj) {
		obj.onclick = BtnBillHandler;
	}
	//ʵʱ����
	var obj = document.getElementById("BtnCharge");
	if (obj) {
		obj.onclick = BtnChargeHandler;
	}
	var obj = document.getElementById("BtnClear");
	if (obj) {
		obj.onclick = BtnClearHandler;
	}
	var obj = document.getElementById("ReceiptNO");
	if (obj) {
		obj.readOnly = true;
	}
	var obj = document.getElementById("BtnOrderDetail");
	if (obj) {
		obj.onclick = linkOrderDetail;
	}
	
	ReadYBConFlag();
	
	GetReceiptNo();
	//InitTableCellClick();
}

/**
* Creator: ZhYW
* CreatDate: 2017-04-21
* Description: ȡ����������ҽ�����ӱ�ʶ
*/
function ReadYBConFlag(){
   var encmeth = DHCWebD_GetObjValue("ReadOPBaseEncrypt");
   if (encmeth != ""){
      var myrtn = cspRunServerMethod(encmeth);
      var myary = myrtn.split('^');
      m_YBConFlag = myary[12];
   }  
}

///�����ı����ֻ������
function SetItemReadOnly(ItmName, ReadOnlyFlag) {
	var obj = websys_$(ItmName);
	if (obj) {
		obj.readOnly = ReadOnlyFlag;
	}
}

///����
function BtnClearHandler() {
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillStayCharge";
	var patframe = parent.frames["DHCOPBillStayCharge"];
	patframe.location.href = lnk;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillStayDepList";
	var patframe = parent.frames["DHCOPBillStayDepList"];
	patframe.location.href = lnk;
}

function CardTypeDefine_OnChange() {
	var myoptval = DHCWeb_GetListBoxValue("CardTypeDefine");
	var myary = myoptval.split("^");
	var myCardTypeDR = myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	if (myCardTypeDR == "") {
		return;
	}
	//Read Card Mode
	if (myary[16] == "Handle") {
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.readOnly = false;
			myobj.onkeydown = RCardNo_KeyDown;
		}
		DHCWeb_DisBtnA("ReadPCSC");
	} else {
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.readOnly = true;
		}
		var obj = document.getElementById("ReadPCSC");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, ReadHFMagCard_Click);
		}
	}
	//Set Focus
	if (myary[16] == "Handle") {
		DHCWeb_setfocus("CardNo");

	} else {
		DHCWeb_setfocus("ReadPCSC");
	}
	m_CardNoLength = myary[17];
}

///Lid
///2012-06-13
///���ݿ����޸Ŀ�����
function InitCardType(CardNO) {
	var CardNO = DHCWeb_Trim(CardNO);
	if (CardNO === "") {
		return "";
	}
	var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "GetPapmiByCardNO", CardNO);
	if (rtn == "-1") {
		return "";
	}
	var CardDataAry = rtn.split("^");
	var CardTypeDR = CardDataAry[3];
	var obj = websys_$("CardTypeDefine");
	if (obj) {
		if (obj.options.length == 0) {
			return "";
		}
		/*
		var myIdx=obj.options.selectedIndex;
		if (myIdx==-1){
			return "";
		}
		*/
		for (var i = 0; i < obj.options.length; i++) {
			var myoptval = obj.options[i].value;
			var myary = myoptval.split("^");
			var myCardTypeDR = myary[0];
			if (myCardTypeDR == CardTypeDR) {
				obj.options[i].selected = true;
				break;
			}
		}
	}
}
function SetCardNOLength() {
	var obj = document.getElementById('CardNo');
	if (obj.value != '') {
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value;
			}
		}
	}
}

function PatientID_KeyDown(e) {
	var key = websys_getKey(e);
	if ((key == 13)) {
		ReadPatInfo();
	}
}

function RCardNo_KeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var myDHCVersion = DHCWebD_GetObjValue("DHCVersion");
		//Set Card No Length;
		SetCardNOLength();
		var myCardNo = DHCWebD_GetObjValue("CardNo");
		var mySecurityNo = "";
		//var myrtn = DHCACC_GetAccInfo();
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardNo, mySecurityNo, "PatInfo");
		var myary = myrtn.split("^");
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			DHCWebD_SetObjValueB("CardNo", myary[1]);
			DHCWebD_SetObjValueB("PatientID", myary[5]);
			ReadPatInfo();
			break;
		case "-200":
			alert(t["-200"]);
			break;
		case "-201":
			DHCWebD_SetObjValueB("PatientID", myary[5]);
			ReadPatInfo();
			break;
		default:
			//alert("");
		}

		return;
	}
}

function ReadHFMagCard_Click() {
	var myCardTypeValue = DHCWeb_GetListBoxValue("CardTypeDefine");
	if (m_SelectCardTypeDR == "") {
		var myrtn = DHCACC_GetAccInfo();
	} else {
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardTypeValue);
	}
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
	case "0":
		//rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
		DHCWebD_SetObjValueB("CardNo", myary[1]);
		DHCWebD_SetObjValueB("PatientID", myary[5]);
		/*
		DHCWebD_SetObjValueB("StayDeposit", eval(myary[3]).toFixed(2));
		*/
		ReadPatInfo();
		break;
	case "-200":
		alert(t["-200"]);
		break;
	case "-201":
		DHCWebD_SetObjValueB("PatientID", myary[5]);
		ReadPatInfo();
		break;
	default:
		//alert("");
	}
}

///��ҽ����
function ReadInsuCard_OnClick() {
	try {
		var rtn = ReadCard("N");
		if ((rtn == "-1") || (rtn == "")) {
			//alert(t['ReadInsuCardErr']);
			return;
		}
		var myArr = rtn.split("|");
		var obj = document.getElementById('CardNo');
		if (obj) {
			obj.value = myArr[0];
		}
		var CardNo = myArr[0];
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, CardNo, "", "PatInfo");
		if (CardNo == "") {
			return;
		}
		var myary = myrtn.split("^");
		var rtn = myary[0];
		switch (rtn) {
		case "0":
			var PatientID = myary[4];
			var PatientNo = myary[5];
			DHCWebD_SetObjValueB("PatientID", myary[5]);
			ReadPatInfo();
			break;
		case "-200": //����Ч,InvaildCard:����Ч
			alert("����Ч");
			//websys_setfocus('RegNo');
			break;
		case "-201":     //�ֽ�,Cashpayment:ʹ���ֽ�
			var PatientID = myary[4];
			var PatientNo = myary[5];
			DHCWebD_SetObjValueB("PatientID", myary[5]);
			ReadPatInfo();
			break;
		default:
		}
	} catch (e) {
		alert("��������:" + " " + e.message);
		return;
	}
}

///��ȡ��ͬ��λ��Ϣ
function GetContractUnit() {
	try {
		var PatientID = document.getElementById("PatientID");
		if ((PatientID) && (PatientID.value != "")) {
			var PatNo = PatientID.value;
			var myExpStr = "";
			var encmeth = DHCWebD_GetObjValue('GetPAPMI');
			var PatDr = cspRunServerMethod(encmeth, PatNo, myExpStr);
			if (PatDr == "") {
				alert(t['RegNoError']);
				PatientID.className = 'clsInvalid';
				websys_setfocus('PatientID');
				return websys_cancel();
			} else {
				PatientID.className = 'clsvalid';
			}
			var encmeth = DHCWebD_GetObjValue("ContractUnitEncmeth");
			var rtn = cspRunServerMethod(encmeth, PatDr);
			var myarr = rtn.split("^");
			DHCWebD_SetObjValueB("CCRowID", myarr[0]);
		}
	} catch (e) {
		return;
	}
}

function ReadPatInfo() {
	var PatientID = document.getElementById("PatientID");
	if ((PatientID) && (PatientID.value != "")) {
		var PatNo = PatientID.value;
		var PatNo = tkMakeServerCall("web.UDHCJFBaseCommon", "regnocon", PatNo);
		PatientID.value = PatNo;
		var encmeth = DHCWebD_GetObjValue('GetPAPMI');
		var myExpStr = "";
		var PatDr = cspRunServerMethod(encmeth, PatNo, myExpStr);
		if (PatDr == "") {
			alert(t['RegNoError']);
			PatientID.className = 'clsInvalid';
			websys_setfocus('PatientID');
			return websys_cancel();
		} else {
			PatientID.className = 'clsvalid';
		}
		var AdmStr = "";
		SetPatientInfo(PatDr, AdmStr);
		GetContractUnit();
	}
}

function SetPatientInfo(PatDr) {
	var encmeth = DHCWebD_GetObjValue('GetPatInfo');
	var myExpStr = "";
	var PatInfoStr = cspRunServerMethod(encmeth, PatDr, myExpStr);
	var myary = PatInfoStr.split('^');
	if (myary[0] == "-1") {
		alert(t['NOStayStatus']);
		return;
	}
	//��־(1:��������,2:��ֹͣ����,-1:�����۲���)^AdmRowID^�ǼǺ�^����^�Ա�^����λ^����λָ��^�ѱ�^�ѱ�ָ��^����^����^����^��Ժ����^�Ƿ���Ժ
	var EpisodeID = myary[1];
	var frm = dhcsys_getmenuform();
	if (frm) {
		frm.EpisodeID.value = EpisodeID;
		if (frm.PatientID) {
			frm.PatientID.value = "";
		}
	}
	DHCWebD_SetObjValueB("StayFlag", myary[0]);
	DHCWebD_SetObjValueB("Adm", myary[1]);
	DHCWebD_SetObjValueB("EpisodeID", myary[1]);
	DHCWebD_SetObjValueB("PatientID", myary[2]);
	DHCWebD_SetObjValueB("PatName", myary[3]);
	DHCWebD_SetObjValueB("PatSex", myary[4]);
	DHCWebD_SetObjValueB("AdmReason", myary[7]);
	DHCWebD_SetObjValueB("AdmReasonDR", myary[8]);
	DHCWebD_SetObjValueB("DisDate", myary[12]);
	DHCWebD_SetObjValueB("HCPDR", myary[15]); //��ͬ��λ����ҵ����ָ��
	DHCWebD_SetObjValueB("HCPDesc", myary[16]); //��ͬ��λ����ҵ����
	DHCWebD_SetObjValueB("AccRowID", myary[17]);
	var CurrStayStat = myary[0];
	if (CurrStayStat != "2") {
		alert("δ�������۳�Ժ,�������������.");
		var obj = document.getElementById("PatInsuExport");
		if (obj) {
			DHCWeb_DisBtn(obj);
		}
		var obj = document.getElementById("BtnStayCharge");
		if (obj) {
			DHCWeb_DisBtn(obj);
		}
		var obj = document.getElementById("BtnCharge");
		if (obj) {
			DHCWeb_DisBtn(obj);
		}
	} else {
		var obj = document.getElementById("PatInsuExport");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, PatInsuExport_OnClick);
		}
		var obj = document.getElementById("BtnStayCharge");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, BtnStayCharge_OnClick);
		}
		var obj = document.getElementById("BtnCharge");
		if (obj) {
			DHCWeb_AvailabilityBtnA(obj, BtnChargeHandler);
		}
	}
	var AdmSource = GetAdmSource(myary[8]);
	if (AdmSource > 0) {
		DHCWebD_SetObjValueB("SelfFeeFlag", false);
	} else {
		DHCWebD_SetObjValueB("SelfFeeFlag", true);
	}
	DHCWebD_SetObjValueB("AdmCTLoc", myary[10]);
	DHCWebD_SetObjValueB("AdmBedNO", myary[11]);
	//ȡ�˵�RowID
	var Guser = session['LOGON.USERID'];
	var WshNetwork = new ActiveXObject("WScript.NetWork");
	var computername = WshNetwork.ComputerName;
	var myExpStr = Guser + "^" + computername + "^";
	var BillInfo = tkMakeServerCall("web.DHCOPBillStayCharge", "GetBillByAdm", EpisodeID, myExpStr);
	var myBillAry = BillInfo.split("^");
	if (myBillAry[0] == "") {
		alert(t['NOBill']);
		return;
	} else {
		DHCWebD_SetObjValueB("BillNO", myBillAry[0]);
	}
	//
	//ȡѺ����Ϣ
	var myExpStr = "^^^^";
	var leftInfo = tkMakeServerCall("web.DHCOPBillEPManageCLS", "getCurrAcountID", EpisodeID);
	var balanceAry = leftInfo.split("^");
	DHCWebD_SetObjValueB("StayDeposit", balanceAry[2]);
	//ȡ������Ϣ
	var BillNO = "";
	var myExpStr = "";
	var SatyFeeInfo = tkMakeServerCall("web.DHCOPBillStayCharge", "GetStayTotalAmt", EpisodeID, BillNO, myExpStr);
	var myFeeAry = SatyFeeInfo.split("^");
	var TotalAmt = myFeeAry[0];     //�ܷ���
	var PayorAmt = myFeeAry[2];     //���˽��
	var DiscAmt = myFeeAry[1];      //�ۿ۽��
	var PatShareAmt = myFeeAry[3];  //�Ը����
	var ReturnFlag = myFeeAry[4];   //��ҩ/�˲��ϱ�ʶ
	DHCWebD_SetObjValueB("PatTotalAmt", PatShareAmt);
	DHCWebD_SetObjValueB("PayorShareAmt", PayorAmt);
	DHCWebD_SetObjValueB("DiscAmt", DiscAmt);
	var myAccLeft = websys_$V("StayDeposit");
	var myToPay = DHCWeb_CalobjA(PatShareAmt, myAccLeft, "-");
	var myToPay = ChangeTwoDecimal_f(myToPay);
	DHCWebD_SetObjValueB("AmountToPay", myToPay);
	DHCWeb_SetColumnData("Tamounttopay", 1, myToPay); //����Ĭ��֧����ʽ�����
	DHCWebD_SetObjValueB("Balance", 0);        //ƽ���֧����ʽ�����仯ʱ����ֵҲ��Ҫ�仯
	if (ReturnFlag == "1") {
		alert("��������ֹͣ��δ�˵�ҩƷ�����ҽ��,�����˻��ٽ���.");
		var obj = document.getElementById("PatInsuExport");
		if (obj) {
			DHCWeb_DisBtn(obj);
		}
		var obj = document.getElementById("BtnStayCharge");
		if (obj) {
			DHCWeb_DisBtn(obj);
		}
		var obj = document.getElementById("BtnCharge");
		if (obj) {
			DHCWeb_DisBtn(obj);
		}
	}
	LoadStayDepList(EpisodeID);
}

///����Ѻ���б�
function LoadStayDepList(EpisodeID) {
	var AccRowID = websys_$V("AccRowID");
	parent.frames['DHCOPBillStayDepList'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillStayDepList&Adm=" + EpisodeID + "&AccountID=" + AccRowID;
}

function GetReceiptNo() {
	var obj = document.getElementById('ReceiptNO');
	if (!obj) {
		return;
	}
	var encmeth = DHCWebD_GetObjValue('GetreceipNO');
	var Guser = session['LOGON.USERID'];
	var myPINVFlag = "Y";
	var myGroupDR = session['LOGON.GROUPID'];
	var myExpStr = Guser + "^" + myPINVFlag + "^" + myGroupDR;
	if (cspRunServerMethod(encmeth, "SetReceipNO", "", myExpStr) != '0') {
		alert(t['05']);
		return;
	}
}

function SetReceipNO(value) {
	var myary = value.split("^");
	var ls_ReceipNo = myary[0];
	var obj = document.getElementById("ReceiptNO");
	if (obj) {
		obj.value = ls_ReceipNo;
	}
	DHCWebD_SetObjValueA("INVLeftNum", myary[2]);
	//change the Txt Color
	if (myary[1] != "0") {
		obj.className = 'clsInvalid';
	}
}

///�˵�
function BtnBillHandler() {
	var EpisodeID = websys_$V('EpisodeID');
	if (EpisodeID == "") {
		alert('�����Ϊ��,���ʵ.');
		return;
	}
	var Guser = session['LOGON.USERID'];
	var WshNetwork = new ActiveXObject("WScript.NetWork");
	var computername = WshNetwork.ComputerName;
	var rtn = tkMakeServerCall("web.UDHCJFBILL", "BILL", EpisodeID, Guser, "", "");
	if (rtn.split("^")[0] == 0) {
		alert("�˵��ɹ�.");
		ReadPatInfo();
	}
}

///ҽ������
function PatInsuExport_OnClick() {
	/*
	var objtbl = document.getElementById('tDHCOPBillStayCharge');
	var rows = objtbl.rows.length;
	if(rows > 2) {
		return;	//���talbe��������1��˵��ҽ���Ѿ������һ�Σ����ٵ��롣
	}
	*/
	var Guser = session['LOGON.USERID'];
	var Group = session['LOGON.GROUPID'];
	var CTLocDR = session['LOGON.CTLOCID'];
	var EpisodeID = websys_$V('EpisodeID');
	if (EpisodeID == "") {
		alert('�����Ϊ��,���ʵ.');
		return;
	}
	var AdmInsType = websys_$V('AdmReasonDR');
	if (AdmInsType == "") {
		alert("�ѱ�Ϊ��");
		return;
	}
	var AdmSource = tkMakeServerCall("web.UDHCJFBaseCommon", "GetAdmSource", AdmInsType);
	if ((AdmSource == 0) || (AdmSource == "")) {
		alert("��ҽ������,���ܵ���.");
		return;
	}
	var SelfFeeFlag = DHCWebD_GetObjValue("SelfFeeFlag");
	if (SelfFeeFlag) {
		alert("���Էѽ���,���ܵ���.");
		return;
	}
	var OrdItmRowIdStr = "";
	var BillNO = tkMakeServerCall("web.UDHCJFOPSpecialPat", "SpecialPatBill", EpisodeID, Guser, OrdItmRowIdStr, AdmInsType);
	//alert(BillNO);
	m_YBStr = OPRevEM(BillNO, Guser, 0);
	//alert(m_YBStr);
	if ("0" != m_YBStr.split("^")[0]) {
		alert("ҽ���������.");
		m_YBStr = "";
		return;
	}
	/*
	//����ҽ������ֵ 	//��ʽ��rtn^DHC_InsuDivideRowID^PatShareSum^DHCINVRowID_"^"_PayMode_DR_$c(2)_PayMode_DR^12.01_$c(2)_PayMode_DR^20_$c(3)_��Ʊ2
	var myAry1 = m_YBStr.split(m_DELIMITER.CH3);
	var myAry2 = myAry1[0].split(m_DELIMITER.CH2);
	var StayDepAmt = websys_$V('StayDeposit');	//����Ѻ��
	var IsAddRow = true;
	for(var i = myAry2.length - 1; i >= 0; i--){
		if(i == 0) {
			var tmpAry = myAry2[i].split("^");
			var PayMAmt = tmpAry[2];			//�Էѽ��
			//var PayMDR = tmpAry[4];			//�ԷѲ���֧����ʽ
			var PayMDR = 4;
			var PayMAmt=eval(PayMAmt)-eval(StayDepAmt);
		}else {
			var tmpAry = myAry2[i].split("^");
			var PayMAmt = tmpAry[1];	        //���
			var PayMDR = tmpAry[0];			    //֧����ʽ
	}
	var PayMInfo = tkMakeServerCall("web.UDHCJFBaseCommon","GetPayMDesc",PayMDR);
	var PayMDesc = PayMInfo.split("^")[1];
	if(i == 0){
		IsAddRow = false;
	}
		AddInsuPayM(PayMDesc, PayMDR, PayMAmt, IsAddRow);
	}
	//�������
	var PatShareAmt = m_YBStr.split("^")[2];
	var BalanceAmt = eval(PatShareAmt)-eval(StayDepAmt);
	BalanceAmt = ChangeTwoDecimal_f(BalanceAmt);
	DHCWebD_SetObjValueB("AmountToPay", BalanceAmt);
	//DHCWebD_SetObjValueB("Balance", BalanceAmt);
	CalcBalance();
	*/
}

///HIS����--����Э��
function BtnStayCharge_OnClick() {
	//BtnBillHandler();	      //����ǰ���˵�һ��
	var myrtn = window.confirm("�Ƿ�ȷ�Ͻ���?");
	if (!myrtn) {
		return myrtn;
	}
	var Guser = session['LOGON.USERID'];
	var Group = session['LOGON.GROUPID'];
	var CTLocDR = session['LOGON.CTLOCID'];
	var HospitalDR = session['LOGON.HOSPID'];
	var SelfFeeFlag = DHCWebD_GetObjValue("SelfFeeFlag");
	var EpisodeID = websys_$V('EpisodeID');
	if (EpisodeID == "") {
		alert("�޾�����Ϣ.");
		return;
	}
	var stayRtn = tkMakeServerCall("web.UDHCJFBaseCommon", "GetObsPatYetDisHosp", EpisodeID);
	if (stayRtn != 1) {
		alert("�˻���δ��Ժ,���ܽ���.");
		return;
		/*
		var myrtn = window.confirm("�˻���δ��Ժ,�Ƿ�ȷ�Ͻ���?");
		if(!myrtn) {
			return myrtn;
		}
		*/
	}
	var StayFlag = GetPatAdmStat(EpisodeID);
	if (StayFlag != "Y") {
		alert("�����۲���,���ʵ.");
		return;
	}
	//add hujunbin 15.2.3 �жϵ�ǰ�����˻�
	var currAccount = getCurrentAccount(EpisodeID);
	if (currAccount == "") {
		alert("���Ƚ�Ѻ����ٽ��н���.");
		return;
	}
	var InsType = websys_$V('AdmReasonDR');
	var AdmSource = GetAdmSource(InsType);
	var InvRequireFlag = "Y";                     //Ĭ�ϴ�ӡ��Ʊ
	if ((!SelfFeeFlag) && (AdmSource > 0)) {
		//InvRequireFlag = "N";		              //ҽ���������۽��㲿��ӡ��Ʊ; ע�ͣ�Э��Ҫ������Ҳ�߸�Ʊ��
	}
	if ((websys_$V("Balance") != 0) && (websys_$V("Balance") != 0.00)) {
		alert("��ƽ,���ʵ.");
		return;
	}
	var CCRowID = websys_$V("CCRowID");    //��ͬ��λָ��
	var PayModeDR = tkMakeServerCall("web.DHCOPBillStayCharge", "GetPayMDrByPayMCode", "ECPP");
	var PayInfo = PayModeDR + "^^^^" + CCRowID + "^^";         //���۲���ʵʱ����
	var PatPaySum = websys_$V('PatTotalAmt');                  //�ܷ���
	if (+PatPaySum == 0) {
		alert("�޷��ò������.");
		return;
	}
	var StayDeposit = websys_$V('StayDeposit');
	var SFlag = 0;                                             //0:�շѣ�1:�˷�
	var OldInvID = "";
	var ReadInfoType = "0";
	var FairType = "F";
	var AccRowID = websys_$V("AccRowID");
	var SelfFeeFlagVal = DHCWebD_GetObjValue("SelfFeeFlag") ? 1 : 0;
	var unordstr = "";    //���۲���Ĭ�Ͻ���ȫ��ҽ��
	var myExpStr = Group + "^" + CTLocDR + "^" + AccRowID;
	myExpStr += "^" + InvRequireFlag;
	myExpStr += "^" + FairType;
	myExpStr += "^" + "";
	myExpStr += "^" + "";
	myExpStr += "^" + "";
	myExpStr += "^" + "";
	myExpStr += "^" + "";
	myExpStr += "^" + StayFlag;
	var encmeth = DHCWebD_GetObjValue('OPBillFootEncrypt');
	if (encmeth != "") {
		var rtnValue = cspRunServerMethod(encmeth, EpisodeID, Guser, unordstr, InsType, PatPaySum, PayInfo, Group, SFlag, OldInvID, ReadInfoType, myExpStr);
		var myConAry = rtnValue.split(String.fromCharCode(2));
		var billary = myConAry[0].split("^");
		var myary = rtnValue.split("^");
		if (myary[0] == "0") {
			//+2017-04-21 ZhYW ����ҽ������
			var myPLen = billary.length;
			var mytmpary = new Array();
			for (var i = 1; i < myPLen; i++) {
				if (billary[i] != "") {
					mytmpary[mytmpary.length] = billary[i];
				}
			}
			var myPRTStr = mytmpary.join("^");
			if ((SelfFeeFlagVal == 0) && (+m_YBConFlag == 1) && (+AdmSource > 0)) {
				var myYBHand = "";
				var myCPPFlag = "ECPP";
				var StrikeFlag = "N";
				var InsuNo = "";
				var CardType = "";
				var YLLB = "";
				var DicCode = "";
				var DicDesc = "";
				var DYLB = "";
				var ChargeSource = "01";  // ������Դ
				var DBConStr = "";        //���ݿ����Ӵ�
				var LeftAmt = StayDeposit;
				var MoneyType = "";
				var SelPayMDR = "";
				var myExpStrYB = StrikeFlag + "^" + Group + "^" + InsuNo + "^" + CardType + "^" + YLLB + "^" + DicCode + "^" + DicDesc;
				myExpStrYB += "^" + LeftAmt + "^" + ChargeSource + "^" + DBConStr + "^" + DYLB + "^" + AccRowID + "^" + HospitalDR + "^" + SelPayMDR + "!" + LeftAmt + "^" + MoneyType;
				var myYBRtn = DHCWebOPYB_DataUpdate(myYBHand, Guser, myPRTStr, AdmSource, InsType, myExpStrYB, myCPPFlag);
				var myYBarry = myYBRtn.split("^");
				if (myYBarry[0] == "YBCancle") {
					return;
				}
				if (myYBarry[0] == "HisCancleFailed") {
					alert(t["HisCancleFailed"]);
					return;
				}
				window.status = t['InsuBillFinished'];
			}
			var myPRTStr = tkMakeServerCall("web.DHCBillCons12", "ValidatePrtRowID", myPRTStr);
			//�����շ�ȷ�����
			var encmeth = DHCWebD_GetObjValue('CompleteChargeEncrypt');
			var rtn = cspRunServerMethod(encmeth, "3", Guser, InsType, myPRTStr, "0", OldInvID, myExpStr);
			if (rtn != "0") {
				alert(t['CompleteFailed']);
				return;
			}
			//���²�������־
			rtn = tkMakeServerCall("web.DHCOPBillStayCharge", "UpdateBillFlag", EpisodeID, 'Y', "");
			//
			BillPrintNew(myary[1]);
			/*
			if ((AdmSource == "0") || (AdmSource == "")) {
				//ҽ�����������Ž����ӡ��ϸ
				BillPrintList(myary[1]);
			}
			*/
			alert("����ɹ�.");
			BtnClearHandler();
		} else {
			//2017-12-19 ZhYW
			var myAry = rtnValue.split(String.fromCharCode(3));
			chargeFail_alert('preChargeFail', myAry[0], myAry[1]);
		}
	}
}


///HIS����
function BtnStayCharge_OnClickOLD() {
	var myrtn = window.confirm("�Ƿ�ȷ�Ͻ���?");
	if (!myrtn) {
		return myrtn;
	}
	var Guser = session['LOGON.USERID'];
	var Group = session['LOGON.GROUPID'];
	var CTLocDR = session['LOGON.CTLOCID'];
	var HospitalDR = session['LOGON.HOSPID'];
	var SelfFeeFlag = DHCWebD_GetObjValue("SelfFeeFlag");
	var EpisodeID = websys_$V('EpisodeID');
	if (EpisodeID == "") {
		alert("�޾�����Ϣ.");
		return;
	}
	var StayFlag = GetPatAdmStat(EpisodeID);
	if (StayFlag != "Y") {
		alert("�����۲���,���ʵ.");
		return;
	}
	var InsType = websys_$V('AdmReasonDR');
	var AdmSource = GetAdmSource(InsType);
	if (!SelfFeeFlag) {
		if ((AdmSource > 0) & ("0" != m_YBStr.split("^")[0])) {
			alert("ҽ������ʧ��.");
			return;
		}
		if ((AdmSource > 0) & (m_YBStr == "")) {
			alert("ҽ������������ҽ������.");
			return;
		}
	}
	if (eval(websys_$V("AmountToPay")) >= 0) {
		alert("Ѻ�����,���ܽ���.");
		return;
	}
	if ((websys_$V("Balance") != 0) && (websys_$V("Balance") != 0.00)) {
		alert("��ƽ,���ʵ.");
		return;
	}
	var PayInfo = BuildPayStr();
	//alert(PayInfo);
	var PatPaySum = websys_$V('PatTotalAmt'); //�ܷ���
	var StayDeposit = websys_$V('StayDeposit');
	var SFlag = 0;              //0:�շѣ�1:�˷�
	var OldInvID = "";
	var ReadInfoType = "0";
	var InvRequireFlag = "Y";   //Ĭ�ϴ�ӡ��Ʊ
	var FairType = "F";
	var SelfFeeFlagVal = DHCWebD_GetObjValue("SelfFeeFlag") ? 1 : 0;
	var ExpStr = Group + "^" + CTLocDR + "^" + HospitalDR + "^" + InvRequireFlag + "^" + FairType + "^" + SelfFeeFlagVal + "^";
	var rtnValue = tkMakeServerCall("web.DHCOPBillStayCharge", "StayCharge", EpisodeID, StayFlag, Guser, InsType, PatPaySum, PayInfo, StayDeposit, SFlag, OldInvID, ReadInfoType, m_YBStr, ExpStr);
	//alert(rtnValue);
	var myary = rtnValue.split("^");
	if (myary[0] == "0") {
		BillPrintNew(myary[1]);
		alert("����ɹ�.");
	} else {
		alert("����ʧ��.");
	}
}


function BtnChargeHandler() {
	//BtnBillHandler();	   //����ǰ���˵�һ��
	var myrtn = window.confirm("�Ƿ�ȷ�Ͻ���?");
	if (!myrtn) {
		return myrtn;
	}
	var Guser = session['LOGON.USERID'];
	var Group = session['LOGON.GROUPID'];
	var CTLocDR = session['LOGON.CTLOCID'];
	var HospitalDR = session['LOGON.HOSPID'];
	var SelfFeeFlag = DHCWebD_GetObjValue("SelfFeeFlag");
	var EpisodeID = websys_$V('EpisodeID');
	if (EpisodeID == "") {
		alert("�޾�����Ϣ.");
		return;
	}
	var stayRtn = tkMakeServerCall("web.UDHCJFBaseCommon", "GetObsPatYetDisHosp", EpisodeID);
	if (stayRtn != "1") {
		alert("�˻���δ��Ժ,���ܽ���.");
		return;
		/*
		var myrtn = window.confirm("�˻���δ��Ժ,�Ƿ�ȷ�Ͻ���?");
		if(!myrtn) {
			return myrtn;
		}
		*/
	}
	var StayFlag = GetPatAdmStat(EpisodeID);
	if (StayFlag != "Y") {
		alert("�����۲���,���ʵ.");
		return;
	}
	//add hujunbin 15.2.3 �жϵ�ǰ�����˻�
	var currAccount = getCurrentAccount(EpisodeID);
	if (currAccount == "") {
		alert("���Ƚ�Ѻ����ٽ��н���.");
		return;
	}
	var InsType = websys_$V('AdmReasonDR');
	var AdmSource = GetAdmSource(InsType);
	var InvRequireFlag = "Y";                     //Ĭ�ϴ�ӡ��Ʊ
	if ((!SelfFeeFlag) && (AdmSource > 0)) {
		//InvRequireFlag = "N";		              //ҽ���������۽��㲿��ӡ��Ʊ; ע�ͣ�Э��Ҫ������Ҳ�߸�Ʊ��
	}
	if (!SelfFeeFlag) {
		if ((AdmSource > 0) & ("0" != m_YBStr.split("^")[0])) {
			alert("ҽ������ʧ��.");
			return;
		}
		if ((AdmSource > 0) & (m_YBStr == "")) {
			alert("ҽ������������ҽ������.");
			return;
		}
	}

	if ((websys_$V("Balance") != 0) && (websys_$V("Balance") != 0.00)) {
		alert("��ƽ,���ʵ.");
		return;
	}
	//var PayInfo = BuildPayStr();
	var PayInfo = "";
	var PatPaySum = websys_$V('PatTotalAmt');    //�ܷ���
	var StayDeposit = websys_$V('StayDeposit');
	var SFlag = 0; //0:�շѣ�1:�˷�
	var OldInvID = "";
	var ReadInfoType = "0";
	var FairType = "F";
	var AccRowID = websys_$V("AccRowID");
	var SelfFeeFlagVal = DHCWebD_GetObjValue("SelfFeeFlag") ? 1 : 0;
	var ExpStr = Group + "^" + CTLocDR + "^" + HospitalDR + "^" + InvRequireFlag + "^" + FairType + "^" + SelfFeeFlagVal + "^" + AccRowID;
	//alert(ExpStr);
	var rtnValue = tkMakeServerCall("web.DHCOPBillStayCharge", "StayCharge", EpisodeID, StayFlag, Guser, InsType, PatPaySum, PayInfo, StayDeposit, SFlag, OldInvID, ReadInfoType, m_YBStr, ExpStr);
	//alert(rtnValue);
	var myary = rtnValue.split("^");
	if (myary[0] == "0") {
		BillPrintNew(myary[1]);
		if ((AdmSource == "0") || (AdmSource == "")) {
			//ҽ�����������Ž����ӡ��ϸ
			//BillPrintList(myary[1]);
		}
		alert("����ɹ�.");
		BtnClearHandler();

	} else if (myary[0] == "100") {
		alert("Ѻ���㣬���Ƚ�Ѻ��.");
	} else {
		alert(myary[0] + " :����ʧ��.");
	}
}

function BillPrintNew(INVstr) {
	var PrtXMLName = "INVPrtFlag2007"; //��Ʊģ��
	DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName);
	if (PrtXMLName == "") {
		return;
	}
	var INVtmp = (INVstr.toString()).split("^");
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = DHCWebD_GetObjValue('getSendtoPrintinfo');
			var PayMode = "";
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myCurGroupDR = session['LOGON.GROUPID'];
			var myExpStr = "^^" + myCurGroupDR;
			//GetInvoicePrtDetail(JSFunName As %String,InvRowID, UseID , PayMode
			//ע��:ҽ�����˲���HIS��ӡ��Ʊ
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", PrtXMLName, INVtmp[invi], sUserCode, PayMode, myExpStr);
		}
	}
}

///��ӡ��ϸ�嵥
function BillPrintList(INVstr) {
	var PrtXMLName = "InvPrintList"; //��ϸģ��
	DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName);
	if (PrtXMLName == "") {
		return;
	}
	var INVtmp = (INVstr.toString()).split("^");
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var encmeth = DHCWebD_GetObjValue('getSendtoPrintinfo');
			var PayMode = "";
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			var myCurGroupDR = session['LOGON.GROUPID'];
			var myExpStr = "" + "^" + "" + "^" + myCurGroupDR + "^" + "";
			//GetInvoicePrtDetail(JSFunName As %String,InvRowID, UseID , PayMode
			//ע��:ҽ�����˲���HIS��ӡ��Ʊ
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", PrtXMLName, INVtmp[invi], sUserCode, PayMode, myExpStr);
		}
	}
	var PrtXMLName = "INVPrtFlag2007"; //���¼��ط�Ʊģ�巢Ʊģ��
	DHCP_GetXMLConfig("InvPrintEncrypt", PrtXMLName);
}

function InvPrintNew(TxtInfo, ListInfo) {
	//var encmeth = DHCWebD_GetObjValue('TestPrint');
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
}

function BuildPayStr() {
	var tempstr1;
	var tempstr = "";
	var payamt = 0;
	var Sum = 0;
	var Objtbl = document.getElementById('tDHCOPBillStayCharge');
	var Rows = Objtbl.rows.length - 1;
	for (i = 1; i <= Rows; i++) {
		var Tpaymode = document.getElementById("Tpaymodez" + i);
		var Tbank = document.getElementById("Tbankz" + i);
		//var Tbanksub = document.getElementById("Tbanksubz"+i);
		var Tcheque = document.getElementById("Tchequez" + i);
		var Tunit = document.getElementById("Tunitz" + i);
		var Taccount = document.getElementById("Taccountz" + i);
		var Tamounttopay = document.getElementById("Tamounttopayz" + i);
		if (Tamounttopay.tagName == 'LABEL') {
			payamt = Tamounttopay.innerText;
		} else {
			payamt = Tamounttopay.value;
		}
		if ((DHCWeb_Trim(payamt) == "") || (+payamt == 0)) {
			//continue;
		}
		Sum = eval(Sum) + eval(payamt);
		tempstr1 = Tpaymode.value + "^" + Tbank.value + "@" + "" + "^" + Tcheque.innerText + "^" + Tunit.innerText + "^" + Taccount.innerText + "^" + payamt;
		tempstr = tempstr + "&" + tempstr1;
	}
	Sum = Sum.toFixed(2);
	var pay = websys_$V('AmountToPay');
	tempstr = "&" + pay + tempstr;
	return tempstr;
}

//yyx 2009-10-15 ҽ��
function GetAdmSource(CurInsType) {
	var encmeth = DHCWebD_GetObjValue('GetAdmSource');
	var AdmSource = cspRunServerMethod(encmeth, CurInsType);
	return AdmSource;
}

///Creator:yyx
///CreateDate:2010-12-14
///Function :ȡ����״̬
function GetPatAdmStat(AdmStr) {
	var PatAdmStat = tkMakeServerCall("web.UDHCJFBaseCommon", "GetPatAdmStayStat", AdmStr);
	return PatAdmStat.split("^")[0];
}

function BtnTest_OnClick() {
}

function tk_ResetRowItemst(objtbl) {
	for (var i = 0; i < objtbl.rows.length; i++) {
		var objrow = objtbl.rows[i];
		if ((i + 1) % 2 == 0) {
			objrow.className = "RowEven";
		} else {
			objrow.className = "RowOdd";
		}
		var rowitems = objrow.all; //IE only
		if (!rowitems){
			rowitems = objrow.getElementsByTagName("*"); //N6
		}
		for (var j = 0; j < rowitems.length; j++) {
			if (rowitems[j].id) {
				var arrId = rowitems[j].id.split("z");
				arrId[arrId.length - 1] = i + 1;
				rowitems[j].id = arrId.join("z");
				rowitems[j].name = arrId.join("z");
			}
		}
	}
}

function tAddRowOLD(objtbl) {
	tk_ResetRowItemst(objtbl);
	var row = objtbl.rows.length;
	var objlastrow = objtbl.rows[row - 1];
	//make sure objtbl is the tbody element
	objtbl = websys_getParentElement(objlastrow);
	var objnewrow = objlastrow.cloneNode(true);
	var rowitems = objnewrow.all; //IE only
	if (!rowitems) {
		rowitems = objnewrow.getElementsByTagName("*"); //N6
	}
	for (var j = 0; j < rowitems.length; j++) {
		if (rowitems[j].id) {
			var Id = rowitems[j].id;
			var arrId = Id.split("z");
			arrId[arrId.length - 1] = row;
			rowitems[j].id = arrId.join("z");
			rowitems[j].name = arrId.join("z");
			if (rowitems[j].tagName == 'LABEL') {
				rowitems[j].innerText = "";
			} else {
				rowitems[j].value = "";
			}
			rowitems[j].onclick = function () {
				ReplaceNode(this);
			}
		}
	}
	objnewrow = objtbl.appendChild(objnewrow);
	if ((objnewrow.rowIndex) % 2 == 0) {
		objnewrow.className = "RowOdd";
	} else {
		objnewrow.className = "RowEven";
	}
}

function InitTableCellClick() {
	var objtbl = document.getElementById('tDHCOPBillStayCharge');
	for (var i = 0; i < objtbl.rows.length; i++) {
		var objrow = objtbl.rows[i];
		var rowitems = objrow.all; //IE only
		if (!rowitems) {
			rowitems = objrow.getElementsByTagName("*"); //N6
		}
		for (var j = 0; j < rowitems.length; j++) {
			if (rowitems[j].id) {
				var arrId = rowitems[j].id.split("z");
				rowitems[j].onclick = function () {
					//alert(this.id+":"+this.name+":"+this.parentNode.cellIndex);
					//alert(this.name.indexOf("Tcheque"));
					//ReplaceNode(this);
				};
				//alert(rowitems[j].parentNode.style.width);
				rowitems[j].style.width = rowitems[j].parentNode.style.width;
				rowitems[j].style.height = rowitems[j].parentNode.style.height;
			}
		}
	}
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var rowobj = getRow(eSrc);
	var Objtbl = document.getElementById('tDHCOPBillStayCharge');
	var Rows = Objtbl.rows.length;
	var lastrowindex = Rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) {
		return;
	}
	if (selectrow != m_SelectedRow) {
		m_FocusRowIndex = selectrow;
		m_SelectedRow = selectrow;
	} else {
		//rowobj.className = '';    //��������ɫ
	}
}

function ReplaceNode(me) {
	var SelRowObj = me.parentNode.parentNode;
	//SelRowObj.className = 'clsRowSelected'; //��������ɫ
	var RowIndex = SelRowObj.rowIndex;
	m_FocusRowIndex = RowIndex;
	if ((me.name.indexOf("Tcheque") >= 0) || (me.name.indexOf("Tunit") >= 0) || (me.name.indexOf("Tamounttopay") >= 0) || (me.name.indexOf("Taccount") >= 0)) {
		//SelectedRow = RowIndex;
		var IsReplaceNode = CanReplaceNode(RowIndex);
		if (!IsReplaceNode) {
			return;
		}
		var obj = document.createElement("input");
		//obj.type = "text";
		obj.id = me.id;
		obj.name = me.name;
		obj.style.textAlign = "right";
		if (!(me.name.indexOf("Tunit") >= 0)) {
			obj.onkeypress = DHCWeb_ValidateFloat; //DHCWeb_SetLimitFloat;
		}
		if (me.tagName == 'LABEL') {
			obj.value = me.innerText;
		} else {
			obj.value = me.value;
		}
		obj.style.width = me.parentNode.style.width; //WIDTH: 152px; HEIGHT=
		obj.style.height = me.parentNode.style.height;
		obj.onclick = function () {
			//alert(me.value);
		}
		var OldNote = me;
		var ParentOldNote = me.parentNode;
		obj.onkeydown = function (e) {
			var key = websys_getKey(e);
			if (key == 13) {
				if (this.parentNode.nextSibling) {
					var NextNode = this.parentNode.nextSibling.childNodes[0];
					ReplaceNode(NextNode);
				} else {
					CalcSTAmt(this);
				}
			}
		}
		obj.onblur = function (e) {
			OldNote.id = this.id;
			OldNote.name = this.name;
			OldNote.innerText = this.value;
			OldNote.style.width = this.style.width; //WIDTH: 152px; HEIGHT=
			OldNote.style.height = this.style.height;
			this.parentNode.replaceChild(OldNote, this);
			CalcBalance(); //����ƽ����
		}
		me.parentNode.replaceChild(obj, me);
		websys_setfocus(me.name);
	}
}

function CalcSTAmt(me) {
	if (me.name.indexOf("Tamounttopay") >= 0) {
		var Balance = websys_$V('Balance');
		var reg = new RegExp(/^(([-,1-9]\d*)|\d)(\.\d{1,2})?$/);
		if (reg.test(me.value.toString())) {
			var RowIndex = me.parentNode.parentNode.rowIndex;
			var TblObj = document.getElementById('tDHCOPBillStayCharge');
			var TblRowCount = TblObj.rows.length;
			var PayMDR = DHCWeb_GetColumnData("Tpaymode", RowIndex);
			var Vali = ValidateRefundAmt(PayMDR, me.value);
			if (!Vali) {
				alert("�˷ѽ��ܴ���Ѻ����");
				SetFocusColumn("Tamounttopay", RowIndex);
				return;
			}
			CalcBalance();
			/*
			var tmpBalance = websys_$V('Balance');
			if((tmpBalance != "0") && (tmpBalance != "0.00")){
				if(RowIndex == (TblRowCount - 1)){
					//��ǰ�������һ��,����Ҫ����һ��
					AddRowHandler();
				}
				var NextRowIndex = RowIndex + 1;
				DHCWeb_SetColumnData("Tamounttopay", NextRowIndex, tmpBalance);
				SetFocusColumn("Tamounttopay", NextRowIndex);
				CalcBalance();
			}
			*/
		}
	}
}

///����ƽ����
function CalcBalance() {
	var tempAmt = 0;
	var Objtbl = document.getElementById('tDHCOPBillStayCharge');
	var Rows = Objtbl.rows.length - 1;
	for (i = 1; i <= Rows; i++) {
		var Tpaymode = document.getElementById("Tpaymodez" + i).value;
		var Tamounttopay = document.getElementById("Tamounttopayz" + i);
		if ((Tpaymode == "6") || (Tpaymode == "12") || (Tpaymode == "7")) {
			continue; //����ҽ��֧����ʽ,�˴�д����
		}
		if (Tamounttopay.tagName == 'LABEL') {
			payamt = Tamounttopay.innerText;
		} else {
			payamt = Tamounttopay.value;
		}
		tempAmt = eval(tempAmt) + eval(payamt);
	}
	var tmpBalance = websys_$V("AmountToPay") - tempAmt;
	tmpBalance = ChangeTwoDecimal_f(tmpBalance);
	DHCWebD_SetObjValueB("Balance", tmpBalance);
}

function BtnInsuPayM_OnClick() {
	/*
	var objtbl = document.getElementById('tDHCOPBillStayCharge');
	AddInsuPayM("ҽ������֧��","6",100);
	AddInsuPayM("ҽ���˻�֧��","12",200);
	AddInsuPayM("�ֽ�","1",185.58);
	*/
}
function AddInsuPayM(PayMDesc, PayMDR, PayMAmt, IsAddRow) {
	var objtbl = document.getElementById('tDHCOPBillStayCharge');
	var rows = objtbl.rows.length;
	var LastRow = rows - 1;
	var Row = LastRow;
	var Tpaymode = document.getElementById("Tpaymodez" + Row);
	DHCWebD_ClearAllListA("Tpaymodez" + Row);
	var OptionLength = Tpaymode.options.length;
	var option = new Option(PayMDesc, PayMDR);
	Tpaymode.add(option);
	Tpaymode.options[OptionLength].selected = true;
	//Tpaymode.disabled = "disabled";
	//var TbankObj = document.getElementById("Tbankz"+Row);
	var AmountToPayObj = document.getElementById("Tamounttopayz" + Row);
	if (AmountToPayObj.tagName == 'LABEL') {
		AmountToPayObj.innerText = ChangeTwoDecimal_f(PayMAmt);
	} else {
		AmountToPayObj.value = ChangeTwoDecimal_f(PayMAmt);
	}
	Tpaymode.disabled = false;
	//TbankObj.disabled = false;
	var IsReplaceNode = CanReplaceNode(Row);
	if (!IsReplaceNode) {
		//ҽ��֧����ʽ�����޸�
		Tpaymode.disabled = true;
		//TbankObj.disabled = true;
	}
	if (IsAddRow) {
		AddRowHandler();
	}
}

///����һ������
function AddRowHandler() {
	//try {
	var objtbl = document.getElementById('tDHCOPBillStayCharge');
	var ret = CanAddRow(objtbl);
	var ret = true;
	if (ret) {
		tAddRow(objtbl);
	}
	//���Կ�����Ļ������
	return false;
	//} catch(e) {alert(e.message);};
}

function BtnAddPayM_OnClick() {
	//���ӿ���
	AddRowHandler();
	//��ƽ����ŵ������ӵ��У�Ȼ�������½���һ��ƽ���
	var objtbl = document.getElementById('tDHCOPBillStayCharge');
	var rows = objtbl.rows.length;
	var LastRow = rows - 1;
	var tmpBalance = websys_$V("Balance");
	DHCWeb_SetColumnData("Tamounttopay", LastRow, tmpBalance);
	CalcBalance();
}

function DelPayMHandler() {
	if (m_FocusRowIndex == 1) {
		return;
	}
	/*
	if(m_SelectedRow == "-1"){
		return;
	}
	*/
	var objtbl = document.getElementById('tDHCOPBillStayCharge');
	var rows = objtbl.rows.length;
	var LastRow = rows - 1;
	if (LastRow != m_FocusRowIndex) {
		alert("ֻ��ɾ�����һ��.");
		return;
	}
	/*
	var SelRowObj = document.getElementById('TInsuFlagz' + selectrow0);
	if ((SelRowObj) && (SelRowObj.innerText == "Y")) {
		alert("ҽ��֧����ʽ����ɾ��");
		return;
	}
	*/
	var DelRowAmt = DHCWeb_GetColumnData("Tamounttopay", m_FocusRowIndex); //��¼ɾ���Ľ��
	objtbl.deleteRow(m_FocusRowIndex);
	if (DHCWeb_Trim(DelRowAmt) == "") { //ɾ���е�֧������ʱ,��ת��Ϊ0
		DelRowAmt = 0;
	}
	var tmpAmt = eval(websys_$V("Balance")) + eval(DelRowAmt); //����ƽ����
	DHCWebD_SetObjValueB("Balance", tmpAmt);
}

///��֤֧����ʽ���˷ѽ��,һֱ֧����ʽ���˷ѽ��ܴ���Ѻ����
///true:�����˷ѣ�false:�����˷�
function ValidateRefundAmt(PayMDR, PayMAmt) {
	var EpisodeID = websys_$V('EpisodeID');
	var rtn = tkMakeServerCall("web.DHCOPBillStayCharge", "ValidateRefundAmt", EpisodeID, PayMDR, PayMAmt);
	if (rtn == "0") {
		return true;
	}
	return false;
}

function tAddRow(objtbl) {
	var rows = objtbl.rows.length;
	var objlastrow = objtbl.rows[rows - 1];
	//make sure objtbl is the tbody element,
	//֮����Ҫ��tk_getTBody?����ΪTBody������THead,����TBodyֻ��appendChild,��ֻ��ͨ��rowobj����ȡ��TBody
	//tUDHCOEOrder_List_Custom�ǰ���THeader��Tbody
	//tUDHCOEOrder_List_Custom.rows��TBody.rows�ǲ�ͬ��?����һ���ǰ����1
	objtbody = tk_getTBody(objlastrow);
	//objtbl=websys_getParentElement(objlastrow);
	var objnewrow = objlastrow.cloneNode(true);
	var rowitems = objnewrow.all; //IE only
	if (!rowitems) {
		rowitems = objnewrow.getElementsByTagName("*"); //N6
	}
	for (var j = 0; j < rowitems.length; j++) {
		if (rowitems[j].id) {
			var Id = rowitems[j].id;
			var arrId = Id.split("z");
			arrId[arrId.length - 1] = parseInt(arrId[arrId.length - 1]) + 1;
			rowitems[j].id = arrId.join("z");
			rowitems[j].name = arrId.join("z");
			//rowitems��ʵ��element�ļ���,ÿ��element��ParentElement����Tabelobj.RowObj.Cell����
			//��element�����͸ı�,ʵ�����Ǹı�Cell��innerHTML,��Ϊelement.style�ǲ�����ı��
			/*
			if (arrId[0] == "OrderPrior"){
				var obj = websys_getParentElement(rowitems[j]);
				var str = "<input type=text id=\""+Id+"\" name=\""+Id+ "\" style=\"width:" + obj.style.width +"\" value=\"\">";
				obj.innerHTML = str;
			}
			*/
			rowitems[j].onclick = function () {
				//ReplaceNode(this);
			}
			if (rowitems[j].tagName == 'LABEL') {
				rowitems[j].innerText = "";
			} else {
				rowitems[j].value = "";
			}
		}
	}
	objnewrow = objtbody.appendChild(objnewrow);
	if ((objnewrow.rowIndex) % 2 == 0) {
		objnewrow.className = "RowEven";
	} else {
		objnewrow.className = "RowOdd";
	}
}

///true:�������һ��
///false:���������
function CanAddRow(objtbl) {
	var rows = objtbl.rows.length;
	if (rows == 1) {
		return false;
	}
	var Row = GetRow(rows - 1);
	return true;
}

///true:�����滻�ڵ�Ԫ��
///false:�����滻�ڵ�Ԫ��
function CanReplaceNode(RowIndex) {
	var ColValue = DHCWeb_GetColumnData("Tpaymode", RowIndex);
	if ((ColValue == "6") || (ColValue == "12")) {
		//ҽ��֧����ʽ
		//�˴�д����,ȡ����ct_paymode ���Rowid
		return false;
	}
	return true;
}

function GetRow(Rowindex) {
	var objtbl = document.getElementById('tDHCOPBillStayCharge');
	var RowObj = objtbl.rows[Rowindex];
	var rowitems = RowObj.all;
	if (!rowitems) {
		rowitems = RowObj.getElementsByTagName("LABEL");
	}
	for (var j = 0; j < rowitems.length; j++) {
		if (rowitems[j].id) {
			var Id = rowitems[j].id;
			var arrId = Id.split("z");
			var Row = arrId[arrId.length - 1];
		}
	}
	return Row;
}

function SetFocusColumn(ColName, Row) {
	var obj = document.getElementById(ColName + "z" + Row);
	if (obj) {
		websys_setfocus(ColName + "z" + Row);
	}
}

function SetCellStyle(ColName, Row, val) {
	var CellObj = document.getElementById(ColName + "z" + Row);
	if (CellObj) {
		CellObj.style.visibility = val;
	}
}

function ClearRow(Rowindex) {
	var objtbl = document.getElementById('tDHCOPBillStayCharge');
	var RowObj = objtbl.rows[Rowindex];
	var rowitems = RowObj.all;
	if (!rowitems) {
		rowitems = objnewrow.getElementsByTagName("*"); //N6
	}
	for (var j = 0; j < rowitems.length; j++) {
		if (rowitems[j].id) {
			var Id = rowitems[j].id;
			var arrId = Id.split("z");
			var Row = arrId[arrId.length - 1];
			if (rowitems[j].tagName == 'LABEL') {
				rowitems[j].innerText = "";
			} else {
				rowitems[j].value = "";
			}
		}
	}
	//SetFocusColumn("OrderName",Row);
	return Row;
}

function ChangeTwoDecimal_f(x) {
	var f_x = parseFloat(x);
	if (isNaN(f_x)) {
		alert('function:changeTwoDecimal->parameter error');
		return false;
	}
	f_x = Math.round(f_x * 100) / 100;
	var s_x = f_x.toString();
	var pos_decimal = s_x.indexOf('.');
	if (pos_decimal < 0) {
		pos_decimal = s_x.length;
		s_x += '.';
	}
	while (s_x.length <= pos_decimal + 2) {
		s_x += '0';
	}
	return s_x;
}

///Lid
///2012-08-31
///У��ҽ����
///����ֵ��-1:��ҽ����ʧ��
///			-1:δ����ҽ����
///			0:�����ɹ�,У��ɹ�,����ҽ������
///			1:�����ɹ�,У��ʧ��,���ܰ�ҽ������.
function VerifyInsuCard() {
	try {
		var rtn = ReadCard1();
		if (rtn == -1) {
			//alert("�����ҽ����.");
			return -2;
		}
		var rtn = ReadCard("N");
		if ((rtn == "-1") || (rtn == "")) {
			return -1;
		}
		var myArr = rtn.split("|");
		var CardNo = myArr[0];
		if (CardNo == "") {
			return false;
		}
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, CardNo, "", "PatInfo");
		var myary = myrtn.split("^");
		var rtn = myary[0];
		var PatientNo = "";
		switch (rtn) {
		case "0":
			PatientID = myary[4];
			PatientNo = myary[5];
			break;
		case "-200":
			alert("����Ч");
			break;
		case "-201":
			PatientID = myary[4];
			PatientNo = myary[5];
			break;
		default:
		}
		var CurrPatientNO = DHCWebD_GetObjValue("PatientID");
		if (PatientNo == CurrPatientNO) {
			return 0;
		} else {
			alert("�Ǳ���ҽ����,���ʵ.");
			return 1;
		}
	} catch (e) {
		alert("��ҽ��������: " + e.message);
		return -1;
	}
}

//add hujunbin 15.2.3
//��ȡ��ǰ����ļ��������˻�
function getCurrentAccount(adm) {
	var currAccount = "";
	var rtn = tkMakeServerCall("web.DHCOPBillEPManageCLS", "getCurrAcountID", adm);
	var rtnval = rtn.split("^");
	if (rtnval[0] == "0") {
		currAccount = rtnval[1];
	}
	return currAccount;
}

function linkOrderDetail() {
	var Adm = DHCWebD_GetObjValue("Adm");
	var Bill = DHCWebD_GetObjValue("BillNO");
	if (Adm == '') {
		alert("���˾���Ϊ��");
		return;
	}
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFOrdDetail&Adm=' + Adm + '&BillNo=' + Bill;
	websys_showModal({
		url: url,
		title: 'ҽ��������ϸ',
		iconCls: 'icon-w-list'
	});
}

document.body.onload = BodyLoadHandler;
document.body.onbeforeunload = BodyunLoadHandler;
