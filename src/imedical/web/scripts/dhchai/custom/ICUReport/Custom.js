// ��ҽԺ��ʼ��ICU����ĳЩ������JS
function InitSelectLoad() {
	if ($.LOGON.HOSPDESC=="�׶�ҽ�ƴ�ѧ������������ҽԺ"){
		if ($.form.GetValue("cboIRPICCType")==""){
			$.form.SetValue("cboIRPICCType","","����Ⱦ");
		}
		if ($.form.GetValue("cboIRPICCCnt")==""){
			$.form.SetValue("cboIRPICCCnt","","��ǻ");
		}
		if ($.form.GetValue("cboIRPICCPos")==""){
			$.form.SetValue("cboIRPICCPos","","������");
		}
		if ($.form.GetValue("cboIROperDoc")==""){
			$.form.SetValue("cboIROperDoc","","����ʦ");
		}
		if ($.form.GetValue("cboIROperLoc")==""){
			$.form.SetValue("cboIROperLoc","","������");
		}
		if ($.form.GetValue("cboIRVAPType")==""){
			$.form.SetValue("cboIRVAPType","","���ڲ��");
		}
		if ($.form.GetValue("cboIROperDocV")==""){
			$.form.SetValue("cboIROperDocV","","����ʦ");
		}
		if ($.form.GetValue("cboIROperLocV")==""){
			$.form.SetValue("cboIROperLocV","","������");
		}
		if ($.form.GetValue("cboIRUCType")==""){
			$.form.SetValue("cboIRUCType","","������");
		}
		if ($.form.GetValue("cboIROperLocU")==""){
			$.form.SetValue("cboIROperLocU","","������");
		}
		if ($.form.GetValue("cboIROperDocU")==""){
			$.form.SetValue("cboIROperDocU","","��ʿ");
		}
	}
}