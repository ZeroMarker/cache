/**
 * @Author      yaojining
 * @DateTime    2020-02-25
 * @description ��������������-�Ҽ�����
 */
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_RecordsConfig',
	TabCode: 'Know'
};
/**
 * @description ��ʼ������
 */
function initUI() {
	initHosp(getConfiguration);
	listenEvents();
}

$(initUI);

/**
 * @description ����
 */
function save() {
	var config = getElementValue(true, true);
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