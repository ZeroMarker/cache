// ��ҽԺ��ʼ��Ժ�б���ĳЩ������JS
function InitSelectLoad() {
	if ($.LOGON.HOSPDESC=="�׶�ҽ�ƴ�ѧ������������ҽԺ"){
		if ($.form.GetValue("cboMedUsePurpose")==""){
			$.form.SetValue("cboMedUsePurpose","","������ҩ");
		}
		if ($.form.GetValue("cboMedPurpose")==""){
			$.form.SetValue("cboMedPurpose","","����");
		}
	}
}