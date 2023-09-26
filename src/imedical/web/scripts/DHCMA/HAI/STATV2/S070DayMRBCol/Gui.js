function Inits070daymebcolWin(){
	var obj = new Object();
	$.parser.parse();
	
	//医院
	obj.cboHospital = Common_ComboToSSHosp("cboHospital",$.LOGON.HOSPID);
	// 日期赋初始值
	obj.dtDateFrom = $('#dtDateFrom').datebox('setValue', Common_GetDate(new Date()));    // 日期初始赋值
	obj.dtDateTo = $('#dtDateTo').datebox('setValue', Common_GetDate(new Date()));
	//筛选条件
	obj.cboConditions = Common_ComboDicCode("cboQryCon","StatScreenCondition");
	$('#cboQryCon').combobox('setValue',1);
	$('#cboQryCon').combobox('setText',"显示全部病区(科室)");
	$HUI.radio("#chkStatunit-Ward").setValue(true);
	
	Inits070daymebcolWinEvent(obj);
	obj.LoadEvent(arguments);
	
	return obj;
}
