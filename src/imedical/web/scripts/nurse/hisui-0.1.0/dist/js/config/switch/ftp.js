/*
 * @Descripttion: ��������������-Ftp����
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
 * @description ��ʼ������
 */
function initUI() {
	initHosp(queryValues);
	listenEvents();
}
$(initUI);
/**
 * @description ����
 */
function save() {
	if (!$('#FtpAddress').val().trim()) {
		$.messager.popover({ msg: 'Ftp��ַ����Ϊ��!', type: 'error' });
		return;
	}
	if (!$('#FtpUserName').val().trim()) {
		$.messager.popover({ msg: 'Ftp�û�������Ϊ��!', type: 'error' });
		return;
	}
	if (!$('#FtpPassWord').val()) {
		$.messager.popover({ msg: 'Ftp���벻��Ϊ��!', type: 'error' });
		return;
	}
	if (!$('#FtpPort').val().trim()) {
		$.messager.popover({ msg: 'Ftp�˿ڲ���Ϊ��!', type: 'error' });
		return;
	}
	if (!$('#FtpDealyTime').val().trim()) {
		$.messager.popover({ msg: 'Ftp�ӳ�ʱ�䲻��Ϊ��!', type: 'error' });
		return;
	}
	$.messager.confirm("����", "ȷ��Ҫ�޸���?", function (r) {
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
					$.messager.popover({ msg: '����ɹ�!', type: 'success' });
				} else {
					$.messager.popover({ msg: '����ʧ��!  ������룺' + ret, type: 'error' });
				}
			});
		} else {
			return;
		}
	});
}

function testFtp() {
	$.messager.progress({
		title: "��ʾ",
		msg: '���ڲ���Ftp���ӣ����Ժ�...',
		text: '������....'
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
			$.messager.alert("��ʾ", ret.msg, 'success');
		} else {
			$.messager.alert("��ʾ", ret.msg, 'error');
		}
	});
}
/**
 * @description �¼�����
 */
function listenEvent() {
	$('#btnTest').bind('click', testFtp);
}