/*
 * @Descripttion: ��������������-�����ַ
 * @Author: yaojining
 */
var GLOBAL = {
	PageCode: 'Picture'
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
		ClassName: "NurMp.Config",
		MethodName: "setValue",
		FieldName: "CreatePictureIP",
		Value: config
	}, function (ret) {
		if (parseInt(ret) == 0) {
			$.messager.popover({ msg: '����ɹ�!', type: 'success' });
		} else {
			$.messager.popover({ msg: '����ʧ��!' + ret, type: 'error' });
		}
	});
}