/*
 * @Descripttion: 护理病历开关配置-编辑器升级
 * @Author: yaojining
 */
var GLOBAL = {
	PageCode: 'Update'
};
/**
 * @description 初始化界面
 */
function initUI() {
	queryValues();
	listenEvents();
}

$(initUI);

/**
 * @description 保存
 */
function save() {
	var config = getElementValue(false, false);
	$cm({
		ClassName: "NurMp.Service.Switch.Config",
		MethodName: "ConfigSet",
		parr: config
	}, function (ret) {
		if (parseInt(ret) > 0) {
			$.messager.popover({ msg: '保存成功!', type: 'success' });
		} else {
			$.messager.popover({ msg: '保存失败!', type: 'error' });
		}
	});
}