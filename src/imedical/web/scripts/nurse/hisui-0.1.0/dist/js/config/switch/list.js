/*
 * @Descripttion: ҳ�����
 * @Author: yaojining
 */
/*
 * @Descripttion: ��������������-�б�����
 * @Author: yaojining
 */
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_SwitchSettings',
	PageCode: 'List'
};
/**
 * @description ��ʼ������
 */
function initUI() {
	initCondition();
	initHosp(function () {
		initGroup(function () {
			initLoc(initModel);
		})
	});
	listenEvents();
}

$(initUI);

/**
 * @description ��ʼ������
 */
function initCondition() {
	$("input[id*='Color']").color({
		editable: false,
		onChange: function (value) {
		}
	});
	// �б�ͼ���ʼ��
	$('#WarnIcons').combogrid({
		url: $URL,
		queryParams: {
			ClassName: 'NurMp.Common.Base.Patient',
			QueryName: 'GetIconList'
		},
		columns: [[
			{ field: 'Checkbox', title: 'sel', checkbox: true },
			{ field: 'Img', title: 'ͼ��', width: 50, align:'center', formatter: formatImg},
			{ field: 'Desc', title: '����', width: 180 },
			{ field: 'Code', title: '����', width: 140 },
			{ field: 'Icon', title: '·��', width: 250, showTip: true, tipWidth: 450 },
			{ field: 'ID', title: 'ID', width: 80, hidden:true }
		]],
		mode: 'remote',
		idField: 'ID',
		textField: 'Desc',
		multiple: true,
		pagination: false,
		panelWidth: 700,
		panelHeight: 300,
		delay: 500,
		enterNullValueClear: true,
		onBeforeLoad: function (param) {
			var desc = "";
			if (param['q']) {
				desc = param['q'];
			}
			param = $.extend(param, { desc: desc });
			return true;
		}
	});
}

/**
 * @description: ͼ����ʽ
 * @param {*} value
 * @param {*} row
 * @param {*} index
 * @return {*} a
 */
function formatImg(value, row, index) {
	return '<img src="' + value + '" />';
}

/**
 * @description ��ʼ����̬Ԫ��
 */
function initSyncElements(item, value, jsonData) {
	if (item == 'NDaysUnEditWarn') {
		if (value) {
			$('#btnNDaysUnEditWarn').linkbutton('enable');
			$('#NDaysUnEditWarnColor').color('enable');
		} else {
			$('#btnNDaysUnEditWarn').linkbutton('disable');
			$('#NDaysUnEditWarnColor').color('disable');
		}
	}
	if (item == 'XHoursUnEditWarn') {
		if (value) {
			$('#btnXHoursUnEditWarn').linkbutton('enable');
		} else {
			$('#btnXHoursUnEditWarn').linkbutton('disable');
		}
	}
	if (item == 'PlaceFileFlag') {
		if (JSON.parse(value) == true) {
			$('#CancelPlaceFileFun').attr('disabled', false);
		} else {
			$('#CancelPlaceFileFun').attr('disabled', true);
		}
	}
}

/**
 * @description ����
 */
function save() {
	var elements = queryElements('.switchTable tr td', false);
	$cm({
		ClassName: "NurMp.Service.Switch.Config",
		MethodName: "SaveSettings",
		HospitalID: GLOBAL.HospitalID,
		DeptType: 1,
		PageCode: GLOBAL.PageCode,
		LocID: $("#cbLoc").combobox("getValue"),
		GroupID: $("#cbGroup").combobox("getValue"),
		UserID: session['LOGON.USERID'],
		Param: JSON.stringify(elements)
	}, function (ret) {
		popover(ret);
	});
}

/**
 * @description: ���½Ǳ�����
 * @param {String} domID
 */
function updateWarnNum(domID) {
	var oriNum = parseInt($('#sp' + domID).text());
	var str = $('#' + domID).val();
	var num = 0;
	if (!!str) {
		num = str.split(',').length;
	}
	if (num > 0) {
		$('#sp' + domID).addClass('span_warn');
	} else {
		$('#sp' + domID).removeClass('span_warn');
	}
	$('#sp' + domID).text(num);
}

/**
 * @description: ������ֵ֮�󴥷��Ķ���
 */
function initAfterSetValue() {
	setTimeout(function () {
		updateWarnNum('IDsDaysUnEditWarn');
		updateWarnNum('IDsHoursUnEditWarn');
	}, 500);
	if ($('#loading').length > 0) {
		$('#loading').hide();
	}
}

/**
 * @description �¼�����
 */
function listenEvent() {
	$('#NDaysUnEditWarn').bind('keyup', function () {
		var value = $('#NDaysUnEditWarn').val();
		if (value) {
			$('#btnNDaysUnEditWarn').linkbutton('enable');
			$('#NDaysUnEditWarnColor').color('enable');
		} else {
			$('#btnNDaysUnEditWarn').linkbutton('disable');
			$('#IDsDaysUnEditWarn').val('');
			$('#NDaysUnEditWarnColor').color('setValue', '#ffffff');
			$('#NDaysUnEditWarnColor').color('disable');
			updateWarnNum('IDsDaysUnEditWarn');
		}
	});
	$('#NDaysUnEditWarn').bind('mouseup', function () {
		var value = $('#NDaysUnEditWarn').val();
		if (value) {
			$('#btnNDaysUnEditWarn').linkbutton('enable');
			$('#NDaysUnEditWarnColor').color('enable');
		} else {
			$('#btnNDaysUnEditWarn').linkbutton('disable');
			$('#IDsDaysUnEditWarn').val('');
			$('#NDaysUnEditWarnColor').color('setValue', '#ffffff');
			$('#NDaysUnEditWarnColor').color('disable');
			updateWarnNum('IDsDaysUnEditWarn');
		}
	});
	$('#XHoursUnEditWarn').bind('keyup', function () {
		var value = $('#XHoursUnEditWarn').val();
		if (value) {
			$('#btnXHoursUnEditWarn').linkbutton('enable');
		} else {
			$('#btnXHoursUnEditWarn').linkbutton('disable');
			$('#IDsHoursUnEditWarn').val('');
			updateWarnNum('IDsHoursUnEditWarn');
		}
	});
	$('#XHoursUnEditWarn').bind('mouseup', function () {
		var value = $('#XHoursUnEditWarn').val();
		if (value) {
			$('#btnXHoursUnEditWarn').linkbutton('enable');
		} else {
			$('#btnXHoursUnEditWarn').linkbutton('disable');
			$('#IDsHoursUnEditWarn').val('');
			updateWarnNum('IDsHoursUnEditWarn');
		}
	});
	$('#PlaceFileFlag').switchbox('options').onSwitchChange = function (e, obj) {
		if (obj.value) {
			$('#CancelPlaceFileFun').attr('disabled', false);
		} else {
			$('#CancelPlaceFileFun').attr('disabled', true);
		}
	};
}