// 按医院初始化院感报告某些下拉框JS
function InitSelectLoad() {
	if ($.LOGON.HOSPDESC=="首都医科大学附属北京安贞医院"){
		if ($.form.GetValue("cboMedUsePurpose")==""){
			$.form.SetValue("cboMedUsePurpose","","其他用药");
		}
		if ($.form.GetValue("cboMedPurpose")==""){
			$.form.SetValue("cboMedPurpose","","治疗");
		}
	}
}