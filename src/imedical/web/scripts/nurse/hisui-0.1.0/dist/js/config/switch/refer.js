/**
 * @Author      yaojining
 * @DateTime    2020-02-25
 * @description 护理病历开关配置-右键引用
 */
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_RecordsConfig',
	TabCode: 'Refer'
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
	$HUI.combobox('#KnowCateExpandFlag', {
		valueField: 'id',
		textField: 'text',
		value: 'O',
		data: [
			{ id: 'C', text: "全部收缩" },
			{ id: 'O', text: "全部展开" },
			{ id: 'P1', text: "展开一级目录" }
		],
	});
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