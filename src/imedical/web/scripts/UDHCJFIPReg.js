/// UDHCJFIPReg.js

//document.write("<object ID='PrtBarcode' CLASSID='CLSID:F2E4AC41-73B7-49E5-B7A4-80B2654B19F4' CODEBASE='../addins/client/JFPrint.CAB#version=1,0,0,0'>");
//document.write("</object>");

var papnoobj, papmiidobj, papnameobj, medicareobj, paperidobj;
var birthdateobj, ageobj, adressobj, companyobj;
var hometelobj, worktelobj, mobtelobj, emailobj;
var SexObj, admdateobj, admtimeobj, usernameobj, deposittypeobj, pyobj, bankobj;
var admreasonobj, admepisobj, mardescobj, rlgdescobj, admdocobj;
var admidobj, admvisitobj, admdocidobj, bankidobj, admreaidobj;
var admepisidobj, pyidobj, deptypeobj, moderowidobj, bankrowidobj;
var admsearchobj, admdepobj, admdepidobj, admwardobj, admwardidobj;
var sexidobj, mardescidobj, rlgdescid;
var zipcodeobj, zipidobj, cityobj, cityidobj, provdescobj, providobj;
var ageyrobj, agemthobj, agedayobj;
var bedobj, bedidobj, roomobj, roomidobj;
var yjamtobj, admqkobj, admqkidobj;
var Guser, gusername, gusercode, UserLoc;
var AskedForSaveAddress = 0;
var CurNo, EndNo, Title;
var Adm, path, returnval;
var curyear, curmon, curday;
var cardCheckNo, opcardnoobj;
var computername = "";
var opcardid = "";
var SocSatdescobj, SocSatidobj, admqkobj, admqkidobj;
var nationdescobj, nationidobj, deptcompobj, cardnoobj, banksubobj;
var cardtypeobj, cardtypeidobj, govcardnoobj, countryobj, countryidobj;
var occuobj, occuidobj, eduobj, eduidobj, languobj, languidobj;
var emptypeobj, emptypeidobj, homeplaceobj, birprovobj, bircityobj;
var ctrltdescobj, ctrltidobj, ForeignIdobj, FPhoneobj, FAddressobj;
var FNotesobj, AdmTimesobj, cityareaobj, cityareaidobj;
var AbortYJprtFlag, DepositFlag, PatinFlag, AgeFlag, LinkDepositFlag, PapnoFlag;
var babybirobj;
var babydob1, babydob2;
var diagnosobj, diagnosidobj, diagnosdescobj, digtypeobj, digtypeidobj;
var newcardnoobj, InsuNoObj, AdmSourceObj, AdmSourceIDObj;    //入院途径
var AdmRefPriorityObj, AdmRefPriorityIDObj;
var m_IDCredTypePlate = "01";    //身份证代码字段
var m_Adddeposit = "";
//+2017-08-17 ZhYW 
var m_PhotoObj = "";

function BodyLoadHandler() {
	babydob1 = "";
	babydob2 = "";
	RcptFlag = 'Y';
	PrtFlag = 'N';
	AgeFlag = 'N';
	getzyjfconfig();
	document.onkeydown = FrameEnterkeyCode;
	//读医保卡
	var obj = document.getElementById('ReadInsuCard');
	if (obj) {
		obj.onclick = ReadInsuCard_OnClick;
	}
	//护士站住院登记成功后不弹是否交押金界面
	m_Adddeposit = websys_$V('AddDeposit');
	AbortYJprtFlag = 'Y';
	Guser = session['LOGON.USERID'];
	gusercode = session['LOGON.USERCODE'];
	gusername = session['LOGON.USERNAME'];
	UserLoc = session['LOGON.CTLOCID'];
	document.getElementById('UserGrp').value = session['LOGON.GROUPID'];
	usernameobj = document.getElementById('username');
	usernameobj.value = gusername;
	usernameobj.readOnly = true;
	var WshNetwork = new ActiveXObject("WScript.NetWork");
	computername = WshNetwork.ComputerName;
	newcardnoobj = document.getElementById('newcardno');
	opcardnoobj = document.getElementById('opcardno');
	papnoobj = document.getElementById('Regno');
	papmiidobj = document.getElementById('papmiid');
	papnameobj = document.getElementById('name');
	medicareobj = document.getElementById('Medicare');
	SexObj = document.getElementById('sex');
	sexidobj = document.getElementById('sexid');
	paperidobj = document.getElementById('paperid');
	birthdateobj = document.getElementById('birthdate');
	ageobj = document.getElementById('age');
	mardescobj = document.getElementById('mardesc');
	mardescidobj = document.getElementById('mardescid');
	rlgdescobj = document.getElementById('rlgdesc');
	rlgdescidobj = document.getElementById('rlgdescid');
	addressobj = document.getElementById('address');
	hometelobj = document.getElementById('hometel');
	zipcodeobj = document.getElementById('zipcode');
	zipidobj = document.getElementById('zipid');
	companyobj = document.getElementById('company');
	worktelobj = document.getElementById('worktel');
	cityobj = document.getElementById('CTCITDesc');
	cityidobj = document.getElementById('cityid');
	provdescobj = document.getElementById('PROVDesc');
	providobj = document.getElementById('provid');
	mobtelobj = document.getElementById('mobtel');
	emailobj = document.getElementById('Email');
	ageyrobj = document.getElementById('ageyr');
	agemthobj = document.getElementById('agemth');
	agedayobj = document.getElementById('ageday');
	SocSatdescobj = document.getElementById('SocSatdesc');
	SocSatidobj = document.getElementById('SocSatid');
	nationdescobj = document.getElementById('nationdesc');
	nationidobj = document.getElementById('nationid');
	cardtypeobj = document.getElementById('CardType');
	cardtypeidobj = document.getElementById('CardTypeid');
	govcardnoobj = document.getElementById('GovCardno');
	countryobj = document.getElementById('Country');
	babybirobj = document.getElementById('babybir');
	var agehourobj = document.getElementById('agehour');
	var ageMinutesobj = document.getElementById('ageMinutes');
	countryidobj = document.getElementById('Countryid');
	occuobj = document.getElementById('Occupation');
	occuidobj = document.getElementById('Occuid');
	eduobj = document.getElementById('Education');
	eduidobj = document.getElementById('Educatid');
	languobj = document.getElementById('Language');
	languidobj = document.getElementById('Languid');
	emptypeobj = document.getElementById('EmployeeType');
	emptypeidobj = document.getElementById('EmpTypeid');
	homeplaceobj = document.getElementById('HomePlace');
	birprovobj = document.getElementById('BirthProvid');
	bircityobj = document.getElementById('BirthCityid');
	ctrltdescobj = document.getElementById('Ctrltdesc');
	ctrltidobj = document.getElementById('Ctrltid');
	ForeignIdobj = document.getElementById('ForeignId');
	FPhoneobj = document.getElementById('ForeignPhone');
	FAddressobj = document.getElementById('ForeignAddress');
	FNotesobj = document.getElementById('ForeignNotes');
	cityareaobj = document.getElementById('cityarea');
	cityareaidobj = document.getElementById('cityareaid');
	admsearchobj = document.getElementById('admsearch');
	admidobj = document.getElementById('admid');
	admvisitobj = document.getElementById('admvisit');
	admdepobj = document.getElementById('admdep');
	admdepidobj = document.getElementById('admdepid');
	admwardobj = document.getElementById('admward');
	admwardidobj = document.getElementById('admwardid');
	bedobj = document.getElementById('admbedno');
	bedidobj = document.getElementById('bedrowid');
	roomobj = document.getElementById('ROOMDesc');
	roomidobj = document.getElementById('roomrowid');
	admdocobj = document.getElementById('admdoc');
	admdocidobj = document.getElementById('admdocid');
	admreasonobj = document.getElementById('admreason');
	admreaidobj = document.getElementById('admreasonid');
	admepisobj = document.getElementById('admepis');
	admepisidobj = document.getElementById('admepisid');
	admdateobj = document.getElementById("admdate");
	admtimeobj = document.getElementById("admtime");
	admqkobj = document.getElementById("admqingk");
	admqkidobj = document.getElementById("admqkid");
	AdmTimesobj = document.getElementById('AdmTimes');
	diagnosobj = document.getElementById('Diagnos');
	diagnosidobj = document.getElementById('Diagnosid');
	diagnosdescobj = document.getElementById('Diagnosdesc');
	digtypeobj = document.getElementById('DiagnosType');
	digtypeidobj = document.getElementById('DiagnosTypeid');
	var RefDocListobj = document.getElementById('RefDocList');
	if (RefDocListobj) {
		RefDocListobj.onkeydown = getrefdoc;
	}
	deposittypeobj = document.getElementById('deposittype');
	deptypeobj = document.getElementById('deptype');
	pyobj = document.getElementById('paymode');
	moderowidobj = document.getElementById('moderowid');
	bankobj = document.getElementById('bank');
	bankrowidobj = document.getElementById('bankrowid');
	yjamtobj = document.getElementById('payamt');
	deptcompobj = document.getElementById('deptcomp');
	cardnoobj = document.getElementById('cardno');
	banksubobj = document.getElementById('banksub');
	InsuNoObj = document.getElementById('InsuNo');
	AdmSourceObj = document.getElementById('AdmSource');
	AdmSourceIDObj = document.getElementById('AdmSourceID');
	AdmRefPriorityObj = document.getElementById('AdmPriority');     //入院病情
	AdmRefPriorityIDObj = document.getElementById('AdmPriorityID'); //入院病情
	//+2017-08-17 ZhYW
	m_PhotoObj = websys_$('PhotoInfo');
	
	getcurdate();
	//clear_click();
	//读取二带身份证  2012-02-14
	var readpersonobj = document.getElementById('readperson');
	if (readpersonobj) {
		readpersonobj.onclick = readperson_click;
	}
	if (papnoobj) {
		papnoobj.onkeydown = getpatinfo;
	}
	if (medicareobj) {
		medicareobj.onkeydown = getpatinfo;   //yyx2007-04-02
	}
	if (zipcodeobj) {
		zipcodeobj.onkeydown = getzipcode;
	}
	if (deposittypeobj) {
		deposittypeobj.onkeydown = getdeptype;
	}
	if (pyobj) {
		pyobj.onkeydown = getpy;
	}
	if (bankobj) {
		bankobj.onkeydown = getbank;
	}
	if (cardnoobj) {
		cardnoobj.onkeydown = entercardno;
	}
	if (banksubobj) {
		banksubobj.onkeydown = enterbanksub;
	}
	if (cityareaobj) {
		cityareaobj.onkeydown = entercityarea;
	}
	//add 2007 01 25 for Insurance
	INSURegObj = document.getElementById('INSUReg');
	if (INSURegObj) {
		INSURegObj.onclick = INSUReg_click;
	}
	if (admreasonobj) {
		admreasonobj.onkeydown = getadmreason;
	}
	if (SexObj) {
		SexObj.onkeydown = getsex;
	}
	if (mardescobj) {
		mardescobj.onkeydown = getmardesc;
	}
	if (rlgdescobj) {
		rlgdescobj.onkeydown = getrlgdesc;
	}
	if (admdocobj) {
		admdocobj.onkeydown = getadmdoc;
	}
	if (admepisobj) {
		admepisobj.onkeydown = getadmepis;
	}
	if (birthdateobj) {
		birthdateobj.onkeydown = getage;
	}
	var regsaveobj = document.getElementById('regsave');
	if (regsaveobj) {
		regsaveobj.onclick = regsave_click;
	}
	var clearobj = document.getElementById('clear');
	if (clearobj) {
		clearobj.onclick = clear_click;
	}
	var clearadmobj = document.getElementById('clearadm');
	if (clearadmobj) {
		clearadmobj.onclick = clearadm_click;
	}
	var btnyjobj = document.getElementById('BtnPrint');
	if (btnyjobj) {
		if (LinkDepositFlag == "Y") {
			if (DepositFlag == "N") {
				btnyjobj.onclick = LinkaddDeposit_click;
			} else {
				getyjinfo();
				btnyjobj.onclick = Add_click;
			}
		} else {
			DHCWeb_DisBtn(btnyjobj);
		}
	}
	var yjsearch = document.getElementById('yjsearch');
	if (yjsearch) {
		yjsearch.onclick = yjsearch_click;
	}
	//yjsearch.style.visibility = "hidden";
	var admfin = document.getElementById('admfin');
	if (admfin) {
		admfin.onclick = admfin_click;
	}
	var readcard = document.getElementById('readcard');
	if (readcard) {
		readcard.onclick = readcard_click;
	}
	var regupdate = document.getElementById('regupdate');
	if (regupdate) {
		regupdate.onclick = regupdate_click;
	}
	var admupdate = document.getElementById('admupdate');
	if (admupdate) {
		admupdate.onclick = admupdate_click;
	}
	var patupsearch = document.getElementById('patupsearch');
	if (patupsearch) {
		patupsearch.onclick = patupsearch_click;
	}
	var admcancel = document.getElementById('admcancel');
	if (admcancel) {
		admcancel.onclick = admcancel_click;
	}
	if (PatinFlag == "N") {
		admdateobj.onkeydown = getadmdate;
	}
	if (papnameobj) {
		papnameobj.onkeydown = enterpatname;
	}
	/*
	if (medicareobj){
		medicareobj.onkeydown = entermedicare;    //yyx2007-04-02
	}
	*/
	if (paperidobj) {
		//paperidobj.onchange = paperidonchange;
		paperidobj.onkeydown = enterpaperid;
	}
	if (addressobj) {
		addressobj.onkeydown = enteraddress;
	}
	if (hometelobj) {
		hometelobj.onkeydown = enterhometel;
	}
	if (companyobj) {
		companyobj.onkeydown = entercompany;
	}
	if (worktelobj) {
		worktelobj.onkeydown = enterworktel;
	}
	if (emailobj) {
		emailobj.onkeydown = enteremail;
	}
	if (mobtelobj) {
		mobtelobj.onkeydown = entermobtel;
	}
	if (cardtypeobj) {
		cardtypeobj.onkeydown = entercardtype;
	}
	if (govcardnoobj) {
		govcardnoobj.onchange = govcardnooncharge;
		govcardnoobj.onkeydown = entergovcardno;
	}
	if (countryobj) {
		countryobj.onkeydown = entercountry;
	}
	if (occuobj) {
		occuobj.onkeydown = enteroccu;
	}
	if (eduobj) {
		eduobj.onkeydown = enteredu;
	}
	if (languobj) {
		languobj.onkeydown = enterlangu;
	}
	if (emptypeobj) {
		emptypeobj.onkeydown = enteremptype;
	}
	if (homeplaceobj) {
		homeplaceobj.onkeydown = enterhomeplace;
	}
	if (ctrltdescobj) {
		ctrltdescobj.onkeydown = enterctrlt;
	}
	if (ForeignIdobj) {
		ForeignIdobj.onkeydown = enterForeignId;
	}
	if (FPhoneobj) {
		FPhoneobj.onkeydown = enterFPhone;
	}
	if (FAddressobj) {
		FAddressobj.onkeydown = enterFAddress;
	}
	if (FNotesobj) {
		FNotesobj.onkeydown = enterFNotes;
	}
	if (babybirobj) {
		babybirobj.onkeydown = enterbaby;
	}
	if (agehourobj) {
		agehourobj.onkeydown = enterbaby;
	}
	if (ageMinutesobj) {
		ageMinutesobj.onkeydown = enterbaby;
	}
	if (bedobj) {
		bedobj.onkeydown = getadmbedno;
	}
	if (admdepobj) {
		admdepobj.onkeydown = getadmdep;
	}
	if (admwardobj) {
		admwardobj.onkeydown = getadmward;
	}
	if (admqkobj) {
		admqkobj.onkeydown = getadmryqk;
	}
	if (SocSatdescobj) {
		SocSatdescobj.onkeydown = getSocSat;
	}
	if (diagnosobj) {
		diagnosobj.onkeydown = getdiagnos;
	}
	if (digtypeobj) {
		digtypeobj.onkeydown = getdigtype;
	}
	if (yjamtobj) {
		yjamtobj.onkeydown = enteryjamt;
	}
	if (ageobj) {
		ageobj.onkeydown = getbirday;
	}
	if (birthdateobj) {
		birthdateobj.onkeydown = getage;
	}
	if (nationdescobj) {
		nationdescobj.onkeydown = getnation;
	}
	if (deptcompobj) {
		deptcompobj.onkeydown = entercomp;
	}
	var HCPDescobj = document.getElementById('HCPDesc');
	if (HCPDescobj) {
		HCPDescobj.onkeydown = enterhcp;
	}
	var encmeth = DHCWebD_GetObjValue('getpath');
	path = cspRunServerMethod(encmeth, '', '');
	var refdep = document.getElementById('refdep');
	if (refdep) {
		refdep.onclick = refunddeposit_click;
	}
	elementformat();
	//add 2007-03-19
	FindObj = document.getElementById('FindPatInfo');
	if (FindObj) {
		FindObj.onclick = Find_click;
	}
	//insert by cx 2007.10.23
	if (newcardnoobj) {
		newcardnoobj.onkeydown = getnewcardinfo;
	}
	//insert by cx 2007.11.19
	var obj = document.getElementById('OPCardType');
	if (obj) {
		obj.size = 1;
		obj.multiple = false;
		loadCardType();
		obj.onchange = OPCardType_OnChange;
	}
	var myobj = document.getElementById('PROVDesc');
	if (myobj) {
		myobj.onkeydown = getProvince;
	}
	var myobj = document.getElementById('CTCITDesc');
	if (myobj) {
		myobj.onkeydown = getCity;
	}
	var myobj = document.getElementById('PAPERBirthProvince');
	if (myobj) {
		myobj.onkeydown = getBirthProvince;
	}
	var myobj = document.getElementById('BirthCity');
	if (myobj) {
		myobj.onkeydown = getBirthCity;
	}
	var myobj = document.getElementById('BirthArea');
	if (myobj) {
		myobj.onkeydown = getBirthArea;
	}
	var myobj = document.getElementById('BirthAddress');
	if (myobj) {
		myobj.onkeydown = getBirthAddress;
	}
	var myobj = document.getElementById('HouseProvince');
	if (myobj) {
		myobj.onkeydown = getHouseProvince;
	}
	var myobj = document.getElementById('HouseCity');
	if (myobj) {
		myobj.onkeydown = getHouseCity;
	}
	var myobj = document.getElementById('HouseArea');
	if (myobj) {
		myobj.onkeydown = getHouseArea;
	}
	var myobj = document.getElementById('HouseZipCode');
	if (myobj) {
		myobj.onkeydown = getHouseZipCode;
	}
	var obj = document.getElementById('opcardno');
	if (obj) {
		obj.onkeydown = getPatByCardNo; //2015-3-4 hujunbin 封装了方法 CardNoKeydownHandler;
	}
	var PrtWCinctureobj = document.getElementById('PrtWCincture');
	if (PrtWCinctureobj) {
		PrtWCinctureobj.onclick = Prt_WCinctureo;
	}
	//儿童腕带打印  add zhli  18.11.22
	var PrtWCinctureobj = document.getElementById('PrtWCinctureChild');
	if (PrtWCinctureobj) {
		PrtWCinctureobj.onclick = Prt_WCinctureoChild;
	}
	//update by zf 20150317 接诊初始化
	if (typeof InitReceipt != 'undefined') {
		InitReceipt();
	}
	//
	var UpInPatNoObj = document.getElementById('BtnUpdInPatNo');
	if (UpInPatNoObj) {
		UpInPatNoObj.onclick = UpInPatNo_click;
	}
	document.getElementById('UserDepID').value = session['LOGON.CTLOCID'];
	//住院证查询连接
	if (papnoobj.value != "") {
		getpatinfo1();
	}
	
	SetDefAdmValue();
	
	var UPDiagnosobj = document.getElementById('BtnUPDiagnos');
	if (UPDiagnosobj) {
		UPDiagnosobj.onclick = UPDiagnos_click;
	}
	var CancelInsuAdmObj = document.getElementById('BtnCancelInsuAdm');
	if (CancelInsuAdmObj) {
		CancelInsuAdmObj.onclick = CancelInsuAdm_click;
	}
	//+2017-08-21 ZhYW
	if (admdateobj){
		admdateobj.onblur = FormatDate_OnBlur;
	}
	//+2017-06-02 ZhYW 控制只能输入正整数 (UDHCJFFormat.js)
	if (AdmTimesobj){
		AdmTimesobj.onkeyup = CheckPositiveInteger;
	}
}

function Find_click() {
	var birth = birthdateobj.value;
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillPAPERInfo&PAPERName=" + papnameobj.value + "&PAPERNo=" + papnoobj.value + "&PAPERRowid=" + papmiidobj.value + "&Sex=" + SexObj.value + "&SexDr=" + sexidobj.value + "&PAPERID=" + paperidobj.value + "&BirthDate=" + birth + "&InsuNo=" + InsuNoObj.value;
	websys_createWindow(lnk, 'UDHCJFIPReg', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

function enterpatname() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if ((key == 13) || (key == 9)) {
		if (papnameobj.value == "") {
			alert(t['12']);
			return;
		} else {
			var namestr = papnameobj.value;
			var namestr1 = GetSpellCodeNew(namestr);
			document.getElementById('pycode').value = namestr1;
			gettoday();
		}
		//mdofiy 2014-11-19 增加判断病人姓名、性别、出生日期一致时给予提示;身份证作为唯一索引查找是否有病人信息
		if (papmiidobj.value == "") {
			var rtn = CheckAlreadyPAPER();
		}
		DHCWeb_Nextfocus();
	}
}

function entermedicare() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

function paperidonchange() {
	PaperIDErr();
}

function enterpaperid() {
	var ageyear;
	var agemon;
	var ageday;
	var agebir;
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		PaperIDErr();
		
	}
}

function PaperIDErr() {
	var mypId = DHCWebD_GetObjValue("paperid");
	mypId = mypId.toUpperCase();
	var myary = DHCWeb_GetInfoFromId(mypId);
	if (myary[0] == "1") {
		DHCWebD_SetObjValueC("birthdate", myary[2]);
		DHCWebD_SetObjValueC("age", myary[4]);
		//Sex
		var mySexDR = "";
		switch (myary[3]) {
		case "男":
			mySexDR = "1";
			break;
		case "女":
			mySexDR = "2";
			break;
		default:
			mySexDR = "4";
			break;
		}
		DHCWebD_SetObjValueC("sex", myary[3]);
		DHCWebD_SetObjValueC("sexid", mySexDR);
		//mdofiy 2014-11-19 增加判断病人姓名、性别、出生日期一致时给予提示;身份证作为唯一索引查找是否有病人信息
		if (papmiidobj.value == "") {
			//papmiidobj.value = mypId;
			var rtn = CheckAlreadyPAPER();
		}
	} else {
		websys_setfocus('paperid');
		return;
	}
	DHCWeb_Nextfocus();
}

function enteraddress() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

function enterhometel() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

function entercompany() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

function enteremail() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

function entermobtel() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

function enterworktel() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

function enteryjamt() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		var payamt = document.getElementById('payamt').value;
		var encmeth = DHCWebD_GetObjValue('getamtdx');
		var amtdx = cspRunServerMethod(encmeth, "", "", payamt);
		document.getElementById('amtdx').value = amtdx;
		DHCWeb_Nextfocus();
	}
}

function getnation() {
	if (window.event.keyCode == 13) {
		var nationstr = nationdescobj.value;
		if (nationstr != t['66']) {
			window.event.keyCode = 117;
			var e = event ? event : (window.event ? window.event : null);
			e.isLookup = true;
			nationdesc_lookuphandler(e);
		} else {
			DHCWeb_Nextfocus();
		}
	}
}

function getage() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if ((key == 13) || (key == 9)) {
		var p1 = birthdateobj.value;
		if (p1 == "") {
			alert(t['09']);
			websys_setfocus('birthdate');
			return;
		}
		var getage1flag = getage1();
		if (getage1flag != true) {
			websys_setfocus("birthdate");
			return;
		}
		//mdofiy 2014-11-19 增加判断病人姓名、性别、出生日期一致时给予提示;身份证作为唯一索引查找是否有病人信息
		if (papmiidobj.value == "") {
			var rtn = CheckAlreadyPAPER();
		}
		DHCWeb_Nextfocus();
	}
}

function getage1() {
	var p1 = birthdateobj.value;
	if (p1 == "") {
		alert(t['09']);
		websys_setfocus('birthdate');
		return;
	} else {
		var DateFlag = FormatDate('birthdate');
		if (DateFlag != true) {
			websys_setfocus('birthdate');
			return false;
		}
		var p2 = birthdateobj.value;
		var p3 = admdateobj.value;
		/*
		var encmeth = DHCWebD_GetObjValue('getage');
		var agestr = cspRunServerMethod(encmeth, p2, p3);
		*/
		//modify hu 14.12.13
		var agestr = tkMakeServerCall("web.UDHCJFCOMMON", "DispPatAge", p2, p3);
		var agestr1 = agestr.split("||");
		ageobj.value = agestr1[0];
		ageyrobj.value = agestr1[1];
		agemthobj.value = agestr1[2];
		agedayobj.value = agestr1[3];
		//add hujunbin 14.12.13 但修改日期后回车自动清空新生儿年龄
		var agehourobj = document.getElementById('agehour');
		var ageMinutesobj = document.getElementById('ageMinutes');
		if (babybirobj && agehourobj && ageMinutesobj) {
			babybirobj.value = "";
			agehourobj.value = "";
			ageMinutesobj.value = "";
		}
		babydob1 = "";
		babydob2 = "";
		return true;
	}
	DHCWeb_Nextfocus();
}

//add hu 14.12.13
function getage2(babybirthdate, babybirthtime) {
	var p1 = birthdateobj.value;
	if (p1 == "") {
		alert(t['09']);
		websys_setfocus('birthdate');
		return;
	} else {
		var p2 = birthdateobj.value;
		var p3 = admdateobj.value;
		var babyadmtime = "";
		var babyadmtimeobj = document.getElementById("admtime");
		if (babyadmtimeobj) {
			babyadmtime = babyadmtimeobj.value;
		}
		/*
		var encmeth = DHCWebD_GetObjValue('getage');
		var agestr = cspRunServerMethod(encmeth, p2, p3);
		*/
		//modify hu 14.12.13
		var agestr = tkMakeServerCall("web.UDHCJFCOMMON", "DispPatAge", p2, p3, babybirthtime, babyadmtime);
		var agestr1 = agestr.split("||");
		ageobj.value = agestr1[0];
		ageyrobj.value = agestr1[1];
		agemthobj.value = agestr1[2];
		agedayobj.value = agestr1[3];
	}
	DHCWeb_Nextfocus();
}

function getbirday() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		if (AgeFlag == "Y") {
			return;
		}
		var p1 = ageobj.value;
		var encmeth = DHCWebD_GetObjValue('getbirthday');
		var birstr = cspRunServerMethod(encmeth, p1);
		if (birthdateobj.value == "") {
			birthdateobj.value = birstr;
		}
		var p2 = birthdateobj.value;
		var p3 = admdateobj.value;
		/*
		var encmeth = DHCWebD_GetObjValue('getage');
		var agestr = cspRunServerMethod(encmeth, p2, p3);
		*/
		// modify hu 14.12.13
		var agestr = tkMakeServerCall("web.UDHCJFCOMMON", "DispPatAge", p2, p3);
		var agestr1 = agestr.split("||");
		//ageobj.value = agestr1[0];
		ageyrobj.value = agestr1[1];
		agemthobj.value = agestr1[2];
		agedayobj.value = agestr1[3];
		DHCWeb_Nextfocus();
	}
}

function GetRcptNo(value) {
	var sub = value.split("^");
	var rcptrowid = sub[0];
	if (rcptrowid == "") {
		alert(t['24']);
		return false;
	}
	EndNo = sub[1];
	CurNo = sub[2];
	Title = sub[3];
	var obj = document.getElementById('currentno');
	obj.value = CurNo;
}

function getsex() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		sex_lookuphandler(e);
		//mdofiy 2014-11-19 增加判断病人姓名、性别、出生日期一致时给予提示;身份证作为唯一索引查找是否有病人信息
		DHCWeb_Nextfocus();
	} else if (window.event.keyCode == 9) {
		if (("f" === this.value) || ("F" === this.value) || ("女" === this.value) || ("nv" === this.value)) {
			this.value = "女";
		} else if (("m" === this.value) || ("M" === this.value) || ("男" === this.value) || ("nan" === this.value)) {
			this.value = "男";
		} else {
			this.value = "";
		}
		var encmeth = DHCWebD_GetObjValue('GetSexDr');
		SexDr = cspRunServerMethod(encmeth, this.value);
		if (SexDr != "") {
			SexDr = SexDr.split("^");
			sexidobj.value = SexDr[0];
			//mdofiy 2014-11-19 增加判断病人姓名、性别、出生日期一致时给予提示;身份证作为唯一索引查找是否有病人信息
			if (papmiidobj.value == "") {
				var rtn = CheckAlreadyPAPER();
			}
		}
		DHCWeb_Nextfocus();
	}
}

function getmardesc() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		mardesc_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function getrlgdesc() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		rlgdesc_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function getzipcode() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		zipcode_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function getadmdep() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		admdep_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function getadmward() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		admward_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function getadmbedno() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		admbedno_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function getadmdoc() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		admdoc_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function getadmreason() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		admreason_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function getadmepis() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		admepis_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function getadmryqk() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		admqingk_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function getdeptype() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		deposittype_lookuphandler(e);
	}
}

function getpy() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		paymode_lookuphandler(e);
		elementformat()
	}
}

function getbank() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		bank_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function enterbanksub() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

function getSocSat() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		SocSatdesc_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function LookUpsex(str) {
	var obj = document.getElementById('sexid');
	var tem = str.split("^");
	obj.value = tem[2];
	//mdofiy 2014-11-19 增加判断病人姓名、性别、出生日期一致时给予提示;身份证作为唯一索引查找是否有病人信息
	if (papmiidobj.value == "") {
		var rtn = CheckAlreadyPAPER();
	}
}

function nationlookup(str) {
	var obj = document.getElementById('nationid');
	var tem = str.split("^");
	obj.value = tem[1];
}

function LookUpadmdep(str) {
	var obj = document.getElementById('admdepid');
	var tem = str.split("^");
	obj.value = tem[1];
	var DepID = tem[1];
	var obj = document.getElementById('bedrowid'); // add by zhl  shenyang
	obj.value = "";
	var obj = document.getElementById('roomrowid');
	obj.value = "";
	roomobj.value = "";
	var obj = document.getElementById('admbedno');
	obj.value = "";
	var obj = document.getElementById('admwardid');
	obj.value = "";
	var obj = document.getElementById('admward');
	obj.value = "";
	//var DepLinkWardInfo = tkMakeServerCall("web.UDHCJFIPReg", "GetDepLinkWard", DepID);
	//+2018-07-16 ZhYW 
	var IPBookId = DHCWebD_GetObjValue('IPBook');
	var DepLinkWardInfo = tkMakeServerCall("web.UDHCJFIPReg", "GetLinkedWard", DepID, IPBookId);
	DepLinkWardInfo = DepLinkWardInfo.split("^");
	var LinkNum = DepLinkWardInfo[0];
	var LinkWardDesc = DepLinkWardInfo[1];
	var LinkWardID = DepLinkWardInfo[2];
	if (LinkNum == 1) {
		var obj = document.getElementById('admwardid');
		obj.value = LinkWardID;
		var obj = document.getElementById('admward');
		obj.value = LinkWardDesc;
	} else {
		var obj = document.getElementById('admwardid');
		obj.value = "";
		var obj = document.getElementById('admward');
		obj.value = "";
	}
	//切换不同科室，入院医生自动变空   add zhli  17.8.25
	DHCWebD_SetObjValueB('admdoc', "");
	DHCWebD_SetObjValueB('admdocid', "");
}

function LookUpadmbed(str) {
	var obj = document.getElementById('bedrowid');
	var obj1 = document.getElementById('roomrowid');
	var tem = str.split("^");
	obj.value = tem[8];
	obj1.value = tem[7];
	roomobj.value = tem[5];
}

function LookUpadmward(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB('admwardid', myAry[1]);
}

function gettypeid(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB('admreasonid', myAry[1]);
}

function getepisid(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB('admepisid', myAry[1]);
}

function ryqklookup(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB('admqkid', myAry[1]);
}

function LookUpType(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB('deptype', myAry[1]);
}

function LookUpPayMode(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB('moderowid', myAry[1]);
	if (pyobj.value == t['02']) {
		websys_setfocus('BtnPrint');
	} else {
		elementformat()
		websys_setfocus('bank');
	}
}

function LookUpBank(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB('bankrowid', myAry[1]);
}

function mardesclookup(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB('mardescid', myAry[1]);
}

function rlgdesclookup(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB('rlgdescid', myAry[1]);
}

function admdoclookup(value) {
	var myAry = value.split("^");
	DHCWebD_SetObjValueB('admdocid', myAry[1]);
}

function admrealookup(str) {
	var obj = document.getElementById('admreasonid');
	var tem = str.split("^");
	obj.value = tem[1];
	var p1 = obj.value;
	var encmeth = DHCWebD_GetObjValue('getSocSatid');
	var socsatstr = cspRunServerMethod(encmeth, p1);
	var socsatstr1 = socsatstr.split("^");
	if (opcardnoobj.value != "") {
		if (SocSatidobj.value == "") {
			SocSatidobj.value = socsatstr1[0];
			SocSatdescobj.value = socsatstr1[1];
		}
	}
}

function gettoday() {
	var encmeth = DHCWebD_GetObjValue('getdatetime');
	var stdatetime = cspRunServerMethod(encmeth);
	if (stdatetime != "") {
		var str1 = stdatetime.split("^");
		admdateobj.value = str1[0];
		admtimeobj.value = str1[1];
		if (PatinFlag == "Y") {
			admdateobj.readOnly = false;
			admtimeobj.readOnly = false;
		} else {
			admdateobj.readOnly = true;
		}
	}
}

function getcurdate() {
	var d = new Date();
	curday = d.getDate();
	curmon = d.getMonth() + 1;
	curyear = d.getYear();
}

function ZipLookupSelect(str) {
	var lu = str.split("^");
	var obj = document.getElementById("zipcode");
	if (obj) {
		obj.value = lu[1];
	}
	var obj = document.getElementById("cityarea");
	if (obj) {
		obj.value = lu[2];
	}
	var obj = document.getElementById("CTCITDesc");
	if (obj) {
		obj.value = lu[3];
	}
	var obj = document.getElementById("PROVDesc");
	if (obj) {
		obj.value = lu[4];
	}
	if (lu[5] == "0") {
		lu[5] = "";
	}
	var obj = document.getElementById("zipid");
	if (obj) {
		obj.value = lu[5];
	}
	var obj = document.getElementById("cityareaid");
	if (obj) {
		obj.value = lu[6];
	}
	var obj = document.getElementById("cityid");
	if (obj) {
		obj.value = lu[7];
	}
	var obj = document.getElementById("provid");
	if (obj) {
		obj.value = lu[8];
	}
}

function CityLookupSelect(str) {
	var lu = str.split("^");
	var obj = document.getElementById("CTCITDesc");
	if (obj) {
		obj.value = lu[0];
	}
	var obj = document.getElementById("PROVDesc");
	if (obj) {
		obj.value = lu[1];
	}
	if (lu[2] == "0") {
		lu[2] = "";
	}
	var obj = document.getElementById("cityid");
	if (obj) {
		obj.value = lu[2];
	}
	var obj = document.getElementById("provid");
	if (obj) {
		obj.value = lu[3];
	}
	var obj = document.getElementById("zipcode");
	if (obj) {
		obj.value = "";
	}
	var obj = document.getElementById("zipid");
	if (obj) {
		obj.value = "";
	}
	//+2018-06-04 ZhYW 
	var myCityDR = lu[2];
	GetZipInfo("", myCityDR, "", "Hpostalcode");    //住址邮编
}

function ProvinceLookupSelect(str) {
	var lu = str.split("^");
	var obj = document.getElementById("PROVDesc");
	if (obj) {
		obj.value = lu[0];
	}
	if (lu[1] == "0") {
		lu[1] = "";
	}
	var obj = document.getElementById("provid");
	if (obj) {
		obj.value = lu[1];
	}
	var obj = document.getElementById("zipcode");
	if (obj) {
		obj.value = "";
	}
	var obj = document.getElementById("zipid");
	if (obj) {
		obj.value = "";
	}
	var obj = document.getElementById("CTCITDesc");
	if (obj) {
		obj.value = "";
	}
	var obj = document.getElementById("cityid");
	if (obj) {
		obj.value = "";
	}
}

function LookUpadmsearch(str) {
	var tmp1 = str.split("^");
	admsearchobj.value = tmp1[0];
	admidobj.value = tmp1[9];
	admvisitobj.value = tmp1[8];
	admdateobj.value = tmp1[3];
	admtimeobj.value = tmp1[4];
	var p2 = tmp1[9];
	var encmeth = DHCWebD_GetObjValue('getadminfo');
	var adminfo = cspRunServerMethod(encmeth, p2);
	var adminfo1 = adminfo.split("^");
	if (adminfo1[0] == "-1") {
		alert(t['42']);
		return;
	} else if (adminfo1[0] == "-2") {
		alert(t['43']);
		return;
	} else {
		var depstr = adminfo1[1].split("@");
		admdepobj.value = depstr[1];
		admdepidobj.value = depstr[0];
		var wardstr = adminfo1[2].split("@");
		admwardobj.value = wardstr[1];
		admwardidobj.value = wardstr[0];
		var docstr = adminfo1[5].split("@");
		admdocobj.value = docstr[1];
		admdocidobj.value = docstr[0];
		var reastr = adminfo1[6].split("@");
		admreasonobj.value = reastr[1];
		admreaidobj.value = reastr[0];
		var episstr = adminfo1[7].split("@");
		admepisobj.value = episstr[1];
		admepisidobj.value = episstr[0];
		var bedstr = adminfo1[4].split("@");
		bedobj.value = bedstr[1];
		bedidobj.value = bedstr[0];
		var roomstr = adminfo1[3].split("@");
		roomobj.value = roomstr[1];
		roomidobj.value = roomstr[0];
		var ryqkstr = adminfo1[8].split("@");
		admqkobj.value = ryqkstr[1];
		admqkidobj.value = ryqkstr[0];
		usernameobj.value = adminfo1[9];
		AdmTimesobj.value = adminfo1[10];
		var admrefdocstr = adminfo1[11];
		if (adminfo1[11] != "") {
			var RefDocListdrobj = document.getElementById('RefDocListdr');
			var RefDocListobj = document.getElementById('RefDocList');
			var admrefdocstr = adminfo1[11].split("@");
			RefDocListdrobj.value = admrefdocstr[0];
			RefDocListobj.value = admrefdocstr[1];
		}
	}
	elementformat1();
}

function SocSatlookup(str) {
	var tmp1 = str.split("^");
	SocSatidobj.value = tmp1[1];
}

function getpatinfo() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		getpatinfo1();
		if (countryobj.value == "") {
			countryobj.value = t['65'];
			var encmeth = DHCWebD_GetObjValue('getcountryid');
			var getcountryid = cspRunServerMethod(encmeth, '', '', t['65']);
			countryidobj.value = getcountryid;
		}
		if (nationdescobj.value == "") {
			nationdescobj.value = t['66'];
			var encmeth = DHCWebD_GetObjValue('getnationid');
			var getnationid = cspRunServerMethod(encmeth, '', '', t['66']);
			nationidobj.value = getnationid;
		}
	}
	if ((digtypeobj.value == "") || (digtypeobj.value == " ") || (digtypeidobj.value == "") || (digtypeidobj.value == " ")) {
		digtypeobj.value = t['HXEY04'];
		var encmeth = DHCWebD_GetObjValue('getdigtypeid');
		var tmp3 = cspRunServerMethod(encmeth, '', '', t['HXEY04']);
		if (tmp3 != "") {
			var tmp3str = tmp3.split("^");
			digtypeobj.value = tmp3str[1];
			digtypeidobj.value = tmp3str[0];
		}
	}
	var IPBookObj = document.getElementById('IPBook');
	var BookID = IPBookObj.value;
	var Parobj = window.opener;
	//+2015-3-4 hujunbin 判断住院证状态
	if (BookID != "") {
		if (!Parobj) {
			SetDefAdmValue();
		}
		var IPBookStatus = tkMakeServerCall("web.DHCBillInterface", "IIsIPBook", BookID);
		if (IPBookStatus != "") {
			//这里赋空,住院证查询结束 保证在院后不再赋值默认就诊信息
			IPBookObj.value = "";
		}
	}
}

function getpatinfo1() {
	//+2015-3-4 hujunbin 检查住院证
	CheckBookMesage();
	/*
	if (papnoobj.value == ""){
		alert(t['07']);
		return;
	}
	*/
	SetDefAdmValue();
	babydob1 = "";
	babydob2 = "";
	var p1 = papnoobj.value;
	var p2 = medicareobj.value;
	var IPBook = "";
	var obj = document.getElementById("IPBook");
	if (obj) {
		IPBook = obj.value;
	}
	var UserDepID = document.getElementById("UserDepID").value;
	var encmeth = DHCWebD_GetObjValue('getpatinfo');
	var str = cspRunServerMethod(encmeth, p1, p2, IPBook, UserDepID);
	if (str != "") {
		var str1 = str.split("^");
		if (str1[0] == "IPBookErr") {
			alert("住院证不在有效日期范围内,不允许入院.");
			papnoobj.value = "";
			window.close();
			return;
		}
		if (str1[0] == "-1") {
			alert(t['07']);
			return;
		} else if (str1[0] == "-2") {
			alert(t['08']);
			papnoobj.value = "";
			return;
		} else if (str1[0] == "Admission") {
			alert("病人正在住院,不允许入院");
			papnoobj.value = "";
			window.close();
			return;
		} else if (str1[0] == "OnceAdmission") {
			alert("病人曾住院,不允许入院");
			papnoobj.value = "";
			window.close();
			return;
		} else if (str1[0] == "NotActive") {
			//+2015-3-4 hujunbin 添加是否有效判断
			alert("此住院证已为无效状态");
			papnoobj.value = "";
			window.close();
			return;
		} else {
			papmiidobj.value = str1[0];
			papnoobj.value = str1[2];
			papnameobj.value = str1[3];
			medicareobj.value = str1[4];
			var sexstr = str1[5].split("@");
			SexObj.value = sexstr[1];
			sexidobj.value = sexstr[0];
			paperidobj.value = str1[6];
			birthdateobj.value = str1[7];
			ageobj.value = str1[8];
			var marstr = str1[9].split("@");
			mardescobj.value = marstr[1];
			mardescidobj.value = marstr[0];
			var rlgstr = str1[10].split("@");
			rlgdescobj.value = rlgstr[1];
			rlgdescidobj.value = rlgstr[0];
			addressobj.value = str1[11];
			companyobj.value = str1[14];
			hometelobj.value = str1[12];
			worktelobj.value = str1[15];
			var zipstr = str1[13].split("@");
			zipcodeobj.value = zipstr[1];
			zipidobj.value = zipstr[0];
			var provstr = str1[16].split("@");
			provdescobj.value = provstr[1];
			providobj.value = provstr[0];
			emailobj.value = str1[17];
			mobtelobj.value = str1[18];
			var citystr = str1[19].split("@");
			cityobj.value = citystr[1];
			cityidobj.value = citystr[0];
			admidobj.value = str1[20];
			admsearchobj.value = str1[21];
			admvisitobj.value = str1[22];
			var deptstr = str1[23].split("@");
			admdepobj.value = deptstr[1];
			admdepidobj.value = deptstr[0];
			var wardstr = str1[24].split("@");
			admwardobj.value = wardstr[1];
			admwardidobj.value = wardstr[0];
			var bedstr = str1[25].split("@");
			bedobj.value = bedstr[1];
			bedidobj.value = bedstr[0];
			var roomstr = str1[32].split("@");
			roomobj.value = roomstr[1];
			roomidobj.value = roomstr[0];
			var docstr = str1[26].split("@");
			admdocobj.value = docstr[1];
			admdocidobj.value = docstr[0];
			var admreastr = str1[27].split("@");
			admreasonobj.value = admreastr[1];
			admreaidobj.value = admreastr[0];
			var admepisstr = str1[28].split("@");
			admepisobj.value = admepisstr[1];
			admepisidobj.value = admepisstr[0];
			admdateobj.value = str1[29];
			admtimeobj.value = str1[30];
			usernameobj.value = str1[31];
			var socsatstr = str1[33].split("@");
			SocSatdescobj.value = socsatstr[1];
			SocSatidobj.value = socsatstr[0];
			var admryqkstr = str1[34].split("@");
			admqkobj.value = admryqkstr[1];
			admqkidobj.value = admryqkstr[0];
			var nationstr = str1[35].split("@");
			nationdescobj.value = nationstr[1];
			nationidobj.value = nationstr[0];
			var cardtypestr = str1[36].split("@");
			cardtypeobj.value = cardtypestr[1];
			cardtypeidobj.value = cardtypestr[0];
			govcardnoobj.value = str1[37];
			var countrystr = str1[38].split("@");
			countryobj.value = countrystr[1];
			countryidobj.value = countrystr[0];
			var occustr = str1[39].split("@");
			occuobj.value = occustr[1];
			occuidobj.value = occustr[0];
			var edustr = str1[40].split("@");
			eduobj.value = edustr[1];
			eduidobj.value = edustr[0];
			var langustr = str1[41].split("@");
			languobj.value = langustr[1];
			languidobj.value = langustr[0];
			var emptypestr = str1[42].split("@");
			emptypeobj.value = emptypestr[1];
			emptypeidobj.value = emptypestr[0];
			var hplacestr = str1[43].split("@");
			homeplaceobj.value = hplacestr[0];
			bircityobj.value = hplacestr[1];
			birprovobj.value = hplacestr[2];
			var ctrltstr = str1[45].split("@");
			ctrltdescobj.value = ctrltstr[1];
			ctrltidobj.value = ctrltstr[0];
			ForeignIdobj.value = str1[44];
			FPhoneobj.value = str1[46];
			FAddressobj.value = str1[47];
			FNotesobj.value = str1[48];
			AdmTimesobj.value = str1[49];
			var cityareastr = str1[50].split("@");
			cityareaobj.value = cityareastr[1];
			cityareaidobj.value = cityareastr[0];
			var pycodeobj = document.getElementById('pycode');
			pycodeobj.value = str1[51];
			var dig1str = str1[52].split("@");
			diagnosobj.value = dig1str[1];
			diagnosidobj.value = dig1str[0];
			var dig2str = str1[53].split("@");
			if (dig2str[1] != "") {
				digtypeobj.value = dig2str[1];
				digtypeidobj.value = dig2str[0];
			}
			diagnosdescobj.value = str1[54];
			var agehourobj = document.getElementById('agehour');
			var ageMinutesobj = document.getElementById('ageMinutes');
			if (str1[55] != "") {
				babybirobj.value = str1[56];
				agehourobj.value = str1[57];
				ageMinutesobj.value = str1[58];
			} else {
				babybirobj.value = "";
				agehourobj.value = "";
				ageMinutesobj.value = "";
			}
			if (str1[59] != "") {
				var refdocstr = str1[59].split("@");
				var RefDocListdrobj = document.getElementById('RefDocListdr');
				var RefDocListobj = document.getElementById('RefDocList');
				RefDocListdrobj.value = refdocstr[0];
				RefDocListobj.value = refdocstr[1];
			}
			var hzipcodeobj = document.getElementById('Hpostalcode');    //住址邮编
			var czipcodeobj = document.getElementById('Cpostalcode');    //出生邮编
			hzipcodeobj.value = str1[60];
			czipcodeobj.value = str1[61];
			InsuNoObj.value = str1[62];
			if (str1[64] != "") {
				var HCPstr = str1[64].split("@");
				var HCPdrobj = document.getElementById('HCPID');
				var HCPDescobj = document.getElementById('HCPDesc');
				HCPdrobj.value = HCPstr[0];
				HCPDescobj.value = HCPstr[1];
			}
			if (str1[66] != "") {
				var BirthProvince = str1[66].split("@");
				var BirthProvinceDrobj = document.getElementById('BirthProvinceDr');
				var PAPERBirthProvinceobj = document.getElementById('PAPERBirthProvince');
				BirthProvinceDrobj.value = BirthProvince[0];
				PAPERBirthProvinceobj.value = BirthProvince[1];
			}
			if (str1[67] != "") {
				var BirthCity = str1[67].split("@");
				var BirthCityDrobj = document.getElementById('BirthCityDr');
				var BirthCityobj = document.getElementById('BirthCity');
				BirthCityDrobj.value = BirthCity[0];
				BirthCityobj.value = BirthCity[1];
			}
			if (str1[68] != "") {
				var BirthArea = str1[68].split("@");
				var BirthAreaDrobj = document.getElementById('BirthAreaDr');
				var BirthAreaobj = document.getElementById('BirthArea');
				BirthAreaDrobj.value = BirthArea[0];
				BirthAreaobj.value = BirthArea[1];
			}
			if (str1[69] != "") {
				var BirthAddressobj = document.getElementById('BirthAddress');
				BirthAddressobj.value = str1[69];
			}
			if (str1[70] != "") {
				var HouseProvince = str1[70].split("@");
				var HouseProvinceDrobj = document.getElementById('HouseProvinceDr');
				var HouseProvinceobj = document.getElementById('HouseProvince');
				HouseProvinceDrobj.value = HouseProvince[0];
				HouseProvinceobj.value = HouseProvince[1];
			}
			if (str1[71] != "") {
				var HouseCity = str1[71].split("@");
				var HouseCityDrobj = document.getElementById('HouseCityDr');
				var HouseCityobj = document.getElementById('HouseCity');
				HouseCityDrobj.value = HouseCity[0];
				HouseCityobj.value = HouseCity[1];
			}
			if (str1[72] != "") {
				var HouseArea = str1[72].split("@");
				var HouseAreaDRobj = document.getElementById('HouseAreaDR');
				var HouseAreaobj = document.getElementById('HouseArea');
				HouseAreaDRobj.value = HouseArea[0];
				HouseAreaobj.value = HouseArea[1];
			}
			if (str1[75] != "") {
				var AdmSourceInfo = str1[75].split("@");
				AdmSourceIDObj.value = AdmSourceInfo[0];
				AdmSourceObj.value = AdmSourceInfo[1];
			}
			DHCWebD_SetObjValueB("HouseAddress", str1[73]);
			DHCWebD_SetObjValueB("HouseZipCode", str1[74]);
			DHCWebD_SetObjValueB("EncryptLevel", str1[76]);
			DHCWebD_SetObjValueB("PatLevel", str1[77]);
			//入院病情(病危、危重、危急)
			if (str1[78] != "") {
				var AdmRefPriorityInfo = str1[78].split("@");
				AdmRefPriorityIDObj.value = AdmRefPriorityInfo[0];
				AdmRefPriorityObj.value = AdmRefPriorityInfo[1];
			}
			if ((str1[20] == "") && (str1[63] == "")) {
				clearadm_click();
			}
			if ((str1[22] != t['16']) && (str1[63] == "")) {
				clearadm_click();
			}
			if (admidobj.value == "") {
				SetDefAdmValue();                //如果是住院证调取, 则病人费别和入院情况都为空了
			}
			if ((str1[79] != "") && (admidobj.value == "") && (str1[20] == "")) {
				var FormerAdmRea = str1[79].split('@');
				if (FormerAdmRea[0] != "") {
					admreaidobj.value = FormerAdmRea[0];
					admreasonobj.value = FormerAdmRea[1];
				}
			}
			DHCWebD_SetObjValueB("payamt", str1[80]);        //住院证建议押金金额
			//+2017-08-17 ZhYW
			DHCWebD_SetObjValueB('PhotoInfo', str1[81]);
			ShowPicByPatInfo(str1[81], "");
			//+2018-11-21 ZhYW 新生儿出生日期
			babydob1 = str1[82];   //日期
			babydob2 = str1[83];   //时间
			/*
			//ZhYW 2018-11-22 不知为何在这里要计算新生儿年龄，先注释
			var e = event ? event : (window.event ? window.event : null);
			var key = websys_getKey(e);
			key = 13;
			enterbaby();
			*/
		}
	}
	elementformat1();
	websys_setfocus('name');
	//DHCWeb_Nextfocus();
}

function regsave_click() {
	clear_lookup();
	var paperidlen = (paperidobj.value).length;
	if ((paperidlen != 15) & (paperidlen != 18) & (paperidobj.value != "")) {
		alert(t['62'])
		websys_setfocus("paperid");
		return;
	}
	if (paperidobj.value != "") {
		var rtn = PaperIDSexErr();
		if (rtn == "SexNotSame") {
			var rtn = window.confirm("性别与身份证上的性别不一致,是否办理住院?");
			if (!rtn) {
				return;
			}
		}
		var rtn = PaperIDBirthErr();
		if (rtn == "BirthDateNotSame") {
			var rtn = window.confirm("出生日期与身份证上的出生日期不一致,是否办理住院?");
			if (!rtn) {
				return;
			}
		}
	}
	if (countryobj.value == "") {
		countryobj.value = t['65'];
		var encmeth = DHCWebD_GetObjValue('getcountryid');
		var getcountryid = cspRunServerMethod(encmeth, '', '', t['65']);
		countryidobj.value = getcountryid;
	}
	if (nationdescobj.value == "汉族") {
		nationidobj.value = 1;
	}
	if (nationdescobj.value == "") {
		nationdescobj.value = t['66'];
		var encmeth = DHCWebD_GetObjValue('getnationid');
		var getnationid = cspRunServerMethod(encmeth, '', '', t['66']);
		nationidobj.value = getnationid;
	}
	if (papnameobj.value == "") {
		alert(t['12']);
		websys_setfocus('name');
		return;
	}
	if ((SexObj.value == "") || (sexidobj.value == "")) {
		alert(t['13']);
		websys_setfocus('sex');
		return;
	}
	if ((admdepobj.value == "") || (admdepidobj.value == "")) {
		alert(t['55']);
		websys_setfocus('admdep');
		return;
	}
	if ((admwardobj.value == "") || (admwardidobj.value == "")) {
		alert(t['10']);
		websys_setfocus('admward');
		return;
	}
	if ((admreasonobj.value == "") || (admreaidobj.value == "")) {
		alert(t['11']);
		websys_setfocus('admreason');
		return;
	}
	if (admvisitobj.value == t['16']) {
		alert(t['14']);
		return;
	}
	if (PapnoFlag == "Y") {
		if ((papmiidobj.value == "") && (papnoobj.value == "")) {
			alert(t['64'])
			websys_setfocus('Regno');
			return;
		}
	}

	var cardtypedesc = cardtypeobj.value;
	if (govcardnoobj.value != "") {
		if ((cardtypeobj.value != "") && (cardtypeidobj.value != "")) {
			var cardtypedesc = cardtypeobj.value;
			if (cardtypedesc.indexOf(t['60']) != "-1") {
				paperidobj.value = govcardnoobj.value;
			}
		}
	}
	if (birthdateobj.value == "") {
		alert("出生日期不能为空.");
		return;
	}
	//tangtao for 不知道是否建卡的病人手输信息查重
	var judgeflag = tkMakeServerCall("web.UDHCJFIPReg", "JudgePatInfo", papnoobj.value);
	if (judgeflag == "") {
		var rtn = CheckAlreadyPAPER();
		if (rtn == true) {
			return;
		}
	}
	var JudgeAdmStatus = tkMakeServerCall("web.UDHCJFIPReg", "JudgeAdmStatus", papnoobj.value);
	if (JudgeAdmStatus != "") {
		var trueorfalse = window.confirm("患者有" + JudgeAdmStatus + "状态就诊,是否办理入院登记!");
		if (!trueorfalse) {
			return;
		}
	}
	//yyx
	var encmeth = DHCWebD_GetObjValue('getpatstatus');
	var qfstatus = cspRunServerMethod(encmeth, papnoobj.value);
	if (qfstatus == "-1") {
		var trueorfalse = window.confirm(t['67']);
		if (!trueorfalse) {
			return;
		}
	}
	if (qfstatus == "-2") {
		var trueorfalse = window.confirm(t['68']);
		if (!trueorfalse) {
			return;
		}
	}
	var AdmStatus = tkMakeServerCall("web.UDHCJFIPReg", "GetAdmStatusInfo", admidobj.value);
	if ((admidobj.value != "") && (AdmStatus == "P")) {
		alert("此病人为预住院状态,不能在此办理住院.");
		return;
	}
	//end
	//insert by cx 2007.05.21 insert pycode
	var pycode = document.getElementById("pycode").value;
	var RefDocListdrobj = document.getElementById('RefDocListdr');
	var hzipcodeobj = document.getElementById('Hpostalcode');
	var czipcodeobj = document.getElementById('Cpostalcode');
	var IPBookobj = document.getElementById('IPBook');
	var HCPobj = document.getElementById('HCPID');
	var AdmStatus = tkMakeServerCall("web.UDHCJFIPReg", "GetAdmStatusInfo", admidobj.value);
	if ((admidobj.value != "") && (AdmStatus != "P")) {
		alert("不能选择以前的就诊办理住院登记");
		return;
	}
	//+2017-07-25 ZhYW 社会地位为空时,通过费别取社会地位
	if (SocSatidobj.value == ""){
		var admReason = admreaidobj.value;
		var encmeth = DHCWebD_GetObjValue('getSocSatid');
		var socsatstr = cspRunServerMethod(encmeth, admReason);
		var socsatstr1 = socsatstr.split("^");
		SocSatidobj.value = socsatstr1[0];
	}
	
	//+2019-01-16 ZhYW 必填信息校验
	if (!checkRequiredElements()) {
		return;
	}
	//
	//modify 2012-01-12 增加出生地省、市、区、户口所在省、市、区等功能
	var BirthProvinceDrobj = document.getElementById('BirthProvinceDr');
	var BirthCityDrobj = document.getElementById('BirthCityDr');
	var BirthAreaDrobj = document.getElementById('BirthAreaDr');
	var BirthAddressobj = document.getElementById('BirthAddress');
	var HouseProvinceDrobj = document.getElementById('HouseProvinceDr');
	var HouseCityDrobj = document.getElementById('HouseCityDr');
	var HouseAreaDRobj = document.getElementById('HouseAreaDR');
	var HouseZipCodeobj = document.getElementById('HouseZipCode');
	var HouseAddressobj = document.getElementById('HouseAddress');
	var AdmPriorityID = document.getElementById('AdmPriorityID').value;
	var p1 = papmiidobj.value + "^" + papnameobj.value + "^" + medicareobj.value + "^" + sexidobj.value;
	p1 = p1 + "^" + paperidobj.value + "^" + birthdateobj.value + "^" + ageobj.value + "^" + ageyrobj.value;
	p1 = p1 + "^" + agemthobj.value + "^" + agedayobj.value + "^" + mardescidobj.value + "^" + rlgdescidobj.value;
	p1 = p1 + "^" + addressobj.value + "^" + hometelobj.value + "^" + zipidobj.value + "^" + companyobj.value;
	p1 = p1 + "^" + worktelobj.value + "^" + providobj.value + "^" + emailobj.value + "^" + mobtelobj.value;
	p1 = p1 + "^" + cityidobj.value + "^" + SocSatidobj.value + "^" + nationidobj.value;
	p1 = p1 + "^" + cardtypeidobj.value + "^" + govcardnoobj.value + "^" + countryidobj.value + "^" + occuidobj.value;
	p1 = p1 + "^" + eduidobj.value + "^" + languidobj.value + "^" + emptypeidobj.value + "^" + birprovobj.value;
	p1 = p1 + "^" + bircityobj.value + "^" + ctrltidobj.value + "^" + ForeignIdobj.value + "^" + FPhoneobj.value;
	p1 = p1 + "^" + FAddressobj.value + "^" + FNotesobj.value + "^" + cityareaidobj.value + "^" + pycode + "^" + babydob1 + "^" + babydob2;
	p1 = p1 + "^" + Medicareflag + "^" + newcardnoobj.value + "^" + hzipcodeobj.value + "^" + czipcodeobj.value + "^" + InsuNoObj.value;
	p1 = p1 + "^" + IPBookobj.value + "^" + HCPobj.value;
	p1 = p1 + "^" + BirthProvinceDrobj.value + "^" + BirthCityDrobj.value + "^" + BirthAreaDrobj.value + "^" + BirthAddressobj.value;
	p1 = p1 + "^" + HouseProvinceDrobj.value + "^" + HouseCityDrobj.value + "^" + HouseAreaDRobj.value + "^" + HouseAddressobj.value + "^" + HouseZipCodeobj.value;
	//+2017-08-17 ZhYW
	p1 += '^' + m_PhotoObj.value;
	
	var p2 = admdepidobj.value + "^" + admwardidobj.value + "^" + roomidobj.value + "^" + bedidobj.value + "^" + admdocidobj.value;
	p2 = p2 + "^" + admreaidobj.value + "^" + admepisidobj.value;
	p2 = p2 + "^" + admdateobj.value + "^" + admtimeobj.value + "^" + Guser + "^" + admqkidobj.value + "^" + "" + "^" + diagnosidobj.value + "^" + diagnosdescobj.value + "^" + digtypeidobj.value + "^" + digtypeobj.value + "^" + RefDocListdrobj.value + "^" + AdmSourceIDObj.value + "^" + AdmPriorityID; //入院途径\入院病情（危重、急、一般);
	if (opcardid != "") {
		var p3 = papnoobj.value + "^" + papmiidobj.value + "^" + paperidobj.value + "^" + opcardnoobj.value + "^" + cardCheckNo + "^" + "" + "^" + "" + "^" + Guser + "^" + computername + "^" + opcardid + "^" + cardCheckNo;
	} else {
		p3 = "";
	}
	var encmeth = DHCWebD_GetObjValue('addpatinfo');
	var tmp = cspRunServerMethod(encmeth, '', '', p1, p2, p3);
	var tmp1 = tmp.split("^");
	if (tmp1[0] == "paterror") {
		alert(t['38']);
		return;
	} else if (tmp1[0] == "admerr") {
		alert(t['14']);
		return;
	} else if (tmp1[0] == "admdep") {
		alert(t['35']);
		return;
	} else if (tmp1[0] == "admward") {
		alert(t['36']);
		return;
	} else if (tmp1[0] == "admreadr") {
		alert(t['37']);
		return;
	} else if (tmp1[0] == "beddiff") {
		alert(t['39']);
		return;
	} else if (tmp1[0] == "opcarderror") {
		alert(t['46']);
		return;
	} else if (tmp1[0] == "MRNError") {
		alert(t['InPatInfo05']);
		return;
	} else if (tmp1[0] == "MRNError1") {
		alert(t['InPatInfo06']);
		return;
	} else if (tmp1[0] == "bederr") {
		alert("此病区没有可用床位,请选择其它病区");
		return;
	} else if (tmp1[0] == "StayStat") {
		alert("此病人正在留观,不允许办理住院登记.");
		return;
	} else if (tmp1[0] == "SexErr") {
		alert("此病人的性别非本科室允许入院登记的性别,不允许办理住院登记.");
		return;
	} else if (tmp1[0] == "AgeErr") {
		alert("此病人的年龄非本科室允许的年龄范围,不允许办理住院登记.");
		return;
	} else if (tmp1[0] == "PatNameErr") {
		alert("入院登记病人姓名发生变化,请先修改病人基本信息姓名再办理入院");
		return;
	} else if (tmp1[0] == "BirthGreatthan") {
		alert("出生日期大于当前日期,不能办理入院!!");
		return;
	} else if (tmp1[0] == "AdmDateError") {
		alert("出生日期大于住院日期,不能办理入院!!");
		return;
	} else if (tmp1[0] == "APPBedErr") {
		alert("该患者未预约到床位,不能办理入院!!");
		return;
	} else if (tmp1[0] == "SignBedErr") {
		alert("科室开启了住院总签床,但住院证状态不是签床,不能办理入院!!");
		return;
	}else if (tmp1[0] == "0") {
		if (papmiidobj.value != "") {
			admidobj.value = tmp1[3];
			admvisitobj.value = tmp1[5];
			admsearchobj.value = tmp1[4];
			medicareobj.value = tmp1[6];
			elementformat1()
			alert(t['27']);
		} else {
			papnoobj.value = tmp1[1];
			papmiidobj.value = tmp1[2];
			admidobj.value = tmp1[3];
			admvisitobj.value = tmp1[5];
			admsearchobj.value = tmp1[4];
			medicareobj.value = tmp1[6];
			elementformat1()
			alert(t['27']);
		}
		//update by zf 20150317 接诊接口
		if (typeof btnReceipt_onclick != 'undefined') {
			btnReceipt_onclick();
		}
		//
		document.getElementById("IPBook").value = "";
		getpatinfo1();
		//转到交押金界面(允许调用交押金程序)   add zhangli  17.3.14
		if (LinkDepositFlag == "Y") {
			if(m_Adddeposit == "") {
				LinkaddDeposit_click();
			}
			
		}
	}

	/*
	var adminfo = papnoobj.value + "^" + papnameobj.value + "^" + admdateobj.value + "^" + SexObj.value;
	adminfo = adminfo + "^" + hometelobj.value + "^" + mardescobj.value + "^" + ageobj.value + "^" + addressobj.value;
	adminfo = adminfo + "^" + medicareobj.value + "^" + companyobj.value;
	Printadminfo(adminfo);
	websys_setfocus('payamt');
	*/
}

///清屏
function clear_click() {
	/*
	clearpat_click();
	clearadm_click();
	if (DepositFlag == "Y") {
		getyjinfo();
	}
	if (PapnoFlag == "N") {
		websys_setfocus('name');
		//websys_setfocus('newcardno');
	}
	if (PapnoFlag == "Y") {
		websys_setfocus('Regno');
	}
	*/
	window.location.reload();
}

function Add_click() {
	Adm = admidobj.value;
	if (deposittypeobj.value == "") {
		deptypeobj.value = "";
	}
	if (pyobj.value == "") {
		moderowidobj.value = "";
	}
	if (bankobj.value == "") {
		bankrowidobj.value = "";
	}
	if (Adm == "") {
		alert(t['25']);
		return;
	}
	//modify 2014-11-18 增加控制退院的病人不能交押金
	var ReturnVal = tkMakeServerCall("web.UDHCJFIPReg", "GetAdmVisitStatus", admidobj.value);
	if ((ReturnVal == "") || (ReturnVal == " ")) {
		alert("获取就诊信息失败!!");
		return;
	} else if (ReturnVal == "AdmNull") {
		alert("获取就诊信息失败!!");
		return;
	} else {
		var ReturnVal1 = ReturnVal.split("^");
		if (ReturnVal1 == "C") {
			alert("病人已退院不能交押金");
			return;
		}
	}
	if (PrtFlag == "Y") {
		alert(t['20']);
		return;
	}
	var deptype = document.getElementById('deptype').value;
	if (deptype == "") {
		alert(t['21']);
		return;
	}
	var payamt = document.getElementById('payamt').value;
	if ((payamt == "") || (!payamt)) {
		alert(t['22']);
		return;
	}
	var moderowid = document.getElementById('moderowid').value;
	if (moderowid == "") {
		alert(t['23']);
		return;
	}
	if (CurNo == "") {
		alert(t['24']);
		return;
	}
	var deptcomp = document.getElementById('deptcomp').value;
	var bankrowid = document.getElementById('bankrowid').value;
	var cardno = document.getElementById('cardno').value;
	//var authno=document.getElementById('authno').value;
	var authno = "";
	var banksub = document.getElementById('banksub').value;
	var encmeth = DHCWebD_GetObjValue('Add');
	var dep = deptype + "^" + payamt + "^" + moderowid + "^" + deptcomp + "^" + bankrowid + "^" + cardno + "^" + authno + "^" + Adm + "^" + CurNo + "^" + UserLoc + "^" + Guser + "^" + EndNo + "^" + Title + "^" + banksub;
	if (cspRunServerMethod(encmeth, 'SetPid', '', dep) == '0') {}
}

function SetPid(value) {
	var sub;
	var str = value.split("^");
	var retcode = str[0];
	var yjrowid = str[1];
	var rcptrowid = str[2];
	if ((retcode != "0") & (retcode != "100")) {
		alert(t['26']);
		return;
	}
	if (retcode == "100") {
		alert(t['30']);
	}
	if (retcode == "0") {   //alert(t['30']);
		PrtFlag = "Y";
		var encmeth = DHCWebD_GetObjValue('getyjdetail');
		returnval = cspRunServerMethod(encmeth, '', '', yjrowid);
		printYJ();
		if (AbortYJprtFlag == "Y") {
			var truthBeTold = window.confirm(t['59']);
			if (!truthBeTold) {
				if (RcptFlag == "Y") {
					var encmeth = DHCWebD_GetObjValue('getrcptno');
					if (cspRunServerMethod(encmeth, 'GetRcptNo', '', Guser) == '0') {}
				}
				PrtFlag = "N";
				abort(yjrowid, rcptrowid);
			}
			if (truthBeTold) {
				clear_click();
			}
		}
		if (AbortYJprtFlag == "N") {
			clear_click();
		}
		if (PapnoFlag == "N") {
			websys_setfocus('name');
		}
		if (PapnoFlag == "Y") {
			websys_setfocus('Regno');
		}
	}
}

function getyjinfo() {
	PrtFlag = "N";
	deposittypeobj.value = "";
	deptypeobj.value = "";
	pyobj.value = "";
	moderowidobj.value = "";
	bankobj.value = "";
	bankrowidobj.value = "";
	banksubobj.value = "";
	cardnoobj.value = "";
	deptcompobj.value = "";
	document.getElementById('deposittype').value = t['01'];
	var encmeth = DHCWebD_GetObjValue('gettyperowid');
	var tmp = cspRunServerMethod(encmeth, '', '', t['01']);
	document.getElementById('deptype').value = tmp;
	document.getElementById('paymode').value = t['02'];
	var encmeth = DHCWebD_GetObjValue('getpaymodeid');
	var tmp1 = cspRunServerMethod(encmeth, '', '');
	document.getElementById('moderowid').value = tmp1;
	document.getElementById('currentno').readOnly = true;
	var payamtobj = document.getElementById('payamt');
	payamtobj.value = "";
	elementformat();
	if (RcptFlag == "Y") {
		var encmeth = DHCWebD_GetObjValue('getrcptno');
		if (cspRunServerMethod(encmeth, 'GetRcptNo', '', Guser) == '0') {}
	}
}

function yjsearch_click() {
	Adm = admidobj.value;
	if (Adm == "") {
		alert(t['25']);
		return;
	}
	var str = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFFindDeposit&Adm=' + Adm;
	window.open(str, '_blank', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width=700,height=520,left=0,top=0');
}

function elementformat1() {
	var imgname;
	var Myobj = document.getElementById('Myid');
	if (Myobj) {
		imgname = "ld" + Myobj.value + "i" + "admdep";
		var admdep1obj = document.getElementById(imgname);
		imgname = "ld" + Myobj.value + "i" + "admward";
		var admward1obj = document.getElementById(imgname);
		var OrdNum = tkMakeServerCall("web.UDHCJFIPReg", "GetAdmOrder", admidobj.value);
		if (OrdNum == " ") {
			OrdNum = "0";
		}
		if (OrdNum == "") {
			OrdNum = "0";
		}
		if (isNaN(OrdNum)) {
			OrdNum = "0";
		}
		imgname = "ld" + Myobj.value + "i" + "admdoc";
		var admdoc1obj = document.getElementById(imgname);
		if (OrdNum != "0") {
			admdep1obj.style.display = "none";
			admdepobj.readOnly = true;
			admward1obj.style.display = "none";
			admwardobj.readOnly = true;
			admdoc1obj.style.display = "none";
			admdocobj.readOnly = true;
		} else {
			admdep1obj.style.display = "";
			admdepobj.readOnly = false;
			admward1obj.style.display = "";
			admwardobj.readOnly = false;
			admdoc1obj.style.display = "";
			admdocobj.readOnly = false;
		}
		//+2018-07-30 ZhYW
		var IPBook = DHCWebD_GetObjValue('IPBook');
		if (IPBook != "") {
			var admDeptDR = DHCWebD_GetObjValue('admdepid');
			var admWardDR = DHCWebD_GetObjValue('admwardid');
			if (admDeptDR != "") {
				admdep1obj.style.display = "none";
				admdepobj.readOnly = true;
			}
			if (admWardDR != "") {
				admward1obj.style.display = "none";
				admwardobj.readOnly = true;
			}
		}
		//
	}
}

function admfin_click() {
	var encmeth = DHCWebD_GetObjValue("getdatetime");
	var stdatetime = cspRunServerMethod(encmeth);
	var str1 = stdatetime.split("^");
	var stdate = str1[0];
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFinfro=&stdate=" + stdate + "&enddate=" + stdate + "&username=" + gusername + "&userid=" + Guser + "&linkFlag=" + "Y";
	websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

function readcard_click() {
	/*
	clear_click();
	websys_setfocus('opcardno');
	var obj = document.getElementById('readcard');
	if (obj) {
		obj.onclick = ReadCardClickHandler;
	}
	*/
	setTimeout("ReadCardClickHandler()", 500);
	//window.setTimeout('ReadCardClickHandler()', 5000);
}

function clearadm_click() {
	admsearchobj.value = "";
	admidobj.value = "";
	admvisitobj.value = "";
	admdepobj.value = "";
	admdepidobj.value = "";
	admwardobj.value = "";
	admwardidobj.value = "";
	admdocobj.value = "";
	admdocidobj.value = "";
	admreasonobj.value = "";
	admreaidobj.value = "";
	admepisobj.value = "";
	admepisidobj.value = "";
	bedobj.value = "";
	bedidobj.value = "";
	roomobj.value = "";
	roomidobj.value = "";
	admdateobj.value = "";
	admtimeobj.value = "";
	admqkobj.value = "";
	admqkidobj.value = "";
	AdmTimesobj.value = "";
	diagnosobj.value = "";
	diagnosidobj.value = "";
	diagnosdescobj.value = "";
	AdmSourceObj.value = "";
	AdmSourceIDObj.value = "";
	AdmRefPriorityIDObj.value = "";
	AdmRefPriorityObj.value = "";
	admqkobj.value = t['58'];
	yjamtobj.value = "";
	gettoday();
	var p1 = admqkobj.value;
	var encmeth = DHCWebD_GetObjValue('getryqk');
	var tmp2 = cspRunServerMethod(encmeth, p1);
	admqkidobj.value = tmp2;
	usernameobj.value = gusername;
	//AdmTimesobj.readOnly = true;
	digtypeobj.value = t['HXEY04'];
	var encmeth = DHCWebD_GetObjValue('getdigtypeid');
	var tmp3 = cspRunServerMethod(encmeth, '', '', t['HXEY04']);
	if (tmp3 != "") {
		var tmp3str = tmp3.split("^");
		digtypeobj.value = tmp3str[1];
		digtypeidobj.value = tmp3str[0];
	}
	var RefDocListdrobj = document.getElementById('RefDocListdr');
	var RefDocListobj = document.getElementById('RefDocList');
	RefDocListdrobj.value = "";
	RefDocListobj.value = "";
	elementformat1();
	//设置默认的费别
	GetDefAdmReason();
	//+2017-08-21 ZhYW 护士站办理入院登记时,默认科室跟病区. 此处先不考虑
	SetDefDeptAndWard();
}

function clearpat_click() {
	opcardid = "";
	opcardnoobj.value = "";
	papnoobj.value = "";
	papmiidobj.value = "";
	papnameobj.value = "";
	medicareobj.value = "";
	SexObj.value = "";
	sexidobj.value = "";
	paperidobj.value = "";
	birthdateobj.value = "";
	ageobj.value = "";
	mardescobj.value = "";
	mardescidobj.value = "";
	rlgdescobj.value = "";
	rlgdescidobj.value = "";
	addressobj.value = "";
	hometelobj.value = "";
	zipcodeobj.value = "";
	zipidobj.value = "";
	companyobj.value = "";
	worktelobj.value = "";
	cityobj.value = "";
	cityidobj.value = "";
	provdescobj.value = "";
	providobj.value = "";
	mobtelobj.value = "";
	emailobj.value = "";
	ageyrobj.value = "";
	agemthobj.value = "";
	agedayobj.value = "";
	SocSatdescobj.value = "";
	SocSatidobj.value = "";
	nationdescobj.value = "";
	nationidobj.value = "";
	cardtypeobj.value = "";
	cardtypeidobj.value = "";
	govcardnoobj.value = "";
	countryobj.value = "";
	countryidobj.value = "";
	occuobj.value = "";
	occuidobj.value = "";
	eduobj.value = "";
	eduidobj.value = "";
	languobj.value = "";
	languidobj.value = "";
	emptypeobj.value = "";
	emptypeidobj.value = "";
	homeplaceobj.value = "";
	birprovobj.value = "";
	bircityobj.value = "";
	ctrltdescobj.value = "";
	ctrltidobj.value = "";
	ForeignIdobj.value = "";
	FPhoneobj.value = "";
	FAddressobj.value = "";
	FNotesobj.value = "";
	cityareaobj.value = "";
	cityareaidobj.value = "";
	var pycodeobj = document.getElementById('pycode');
	pycodeobj.value = "";
	babybirobj.value = "";
	var agehourobj = document.getElementById('agehour');
	var ageMinutesobj = document.getElementById('ageMinutes');
	agehourobj.value = "";
	ageMinutesobj.value = "";
	newcardnoobj.value = "";
	getnationdesc();
	getcountrydesc();
	var hzipcodeobj = document.getElementById('Hpostalcode');
	hzipcodeobj.value = "";
	var czipcodeobj = document.getElementById('Cpostalcode');
	czipcodeobj.value = "";
	InsuNoObj.value = "";
	var HCPIDobj = document.getElementById('HCPID');
	var HCPdescobj = document.getElementById('HCPDesc');
	HCPIDobj.value = "";
	HCPdescobj.value = "";
	var PAPERBirthProvinceobj = document.getElementById('PAPERBirthProvince');
	PAPERBirthProvinceobj.value = "";
	var BirthProvinceDrobj = document.getElementById('BirthProvinceDr');
	BirthProvinceDrobj.value = "";
	var BirthCityobj = document.getElementById('BirthCity');
	BirthCityobj.value = "";
	var BirthCityDrobj = document.getElementById('BirthCityDr');
	BirthCityDrobj.value = "";
	var BirthAreaobj = document.getElementById('BirthArea');
	BirthAreaobj.value = "";
	var BirthAreaDrobj = document.getElementById('BirthAreaDr');
	BirthAreaDrobj.value = "";
	var BirthAddressobj = document.getElementById('BirthAddress');
	BirthAddressobj.value = "";
	var HouseProvinceobj = document.getElementById('HouseProvince');
	HouseProvinceobj.value = "";
	var HouseProvinceDrobj = document.getElementById('HouseProvinceDr');
	HouseProvinceDrobj.value = "";
	var HouseCityobj = document.getElementById('HouseCity');
	HouseCityobj.value = "";
	var HouseCityDrobj = document.getElementById('HouseCityDr');
	HouseCityDrobj.value = "";
	var HouseAreaobj = document.getElementById('HouseArea');
	HouseAreaobj.value = "";
	var HouseAreaDRobj = document.getElementById('HouseAreaDR');
	HouseAreaDRobj.value = "";
	var HouseAddressobj = document.getElementById('HouseAddress');
	HouseAddressobj.value = "";
	var HouseZipCodeobj = document.getElementById('HouseZipCode');
	HouseZipCodeobj.value = "";
	var IPBookObj = document.getElementById('IPBook');
	IPBookObj.value = "";
	var EncryptLevelObj = document.getElementById('EncryptLevel');
	if (EncryptLevelObj) {
		EncryptLevelObj.value = "";
	}
	var PatLevelObj = document.getElementById('PatLevel');
	if (PatLevelObj) {
		PatLevelObj.value = "";
	}
}

function regupdate_click() {
	clear_lookup();
	var paperidlen = (paperidobj.value).length;
	if ((paperidlen != 15) & (paperidlen != 18) & (paperidobj.value != "")) {
		alert(t['62']);
		websys_setfocus("paperid");
		return;
	}
	if (paperidobj.value != "") {
		var rtn = PaperIDSexErr();
		if (rtn == "SexNotSame") {
			var rtn = window.confirm("性别与身份证上的性别不一致,是否确认更新病人基本信息?");
			if (!rtn) {
				return;
			}
		}
		var rtn = PaperIDBirthErr();
		if (rtn == "BirthDateNotSame") {
			var rtn = window.confirm("出生日期与身份证上的出生日期不一致,是否确认更新病人基本信息?");
			if (!rtn) {
				return;
			}
		}
	}
	if ((papnameobj.value == "") || (papmiidobj.value == "")) {
		alert(t['39']);
		return;
	}
	var p1 = papmiidobj.value;
	var pycodeobj = document.getElementById('pycode');
	var hzipcodeobj = document.getElementById('Hpostalcode');
	var czipcodeobj = document.getElementById('Cpostalcode');
	var HCPobj = document.getElementById('HCPID');
	var HCPDescobj = document.getElementById('HCPDesc');
	var HCPDesc = HCPDescobj.value;
	if (HCPDesc == "") {
		HCPobj.value = "";
	}
	var p2 = papnameobj.value + "^" + medicareobj.value + "^" + sexidobj.value + "^" + paperidobj.value + "^" + birthdateobj.value;
	p2 = p2 + "^" + ageobj.value + "^" + ageyrobj.value + "^" + agemthobj.value + "^" + agedayobj.value + "^" + mardescidobj.value;
	p2 = p2 + "^" + rlgdescidobj.value + "^" + addressobj.value + "^" + hometelobj.value + "^" + zipidobj.value;
	p2 = p2 + "^" + companyobj.value + "^" + worktelobj.value + "^" + cityidobj.value + "^" + providobj.value + "^" + mobtelobj.value + "^" + emailobj.value + "^" + Guser + "^" + SocSatidobj.value + "^" + nationidobj.value;
	p2 = p2 + "^" + cardtypeidobj.value + "^" + govcardnoobj.value + "^" + countryidobj.value + "^" + occuidobj.value;
	p2 = p2 + "^" + eduidobj.value + "^" + languidobj.value + "^" + emptypeidobj.value + "^" + birprovobj.value;
	p2 = p2 + "^" + bircityobj.value + "^" + ctrltidobj.value + "^" + ForeignIdobj.value + "^" + FPhoneobj.value;
	p2 = p2 + "^" + FAddressobj.value + "^" + FNotesobj.value + "^" + cityareaidobj.value + "^" + pycodeobj.value + "^" + babydob1 + "^" + babydob2;
	p2 = p2 + "^" + hzipcodeobj.value + "^" + czipcodeobj.value + "^" + InsuNoObj.value + "^" + HCPobj.value;
	//modify 2012-01-12 增加出生地省、市、区、户口所在省、市、区等功能
	var BirthProvinceDr = DHCWebD_GetObjValue('BirthProvinceDr');
	var BirthCityDr = DHCWebD_GetObjValue('BirthCityDr');
	var BirthAreaDr = DHCWebD_GetObjValue('BirthAreaDr');
	var BirthAddress = DHCWebD_GetObjValue('BirthAddress');
	var HouseProvinceDr = DHCWebD_GetObjValue('HouseProvinceDr');
	var HouseCityDr = DHCWebD_GetObjValue('HouseCityDr');
	var HouseAreaDR = DHCWebD_GetObjValue('HouseAreaDR');
	var HouseAddress = DHCWebD_GetObjValue('HouseAddress');
	var HouseZipCode = DHCWebD_GetObjValue('HouseZipCode');
	p2 = p2 + "^" + BirthProvinceDr + "^" + BirthCityDr + "^" + BirthAreaDr + "^" + BirthAddress;
	p2 = p2 + "^" + HouseProvinceDr + "^" + HouseCityDr + "^" + HouseAreaDR + "^" + HouseAddress + "^" + HouseZipCode;
	//+2017-08-17 ZhYW 
	p2 += '^' + m_PhotoObj.value;
	var p3 = admidobj.value;
	var encmeth = DHCWebD_GetObjValue('getupreginfo');
	var tmp2 = cspRunServerMethod(encmeth, '', '', p1, p2, p3);
	if (tmp2 == 0){
		alert('病人基本信息修改成功');
	}
	return tmp2;
}

function admupdate_click() {
	//2015-1-6 tang 修改信息增加必填项判断
	var paperidlen = (paperidobj.value).length;
	if ((paperidobj.value != "") && (paperidlen != 15) && (paperidlen != 18)) {
		alert("身份证号位数不对,不能修改信息!");
		websys_setfocus("paperid");
		return;
	}
	if (papnameobj.value == "") {
		alert("姓名为空,不能修改信息!");
		websys_setfocus('name');
		return;
	}
	if ((SexObj.value == "") || (sexidobj.value == "")) {
		alert("性别为空,不能修改信息!");
		websys_setfocus('sex');
		return;
	}
	if ((admdepobj.value == "") || (admdepidobj.value == "")) {
		alert("科室为空,不能修改信息!");
		websys_setfocus('admdep');
		return;
	}
	if ((admwardobj.value == "") || (admwardidobj.value == "")) {
		alert("病区为空,不能修改信息!");
		websys_setfocus('admward');
		return;
	}
	if ((admreasonobj.value == "") || (admreaidobj.value == "")) {
		alert("病人类型为空,不能修改信息!");
		websys_setfocus('admreason');
		return;
	}
	if (birthdateobj.value == "") {
		alert("出生日期为空,不能修改信息!");
		return;
	}
	var tmp2 = regupdate_click();
	if (tmp2 == "BirthGreatthan") {
		alert("出生日期大于当前日期,不能修改就诊信息!!");
		return;
	} else if (tmp2 == "BabyDobError") {
		alert("婴儿出生时间不能大于入院时间!");
		return;
	} else {
	}
	clear_lookup();
	//就诊为空时则不更新就诊
	if ((admidobj.value == "") && (tmp2 == 0)) {
		//alert(t['42']);
		//alert("病人信息修改成功.");
		return;
	}
	if (admreaidobj.value == "") {
		alert("病人类型不允许为空,请选择");
		return;
	}
	var RefDocListdrobj = document.getElementById('RefDocListdr');
	var AdmDocDrObj = document.getElementById('admdocid');
	var AdmPriorityID = document.getElementById('AdmPriorityID').value;
	var p1 = admidobj.value;
	
	var p2 = admreaidobj.value + "^" + admepisidobj.value + "^" + admqkidobj.value + "^" + RefDocListdrobj.value + "^" + Guser;
	p2 += "^" + "" + "^" + "" + "^" + admdepidobj.value + "^" + admwardidobj.value + "^" + AdmDocDrObj.value;
	p2 += "^" + AdmSourceIDObj.value + "^" + admdateobj.value + "^" + AdmPriorityID; //入院病情
	
	var p3 = papmiidobj.value;
	var encmeth = DHCWebD_GetObjValue('getupadminfo');
	var tmp3 = cspRunServerMethod(encmeth, '', '', p1, p2, p3);
	if (tmp3 == "BedErr") {
		alert("病人已在床位不允许修改科室/病区.");
		return;
	}
	//+2018-01-19 ZhYW 
	if (tmp3 == "-1001") {
		alert("此病区已经没有可用的床位了.");
		return;
	}
	if (tmp3 == "-1002") {
		alert("已开医嘱,不能修改科室病区.");
		return;
	}
	if (tmp3 == "-1003") {
		alert("已开医嘱,不能修改医生.");
		return;
	}
	if ((tmp2 == "patvalno") && (tmp3 == "admvalno")) {
		alert(t['44']);
		return;
	}
	if ((tmp2 == "patiderror") || (tmp2 == "patvalerror")) {
		alert(t['39']);
		return;
	} else {
		if ((tmp3 == "admiderror") || (tmp3 == "admvalerror")) {
			alert(t['43']);
			return;
		}
	}
	if (tmp3 == "AdmDateErr") {
		alert("已入院患者不允许修改就诊信息!");
		return;
	}
	if ((tmp2 == "0") || (tmp2 == "patvalno")) {
		if ((tmp3 == "0") || (tmp3 == "admvalno")) {
			if (tmp3 == "0"){
				alert(t['56']);
			}else if ((tmp3 == "admvalno") && (tmp2 == "patvalno")){
				alert(t['45']);
			}else {
				
			}
			//clear_click();   //修改成功后不清空
			return;
		} else {
			alert(t['57']);
			return;
		}
	}
}

function patupsearch_click() {
	var encmeth = DHCWebD_GetObjValue('getdatetime');
	var stdatetime = cspRunServerMethod(encmeth);
	var str1 = stdatetime.split("^");
	var stdate = str1[0];
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFUpPatInfo&stdate=' + stdate + '&enddate=' + stdate + '&stdate1=' + stdate + '&enddate1=' + stdate + '&username=' + gusername + '&userid=' + Guser;
	websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

function getpatbycard() {
	if (opcardnoobj.value == "") {
		alert("no card no");
		return;
	}
	var encmeth = DHCWebD_GetObjValue("getpatbyCardNoClass");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, opcardnoobj.value, cardCheckNo);
		var myary = rtn.split("^");
		if (myary[0] == '0') {
			papnoobj.value = myary[1];
			papmiidobj.value = myary[2];
			papnameobj.value = myary[3];
			//cardCheckNo = myary[5];
			opcardid = myary[6];
			if (PapnoFlag == "N") {
				websys_setfocus('name');
			}
			if (PapnoFlag == "Y") {
				websys_setfocus('Regno');
			}
		} else {
			if (myary[0] == '-341') {
				alert(t[2024]);
			}
			if (myary[0] == '-340') {
				alert(t[2003]);
			}
			//Clear_click();
		}
	}
}

function admcancel_click() {
	if (papmiidobj.value == "") {
		alert(t['47']);
		return;
	}
	if (admidobj.value == "") {
		alert(t['42']);
		return;
	}
	if (admvisitobj.value == "") {
		alert(t['48']);
		return;
	}
	var truthBeTold = window.confirm(t['HXEY11']);
	if (!truthBeTold) {
		return;
	}
	var ReaInfo = tkMakeServerCall("web.UDHCJFORDCHK", "GetAdmReaInfo", admidobj.value);
	var ReaInfo1 = ReaInfo.split("^");
	var AdmReasonNationCode = ReaInfo1[1];
	var AdmReasonId = ReaInfo1[0];
	var InsuAdmInfo = tkMakeServerCall("web.DHCINSUPort", "GetInsuAdmInfoByAdmDr", admidobj.value);
	var InsuAdmInfo = InsuAdmInfo.split("^");
	if ((AdmReasonNationCode != "") && (AdmReasonNationCode != "0")) {
		if ((InsuAdmInfo != "") && (InsuAdmInfo[10] != "B") & (InsuAdmInfo[10] != "S")) {
			alert("医保登记没有退院不允许退院.");
			return;
		}
	}
	var p1 = admidobj.value;
	var p2 = Guser;
	var encmeth = DHCWebD_GetObjValue('getadmcancel');
	var tmp2 = cspRunServerMethod(encmeth, '', '', p1, p2);
	if (tmp2 == "100") {
		alert(t['42']);
		return;
	} else if (tmp2 == "1") {
		alert(t['49']);
		return;
	} else if (tmp2 == "2") {
		alert(t['48']);
		return;
	} else if (tmp2 == "3") {
		alert(t['50']);
		return;
	} else if (tmp2 == "4") {
		alert(t['51']);
		return;
	} else if (tmp2 == "6") {
		alert("病人有未停止的医嘱,不能退院.");
		return;
	} else if (tmp2 == "7") {
		alert("有在院或者出院婴儿就诊,母亲不能退院.");
		return;
	} else if (tmp2 == "5") {
		alert(t['54']);
		return;
	} else if (tmp2 == "BedErr") {
		alert("此病人有包床信息,请取消包床后退院.")
		return
	} else if (tmp2 == "OPAdm") {
		alert("此病人有门诊费用转住院不允许退院.")
		return;
	}else if (tmp2 == "PatInBedErr") {
		alert("此病人目前在床，不允许退院.")
		return;
	}  else if (tmp2 == "0") {
		alert(t['52']);
		//update by zf 20150317 取消接诊接口
		if (typeof btnUnReceipt_onclick != 'undefined') {
			btnUnReceipt_onclick();
		}
		//
		clear_click();
		return;
	} else {
		alert(t['53'] + "ErrCode" + tmp2);
		return;
	}
}

function clear_lookup() {
	if (SexObj.value == "") {
		sexidobj.value = "";
	}
	if (mardescobj.value == "") {
		mardescidobj.value = "";
	}
	if (rlgdescobj.value == "") {
		rlgdescidobj.value = "";
	}
	if (zipcodeobj.value == "") {
		zipidobj.value = "";
	}
	if (provdescobj.value == "") {
		providobj.value = "";
	}
	if (cityobj.value == "") {
		cityidobj.value = "";
	}
	if (admdepobj.value == "") {
		admdepidobj.value = "";
	}
	if (admwardobj.value == "") {
		admwardidobj.value = "";
	}
	if (bedobj.value == "") {
		bedidobj.value = "";
	}
	if (roomobj.value == "") {
		roomidobj.value = "";
	}
	if (admdocobj.value == "") {
		admdocidobj.value = "";
	}
	if (admreasonobj.value == "") {
		admreaidobj.value = "";
	}
	if (admepisobj.value == "") {
		admepisidobj.value = "";
	}
	if (SocSatdescobj.value == "") {
		SocSatidobj.value = "";
	}
	if (admqkobj.value == "") {
		admqkidobj.value = "";
	}
	if (nationdescobj.value == "") {
		nationidobj.value = "";
	}
	if (cardtypeobj.value == "") {
		cardtypeidobj.value = "";
	}
	if (countryobj.value == "") {
		countryidobj.value = "";
	}
	if (occuobj.value == "") {
		occuidobj.value = "";
	}
	if (eduobj.value == "") {
		eduidobj.value = "";
	}
	if (languobj.value == "") {
		languidobj.value = "";
	}
	if (emptypeobj.value == "") {
		emptypeidobj.value = "";
	}
	if (homeplaceobj.value == "") {
		birprovobj.value = "";
		bircityobj.value = "";
	}
	if (ctrltdescobj.value == "") {
		ctrltidobj.value = "";
	}
	if (cityareaobj.value == "") {
		cityareaidobj.value = "";
	}
	if (diagnosobj.value == "") {
		diagnosidobj.value = "";
	}
	if (digtypeobj.value == "") {
		digtypeidobj.value = "";
	}
	var RefDocListdrobj = document.getElementById('RefDocListdr');
	var RefDocListobj = document.getElementById('RefDocList');
	if (RefDocListobj.value == "") {
		RefDocListdrobj.value = "";
	}
	if (document.getElementById('pycode').value == "") {
		var namestr = papnameobj.value;
		var namestr1 = GetSpellCodeNew(namestr);
		document.getElementById('pycode').value = namestr1;
	}
	var BirthProvinceDrobj = document.getElementById('BirthProvinceDr');
	var PAPERBirthProvinceobj = document.getElementById('PAPERBirthProvince');
	if (PAPERBirthProvinceobj.value == "") {
		BirthProvinceDrobj.value = "";
	}
	var BirthCityDrobj = document.getElementById('BirthCityDr');
	var BirthCityobj = document.getElementById('BirthCity');
	if (BirthCityobj.value == "") {
		BirthCityDrobj.value = "";
	}
	var BirthAreaDrobj = document.getElementById('BirthAreaDr');
	var BirthAreaobj = document.getElementById('BirthArea');
	if (BirthAreaobj.value == "") {
		BirthAreaDrobj.value = "";
	}
	var HouseProvinceDrobj = document.getElementById('HouseProvinceDr');
	var HouseProvinceobj = document.getElementById('HouseProvince');
	if (HouseProvinceobj.value == "") {
		HouseProvinceDrobj.value = "";
	}
	var HouseCityDrobj = document.getElementById('HouseCityDr');
	var HouseCityobj = document.getElementById('HouseCity');
	if (HouseCityobj.value == "") {
		HouseCityDrobj.value = "";
	}
	var HouseAreaDRobj = document.getElementById('HouseAreaDR');
	var HouseAreaobj = document.getElementById('HouseArea');
	if (HouseAreaobj.value == "") {
		HouseAreaDRobj.value = "";
	}
}

function INSUReg_click() {
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=INSUIPReg&PapmiNo=' + papnoobj.value + "&AdmDr=" + admidobj.value;
	websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
	/*
	var result = window.showModalDialog(lnk, window, 'dialogWidth:' + iWidth + 'px;dialogHeight:' + iHeight + 'px;center:yes;');
	if (result != null) {
		if (result != "") {
			location.href = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFCASHIER";
		}
	}
	*/
}

function refunddeposit_click() {
	Adm = admidobj.value;
	if (Adm == "") {
		alert(t['42']);
		return;
	}
	var str = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFRefundDeposit&Adm=' + Adm;
	window.open(str, '_blank', 'toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=1000,height=600,left=0,top=60');
}

function abort(yjrowid, rcptrowid) {
	var p1 = yjrowid;
	var p2 = rcptrowid;
	var p3 = Guser;
	var encmeth = DHCWebD_GetObjValue('Abort');
	if (cspRunServerMethod(encmeth, 'SetPid1', '', p1, p2, p3) == '0') {}
}

function SetPid1(value) {
	if (value != "0") {
		alert(t['12']);
		return;
	} else {
		Add_click();
	}
}

function entercomp() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		websys_setfocus('BtnPrint');
	}
}

function entercardno() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

function elementformat() {
	var compobj = document.getElementById("deptcomp");
	var Myobj = document.getElementById('Myid');
	if (Myobj) {
		var imgname = "ld" + Myobj.value + "i" + "bank";
		var bankobj1 = document.getElementById(imgname);
	}
	if (pyobj.value == t['02']) {
		if (bankobj) {
			bankobj.readOnly = true;
		}
		if (compobj) {
			compobj.readOnly = true;
		}
		if (cardnoobj) {
			cardnoobj.readOnly = true;
		}
		if (banksubobj) {
			banksubobj.readOnly = true;
		}
		if (bankobj1) {
			bankobj1.style.display = "none";
		}
	} else {
		if (bankobj) {
			bankobj.readOnly = false;
		}
		if (compobj) {
			compobj.readOnly = false;
		}
		if (cardnoobj) {
			cardnoobj.readOnly = false;
		}
		if (banksubobj) {
			banksubobj.readOnly = false;
		}
		if (bankobj1) {
			bankobj1.style.display = "";
		}
	}
}

function CardTypelookup(str) {
	var tmp1 = str.split("^");
	cardtypeidobj.value = tmp1[1];
	govcardnoobj.value = "";
	websys_setfocus('GovCardno');
}

function entercardtype() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		CardType_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function govcardnooncharge() {
	var myrtn = IsCredTypeID();
	if (myrtn) {
		var mypId = DHCWebD_GetObjValue("GovCardno");
		mypId = mypId.toUpperCase();
		var myary = DHCWeb_GetInfoFromId(mypId);
		if (myary[0] == "1") {
			DHCWebD_SetObjValueC("birthdate", myary[2]);
			DHCWebD_SetObjValueC("age", myary[4]);
			var mySexDR = "";
			switch (myary[3]) {
			case "男":
				mySexDR = "1";
				break;
			case "女":
				mySexDR = "2";
				break;
			default:
				mySexDR = "4";
				break;
			}
			DHCWebD_SetObjValueC("sex", myary[3]);
			DHCWebD_SetObjValueC("sexid", mySexDR);
			DHCWebD_SetObjValueC("paperid", mypId);
		} else {
			websys_setfocus("GovCardno");
			return;
		}
	}
	DHCWeb_Nextfocus();
}

function entergovcardno() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var myrtn = IsCredTypeID();
		if (myrtn) {
			var mypId = DHCWebD_GetObjValue("GovCardno");
			mypId = mypId.toUpperCase();
			var myary = DHCWeb_GetInfoFromId(mypId);
			if (myary[0] == "1") {
				DHCWebD_SetObjValueC("birthdate", myary[2]);
				DHCWebD_SetObjValueC("age", myary[4]);
				var mySexDR = "";
				switch (myary[3]) {
				case "男":
					mySexDR = "1";
					break;
				case "女":
					mySexDR = "2";
					break;
				default:
					mySexDR = "4";
					break;
				}
				DHCWebD_SetObjValueC("sex", myary[3]);
				DHCWebD_SetObjValueC("sexid", mySexDR);
				DHCWebD_SetObjValueC("paperid", mypId);
			} else {
				websys_setfocus("GovCardno");
				return;
			}
		}

		DHCWeb_Nextfocus();
	}
}

function Countrylookup(str) {
	var tmp1 = str.split("^");
	countryidobj.value = tmp1[1]
}

function getAdmRefPriorityID(str) {
	var tmp1 = str.split("^");
	AdmRefPriorityIDObj.value = tmp1[1];
}

function entercountry() {
	if (window.event.keyCode == 13) {
		var countrystr = countryobj.value;
		if (countrystr != t['65']) {
			window.event.keyCode = 117;
			var e = event ? event : (window.event ? window.event : null);
			e.isLookup = true;
			Country_lookuphandler(e);
		} else {
			DHCWeb_Nextfocus();
		}
	}
}

function Occulookup(str) {
	var tmp1 = str.split("^");
	occuidobj.value = tmp1[1];
}

function enteroccu() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		Occupation_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function Edulookup(str) {
	var tmp1 = str.split("^");
	eduidobj.value = tmp1[1];
}

function enteredu() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		Education_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function langulookup(str) {
	var tmp1 = str.split("^");
	languidobj.value = tmp1[1];
}

function enterlangu() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		Language_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function emptypelookup(str) {
	var tmp1 = str.split("^");
	emptypeidobj.value = tmp1[1]
}

function enteremptype() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		EmployeeType_lookuphandler();
		DHCWeb_Nextfocus();
	}
}

function homeplacelookup(str) {
	var tmp1 = str.split("^");
	birprovobj.value = tmp1[1];
	bircityobj.value = tmp1[2];
}

function enterhomeplace() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		HomePlace_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function ctrltlookup(str) {
	var tmp1 = str.split("^");
	ctrltidobj.value = tmp1[1]
}

function enterctrlt() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		Ctrltdesc_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function enterForeignId() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

function enterFPhone() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

function enterFAddress() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

function enterFNotes() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

function getadmdate() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		//+2017-08-21 ZhYW 将日期格式化封装到一个方法中
		FormatDate('admdate');
	}
}

function LinkaddDeposit_click() {
	var rtn = window.confirm("是否确认到【交押金】界面交押金?");
	if (!rtn){
		return;
	}
	Adm = admidobj.value;
	if (Adm == "") {
		alert(t['25']);
		return;
	}
	deposittype = "";
	//modify 2014-11-18 增加控制退院的病人不能交押金
	var ReturnVal = tkMakeServerCall("web.UDHCJFIPReg", "GetAdmVisitStatus", admidobj.value);
	if ((ReturnVal == "") || (ReturnVal == " ")) {
		alert("获取就诊信息失败。");
		return;
	} else if (ReturnVal == "AdmNull") {
		alert("获取就诊信息失败。");
		return;
	} else {
		var ReturnVal1 = ReturnVal.split("^");
		if (ReturnVal1[1] == "C") {
			alert("病人已退院不能交押金。");
			return;
		}
	}
	
	var lnk = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFDeposit&Adm=' + Adm + '&deposittype=' + t['01'];
	websys_createWindow(lnk, '_blank', 'toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
}

function cityarealookup(str) {
	var tmp1 = str.split("^");
	if (tmp1[3] == "0") {
		tmp1[3] = "";
	}
	var obj = document.getElementById("CTCITDesc");
	if (obj) {
		obj.value = tmp1[1];
	}
	var obj = document.getElementById("PROVDesc");
	if (obj) {
		obj.value = tmp1[2];
	}
	var obj = document.getElementById("cityareaid");
	if (obj) {
		obj.value = tmp1[3];
	}
	var obj = document.getElementById("cityid");
	if (obj) {
		obj.value = tmp1[4];
	}
	var obj = document.getElementById("provid");
	if (obj) {
		obj.value = tmp1[5];
	}
	//+2018-06-04 ZhYW 
	var myCityAreaDR = tmp1[3];
	GetZipInfo("", "", myCityAreaDR, "Hpostalcode");    //住址邮编
}

function entercityarea() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		cityarea_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function enterbaby() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		var agehourobj = document.getElementById('agehour');
		var ageMinutesobj = document.getElementById('ageMinutes');
		var babybirstr = babybirobj.value + t['HXEY05'] + agehourobj.value + t['HXEY06'] + ageMinutesobj.value + t['HXEY07'];
		if (ageMinutesobj.value != "") {
			if (eval(ageMinutesobj.value) > 59) {
				ageMinutesobj.value = "";
				return;
			}
		}
		if (agehourobj.value != "") {
			if (eval(agehourobj.value) > 23) {
				agehourobj.value = "";
				return;
			}
		}
		if ((babybirobj.value != "") || (agehourobj.value != "") || (ageMinutesobj.value != "")) {
			//modify hujunbin 15.1.8
			var ageConfig = tkMakeServerCall("web.UDHCJFAgeConfig", "GetAgeConfig");
			if (ageConfig == "Y") {
				var p2 = admdateobj.value;
				var p3 = admtimeobj.value;
				var p1 = babybirstr;
			} else {
				var currDateTime = tkMakeServerCall("web.UDHCJFCOMMON", "getdatetime");
				var currDate = currDateTime.split("^")[0];
				var currTime = currDateTime.split("^")[1];
				var p2 = currDate;
				var p3 = currTime;
				var p1 = babybirstr;
			}
			var encmeth = DHCWebD_GetObjValue('getbabybirday');
			var tmp2 = cspRunServerMethod(encmeth, p1, p2, p3);
			if (tmp2 != "") {
				if (tmp2 == "1") {
					alert(t['HXEY01']);
					return;
				} else if (tmp2 == "2") {
					alert(t['HXEY02']);
					return;
				} else if (tmp2 == "3") {
					alert(t['HXEY03']);
					return;
				} else {
					var babystr = tmp2.split("^");
					babydob1 = babystr[0];
					babydob2 = babystr[1];
					var babybirthday = babystr[2];
					birthdateobj.value = babybirthday;
					//add hujunbin 14.12.13
					if ((babydob1 != "") && (babydob2 != "")) {
						var getage1flag = getage2(babydob1, babydob2);
						if (getage1flag != true) {
							//websys_setfocus("birthdate");
							return;
						}
					} else if (birthdateobj.value != "") {
						var getage1flag = getage1();
						if (getage1flag != true) {
							//websys_setfocus("birthdate");
							return;
						}
					}
				}
			}
		}
		/*
		if (babybirobj.value != "") {
			agedayobj.value = babybirobj.value;
		}
		*/
		DHCWeb_Nextfocus();
	}
}

function getdiagnos() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		Diagnos_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function LookUpWithAlias(str) {
	var tmp1 = str.split("^");
	diagnosidobj.value = tmp1[1];
}

function getdigtype() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		DiagnosType_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function digtypelookup(str) {
	var tmp1 = str.split("^");
	digtypeidobj.value = tmp1[1];
}

function refdoclookup(str) {
	var RefDocListdrobj = document.getElementById('RefDocListdr');
	var tmp1 = str.split("^");
	RefDocListdrobj.value = tmp1[1];
}

function getrefdoc() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		RefDocList_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

function getnewcardinfo() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		if (newcardnoobj.value == "") {
			alert(t['HXEY08']);
			return;
		} else {
			var lnewcardno = newcardnoobj.value.length;
			if (eval(lnewcardno) != 10) {
				alert(t['HXEY10']);
				return;
			}
			var p1 = newcardnoobj.value;
			var encmeth = DHCWebD_GetObjValue('getnewcardinfo');
			var newcardinfo = cspRunServerMethod(encmeth, p1);
			if (newcardinfo != "") {
				var tmp = newcardinfo.split("^");
				papnoobj.value = tmp[2];
				getpatinfo1();
			}
			if (newcardinfo == "") {
				websys_setfocus('name');
			}
		}
	}
}

function getnationdesc() {
	if (nationdescobj.value == "") {
		nationdescobj.value = t['66'];
		var encmeth = DHCWebD_GetObjValue('getnationid');
		var getnationid = cspRunServerMethod(encmeth, '', '', t['66']);
		nationidobj.value = getnationid;
	}
}

function getcountrydesc() {
	if (countryobj.value == "") {
		countryobj.value = t['65'];
		var encmeth = DHCWebD_GetObjValue('getcountryid');
		var getcountryid = cspRunServerMethod(encmeth, '', '', t['65']);
		countryidobj.value = getcountryid;
	}
}

function Prt_WCinctureo() {
	var prtConfig = tkMakeServerCall('web.UDHCJFIPReg', 'GetWDPrintFlag');
	if (prtConfig == 0) {
		alert('配置不打印腕带,如需打印,请修改打印配置.');
		return;
	} else if (prtConfig == 2) {
		alert('配置需要在护士站打印腕带.');
		return;
	}
	prt_Wristband(admidobj.value);
}

function Prt_WCinctureoChild() {
	var prtConfig = tkMakeServerCall('web.UDHCJFIPReg', 'GetChildWDPrintFlag');
	if (prtConfig == 0) {
		alert('配置不打印腕带,如需打印,请修改打印配置.');
		return;
	} else if (prtConfig == 2) {
		alert('配置需要在护士站打印腕带.');
		return;
	}
	prt_WristbandChild(admidobj.value);
}

function Prt_WCinctureoOLD() {
	var WCinctureoFlag = tkMakeServerCall("web.UDHCJFIPReg", "GetWDPrintFlag");
	if ((WCinctureoFlag == "0") || (WCinctureoFlag == 0)) {
		alert("配置不打印腕带,如需打印,请修改打印配置!");
		return;
	} else if ((WCinctureoFlag == "2") || (WCinctureoFlag == 2)) {
		alert("配置需要在护士站打印腕带!");
		return;
	}
	if (admidobj.value == "") {
		alert(t['PrintError1']);
		return;
	} else {
		var encmeth = DHCWebD_GetObjValue('getadmstatus');
		var getadmstatus = cspRunServerMethod(encmeth, admidobj.value);
		if (getadmstatus != "A") {
			alert(t['PrintError1']);
			return;
		}
		var TMPage = '';
		var obj = new ActiveXObject("JFPrint.PrtBarcode");
		if (obj) {
			obj.PrintWirst(papnoobj.value, papnameobj.value, SexObj.value, TMPage, "WANDAI", 1, admdateobj.value, bedobj.value);
			/*
			//add by wangjian 2015-01-26
			var myCondition = '{papno:"' + papnoobj.value + '",papname:"' + papnameobj.value + '",PrintDiv:"' + t['PrintName'] + '"}'
			var myContent = '{papno:"' + papnoobj.value + '",EpisodeId:"' + admidobj.value + '"}'
			var mySecretCodeStr = tkMakeServerCall("web.UDHCJFBaseCommon", "GetPatEncryptLevel", "", admidobj.value)
			var mySecretCode = mySecretCodeStr.split("^")[2];
			websys_EventLog("UDHCJFIPReg.WCinctureo", myCondition, myContent, mySecretCode);
			*/
			//end
		} else {
			alert("打印包加载错误!");
		}
		obj = null;
	}
}

function FrameEnterkeyCode() {
	var e = window.event;
	switch (e.keyCode) {
	case 118:
		clear_click();
		break;
	case 119:
		Prt_WCinctureo();
		break;
	case 120:
		regsave_click();
		break;
	case 121:
		if (LinkDepositFlag == "Y") {
			if (DepositFlag == "N") {
				LinkaddDeposit_click();
			} else {
				getyjinfo();
				Add_click();
			}
		} else {
			//DHCWeb_DisBtn(btnyjobj);
		}
		break;
	case 117:
 		admcancel_click();
		break;
	}
}

//修改住院次数
function UpInPatNo_click() {
	if (admidobj.value == "") {
		alert("请选择病人的就诊记录.");
		return;
	}
	var InPatNo = AdmTimesobj.value;
	var ReturnVal = tkMakeServerCall("web.UDHCJFIPReg", "UpdateAdmInPatNo", admidobj.value, InPatNo, Guser);
	if (ReturnVal == 0) {
		alert("住院次数修改成功.");
		return;
	} else {
		alert("住院次数修改失败.");
	}
}

//读二带身份证
function readperson_click() {
	try {
		var myHCTypeDR = '1';
		var myInfo = DHCWCOM_PersonInfoRead(myHCTypeDR);
		//测试串
		//var myInfo = "0^<IDRoot><Age>55</Age><Name>****</Name><Sex>1</Sex><NationDesc>汉</NationDesc><Birth>19620817</Birth><Address>湖南省岳阳市岳阳楼区七里山社区居委会*区**栋***号</Address><CredNo>430105196208171015</CredNo><PhotoInfo></PhotoInfo></IDRoot>"
		var myAry = myInfo.split('^');
		if ((myAry.length > 1) && (myAry[0] == '0')) {
			SetPatInfoByXML(myAry[1]);
		}
	}catch(e){
	}
}

/**
* Creator: ZhYW
* CreatDate: 2017-08-17
*/
function SetPatInfoByXML(XMLStr) {
	XMLStr = "<?xml version='1.0' encoding='gb2312'?>" + XMLStr;
	var xmlDoc = DHCDOM_CreateXMLDOM();
	xmlDoc.async = false;
	xmlDoc.loadXML(XMLStr);
	if (xmlDoc.parseError.errorCode != 0) {
		alert(xmlDoc.parseError.reason);
		return;
	}
	var nodes = xmlDoc.documentElement.childNodes;
	for (var i = 0; i < nodes.length; i++) {
		var myItemName = nodes(i).nodeName;
		var myItemValue = nodes(i).text;
		switch (myItemName) {
		case 'CredNo':
			DHCWebD_SetListValueA(paperidobj, myItemValue);
			break;
		case 'Name':
			var patName = DHCWebD_GetObjValueA(papnameobj);
			if ((patName != "") && (myItemValue != "") && (patName != myItemValue)) {
				var myrtn = window.confirm("身份证姓名:" + myItemValue + " 与HIS姓名:" + patName + " 不一致,是否使用身份证姓名!");
				if (myrtn) {
					DHCWebD_SetListValueA(papnameobj, myItemValue);
				}
			} else {
				DHCWebD_SetListValueA(papnameobj, myItemValue);
			}
			break;
		case 'Sex':
			var sex = '';
			switch (myItemValue) {
			case '1':
				sex = '男';
				break;
			case '2':
				sex = '女';
				break;
			default:
				sex = '其他';
				break;
			}
			DHCWebD_SetListValueA(SexObj, sex);
			var encmeth = DHCWebD_GetObjValue('GetSexDr');
			var SexDr = cspRunServerMethod(encmeth, sex);
			if (SexDr != "") {
				SexDr = SexDr.split('^');
				DHCWebD_SetListValueA(sexidobj, SexDr[0]);
			}
			break;
		case 'Birth':
			DHCWebD_SetListValueA(birthdateobj, myItemValue);
			var DateFlag = FormatDate('birthdate');
			break;
		case 'NationDesc':
			if (myItemValue.indexOf('族') == -1){
				myItemValue = myItemValue + '族';
			}
			DHCWebD_SetListValueA(nationdescobj, myItemValue);
			var encmeth = DHCWebD_GetObjValue('getnationid');
			var nationID = cspRunServerMethod(encmeth, '', '', myItemValue);
			DHCWebD_SetListValueA(nationidobj, nationID);
			break;
		case 'Age':
			if (myItemValue.indexOf('岁') == -1){
				myItemValue = myItemValue + '岁';
			}
			DHCWebD_SetListValueA(ageobj, myItemValue);
			break;
		case 'Address':
			DHCWebD_SetListValueA(addressobj, myItemValue);
			break;
		case 'PhotoInfo':
			DHCWebD_SetListValueA(m_PhotoObj, myItemValue);
			var credID = DHCWebD_GetObjValueA(paperidobj);
			ShowPicByPatInfo(myItemValue, credID);
			break;
		default:
			break;
		}
	}
	delete xmlDoc;
}

//根据安全组取默认费别
function GetDefAdmReason() {
	var DefAdmReasonInfo = tkMakeServerCall("web.UDHCJFBaseCommon", "GetDefAdmReason", session['LOGON.GROUPID']);
	DefAdmReasonInfo = DefAdmReasonInfo.split("^");
	if ((admreaidobj.value == "") && (admreasonobj.value == "")) {
		admreaidobj.value = DefAdmReasonInfo[0];
		admreasonobj.value = DefAdmReasonInfo[1];
	}
}

function GetBirthProvince(str) {
	var lu = str.split("^");
	var obj = document.getElementById("PAPERBirthProvince");
	if (obj) {
		obj.value = lu[0];
	}
	if (lu[1] == "0") {
		lu[1] = "";
	}
	var obj = document.getElementById("BirthProvinceDr");
	if (obj) {
		obj.value = lu[1];
	}
	var obj = document.getElementById("BirthCity");
	if (obj) {
		obj.value = "";
	}
	var obj = document.getElementById("BirthCityDr");
	if (obj) {
		obj.value = "";
	}
	var obj = document.getElementById("BirthArea");
	if (obj) {
		obj.value = "";
	}
	var obj = document.getElementById("BirthAreaDr");
	if (obj) {
		obj.value = "";
	}
}

function GetBirthCity(str) {
	var lu = str.split("^");
	var obj = document.getElementById("BirthCity");
	if (obj) {
		obj.value = lu[0];
	}
	var obj = document.getElementById("PAPERBirthProvince");
	if (obj) {
		obj.value = lu[1];
	}
	if (lu[2] == "0") {
		lu[2] = "";
	}
	var obj = document.getElementById("BirthCityDr");
	if (obj) {
		obj.value = lu[2];
	}
	var obj = document.getElementById("BirthProvinceDr");
	if (obj) {
		obj.value = lu[3];
	}
	var obj = document.getElementById("BirthArea");
	if (obj) {
		obj.value = "";
	}
	var obj = document.getElementById("BirthAreaDr");
	if (obj) {
		obj.value = "";
	}
}

function GetBirthArea(str) {
	var tmp1 = str.split("^");
	var BirthAreaDrobj = document.getElementById("BirthAreaDr");
	if (tmp1[3] == "0") {
		tmp1[3] = "";
	}
	var obj = document.getElementById("BirthCity");
	if (obj) {
		obj.value = tmp1[1];
	}
	var obj = document.getElementById("PAPERBirthProvince");
	if (obj) {
		obj.value = tmp1[2];
	}
	var obj = document.getElementById("BirthCityDr");
	if (obj) {
		obj.value = tmp1[4];
	}
	var obj = document.getElementById("BirthAreaDr");
	if (obj) {
		obj.value = tmp1[3];
	}
	var obj = document.getElementById("BirthProvinceDr");
	if (obj) {
		obj.value = tmp1[5];
	}
}

function GetHouseProvince(str) {
	var lu = str.split("^");
	var obj = document.getElementById("HouseProvince");
	if (obj) {
		obj.value = lu[0];
	}
	if (lu[1] == "0") {
		lu[1] = "";
	}
	var obj = document.getElementById("HouseProvinceDr");
	if (obj) {
		obj.value = lu[1];
	}
	var obj = document.getElementById("HouseCity");
	if (obj) {
		obj.value = "";
	}
	var obj = document.getElementById("HouseCityDr");
	if (obj) {
		obj.value = "";
	}
	var obj = document.getElementById("HouseArea");
	if (obj) {
		obj.value = "";
	}
	var obj = document.getElementById("HouseAreaDR");
	if (obj) {
		obj.value = "";
	}
}

function GetHouseCity(str) {
	var lu = str.split("^");
	var obj = document.getElementById("HouseCity");
	if (obj) {
		obj.value = lu[0];
	}
	var obj = document.getElementById("HouseProvince");
	if (obj) {
		obj.value = lu[1];
	}
	if (lu[2] == "0") {
		lu[2] = "";
	}
	var obj = document.getElementById("HouseCityDr");
	if (obj) {
		obj.value = lu[2];
	}
	var obj = document.getElementById("HouseProvinceDr");
	if (obj) {
		obj.value = lu[3];
	}
	var obj = document.getElementById("HouseArea");
	if (obj) {
		obj.value = "";
	}
	var obj = document.getElementById("HouseAreaDR");
	if (obj) {
		obj.value = "";
	}
	//+2018-06-04 ZhYW 
	var myCityDR = lu[2];
	GetZipInfo("", myCityDR, "", "HouseZipCode");    //户口邮编
}

function GetHouseArea(str) {
	var tmp1 = str.split("^");
	var HouseAreaDRobj = document.getElementById("HouseAreaDR");
	if (tmp1[3] == "0") {
		tmp1[3] = "";
	}
	var obj = document.getElementById("HouseCity");
	if (obj) {
		obj.value = tmp1[1];
	}
	var obj = document.getElementById("HouseProvince");
	if (obj) {
		obj.value = tmp1[2];
	}
	var obj = document.getElementById("HouseCityDr");
	if (obj) {
		obj.value = tmp1[4];
	}
	var obj = document.getElementById("HouseAreaDR");
	if (obj) {
		obj.value = tmp1[3];
	}
	var obj = document.getElementById("HouseProvinceDr");
	if (obj) {
		obj.value = tmp1[5];
	}
	//+2018-06-04 ZhYW 
	var myCityAreaDR = tmp1[3];
	GetZipInfo("", "", myCityAreaDR, "HouseZipCode");    //户口邮编
}

function getProvince() {
	if (window.event.keyCode == 13) {
		var nationstr = nationdescobj.value;
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		PROVDesc_lookuphandler(e);
	}
}

function getCity() {
	if (window.event.keyCode == 13) {
		var nationstr = nationdescobj.value;
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		CTCITDesc_lookuphandler(e);
	}
}

function getBirthProvince() {
	if (window.event.keyCode == 13) {
		var nationstr = nationdescobj.value;
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		PAPERBirthProvince_lookuphandler(e);
	}
}

function getBirthCity() {
	if (window.event.keyCode == 13) {
		var nationstr = nationdescobj.value;
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		BirthCity_lookuphandler(e);
	}
}

function getBirthArea() {
	if (window.event.keyCode == 13) {
		var nationstr = nationdescobj.value;
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		BirthArea_lookuphandler(e);
	}
}

function getBirthAddress() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

function getHouseProvince() {
	if (window.event.keyCode == 13) {
		var nationstr = nationdescobj.value;
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		HouseProvince_lookuphandler(e);
	}
}

function getHouseCity() {
	if (window.event.keyCode == 13) {
		var nationstr = nationdescobj.value;
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		HouseCity_lookuphandler(e);
	}
}

function getHouseArea() {
	if (window.event.keyCode == 13) {
		var nationstr = nationdescobj.value;
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		HouseArea_lookuphandler(e);
	}
}

function getHouseAddress() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

function getHouseZipCode() {
	var e = event ? event : (window.event ? window.event : null);
	var key = websys_getKey(e);
	if (key == 13) {
		DHCWeb_Nextfocus();
	}
}

///读医保卡
function ReadInsuCard_OnClick() {
	try {
		var rtn = ReadCard("Y");
		if ((rtn == "-1") || (rtn == "")) {
			//alert(t['ReadInsuCardErr']);
			return;
		}
		var myArr = rtn.split("|");
		var obj = document.getElementById('opcardno');
		if (obj) {
			obj.value = myArr[0];
		}
		var CardNo = myArr[0];
		var InsuReaCode = myArr[6];
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
			papnoobj.value = PatientNo;
			//var obj = document.getElementById("PatientID");
			//obj.value = myary[5];
			getpatinfo1();
			if ((InsuReaCode != "") && (InsuReaCode != " ")) {
				var InsuInfo = tkMakeServerCall("web.UDHCJFIPReg", "GetReaInsuInfo", InsuReaCode);
				if (InsuInfo != "") {
					var InsuInfo1 = InsuInfo.split("^");
					admreasonobj.value = InsuInfo1[1];
					admreaidobj.value = InsuInfo1[0];
				}
			}
			break;
		case "-200": //卡无效,InvaildCard:卡无效
			alert("卡无效");
			//websys_setfocus('RegNo');
			break;
		case "-201": //现金,Cashpayment:使用现金
			var PatientID = myary[4];
			var PatientNo = myary[5];
			papnoobj.value = PatientNo;
			/*
			var obj = document.getElementById("PatientID");
			obj.value = myary[5];
			m_ReadCardFlag = 1;   //读卡成功后?该标志设为1?
			*/
			getpatinfo1();
			if ((InsuReaCode != "") && (InsuReaCode != " ")) {
				var InsuInfo = tkMakeServerCall("web.UDHCJFIPReg", "GetReaInsuInfo", InsuReaCode);
				if (InsuInfo != "") {
					var InsuInfo1 = InsuInfo.split("^");
					admreasonobj.value = InsuInfo1[1];
					admreaidobj.value = InsuInfo1[0];
				}
			}
			break;
		default:
		}
	} catch (e) {
		alert("读卡错误:" + " " + e.message);
		return;
	}
}

//入院途径
function AdmSourceOfAttend(AdmSourceInfo) {
	var AdmSourceInfo = AdmSourceInfo.split("^");
	document.getElementById('AdmSourceID').value = AdmSourceInfo[1]
}

function SetDefAdmValue() {
	gettoday();
	admqkobj.value = t['58'];
	var p1 = admqkobj.value;
	var encmeth = DHCWebD_GetObjValue('getryqk');
	var tmp2 = cspRunServerMethod(encmeth, p1);
	admqkidobj.value = tmp2;
	usernameobj.value = gusername;
	//AdmTimesobj.readOnly = true;
	digtypeobj.value = t['HXEY04'];
	var encmeth = DHCWebD_GetObjValue('getdigtypeid');
	var tmp3 = cspRunServerMethod(encmeth, '', '', t['HXEY04']);
	if (tmp3 != "") {
		var tmp3str = tmp3.split("^");
		digtypeobj.value = tmp3str[1];
		digtypeidobj.value = tmp3str[0];
	}
	var RefDocListdrobj = document.getElementById('RefDocListdr');
	var RefDocListobj = document.getElementById('RefDocList');
	RefDocListdrobj.value = "";
	RefDocListobj.value = "";
	elementformat1();
	//设置默认的费别
	GetDefAdmReason();
	//设置默认的国籍、民族、省市（建卡设置的默认值）
	GetDefPatOtherInfo();
	//+2017-08-21 ZhYW 护士站办理入院登记时,默认科室跟病区. 此处先不考虑
	SetDefDeptAndWard();
}

function UPDiagnos_click() {
	if ((admidobj.value == "") || (admidobj.value == " ")) {
		alert("请选择就诊记录!!");
		return;
	}
	var Diagnosobj = document.getElementById('Diagnos');
	var Diagnosdescobj = document.getElementById('Diagnosdesc');
	var Diagnosidobj = document.getElementById('Diagnosid');
	var DiagnosTypeobj = document.getElementById('DiagnosType');
	var DiagnosTypeidobj = document.getElementById('DiagnosTypeid');
	var Diagnos = Diagnosobj.value;
	var Diagnosdesc = Diagnosdescobj.value;
	var Diagnosid = Diagnosidobj.value;
	var DiagnosType = DiagnosTypeobj.value;
	var DiagnosTypeid = DiagnosTypeidobj.value;
	if ((Diagnosid == "") || (Diagnosid == " ")) {
		Diagnosid = "";
	}
	if (((Diagnos == "") || (Diagnos == " ")) & (Diagnosid != "")) {
		Diagnos = "";
		Diagnosid = "";
		Diagnosidobj.value = "";
		alert("诊断不能为空!!")
		return;
	}
	if ((DiagnosType == "") || (DiagnosType == " ")) {
		DiagnosType = "";
		alert("诊断类型不能为空!!");
		return;
	}
	if ((DiagnosTypeid == "") || (DiagnosTypeid == " ")) {
		DiagnosTypeid = "";
		alert("诊断类型不能为空!!");
		return;
	}
	if (Diagnosdesc == " ") {
		Diagnosdesc = "";
	}
	var DiagInfo = DiagnosType + "^" + DiagnosTypeid + "^" + Diagnos + "^" + Diagnosid + "^" + Diagnosdesc + "^" + Guser + "^" + admidobj.value;
	var DiagRetCode = tkMakeServerCall("web.UDHCJFIPReg", "UpDiagnos", DiagInfo);
	if (DiagRetCode == "DiagNull") {
		alert("诊断信息不能为空!!");
	} else if (DiagRetCode == "AdmNull") {
		alert("就诊信息不能为空!!");
	} else if (DiagRetCode == "AdmDisch") {
		alert("患者已经出院不能修改诊断!!");
	} else if (DiagRetCode == "DiagnosTypeNull") {
		alert("诊断类型为空不能修改诊断!!");
	} else if (DiagRetCode == "DiagnosNull") {
		alert("诊断代码为空不能修改诊断!!");
	} else if (DiagRetCode == "GuserNull") {
		alert("操作员为空不能修改诊断!!");
	} else if (DiagRetCode == "MoreDiag") {
		alert("医生已下诊断不能修改诊断!!");
	} else if (DiagRetCode == "DiagnosTypeErr") {
		alert("诊断类型与初始录入的不一致不能修改诊断!!");
	} else if (DiagRetCode == "NoModify") {
		alert("诊断没有变更.");
	} else if (DiagRetCode == "0") {
		alert("诊断修改成功!!");
		getpatinfo1();
	} else {
		alert("诊断修改失败");
	}
}

//取消医保登记
function CancelInsuAdm_click() {
	var ReaInfo = tkMakeServerCall("web.UDHCJFORDCHK", "GetAdmReaInfo", admidobj.value);
	var ReaInfo1 = ReaInfo.split("^");
	var AdmReasonNationCode = ReaInfo1[1];
	var AdmReasonId = ReaInfo1[0];
	if ((AdmReasonNationCode != "") && (AdmReasonNationCode > 0)) {
		var rtn = InsuIPRegStrike(0, Guser, admidobj.value, "", admreaidobj.value, "");
		if (rtn == 0) {
			alert("取消医保登记成功.");
		}
	} else {
		alert("非医保病人,不允许取消医保登记.");
	}
}

function IsDate(mystring) {
	var reg = /^(\d{4})-(\d{2})-(\d{2})$/;
	var str = mystring;
	var arr = reg.exec(str);
	if (str == "") {
		return true;
	}
	if (!reg.test(str) && RegExp.$2 <= 12 && RegExp.$3 <= 31) {
		var obj = document.getElementById("birthdate");
		obj.className = 'clsInvalid';
		websys_setfocus("birthdate");
		alert("请输入正确日期");
		return false;
	}
	return true;
}

/*
function check(date){
	return (new Date(date).getDate()==date.substring(date.length-2));
}
*/

///mdofiy 2014-11-19 增加判断病人姓名、性别、出生日期一致时给予提示;身份证作为唯一索引查找是否有病人信息
function CheckAlreadyPAPER() {
	//mdofiy 2013-3-15 增加判断病人姓名、性别、出生日期、身份证一致时给予提示
	if (papmiidobj.value == "") {
		if (paperidobj.value == "") {
			if ((papnameobj.value == "") || (sexidobj.value == "") || (birthdateobj.value == "")) {
				return false;
			}
		}
		//判断出生日期格式是否合法  add zhli 17.12.1
		var dobstr=tkMakeServerCall("web.UDHCJFIPReg","CheckDateIsLegality",birthdateobj.value);
		if(dobstr=="DateErr"){
			alert("维护的出生日期不正确");
			return;
		}
		var PatInfo = papnameobj.value + "^" + sexidobj.value + "^" + birthdateobj.value + "^" + paperidobj.value + "^" + InsuNoObj.value;
		var encmeth = DHCWebD_GetObjValue('CheckPatNum');
		var PAPERNum = cspRunServerMethod(encmeth, PatInfo);
		if (PAPERNum == "") {
			PAPERNum = 0;
		}
		if (isNaN(PAPERNum)) {
			PAPERNum = 0;
		}
		if (PAPERNum > 0) {
			alert("系统中已有患者信息请核实!!");
			var birth = birthdateobj.value;
			/*if (birth != "") {
				var birth1 = birth.split("-");
				birth = birth1[2] + "/" + birth1[1] + "/" + birth1[0];
			}
			*/
			var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillPAPERInfo&PAPERName=" + papnameobj.value + "&PAPERNo=" + papnoobj.value + "&PAPERRowid=" + papmiidobj.value + "&Sex=" + SexObj.value + "&SexDr=" + sexidobj.value + "&PAPERID=" + paperidobj.value + "&BirthDate=" + birth + "&InsuNo=" + InsuNoObj.value;
			win = open(lnk, "UDHCJFIPReg", "scrollbars=1,top=100,left=10,width=1000,height=500");
			return true;
		} else {
			return false;
		}
	} else {
		return true;
	}
}

function gethcpinfo(str) {
	var str1 = str.split("^");
	var obj = document.getElementById("HCPDesc");
	if (obj) {
		obj.value = str1[0];
	}
	var obj = document.getElementById("HCPID");
	if (obj) {
		obj.value = str1[1];
	}
}

function enterhcp() {
	if (window.event.keyCode == 13) {
		window.event.keyCode = 117;
		var e = event ? event : (window.event ? window.event : null);
		e.isLookup = true;
		HCPDesc_lookuphandler(e);
		DHCWeb_Nextfocus();
	}
}

///验证查找有效的住院证信息
function CheckBookMesage() {
	var IPBookObj = document.getElementById('IPBook');
	var p1 = papnoobj.value;
	var p2 = medicareobj.value;
	if (IPBookObj) {
		BookID = IPBookObj.value;
		var PAPMIID = tkMakeServerCall("web.UDHCJFIPReg", "GetPapmiId", p1, p2);
		var IPBookPapmiDr = tkMakeServerCall("web.UDHCJFIPReg", "GetPatIDByIPBookID", BookID);
		if ((IPBookPapmiDr != PAPMIID) & (IPBookPapmiDr != "") & (BookID != "")) {
			var IPBookObj = document.getElementById("IPBook");
			IPBookObj.value = "",
			BookID = "";
			return;          //处理前一个病人得到住院证信息后不办理入院，新病人入院会使用到上一个病人的住院证的问题
		}
		if (BookID != "") {
			return;
		}
		if (PAPMIID != "") {
			var AdmitAdmnum = tkMakeServerCall("web.UDHCJFIPReg", "GetAdmFlag", PAPMIID);
			if (AdmitAdmnum > 0) {
				return;
			}
			//在院不再查询住院证
			var RtnStr = tkMakeServerCall("web.DHCDocIPBookingCtl", "GetIPBKNum", PAPMIID);
			var RtnArry = RtnStr.split("^");
			var BookNum = RtnArry[0];
			var BookID = RtnArry[1];
			if (BookNum > 0) {
				var rtn = window.confirm("患者存在有效的住院证,是否使用住院证办理？");
				if (!rtn) {
					return;
				}
				if (BookNum == 1) {
					IPBookObj.value = BookID;
				} else if (BookNum > 1) {
					var lnk = "doc.ipbookquery.hui.csp?PatientID=" + PAPMIID + "&UDHCJFFlag=Y";
					var obj = new Object();
					obj.name = "UDHCJFFindBook";
					var Rtn = window.showModalDialog(lnk, obj, "dialogwidth:800em;dialogheight:500em;center:1");
					if ((Rtn != "") && (Rtn != "undefined") && (Rtn != undefined)) {
						IPBookObj.value = Rtn;
					}
				}
			}
		}
	}
}

//+2015-3-4 hujunbin 卡回车事件封装
function getPatByCardNo() {
	CardNoKeydownHandler();
	//+2015-3-4 hujunbin 判断住院证状态
	var IPBookObj = document.getElementById('IPBook');
	var BookID = IPBookObj.value;
	var Parobj = window.opener;
	if (BookID != "") {
		if (!Parobj) {
			SetDefAdmValue();
		}
		var IPBookStatus = tkMakeServerCall("web.DHCBillInterface", "IIsIPBook", BookID);
		if (IPBookStatus != "") {
			//这里赋空,住院证查询结束 保证在院后不再赋值默认就诊信息
			IPBookObj.value = "";
		}
	}
}

function PaperIDSexErr() {
	var Sex = GetSexByIDCard(paperidobj.value);
	if (Sex != "") {
		var encmeth = DHCWebD_GetObjValue('GetSexDr');
		SexStr = cspRunServerMethod(encmeth, Sex);
		var SexDr = SexStr.split("^")[0];
		if ((SexDr != "") & (SexDr != sexidobj.value)) {
			return "SexNotSame";
		}
	}
}

function PaperIDBirthErr() {
	var paperidlen = (paperidobj.value).length;
	if (eval(paperidlen) == 15) {
		var tmp = paperidobj.value;
		ageyear = tmp.substring(6, 8);
		agemon = tmp.substring(8, 10);
		ageday = tmp.substring(10, 12);
		agebir = "19" + ageyear + "-" + agemon + "-" + ageday;
		agebir = tkMakeServerCall("websys.Conversions", "DateHtmlToLogical", agebir);
		agebir = tkMakeServerCall("websys.Conversions", "DateLogicalToHtml", agebir);
		if (birthdateobj.value != agebir) {
			//alert(t['63']);
			//birthdateobj.value = "";
			//paperidobj.value = "";
			//ageobj.value = "";
			return "BirthDateNotSame";
		}
	} else if (eval(paperidlen) == 18) {
		var tmp = paperidobj.value;
		ageyear = tmp.substring(6, 10);
		agemon = tmp.substring(10, 12);
		ageday = tmp.substring(12, 14);
		agebir = ageyear + "-" + agemon + "-" + ageday;
		agebir = tkMakeServerCall("websys.Conversions", "DateHtmlToLogical", agebir);
		agebir = tkMakeServerCall("websys.Conversions", "DateLogicalToHtml", agebir);
		if (birthdateobj.value != agebir) {
			//alert(t['63']);
			return "BirthDateNotSame";
			//birthdateobj.value = "";
			//paperidobj.value = "";
			//ageobj.value = "";
		}
	} else {
		alert(t['62']);
		paperidobj.value = "";
		return -1;
	}
}

function GetDefPatOtherInfo() {
	var DefaultInfo = tkMakeServerCall("web.DHCBillInterface", "GetDefaultPatInfo");
	var DefaultInfo = DefaultInfo.split("^");
	var DefaultCountryDR = DefaultInfo[0];
	var DefaultCountry = DefaultInfo[1];
	var DefaultNationDR = DefaultInfo[2];
	var DefaultNation = DefaultInfo[3];
	var DefaultProvinceDR = DefaultInfo[4];
	var DefaultProvince = DefaultInfo[5];
	var DefaultCityDR = DefaultInfo[6];
	var DefaultCity = DefaultInfo[7];
	if (countryidobj.value == "") {
		countryidobj.value = DefaultCountryDR;
	}
	if (countryobj.value == "") {
		countryobj.value = DefaultCountry;
	}
	if (countryobj.value == "") {
		nationidobj.value = DefaultNationDR;
	}
	if (nationdescobj.value == "") {
		nationdescobj.value = DefaultNation;
	}
	if (cityidobj.value == "") {
		cityidobj.value = DefaultCityDR;
	}
	if (cityobj.value == "") {
		cityobj.value = DefaultCity;
	}
	if (providobj.value == "") {
		providobj.value = DefaultProvinceDR;
	}
	if (provdescobj.value == "") {
		provdescobj.value = DefaultProvince;
	}
}

///验证选择的证件类型是否是"身份证"
///true:是，false：不是
function IsCredTypeID() {
	var myCredTypeId = cardtypeidobj.value;
	var rtn = tkMakeServerCall("web.UDHCJFIPReg", "GetCredTypeCode", myCredTypeId);
	var myary = rtn.split("^");
	if (myary[1] == m_IDCredTypePlate) {
		return true;
	} else {
		return false;
	}
}

/**
* Creator: ZhYW
* CreatDate: 2017-08-17
*/
function ShowPicByPatInfo(photoInfo, credID){
	var src = "";
	if (photoInfo != "") {
		var src = 'data:image/png;base64,' + photoInfo;
	} else if (credID != ""){
		var src = 'c://' + credID + '.bmp';
	}else;
	
	ShowPicBySrcNew(src, 'imgPic');
}

/**
* Creator: ZhYW
* CreatDate: 2017-08-21
*/
function SetDefDeptAndWard(){
	if (m_Adddeposit == ""){
		return;
	}
	var loginLocID = session['LOGON.CTLOCID'];
	var loginWardID = session['LOGON.WARDID'];
	if ((admdepobj.value == "") && (admdepidobj.value == "")){
		admdepidobj.value = loginLocID;
		admdepobj.value = tkMakeServerCall('web.UDHCJFIPReg', 'GetDepartmentName', loginLocID);
	}
	if ((admwardidobj.value == "") && (admwardobj.value == "")){
		admwardidobj.value = loginWardID;
		admwardobj.value = tkMakeServerCall('web.UDHCJFIPReg', 'GetWardName', loginWardID);
	}
}

/**
* Creator: ZhYW
* CreatDate: 2017-08-21
*/
function FormatDate_OnBlur() {
	var date = this.value;
	if ((date == "") || ((date.length != 8) && ((date.length != 10)))) {
		this.className = 'clsInvalid';
		alert('请输入正确日期');
		this.focus();
		this.select();
		return false;
	} else {
		this.className = 'clsvalid';
	}
	var dateFormat = tkMakeServerCall('websys.Conversions', 'DateFormat');
	if ((date.length == 8)) {
		var year = date.substring(0, 4);
		var month = date.substring(4, 6);
		var day = date.substring(6, 8);
		if (year == "") {
			year.className = 'clsInvalid';
			alert('请输入正确日期');
			this.focus();
			this.select();
			return false;
		}
		if (isNaN(year)) {
			this.className = 'clsInvalid';
			alert("请输入正确日期");
			this.focus();
			this.select();
			return false;
		}
		if (eval(year) < 1842) {
			this.className = 'clsInvalid';
			alert('请输入正确日期');
			this.focus();
			this.select();
			return false;
		}
		if (month == "") {
			this.className = 'clsInvalid';
			alert('请输入正确日期');
			this.focus();
			this.select();
			return false;
		}
		if (isNaN(month)) {
			this.className = 'clsInvalid';
			alert('请输入正确日期');
			this.focus();
			this.select();
			return false;
		}
		if (day == "") {
			this.className = 'clsInvalid';
			alert('请输入正确日期');
			this.focus();
			this.select();
			return false;
		}
		if (isNaN(day)) {
			this.className = 'clsInvalid';
			alert('请输入正确日期');
			this.focus();
			this.select();
			return false;
		}
		if (dateFormat == 3) {
			var date = year + '-' + month + '-' + day;
		} else {
			var date = day + '/' + month + '/' + year;
		}
		var rtn = tkMakeServerCall('web.UDHCJFIPReg', 'CheckDateIsLegality', date);
		if (rtn != 'Yes') {
			alert('请输入正确日期');
			this.className = 'clsInvalid';
			this.focus();
			this.select();
			return false;
		}
		this.value = date;
		return true;
	}
	if ((date.length == 10)) {
		if (dateFormat == 3) {
			var year = date.substring(0, 4);
			var month = date.substring(5, 7);
			var day = date.substring(8, 10);
		} else {
			var year = date.substring(6, 10);
			var month = date.substring(3, 5);
			var day = date.substring(0, 2);
		}
		if (year == "") {
			this.className = 'clsInvalid';
			alert('请输入正确日期');
			this.focus();
			this.select();
			return false;
		}
		if (isNaN(year)) {
			this.className = 'clsInvalid';
			alert('请输入正确日期');
			this.focus();
			this.select();
			return false;
		}
		if (eval(year) < 1842) {
			this.className = 'clsInvalid';
			alert('请输入正确日期');
			this.focus();
			this.select();
			return false;
		}
		if (month == "") {
			this.className = 'clsInvalid';
			alert('请输入正确日期');
			this.focus();
			this.select();
			return false;
		}
		if (isNaN(month)) {
			this.className = 'clsInvalid';
			alert('请输入正确日期');
			this.focus();
			this.select();
			return false;
		}
		if (day == "") {
			this.className = 'clsInvalid';
			alert('请输入正确日期');
			this.focus();
			this.select();
			return false;
		}
		if (isNaN(day)) {
			this.className = 'clsInvalid';
			alert('请输入正确日期');
			this.focus();
			this.select();
			return false;
		}
		if (dateFormat == 3) {
			var date = year + '-' + month + '-' + day;
		} else {
			var date = day + '/' + month + '/' + year;
		}
		var rtn = tkMakeServerCall('web.UDHCJFIPReg', 'CheckDateIsLegality', date);
		if (rtn != 'Yes') {
			alert('请输入正确日期');
			this.className = 'clsInvalid';
			this.focus();
			this.select();
			return false;
		}
		this.value = date;
		return true;
	}
}

/**
* Creator: ZhYW
* CreatDate: 2017-08-21
*/
function FormatDate(element) {
	var obj = document.getElementById(element);
	if (!obj) {
		return false;
	}
	var date = obj.value;
	if ((date == "") || ((date.length != 8) && ((date.length != 10)))) {
		obj.className = 'clsInvalid';
		alert('请输入正确日期');
		websys_setfocus(element);
		return websys_cancel();
	} else {
		obj.className = 'clsvalid';
	}
	var dateFormat = tkMakeServerCall('websys.Conversions', 'DateFormat');
	if ((date.length == 8)) {
		var year = date.substring(0, 4);
		var month = date.substring(4, 6);
		var day = date.substring(6, 8);
		if (year == "") {
			year.className = 'clsInvalid';
			alert('请输入正确日期');
			websys_setfocus(element);
			return websys_cancel();
		}
		if (isNaN(year)) {
			obj.className = 'clsInvalid';
			alert("请输入正确日期");
			websys_setfocus(element);
			return websys_cancel();
		}
		if (eval(year) < 1842) {
			obj.className = 'clsInvalid';
			alert('请输入正确日期');
			websys_setfocus(element);
			return websys_cancel();
		}
		if (month == "") {
			obj.className = 'clsInvalid';
			alert('请输入正确日期');
			websys_setfocus(element);
			return false;
		}
		if (isNaN(month)) {
			obj.className = 'clsInvalid';
			alert('请输入正确日期');
			websys_setfocus(element);
			return websys_cancel();
		}
		if (day == "") {
			obj.className = 'clsInvalid';
			alert('请输入正确日期');
			websys_setfocus(element);
			return websys_cancel();
		}
		if (isNaN(day)) {
			obj.className = 'clsInvalid';
			alert('请输入正确日期');
			websys_setfocus(element);
			return websys_cancel();
		}
		if (dateFormat == 3) {
			var date = year + '-' + month + '-' + day;
		} else {
			var date = day + '/' + month + '/' + year;
		}
		var rtn = tkMakeServerCall('web.UDHCJFIPReg', 'CheckDateIsLegality', date);
		if (rtn != 'Yes') {
			alert('请输入正确日期');
			obj.className = 'clsInvalid';
			websys_setfocus(element);
			return websys_cancel();
		}
		DHCWebD_SetObjValueA(element, date);
		return true;
	}
	if ((date.length == 10)) {
		if (dateFormat == 3) {
			var year = date.substring(0, 4);
			var month = date.substring(5, 7);
			var day = date.substring(8, 10);
		} else {
			var year = date.substring(6, 10);
			var month = date.substring(3, 5);
			var day = date.substring(0, 2);
		}
		if (year == "") {
			obj.className = 'clsInvalid';
			alert('请输入正确日期');
			websys_setfocus(element);
			return websys_cancel();
		}
		if (isNaN(year)) {
			obj.className = 'clsInvalid';
			alert('请输入正确日期');
			websys_setfocus(element);
			return websys_cancel();
		}
		if (eval(year) < 1842) {
			obj.className = 'clsInvalid';
			alert('请输入正确日期');
			websys_setfocus(element);
			return websys_cancel();
		}
		if (month == "") {
			obj.className = 'clsInvalid';
			alert('请输入正确日期');
			websys_setfocus(element);
			return websys_cancel();
		}
		if (isNaN(month)) {
			obj.className = 'clsInvalid';
			alert('请输入正确日期');
			websys_setfocus(element);
			return websys_cancel();
		}
		if (day == "") {
			obj.className = 'clsInvalid';
			alert('请输入正确日期');
			websys_setfocus(element);
			return websys_cancel();
		}
		if (isNaN(day)) {
			obj.className = 'clsInvalid';
			alert('请输入正确日期');
			websys_setfocus(element);
			return websys_cancel();
		}
		if (dateFormat == 3) {
			var date = year + '-' + month + '-' + day;
		} else {
			var date = day + '/' + month + '/' + year;
		}
		var rtn = tkMakeServerCall('web.UDHCJFIPReg', 'CheckDateIsLegality', date);
		if (rtn != 'Yes') {
			alert('请输入正确日期');
			obj.className = 'clsInvalid';
			websys_setfocus(element);
			return websys_cancel();
		}
		DHCWebD_SetObjValueA(element, date);
		return true;
	}
}

/**
* 获取邮政编码
*/
function GetZipInfo(provinceDR, cityDR, cityAreaDR, itemName) {
	var tabName = "CTZIP";
	var queryInfo = provinceDR + "^" + cityDR + "^" + cityAreaDR;
	var myBaseData = GetListData(tabName, queryInfo);
	if (myBaseData.split("$c(2)").length > 1) {
		var myCode = myBaseData.split("$c(2)")[1];
		DHCWebD_SetObjValueB(itemName, myCode);
	}
}

function GetListData(tabName, queryInfo) {
	var myBData = "";
	var encmeth = DHCWebD_GetObjValue("ReadCTBaseEncrypt");
	if (encmeth != "") {
		myBData = cspRunServerMethod(encmeth, tabName, queryInfo);
	}
	return myBData;
}

/**
* 验证必填信息
* @author ZhYW
*/
function checkRequiredElements() {
	//性别验证
	if (!validate('CT_Sex', 'CTSEX_RowId', websys_$V('sexid'), 'CTSEX_Desc', 'sex')) {
		return false;
	}
	//国籍验证
	if (!validate('CT_Country', 'CTCOU_RowId', websys_$V('Countryid'), 'CTCOU_Desc', 'Country')) {
		return false;
	}
	//患者类型验证
	if (!validate('PAC_AdmReason', 'REA_RowId', websys_$V('admreasonid'), 'REA_Desc', 'admreason')) {
		return false;
	}
	//科室验证
	if (!validate('CT_Loc', 'CTLOC_RowID', websys_$V('admdepid'), 'CTLOC_Desc', 'admdep')) {
		return false;
	}
	//病区验证
	if (!validate('PAC_Ward', 'WARD_RowID', websys_$V('admwardid'), 'WARD_Desc', 'admward')) {
		return false;
	}
	return true;
}

/**
* 验证元素值是否合法
* @author ZhYW
* @param {String} tabName 表名
* @param {String} idCol Id列名
* @param {String} idCol Id列名
* @param {Integer} idVal Id值
* @param {Integer} descCol 描述列名
* @param {Integer} element 表单元素名
* @return {Boolean} 
*/
function validate(tabName, idCol, idVal, descCol, element) {
	var obj = websys_$(element);
	if (idVal == '') {
		websys_addClass(obj, 'clsInvalid');
		return false;
	}
	if (getDescById(tabName, idCol, idVal, descCol) != websys_trim(obj.value)) {
		websys_addClass(obj, 'clsInvalid');
		return false;
	}
	websys_removeClass(obj, 'clsInvalid');
	return true;
}

function getDescById(tabName, idCol, idVal, descCol) {
	return websys_trim(tkMakeServerCall("web.DHCBillCommon", "GetDescById", tabName, idCol, idVal, descCol));
}

document.body.onload = BodyLoadHandler;
