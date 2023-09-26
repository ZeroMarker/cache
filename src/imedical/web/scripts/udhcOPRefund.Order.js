/// udhcOPRefund.Order.js

function BodyLoadHandler() {
	var myobj = document.getElementById("AllSelect");
	if (myobj) {
		myobj.onclick = AllSelect_OnClick;
	}
	IntDoument();
	document.onkeydown = document_OnKeyDown;
}

function AllSelect_OnClick() {
	var mycheck = DHCWebD_GetObjValue("AllSelect");
	SelectAll(mycheck);
}

function SelectAll(myCheck) {
	var myRows = DHCWeb_GetTBRows("tudhcOPRefund_Order");
	for (var i = 1; i <= myRows; i++) {
		var obj = document.getElementById('Tselectz' + i);
		if (!obj.disabled) {
			DHCWeb_SetColumnData("Tselect", i, myCheck);
		}
	}
	if (myRows > 0) {
		CalCurRefund();
	}
}

function document_OnKeyDown() {
	var e = window.event;
	parent.window.FrameShutCutKeyFrame(e);
	DHCWeb_EStopSpaceKey();

}

function tRefundOrder_Click() {
	var eSrc = window.event.srcElement;
	if (eSrc.tagName == "IMG") {
		eSrc = window.event.srcElement.parentElement;
	}
	var eSrcAry = eSrc.id.split("z");
	var rowObj = getRow(eSrc);
	if (rowObj.tagName == 'TH') {
		return;
	}
	var row = rowObj.rowIndex;
	var sExcute = DHCWeb_GetColumnData('TExcuteflag', row);
	var ExQty = DHCWeb_GetColumnData('TOrderQty', row);
	var ReturnQty = DHCWeb_GetColumnData('TReturnQty', row);
	var sSelect = document.getElementById('Tselectz' + row);
	if ((sExcute == "1") || ((ReturnQty < ExQty) && (ReturnQty != 0))) {
		sSelect.disabled = true;
	}
}

function IntDoument() {
	var tabOPList = document.getElementById('tudhcOPRefund_Order');
	var rows = tabOPList.rows.length;
	for (var row = 1; row < rows; row++) {
		var sExcute = DHCWeb_GetColumnData('TExcuteflag', row);
		var myAuditFlag = DHCWeb_GetColumnData('AuditFlag', row);
		var sSelect = document.getElementById('Tselectz' + row);
		if ((sExcute == "1")) {
			sSelect.disabled = true;
		} else {
			sSelect.disabled = false;
		}
		var myAuditCheckDis = DHCWeb_GetColumnData('AuditCheckDis', row);
		var UnAuditOrdItem = DHCWeb_GetColumnData('UnAuditOrdItem', row);
		var TOrdStopStatus = DHCWeb_GetColumnData('TOrdStopStatus', row);
		if (myAuditCheckDis == "Y") {
			sSelect.disabled = true;
			if ((TOrdStopStatus != "D") && (UnAuditOrdItem == "Y") && (sExcute != "1")) {
				sSelect.disabled = false;
			}
		} else {
			sSelect.disabled = false;
		}
		var myAuditSelFlag = DHCWeb_GetColumnData('AuditSelFlag', row);
		myAuditSelFlag = parseInt(myAuditSelFlag);
		DHCWebD_SetListValueA(sSelect, myAuditSelFlag);
	}
	CalCurRefund();
}

function CalCurRefund() {
	var myRefSum = 0;
	var ListObj = parent.frames["udhcOPRefund_Order"];
	var mainobj = parent.frames["udhcOPRefund_main"];
	if ((mainobj) && (ListObj)) {
		var myRoundNum = 0;
		var obj = mainobj.document.getElementById("RoundNum");
		myRoundNum = DHCWebD_GetObjValueA(obj);
		if ((isNaN(myRoundNum)) || (myRoundNum == "")) {
			myRoundNum = 0;
		}
		myRoundNum = parseFloat(myRoundNum);
		var obj = mainobj.document.getElementById("Sum");
		var myINVSum = DHCWebD_GetObjValueA(obj);
		var rtn = DHCWebD_CalListCol(ListObj, "RefSum", "Tselect");
		var obj = mainobj.document.getElementById("RefundSum");
		if (obj) {
			obj.value = rtn;
		}
		var obj = mainobj.document.getElementById("FactRefSum");
		if (obj) {
			obj.value = rtn;
		}
	}
	return myRefSum;
}

function SelectRowHandler() {
	//+ZhYW 2017-04-20 新版检查申请单医嘱, 如果没有选择部位不能勾选退费
	var selectrow = DHCWeb_GetRowIdx(window);
	var selectObj = websys_$("Tselectz" + selectrow);
	if ((selectObj.checked)&&(!selectObj.disabled)){
		var orderRowId = DHCWeb_GetColumnData("TOrderRowid", selectrow);
		var refundRepPart = DHCWeb_GetColumnData("RefundRepPart", selectrow);
		var isAppRepFlag = tkMakeServerCall("web.UDHCJFPRICE", "IsAppRepOrder", orderRowId);
		if((isAppRepFlag == "Y") && (refundRepPart == "")){
			alert("申请单医嘱必须先选择部位");
			DHCWeb_SetColumnData("Tselect", selectrow, false);
		}
	}
	//
	CalCurRefund();
}

/**
* Creator: ZhYW
* CreatDate: 2017-09-08
* Description: 针对退费模式为"不需要审批"的检查申请单退费
*/
function OpenPartWinOnClick(oeitm, PBORowID, index) {
	var lnk = "dhcapp.repparttarwin.csp?oeori=" + oeitm;
	var rtn = window.showModalDialog(lnk, "", "dialogwidth:620px;dialogheight:400px;center:1");
	//var rtn = window.open(lnk, "", "scrollbars=no,resizable=no,top=100,status=yes,left=100,width=800,height=460");
	if (rtn) {
		var tmpAry = rtn.split("!!");
		var repPartIdStr = "";
		for (var i = 0; i < tmpAry.length; i++) {
			var tmp = tmpAry[i];
			var id = tmp.split("^")[0];
			var desc = tmp.split("^")[1];
			if (repPartIdStr == "") {
				repPartIdStr = id;
			} else {
				repPartIdStr = repPartIdStr + "!!" + id;
			}
		}
		DHCWeb_SetColumnData("RefundRepPart", index, repPartIdStr);
		if (repPartIdStr != "") {
			var rtn = tkMakeServerCall("web.udhcOPRefund", "UpdateExaReqFlag", oeitm, repPartIdStr);
			if (+rtn != 0) {
				alert('更新检查申请部位表退费申请状态失败');
				return;
			}
			var isRefAll = tkMakeServerCall("web.udhcOPRefund", "IsAllRefundRepPart", oeitm);
			var returnQty = 1;      //1:全部退费, 0:部分退费
			if (isRefAll == 1) {
				returnQty = 0;
			}
			DHCWeb_SetColumnData("TReturnQty", index, returnQty);
			var myRefSum = tkMakeServerCall("web.udhcOPRefund", "GetRepPartRefAmt", oeitm, PBORowID);
			DHCWeb_SetColumnData("RefSum", index, myRefSum);
			DHCWeb_SetColumnData("Tselect", index, true);
		} else {
			DHCWeb_SetColumnData("Tselect", index, false);
		}
	} else {
		DHCWeb_SetColumnData("RefundRepPart", index, "");
		DHCWeb_SetColumnData("Tselect", index, false);
	}
	
	CalCurRefund();
}

document.body.onload = BodyLoadHandler;
