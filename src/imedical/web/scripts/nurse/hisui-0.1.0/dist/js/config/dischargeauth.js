/*
 * @Descripttion: ��Ժ������Ȩ����
 * @Author: yaojining
 * @Date: 2023-02-11
 */
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_SwitchSettings',
	PageCode: 'DischAuth',
	ControlElements: {
		'DAFileControl': 'DAFileControlInterface',
		'DAEmrControl': 'DAEmrControlDays',
		'DAObsControl': 'DAObsControlDays',
		'DABloodSugarControl': 'DABloodSugarControlDays',
		'DABirthDiagramControl': 'DABirthDiagramControlDays',
		'DAHealthEduControl': 'DAHealthEduControlDays',
		'DAFileControlDischAuth': 'DAFileControlDischAuthInterface',
	}
};
/**
 * @description ��ʼ������
 */
function initUI() {
	initHosp(queryValues);
	initCondition();
	listenEvents();
}

$(initUI);

/**
 * @description ��ʼ������
 */
function initCondition() {
	
}

/**
 * @description ����
 */
function save() {
	var elements = queryElements('.form_table tr td', false);
	$cm({
		ClassName: "NurMp.Service.Switch.Config",
		MethodName: "SaveSettings",
		HospitalID: GLOBAL.HospitalID,
		DeptType: 1,
		PageCode: GLOBAL.PageCode,
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
	var domID = GLOBAL.ControlElements[item];
	if (!!domID) {
		if (JSON.parse(value) == true) {
			$('#' + domID).attr('disabled', false);
		} else {
			$('#' + domID).attr('disabled', true);
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
	$('#DAFileControl').switchbox('options').onSwitchChange = function (e, obj) {
		if (obj.value) {
			$('#DAFileControlInterface').attr('disabled', false);
		} else {
			$('#DAFileControlInterface').attr('disabled', true);
		}
	};
	$('#DAEmrControl').switchbox('options').onSwitchChange = function (e, obj) {
		if (obj.value) {
			$('#DAEmrControlDays').attr('disabled', false);
		} else {
			$('#DAEmrControlDays').attr('disabled', true);
		}
	}
	$('#DAObsControl').switchbox('options').onSwitchChange = function (e, obj) {
		if (obj.value) {
			$('#DAObsControlDays').attr('disabled',false);
		} else {
			$('#DAObsControlDays').attr('disabled',true);
		}
	}
	$('#DABloodSugarControl').switchbox('options').onSwitchChange = function (e, obj) {
		if (obj.value) {
			$('#DABloodSugarControlDays').attr('disabled', false);
		} else {
			$('#DABloodSugarControlDays').attr('disabled', true);
		}
	}
	$('#DABirthDiagramControl').switchbox('options').onSwitchChange = function (e, obj) {
		if (obj.value) {
			$('#DABirthDiagramControlDays').attr('disabled', false);
		} else {
			$('#DABirthDiagramControlDays').attr('disabled', true);
		}
	}
	$('#DAHealthEduControl').switchbox('options').onSwitchChange = function (e, obj) {
		if (obj.value) {
			$('#DAHealthEduControlDays').attr('disabled', false);
		} else {
			$('#DAHealthEduControlDays').attr('disabled', true);
		}
	}
	$('#DAFileControlDischAuth').switchbox('options').onSwitchChange = function (e, obj) {
		if (obj.value) {
			$('#DAFileControlDischAuthInterface').attr('disabled', false);
		} else {
			$('#DAFileControlDischAuthInterface').attr('disabled', true);
		}
	};
}
