/// UDHCJFPatBill.js

var SelectedRow = 0;
var BillNo = "";
function BodyLoadHandler() {
	gusername = session['LOGON.USERNAME'];
	var obj = document.getElementById("Print");
	if (obj) {
		obj.onclick = Print;
	}
	var obj = document.getElementById("CheckOrderFee");
	if (obj) {
		obj.onclick = CheckOrderFee;
	}
}

function Print() {
	if (BillNo == "") {
		alert("请选择账单号打印费用明细.");
		return;
	}
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetail&BillNo=' + BillNo;
	websys_createWindow(url, '_blank', "width=80%,height=80%");
}

function CheckOrderFee() {
	if (BillNo == "") {
		alert("账单号为空！");
		return;
	}
	var Admobj = document.getElementById("Adm");
	var url = 'websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFBillDetailOrder&BillNo=' + BillNo + '&EpisodeID=' + Admobj.value;
	websys_createWindow(url, '_blank', "width=80%,height=80%");
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var Objtbl = document.getElementById('tUDHCJFPatBill');
	var Rows = Objtbl.rows.length;
	var lastrowindex = Rows - 1;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	if (!selectrow) {
		return;
	}
	var SelRowObj = document.getElementById('Tbillnoz' + selectrow);
	BillNo = SelRowObj.innerText;
	SelectedRow = selectrow;
}

document.body.onload = BodyLoadHandler;