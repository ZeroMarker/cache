/*
 * @Descripttion: �Ҽ�����-�������
 * @Author: yaojining
 */

var GV = {
	code: 'Symbol',
	hospitalID: session['LOGON.HOSPID'],
	className: 'NurMp.Service.Refer.Chars',
};

/**
 * @description: ��ʼ������
 */
$(function () {
	requestConfig(initData);
});

/**
 * @description: ��ʼ�����ݱ��
 * @param {object} config
 */
function initData(config) {
	$cm({
		ClassName: config.queryParams.ClassName,
		MethodName: config.queryParams.MethodName,
		HospitalID: GV.hospitalID
	}, function (items) {
		$('#kwChars').keywords({
			singleSelect: true,
			items: items,
			onClick: function (v) {
				writToPreview(v.text);
			}
		});
	});
}
