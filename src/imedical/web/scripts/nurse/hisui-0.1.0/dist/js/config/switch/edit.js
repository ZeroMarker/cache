/*
 * @Descripttion: 护理病历开关配置-病历填写
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
 * @description 初始化界面
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
 * @description 初始化条件
 */
function initCondition() {
	$("input[id*='Backcolor']").color({
		editable: false,
		onChange: function (value) {
		}
	});
	// $('#comboRecordDate').combobox({
	// 	data: [
	// 		{ id: 1, text: '不允许提前书写超过当前时间X小时的记录'},
	// 		{ id: 6, text: '不允许推后书写早于当前时间X小时的记录'},
	// 		{ id: 2, text: '不允许书写后天及之后的记录'},
	// 		{ id: 3, text: '不允许书写一周之后的记录'},
	// 		{ id: 4, text: '只允许书写前天、昨天、今天的记录'},
	// 		{ id: 5, text: '不限日期'},
	// 	]
	// });
}

/**
 * @description 保存
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
 * @description 初始化动态元素
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
			$.hisui.addArrayItem(data, 'value', { text: '不限时间', value: 8});
			$('#comboRecordTime').combobox('loadData', data);
		}
	}
}

/**
 * @description: 加载完值之后触发的动作
 */
function initAfterSetValue() {
	if ($('#loading').length > 0) {
		$('#loading').hide();
	}
}

/**
 * @description 事件监听
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
			$.hisui.addArrayItem(data, 'value', { text: '不限时间', value: 8});
			$('#comboRecordTime').combobox('loadData', data);
		}
	};
}
