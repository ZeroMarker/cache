/*
 * @Descripttion: 右键引用-特殊符号
 * @Author: yaojining
 */

var GV = {
	code: 'Symbol',
	hospitalID: session['LOGON.HOSPID'],
	className: 'NurMp.Service.Refer.Chars',
};

/**
 * @description: 初始化界面
 */
$(function () {
	requestConfig(initData);
});

/**
 * @description: 初始化数据表格
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
