/*
 *ģ��:����ҩ��
 *��ģ��:����ҩ��-��ҩ
 *createdate:2016-08-22
 *creator:dinghongying
 */
DHCPHA_CONSTANT.DEFAULT.PHLOC = "";
DHCPHA_CONSTANT.DEFAULT.PHUSER = "";
DHCPHA_CONSTANT.DEFAULT.PHWINDOW = "";
DHCPHA_CONSTANT.DEFAULT.CYFLAG = "";
DHCPHA_CONSTANT.VAR.TIMER = "";
DHCPHA_CONSTANT.VAR.TIMERSTEP = 30 * 1000;
var PrintType="";
$(function () {
	CheckPermission();
	var ctloc = DHCPHA_CONSTANT.DEFAULT.LOC.text;
	$("#currentctloc").text(ctloc)
	/* ��ʼ����� start*/
	var daterangeoptions={
		singleDatePicker:true
	}
	$("#date-start").dhcphaDateRange(daterangeoptions);
	$("#date-end").dhcphaDateRange(daterangeoptions);

	InitGridWin();
	InitPYWin();
	InitGridPY();
	InitGirdPYDetail();
	InitConfig();
	/* ��Ԫ���¼� start*/
	//�ǼǺŻس��¼�
	$('#txt-patno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patno = $.trim($("#txt-patno").val());
			if (patno != "") {
				var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);			
				$(this).val(newpatno);
				if(newpatno==""){return;}
				QueryGridPY();
			}
		}
	});
	//���Żس��¼�
	$('#txt-cardno').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var cardno = $.trim($("#txt-cardno").val());
			if (cardno != "") {
				BtnReadCardHandler();
			}
		}
	});
	//�������лس��¼�
	$("input[type=text]").on("keypress", function (e) {
		if (window.event.keyCode == "13") {
			return false;
		}
	})
	/* ��Ԫ���¼� end*/


	/* �󶨰�ť�¼� start*/
	$("#btn-find").on("click", QueryGridPY);
	$("#btn-autoprint").on("click", function () {
		$("#modal-dhcpha-autoprint").modal('show');
	});
	$("#btn-clear").on("click", ClearConditions);
	$("#btn-change").on("click", function () {
		$("#modal-windowinfo").modal('show');
	});
	$("#btn-disp").on("click", ExecutePY);
	$('#btn-reprint').bind("click", RePrintHandler);
	$("#btn-win-sure").on("click", PYWindowConfirm);
	$("#btn-readcard").on("click", BtnReadCardHandler); //����
	/* �󶨰�ť�¼� end*/
	;

	/*modal show start*/
	$('#modal-dhcpha-autoprint').on('show.bs.modal', function () {
		DHCPHA_CONSTANT.VAR.TIMER = setInterval("AutoPrintPresc();", DHCPHA_CONSTANT.VAR.TIMERSTEP);
	})
	$('#modal-dhcpha-autoprint').on('hide.bs.modal', function () {
		clearTimeout(DHCPHA_CONSTANT.VAR.TIMER);
	})
	$("#modal-windowinfo").on('shown.bs.modal', function () {
		$('input[type=checkbox][name=dhcphaswitch]').bootstrapSwitch({
			onText: "����",
			offText: "����",
			onColor: "success",
			offColor: "default",
			size: "small",
			onSwitchChange: function (event, state) {
				var ret = ChangeWinStat(state);
				if (ret == false) {
					$(this).bootstrapSwitch('state', !state, true);
				}
			}
		})
		$("#grid-window").setGridWidth($("#modal-windowinfo .div_content").width())
		$("#grid-window").HideJqGridScroll({
			hideType: "X"
		})
	})
	/*modal show end*/
	HotKeyInit("PY","grid-py");
})
//��ʼ����ҩtable
function InitGridPY() {
	var columns = [{
			header: '��ҩ״̬',
			index: 'TPhDispStat',
			name: 'TPhDispStat',
			width: 75,
			cellattr: addPhDispStatCellAttr
		},
		{
			header: '�շ�����',
			index: 'TPrtDate',
			name: 'TPrtDate',
			width: 100,
			align: 'left'
		},
		{
			header: '�ǼǺ�',
			index: 'TPmiNo',
			name: 'TPmiNo',
			width: 90,
			align: 'left'
		},
		{
			header: '������',
			index: 'TPrescNo',
			name: 'TPrescNo',
			width: 125,
			align: 'left'
		},
		{
			header: '����',
			index: 'TPatName',
			name: 'TPatName',
			width: 80,
			align: 'left'
		},
		{
			header: '�Ա�',
			index: 'TPerSex',
			name: 'TPerSex',
			width: 50,
			align: 'left'
		},
		{
			header: '����',
			index: 'TPerAge',
			name: 'TPerAge',
			width: 60,
			align: 'left'
		},
		{
			header: '�������',
			index: 'TPrescMoney',
			name: 'TPrescMoney',
			width: 100,
			align: 'right'
		},
		{
			header: '�ѱ�',
			index: 'TPrescType',
			name: 'TPrescType',
			width: 60,
			align: 'left'
		},
		{
			header: '��������',
			index: 'TPrescTitle',
			name: 'TPrescTitle',
			width: 60
		},
		{
			header: '��ҩ����',
			index: 'TWinDesc',
			name: 'TWinDesc',
			width: 90,
			align: 'left'
		},
		{
			header: '����',
			index: 'TPerLoc',
			name: 'TPerLoc',
			width: 110,
			align: 'left'
		},
		{
			header: 'ȡ��',
			index: 'TNoteFlag',
			name: 'TNoteFlag',
			width: 60,
			align: 'left',
			hidden: true
		},
		{
			header: '��ҩ��',
			index: 'TDispMachine',
			name: 'TDispMachine',
			width: 60,
			editable: true,
			edittype: 'checkbox',
			align: 'left',
			hidden: true
		},
		{
			header: '����',
			index: 'TJS',
			name: 'TJS',
			width: 60,
			align: 'left'
		},
		{
			header: '��ҩ����',
			index: 'TJYType',
			name: 'TJYType',
			width: 80,
			align: 'left'
		},
		{
			header: '�绰',
			index: 'TCallCode',
			name: 'TCallCode',
			width: 100,
			align: 'left'
		},
		{
			header: '���',
			index: 'TMR',
			name: 'TMR',
			width: 300,
			align: 'left'
		},
		{
			header: '��ҩ��־',
			index: 'TFyFlag',
			name: 'TFyFlag',
			width: 40,
			hidden: true
		},
		{
			header: '��ӡ',
			index: 'TPrintFlag',
			name: 'TPrintFlag',
			width: 60,
			hidden: true
		},
		{
			header: 'TPatAdd',
			index: 'TPatAdd',
			name: 'TPatAdd',
			width: 40,
			hidden: true
		},
		{
			header: 'TPatID',
			index: 'TPatID',
			name: 'TPatID',
			width: 40,
			hidden: true
		},
		{
			header: 'Tphdrowid',
			index: 'Tphdrowid',
			name: 'Tphdrowid',
			width: 40,
			hidden: true
		},
		{
			header: 'TPhawId',
			index: 'TPhawId',
			name: 'TPhawId',
			width: 40,
			hidden: true
		},
		{
			header: '�����ܼ�',
			index: 'TEncryptLevel',
			name: 'TEncryptLevel',
			width: 40,
			hidden: true
		},
		{
			header: '���˼���',
			index: 'TPatLevel',
			name: 'TPatLevel',
			width: 40,
			hidden: true
		}

	];
	var jqOptions = {
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryPYList&style=jqGrid', //��ѯ��̨	
		height: DhcphaJqGridHeight(2, 1) + 7,
		multiselect: false,
		datatype: 'local',
		shrinkToFit: true,
		pager: "#jqGridPager", //��ҳ�ؼ���id  
		onSelectRow: function (id, status) {
			QueryGridPYSub()
		},
		loadComplete: function () {
			$("#grid-pydetail").clearJqGrid();
		}
	};
	$("#grid-py").dhcphaJqGrid(jqOptions);
}

//��ʼ����ҩ��ϸtable
function InitGirdPYDetail() {
	var columns = [{
			header: 'ҩƷ����',
			index: 'TPhDesc',
			name: 'TPhDesc',
			width: 200,
			align: 'left'
		},
		{
			header: '����',
			index: 'TPhQty',
			name: 'TPhQty',
			width: 60,
			align: 'right'
		},
		{
			header: '��λ',
			index: 'TPhUom',
			name: 'TPhUom',
			width: 80,
			align: 'left'
		},
		{
			header: '�÷�',
			index: 'TYF',
			name: 'TYF',
			width: 80,
			align: 'left'
		},
		{
			header: '����',
			index: 'TJL',
			name: 'TJL',
			width: 60,
			align: 'left'
		},
		{
			header: 'Ƶ��',
			index: 'TPC',
			name: 'TPC',
			width: 60,
			align: 'left'
		},
		{
			header: '�Ƴ�',
			index: 'TLC',
			name: 'TLC',
			width: 80,
			align: 'left'
		},
		{
			header: '����',
			index: 'TPrice',
			name: 'TPrice',
			width: 80,
			align: 'right',
			align: 'left'
		},
		{
			header: '���',
			index: 'TMoney',
			name: 'TMoney',
			width: 80,
			align: 'right',
			align: 'left'
		},
		{
			header: '״̬',
			index: 'TOrdStatus',
			name: 'TOrdStatus',
			width: 80,
			align: 'left'
		},
		{
			header: '��Ʊ��',
			index: 'TPrtNo',
			name: 'TPrtNo',
			width: 100
		},
		{
			header: '����',
			index: 'TPhFact',
			name: 'TPhFact',
			width: 200,
			align: 'left'
		},
		{
			header: '��ע',
			index: 'TPhbz',
			name: 'TPhbz',
			width: 70,
			align: 'left'
		},
		{
			header: '��ҩ��',
			index: 'TDispMachine',
			name: 'TDispMachine',
			width: 60,
			align: 'left'
		},
		{
			header: '��λ',
			index: 'TIncHW',
			name: 'TIncHW',
			width: 100,
			align: 'left'
		},
		{
			header: 'TOrditm',
			index: 'TOrditm',
			name: 'TOrditm',
			width: 60,
			hidden: true
		},
		{
			header: 'TUnit',
			index: 'TUnit',
			name: 'TUnit',
			width: 70,
			hidden: true
		},
		{
			header: '����',
			index: 'TIncPC',
			name: 'TIncPC',
			width: 150,
			hidden: true
		},
		{
			header: '���',
			index: 'TPhgg',
			name: 'TPhgg',
			width: 150,
			hidden: true
		},
		{
			header: 'Ƥ��',
			index: 'TSkinTest',
			name: 'TSkinTest',
			width: 70
		},
		{
			header: '����',
			index: 'TPhFact',
			name: 'TPhFact',
			width: 150,
			hidden: true
		}
	];
	var jqOptions = {
		datatype: 'local',
		rowNum: 200,
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryDispListDetail&style=jqGrid',
		height: DhcphaJqGridHeight(1, 1) - 10
	};
	$("#grid-pydetail").dhcphaJqGrid(jqOptions);
}
//��ѯ��ҩ�б�
function QueryGridPY() {

	var stdate = $("#date-start").val();
    var enddate = $("#date-end").val();
	var chkpy = "0";
	if ($("#chk-py").is(':checked')) {
		chkpy = "1";
	}
	var patno = $("#txt-patno").val();
	if((patno=="")&&(chkpy!=1)){
		dhcphaMsgBox.alert("������ǼǺŻ򿨺ź�,�ٴβ�ѯ!");
		return;
	}
	var GPhl = DHCPHA_CONSTANT.DEFAULT.PHLOC;
	var GPhw = DHCPHA_CONSTANT.DEFAULT.PHWINDOW; //$('#sel-window option:selected').val(); //������ҩ���ڵ�ID
	var CPatName = "";
	var params = stdate + "^" + enddate + "^" + GPhl + "^" + GPhw + "^" + patno + "^" + CPatName + "^" + chkpy;
	$("#grid-py").setGridParam({
		datatype: 'json',
		postData: {
			'params': params
		}
	}).trigger("reloadGrid");
}
//��ѯ��ҩ��ϸ
function QueryGridPYSub() {
	var selectid = $("#grid-py").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-py").jqGrid('getRowData', selectid);
	var prescno = selrowdata.TPrescNo;
	var rPhdrow = "";
	var params = DHCPHA_CONSTANT.DEFAULT.PHLOC + "^" + prescno + "^" + rPhdrow;
	$("#grid-pydetail").setGridParam({
		datatype: 'json',
		postData: {
			'params': params
		}
	}).trigger("reloadGrid");
}
// ִ����ҩ
function ExecutePY() {
	if (DhcphaGridIsEmpty("#grid-py") == true) {
		return;
	}
	var selectid = $("#grid-py").jqGrid('getGridParam', 'selrow');
	if ((selectid == "") || (selectid == null)) {
		dhcphaMsgBox.alert("û��ѡ������,������ҩ!");
		return;
	}
	var selrowdata = $("#grid-py").jqGrid('getRowData', selectid);
	var prescno = selrowdata.TPrescNo;
	var printflag = selrowdata.TPrintFlag;
	if (printflag == "1") {
		dhcphaMsgBox.alert("��ѡ�еļ�¼�Ѿ���ҩ!");
		return;
	}
	var adtresult = tkMakeServerCall("web.DHCOutPhCommon", "GetOrdAuditResultByPresc", prescno);
	if (adtresult == "") {
		dhcphaMsgBox.alert("�������!")
		return;
	} else if (adtresult == "N") {
		dhcphaMsgBox.alert("��˲�ͨ��,��������ҩ!")
		return;
	}
	var pharwid = selrowdata.TPhawId;
	var RetInfo = tkMakeServerCall("PHA.OP.PyAdv.OperTab", "SavePhdData", DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHWINDOW, DHCPHA_CONSTANT.DEFAULT.PHUSER, prescno, pharwid);
	var retarr = RetInfo.split("^");
	var dispret = retarr[0];
	var retmessage = retarr[1];
	if (dispret > 0) {
		var bgcolor = $(".dhcpha-record-pyed").css("background-color");
		var cssprop = {
			background: bgcolor,
			color: 'black'
		};
		$("#grid-py").setCell(selectid, 'TPrintFlag', 1);
		$("#grid-py").setCell(selectid, 'Tphdrowid', dispret);
		$("#grid-py").setCell(selectid, 'TPhDispStat', "����ҩ", cssprop);
		AfterExecPrint(prescno,PrintType,dispret,"");
		//AfterPyPrint(dispret, prescno, "");
	} else {
		dhcphaMsgBox.alert(retmessage, "error")
		return;
	}
}

//�Զ���ӡ��ҩ��
function AutoPrintPresc() {
	var autopy = tkMakeServerCall("web.DHCOutPhCode", "GetPhlAutoPyFlag", DHCPHA_CONSTANT.DEFAULT.PHLOC);
	if (autopy != 1) return;
	var startDate = $("#date-start").val();
    var endDate = $("#date-end").val();
	var getautodispinfo = tkMakeServerCall("PHA.OP.PyAdv.Query", "GetAutoDispInfo", startDate, endDate, DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHWINDOW);
	var retarr = getautodispinfo.split("^")
	var retnum = retarr[0]
	var retpid = retarr[1]
	if (retnum == 0) {
		return;
	}
	var insertphdispauto = tkMakeServerCall("PHA.OP.PyAdv.OperTab", "SaveAutoDispInfo", retpid, DHCPHA_CONSTANT.DEFAULT.PHLOC, DHCPHA_CONSTANT.DEFAULT.PHWINDOW, DHCPHA_CONSTANT.DEFAULT.PHUSER);
	if (insertphdispauto == "") {
		return;
	}
	var phdIdArr = insertphdispauto.split("^");
	for (var phdI = 0; phdI < phdIdArr.length; phdI++) {
		var iPhdIdStr = phdIdArr[phdI] || "";
		if (iPhdIdStr == "") {
			continue;
		}
		var iPhdId = iPhdIdStr.split("$")[0];
		var iPrescNo = iPhdIdStr.split("$")[1];
		AfterExecPrint(iPrescNo,PrintType,iPhdId,"")
		//AfterPyPrint(iPhdId, iPrescNo, "");
	}
}

//���´�ӡ
function RePrintHandler() {
	if (DhcphaGridIsEmpty("#grid-py") == true) {
		return;
	}
	var selectid = $("#grid-py").jqGrid('getGridParam', 'selrow');
	var selrowdata = $("#grid-py").jqGrid('getRowData', selectid);
	if (selectid == "") {
		dhcphaMsgBox.alert("û��ѡ������,�޷���ӡ!");
		return;
	}
	var phdrowid = selrowdata.Tphdrowid;
	var prescno = selrowdata.TPrescNo;
	AfterExecPrint(prescno,PrintType,phdrowid,"��")
	//AfterPyPrint(phdrowid, prescno, "��");
}

//��ҩ��Ĵ�ӡ���߲������ã�
function AfterPyPrint(phdrowid, prescno, ReprintFlag) {
	var outparamstr = tkMakeServerCall("PHA.OP.COM.Method", "GetParamProp", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID);
	var printtype = outparamstr.split("^")[1];
	if (printtype == "2") {
		OUTPHA_PRINTCOM.Presc(prescno, "����", "");
	} else {
		OUTPHA_PRINTCOM.PYD(phdrowid, ReprintFlag);
	}
}

//���
function ClearConditions() {
	$("#txt-patno").val("");
	$("#txt-cardno").val("");
	$('#chk-py').iCheck('uncheck');
	$("#date-start").data('daterangepicker').setStartDate(new Date());
	$("#date-start").data('daterangepicker').setEndDate(new Date());
	$("#date-end").data('daterangepicker').setStartDate(new Date());
	$("#date-end").data('daterangepicker').setEndDate(new Date());
	$("#grid-py").clearJqGrid();
	$("#grid-pydetail").clearJqGrid();
}

//��ʼ����ҩ����table
function InitGridWin() {
	var columns = [{
			header: '��ҩ����',
			index: 'pyWindesc',
			name: 'pyWindesc'
		},{
			header: '��ҩ����',
			index: 'phwWinDesc',
			name: 'phwWinDesc'
		},
		{
			header: '��ҩ����״̬',
			index: 'phwWinStat',
			name: 'phwWinStat',
			
			formatter: statusFormatter,
			title: false
		},
		{
			header: 'phwid',
			index: 'phwid',
			name: 'phwpid',
			width: 20,
			hidden: true
		},
		{
			header: 'phwpid',
			index: 'phwpid',
			name: 'phwpid',
			width: 20,
			hidden: true
		}
	];
	var jqOptions = {
		colModel: columns, //��
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=QueryDispWinList&gLocId=' + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + '&ChkRelFlag=1',
		height: '100%',
		autowidth: true,
		loadComplete: function () {}
	};
	$("#grid-window").dhcphaJqGrid(jqOptions);
}
//�Զ���״̬�и�ʽ
function statusFormatter(cellvalue, options, rowdata) {
	if (cellvalue == "����") {
		return '<input name="dhcphaswitch" type="checkbox" checked> '
	} else {
		return '<input name="dhcphaswitch" type="checkbox" unchecked> '
	}
}

function ChangeWinStat(state) {
	var wintd = $(event.target).closest("td");
	var rowid = $(wintd).closest("tr.jqgrow").attr("id");
	var selrowdata = $("#grid-window").jqGrid('getRowData', rowid);
	var phwpid = selrowdata.phwpid;
	var phwWinStat = state;
	var winstat = "";
	if (phwWinStat == true) {
		phwWinStat = "1";
	} else {
		phwWinStat = "0";
	}
	var modifyret = tkMakeServerCall("web.DHCOutPhDisp", "UpdatePhwp", phwpid, phwWinStat);
	if (modifyret == 0) {
		return true;
	} else if (modifyret == -11) {
		dhcphaMsgBox.alert("��ȷ������һ������Ϊ����״̬!");
		return false;
	} else {
		dhcphaMsgBox.alert("�޸Ĵ���״̬ʧ��,�������:" + modifyret, "error");
		return false;
	}
}
//��ҩ����ȷ��
function PYWindowConfirm() {
	var pyusr = DHCPHA_CONSTANT.SESSION.GUSER_ROWID;
	var ctloc = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID;
	var pywindata = $("#sel-window").select2("data")[0];
	if (pywindata == undefined) {
		dhcphaMsgBox.alert("��ҩ���ڲ���Ϊ��!");
		return false;
	}
	var timestep = $("#timestep").val().trim();
	if (timestep == "") {
		dhcphaMsgBox.alert("ʱ��������Ϊ��!");
		return false;
	}
	var pywin = pywindata.id;
	var pywindesc = pywindata.text;
	$('#modal-windowinfo').modal('hide');
	$("#currentwin").text("");
	$("#currentwin").text(pywindesc);
	$("#btn-change").text(pywindesc);
	DHCPHA_CONSTANT.DEFAULT.PHWINDOW = pywin;
	if ($.trim(timestep) != "") {
		DHCPHA_CONSTANT.VAR.TIMERSTEP = $("#timestep").val();
	}
	var phcookieinfo = pywin + "^" + pywindesc;
	removeCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^py");
	setCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^py", phcookieinfo);
	ClearConditions();
	return false;
}

//Ȩ����֤
function CheckPermission() {
	$.ajax({
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL + '?action=CheckPermission' +
			'&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID +
			'&gUserId=' + DHCPHA_CONSTANT.SESSION.GUSER_ROWID +
			'&gLocId=' + DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID,
		type: 'post',
		success: function (data) {
			var retjson = eval("(" + data + ")");
			var retdata = retjson[0];
			var permissionmsg = "",
				permissioninfo = "";
			if (retdata.phloc == "") {
				permissionmsg = "ҩ������:" + DHCPHA_CONSTANT.DEFAULT.LOC.text;
				permissioninfo = "��δ������ҩ������ά����ά��!"
			} else {
				permissionmsg = "����:" + DHCPHA_CONSTANT.SESSION.GUSER_CODE + "��������:" + DHCPHA_CONSTANT.SESSION.GUSER_NAME;
				if (retdata.phuser == "") {
					permissioninfo = "��δ������ҩ����Ա����ά��!"
				} else if (retdata.phnouse == "Y") {
					permissioninfo = "����ҩ����Ա����ά����������Ϊ��Ч!"
				} else if (retdata.phpy != "Y") {
					permissioninfo = "����ҩ����Ա����ά����δ������ҩȨ��!"
				}
			}
			if (permissioninfo != "") {
				$('#modal-dhcpha-permission').modal({
					backdrop: 'static',
					keyboard: false
				}); //���ɫ���򲻹ر�
				$('#modal-dhcpha-permission').on('show.bs.modal', function () {
					$("#lb-permission").text(permissionmsg)
					$("#lb-permissioninfo").text(permissioninfo)

				})
				$("#modal-dhcpha-permission").modal('show');
			} else {
				DHCPHA_CONSTANT.DEFAULT.PHLOC = retdata.phloc;
				DHCPHA_CONSTANT.DEFAULT.PHUSER = retdata.phuser;
				DHCPHA_CONSTANT.DEFAULT.CYFLAG = retdata.phcy;
				var getphcookie = getCookie(DHCPHA_CONSTANT.COOKIE.NAME + "^py");
				if (getphcookie != "") {
					$("#currentwin").text(getphcookie.split("^")[1]);
					$("#btn-change").text(getphcookie.split("^")[1])
					DHCPHA_CONSTANT.DEFAULT.PHWINDOW = getphcookie.split("^")[0];
				} else {
					$("#modal-windowinfo").modal('show');
				}
				$('#modal-windowinfo').on('show.bs.modal', function () {
					$("#sel-window ").empty();
				})
			}
		},
		error: function () {}
	})
}
//��ʼ����ҩ����
function InitPYWin() {
	var selectoption = {
		url: DHCPHA_CONSTANT.URL.COMMON_OUTPHA_URL +
			"?action=GetPYWinList&style=select2&gLocId=" +
			DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID + "&chkFyWFlag=1",
		minimumResultsForSearch: Infinity
	}
	$("#sel-window").dhcphaSelect(selectoption)
}

function addPhDispStatCellAttr(rowId, val, rawObject, cm, rdata) {
	if (val == "����ҩ") {
		return "class=dhcpha-record-pyed";
	} else if (val == "�Ѵ�ӡ") {
		return "class=dhcpha-record-printed";
	} else if (val == "�ѷ�ҩ") {
		return "class=dhcpha-record-disped";
	} else {
		return "";
	}
}
//����
function BtnReadCardHandler() {
	var readcardoptions = {
		CardTypeId: "sel-cardtype",
		CardNoId: "txt-cardno",
		PatNoId: "txt-patno"
	}
	DhcphaReadCardCommon(readcardoptions, ReadCardReturn)
}
//�������ز���
function ReadCardReturn() {
	QueryGridPY();
}
function InitConfig(){
	var CongigStr= tkMakeServerCall("PHA.OP.COM.Method", "GetParamProp", DHCPHA_CONSTANT.SESSION.GROUP_ROWID, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID, DHCPHA_CONSTANT.SESSION.GUSER_ROWID)
	if(CongigStr!=""){
		var arr=CongigStr.split("^");
		if(arr.length>=2){
			PrintType=arr[1]
		}
	}
}