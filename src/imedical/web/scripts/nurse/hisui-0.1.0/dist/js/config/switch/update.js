/*
 * @Descripttion: ��������������-�༭������
 * @Author: yaojining
 */
var GLOBAL = {
	PageCode: 'Update'
};
/**
 * @description ��ʼ������
 */
function initUI() {
	queryValues();
	listenEvents();
}

$(initUI);

/**
 * @description ����
 */
function save() {
	var config = getElementValue(false, false);
	$cm({
		ClassName: "NurMp.Service.Switch.Config",
		MethodName: "ConfigSet",
		parr: config
	}, function (ret) {
		if (parseInt(ret) > 0) {
			$.messager.popover({ msg: '����ɹ�!', type: 'success' });
		} else {
			$.messager.popover({ msg: '����ʧ��!', type: 'error' });
		}
	});
}