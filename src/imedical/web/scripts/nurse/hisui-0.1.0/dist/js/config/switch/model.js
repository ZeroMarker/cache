/**
 * @Author      yaojining
 * @DateTime    2020-02-25
 * @description 护理病历开关配置-模板列表
 */
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ConfigTableName: 'Nur_IP_RecordsConfig',
	TabCode: 'Model'
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
/**
 * @description 初始化动态元素
 */
function initSyncElements(item, value) {
	if (item == 'GotoUrl') {
		if (value == true) {
			$('.urlTr').show();
		} else {
			$('.urlTr').hide();
		}
	}
}
/**
 * @description 事件监听
 */
function listenEvent() {
	$('#GotoUrl').switchbox('options').onSwitchChange = function (e, obj) {
		if (obj.value) {
			$('.urlTr').show();
		} else {
			$('.urlTr').hide();
		}
	};
}
