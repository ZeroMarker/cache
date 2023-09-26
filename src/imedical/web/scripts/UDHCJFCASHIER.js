/// UDHCJFCASHIER.js

var Adm = "";
var BillNo = "";
var Guser;
var instype;
var disch;
var papnoobj;
var locobj;
var nameobj;
var admobj;
var billnoobj, billednoobj;
var depositobj, totalamountobj, amttopayobj;
var billedobj;
var paidobj;
var tobillobj;
var stdateobj;
var enddateobj;
var discretamtobj;
var payobj;
var episodeidobj;
var patidobj;
var patzynoobj;
var patloc;
var SelectedRow = "-1";
var billed = [];
var RegistrationNoobj;
var dischobj;
var getdischobj;
var myData1 = new Array();
var myData2 = new Array();
var myData3 = new Array();
var myData4 = new Array();
var myData5 = new Array();
var myData6 = new Array();
var catedata = new Array();
var path, gusercode, today, GuserCode, Tinvno, billstatus;
var ryyear, rymon, ryday, cyyear, cymon, cyday;
var flag;
var typeobj;
var oldtotalamount;
var RefundFlag;

function BodyLoadHandler() {
	DHCP_GetXMLConfig("InvPrintEncrypt", "DHCJFIPReceipt");
	document.onkeydown = FrameEnterkeyCode;
	Guser = session['LOGON.USERID'];
	GuserCode = session["LOGON.USERCODE"];
	getzyjfconfig();
	papnoobj = document.getElementById('Regno');
	locobj = document.getElementById('Loc');
	typeobj = document.getElementById('Type');
	nameobj = document.getElementById('Name');
	admobj = document.getElementById('Adm');
	billnoobj = document.getElementById('BillNo');
	depositobj = document.getElementById('Deposit');
	totalamountobj = document.getElementById('Totalamount');
	amttopayobj = document.getElementById('Amounttopay');
	discretamtobj = document.getElementById('Discretamt');
	billedobj = document.getElementById('Billed');
	billednoobj = document.getElementById('billedno');
	paidobj = document.getElementById('Paid');
	tobillobj = document.getElementById('ToBill');
	dischobj = document.getElementById('Discharge');
	getbilledobj = document.getElementById('getbilled');
	getpaidobj = document.getElementById('getpaid');
	gettobillobj = document.getElementById('gettobill');
	getdischobj = document.getElementById('getdisch');
	//stdateobj = document.getElementById('StDate');
	enddateobj = document.getElementById('EndDate');
	payobj = document.getElementById('Pay');
	var clearobj = document.getElementById('Clear');
	episodeidobj = document.getElementById('EpisodeID');
	patidobj = document.getElementById('PatientID');
	RegistrationNoobj = document.getElementById('RegistrationNo'); //�ǼǺ�
	var printdetailobj = document.getElementById('Printdetail');
	var adddepositobj = document.getElementById('AddDeposit');
	var refunddepobj = document.getElementById('RefundDeposit');
	if (papnoobj) {
		papnoobj.onkeydown = getpat;
	}
	if (adddepositobj) {
		adddepositobj.onclick = LinkAddDeposit;
	}

	if (refunddepobj) {
		refunddepobj.onclick = LinkRefundDeposit;
	}

	var btnbill = document.getElementById('BtnBill');
	if (btnbill) {
		btnbill.onclick = Bill;
	}
	if (printdetailobj) {
		printdetailobj.onclick = LinkBillDetail;
	}
	if (payobj) {
		payobj.onclick = LinkPay;
	}
	if (clearobj) {
		clearobj.onclick = clearall;
	}
	if (billedobj) {
		billedobj.onclick = getbilledobjfun;
	}
	if (paidobj) {
		paidobj.onclick = getpaidobjfun;
	}
	if (tobillobj) {
		tobillobj.onclick = gettobillobjfun;
	}
	if (dischobj) {
		dischobj.onclick = getdischobjfun;
	}
	if (depositobj) {
		depositobj.readOnly = true;
	}
	if (totalamountobj) {
		totalamountobj.readOnly = true;
	}
	if (amttopayobj) {
		amttopayobj.readOnly = true;
	}

	if (discretamtobj) {
		discretamtobj.readOnly = true;
	}

	getbilledobjfun();
	getpaidobjfun();
	gettobillobjfun();
	getdischobjfun();
	if (locobj) {
		locobj.onkeyup = clearLoc;
		locobj.onkeydown = getloc;
	}
	if (typeobj) {
		typeobj.onkeyup = clearType;
		typeobj.onkeydown = gettype;
	}
	//getenddate();   ˢ�²����½�������  add 17.12.26

	//getpath();

	//insert by 2006.06.01 by cx
	var obj = document.getElementById("ybcardno");
	if (obj) {
		obj.onkeydown = ybcardnoEnter;
	}
	patzynoobj = document.getElementById("patmedicare");
	patzynoobj.onkeydown = getpat;
	//insert by 2008.05.05 ���Ӷ�������
	var readcard = document.getElementById('readcard');
	if (readcard) {
		readcard.onclick = readcard_click;
	}

	var obj = document.getElementById('OPCardType');
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		loadCardType();
		obj.onchange = OPCardType_OnChange;
	}

	var obj = document.getElementById('opcardno');
	if (obj) {
		obj.onkeydown = CardNoKeydownHandler;
	}
	websys_setfocus('Regno');
	RefundFlag = "";
	var reprtFPbtn = document.getElementById('RePrintFP');
	if (reprtFPbtn) {
		reprtFPbtn.onclick = ReprintFP;
	}
	var UserDepIDobj = document.getElementById('UserDepID');
	if (UserDepIDobj) {
		UserDepIDobj.value = session['LOGON.CTLOCID'];
	}

	var CloseAcount = document.getElementById('BtnCloseAcount');
	if (CloseAcount) {
		CloseAcount.onclick = CloseAcount_click;
	}

	var UnCloseAcount = document.getElementById('BtnUnCloseAcount');
	if (UnCloseAcount) {
		UnCloseAcount.onclick = UnCloseAcount_click;
	}
}

///dump fee detaile
function DumpFiles() {
	var str = IPRevOutPut(BillNo);
	if (str == "0") {
		alert(t['msgIns01']);
	}
}

function getpat() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		getpatinfo1();
	}
}

function setpat_val(value) {
	var val = value.split("^");
	papnoobj.value = val[0];
	nameobj.value = val[1];
	admobj.value = val[2];
	Adm = admobj.value;
	episodeidobj.value = Adm;
	var patzynoobj = document.getElementById("patmedicare"); //yyx
	patzynoobj.value = val[6];
	document.getElementById("decease").value = val[7];
	if (val[7] != t['23']) {
		document.getElementById("decease").style.color = "red";
	} else {
		document.getElementById("decease").style.color = "black";
	}
	if (val[8] == "A") {
		//alert(t['56']);
	}
	//insert by cx 2006.06.03
	var patid = "";
	var encmeth = DHCWebD_GetObjValue('getpapmiid');
	patid = cspRunServerMethod(encmeth, val[0]);
	var patidobj = document.getElementById('PatientID');
	patidobj.value = patid;
	if (patid != "") {
		getybcardno();
	}
}

function getbilledobjfun() {
	if (getbilledobj.value == "1") {
		billedobj.checked = true;
	}
	if (billedobj.checked == true) {
		paidobj.checked = false;
		tobillobj.checked = false;
		dischobj.checked = false;
		getbilledobj.value = "1";
		getpaidobj.value = "0";
		gettobillobj.value = "0";
		getdischobj.value = "0";
	}
}

function getpaidobjfun() {
	if (getpaidobj.value == "1") {
		paidobj.checked = true;
	}
	if (paidobj.checked == true) {
		getpaidobj.value = "1";
		tobillobj.checked = false;
		dischobj.checked = false;
		billedobj.checked = false;
		gettobillobj.value = "0";
		getdischobj.value = "0";
		getbilledobj.value = "0";
	}
}

function gettobillobjfun() {
	if (gettobillobj.value == "1") {
		tobillobj.checked = true;
	}
	if (tobillobj.checked == true) {
		gettobillobj.value = "1";
		paidobj.checked = false;
		dischobj.checked = false;
		billedobj.checked = false;
		getpaidobj.value = "0";
		getdischobj.value = "0";
		getbilledobj.value = "0";
	}
}

function getdischobjfun() {
	if (getdischobj.value == "1") {
		dischobj.checked = true;
	}
	if (dischobj.checked == true) {
		getdischobj.value = "1";
		paidobj.checked = false;
		tobillobj.checked = false;
		billedobj.checked = false;
		getpaidobj.value = "0";
		gettobillobj.value = "0";
		getbilledobj.value = "0";
	}
}

function clearall() {
	location.href = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFCASHIER";
}

function gettypeid(value) {
	var val = value.split("^");
	var obj = document.getElementById('typeid');
	obj.value = val[1];
}

function getlocid(value) {
	var val = value.split("^");
	var obj = document.getElementById('locid');
	obj.value = val[1];
}

/*
function getpath(){
	var encmeth = DHCWebD_GetObjValue('getpath');
	path = cspRunServerMethod(encmeth, '', '');
}
*/

function getenddate() {
	var encmeth = DHCWebD_GetObjValue('getenddate');
	if (cspRunServerMethod(encmeth, 'setdate_val', '', '') == '1') {};
}

function setdate_val(value) {
	enddateobj.value = value;
	today = value;
}

function getdeposit(Adm) {
	p1 = Adm;
	var encmeth = DHCWebD_GetObjValue('getdeposit');
	return cspRunServerMethod(encmeth, p1);
}

function gettoday() {
	var d = new Date();
	var s = d.getDate() + "/";
	s += (d.getMonth() + 1) + "/";
	s += d.getYear();
	return (s);
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var rowobj = getRow(eSrc);
	Objtbl = document.getElementById('tUDHCJFCASHIER');
	Rows = Objtbl.rows.length;
	var lastrowindex = Rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow){
		return;
	}
	if (selectrow != SelectedRow) {
		//+2015-3-23 hujunbin ������ID���˵�ID����ͷ�˵�
		var episodeObj = document.getElementById('Tadmz' + selectrow);
		var billObj = document.getElementById('Tbillrowidz' + selectrow);
		var frm = parent.parent.document.forms['fEPRMENU'];
		if (typeof(frm) != "undefined") {
			var frmEpisodeID = frm.EpisodeID;
			var frmBillID = frm.BillRowIds;
			if (billObj){
				frmBillID.value = billObj.innerText;
			}
			if (episodeObj){
				frmEpisodeID.value = episodeObj.innerText;
			}
		}
		var SelRowObj = document.getElementById('Tadmz' + selectrow);
		Adm = SelRowObj.innerText;
		if (Adm) {
			admobj.value = Adm;
			episodeidobj.value = Adm;
		} else {
			admobj.value = "";
			episodeidobj.value = "";
		}
		SelRowObj = document.getElementById('Tregnoz' + selectrow);
		var regno = SelRowObj.innerText;
		if (regno) {
			RegistrationNoobj.value = regno;
		} else {
			RegistrationNoobj.value = "";
		}
		var SelRowObj = document.getElementById('TPatientIDz' + selectrow);
		var PatientID = SelRowObj.innerText;
		if (PatientID) {
			patidobj.value = PatientID;
		} else {
			patidobj.value = "";
		}
		var SelRowObj = document.getElementById('Tbillstatusz' + selectrow);
		billstatus = SelRowObj.innerText;
		depositobj.value = getdeposit(Adm);
		//SelRowObj = document.getElementById('Tdiscretamtz' + selectrow);
		//discretamtobj.value = SelRowObj.innerText;
		if (discretamtobj.value == "")
			discretamtobj.value = "0.00";
		if (billstatus == "Paid") {
			totalamountobj.value = "0.00";
			amttopayobj.value = "0.00";
		} else {
			SelRowObj = document.getElementById('Tpatientsharez' + selectrow);
			totalamountobj.value = SelRowObj.innerText;
			var tmpamt = totalamountobj.value - depositobj.value - discretamtobj.value;   //*
			amttopayobj.value = tmpamt.toFixed(2);
		}
		if (amttopayobj.value < 0) {
			amttopayobj.style.color = "red";
		} else {
			amttopayobj.style.color = "black";
		}
		var SelRowObj = document.getElementById('Tbillrowidz' + selectrow);
		BillNo = SelRowObj.innerText;
		if (BillNo) {
			billnoobj.value = BillNo;
		} else {
			billnoobj.value = "";
			BillNo = "";
		}
		SelRowObj = document.getElementById('Tinvnoz' + selectrow);
		Tinvno = SelRowObj.innerText;
		if (!Tinvno){
			Tinvno = "";
		}
		SelRowObj = document.getElementById('Tregnoz' + selectrow);
		papnoobj.value = SelRowObj.innerText;
		SelRowObj = document.getElementById('Tnamez' + selectrow);
		nameobj.value = SelRowObj.innerText;
		SelRowObj = document.getElementById('Tbilltypez' + selectrow);
		instype = SelRowObj.innerText;
		SelRowObj = document.getElementById('Tdischargestatusz' + selectrow);
		disch = SelRowObj.innerText;
		SelRowObj = document.getElementById('Tlocz' + selectrow);
		patloc = SelRowObj.innerText;
		SelRowObj = document.getElementById('Tpatzynoz' + selectrow);
		patzynoobj.value = SelRowObj.innerText;
		//+2018-01-15 ZhYW 
		var decease = DHCWeb_GetColumnData('TDecease', selectrow);
		var deceaseObj = websys_$("decease");
		deceaseObj.value = decease;
		if (decease != t['23']) {
			deceaseObj.style.color = "red";
		} else {
			deceaseObj.style.color = "black";
		}
		//
		RefundFlag = document.getElementById('Trefundz' + selectrow).innerText;
		SelectedRow = selectrow;
	} else {
		papnoobj.value = "";
		nameobj.value = "";
		admobj.value = "";
		billnoobj.value = "";
		depositobj.value = "";
		totalamountobj.value = "";
		amttopayobj.value = "";
		discretamtobj.value = "";
		SelectedRow = "-1";
		Adm = "";
		BillNo = "";
		Tinvno = "";
		billstatus = "";
		episodeidobj.value = "";
		patidobj.value = "";
		patzynoobj.value = "";
		DHCWebD_SetObjValueB("decease", "");
	}
	//insert by cx 2006.06.03
	getybcardno()
}

function LinkPay() {
	if (Adm == "" || BillNo == "") {
		alert("����ѡ���˵�!");
		return;
	}
	//�ж�Ӥ���Ƿ����
	var rtn = tkMakeServerCall("web.UDHCJFCOMMON", "CheckBabyAdmDisCharge", Adm);
	if (rtn == "-1") {
		var PayFlag = window.confirm("��Ӥ��δ����,ĸ���Ƿ�ȷ�Ͻ���?");
		if (!PayFlag) {
			return;
		}
	}
	if (rtn == "-2") {
		var PayFlag = window.confirm("Ӥ��δ�����ս���,ĸ���Ƿ�ȷ�Ͻ���?");
		if (!PayFlag) {
			return;
		}
	}
	if (disch == t['53']) {
		alert(t['54']);
	}

	if (RefundFlag == "B") //yyx 2009-09-24 bug�޸�
	{
		alert("���˵��Ѿ����,���������.");
		return
	}
	GetAdmReaNationCode();
	if (disch != t['55']) {
		if ((ReaNationCode != "") && (ReaNationCode != "0") && (InsuPayFlag == "N")) {
			alert("ҽ������δ�����ս��㲻�ܽ���!!");
			return;
		} else {
			if (!confirm(t['56'])) {
				return;    //alert(t['56']);
			}
		}
	}
	//�ж��շ���δ���˵�ҽ���A�мƷ������뷢ҩ������һ�µ�ҩƷ�A��������������
	/*
	var ReturnValStr=tkMakeServerCall("web.DHCIPBillPayControl","GetNotBillOrd",Adm,BillNo)

	var ReturnVal=ReturnValStr.split("^")

	var MNotBill=ReturnVal[0].split(",");
	var MNotBillNum=MNotBill[0],MNotBillInfo=MNotBill[1];
	var MDis=ReturnVal[1].split(",");
	var MDisNum=MDis[0];
	var MDisInfo=MDis[1];
	var NotDisp=ReturnVal[2].split(",");
	var NotDispNum=NotDisp[0],NotDispInfo=NotDisp[1];
	if (MDisNum!=0)
{  alert("�˲�����ҩƷ��ҩ������Ʒ�������һ�µ�ҽ��,���������."+"^"+MDisInfo);
	return;   }
	if (MNotBillNum!=0)
{  alert("�˲�������Ҫ�Ʒѵ�ҽ��,���������."+"^"+MNotBillInfo);
	return;   }

	if (NotDispNum!=0)
{
	alert("������ҩƷ��Ҫ���ŵ�ҽ��,���������"+NotDispInfo);
	return;
	}
	//�ж�Ӥ����
	var ReturnValStr=tkMakeServerCall("web.DHCIPBillPayControl","GetBabyNotBillOrd",Adm,BillNo);
	var ReturnVal=ReturnValStr.split("^");
	var MNotBill=ReturnVal[0].split(",");
	var MNotBillNum=MNotBill[0];
	var MNotBillInfo=MNotBill[1];
	var MDis=ReturnVal[1].split(",");
	var MDisNum=MDis[0],MDisInfo=MDis[1];
	var NotDisp=ReturnVal[2].split(",");
	var NotDispNum=NotDisp[0],NotDispInfo=NotDisp[1];
	if (MDisNum != 0){
  		alert("�˲��˵�Ӥ����ҩƷ��ҩ������Ʒ�������һ�µ�ҽ��,���������."+"^"+MDisInfo);
		return;
	}
	if (MNotBillNum!=0){
		alert("�˲��˵�Ӥ������Ҫ�Ʒѵ�ҽ��,���������."+"^"+MNotBillInfo);
		return;
	}

	if (NotDispNum!=0) {
		alert("���˵�Ӥ����ҩƷ��Ҫ���ŵ�ҽ��,���������"+NotDispInfo);
		return;
	}
	*/

	//modify 2014-11-12  סԺ�������ʹ���¼�����ò�ѯ
	var CheckFlag = "PAY";
	var BillFlag = "New";     //7.0֮ǰ�汾Ϊ"Old"��֮�����7.0Ϊ "New"
	var ReturnValStr = tkMakeServerCall("web.DHCIPBillCheckAdmFee", "AdmSettlementCheck", Adm, BillNo, CheckFlag, BillFlag)
	var ReturnVal = ReturnValStr.split("^");
	//���̺�^7.0��汾û��ִ�м�¼^��ʵ״̬ҽ��û�мƷ�^û�з�ҩҽ��^��ҩ������Ʒ�������һ��^ȱ�ٴ�λ������^ȱ�ٻ���ѵ�����^ȱ�����ѵ�����^ȱ�ٻ�ʳ�ѵ�����^ȱ��ȡů�ѵ�����^���������Ƿ�������ҽ��^���������Ƿ�������ҽ��^���ò�ƽ���˵�����^���ò�ƽ��ҽ������^�˵�����С��0
	var NExecNull = ReturnVal[1];
	var TBOEOrd = ReturnVal[2];
	var NCDrug = ReturnVal[3];
	var NDrugErr = ReturnVal[4];
	var NBedNumErr = ReturnVal[5];
	var NNurseNumErr = ReturnVal[6];
	var NExamNumErr = ReturnVal[7];
	var NFoodNumErr = ReturnVal[8];
	var NWarmNumErr = ReturnVal[9];
	var NOPOENum = ReturnVal[10];
	var NAnAOENum = ReturnVal[11];
	var UnevenBillNum = ReturnVal[12];
	var UnevenOrdNum = ReturnVal[13];
	var BillNegativeNum = ReturnVal[14];

	//�°�ҽ��û��ִ�м�¼
	if ((NExecNull == "") || (NExecNull == "")) {
		alert("���ҽ��ִ����Ϣʧ�ܲ��ܽ���!!");
		return;
	}
	if (isNaN(NExecNull)) {
		alert("���ҽ��ִ����Ϣʧ�ܲ��ܽ���!!");
		return;
	}
	if ((eval(NExecNull) != 0) && (BillFlag == "New")) {
		alert("����ҽ��δ�ҵ�ִ�м�¼,�ƷѴ����ܽ���,�����ڡ�����סԺ���ú˲顷ģ���ҵ���������");
		return;
	}
	//����ҽ����"TB" ״̬
	if ((TBOEOrd == "") || (TBOEOrd == "")) {
		alert("���ҽ���Ƿ�Ʒ�ʧ�ܲ��ܽ���!!");
		return;
	}
	if (isNaN(TBOEOrd)) {
		alert("���ҽ���Ƿ�Ʒ�ʧ�ܲ��ܽ���!!");
		return;
	}
	if (eval(TBOEOrd) != 0) {
		alert("����ҽ����δ�Ʒ�ҽ�����ܽ���,�����ڡ�����סԺ���ú˲顷ģ���ҵ���������");
		return;
	}
	//����ҽ����δ��ҩ��¼
	if ((NCDrug == "") || (NCDrug == "")) {
		alert("��黼���Ƿ���δ��ҩҽ�����ܽ���!!");
		return;
	}
	if (isNaN(NCDrug)) {
		alert("��黼���Ƿ���δ��ҩҽ�����ܽ���!!");
		return;
	}
	if (eval(NCDrug) != 0) {
		alert("������δ��ҩҽ�����ܽ���,�����ڡ�����סԺ���ú˲顷ģ���ҵ���������");
		return;
	}
	//����ҽ����δ��ҩ��¼
	if ((NDrugErr == "") || (NDrugErr == "")) {
		alert("��黼�߷�ҩ��Ʒ������Ƿ�һ��ʧ�ܲ��ܽ���!!");
		return;
	}
	if (isNaN(NDrugErr)) {
		alert("��黼�߷�ҩ��Ʒ������Ƿ�һ��ʧ�ܲ��ܽ���!!");
		return;
	}
	if (eval(NDrugErr) != 0) {
		alert("�����з�ҩ������Ʒ�������һ�²��ܽ���,�����ڡ�����סԺ���ú˲顷ģ���ҵ���������");
		return;
	}
	//����סԺ�����봲λ����������
	if ((NBedNumErr == "") || (NBedNumErr == "")) {
		alert("��黼����ȡ��λ������ʧ�ܲ��ܽ���!!");
		return;
	}
	if (isNaN(NBedNumErr)) {
		alert("��黼����ȡ��λ������ʧ�ܲ��ܽ���!!");
		return;
	}
	if (eval(NBedNumErr) != 0) {
		var PayFlag = window.confirm("������ȡ��λ��������ʵ��סԺ��������,�����ڡ�����סԺ���ú˲顷ģ���ҵ�δ�մ�λ������,�Ƿ����?");
		if (!PayFlag) {
			return;
		}
	}
	//���߻����������סԺ��������
	if ((NNurseNumErr == "") || (NNurseNumErr == "")) {
		alert("��黼����ȡ���������ʧ�ܲ��ܽ���!!");
		return;
	}
	if (isNaN(NNurseNumErr)) {
		alert("��黼����ȡ���������ʧ�ܲ��ܽ���!!");
		return;
	}
	if (eval(NNurseNumErr) != 0) {
		var PayFlag = window.confirm("������ȡ��λ��������ʵ��סԺ��������,�����ڡ�����סԺ���ú˲顷ģ���ҵ�δ�ջ��������,�Ƿ����?");
		if (!PayFlag) {
			return;
		}
	}
	//��������������סԺ����������
	if ((NExamNumErr == "") || (NExamNumErr == "")) {
		alert("��黼����ȡ��������ʧ�ܲ��ܽ���!!");
		return;
	}
	if (isNaN(NExamNumErr)) {
		alert("��黼����ȡ��������ʧ�ܲ��ܽ���!!");
		return;
	}
	if (eval(NExamNumErr) != 0) {
		var PayFlag = window.confirm("������ȡ����������ʵ��סԺ��������,�����ڡ�����סԺ���ú˲顷ģ���ҵ�δ����������,�Ƿ����?");
		if (!PayFlag) {
			return;
		}
	}
	//���߻�ʳ��������סԺ��������
	if ((NFoodNumErr == "") || (NFoodNumErr == "")) {
		alert("��黼����ȡ��ʳ������ʧ�ܲ��ܽ���!!");
		return;
	}
	if (isNaN(NFoodNumErr)) {
		alert("��黼����ȡ��ʳ������ʧ�ܲ��ܽ���!!");
		return;
	}
	if (eval(NFoodNumErr) != 0) {
		var PayFlag = window.confirm("������ȡ��ʳ��������ʵ��סԺ��������,�����ڡ�����סԺ���ú˲顷ģ���ҵ�δ�ջ�ʳ������,�Ƿ����?");
		if (!PayFlag) {
			return;
		}
	}
	//���߿յ�ȡů��������סԺ��������
	if ((NWarmNumErr == "") || (NWarmNumErr == "")) {
		alert("��黼����ȡ�յ�/ȡů������ʧ�ܲ��ܽ���!!");
		return;
	}
	if (isNaN(NWarmNumErr)) {
		alert("��黼����ȡ�յ�/ȡů������ʧ�ܲ��ܽ���!!");
		return;
	}
	if (eval(NWarmNumErr) != 0) {
		var PayFlag = window.confirm("������ȡ�յ�/ȡů������ʵ��סԺ��������,�����ڡ�����סԺ���ú˲顷ģ���ҵ�δ�տյ�/ȡů������,�Ƿ����?");
		if (!PayFlag) {
			return;
		}
	}
	//�����������뵫û���������ҽ��
	if ((NOPOENum == "") || (NOPOENum == "")) {
		alert("��黼���������ҽ��ʧ�ܲ��ܽ���!!");
		return;
	}
	if (isNaN(NOPOENum)) {
		alert("��黼���������ҽ��ʧ�ܲ��ܽ���!!");
		return;
	}
	if (eval(NOPOENum) != 0) {
		var PayFlag = window.confirm("���������������뵫δ��¼�������ҽ��,�����ڡ�����סԺ���ú˲顷ģ���ҵ�δ�տյ�/ȡů������,�Ƿ����?");
		if (!PayFlag) {
			return;
		}
	}
	//�����������뵫û���������ҽ��
	if ((NAnAOENum == "") || (NAnAOENum == "")) {
		alert("��黼���������ҽ��ʧ�ܲ��ܽ���!!");
		return;
	}
	if (isNaN(NAnAOENum)) {
		alert("��黼���������ҽ��ʧ�ܲ��ܽ���!!");
		return;
	}
	if (eval(NAnAOENum) != 0) {
		var PayFlag = window.confirm("���������������뵫δ��¼�������ҽ��,�����ڡ�����סԺ���ú˲顷ģ���ҵ�δ�տյ�/ȡů������,�Ƿ����?");
		if (!PayFlag) {
			return;
		}
	}
	//�����˵���ƽ
	if ((UnevenBillNum == "") || (UnevenBillNum == "")) {
		alert("��黼���˵�ʧ�ܲ��ܽ���!!");
		return;
	}
	if (isNaN(UnevenBillNum)) {
		alert("��黼���˵�ʧ�ܲ��ܽ���!!");
		return;
	}
	if (eval(UnevenBillNum) != 0) {
		alert("�����˵���ƽ���ܽ���!!");
		return;
	}
	//����ҽ���˵���ƽ
	if ((UnevenOrdNum == "") || (UnevenOrdNum == "")) {
		alert("��黼��ҽ���˵����ʧ�ܲ��ܽ���!!");
		return;
	}
	if (isNaN(UnevenOrdNum)) {
		alert("��黼��ҽ���˵����ʧ�ܲ��ܽ���!!");
		return;
	}
	if (eval(UnevenOrdNum) != 0) {
		alert("����ҽ���˵���ƽ���ܽ���!!");
		return;
	}
	//����ҽ���˵�����Ϊ����
	if ((BillNegativeNum == "") || (BillNegativeNum == "")) {
		alert("��黼��ҽ���˵�����ʧ�ܲ��ܽ���!!");
		return;
	}
	if (isNaN(BillNegativeNum)) {
		alert("��黼��ҽ���˵�����ʧ�ܲ��ܽ���!!");
		return;
	}
	if (eval(BillNegativeNum) != 0) {
		alert("����ҽ���˵�����Ϊ�������ܽ���!!");
		return;
	}
	//�ж�Ӥ��ҽ��
	var CheckFlag = "PAY";
	var BillFlag = "New";     //7.0֮ǰ�汾Ϊ"Old"��֮�����7.0Ϊ "New"
	var ReturnValStr = tkMakeServerCall("web.DHCIPBillCheckAdmFee", "GetBabySettlementCheck", Adm, BillNo, CheckFlag, BillFlag);
	if (ReturnValStr != "") {
		var ReturnValStr1 = ReturnValStr.split(String.fromCharCode(3));
		for (var i = 0; i < ReturnValStr1.length - 1; i++) {
			if (ReturnValStr1[i] != "") {
				var ReturnValStr12 = ReturnValStr1[i].split(String.fromCharCode(2));
				var BabyName = ReturnValStr12[0];
				var ReturnVal = ReturnValStr12[1].split("^");
				//���̺�^7.0��汾û��ִ�м�¼^��ʵ״̬ҽ��û�мƷ�^û�з�ҩҽ��^��ҩ������Ʒ�������һ��^ȱ�ٴ�λ������^ȱ�ٻ���ѵ�����^ȱ�����ѵ�����^ȱ�ٻ�ʳ�ѵ�����^ȱ��ȡů�ѵ�����^���ò�ƽ���˵�����^���ò�ƽ��ҽ������^�˵�����С��0
				var NExecNull = ReturnVal[1];
				var TBOEOrd = ReturnVal[2];
				var NCDrug = ReturnVal[3];
				var NDrugErr = ReturnVal[4];
				var NBedNumErr = ReturnVal[5];
				var NNurseNumErr = ReturnVal[6];
				var NExamNumErr = ReturnVal[7];
				var NFoodNumErr = ReturnVal[8];
				var NWarmNumErr = ReturnVal[9];
				var NOPOENum = ReturnVal[10];
				var NAnAOENum = ReturnVal[11];
				var UnevenBillNum = ReturnVal[12];
				var UnevenOrdNum = ReturnVal[13];
				var BillNegativeNum = ReturnVal[14];

				//�°�ҽ��û��ִ�м�¼
				if ((NExecNull == "") || (NExecNull == "")) {
					alert("���ҽ��ִ����Ϣʧ�ܲ��ܽ���!!");
					return;
				}
				if (isNaN(NExecNull)) {
					alert("���ҽ��ִ����Ϣʧ�ܲ��ܽ���!!");
					return;
				}
				if ((eval(NExecNull) != 0) && (BillFlag == "New")) {
					alert("����ҽ��δ�ҵ�ִ�м�¼,�ƷѴ����ܽ���,�����ڡ�����סԺ���ú˲顷ģ���ҵ���������");
					return;
				}
				//����ҽ����"TB" ״̬
				if ((TBOEOrd == "") || (TBOEOrd == "")) {
					alert("���ҽ���Ƿ�Ʒ�ʧ�ܲ��ܽ���!!");
					return;
				}
				if (isNaN(TBOEOrd)) {
					alert("���ҽ���Ƿ�Ʒ�ʧ�ܲ��ܽ���!!");
					return;
				}
				if (eval(TBOEOrd) != 0) {
					alert("����ҽ����δ�Ʒ�ҽ�����ܽ���,�����ڡ�����סԺ���ú˲顷ģ���ҵ���������");
					return;
				}
				//����ҽ����δ��ҩ��¼
				if ((NCDrug == "") || (NCDrug == "")) {
					alert("��黼���Ƿ���δ��ҩҽ�����ܽ���!!");
					return;
				}
				if (isNaN(NCDrug)) {
					alert("��黼���Ƿ���δ��ҩҽ�����ܽ���!!");
					return;
				}
				if (eval(NCDrug) != 0) {
					alert("������δ��ҩҽ�����ܽ���,�����ڡ�����סԺ���ú˲顷ģ���ҵ���������");
					return;
				}
				//����ҽ����δ��ҩ��¼
				if ((NDrugErr == "") || (NDrugErr == "")) {
					alert("��黼�߷�ҩ��Ʒ������Ƿ�һ��ʧ�ܲ��ܽ���!!");
					return;
				}
				if (isNaN(NDrugErr)) {
					alert("��黼�߷�ҩ��Ʒ������Ƿ�һ��ʧ�ܲ��ܽ���!!");
					return;
				}
				if (eval(NDrugErr) != 0) {
					alert("�����з�ҩ������Ʒ�������һ�²��ܽ���,�����ڡ�����סԺ���ú˲顷ģ���ҵ���������");
					return;
				}
				//����סԺ�����봲λ����������
				if ((NBedNumErr == "") || (NBedNumErr == "")) {
					alert("��黼����ȡ��λ������ʧ�ܲ��ܽ���!!");
					return;
				}
				if (isNaN(NBedNumErr)) {
					alert("��黼����ȡ��λ������ʧ�ܲ��ܽ���!!");
					return;
				}
				if (eval(NBedNumErr) != 0) {
					var PayFlag = window.confirm("������ȡ��λ��������ʵ��סԺ��������,�����ڡ�����סԺ���ú˲顷ģ���ҵ�δ�մ�λ������,�Ƿ����?");
					if (!PayFlag) {
						return;
					}
				}
				//���߻����������סԺ��������
				if ((NNurseNumErr == "") || (NNurseNumErr == "")) {
					alert("��黼����ȡ���������ʧ�ܲ��ܽ���!!");
					return;
				}
				if (isNaN(NNurseNumErr)) {
					alert("��黼����ȡ���������ʧ�ܲ��ܽ���!!");
					return;
				}
				if (eval(NNurseNumErr) != 0) {
					var PayFlag = window.confirm("������ȡ��λ��������ʵ��סԺ��������,�����ڡ�����סԺ���ú˲顷ģ���ҵ�δ�ջ��������,�Ƿ����?");
					if (!PayFlag) {
						return;
					}
				}
				//��������������סԺ����������
				if ((NExamNumErr == "") || (NExamNumErr == "")) {
					alert("��黼����ȡ��������ʧ�ܲ��ܽ���!!");
					return;
				}
				if (isNaN(NExamNumErr)) {
					alert("��黼����ȡ��������ʧ�ܲ��ܽ���!!");
					return;
				}
				if (eval(NExamNumErr) != 0) {
					var PayFlag = window.confirm("������ȡ����������ʵ��סԺ��������,�����ڡ�����סԺ���ú˲顷ģ���ҵ�δ����������,�Ƿ����?");
					if (!PayFlag) {
						return
					}
				}
				//���߻�ʳ��������סԺ��������
				if ((NFoodNumErr == "") || (NFoodNumErr == "")) {
					alert("��黼����ȡ��ʳ������ʧ�ܲ��ܽ���!!");
					return;
				}
				if (isNaN(NFoodNumErr)) {
					alert("��黼����ȡ��ʳ������ʧ�ܲ��ܽ���!!");
					return;
				}
				if (eval(NFoodNumErr) != 0) {
					var PayFlag = window.confirm("������ȡ��ʳ��������ʵ��סԺ��������,�����ڡ�����סԺ���ú˲顷ģ���ҵ�δ�ջ�ʳ������,�Ƿ����?");
					if (!PayFlag) {
						return;
					}
				}
				//���߿յ�ȡů��������סԺ��������
				if ((NWarmNumErr == "") || (NWarmNumErr == "")) {
					alert("��黼����ȡ�յ�/ȡů������ʧ�ܲ��ܽ���!!");
					return;
				}
				if (isNaN(NWarmNumErr)) {
					alert("��黼����ȡ�յ�/ȡů������ʧ�ܲ��ܽ���!!");
					return;
				}
				if (eval(NWarmNumErr) != 0) {
					var PayFlag = window.confirm("������ȡ�յ�/ȡů������ʵ��סԺ��������,�����ڡ�����סԺ���ú˲顷ģ���ҵ�δ�տյ�/ȡů������,�Ƿ����?");
					if (!PayFlag) {
						return;
					}
				}
				//�����������뵫û���������ҽ��
				if ((NOPOENum == "") || (NOPOENum == "")) {
					alert("��黼���������ҽ��ʧ�ܲ��ܽ���!!");
					return;
				}
				if (isNaN(NOPOENum)) {
					alert("��黼���������ҽ��ʧ�ܲ��ܽ���!!");
					return;
				}
				if (eval(NOPOENum) != 0) {
					var PayFlag = window.confirm("���������������뵫δ��¼�������ҽ��,�����ڡ�����סԺ���ú˲顷ģ���ҵ�δ�տյ�/ȡů������,�Ƿ����?");
					if (!PayFlag) {
						return;
					}
				}
				//�����������뵫û���������ҽ��
				if ((NAnAOENum == "") || (NAnAOENum == "")) {
					alert("��黼���������ҽ��ʧ�ܲ��ܽ���!!");
					return;
				}
				if (isNaN(NAnAOENum)) {
					alert("��黼���������ҽ��ʧ�ܲ��ܽ���!!");
					return;
				}
				if (eval(NAnAOENum) != 0) {
					var PayFlag = window.confirm("���������������뵫δ��¼�������ҽ��,�����ڡ�����סԺ���ú˲顷ģ���ҵ�δ�տյ�/ȡů������,�Ƿ����?");
					if (!PayFlag) {
						return;
					}
				}

				//�����˵���ƽ
				if ((UnevenBillNum == "") || (UnevenBillNum == "")) {
					alert("��黼���˵�ʧ�ܲ��ܽ���!!");
					return;
				}
				if (isNaN(UnevenBillNum)) {
					alert("��黼���˵�ʧ�ܲ��ܽ���!!");
					return;
				}
				if (eval(UnevenBillNum) != 0) {
					alert("�����˵���ƽ���ܽ���!!");
					return;
				}
				//����ҽ���˵���ƽ
				if ((UnevenOrdNum == "") || (UnevenOrdNum == "")) {
					alert("��黼��ҽ���˵����ʧ�ܲ��ܽ���!!");
					return;
				}
				if (isNaN(UnevenOrdNum)) {
					alert("��黼��ҽ���˵����ʧ�ܲ��ܽ���!!");
					return;
				}
				if (eval(UnevenOrdNum) != 0) {
					alert("����ҽ���˵���ƽ���ܽ���!!");
					return;
				}
				//����ҽ���˵�����Ϊ����
				if ((BillNegativeNum == "") || (BillNegativeNum == "")) {
					alert("��黼��ҽ���˵�����ʧ�ܲ��ܽ���!!");
					return;
				}
				if (isNaN(BillNegativeNum)) {
					alert("��黼��ҽ���˵�����ʧ�ܲ��ܽ���!!");
					return;
				}
				if (eval(BillNegativeNum) != 0) {
					alert("����ҽ���˵�����Ϊ�������ܽ���!!");
					return;
				}
			}
		}
	}

	var encmeth = DHCWebD_GetObjValue('getjudge');
	var num = cspRunServerMethod(encmeth, '', '', Adm);
	if (num == '1') {     //if (billednoobj.value!=Adm && billstatus!="Paid")
		//{  alert(t['02']);return; }
	}
	if (PatFeeConfirmFlag == "Y") {    //�������yyx
		var encmeth = DHCWebD_GetObjValue('getconfirmflag');
		var retval = cspRunServerMethod(encmeth, Adm);
		var confirmflagstr = retval.split("^");
		if (confirmflagstr[1] == "N") {
			alert(t['Confirm01']);
			return;
		}
	}
	var pay = amttopayobj.value;
	var deposit = depositobj.value;
	var patfee = totalamountobj.value;
	/*
	var encmeth = DHCWebD_GetObjValue('UpdatePatFee');
	var RetVal = cspRunServerMethod(encmeth,BillNo);
	var RetVal = RetVal.split("^");
	var Error = RetVal[0];
	if ((Error != 0)&&(Error != "1")){
		alert("���·��ñ����");
		return;
	}
	if (Error == "0"){   
		patfee = RetVal[1];
		deposit = depositobj.value;
		pay = (eval(patfee)-eval(deposit)).toFixed(2).toString(10);
	}
	*/
	var ybcardno = "";     //ҽ������
	var encmeth = DHCWebD_GetObjValue('SetPaybzclass');  //���ӽ����־
	var getbzclassbz = cspRunServerMethod(encmeth, Adm, BillNo);

	//var lnk='udhcjfpay.csp?&Adm='+Adm+'&BillNo='+BillNo+'&Pay='+pay+'&Deposit='+deposit+'&pattype='+instype+'&patfee='+patfee+"&ybcardno="+ybcardno
	//websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');

	var str = 'dhcipbillcharge.main.csp';
	window.open(str, "_self");

	//+2015-3-11 hujunbin ���ӵ���סԺ�շ�
	//selectTabBar("Menu53617", "Menu54484");
}

function LinkBillDetail() {
	if ((BillNo == "") || (BillNo == " ")) {
		alert("��ѡ����!!");
		return;
	}
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetail&BillNo=' + BillNo;
	websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

function judge() {
	var encmeth = DHCWebD_GetObjValue('getjudge');
	var num = cspRunServerMethod(encmeth, '', '', Adm);
	return num;
}

function Bill() {
	if (Adm == "") {
		alert(t['03']);
		return;
	}
	if (Adm != "") {
		var encmeth = DHCWebD_GetObjValue('getmotheradm');
		if (cspRunServerMethod(encmeth, Adm) == 'true') {
			alert("�˲���ΪӤ���A���������˵�.");
			return;
		}
		var WshNetwork = new ActiveXObject("WScript.NetWork");
		var computername = WshNetwork.ComputerName;
		/*
		var myrtn = tkMakeServerCall("web.DHCIPMealWorkLoad","toHisBillByAdm",Adm);
		if (myrtn != "0"){
			alert("������ʳ���ô���! ������룺" + rtn);
			return;
		}else {
			alert("������ʳ���óɹ�!");
		}
		*/
		var encmeth = DHCWebD_GetObjValue('getbill');
		var num = cspRunServerMethod(encmeth, '', '', Adm, Guser, BillNo, computername);
		if (num == "AdmNull") {
			alert("����Ų���Ϊ��.");
			return;
		}
		if (num == "PBNull") {
			alert("�˵���Ϊ��,�˵�ʧ��.");
			return;
		}
		if (num == "OrdNull") {
			alert("����û��ҽ��,�����˵�");
			return;
		}
		if (num == '0') {
			billednoobj.value = Adm;
			alert(t['04']);
			//var Findobj = document.getElementById('Find');
			//Findobj.click()    //Lid 2010-07-09 �˵��ɹ���ˢ�½���
			//Lid 2010-07-09 �˵���A���¸��½�������
			UpdateFootData(BillNo);
		}
		if (num == '2') {
			alert(t['05'])
			return;
		}
		if (num != '0') {
			alert(t['06']);
		}
	}
}

function ReBill() {
	if (BillNo == "") {
		alert(t['57']);
		return;
	}
	if (Adm == "") {
		alert(t['03']);
		return;
	}
	if (Adm != "") {
		var PBNum = tkMakeServerCall("web.UDHCJFBaseCommon", "JudgeBillNum", Adm);
		if (PBNum >= 2) {
			rtn = window.confirm("����������δ������˵�,�Ƿ�ȷ�����������˵�?");
			if (!rtn) {
				return;
			}
		}
		var encmeth = DHCWebD_GetObjValue('rebill');
		var num = cspRunServerMethod(encmeth, '', '', Adm, BillNo, Guser);
		if (num == '0') {
			alert(t['07']);
		}
		if (num == "ExtItmErr") {
			alert("�˵���ִ�м�¼�и��ӵ��շ���Ŀ,�������������˵�.")
			return;
		}
		if (num != '0') {
			alert(t['08']);
		}
	}
	var Findobj = document.getElementById('Find');
	Findobj.click();
}

function LinkAddDeposit() {
	if (Adm == "") {
		alert(t['03']);
		return;
	}
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDeposit&Adm=' + Adm + '&deposittype=' + "";
	websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

function LinkRefundDeposit() {
	if (Adm == "") {
		alert(t['03']);
		return;
	}
	//+2018-07-11 ZhYW 
	var rtn = tkMakeServerCall("web.DHCBillPreIPAdmTrans", "CheckRefDeposit", Adm);
	if (+rtn == 1) {
		alert('�û��ߵ�ԤסԺҽ��������Чҽ��,������Ѻ��.');
		return;
	}else if (+rtn == 2) {
		alert('�û�����ԤסԺת������ķ���δ����,������Ѻ��.');
		return;
	};
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFRefundDeposit&Adm=' + Adm;
	websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

function LinkIntBill() {
	if (BillNo == " ") {
		alert("�˵�Ϊ��,���������˵�.");
		return;
	}
	if (BillNo == "") {
		alert("�˵�Ϊ��,���������˵�.");
		return;
	}
	if (billstatus == "Paid") {
		alert("���˵��ѽ���,���������˵�");
		return;
	}
	//�˺�����;��ĳЩ���͵�ҽ�����˲��ܽ�����;����
	var InitPayflag = DoNotInitPay();
	if (InitPayflag == false) {
		alert(t['HXEY01']);
		return;
	}
	var encmeth = DHCWebD_GetObjValue('getjudge');
	var num = cspRunServerMethod(encmeth, '', '', Adm);
	if ((num == "") || (num == " ")) {
		num = 0;
	}
	if (isNaN(num)) {
		num = 0;
	}
	if (eval(num) > 1) {
		alert("�����ж��δ�����˵����������˵�!!")
		return;
	}
	//add hujunbin 15.1.14 ��;����ʱ�Զ��˵�
	Bill();
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFIntPay&BillNo=' + BillNo;
	websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

function DelIntBill() {
	var truthBeTold = window.confirm(t['15']);
	if (!truthBeTold) {
		return
	}
	if (BillNo == "") {
		alert(t['01']);
		return
	}
	var encmeth = DHCWebD_GetObjValue('delbill');
	var num = cspRunServerMethod(encmeth, BillNo, Guser);
	if (num == '0') {
		alert(t['09']);
	}
	if (num != '0') {
		alert(t['10']);
		return;
	}
	var Findobj = document.getElementById('Find');
	Findobj.click();
}

function DelPay(lnk) {
	var truthBeTold = window.confirm(t['14']);
	if (!truthBeTold) {
		return;
	}
	if ((Adm == "") || (BillNo == "")) {
		alert(t['01']);
		return;
	}
	if (billstatus == "Bill") {
		alert(t['16']);
		return;
	}
	//�жϻ����Ƿ���ȡ������
	var encmeth = DHCWebD_GetObjValue('getpbflag');
	var pbflagstr = cspRunServerMethod(encmeth, BillNo);
	if (pbflagstr == "Abort") {
		alert(t['PbCancel01']);
		return;
	}
	if (pbflagstr == "QF") {
		alert(t['PbCancel02']);
		return;
	}
	if (pbflagstr == "PbNotPaid") {
		alert(t['PbCancel03']);
		return;
	}
	if (pbflagstr == "PbAlready") {
		alert(t['PbCancel04']);
		return;
	}
	if (pbflagstr == "TransErr") {
		var Flag = window.confirm("���˽���ʱת��Ԥ����,�Ƿ�ȷ��ȡ������,���ȡ������Ԥ���������.");
		if (!Flag) {
			return;
		} else {
			alert("���˵���;����ת����Ԥ����");
		}
	}
	//����ҽ����IPRevFootBack������ҽ������
	var ReturnValue = TransIPRevFootBack(Guser, BillNo, Adm);
	if (ReturnValue < 0) {
		alert("ҽ��ȡ������ʧ��.");
		return;
	}
	var invnoflag = "N";
	var invflag;
	var delpay = document.getElementById('delpay');
	if (delpay) {
		var encmeth = delpay.value;
	} else {
		var encmeth = '';
	}
	var str = cspRunServerMethod(encmeth, '', '', Adm, BillNo, Guser, RefFpPrtFlag, RefFpFlag);
	str = str.split("^");
	var num = str[0];
	var chprtrowid = str[3];
	var invflag = str[4];
	var chprt = str[5];
	if (num == 'null' && invflag == "Y") {
		alert(t['13']);
		return;
	}
	if (num == 'abort') {
		alert(t['PbCancel01']);
		return;
	}
	if (num == "QF") {
		alert(t['PbCancel02']);
		return;
	}
	if (num == "CloseAcountErr") {
		alert("���˵��Ѿ�����,������ȡ������.")
		return
	}
	if (num != '0') {
		alert(t['12']);
		return;
	}
	if (num == '0') {
		alert(t['11']);
	}
	if (chprt == "N") {
		return;
	}
	if (RefFpPrtFlag == "Y" && Tinvno != "" && chprt == "Y") {
		PrintFP(chprtrowid);
	}
	var Findobj = document.getElementById('Find');
	Findobj.click();
}

function getdata(value) {
	//modify 2006.2.28 by cx
	catedata = value.split("###");
	var mydata = catedata[0].split("&");
	for (i = 1; i < mydata.length; i++) {
		var tmpstrs = mydata[i];
		myData1 = tmpstrs.split("^");
		InPatCate[i - 1] = myData1;
	}
	if (catedata[1] != "") {
		var inpatdata = catedata[1].split("&");
		for (j = 1; j < inpatdata.length; j++) {
			var tmpstrs1 = inpatdata[j];
			var tmpstrs2 = tmpstrs1.split("^");
			InPatSubCate[j - 1] = tmpstrs2;
		}
	}
}

function PrintAdmInfo() {
	if (Adm == "") {
		alert(t['03']);
		return;
	}
	if (Adm != "") {
		var encmeth = DHCWebD_GetObjValue('printadminfo');
		var str = cspRunServerMethod(encmeth, '', '', Adm);
		if (str != "") {
			AdmInfoPrint(str)
		}
	}
}

function gettype() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		Type_lookuphandler();
	}
}

function getloc() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		Loc_lookuphandler();
	}
}

function readcard_click() {
	//clearall();
	var rtn = ReadCardClickHandler();
	if (rtn) {
		var Findobj = document.getElementById('Find');
		Findobj.click();
	}
}

function getpatinfo1() {
	if ((papnoobj.value != "") || (patzynoobj.value != "")) {
		p1 = papnoobj.value;
		var Medicare = patzynoobj.value;
		var encmeth = DHCWebD_GetObjValue('getadm');
		if (cspRunServerMethod(encmeth, 'setpat_val', '', p1, Medicare) == "") {
			alert("û�д˲�����Ϣ");
		}
	}
}

function FrameEnterkeyCode() {
	var e = window.event;
	switch (e.keyCode) {
	case 119:
		LinkBillDetail();
		break;
	case 118:
		clearall();
		break;
	case 119:
		var Findobj = document.getElementById('Find');
		Findobj.click();
		break;
	case 120:
		//LinkPay();    //2017-08-30 ZhYW ע��
		break;
	case 121:
		LinkAddDeposit();
		break;
	//case 123:
	case 117:  //�͵���F12��ͻ  �ĳ�F6
		LinkRefundDeposit();
		break;
	}
}

///Lid
///2010-07-09
///�˵��ɹ���A��ˢ�½���Aֻ���½�������
function UpdateFootData(BillNO) {
	//�����˵���,��ȡ�˵���Ľ�������
	var CH2 = String.fromCharCode(2);
	var ExpStr = "";
	var SelRowObj = document.getElementById('Tbillstatusz' + SelectedRow);
	var payedFlag = "";
	if (SelRowObj.innerText === "Bill") {
		payedFlag = "B";
	} else {
		payedFlag = "P";
	}
	//δ�����¼�޸�����
	if (payedFlag === "B") {
		//Ѻ��$c(2)�ܽ��^�Ը����^�ۿ۽��^���˽��
		var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "GetPatFeeByBillNO", BillNO, payedFlag, ExpStr);
		var tmpAry = rtn.split(CH2);
		var deposit = tmpAry[0];
		var patfeeInfo = tmpAry[1].split("^");
		var stAmt = tmpAry[2];
		depositobj.value = deposit;
		totalamountobj.value = patfeeInfo[1];
		amttopayobj.value = stAmt;
		if (eval(amttopayobj.value) < 0) {
			amttopayobj.style.color = "red";
		} else {
			amttopayobj.style.color = "black";
		}
		//����ѡ�м�¼������
		var SelRowObj = document.getElementById('Tdepositz' + SelectedRow);
		SelRowObj.innerText = deposit;
		var SelRowObj = document.getElementById('Ttotalamountz' + SelectedRow);
		SelRowObj.innerText = patfeeInfo[0];
		var SelRowObj = document.getElementById('Tpatientsharez' + SelectedRow);
		SelRowObj.innerText = patfeeInfo[1];
		//var SelRowObj = document.getElementById('Tdiscountamountz'+SelectedRow);
		//SelRowObj.value = patfeeInfo[2];    //TdiscountamountzԪ�ر�����
	}
}

///�����������Ԫ�ءAGetNotBillOrd,����UDHCJFBaseCommon�е�GetNotBillOrd�]Adm)
function GetNotBillOrd(Adm) {
	/*
	var NotBillOrdObj = document.getElementById('GetNotBillOrd');
	if (NotBillOrdObj) {
		var encmeth = NotBillOrdObj.value;
	} else {
		var encmeth = '';
	}
	var ReturnVal = cspRunServerMethod(encmeth,Adm);
	*/
	var ReturnVal = tkMakeServerCall("web.UDHCJFBaseCommon", "GetNotBillOrd", Adm);
	return ReturnVal;
}

///����Ʊ
function ReprintFP() {
	var Guser = session['LOGON.USERID'];
	DHCP_GetXMLConfig("InvPrintEncrypt", "DHCJFIPReceipt");
	if ((!Tinvno) || (Tinvno == " ")) {
		alert("δѡ�񲹴�Ʊ����Ϣ��û�в�����Ϣ");
		return;
	} else {
		var invrtn = tkMakeServerCall("web.UDHCJFPRINTINV", "GetInvflagByInvno", Tinvno, Guser);
		var prtinvflag = invrtn.split("^")[0];
		var prtinvrowid = invrtn.split("^")[1];
		var InvReasonDR = invrtn.split("^")[2];
		GetXMLName(InvReasonDR);
		if (prtinvflag != 1) {
			alert("�˷�Ʊ�����ش�");
			return;
		} else {
			var selecttrue = window.confirm("ȷ��Ҫ�ش�Ʊ��");
			if (!selecttrue) {
				return;
			}
			var prtinvrowid = prtinvrowid + "#" + "R"; //���Ӳ����־
			PrintFP(prtinvrowid);
		}
	}
}

function GetXMLName(InvReasonDR) {
	if ((Adm == "") || (BillNo == "")) {
		return;
	}
	if ((Tinvno == "") || (Tinvno == " ")) {
		return;
	}
	GetAdmReaNationCodeByAdm(Adm);
	var XMLName = tkMakeServerCall("web.UDHCJFBaseCommon", "GetInvXMLName", AdmReasonId);
	if (XMLName == "") {
		DHCP_GetXMLConfig("InvPrintEncrypt", "DHCJFIPReceipt");
	} else {
		DHCP_GetXMLConfig("InvPrintEncrypt", XMLName);
	}
}

function GetAdmReaNationCodeByAdm(Adm) {
	var encmeth = DHCWebD_GetObjValue('GetAdmReaNationCode');
	var GetAdmReasonStr = cspRunServerMethod(encmeth, Adm);
	var GetAdmReasonStrDetail = GetAdmReasonStr.split("^");
	AdmReasonId = GetAdmReasonStrDetail[0];
	AdmReasonNationCode = GetAdmReasonStrDetail[1];
}

///��ҽ������˵�
function LinkIntBillDetail() {
	if (BillNo == " " || BillNo == "") {
		alert("�˲���û���˵�,���ܲ���˵�");
		return;
	}
	if (billstatus == "Paid") {
		alert("���˵��Ѿ�����,���ܲ���˵�");
		return;
	}
	//�˺�����;��ĳЩ���͵�ҽ�����˲��ܽ�����;����
	var InitPayflag = DoNotInitPay();
	if (InitPayflag == false) {
		alert(t['HXEY01']);
		return;
	}
	var encmeth = DHCWebD_GetObjValue('getjudge');
	var num = cspRunServerMethod(encmeth, '', '', Adm);
	if ((num == "") || (num == " ")) {
		num = 0;
	}
	if (isNaN(num)) {
		num = 0;
	}
	if (eval(num) > 1) {
		alert("�����ж��δ�����˵����������˵�!!");
		return;
	}
	var RegNo = RegistrationNoobj.value;
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBILLOEORIItemGroup&EpisodeID=' + Adm + '&BillNo=' + BillNo + '&Guser=' + Guser;
	websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

function CloseAcount_click() {
	if ((Adm == "") || (Adm == " ")) {
		alert("��ѡ������˵��˵�");
		return;
	}
	if ((BillNo == "") || (BillNo == " ")) {
		alert("��ѡ������˵��˵�");
		return;
	}
	if (RefundFlag == "B") { //yyx 2009-09-24 bug�޸�
		alert("���˵��Ѿ����,���������");
		return;
	}
	Bill();
	var encmeth = DHCWebD_GetObjValue('getjudge');
	var num = cspRunServerMethod(encmeth, '', '', Adm);
	if (num == '1') {
		if ((billednoobj.value != Adm) && (billstatus != "Paid")) {
			alert(t['02']);
			return;
		}
	}
	/*
	var encmeth = DHCWebD_GetObjValue('getjudge');
	var num = cspRunServerMethod(encmeth,'','',Adm);
	if (num == '1'){
		if ((billednoobj.value != Adm) && (billstatus!="Paid")) {
			alert(t['02']);
			return;
		}
	}
	*/

	var WshNetwork = new ActiveXObject("WScript.NetWork");
	var computername = WshNetwork.ComputerName;
	var RetCode = tkMakeServerCall("web.DHCIPBillPBCloseAcount", "PaidPatientbill", Adm, BillNo, Guser, computername);
	if (RetCode == "0") {
		alert("���˳ɹ�.");
		return;
	} else {
		alert("����ʧ��:"+RetCode);
		return;
	}
}

function GetPaidCAcountFlag() {
	if (Adm == "" || BillNo == "") {
		return "N";
	}
	var RetCode = tkMakeServerCall("web.DHCIPBillPBCloseAcount", "GetPaidCAcountFlag", BillNo);
	return RetCode;
}

function UnCloseAcount_click() {
	if ((Adm == "") || (Adm == " ")) {
		alert("��ѡ����ȡ�����˵��˵�");
		return;
	}
	if ((BillNo == "") || (BillNo == " ")) {
		alert("��ѡ����ȡ�����˵��˵�");
		return;
	}
	if (RefundFlag == "B") {
		alert("���˵��Ѿ����,������ȡ������");
		return;
	}
	var PaidCAcountFlag = GetPaidCAcountFlag();
	if (PaidCAcountFlag != "Y") {
		alert("���˵�����ȡ������");
		return;
	}
	var WshNetwork = new ActiveXObject("WScript.NetWork");
	var computername = WshNetwork.ComputerName;
	var RetCode = tkMakeServerCall("web.DHCIPBillPBCloseAcount", "UnCloseAcount", Adm, BillNo, Guser, computername);
	if (RetCode == "0") {
		alert("ȡ�����ʳɹ�");
		var Findobj = document.getElementById('Find');
		Findobj.click();
		//Lid 2010-07-09 �˵��ɹ���ˢ�½���
		return;
	}else {
		if (RetCode == "AdmNull") {
			alert("��ѡ����ȡ�����˵��˵�");
			return;
		} else if (RetCode == "ErrNull") {
			alert("���˵�����ȡ������");
			return;
		} else if (RetCode == "AlreadyPRT") {
			alert("���˵��Ѿ����㲻��ȡ������");
			return;
		}else if (RetCode == "CofimOK") {
			alert("�Ѿ����,����ȡ������.");
			return;
		} else {
			alert("ȡ������ʧ��,�������:" + RetCode);
			return;
		}
	}
}

//hujunbin ѡ��ͷ�˵�
function selectTabBar(preId, newId) {
	if (window.parent) {
		var PreBarObj = window.parent.document.getElementById(preId);
		var menuBarObj = window.parent.document.getElementById(newId);
		if (menuBarObj) {
			var href = menuBarObj.getAttribute("jshref");
			var target = menuBarObj.getAttribute("target");
			var blankOpt = menuBarObj.getAttribute("blankOpt");
			if (href == "#") {
				event.preventDefault();
				event.stopPropagation();
				return false;
			}
			if (menuBarObj) {
				PreBarObj.getAttribute("style")["border-color"] = "";
				PreBarObj.getAttribute("style")["color"] = "";
				PreBarObj.getAttribute("style")["background"] = "";
			}
			if (menuBarObj) {
				//menuBarObj.getAttribute("style")["border-color"] = "#b7d2ff";
				//menuBarObj.getAttribute("style")["color"] = "#ffffff";
				//menuBarObj.getAttribute("style")["background"] = "#1369c0";
			}
			window.location.href = href;
		}
	}
}

/**
* Creator: ZhYW
* CreatDate: 2017-09-13
*/
function clearLoc() {
	var loc = websys_$V("Loc");
	if (loc == ""){
		DHCWebD_SetObjValueB("locid", "");
	}
}

function clearType() {
	var type = websys_$V("Type");
	if (type == ""){
		DHCWebD_SetObjValueB("typeid", "");
	}
}

document.body.onload = BodyLoadHandler;
