/**
 * @Author      yaojining
 * @DateTime    2020-02-25
 * @description ��������������-�Ҽ�����
 */
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_RecordsConfig',
	TabCode: 'Refer'
};
/**
 * @description ��ʼ������
 */
function initUI() {
	initHosp(getConfiguration);
	initCondition();
	listenEvents();
}
$(initUI);
/**
 * @description ��ʼ������
 */
function initCondition() {
	$HUI.combobox('#KnowCateExpandFlag', {
		valueField: 'id',
		textField: 'text',
		value: 'O',
		data: [
			{ id: 'C', text: "ȫ������" },
			{ id: 'O', text: "ȫ��չ��" },
			{ id: 'P1', text: "չ��һ��Ŀ¼" }
		],
	});
}
/**
 * @description ����
 */
function save() {
	var config = getElementValue(GLOBAL, true, true);
	$cm({
		ClassName: "NurMp.Service.Switch.Config",
		MethodName: "save",
		parr: config,
		HospitalID: GLOBAL.HospitalID,
		DeptType: 'I'
	}, function (ret) {
		if (parseInt(ret) == 0) {
			$.messager.popover({ msg: '����ɹ�!', type: 'success' });
		} else {
			$.messager.popover({ msg: '����ʧ��!' + ret, type: 'error' });
		}
	});
}