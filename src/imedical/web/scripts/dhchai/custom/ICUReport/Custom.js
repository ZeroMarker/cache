// 按医院初始化ICU报告某些下拉框JS
function InitSelectLoad() {
	if ($.LOGON.HOSPDESC=="首都医科大学附属北京安贞医院"){
		if ($.form.GetValue("cboIRPICCType")==""){
			$.form.SetValue("cboIRPICCType","","抗感染");
		}
		if ($.form.GetValue("cboIRPICCCnt")==""){
			$.form.SetValue("cboIRPICCCnt","","三腔");
		}
		if ($.form.GetValue("cboIRPICCPos")==""){
			$.form.SetValue("cboIRPICCPos","","颈静脉");
		}
		if ($.form.GetValue("cboIROperDoc")==""){
			$.form.SetValue("cboIROperDoc","","麻醉师");
		}
		if ($.form.GetValue("cboIROperLoc")==""){
			$.form.SetValue("cboIROperLoc","","手术室");
		}
		if ($.form.GetValue("cboIRVAPType")==""){
			$.form.SetValue("cboIRVAPType","","经口插管");
		}
		if ($.form.GetValue("cboIROperDocV")==""){
			$.form.SetValue("cboIROperDocV","","麻醉师");
		}
		if ($.form.GetValue("cboIROperLocV")==""){
			$.form.SetValue("cboIROperLocV","","手术室");
		}
		if ($.form.GetValue("cboIRUCType")==""){
			$.form.SetValue("cboIRUCType","","抗反流");
		}
		if ($.form.GetValue("cboIROperLocU")==""){
			$.form.SetValue("cboIROperLocU","","手术室");
		}
		if ($.form.GetValue("cboIROperDocU")==""){
			$.form.SetValue("cboIROperDocU","","护士");
		}
	}
}