/**
 * ����:   	 ����ҩƷ���� - ���鴦����ӡ
 * ��д��:   Huxiaotian
 * ��д����: 2020-08-23
 * csp:		 pha.in.v1.narcprescprt.csp
 * js:		 pha/in/v1/narcprescprt.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v1.narcprescprt.csp';
PHA_COM.App.Name = '���鴦����ӡ';
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

$(function () {
	InitDict();
	InitGridNarcPresc();
	InitEvents();

	InitConfig();
});

// ��ʼ�� - ���ֵ�
function InitDict() {
	PHA.ComboBox("wardLocId", {
		placeholder: '����...',
		url: PHA_STORE.CTLoc().url + "&TypeStr=W&HospId=" + session['LOGON.HOSPID']
	});
	PHA.ComboBox('phLocId', {
		placeholder: '��ҩ����...',
		url: PHA_STORE.CTLoc().url + '&TypeStr=D&HospId=' + session['LOGON.HOSPID']
	});
	PHA.ComboBox("docLocId", {
		placeholder: '��������...',
		url: PHA_STORE.DocLoc().url
	});
	PHA.ComboBox("poisonIdStr", {
		placeholder: '���Ʒ���...',
		url: PHA_STORE.PHCPoison().url,
		multiple: true,
		rowStyle: 'checkbox',
		selectOnNavigation: false,
		onLoadSuccess: function (data) {
			var thisOpts = $('#poisonIdStr').combobox('options');
			thisOpts.isLoaded = true;
		}
	});
	PHA.ComboBox("admType", {
		placeholder: '��������...',
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=AdmType',
		panelHeight: 'auto'
	});
	/*
	PHA.ComboBox("oeoreState", {
		placeholder: 'ִ�м�¼״̬...',
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=OEOREStatus'
	});
	*/
}

// ��ʼ�� - �¼���
function InitEvents() {
	// �ǼǺ�
	$('#patNo').on('keydown', function (e) {
		if (e.keyCode == 13) {
			var tPatNo = $('#patNo').val() || "";
			if (tPatNo == "") {
				return;
			}
			var nPatNo = PHA_COM.FullPatNo(tPatNo);
			$('#patNo').val(nPatNo);
			Query();
		}
	});
	$('#btnFind').on("click", Query);
	$('#btnClear').on("click", Clear);
	$('#btnPrint').on("click", PrintPrescDirect);
}

// ��ʼ�� - ���
function InitGridNarcPresc() {
	var columns = [
		[{
				title: "��������",
				field: "docLocDesc",
				width: 120,
				align: "left",
				sortable: true
			}, {
				title: "����",
				field: "wardLocDesc",
				width: 130,
				align: "left",
				sortable: true
			}, {
				title: "������",
				field: "prescNo",
				width: 130,
				align: "left",
				sortable: true
			}, {
				title: "�ǼǺ�",
				field: "patNo",
				width: 100,
				align: "left",
				sortable: true
			}, {
				title: "����",
				field: "patName",
				width: 90,
				align: "left",
				sortable: true
			}, {
				title: "֤������",
				field: "IDCard",
				width: 170,
				align: "left",
				sortable: true,
				formatter: function(value, rowData, rowIndex){
					return '<label title="' + (rowData.cardTypeDesc || '') + '" class="hisui-tooltip" data-options="position:\'right\'">' + value + '</label>';
				}
			}, {
				title: "�Ա�",
				field: "patSex",
				width: 65,
				align: "left",
				sortable: true
			}, {
				title: "����",
				field: "patAge",
				width: 65,
				align: "left",
				sortable: true
			}, {
				title: "����",
				field: "patWeight",
				width: 70,
				align: "left",
				sortable: true
			}, {
				title: "���",
				field: "patHeight",
				width: 70,
				align: "left",
				sortable: true
			}, {
				title: "�绰",
				field: "patTel",
				width: 110,
				align: "left",
				sortable: true
			}, {
				title: "������",
				field: "MRNo",
				width: 100,
				align: "left",
				sortable: true
			}, {
				title: "���",
				field: "MRDiagnos",
				width: 150,
				align: "left",
				sortable: true
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.Narc.Print',
			QueryName: 'NarcPresc'
		},
		singleSelect: true,
		pagination: true,
		columns: columns,
		toolbar: "#gridNarcPrescBar",
		onSelect: function (rowIndex, rowData) {
			var prescNo = rowData.prescNo;
			PrintPrescPreviwe(prescNo);
		},
		onLoadSuccess: function () {
			$('#ifrm-presc').attr('src', '');
		}
	};
	PHA.Grid("gridNarcPresc", dataGridOption);
}

function Query() {
	// ����
	var formDataArr = PHA.DomData("#formPanel", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	formData.hospId = session['LOGON.HOSPID'];

	// ��ѯ
	var InputStr = JSON.stringify(formData);
	$('#gridNarcPresc').datagrid('query', {
		InputStr: InputStr
	});
}

// ����Ԥ��
function PrintPrescPreviwe(prescNo) {
	var jsonData = GetPrescData(prescNo);
	if (jsonData == null) {
		return;
	}
	var backgroundColor = "white";
	if (jsonData.Para.PrescTitle) {
		var prescTitle = jsonData.Para.PrescTitle;
		if ((prescTitle.indexOf("��") >= 0) || (prescTitle.indexOf("��һ") >= 0)) {
			backgroundColor = "#F5A89A"; // ǳ��
		}
		if (prescTitle.indexOf("��") >= 0) {
			backgroundColor = "#F6FDAF"; // ����
		}
		if (prescTitle.indexOf("��") >= 0) {
			backgroundColor = "#D5FFCA"; // ����
		}
	}
	PRINTCOM.XML({
		printBy: 'inv',
		XMLTemplate: jsonData.Templet,
		data: jsonData,
		iframeID: 'ifrm-presc',
		preview: {
			showButtons: false,
			backgroundColor: backgroundColor
		},
		page: {
			rows: 15,
			x: 20,
			y: 2,
			fontname: '����',
			fontbold: 'false',
			fontsize: '12'
		},
		extendFn: function (data) {
			return {
				PrtDevice: data.Para.PrtDevice
			}
		}
	});
}

// ֱ�Ӵ�ӡ
function PrintPrescDirect() {
	var selectedData = $('#gridNarcPresc').datagrid('getSelected');
	if (selectedData == null || selectedData.length == 0) {
		PHA.Popover({
			msg: '��ѡ����Ҫ��ӡ�Ĵ���!',
			type: "info"
		});
		return;
	}
	var prescNo = selectedData.prescNo;
	var jsonData = GetPrescData(prescNo);
	if (jsonData == null) {
		return;
	}

	PRINTCOM.XML({
		XMLTemplate: jsonData.Templet,
		data: jsonData,
		extendFn: function (data) {
			return {
				PrtDevice: data.Para.PrtDevice
			}
		}
	});
}

function GetPrescData(prescNo) {
	var jsonData = $.cm({
		ClassName: 'PHA.MOB.COM.Print',
		MethodName: 'PrescPrintData',
		prescNo: prescNo
	}, false);
	if (jsonData.errCode < 0 || jsonData.success == 0) {
		PHA.Alert("��ʾ", "��ȡ���ݴ���!" + jsonData.errMsg + ' \r\n ' + jsonData.success, -1);
		return null;
	}
	if (!jsonData.Templet) {
		PHA.Alert("��ʾ", "δ��ȡ����Ҫ��������!", -1);
		return null;
	}
	return jsonData;
}

function Clear() {
	PHA.DomData("#formPanel", {
		doType: 'clear'
	});
	$('#startDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.StDate']));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.EdDate']));
	PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
	$('#gridNarcPresc').datagrid('clear');
	$('#ifrm-presc').attr('src', '');
}

function InitConfig() {
	$.cm({
		ClassName: "PHA.IN.Narc.Com",
		MethodName: "GetConfigParams",
		InputStr: PHA_COM.Session.ALL
	}, function (retJson) {
		// ���ݸ�ȫ��
		PHA_COM.VAR.CONFIG = retJson;
		$('#startDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.StDate']));
		$('#endDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['ComQuery.EdDate']));
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr']);
		// �Զ���ѯ
		if (patNo != "") {
			Query();
		}
	}, function (error) {
		console.dir(error);
		alert(error.responseText);
	});
}
