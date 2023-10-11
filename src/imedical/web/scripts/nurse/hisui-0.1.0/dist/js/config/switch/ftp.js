/*
 * @Descripttion: 护理病历开关配置-Ftp配置
 * @Author: yaojining
 */
var GLOBAL = {
	HospEnvironment: true,
	HospitalID: session['LOGON.HOSPID'],
	ClsName: 'CF.NUR.EMR.FtpInfo',
	ConfigTableName: 'Nur_IP_FtpInfo',
	PageCode: 'FTP'
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
	if (!$('#FtpAddress').val().trim()) {
		$.messager.popover({ msg: 'Ftp地址不能为空!', type: 'error' });
		return;
	}
	if (!$('#FtpUserName').val().trim()) {
		$.messager.popover({ msg: 'Ftp用户名不能为空!', type: 'error' });
		return;
	}
	if (!$('#FtpPassWord').val()) {
		$.messager.popover({ msg: 'Ftp密码不能为空!', type: 'error' });
		return;
	}
	if (!$('#FtpPort').val().trim()) {
		$.messager.popover({ msg: 'Ftp端口不能为空!', type: 'error' });
		return;
	}
	if (!$('#FtpDealyTime').val().trim()) {
		$.messager.popover({ msg: 'Ftp延迟时间不能为空!', type: 'error' });
		return;
	}
	$.messager.confirm("提醒", "确定要修改吗?", function (r) {
		if (r) {
			$cm({
				ClassName: "NurMp.Service.Image.Ftp",
				MethodName: "saveFtpInfo",
				IP: $('#FtpAddress').val().trim(),
				UserName: $('#FtpUserName').val().trim(),
				Password: $('#FtpPassWord').val(),
				Port: $('#FtpPort').val().trim(),
				DealyTime: $('#FtpDealyTime').val().trim(),
				TransferType: $("#FtpTransferType").switchbox('getValue'),
				Ftps: $("#Ftps").switchbox('getValue'),
				HospitalID: GLOBAL.HospitalID
			}, function (ret) {
				if (parseInt(ret) == 0) {
					$.messager.popover({ msg: '保存成功!', type: 'success' });
				} else {
					$.messager.popover({ msg: '保存失败!  错误代码：' + ret, type: 'error' });
				}
			});
		} else {
			return;
		}
	});
}

function testFtp() {
	$.messager.progress({
		title: "提示",
		msg: '正在测试Ftp连接，请稍候...',
		text: '测试中....'
	});
	$cm({
		ClassName: "NurMp.Service.Image.Ftp",
		MethodName: "TestFtp",
		HospitalID: GLOBAL.HospitalID,
		IP: $('#FtpAddress').val().trim(),
		UserName: $('#FtpUserName').val().trim(),
		Password: $('#FtpPassWord').val(),
		Port: $('#FtpPort').val().trim(),
		DealyTime: $('#FtpDealyTime').val().trim(),
		TransferType: $("#FtpTransferType").switchbox('getValue'),
		Ftps: $("#Ftps").switchbox('getValue')
	}, function (ret) {
		$.messager.progress("close");
		if (ret.status == '0') {
			$.messager.alert("提示", ret.msg, 'success');
		} else {
			$.messager.alert("提示", ret.msg, 'error');
		}
	});
}
/**
 * @description 事件监听
 */
function listenEvent() {
	$('#btnTest').bind('click', testFtp);
}