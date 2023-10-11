/*
 * @Descripttion: ��������������-������д
 * @Author: yaojining
 * @Date: 2020-02-25
 */
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_SwitchSettings',
	PageCode: 'Edit'
};
/**
 * @description ��ʼ������
 */
function initUI() {
	initHosp(function(){
		initGroup(function(){
			initLoc(initModel);
		})
	});
	initCondition();
	listenEvents();
}

$(initUI);

/**
 * @description ��ʼ������
 */
function initCondition() {
	$("input[id*='Backcolor']").color({
		editable: false,
		onChange: function (value) {
		}
	});
	// $('#comboRecordDate').combobox({
	// 	data: [
	// 		{ id: 1, text: '��������ǰ��д������ǰʱ��XСʱ�ļ�¼'},
	// 		{ id: 6, text: '�������ƺ���д���ڵ�ǰʱ��XСʱ�ļ�¼'},
	// 		{ id: 2, text: '��������д���켰֮��ļ�¼'},
	// 		{ id: 3, text: '��������дһ��֮��ļ�¼'},
	// 		{ id: 4, text: 'ֻ������дǰ�졢���졢����ļ�¼'},
	// 		{ id: 5, text: '��������'},
	// 	]
	// });
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
		ModelID: $('#cbModel').combobox('getValue'),
		GroupID: $("#cbGroup").combobox("getValue"),
		UserID: session['LOGON.USERID'],
		Param: JSON.stringify(elements)
	}, function (ret) {
		popover(ret);
	});
}
/**
 * @description ��ʼ����̬Ԫ��
 */
function initSyncElements(item, value, jsonData) {
	if (item == 'GotoUrl') {
		if (JSON.parse(value) == true) {
			$('#UrlParameter').attr('disabled', false);
		} else {
			$('#UrlParameter').attr('disabled', true);
		}
	}
//	if (item == 'OutPatientEditFlag') {
//		if (JSON.parse(value) == true) {
//			// $('#OutPatientEditDays').numberbox('setValue', String(jsonData['OutPatientEditDays']));
//			$('#OutPatientEditDays').attr('disabled', false);
//		} else {
//			$('#OutPatientEditDays').attr('disabled', true);
//		}
//	}
	if (item == 'AllVisitFlag') {
		if (JSON.parse(value) == true) {
			// $('#SameAdmType').switchbox('setValue', jsonData['SameAdmType']);
			$('#SameAdmType').switchbox('setActive',true);
		} else {
			$('#SameAdmType').switchbox('setActive',false);
		}
	}
	if (item == 'InHospTime') {
		if (JSON.parse(value) == true) {
			$('.beforeHours').attr('disabled', false);
		} else {
			$('.beforeHours').attr('disabled', true);
		}
	}
	if (item == 'comboRecordDate') {
		if ((String(value) == '1') || (String(value) == '6')) {
			$('#comboRecordTime').combobox('enable');
		} else {
			$('#comboRecordTime').combobox('disable');
		}
		if (String(value) == '6') {
			var data = $('#comboRecordTime').combobox('getData');
			$.hisui.removeArrayItem(data, 'value', 8);
			$('#comboRecordTime').combobox('loadData', data);
		} else {
			var data = $('#comboRecordTime').combobox('getData');
			$.hisui.addArrayItem(data, 'value', { text: '����ʱ��', value: 8});
			$('#comboRecordTime').combobox('loadData', data);
		}
	}
}

/**
 * @description: ������ֵ֮�󴥷��Ķ���
 */
function initAfterSetValue() {
	if ($('#loading').length > 0) {
		$('#loading').hide();
	}
}

/**
 * @description �¼�����
 */
function listenEvent() {
	$('#GotoUrl').switchbox('options').onSwitchChange = function (e, obj) {
		if (obj.value) {
			$('#UrlParameter').attr('disabled', false);
		} else {
			$('#UrlParameter').attr('disabled', true);
		}
	};
//	$('#OutPatientEditFlag').switchbox('options').onSwitchChange = function (e, obj) {
//		if (obj.value) {
//			$('#OutPatientEditDays').attr('disabled', false);
//		} else {
//			$('#OutPatientEditDays').attr('disabled', true);
//		}
//	};
	$('#AllVisitFlag').switchbox('options').onSwitchChange = function (e, obj) {
		if (obj.value) {
			$('#SameAdmType').switchbox('setActive',true);
		} else {
			$('#SameAdmType').switchbox('setActive',false);
		}
	};
	$('#InHospTime').switchbox('options').onSwitchChange = function (e, obj) {
		if (obj.value) {
			$('.beforeHours').attr('disabled', false);
		} else {
			$('.beforeHours').attr('disabled', true);
		}
	};
	$('#comboRecordDate').combobox('options').onSelect = function (record) {
		if ((String(record.value) == '1') || (String(record.value) == '6')) {
			$('#comboRecordTime').combobox('enable');
		} else {
			$('#comboRecordTime').combobox('disable');
			$('#comboRecordTime').combobox('setValue', '');
		}
		if (String(record.value) == '6') {
			var data = $('#comboRecordTime').combobox('getData');
			$.hisui.removeArrayItem(data, 'value', 8);
			$('#comboRecordTime').combobox('loadData', data);
		} else {
			var data = $('#comboRecordTime').combobox('getData');
			$.hisui.addArrayItem(data, 'value', { text: '����ʱ��', value: 8});
			$('#comboRecordTime').combobox('loadData', data);
		}
	};
}
