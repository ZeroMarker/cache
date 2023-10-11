/*
 * @Descripttion: 护理病历开关配置-服务地址
 * @Author: yaojining
 */
var GLOBAL = {
	PageCode: 'Picture'
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
		ClassName: "NurMp.Config",
		MethodName: "setValue",
		FieldName: "CreatePictureIP",
		Value: config
	}, function (ret) {
		if (parseInt(ret) == 0) {
			$.messager.popover({ msg: '保存成功!', type: 'success' });
		} else {
			$.messager.popover({ msg: '保存失败!' + ret, type: 'error' });
		}
	});
}