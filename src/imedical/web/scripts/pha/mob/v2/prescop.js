/**
 * @Description: �ƶ�ҩ�� - �����в�ҩ������ѯ
 * @Creator:     Huxt 2021-03-05
 * @Csp:         pha.mob.v2.prescop.csp
 * @Js:          pha/mob/v2/prescop.js
 */
var curLocId = session['LOGON.CTLOCID'];
var curUserId = session['LOGON.USERID'];
var combWidth = 130;
PHA_COM.VAR = {
	CONFIG: null
};
var gLocId = session['LOGON.CTLOCID'] ;
PHA_COM.App.ProCode = 'HERB' ;
PHA_COM.App.ProDesc = '�в�ҩ��';
PHA_COM.App.Csp = 'pha.mob.v2.prescop.csp' ;
PHA_COM.App.Name = '���ﴦ����ѯ' ;

$(function () {
	//��ʼ������
	InitDict();
	InitGridPresc();
	InitGridPrescDetail();
	PHA_COM.ResizePanel({
		layoutId: 'layout-main',
		region: 'south',
		height: 0.4
	});

	// ���¼�
	$('#btnFind').on("click", QueryPresc);
	$('#btnPrint').on("click", Print);
	$('#btnPrinLabel').on("click", PrinDJLabel);
	$('#btnPrintHPLabel').on("click", PrintHPLabel);
	$('#btnAllowRet').on("click", AllowRet);
	$('#btnEmergency').on("click", Emergency);
	$('#btnCancelRefuse').on('click', CancelRefuse);
	$('#btnClear').on('click', Clear);

	// �ǼǺŻس��¼�
	$('#patNo').on('keypress', function (event) {
		if (event.keyCode == 13) {
			var patNo = $('#patNo').val();
			if (patNo == "") {
				return;
			}
			var newPatNo = PHA_COM.FullPatNo(patNo);
			$('#patNo').val(newPatNo);
			QueryPresc();
		}
	});

	// �����Żس��¼�
	$('#prescNo').on('keypress', function (event) {
		if (event.keyCode == 13) {
			var prescNo = $('#txt-PrescNo').val();
			if (prescNo == "") {
				return;
			}
			var newPrescNo = tkMakeServerCall("PHA.COM.MOB.Utils", "%PrescNoPadding", prescNo, 6, "O");
			$('#txt-PrescNo').val(newPrescNo);
			QueryPresc();
		}
	});
});

// ��ʼ��������
function InitDict() {
	PHA.ComboBox("phLoc", {
		placeholder: '��ѡ��ҩ��...',
		url: PHA_STORE.Pharmacy().url,
		width: combWidth ,
		onLoadSuccess: function (data) {
			var rows = data.length;
			for (var i = 0; i < rows; i++) {
				var iData = data[i];
				if (iData.RowId == gLocId) {
					$('#phLoc').combobox('setValue', iData.RowId);
				}
			}
		}
	});

	PHA.ComboBox("prescStatus", {
		placeholder: 'ѡ�񴦷�״̬...',
		//url: $URL + '?ResultSetType=Array&ClassName=PHA.MOB.PrescOP.Query&QueryName=StatusList&locId=' + session['LOGON.CTLOCID'],
		url: $URL + '?ResultSetType=Array&ClassName=PHA.HERB.Com.Store&QueryName=ExeProStore&gLocId=' + session['LOGON.CTLOCID'] + '&HospId=' + session['LOGON.HOSPID'] + '&admType=O',
		width: combWidth ,
		panelHeight: 'auto',
		editable: true,
		onLoadSuccess: function (data) {
			//$('#prescStatus').combobox('setValue', '0');
		}
	});
	
	// ����Ĭ��
	if ($('#startDate').datebox('getValue') == "") {
		$('#startDate').datebox('options').value = PHA_UTIL.SysDate('t');
		$('#startDate').datebox('setValue', $('#startDate').datebox('options').value);
	}
	if ($('#endDate').datebox('getValue') == "") {
		$('#endDate').datebox('options').value = PHA_UTIL.SysDate('t');
		$('#endDate').datebox('setValue', $('#endDate').datebox('options').value);
	}
	
	PHA.ComboBox('refuseFlag', {
		placeholder: '��ѡ��ܾ�...',
        data: [
            { RowId: 'Y', Description: $g('��') },
            { RowId: 'N', Description: $g('��') }
        ],
        panelHeight: 'auto',
        width: combWidth ,
		editable: false,
        onSelect: function () {}
    });
	
	PHA.ComboBox('cookType', {
		placeholder: '��ѡ���ҩ��ʽ...',
        url: PHA_HERB_STORE.CookType('', curLocId).url,
        width: combWidth ,
        panelHeight: 'auto'
    });
	
}

// ��ʼ�������
function InitGridPresc() {
	var columns = [[{
				field: "phar",
				title: 'phar',
				width: 80,
				hidden: true
			}, {
				field: 'phbdId',
				title: 'phbdId',
				width: 80,
				hidden: true
			}, {
				field: "prescNo",
				title: '������',
				width: 125,
				formatter: function (value, rowData, rowIndex) {
					return "<a style='border:0px;cursor:pointer;text-decoration:underline' onclick=OpenStepWin(" + rowIndex + ") >" + value + "</a>";
				}
			}, {
				field: 'phCookMode',
				title: '��ҩ����',
				width: 80
			}, {
				field: 'patName',
				title: '��������',
				width: 100
			}, {
				field: 'patNo',
				title: '�ǼǺ�',
				width: 120
			}, {
				field: 'winDesc',
				title: '����',
				width: 80
			}, {
				field: 'phLocDesc',
				title: '��ҩ����',
				width: 120
			}, {
				field: 'admLocDesc',
				title: '�������',
				width: 160
			}, {
				field: 'comUserName',
				title: '��ͨҩ��ҩ��',
				width: 100
			}, {
				field: 'valUserName',
				title: '����ҩ��ҩ��',
				width: 100
			}, {
				field: 'ordDT',
				title: 'ҽ��ʱ��',
				width: 155,
				align: 'center'
			}, {
				field: 'phaDT',
				title: '�շ�ʱ��',
				width: 155,
				align: 'center'
			}, {
				field: 'status',
				title: '����״̬',
				width: 80,
				align: 'center'
			}, {
				field: 'startPy',
				title: '��ҩ״̬',
				width: 80,
				hidden: true ,
				align: 'center'
			}, {
				field: 'priceFlag',
				title: '����ҩ',
				width: 80,
				align: 'center',
				formatter: YesNoFormatter
			}, {
				field: 'priFlag',
				title: '�Ƿ�����',
				width: 75,
				align: 'center',
				formatter: YesNoFormatter
			}, {
				field: 'allowRetFlag',
				title: '������ҩ��־',
				width: 110,
				align: 'center',
				formatter: YesNoFormatter
			}, {
				field: 'refuseFlag',
				title: '�ܾ���־',
				width: 70,
				align: 'center',
				formatter: YesNoFormatter
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.PrescOP.Query',
			QueryName: 'PharData'
		},
		fitColumns: false,
		border: false,
		rownumbers: false,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#gridPrescBar',
		onSelect: function (rowIndex, rowData) {
			QueryPrescDetail();
		},
		onClickCell: function (index, field, value) {},
		onLoadSuccess: function (data) {
			$('#gridPrescDetail').datagrid('clear');
			if (data.total > 0) {
				var selRowIdx = $(this).datagrid("options").selectedRowIndex;
				if (selRowIdx >= 0 && selRowIdx < data.rows.length) {
					$(this).datagrid("selectRow", selRowIdx);
				} else {
					$(this).datagrid("selectRow", 0);
				}
			}
		}
	};
	PHA.Grid("gridPresc", dataGridOption);
}

// ��ϸ���
function InitGridPrescDetail() {
	var columns = [[{
				field: 'inci',
				title: 'inci',
				width: 80,
				hidden: true
			}, {
				field: 'dspId',
				title: 'dspId',
				width: 80,
				hidden: true
			}, {
				field: 'oeori',
				title: 'oeori',
				width: 80,
				hidden: true
			}, {
				field: 'oeStatusDesc',
				title: 'ҽ��״̬',
				width: 100,
				align: 'center',
				styler: function(value, rowData, rowIndex) {
					if (rowData.oeStatusCode != "V" && rowData.oeStatusCode != "E") {
						return 'background-color:#FF5252; color:white;';
					}
				}
			}, {
				field: 'inciCode',
				title: 'ҩƷ����',
				width: 150
			}, {
				field: 'inciDesc',
				title: 'ҩƷ����',
				width: 200
			}, {
				field: 'geneDesc',
				title: 'ͨ����',
				width: 160
			}, {
				field: 'goodName',
				title: '��Ʒ��',
				width: 160,
				hidden: true
			}, {
				field: 'inciSpec',
				title: '���',
				width: 100
			}, {
				field: 'dspQty',
				title: '����',
				width: 100
			}, {
				field: 'dspUomDesc',
				title: '��λ',
				width: 100
			}, {
				field: 'pyFlag',
				title: '��ҩ���',
				width: 100,
				align: 'center',
				formatter: YesNoFormatter
			}, {
				field: 'freqDesc',
				title: 'Ƶ��',
				width: 150
			}, {
				field: 'instDesc',
				title: '�÷�',
				width: 100
			}, {
				field: 'duratDesc',
				title: '�Ƴ�',
				width: 100
			}, {
				field: 'ordRemark',
				title: 'ҽ����ע',
				width: 150
			}, {
				field: 'feeType',
				title: '�ѱ�',
				width: 150
			}, {
				field: 'oeDate',
				title: 'ҽ������',
				width: 120,
				align: 'center'
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.MOB.PrescOP.Query',
			QueryName: 'PrescDetail'
		},
		fitColumns: false,
		border: false,
		rownumbers: true,
		columns: columns,
		pagination: false,
		onLoadSuccess: function (data) {}
	};
	PHA.Grid("gridPrescDetail", dataGridOption);
}

// ��ѯ
function QueryPresc() {
	// ��ѯ����
	var formDataArr = PHA.DomData("#gridPrescBar", {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	var pJsonStr = JSON.stringify(formData);

	$('#gridPresc').datagrid('query', {
		pJsonStr: pJsonStr
	});
}

// ��ѯ��ϸ
function QueryPrescDetail() {
	var selRow = $('#gridPresc').datagrid('getSelected');
	var prescNo = selRow.prescNo;
	var pJsonStr = JSON.stringify({
		prescNo: prescNo
	});
	
	$('#gridPrescDetail').datagrid('query', {
		pJsonStr: pJsonStr
	});
}

// ����
function Clear() {
	PHA.DomData("#gridPrescBar", {
		doType: 'clear'
	});
	$('#startDate').datebox('setValue', $('#startDate').datebox('options').value);
	$('#endDate').datebox('setValue', $('#endDate').datebox('options').value);
	$('#prescStatus').combobox('setValue', '');
	$('#gridPresc').datagrid('clear');
	$('#gridPrescDetail').datagrid('clear');
	
	PHA_SYS_SET.Form.ReSet({
		phLoc: gLocId
	});
}

// ��ӡ��ҩ��
function Print() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	/*
	var phdId= tkMakeServerCall("PHA.OP.COM.Print","GetPhdByPrescNo",prescNo)
	*/
	var pyInfo = tkMakeServerCall("PHA.HERB.Com.Data","GetPrescPYInfo",prescNo)
	if (pyInfo == ""){
		$.messager.alert("��ʾ", "�ô�����δ��ҩ�����ܴ�ӡ��ҩ��", "warning");
		return;	
	}
	PHA_MOB_PRINT.PrintPyd(prescNo);
}

// ��������ǩ
function PrinDJLabel() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	var selRow = $('#gridPresc').datagrid('getSelected');
	var cookMode = selRow.phCookMode || "";
	if (cookMode !== "����") {
		$.messager.alert("��ʾ", "�ô�����ҩ���Ͳ��Ǵ��壬����Ҫ��ӡ�����ǩ", "warning");
		return;
	}
	
	// ����
	var winId = "presc_win_printNum";
	var winContentId = "presc_win_printNum" + "_content";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: 250,
			height: 140,
			modal: true,
			title: "����������ǩ����",
			iconCls: 'icon-w-print',
			content: "<div style='padding:10px;'><input id='prntDJNum' class='hisui-validatebox' style='width:222px;'/></div>",
			closable: true,
			buttons:[{
				text:'ȷ��',
				handler:function(){
					var prescNo = GetSelectedPrescNo();
					var printNum = $('#prntDJNum').val() || "";
					if (printNum == "" || printNum <= 0 || isNaN(parseInt(printNum))) {
						$.messager.popover({
							msg: "������һ��������!",
							type: "alert",
							timeout: 1000,
							style: {top: 20, left: ""}
						});
					}
					PHA_MOB_PRINT.PrintDJLabel(prescNo, printNum);
					$('#' + winId).dialog('close');
				}
			},{
				text:'ȡ��',
				handler:function(){
					$('#' + winId).dialog('close');
				}
			}]
		});
	}
	$('#' + winId).dialog('open');
	
	// ȡĬ�ϵ�����
	var printNum = tkMakeServerCall('PHA.MOB.COM.Print', 'GetDefaultDJNum', prescNo);
	printNum = printNum <= 0 ? 1 : printNum;
	$('#prntDJNum').val(printNum);
	$('#prntDJNum').focus();
}

// ����ҩ��ǩ
function PrintHPLabel() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	var selRow = $('#gridPresc').datagrid('getSelected');
	var priceFlag = selRow.priceFlag || "";
	if (priceFlag !== "Y") {
		$.messager.alert("��ʾ", "�ô��������й���ҩ������Ҫ��ӡ����ҩ��ǩ", "warning");
		return;
	}
	PHA_MOB_PRINT.PrintPriceLabel(prescNo);
}

// ����Ϊ����
function Emergency() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	var selRow = $('#gridPresc').datagrid('getSelected');
	var priFlag = selRow.priFlag || "";
	if (priFlag == "Y") {
		$.messager.alert("��ʾ", "�ô����Ѿ�������״̬������Ҫ�ٴ����ã�", "warning");
		return;
	}
	var pJsonStr = JSON.stringify({
		prescNo: prescNo
	});

	var retStr = tkMakeServerCall("PHA.MOB.PrescOP.Save", "PrescEmergency", pJsonStr);
	var retArr = retStr.split("^");
	if (retArr[0] < 0) {
		$.messager.alert("��ʾ", retArr[1], "warning");
		return;
	}
	$.messager.popover({
		msg: "���óɹ�!",
		type: "success",
		timeout: 1000
	});
	QueryPresc();
}

// ������ҩ
function AllowRet() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	var selRow = $('#gridPresc').datagrid('getSelected');
	var phbdId = selRow.phbdId || "";

	var pJsonStr = JSON.stringify({
		phbdId: phbdId,
		userId: session['LOGON.USERID']
	});

	var retStr = tkMakeServerCall("PHA.MOB.PrescOP.Save", "PrescAllowRet", pJsonStr);
	var retArr = retStr.split("^");
	if (retArr[0] < 0) {
		$.messager.alert("��ʾ", retArr[1], "warning");
		return;
	}
	$.messager.popover({
		msg: "���óɹ�!",
		type: "success",
		timeout: 1000
	});
	QueryPresc();
}

// �ֻ��Ͼܾ���ҩ�ĳ����ܾ�
function CancelRefuse() {
	var prescNo = GetSelectedPrescNo();
	if (prescNo == "") {
		return;
	}
	var selRow = $('#gridPresc').datagrid('getSelected');
	var refuseFlag = selRow.refuseFlag || "";
	if (refuseFlag !== "Y") {
		$.messager.alert("��ʾ", "�ô���δ�ܾ���ҩ�����ܳ����ܾ�", "warning");
		return;
	}
	
	var pJsonStr = JSON.stringify({
		prescNo: prescNo,
		userId: curUserId
	});

	var retStr = tkMakeServerCall("PHA.MOB.PrescOP.Save", "CancelRefuse", pJsonStr);
	var retArr = retStr.split("^");
	if (retArr[0] < 0) {
		$.messager.alert("��ʾ", retArr[1], "warning");
		return;
	}
	$.messager.popover({
		msg: "�����ɹ�!",
		type: "success",
		timeout: 1000
	});
	QueryPresc();
}

function GetSelectedPrescNo() {
	var selRow = $('#gridPresc').datagrid('getSelected');
	if (selRow == null) {
		$.messager.popover({
			msg: "��ѡ�񴦷�!",
			type: "alert",
			timeout: 1000
		});
		return "";
	}
	var prescNo = selRow.prescNo || "";
	if (prescNo == "") {
		$.messager.popover({
			msg: "��ѡ�񴦷�!",
			type: "alert",
			timeout: 1000
		});
		return "";
	}
	return prescNo;
}

// ����׷�ٵ���
function OpenStepWin(rowIndex) {
	var rowsData = $('#gridPresc').datagrid('getRows');
	if (rowsData == null) {
		$.messager.popover({
			msg: "�����б�û������!",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	var rowData = rowsData[rowIndex];
	var prescNo = rowData.prescNo || "";
	if (prescNo == "") {
		$.messager.popover({
			msg: "����ѡ�񴦷�!",
			type: "alert",
			timeout: 1000
		});
		return;
	}

	// ����
	var winWidth = parseInt($(document.body).width() * 0.97);
	var winId = "presc_win_step";
	var winContentId = "presc_win_step" + "_content";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: winWidth,
			height: 160,
			modal: true,
			title: "����״̬׷��",
			iconCls: 'icon-w-find',
			content: "<div id='" + winContentId + "' style='height:90px;margin:10px;'></div>",
			closable: true,
			onClose: function () {}
		});
	}

	// ����
	$("#" + winContentId).children().remove();
	var stepJsonStr = tkMakeServerCall('PHA.MOB.PrescOP.Query', 'GetStepWinInfo', prescNo);
	var stepJsonData = eval('(' + stepJsonStr + ')');
	var steps = stepJsonData.items.length;
	var stepWidth = (winWidth - 40) / steps;
	$("#" + winContentId).hstep({
		titlePostion: 'top',
		showNumber: false,
		stepWidth: stepWidth,
		currentInd: stepJsonData.currentInd,
		items: stepJsonData.items,
		onSelect: function (ind, item) {}
	});

	// �򿪴���
	$('#' + winId).dialog('open');
	$('#' + winId).dialog('setTitle', "����״̬׷�� - " + prescNo);
}

function YesNoFormatter(value, row, index) {
	if (value == "Y") {
		return PHA_COM.Fmt.Grid.Yes.Chinese;
	} else {
		return PHA_COM.Fmt.Grid.No.Chinese;
	}
}

// ��������
function InitConfig() {
	$.cm({
		ClassName: "PHA.MOB.COM.PC",
		MethodName: "GetConfig",
		InputStr: PHA_COM.Session.ALL
	}, function (retJson) {
		// ���ݸ�ȫ��
		PHA_COM.VAR.CONFIG = retJson;
	}, function (error) {
		console.dir(error);
		alert(error.responseText);
	});
}
