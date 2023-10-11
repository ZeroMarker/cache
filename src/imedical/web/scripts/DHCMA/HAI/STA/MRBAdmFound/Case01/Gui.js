//页面Gui
function InitWin(){
	var obj = new Object();
	obj.QryOpption="label01"
	Common_ComboToSSHosp('cboHospital',$.LOGON.HOSPID);
	Common_CreateMonth('DateFrom');
	Common_CreateMonth('DateTo');
	
	$HUI.combobox("#cboHospital",{
		 onSelect:function(rec){//给医院增加Select事件，更新科室列表
			HospIDs=rec.ID;
			Common_ComboToLoc("cboLocation",HospIDs,'','I','E');
		 }
	 })
	
	InitWinEvent(obj);
	return obj;
}
$(InitWin);