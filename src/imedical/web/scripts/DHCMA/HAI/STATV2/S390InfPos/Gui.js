function InitS390InfPosWin(){
	var obj = new Object();
	$.parser.parse();
	
	//医院
	obj.cboHospital = Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
	// 日期赋初始值
	obj.dtDateFrom = $('#dtDateFrom').datebox('setValue', Common_GetDate(new Date()));    // 日期初始赋值
	obj.dtDateTo = $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));

	$HUI.radio("#chkStatunit-Ward").setValue(true);	
	InitS390InfPosfWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
