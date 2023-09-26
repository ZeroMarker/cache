/*
ģ��:		��ҩ��
��ģ��:		��ҩ��-��ҩ������ȷ��
Creator:	hulihua
CreateDate:	2017-11-29
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
var recorduserid = ""; //ȷ����
DhcphaTempBarCode = "";

$(function () {
	/*��ʼ����� start*/
	SetDefaultCode();
	InitDecCond();
	InitGridDispConfirm();
	SetInitDecCond();
	/*��ʼ����� end*/
	//����س��¼�
	$('#txt-barcode').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			AddBarPrescNo();
		}
	});

	//���Żس��¼�
	$('#txt-usercode').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			SetInitDecCond();
		}
	});
	//�������лس��¼�
	$("input[type=text]").on("keypress", function (event) {
		if (window.event.keyCode == "13") {
			return false;
		}
	});

	$("button").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			return false;
		}
	});

	$("#sel-deccond").on('select2:select', function () {
		DhcphaTempBarCode = "";
		$('#recordprenum').text(0);
		$("#txt-barcode").val("");
		$("#grid-recordconfirm").jqGrid("clearGridData");
	});

	/* �󶨰�ť�¼� start*/
	$("#a-help").popover({
		animation: true,
		placement: 'bottom',
		trigger: 'hover',
		html: true,
		content: '<div style="width:300px;">*��ܰ��ʾ*</br>����ɨ������,��ɨ�蹤��Ŷ~</div>'
	});
	/* �󶨰�ť�¼� end*/

	$("#grid-recordconfirm").setGridWidth("")
	document.onkeydown = OnKeyDownHandler;
})

window.onload = function () {
	setTimeout("$(window).focus()", 100);
}

///Ĭ�ϵ�¼����Ϣ
function SetDefaultCode() {
	$('#recorduser').text(gUserName);
	$('#recordprenum').text(0);
	recorduserid = gUserID;
}

///�Ѽ�¼��ѯ
function RecordQuery() {
	var lnk = "dhcpha/dhcpha.inpha.hmrecordworkquery.csp";
	window.open(lnk, "_target", "width=" + (window.screen.availWidth - 10) + ",height=" + (window.screen.availHeight - 10) + ",menubar=no,status=yes,toolbar=no,resizable=yes,top='0',left='110',location=no");
}

///��ʼ����ϸtable
function InitGridDispConfirm() {
	var columns = [{
			header: '������',
			index: 'TPrescNo',
			name: 'TPrescNo',
			width: 80
		}, {
			header: '��������',
			index: 'TDoctorLoc',
			name: 'TDoctorLoc',
			width: 120,
			align: 'left'
		}, {
			header: '�ǼǺ�',
			index: 'TPatNo',
			name: 'TPatNo',
			width: 60
		}, {
			header: '��������',
			index: 'TPatName',
			name: 'TPatName',
			width: 60
		}, {
			header: '�Ա�',
			index: 'TSex',
			name: 'TSex',
			width: 60
		}, {
			header: '����',
			index: 'TPatAge',
			name: 'TPatAge',
			width: 30
		}, {
			header: '����',
			index: 'TFactor',
			name: 'TFactor',
			width: 60
		}, {
			header: '�÷�',
			index: 'TInstruc',
			name: 'TInstruc',
			width: 60
		}, {
			header: '��ҩ��ʽ',
			index: 'TCookType',
			name: 'TCookType',
			width: 60
		}
	];
	var jqOptions = {
		datatype: 'local',
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.THIS_URL + '?action=QueryDispConfirmList',
		height: DispConfirmCanUseHeight(),
		shrinkToFit: true,
		rownumbers: true,
		ondblClickRow: function () {
			DelBarPrescNo();
		}
	};
	$("#grid-recordconfirm").dhcphaJqGrid(jqOptions);
}

//���Ӵ����б���Ϣ��
function AddBarPrescNo() {
	DhcphaTempBarCode = "";
	var deccondesc = $.trim($('#sel-deccond option:checked').text());
	var decconid = $('#sel-deccond').val();
	if ((decconid == "") || (decconid == null)) {
		dhcphaMsgBox.alert("��¼״̬����Ϊ��!");
		return false;
	}
	var barcode = $.trim($("#txt-barcode").val());
	var dispgridrows = $("#grid-recordconfirm").getGridParam('records');
	for (var i = 1; i <= dispgridrows; i++) {
		var tmpselecteddata = $("#grid-recordconfirm").jqGrid('getRowData', i);
		var tmpprescno = tmpselecteddata["TPrescNo"];
		if (barcode.indexOf(tmpprescno) != "-1") {
			dhcphaMsgBox.alert("�ô�����ɨ��!");
			$("#txt-barcode").val("");
			return false;
		}
	}
	var ResultStr = tkMakeServerCall("web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery", "GetPrescByBarCode", barcode, deccondesc);
	var ResultStrArr = ResultStr.split(tmpSplit);
	var ResultCode = ResultStrArr[0];
	if ((ResultCode < 0) || (ResultCode == "") || (ResultCode == null)) {
		if (ResultCode == "-6") {
			dhcphaMsgBox.alert("�ô�����&nbsp&nbsp<b><font color=#CC1B04 size=4 >" + ResultStrArr[1] + "</font></b>&nbsp&nbsp�Ѽ�¼!<br/>");
		} else {
			dhcphaMsgBox.alert(ResultStrArr[1]);
		}
		$("#txt-barcode").val("");
		return false;
	}
	var ResultStrArr = ResultStr.split(tmpSplit)
		var PrescNo = ResultStrArr[0];
	var PatNo = ResultStrArr[1];
	var PatName = ResultStrArr[2];
	var Sex = ResultStrArr[3];
	var PatAge = ResultStrArr[4];
	var Instruc = ResultStrArr[5];
	var Factor = ResultStrArr[6];
	var CookType = ResultStrArr[7];
	var DoctorLoc = ResultStrArr[8];
	var datarow = {
		TPrescNo: PrescNo,
		TPatNo: PatNo,
		TPatName: PatName,
		TSex: Sex,
		TPatAge: PatAge,
		TFactor: Factor,
		TInstruc: Instruc,
		TCookType: CookType,
		TDoctorLoc: DoctorLoc
	};
	//console.log(datarow)
	var id = $("#grid-recordconfirm").find("tr").length;
	var su = $("#grid-recordconfirm").jqGrid('addRowData', id, datarow);
	if (!su) {
		dhcphaMsgBox.alert("ɨ��ʧ�ܣ����ʵ��");
	}
	$("#txt-barcode").val("");
	DhcphaTempBarCode = "";
	var SumFactor = $('#recordprenum').text();
	if ((SumFactor == "") || (SumFactor == null)) {
		SumFactor = 0;
	}
	SumFactor = parseInt(SumFactor) + parseInt(Factor);
	$('#recordprenum').text(SumFactor);
	return false;
}

function DelBarPrescNo() {
	var id = $("#grid-recordconfirm").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-recordconfirm").jqGrid('getRowData', id);
	var Factor = selrowdata.TFactor;
	var SumFactor = $('#recordprenum').text();
	if ((SumFactor == "") || (SumFactor == null)) {
		SumFactor = 0;
	}
	SumFactor = parseInt(SumFactor) - parseInt(Factor);
	$('#recordprenum').text(SumFactor);
	var su = $("#grid-recordconfirm").jqGrid('delRowData', id);
	if (!su) {
		dhcphaMsgBox.alert("ɾ��ʧ�ܣ�������˫��ɾ����");
	}
	return false;
}

//��֤�û���Ϣ��ִ��ȷ��
function ExecuteSure() {
	DhcphaTempBarCode = "";
	if ((recorduserid == "") || (recorduserid == null)) {
		dhcphaMsgBox.alert("��¼�˲���Ϊ��!");
		return false;
	}
	var deccondesc = $.trim($('#sel-deccond option:checked').text());
	var decconid = $('#sel-deccond').val();
	if ((decconid == "") || (decconid == null)) {
		dhcphaMsgBox.alert("��¼״̬����Ϊ��!");
		return false;
	}
	var grid_records = $("#grid-recordconfirm").getGridParam('records');
	if (grid_records == 0) {
		dhcphaMsgBox.alert("��ǰ�����޴�������,����ɨ�账�����룡");
		$("#txt-barcode").val("");
		return false;
	}
	var firstrowdata = $("#grid-recordconfirm").jqGrid("getRowData", 1); //��ȡ��һ������
	var prescno = firstrowdata.TPrescNo;
	if ((prescno == "") || (prescno == undefined)) {
		dhcphaMsgBox.alert("����ϵ��Ϣ������֤�����Ƿ��������!");
		$("#txt-barcode").val("");
		return false;
	}
	var dispgridrows = $("#grid-recordconfirm").getGridParam('records');
	var succCnt=0;
	for (var i = 1; i <= dispgridrows; i++) {
		var tmpselecteddata = $("#grid-recordconfirm").jqGrid('getRowData', i);
		var tmpprescno = tmpselecteddata["TPrescNo"];
		var retValue = tkMakeServerCall("web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery", "SaveRecordWorkLoad", tmpprescno, deccondesc, recorduserid);
		if (retValue != 0) {
			var Msg = retValue.split("^")[1];
			dhcphaMsgBox.alert("��¼&nbsp&nbsp<b><font color=#CC1B04 size=5 >" + tmpprescno + "</font></b>&nbsp&nbspʧ��!<br/>" + Msg);
			continue;
		} else {
			succCnt++;
			
		}
	}
	if(succCnt==0){
		dhcphaMsgBox.message("δ��¼!", "info");
	}if (succCnt==dispgridrows){
		dhcphaMsgBox.message("��¼��ɣ�ȫ���ɹ�!", "success");
	}else{
		dhcphaMsgBox.message("��¼��ɣ����ֳɹ�!", "success");
	}
	ClearConditons();
	return false;
}

//״̬�ݴ�
function SaveStatus() {
	if ((recorduserid == "") || (recorduserid == null)) {
		dhcphaMsgBox.alert("��¼�˲���Ϊ��!");
		return false;
	}
	var deccondesc = $.trim($('#sel-deccond option:checked').text());
	var decconid = $('#sel-deccond').val();
	if ((decconid == "") || (decconid == null)) {
		dhcphaMsgBox.alert("��¼״̬����Ϊ��!");
		return false;
	}
	var retValue = tkMakeServerCall("web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery", "SaveTempStatus", decconid, deccondesc, recorduserid);
	if (retValue != 0) {
		var Msg = retValue.split("^")[1];
		dhcphaMsgBox.alert("�ݴ�ʧ�ܣ�" + Msg);
	} else {
		dhcphaMsgBox.alert("�ݴ�ɹ�!");
	}
	return false;
}

//����ҩ״̬������ֵ
function SetInitDecCond() {
	var usercode = $.trim($("#txt-usercode").val());
	if (usercode == "") {
		usercode = gUserCode;
	}
	if (usercode == "") {
		dhcphaMsgBox.alert("���Ų���Ϊ��!");
		return false;
	}
	var defaultinfo = tkMakeServerCall("web.DHCINPHA.MTCommon.PublicCallMethod", "GetUserDefaultInfo", usercode);
	if (defaultinfo == "") {
		dhcphaMsgBox.alert("��������ȷ�Ĺ��ţ�");
		return false;
	}
	var ss = defaultinfo.split("^");
	recorduserid = ss[0];
	$('#recorduser').text(ss[2]);
	$("#txt-usercode").val("");
	var DecCondStr = tkMakeServerCall("web.DHCINPHA.HMRecordWorkLoad.RecordWorkLoadQuery", "GetTempStatus", recorduserid);
	if ((DecCondStr != "") || (DecCondStr != null)) {
		$("#sel-deccond").empty();
		var select2option = '<option value=' + "'" + DecCondStr.split("^")[0] + "'" + 'selected>' + DecCondStr.split("^")[1] + '</option>'
			$("#sel-deccond").append(select2option);
	}
	return false;
}

function ClearConditons() {
	DhcphaTempBarCode = "";
	$('#recordprenum').text(0);
	$("#txt-barcode").val("");
	$("#txt-usercode").val("");
	SetInitDecCond();
	$("#grid-recordconfirm").jqGrid("clearGridData");
}
//��ҳ��table���ø߶�
function DispConfirmCanUseHeight() {
	var height1 = parseFloat($("[class='container-fluid dhcpha-containter']").height());
	var height2 = parseFloat($("[class='panel-heading']").outerHeight());
	var height3 = parseFloat($(".div_content").css("margin-top"));
	var height4 = parseFloat($(".div_content").css("margin-bottom"));
	var height5 = parseFloat($(".dhcpha-row-split").outerHeight());
	var tableheight = $(window).height() - height1 - height4 - height2 - height3 - height5 - DhcphaGridTrHeight + 40;
	return tableheight;
}

function CheckTxtFocus() {
	var txtfocus1 = $("#txt-barcode").is(":focus");
	var txtfocus2 = $("#txt-usercode").is(":focus")
		if ((txtfocus1 != true) && (txtfocus2 != true)) {
			return false;
		}
		return true;
}

//����keydown,���ڶ�λɨ��ǹɨ����ֵ
function OnKeyDownHandler() {

	if (CheckTxtFocus() != true) {
		if (event.keyCode == 13) {
			if (DhcphaTempBarCode.length > 6) {
				$("#txt-barcode").val(DhcphaTempBarCode);
				AddBarPrescNo();
			} else {
				$("#txt-usercode").val(DhcphaTempBarCode);
				if ($("#grid-recordconfirm").getGridParam('records') > 0) {
					ExecuteSure();
				}
			}
			DhcphaTempBarCode = "";
		} else {
			DhcphaTempBarCode += String.fromCharCode(event.keyCode)
		}
	}
}
