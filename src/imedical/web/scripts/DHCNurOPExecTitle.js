var admType, disFlag, disRefresh, disReturn, disLab, disSkinTest;
var preRegNo = "",
	disFlag, tableRows = 1,
	curAdmId, curPapmiId;
var EpisodeID = document.getElementById("EpisodeID").value; //ypz 060726
var regNoLength = 8;
var fullFlag = 0;
var objGetPatConfig = document.getElementById("GetPatConfig");
if (objGetPatConfig) {
	var patConfig = cspRunServerMethod(objGetPatConfig.value);
	var tmpList = patConfig.split("^");
	if (tmpList[0] > 8) regNoLength = tmpList[0];
}

function BodyLoadHandler() {
	var objRegNo = document.getElementById("regNo");
	if (objRegNo) {
		objRegNo.onkeydown = RegNoKeyDown; //objRegNo.onblur=RegNoBlur;
		if (EpisodeID != "") {
			var getRegNoFromAdm = document.getElementById("getRegNoFromAdm").value;
			var retStr = cspRunServerMethod(getRegNoFromAdm, EpisodeID);
			if (retStr != "") {
				objRegNo.value = retStr;
				preRegNo = retStr
			} else {
				document.getElementById("EpisodeID").value = "";
				EpisodeID = ""
			}


		}
	}
	disFlag = 0;
	disRefresh = 0;
	disReturn = 0, disLab = 0, disSkinTest = 0;
	var objSearch = document.getElementById("SearCH");
	if (objSearch) {
		objSearch.onclick = SearchClick;
	}
	admType = document.getElementById("admType").value;
	var clearScreenObj = document.getElementById("clearScreen");
	if (clearScreenObj) {
		clearScreenObj.onclick = ClearScreen;
	}
	var today = document.getElementById("getToday").value; //ypz 061123
	var stdate = document.getElementById("startDate");
	if (stdate) {
		if (stdate.value == "") {
			stdate.value = today;
		} //ypz 061123
		stdate.onblur = Adjust_EDate;
		stdate.onchange = Adjust_EDate
	}
	var edate = document.getElementById("endDate");
	if (edate) {
		if (edate.value == "") {
			edate.value = today;
		} //ypz 061123
		edate.onblur = Adjust_SDate;
		edate.onchange = Adjust_SDate;
	}
	/*var GetDate=document.getElementById("GetDate").value;
	var rets=cspRunServerMethod(GetDate);
	var tem=rets.split("^");
	stdate.value=tem[0];
	edate.value=tem[1];*/
	var readcard = document.getElementById("readcard");
	if (readcard) {
		readcard.onclick = FunReadCard;
	}
	var readcard = document.getElementById("ReadCardAppend");
	if (readcard) {
		readcard.onclick = FunReadCardApp;
	}
	var arrangSeat=document.getElementById("arrangSeat");
	if(arrangSeat){
		arrangSeat.onclick=arrangSeatClick;
	}
	var GetUserGroupAccess = document.getElementById("GetUserGroupAccess").value;
	var userId = session['LOGON.USERID'];
	var usr = document.getElementById("userId");
	if (usr) usr.value = userId;
	var userGroupId = session['LOGON.GROUPID'] //ypz
	var objUserGroup = document.getElementById("userGroupId");
	if (objUserGroup) objUserGroup.value = userGroupId;
	var locID=session['LOGON.CTLOCID'];
	var retStr = cspRunServerMethod(GetUserGroupAccess, userGroupId, userId,"oldSheet","",locID);
	var tem = retStr.split("!");
	var temp = tem[1].split("|"); 
	var objBtnCheckOut = document.getElementById("BtnCheckOut");
	if (objBtnCheckOut) {
		objBtnCheckOut.onclick = CheckOutClick;
		objBtnCheckOut.style.visibility = "hidden";
		objBtnCheckOut.disabled = false;
	}
	if (tem[1] != "") {
		var objGetTypeName = document.getElementById("GetTypeName");
		if (objGetTypeName) {
			var retTypeName = cspRunServerMethod(objGetTypeName.value, temp[0]);
		}
		var objReportType = document.getElementById("ReportList");
		objReportType.value = retTypeName
		var objHospitalRowId = document.getElementById("HospitalRowId");
		objHospitalRowId.value = temp[0].split("@")[0];
		var obj = document.getElementById('queryTypeCode');
		obj.value = temp[0].split("@")[1];
		changeDisplay();
		//if (obj.value=="JYDO") objBtnCheckOut.style.visibility ="visible";
	}
	if (admType == "I") {
		var GetUserWardId = document.getElementById("GetUserWardId").value;
		var wardstr = cspRunServerMethod(GetUserWardId, userId);
		if (wardstr != "") {
			getwardid(wardstr);
		}
	}

	var objPlanPriceNew = document.getElementById("PlanPriceNew");
	if (objPlanPriceNew) {
		objPlanPriceNew.onclick = ReLoadOPFootNew;
	}

	if (EpisodeID != "") {
		Search(true);
	}
	//DHCP_GetXMLConfig("InvPrintEncrypt","AHHFOPCCardPayPrt");
	var obj = document.getElementById('ReadCard');
	if (obj) obj.onclick = ReadCard_Click;
	var obj = document.getElementById("CardNo");
	if (obj) {
		if (obj.type != "Hiden") {
			obj.onkeydown = CardNo_KeyDown;
		}
	}

	loadCardType();
	CardTypeDefine_OnChange();
	var myobj = document.getElementById('CardTypeDefine');
	if (myobj) {
		myobj.onchange = CardTypeDefine_OnChange;
		myobj.size = 1;
		myobj.multiple = false;
	}
	var obj = document.getElementById("btnShowDetail");
	if (obj) {
		if (fullFlag == 1) {

			var textnode = document.createTextNode(t['val:cancelshowdetail']);
			obj.replaceChild(textnode, obj.childNodes[1]);
			if (parent.NurOPFrame) parent.NurOPFrame.rows = "26%,*,37%";
		}
		obj.onclick = SetFrame;
	}
	GetPatOrderButton(1);
	Search(true);
}

function arrangSeatClick()
{
	var lnk = "dhcnursyroomseatmap.csp";//"dhcem.patientseat.csp";
	//window.open(lnk, "座位图", "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=500,width=500,top=-100,left=100");
	//var tmp=window.open(lnk,"座位图","_blank","top=0,left=0");
    websys_createWindow(lnk,"座位图","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes,height=63%,width=83%");
    //tmp.resizeTo(screen.width,screen.height);
    //tmp.moveTo(0,0);
    //tmp.focus();
	//dhcem.patientseat.csp
}

function SetFrame() {
	if (!parent.NurOPFrame) return;
	var objbtnShowDetail = document.getElementById("btnShowDetail");
	if (fullFlag == 0) {
		parent.NurOPFrame.rows = "26%,*,37%";
		fullFlag = 1;
		if (objbtnShowDetail) {
			var textnode = document.createTextNode(t['val:cancelshowdetail']);
			objbtnShowDetail.replaceChild(textnode, objbtnShowDetail.childNodes[1]);
		}
	} else {
		parent.NurOPFrame.rows = "26%,*,0%";
		fullFlag = 0;
		if (objbtnShowDetail) {
			var textnode = document.createTextNode(t['val:showdetail']);
			objbtnShowDetail.replaceChild(textnode, objbtnShowDetail.childNodes[1]);
		}
	}
	return;
}

function ReLoadOPFootNew() {
	var curregno = document.getElementById("regNo").value;
	if (curregno == "") {
		alert("请选择登记号!");
		return false;
	}
	//alert(curregno)
	var curCardNo = document.getElementById("CardNo").value;
	//alert(curCardNo)
	var lnk = "udhcopbillif.csp?PatientIDNo=" + curregno + "&CardNo=" + curCardNo;
	var NewWin = open(lnk, "udhcopbillif", "scrollbars=no,resizable=no,top=6,left=6,width=1000,height=680");
}

function DateDemo() {
	var d, s = "";
	d = new Date();
	s += d.getDate() + "/";
	s += (d.getMonth() + 1) + "/";
	s += d.getYear();
	return (s);
}

function SearchClick() {
	RegNoBlur(true);
	//Search(true);
	//GetListOrd()
}

function Search(searchFlag) {
	document.getElementById("EpisodeID").value = "";
	EpisodeID = "";
	var wardId = document.getElementById("wardId").value;
	var regNo = document.getElementById("regNo").value;
	if (regNo != "") BasPatinfo(regNo);
	if (EpisodeID != "") regNo = regNo + "^" + EpisodeID //ypz 060728
	var locId = document.getElementById("locId").value;
	var queryTypeCode = document.getElementById("queryTypeCode").value;
	var HospitalRowId = document.getElementById("HospitalRowId").value;
	//if ((admType=="I")&&(wardId=="")&&(regNo=="")) {alert(t['alert:SelLocOrRegNo']);return false;};//should fill loc or regno 
	var stdate = document.getElementById("startDate").value;
	var edate = document.getElementById("endDate").value;
	/*if (!IsValidDate(document.getElementById("startDate"))||(stdate=="")){
		alert("开始日期不正确");
		return;
	}
	if (!IsValidDate(document.getElementById("endDate"))||(edate=="")){
		alert("结束日期不正确");
		return;
	}*/
	if (searchFlag) {
		if ((admType != "O") && (locId == "") && (regNo == "") && (stdate != edate)) {
			alert(t['alert:SelLocOrRegNo']);
			return false;
		}; //should fill loc or regno
		if (queryTypeCode == "") {
			alert(t['alert:selType']);
			return false;
		} //sel type first
	}
	//var reportType=document.getElementById("ReportList").value;
	var wardDesc = document.getElementById("PacWard").value;
	var Dept = document.getElementById("Dept").value;
	var ExeCheck = document.getElementById("exeFlag").checked;
	//var objBtnCheckOut=document.getElementById("BtnCheckOut");
	//if (queryTypeCode=="JYDO") objBtnCheckOut.style.visibility ="visible";
	//else objBtnCheckOut.style.visibility ="hidden";
	var exeFlag;
	var gap = "";
	if (ExeCheck == false) {
		exeFlag = 0;
	} else {
		exeFlag = 1;
	}
	if (Dept == "") {
		locId = "";
	}
	if (queryTypeCode == "") return;
	var userId = session['LOGON.USERID'];
	//if (locId=="")
	//{
	//    //locId=session['LOGON.CTLOCID'];
	//    //document.getElementById("locId").value=locId;
	//}
	//alert("&wardId="+wardId+"&regNo="+regNo+"&userId="+userId+"&startDate="+stdate+"&endDate="+edate+"&queryTypeCode="+queryTypeCode+"&gap="+gap+"&warddes="+wardDesc+"&locId="+locId+"&admType="+admType+"&exeFlag="+exeFlag)
	var HOSPID = session['LOGON.HOSPID'];
	var flowFlag=document.getElementById("flowFlag")
	if ((queryTypeCode == "SYDO")&&(flowFlag)&&(flowFlag.value==="1")) { // 门诊输液单走csp

		var lnk = "dhcnuropexectable.csp" + "?wardId=" + wardId + "&regNo=" + regNo + "&userId=" + userId + "&startDate=" + stdate + "&endDate=" + edate + "&queryTypeCode=" + queryTypeCode + "&gap=" + gap + "&warddes=" + wardDesc + "&locId=" + locId + "&admType=" + admType + "&exeFlag=" + exeFlag + "&disFlag=" + disFlag + "&HospitalRowId=" + HospitalRowId + "&HOSPID=" + HOSPID   //+ "&startTime=" + startTime + "&endTime=" + endTime + "&searchFlag=" + searchFlag;
	} else {
		var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNUROPEXEC" + "&wardId=" + wardId + "&regNo=" + regNo + "&userId=" + userId + "&startDate=" + stdate + "&endDate=" + edate + "&queryTypeCode=" + queryTypeCode + "&gap=" + gap + "&warddes=" + wardDesc + "&locId=" + locId + "&admType=" + admType + "&exeFlag=" + exeFlag + "&disFlag=" + disFlag + "&HospitalRowId=" + HospitalRowId + "&HOSPID=" + HOSPID//+ "&startTime=" + startTime + "&endTime=" + endTime;

	}
	//var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNUROPEXEC" + "&wardId=" + wardId + "&regNo=" + regNo + "&userId=" + userId + "&startDate=" + stdate + "&endDate=" + edate + "&queryTypeCode=" + queryTypeCode + "&gap=" + gap + "&warddes=" + wardDesc + "&locId=" + locId + "&admType=" + admType + "&exeFlag=" + exeFlag + "&disFlag=" + disFlag + "&HospitalRowId=" + HospitalRowId;
	parent.frames['OrdList'].location.href = lnk;

	//ypz 081029 begin
	var reportType = document.getElementById("ReportList").value;
	parent.frames['OrdAttach'].location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPExecAttach" + "&wardId=-1&regNo=" + regNo + "&userId=" + userId + "&startDate=" + stdate + "&endDate=" + edate + "&queryTypeCode=" + queryTypeCode + "&admType=" + admType + "&exeFlag=" + ExeCheck + "&ReportType=" + reportType;
	//ypz 081029 end
}

function ExecuteClick() {
	var objtbl = document.getElementById('tDHCNurOPExec');
	var rowid;
	rowid = "";
	for (i = 1; i < objtbl.rows.length; i++) {
		//	   var eSrc=objtbl.rows[i];
		//	   var RowObj=getRow(eSrc);
		var item = document.getElementById("seleitemz" + i);
		if (item.checked == true) {
			var basedose = document.getElementById("doseQtyUnitz" + i).innerText;
			var oeoriId = document.getElementById("oeoriIdz" + i).innerText;
			var arcicId = ""; //ypz 061113//document.getElementById("arcicIdz"+i).innerText;
			rowid = rowid + "^" + basedose + "!" + oeoriId + "!" + arcicId + "!" + i;
		}
	}
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCORDEXCUTE" + "&AAA=1&BBB=" + rowid;
	window.open(lnk, t["val:title"], "toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,height=300,width=300,top=-100,left=300");
}

function SearchClickOld() {
	var method = document.getElementById("schord");
	var wardno = document.getElementById("wardId").value;
	var regno = document.getElementById("regNo").value;
	var userId = session['LOGON.USERID'];
	var mthallpatient = document.getElementById("getallpatient");
	if (method) {
		var encmeth = method.value
	} else {
		var encmeth = ''
	};
	if (cspRunServerMethod(encmeth, '', '', wardno, regno, userId) == '0') {}
	if (mthallpatient) {
		var encmeth = mthallpatient.value
	} else {
		var encmeth = ''
	};
	if (cspRunServerMethod(encmeth, 'getallord', '', userId) == '0') {}
}

function getloc(str) {
	var loc = str.split("^");
	var obj = document.getElementById("locId");
	obj.value = loc[1];
}

function getwardid(str) {
	var obj = document.getElementById('wardId');
	var tem = str.split("^");
	obj.value = tem[1];
	var obj = document.getElementById('PacWard');
	obj.value = tem[0];
	return;
}

function savetyp(str) {
	var objHospitalRowId = document.getElementById("HospitalRowId");
	var obj = document.getElementById('queryTypeCode');
	var tem = str.split("^");
	obj.value = tem[1].split("@")[1];
	objHospitalRowId.value = tem[1].split("@")[0];
	changeDisplay();
	Search(false);
}

function RegNoKeyDown() {
	if ((event.keyCode == 13) || (event.keyCode == 9)) {
		RegNoBlur(false)
	};
}

function RegNoBlur(queryFlag) {
	var i;
	var objRegNo = document.getElementById("regNo");
	websys_setfocus("Dept"); //startDate
	if ((objRegNo.value == preRegNo) && (queryFlag == false)) return; //ypz 061112
	var obj = document.getElementById("patMainInfo");
	obj.value = ""
	var isEmpty = (objRegNo.value == "");
	var oldLen = objRegNo.value.length;

	if (!isEmpty) { //add 0 before regno
		for (i = 0; i < regNoLength - oldLen; i++) //for (i=0;i<8-oldLen;i++)
		{
			objRegNo.value = "0" + objRegNo.value
		}
	}

	preRegNo = objRegNo.value;

	disFlag = 0;
	//BasPatinfo(objRegNo.value);
	document.getElementById("CardNo").value="";  //??2010-10-18
	var objBtnCheckOut = document.getElementById("BtnCheckOut"); //ypz 061122
	if (objBtnCheckOut) objBtnCheckOut.style.visibility = "hidden";
	document.getElementById("EpisodeID").value = "";
	EpisodeID = "";
	if (queryFlag == false) GetPatOrderButton(1);

	Search(true);
	//GetListOrd()
}

function FunReadCard() {

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
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			document.getElementById("EpisodeID").value = "";
			EpisodeID = "";
			var obj = document.getElementById("regNo");
			obj.value = myary[5];
			var obj = document.getElementById("CardNo");
			obj.value = myary[1];

			if (myary[5] != "") {
				BasPatinfo(myary[5]);
				if (document.getElementById("queryTypeCode").value.indexOf("JYDO") > -1) {
					var objBtnCheckOut = document.getElementById("BtnCheckOut");
					if (objBtnCheckOut) {
						objBtnCheckOut.onclick = CheckOutClick;
						objBtnCheckOut.style.visibility = "visible";
						objBtnCheckOut.disabled = false;
					}
				}
				ReLoadOPFoot("Bill", "", ""); //only read pat base info,no fee
				disFlag = 0;
			}
			break;
		case "-200":
			alert(t["alert:cardinvalid"]);
			break;
		case "-201":
			alert(t["alert:cardvaliderr"]);
		default:
	}
	//GetListOrd()
}

function GetListOrd() {
	curAdmId = "", curPapmiId = "";
	var Objtbl = parent.frames["OrdList"].document.getElementById('tDHCNurOPExec');
	if(Objtbl){
		tableRows = Objtbl.rows.length;
	}else{
		tableRows = 0;
	}
	if (tableRows < 2) return true;
	var oeoriIdExt, curOrdId
	oeoriIdExt = parent.frames["OrdList"].document.getElementById("oeoriIdz" + 1).innerText;
	var tmpList = oeoriIdExt.split("||");
	curOrdId = tmpList[0];
	var multiOrder = false,
		checkCount = 0,
		selOrder = 0;
	for (var i = 1; i < tableRows; i++) { //multi Adm,select one
		oeoriIdExt = parent.frames["OrdList"].document.getElementById("oeoriIdz" + i).innerText;
		tmpList = oeoriIdExt.split("||");
		if (curOrdId != tmpList[0]) {
			multiOrder = true;
		}
		check = parent.frames["OrdList"].document.getElementById('seleitemz' + i);
		if (check.checked == true) {
			checkCount = checkCount + 1;
			curOrdId = tmpList[0];
		}
	}
	if ((multiOrder == true) && (checkCount != 1)) {
		alert(t['alert:multiOrder']);
		return false;
	}
	var GetAdmIdPapmiId = document.getElementById("GetAdmIdPapmiId").value;
	var retStr = cspRunServerMethod(GetAdmIdPapmiId, curOrdId);
	if (retStr != "") {
		var tmpList = retStr.split("^");
		curAdmId = tmpList[0];
		curPapmiId = tmpList[1];
	}
	return true;
}

function FunReadCardApp() {
	if (GetListOrd() != true) {
		return;
	}
	//alert(document.getElementById("CardNo").value+"/"+curAdmId+"/"+curPapmiId+"/"+tableRows);

	if (tableRows < 2) {
		////alert(t['alert:noNeed']);
		ReLoadOPFoot("App", "", "");
		return;
	}
	var regNo = document.getElementById("regNo").value;
	var cardNo = document.getElementById("CardNo").value;
	if ((curAdmId != "") && (curPapmiId != "") && (cardNo != "") && (regNo.length > 7)) {
		ReLoadOPFoot("Enter", curAdmId, curPapmiId);
		return;
	}
	alert(t['alert:readCard']); //never read card
	var myrtn = DHCACC_GetAccInfo();
	//alert(myrtn);
	var myary = myrtn.split("^");
	var rtn = myary[0];
	switch (rtn) {
		case "0":
			///rtn +"^"+myCardNo+"^" + myCheckNo +"^"+myLeftM+"^"+myPAPMI+"^"+myPAPMNo;
			var obj = document.getElementById("regNo");
			obj.value = myary[5];
			var obj = document.getElementById("CardNo");
			obj.value = myary[1];
			if (myary[5] != "") {
				BasPatinfo(myary[5]);
				ReLoadOPFoot("App", "", "");
			}
			break;
		case "-200":
			alert(t["alert:cardinvalid"]);
			break;
		case "-201":
			alert(t["alert:cardvaliderr"]);
		default:
	}
}

function ReLoadOPFoot(ParCallType, admId, papmiId) {
	var RegNo = document.getElementById("regNo").value;
	var group = session['LOGON.GROUPID'];
	//var ctloc=document.getElementById("ctloc").value;
	//var stdate=document.getElementById("CDateSt").value;
	//var enddate=document.getElementById("CDateEnd").value;
	//var pmi=document.getElementById("CPmiNo").value;
	locId = session['LOGON.CTLOCID'];
	var card = document.getElementById("CardNo").value;
	var billStatus = document.getElementById("PopStatus").value;
	var bill = cspRunServerMethod(billStatus, RegNo, group, locId);
	disFlag = 0;
	//if (((bill=="Y") && (ParCallType=="Bill")) || (ParCallType=="App"))
	if (ParCallType == "App") {
		//alert("call:"+card+"/"+admId+"/"+papmiId)
		var lnk = "udhcopbillif.csp?PatientIDNo=" + RegNo + "&CardNo=" + card;
		var NewWin = open(lnk, "udhcopbillif", "scrollbars=yes,resizable=yes,top=6,left=6,width=1000,height=680");
		disFlag = 1;
	} else if (ParCallType == "Enter") {
		//alert("call:"+card+"/"+admId+"/"+papmiId)
		var lnk = "udhcopbillforadmif.csp?CardNo=" + card + "&SelectAdmRowId=" + admId + "&SelectPatRowId=" + papmiId;
		var NewWin = open(lnk, "udhcopbillif", "scrollbars=yes,resizable=yes,top=6,left=6,width=1000,height=680");
		disFlag = 1;
	}
	GetPatOrderButton(1);
	Search(true);
}

function BasPatinfo(regNo) {
	if (regNo == "") return;
	var patinfo = document.getElementById("patinfo").value;
	var str = cspRunServerMethod(patinfo, regNo);
	var obj = document.getElementById("patMainInfo");
	obj.value = "";
	if (str == "") {
		document.getElementById("regNo").value = ""
		alert("不存在就诊信息")
		return;
	}
	var tem = str.split("^");
	//var cardNo = document.getElementById("CardNo");
	//cardNo.value = "";
	obj.value = tem[4] + "," + tem[3] + "," + tem[7] + "," + tem[25] + "," + tem[26];
	//obj=document.getElementById("PatLoc"); //ypz rem
	//obj.value=tem[1];
}

function transINVStr(myINVStr) {
	Search(true);

}

function GetDate(dateStr) {
	var tmpList = dateStr.split("/");
	if (tmpList < 3) return 0;
	return tmpList[2] * 1000 + tmpList[1] * 50 + tmpList[0];
}

function Adjust_EDate() {
	var stdate = document.getElementById("startDate");
	var edate = document.getElementById("endDate");
	//alert(stdate.value+" "+edate.value)
	if (GetDate(stdate.value) > GetDate(edate.value)) edate.value = stdate.value;
}

function Adjust_SDate() {
	var stdate = document.getElementById("startDate");
	var edate = document.getElementById("endDate");
	if (GetDate(stdate.value) > GetDate(edate.value)) stdate.value = edate.value;
}

function changeDisplay() {
	var queryTypeCode = document.getElementById('queryTypeCode').value;
	if (queryTypeCode.indexOf("JYDO") > -1) {
		//var obj=document.getElementById("cColorExec");
		//if (obj) obj.style.visibility ="hidden";
		var obj = document.getElementById("cColorTest");
		if (obj) obj.style.visibility = "hidden";
		var obj = document.getElementById("cColorLongNew");
		if (obj) obj.style.visibility = "hidden";
		var obj = document.getElementById("cColorSkinTest");
		if (obj) obj.style.visibility = "hidden";
		var obj = document.getElementById("cColorExecDiscon");
		if (obj) obj.style.visibility = "hidden";
		var obj = document.getElementById("cColorLackOfFee");
		if (obj) obj.style.visibility = "hidden";
		//var obj=document.getElementById("cColorTemp");
		//if (obj) obj.style.visibility ="hidden";
		var obj = document.getElementById("cColorDiscontinue");
		if (obj) obj.style.visibility = "hidden";
		var obj = document.getElementById("cColorImmediate");
		if (obj) obj.style.visibility = "hidden";
		//var obj=document.getElementById("cColorUnPaid");
		//if (obj) obj.style.visibility ="hidden";
	} else {
		var obj = document.getElementById("cColorExec");
		if (obj) obj.style.visibility = "visible";
		var obj = document.getElementById("cColorTempTest");
		if (obj) obj.style.visibility = "visible";
		var obj = document.getElementById("cColorLongNew");
		if (obj) obj.style.visibility = "visible";
		var obj = document.getElementById("cColorSkinTest");
		if (obj) obj.style.visibility = "visible";
		var obj = document.getElementById("cColorExecDiscon");
		if (obj) obj.style.visibility = "visible";
		var obj = document.getElementById("cColorLackOfFee");
		if (obj) obj.style.visibility = "visible";
		var obj = document.getElementById("cColorTemp");
		if (obj) obj.style.visibility = "visible";
		var obj = document.getElementById("cColorDiscontinue");
		if (obj) obj.style.visibility = "visible";
		var obj = document.getElementById("cColorImmediate");
		if (obj) obj.style.visibility = "visible";
		//var obj=document.getElementById("cColorUnPaid");
		//if (obj) obj.style.visibility ="visible";
	}
}

function ClearScreen() {
	document.getElementById("regNo").value = "";
	document.getElementById("CardNo").value = "";
	document.getElementById("patMainInfo").value = "";
	preRegNo = "";
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCNurOPExecTitle&admType="+document.getElementById("admType").value;
	parent.frames['NurseTop'].location.href = lnk;
	//Search(false);
	//DHCWeb_setfocus("ReadCard"); //websys_setfocus("regNo"); //ypz 081219 
}

function BillPrintNew(INVstr) {
	var INVtmp = INVstr.split("^");
	///
	///INVstr
	for (var invi = 0; invi < INVtmp.length; invi++) {
		if (INVtmp[invi] != "") {
			var beforeprint = document.getElementById('getSendtoPrintinfo');
			if (beforeprint) {
				var encmeth = beforeprint.value
			} else {
				var encmeth = ''
			};
			var PayMode = "3"; //card paid mode
			var Guser = session['LOGON.USERID'];
			var sUserCode = session['LOGON.USERCODE'];
			//GetInvoicePrtDetail(JSFunName As %String,InvRowID, UseID , PayMode
			var Printinfo = cspRunServerMethod(encmeth, "InvPrintNew", "AHHFOPCCardPayPrt", INVtmp[invi], sUserCode, PayMode, "");
		}
	}
}

function InvPrintNew(TxtInfo, ListInfo) {
	////
	////DHCP_PrintFun(encmeth,PObj,inpara,inlist)
	var myobj = document.getElementById("ClsBillPrint");
	DHCP_PrintFun(myobj, TxtInfo, ListInfo);
}

function CheckOutClick() {
	var objBtnCheckOut = document.getElementById("BtnCheckOut");
	if (objBtnCheckOut) {
		objBtnCheckOut.disabled = true;
		objBtnCheckOut.onclick = function() {
			return false;
		}
	}
	var accountInfo = parent.frames["OrdList"].accountInfo;
	var tmpList = accountInfo.split("!");
	if (tmpList.length < 4) {
		alert("no data");
		return;
	}
	var patPaySum = tmpList[0];
	var oeoriIdStr = tmpList[1];
	var admIdStr = tmpList[2];
	var papmiId = tmpList[3];
	if (tmpList[1].length < 4) return;
	var cardNo = document.getElementById("CardNo").value;
	if (cardNo == "") {
		alert("error");
		return;
	}
	var retStr = DHCACC_CheckMCFPay(tmpList[0], cardNo);
	tmpList = retStr.split("^");
	if (tmpList[0] == "-206") {
		alert(t['alert:errCard']);
		return;
	}
	if (tmpList[0] == "-205") {
		alert(t['alert:lackOfMoney']);
		return;
	}
	if (tmpList[0] != "0") return;
	var accManId = tmpList[1];
	var userId = session['LOGON.USERID'];
	var userGroupId = session['LOGON.GROUPID'];
	var logLocId = session['LOGON.CTLOCID'];
	var checkOut = document.getElementById("CheckOut").value;

	//alert(checkOut+"/"+papmiId+"/"+admIdStr+"/"+oeoriIdStr+"/"+patPaySum+"/"+userId+"/"+userGroupId+"/"+logLocId+"/"+accManId);
	//alert(papmiId+"/"+admIdStr+"/"+oeoriIdStr+"/"+patPaySum+"/"+userId+"/"+userGroupId+"/"+logLocId+"/"+accManId);
	//patPaySum=1;//return;
	var retStr = cspRunServerMethod(checkOut, papmiId, admIdStr, oeoriIdStr, patPaySum, userId, userGroupId, logLocId, accManId);
	tmpList = retStr.split(String.fromCharCode(2));
	if (tmpList.length > 1) {
		if (tmpList[0] == "102") {
			alert(t['alert:amtMisMatch']);
			return;
		}
		if (tmpList[0] == "105") {
			alert(t['alert:paidModeErr']);
			return;
		}
		if (tmpList[0] == "2621") {
			alert(t['alert:rowIdErr']);
			return;
		}
		if (tmpList[0] != 0) {
			alert("error return:" + tmpList[0]);
			return;
		}
		alert(t['alert:accSuccess']);
		Search(false);
		BillPrintNew(tmpList[1]);
	}
}

function ReadCard_Click() {
	var myoptval = DHCWeb_GetListBoxValue("CardTypeDefine");

	var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myoptval);
	//var myrtn=DHCACC_GetAccInfo(m_SelectCardTypeDR);

	var myary = myrtn.split("^");
	var rtn = myary[0];
	var leftmon = myary[3];
	var RegNoObj = document.getElementById('regNo');
	switch (rtn) {
		case "0": //卡有效
			var obj = document.getElementById("regNo");
			obj.value = myary[5];
			var obj = document.getElementById("CardNo");
			obj.value = myary[1];
			event.keyCode = 13;
			RegNoKeyDown(event);
			break;
		case "-200": //卡无效
			alert(t['alert:cardinvalid']);
			//websys_setfocus('regNo');  //ypz 081216
			break;
		case "-201": //卡有效,账户无效
			var obj = document.getElementById("regNo");
			obj.value = myary[5];
			event.keyCode = 13;
			RegNoKeyDown(event);
			break;
		default:
	}
	/*
	var obj=document.getElementById("CardNo");
		alert("AAA"+obj.value)
		*/
}

function loadCardType() {
	DHCWebD_ClearAllListA("CardTypeDefine");
	var encmeth = DHCWebD_GetObjValue("ReadCardTypeEncrypt");
	if (encmeth != "") {
		var rtn = cspRunServerMethod(encmeth, "DHCWeb_AddToListA", "CardTypeDefine");
	}
}

var m_CardNoLength = 0;
var m_SelectCardTypeDR = "";
var m_CCMRowID = ""

function CardTypeDefine_OnChange() {
	var myoptval = DHCWeb_GetListBoxValue("CardTypeDefine");

	var myary = myoptval.split("^");

	var myCardTypeDR = myary[0];
	m_SelectCardTypeDR = myCardTypeDR;
	m_CCMRowID = myary[14];
	if (myCardTypeDR == "") {
		return;
	}
	///Read Card Mode
	if (myary[16] == "Handle") {
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			myobj.readOnly = false;
		}
		//DHCWeb_DisBtnA("ReadCard");
	} else {
		var myobj = document.getElementById("CardNo");
		if (myobj) {
			//ypz rem081211//myobj.readOnly = true;
		}
		var obj = document.getElementById("ReadCard");
		if (obj) {
			obj.disabled = false;
			obj.onclick = ReadCard_Click;
		}
	}

	//Set Focus
	if (myary[16] == "Handle") {
		DHCWeb_setfocus("CardNo");
	} else {
		DHCWeb_setfocus("ReadCard");
	}

	m_CardNoLength = myary[17];

}

function SetCardNOLength() {
	var obj = document.getElementById('RCardNo');
	if (obj.value != '') {
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value
			}
		}
		var myCardobj = document.getElementById('CardNo');
		if (myCardobj) {
			myCardobj.value = obj.value;
		}
	}
}

function Doc_OnKeyDown() {
	if ((event.keyCode == 119)) {
		ReadCard_Click();
	}
}

function CardNo_KeyDown(e) {
	var key = websys_getKey(e);
	if ((key == 13)) {
		SetCardNOLength();
		var myCardNo = DHCWebD_GetObjValue("CardNo");
		var mySecurityNo = ""
		var myrtn = DHCACC_GetAccInfo(m_SelectCardTypeDR, myCardNo, mySecurityNo, "PatInfo");

		var myary = myrtn.split("^");

		if ((myary[0] == "0") || (myary[0] == "-201")) {
			var myPAPMNo = myary[5];
			//ypz rem 081211//var obj=document.getElementById("PatientID");
			//alert(myary)
			//ypz rem 081211//DHCWebD_SetListValueA(obj,myPAPMNo);
			//ReadPatInfo();
			var RegNoObj = document.getElementById('regNo');
			if (RegNoObj) RegNoObj.value = myPAPMNo
			document.getElementById("EpisodeID").value = "";
			EpisodeID = "";
			GetPatOrderButton(1);
			Search(true);
		} else {
			alert("无效的卡号!");
		}

	}
}

function SetCardNOLength() {
	var obj = document.getElementById('CardNo');
	if (obj.value != '') {
		if ((obj.value.length < m_CardNoLength) && (m_CardNoLength != 0)) {
			for (var i = (m_CardNoLength - obj.value.length - 1); i >= 0; i--) {
				obj.value = "0" + obj.value
			}
		}
	}
}

document.onkeydown = Doc_OnKeyDown;
document.body.onload = BodyLoadHandler;