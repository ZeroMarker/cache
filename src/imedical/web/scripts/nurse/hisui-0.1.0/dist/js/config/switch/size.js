/*
 * @Descripttion: ��������������-ͼƬ�ߴ�
 * @Author: yaojining
 */
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ClsName: 'CF.NUR.EMR.CA',
	ConfigTableName: 'Nur_IP_CA',
	PageCode: 'Size'
};
/**
 * @description ��ʼ������
 */
function initUI() {
	initHosp(queryValues);
	listenEvents();
}

$(initUI);

/**
 * @description ����
 */
function save() {
	var config = getElementValue(true, true);
	$cm({
		ClassName: "NurMp.Service.CA.Handle",
		MethodName: "save",
		parr: config,
		HospitalID: GLOBAL.HospitalID
	}, function (ret) {
		if (parseInt(ret) == 0) {
			$.messager.popover({ msg: '����ɹ�!', type: 'success' });
		} else {
			$.messager.popover({ msg: '����ʧ��!' + ret, type: 'error' });
		}
	});
}
