/**
 * ����:	 �ƶ�ҩ�� - �Զ���ӡ
 * ��д��:	 Huxt
 * ��д����: 2023-05-17
 * scripts/pha/mob/v2/autoprint.js
 */

var PHA_MOB_AUTOPRINT = {
	Timer: null,
	Seconds: 5000,
	Doing: false,
	NeedTerminate: false
};
$(function () {
	$('#panelAutoPrint').panel({
		title: PHA_COM.IsTabsMenu() !== true ? '�ƶ����Զ���ӡ' : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-print',
		fit: true,
		bodyCls: 'panel-body-gray'
	});

	$('#gifMachine').hide();
	$('#btnStart').on('click', function () {
		if (PHA_MOB_AUTOPRINT.Timer != null) {
			return;
		}
		if (CheckDoing() === false) {
			return;
		}
		if (IsCheckedPrintType() === false) {
			PHA.Popover({
				msg: '�����ٹ�ѡһ�ִ�ӡ��ʽ!',
				type: 'alert'
			});
			return;
		}
		SetCheckboxDisable(true);
		$('#gifMachine').show();
		AutoPrint();
		StartTimer();
	});
	$('#btnStop').on('click', function () {
		if (CheckDoing() === false) {
			return;
		}
		SetCheckboxDisable(false);
		$('#gifMachine').hide();
		clearTimeout(PHA_MOB_AUTOPRINT.Timer);
		PHA_MOB_AUTOPRINT.Timer = null;
	});
	$('#btnRefresh').on('click', function () {
		if (PHA_MOB_AUTOPRINT.Timer != null) {
			return;
		}
		if (CheckDoing() === false) {
			return;
		}
		$('#gifMachine').show();
		AutoPrint();
		StartTimer();
	});
});

function IsCheckedPrintType() {
	var checkTypeArr = $('.hisui-checkbox');
	for (var i = 0; i < checkTypeArr.length; i++) {
		if ($(checkTypeArr[i]).checkbox('getValue') === true) {
			return true;
		}
	}
	return false;
}

function SetCheckboxDisable(flag){
	var checkTypeArr = $('.hisui-checkbox');
	for (var i = 0; i < checkTypeArr.length; i++) {
		$(checkTypeArr[i]).checkbox('setDisable', flag);
	}
}

function CheckDoing() {
	if (PHA_MOB_AUTOPRINT.Doing === true) {
		PHA.Popover({
			msg: '������ȡ����, �� 1-2s ������',
			type: 'alert'
		});
		return false;
	}
	return true;
}

function StartTimer() {
	PHA_MOB_AUTOPRINT.Timer = setTimeout(function () {
		if (PHA_MOB_AUTOPRINT.NeedTerminate === true) {
			return;
		}
		PHA_MOB_AUTOPRINT.Doing = true;
		try {
			AutoPrint();
		} catch (e) {
			console.log(e);
		}
		PHA_MOB_AUTOPRINT.Doing = false;
		StartTimer();
	}, PHA_MOB_AUTOPRINT.Seconds);
}

function AutoPrint() {
	if (IsCheckedPrintType() === false) {
		return;
	}
	var jsonStr = tkMakeServerCall('PHA.MOB.COM.Print', 'GetPrintCommon', session['LOGON.CTLOCID'], '');
	var jsonData = JSON.parse(jsonStr);
	if (jsonData.CSPSessionCookie) {
		PHA_MOB_AUTOPRINT.NeedTerminate = true;
		return;
	}
	if (jsonData.success == 0) {
		console.log(jsonData);
		return;
	}
	var PrescNoArr = jsonData.PrescNoArr;
	var FinePrescNoArr = jsonData.FinePrescNoArr;
	var BoxIdArr = jsonData.BoxIdArr;

	// ����/��ҩ��
	for (var i = 0; i < PrescNoArr.length; i++) {
		var prescNo = PrescNoArr[i];
		if ($('#chkPrintPresc').checkbox('getValue') === true) {
			PrintPresc(prescNo);
		}
		if ($('#chkPrintPyd').checkbox('getValue') === true) {
			PrintPyd(prescNo);
		}
	}

	// ����ҩ��ǩ
	for (var i = 0; i < FinePrescNoArr.length; i++) {
		var prescNo = FinePrescNoArr[i];
		if ($('#chkPrintPrescFine').checkbox('getValue') === true) {
			PrintPriceLabel(prescNo);
		}
	}

	// �������ǩ
	for (var i = 0; i < BoxIdArr.length; i++) {
		var boxId = BoxIdArr[i];
		if ($('#chkPrintBox').checkbox('getValue') === true) {
			PrintBoxLable(boxId);
		}
	}
}

/**
 * @creator: Huxt 2020-12-08
 * @description: ��ӡ���� (��ҩ&��ҩ)
 */
function PrintPresc(prescNo) {
	var jsonData = $.cm({
		ClassName: 'PHA.MOB.COM.Print',
		MethodName: 'PrescPrintData',
		prescNo: prescNo
	}, false);
	if (jsonData.errCode < 0 || jsonData.success == 0) {
		return;
	}
	if (!jsonData.Templet) {
		return;
	}
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: jsonData.Templet,
		data: jsonData,
		extendFn: function (data) {
			return {
				PrtDevice: data.Para.PrtDevice
			}
		}
	});
}
/**
 * @creator: Huxt 2020-12-08
 * @description: ��ӡ��ҩ�� (��ҩ&��ҩ)
 */
function PrintPyd(prescNo) {
	var jsonData = $.cm({
		ClassName: 'PHA.MOB.COM.Print',
		MethodName: 'PydPrintData',
		prescNo: prescNo
	}, false);
	if (jsonData.errCode < 0 || jsonData.success == 0) {
		return;
	}
	if (!jsonData.Templet) {
		return;
	}

	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: jsonData.Templet,
		data: jsonData,
		extendFn: function (data) {
			return {
				PrtDevice: data.Para.PrtDevice
			}
		}
	});
}

/**
 * @creator: Huxt 2020-12-08
 * @description: ��ӡ����ҪƷ��ǩ (����ҩ)
 */
function PrintPriceLabel(prescNo) {
	var jsonData = $.cm({
		ClassName: 'PHA.MOB.COM.Print',
		MethodName: 'PriceLabelPrintData',
		prescNo: prescNo
	}, false);
	if (jsonData.errCode < 0 || jsonData.success == 0) {
		return;
	}

	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: "PHAINPriceLabel",
		data: jsonData,
		page: {
			rows: 1,
			format: ""
		},
		extendFn: function (data) {
			return {
				PrtDevice: data.Para.PrtDevice
			}
		}
	});
}

/**
 * @creator: Huxt 2020-12-08
 * @description: ��������ܱ�ǩ (��ҩ������ǩ-������)
 */
function PrintBoxLable(boxId) {
	var jsonData = $.cm({
		ClassName: 'PHA.MOB.COM.Print',
		MethodName: 'BoxPrintData',
		boxId: boxId
	}, false);
	if (jsonData.errCode < 0 || jsonData.success == 0) {
		return;
	}

	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: "PHAINBoxLabel",
		data: jsonData,
		extendFn: function (data) {
			return {
				PrtDevice: data.Para.PrtDevice
			}
		}
	});
}
