/**
 * @Author      yaojining
 * @DateTime    2020-02-25
 * @description 护理病历开关配置-底色设置
 */
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_RecordsConfig',
	TabCode: 'Color'
};
/**
 * @description 初始化界面
 */
function initUI() {
	initHosp(getConfiguration);
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
	})
}
/**
 * @description 保存
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
			$.messager.popover({ msg: '保存成功!', type: 'success' });
		} else {
			$.messager.popover({ msg: '保存失败!' + ret, type: 'error' });
		}
	});
}