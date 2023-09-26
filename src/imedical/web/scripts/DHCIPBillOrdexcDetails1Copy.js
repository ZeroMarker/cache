/// DHCIPBillOrdexcDetails1Copy.js

function BodyLoadHandler() {
	iniBgColor();
	//2015-08-17 zhuangna st
	var StopObj = document.getElementById('Stop');
	if (StopObj) {
		StopObj.onclick = Stop_click;
	}
	//2015-08-17 zhuangna end
}

function SelectRowHandler() {
	var eSrc = window.event.srcElement;
	var rowObj = getRow(eSrc);
	var selectrow = rowObj.rowIndex;
	var SelRowObj = document.getElementById('TBillOrdRowidz' + selectrow);
	//wangjian 20160205 控制合计行不可选择选择后变灰
	var selCheckObj = document.getElementById('Selectz' + selectrow);
	var isTotalObj = document.getElementById('TExecDatez' + selectrow);
	if ((selCheckObj.checked) && (isTotalObj.innerText == "合计")) {
		alert("此行为合计行不可选择操作");
		selCheckObj.checked = false;
		selCheckObj.disabled = true;

	}
}

function Stop_click() {
	var tableData = document.getElementById("tDHCIPBillOrdexcDetails1Copy");
	var selectFlag = 0;
	for (var i = 1; i < tableData.rows.length; i++) {
		if (document.getElementById("Selectz" + i).checked == true) {
			selectFlag = 1;
		}
	}
	if (selectFlag == 0) {
		alert("请选中要停止的医嘱执行记录!");
		return;
	}
	var Guser = session['LOGON.USERID'];
	var gusername = session['LOGON.USERNAME'];
	var gusercode = session['LOGON.USERCODE'];
	var ctLoc = session['LOGON.CTLOCID'];
	var Group = session['LOGON.GROUPID'];
	for (var i = 1; i < tableData.rows.length; i++) {
		var isTotal = document.getElementById('TExecDatez' + i).innerText;
		if (isTotal == "合计") {
			continue;
		}
		if (document.getElementById("Selectz" + i).checked == true) {
			var OrdExcRowID = document.getElementById("TOrdExcRowIDz" + i).innerText;
			var Guser = session['LOGON.USERID'];
			var ret = tkMakeServerCall("web.UDHCJFBillDetailOrder", "CheckStopOrder", OrdExcRowID, "C", Guser, ctLoc, Group);
			if (ret != 0) {
				switch (ret) {
				case "-303":
					alert("执行记录状态没有变化, 不用改变");
					return;
				case "-304":
					alert("执行记录已经执行,不能停止");
					return;
				case "-302":
					alert("执行记录已结算或完成,不能执行该操作");
					return;
				case "-305":
					alert("执行记录没有执行,不需要撤销");
					return;
				case "-306":
					alert("执行记录保存失败");
					return;
				case "-307":
					alert("执行记录变化表保存失败");
					return;
				case "-308":
					alert("执行记录计费变化表保存失败");
					return;
				case "-310":
					alert("执行记录扩展表保存失败");
					return;
				case "-301":
					alert("停止医嘱执行记录失败");
					return;
				case "-314":
					alert("临时医嘱未停止,不能停止执行");
					return;
				case "-315":
					alert("修改执行记录医嘱状态失败");
					return;
				case "-317":
					alert("停止医嘱执行记录失败");
					return;
				case "-301":
					alert("停止医嘱执行记录失败");
					return;
				default:
					alert("退费失败!" + ret);
					return;
				}

			} else {
				//alert("退费成功!");
				//return;
			}

		}
	}
	alert("退费成功!");

	var Oeordrowid = document.getElementById('Oeordrowid').value;
	var StDate = document.getElementById('StDate').value;
	var EndDate = document.getElementById('EndDate').value;
	var EpisodeID = document.getElementById('EpisodeID').value;
	var str = 'websys.default.csp?WEBSYS.TCOMPONENT=DHCIPBillOrdexcDetails1Copy&Oeordrowid=' + Oeordrowid + "&StDate=" + StDate + "&EndDate=" + EndDate + "&EpisodeID=" + EpisodeID;
	window.location.href = str;
}

function iniBgColor() {
	var tableObj = document.getElementById('tDHCIPBillOrdexcDetails1Copy');
	var rowNum = tableObj.rows.length;
	for (var i = 1; i < rowNum; i++) {
		var BillFlagObj = document.getElementById('TBillFlagz' + i);
		var BillFlag = BillFlagObj.innerText;
		var Patamt = document.getElementById('Patamtz' + i).innerText;
		if ((BillFlag == "未计费") || ((BillFlag == "已计费") & (eval(Patamt) == "0.00"))) {
			BillFlagObj.style.color = "Red";
			//tableObj.rows[i].cells[21].className="Red";
		}
	}
}

document.body.onload = BodyLoadHandler;
