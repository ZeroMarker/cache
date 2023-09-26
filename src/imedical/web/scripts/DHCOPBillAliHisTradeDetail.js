///DHCOPBillAliHisTradeDetail.js

var Guser, GuserCode;
var SelectedRow = "-1";

function BodyLoadHandler() {
	Guser = session['LOGON.USERID'];
	GuserCode = session["LOGON.USERCODE"];
	var Findobj = document.getElementById("Find");
	if (Findobj) {
		Findobj.onclick = Find_Click;
	}
	var ReadTradeInvobj = document.getElementById("ReadTradeInv");
	if (ReadTradeInvobj) {
		ReadTradeInvobj.onclick = TradeInv_Click;
	}
	var jobobj = document.getElementById("job");
	var job = jobobj.value;
	if ((job == "") || (job == " ")) {
		var GetCurJob = document.getElementById("GetCurJob");
		if (GetCurJob) {
			var encmeth = GetCurJob.value;
		} else {
			var encmeth = '';
		}
		job = cspRunServerMethod(encmeth);
		jobobj.value = job;
	}
}

function Find_Click() {
	var jobobj = document.getElementById("job");
	var job = jobobj.value;
	var StDate = "";
	var EndDate = "";
	var StDateobj = document.getElementById("StDate");
	if (StDateobj) {
		StDate = StDateobj.value;
	}
	var EndDateobj = document.getElementById("EndDate");
	if (EndDateobj) {
		EndDate = EndDateobj.value;
	}
	var PAPERNoobj = document.getElementById("PAPERNo");
	if (PAPERNoobj) {
		var PAPERNo = PAPERNoobj.value;
	}
	var PAPERNameobj = document.getElementById("PAPERName");
	if (PAPERNameobj) {
		var PAPERName = PAPERNameobj.value;
	}
	var CardNoobj = document.getElementById("CardNo");
	if (CardNoobj) {
		var CardNo = CardNoobj.value;
	}
	var CardBalanceobj = document.getElementById("CardBalance");
	if (CardBalanceobj) {
		var CardBalance = CardBalanceobj.value;
	}
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillAliHisTradeDetail&StDate=" + StDate;
	lnk += "&EndDate=" + EndDate + "&Guser=" + Guser + "&job=" + job + "&PAPERNo=" + PAPERNo + "&PAPERName=" + PAPERName;
	location.href = lnk;
}

function TradeInv_Click() {
	var Objtbl = document.getElementById('tDHCOPBillAliHisTradeDetail');
	var Rows = Objtbl.rows.length;
	if (Rows < 2) {
		return;
	}
	var TradeRowidobj = document.getElementById("TradeRowid");
	var TradeRowid = TradeRowidobj.value;
	if ((TradeRowid == "") || (TradeRowid == " ")) {
		alert("请选择要查询的交易");
		return;
	}
	var CheckINVDetail = document.getElementById("CheckINVDetail");
	if (CheckINVDetail) {
		var encmeth = CheckINVDetail.value;
	} else {
		var encmeth = '';
	}
	var INVDetail = cspRunServerMethod(encmeth, TradeRowid);
	if ((INVDetail == "") || (INVDetail == " ")) {
		alert("未找到相应发票信息.");
		return;
	} else if (INVDetail == "TradeNull") {
		alert("请选择要查询的交易.");
		return;
	} else {
		var INVDetail1 = INVDetail.split("^");
		var INVNum = INVDetail1[0];
		if ((INVNum == "") || (INVNum == " ")) {
			INVNum = 0;
		}
		if (isNaN(INVNum)) {
			INVNum = 0;
		}
		if (eval(INVNum) == 0) {
			alert("未找到相应发票信息.");
			return;
		} else {
			var PAPERDR = INVDetail1[1];
			var PAPERName = INVDetail1[2];
			var PAPERNo = INVDetail1[3];
			var TradeNo = INVDetail1[4];
			var BankCardNo = INVDetail1[5];
			var TradeAmt = INVDetail1[6];
			var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHCOPBillAliINVDetail&TradeRowid=" + TradeRowid + "&PAPERNo=" + PAPERNo + "&PAPERName=" + PAPERName;
			lnk = lnk + "&BankCardNo=" + BankCardNo + "&TradeAmt=" + TradeAmt + "&TradeNo=" + TradeNo;
			var NewWin = open(lnk, "DHCOPBillPOSINVDetail", "scrollbars=no,resizable=no,top=50,left=50,width=1000,height=800");
		}
	}
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var rowobj = getRow(eSrc);
	var Objtbl = document.getElementById('tDHCOPBillAliHisTradeDetail');
	var Rows = Objtbl.rows.length;
	var lastrowindex = Rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) {
		return;
	}
	var TradeRowidobj = document.getElementById("TradeRowid");
	if (selectrow != SelectedRow) {
		var SelRowObj = document.getElementById('TTradeRowidz' + selectrow);
		var TTradeRowid = SelRowObj.innerText;
		TradeRowidobj.value = TTradeRowid;
		SelectedRow = selectrow;
	} else {
		TradeRowidobj.value = "";
		SelectedRow = "-1";
	}
}

document.body.onload = BodyLoadHandler;
