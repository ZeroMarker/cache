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
	//wangjian 20160205 ���ƺϼ��в���ѡ��ѡ�����
	var selCheckObj = document.getElementById('Selectz' + selectrow);
	var isTotalObj = document.getElementById('TExecDatez' + selectrow);
	if ((selCheckObj.checked) && (isTotalObj.innerText == "�ϼ�")) {
		alert("����Ϊ�ϼ��в���ѡ�����");
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
		alert("��ѡ��Ҫֹͣ��ҽ��ִ�м�¼!");
		return;
	}
	var Guser = session['LOGON.USERID'];
	var gusername = session['LOGON.USERNAME'];
	var gusercode = session['LOGON.USERCODE'];
	var ctLoc = session['LOGON.CTLOCID'];
	var Group = session['LOGON.GROUPID'];
	for (var i = 1; i < tableData.rows.length; i++) {
		var isTotal = document.getElementById('TExecDatez' + i).innerText;
		if (isTotal == "�ϼ�") {
			continue;
		}
		if (document.getElementById("Selectz" + i).checked == true) {
			var OrdExcRowID = document.getElementById("TOrdExcRowIDz" + i).innerText;
			var Guser = session['LOGON.USERID'];
			var ret = tkMakeServerCall("web.UDHCJFBillDetailOrder", "CheckStopOrder", OrdExcRowID, "C", Guser, ctLoc, Group);
			if (ret != 0) {
				switch (ret) {
				case "-303":
					alert("ִ�м�¼״̬û�б仯, ���øı�");
					return;
				case "-304":
					alert("ִ�м�¼�Ѿ�ִ��,����ֹͣ");
					return;
				case "-302":
					alert("ִ�м�¼�ѽ�������,����ִ�иò���");
					return;
				case "-305":
					alert("ִ�м�¼û��ִ��,����Ҫ����");
					return;
				case "-306":
					alert("ִ�м�¼����ʧ��");
					return;
				case "-307":
					alert("ִ�м�¼�仯����ʧ��");
					return;
				case "-308":
					alert("ִ�м�¼�Ʒѱ仯����ʧ��");
					return;
				case "-310":
					alert("ִ�м�¼��չ����ʧ��");
					return;
				case "-301":
					alert("ֹͣҽ��ִ�м�¼ʧ��");
					return;
				case "-314":
					alert("��ʱҽ��δֹͣ,����ִֹͣ��");
					return;
				case "-315":
					alert("�޸�ִ�м�¼ҽ��״̬ʧ��");
					return;
				case "-317":
					alert("ֹͣҽ��ִ�м�¼ʧ��");
					return;
				case "-301":
					alert("ֹͣҽ��ִ�м�¼ʧ��");
					return;
				default:
					alert("�˷�ʧ��!" + ret);
					return;
				}

			} else {
				//alert("�˷ѳɹ�!");
				//return;
			}

		}
	}
	alert("�˷ѳɹ�!");

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
		if ((BillFlag == "δ�Ʒ�") || ((BillFlag == "�ѼƷ�") & (eval(Patamt) == "0.00"))) {
			BillFlagObj.style.color = "Red";
			//tableObj.rows[i].cells[21].className="Red";
		}
	}
}

document.body.onload = BodyLoadHandler;
