/*
 * @Descripttion: 护理病历开关配置-图片尺寸
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
 * @description 初始化界面
 */
function initUI() {
	initHosp(queryValues);
	listenEvents();
}

$(initUI);

/**
 * @description 保存
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
			$.messager.popover({ msg: '保存成功!', type: 'success' });
		} else {
			$.messager.popover({ msg: '保存失败!' + ret, type: 'error' });
		}
	});
}
